package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.util.List;

import javax.annotation.Resource;

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

    @Override
    public List<ParamData> getPersonList(ParamData pd) {
        return mPersonDao.selectPersonList(pd);
    }

    @Override
    public boolean uploadImage(CommonsMultipartFile file, ParamData pd) {
        BufferedOutputStream fos = null;
        try {
            String realPath = CommConst.UPLOAD_IMAGE;
            CommUtil.mkdir(realPath);
            String[] suffix = file.getContentType().split("/");
            String fileName = CommUtil.get32UUID() + "." + suffix[1];
            String filePath = realPath + fileName;

            fos = new BufferedOutputStream(new FileOutputStream(filePath));
            fos.write(file.getBytes());
            fos.flush();

            //判断文件是否上传成功
            File file1 = new File(filePath);
            return file1.exists() && file1.length() == file.getSize();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (fos != null) fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    @Override
    public boolean addPerson(ParamData pd) {
        return mPersonDao.insertPerson(pd);
    }

    @Override
    public ParamData queryPerson(ParamData pd) {
        return mPersonDao.selectPerson(pd);
    }

    @Override
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
}
