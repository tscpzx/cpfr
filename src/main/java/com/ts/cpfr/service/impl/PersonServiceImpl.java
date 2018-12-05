package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname PersonServiceImpl
 * @Description
 * @Date 2018/11/6 10:45
 * @Created by cjw
 */
@Service
public class PersonServiceImpl implements PersonService {

    @Resource
    private PersonDao mPersonDao;
    @Autowired
    private Memory memory;

    @Override
    public List<ParamData> getPersonList(ParamData pd) {
        return mPersonDao.selectPersonList(pd);
    }


    @Override
    public boolean addPerson(ParamData pd) {
        return mPersonDao.insertImage(pd) && mPersonDao.insertPerson(pd);
    }

    @Override
    public ParamData queryPerson(ParamData pd) {
        return mPersonDao.selectPerson(pd);
    }

    public byte[] blobToByte(Blob blob) throws Exception {
        InputStream is = blob.getBinaryStream();
        byte[] bs = new byte[1024 * 10];
        int len = -1;
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        while ((len = is.read(bs)) != -1) {
            os.write(bs, 0, len);
        }
        byte[] bytes = os.toByteArray();
        os.close();
        is.close();
        return bytes;
    }

    @Override
    public boolean uploadImageFile(CommonsMultipartFile file, ParamData pd) throws Exception {
        BufferedOutputStream fos = null;
        try {
            String realPath = SystemConfig.UPLOAD_IMAGE_DIR;
            CommUtil.mkdir(realPath);
            String[] suffix = file.getContentType().split("/");
            String fileName = CommUtil.get32UUID() + "." + suffix[1];
            String filePath = realPath + fileName;

            fos = new BufferedOutputStream(new FileOutputStream(filePath));
            fos.write(file.getBytes());
            fos.flush();

            //判断文件是否上传成功
            File file1 = new File(filePath);
            if (file1.exists() && file1.length() == file.getSize()) {
                pd.put("image_path", filePath);
                return true;
            }
        } finally {
            if (fos != null) fos.close();
        }
        return false;
    }

    @Override
    public void loadImageFile(ParamData pd, HttpServletResponse response) throws Exception {
        BufferedInputStream bis = null;
        BufferedOutputStream fos = null;
        try {
            File file = new File(pd.getString("image_path"));
            if (file.exists()) {
                bis = new BufferedInputStream(new FileInputStream(file));
                fos = new BufferedOutputStream(response.getOutputStream());

                response.setHeader("Cache-Control", "no-cache,must-revalidate");//告诉浏览器当前页面不进行缓存，每次访问的时间必须从服务器上读取最新的数据
                response.setContentLength(bis.available());

                byte[] buffer = new byte[1024 << 2];
                int length;
                while ((length = bis.read(buffer)) > 0) {
                    fos.write(buffer, 0, length);
                }
                fos.flush();
            }

        } finally {
            if (bis != null) bis.close();
            if (fos != null) fos.close();
        }
    }

    @Override
    public void file2base64(List<ParamData> list) throws Exception {
        for (ParamData pd : list) {
            file2base64(pd);
        }
    }

    @Override
    public void file2base64(ParamData pd) throws Exception {
        File file = new File(pd.getString("image_path"));
        if (file.exists()) {
            FileInputStream fis = new FileInputStream(file);
            byte[] bytes = new byte[fis.available()];
            fis.read(bytes);
            pd.put("base_image", bytes);
        }
        pd.remove("image_path");
    }

    @Override
    public void blob2base64(List<ParamData> list) throws Exception {
        for (ParamData pd : list) {
            blob2base64(pd);
        }
    }

    @Override
    public void blob2base64(ParamData pd) throws Exception {
        pd.put("wid", memory.getLoginUser().getWId());
        ParamData paramData = mPersonDao.selectImage(pd);
        if (paramData != null) {
            pd.put("base_image", paramData.get("blob_image"));
        }
        pd.remove("wid");
    }

    @Override
    public List<ParamData> getPersonBase64List(ParamData pd) {
        return mPersonDao.selectPersonListWithBlob(pd);
    }
}
