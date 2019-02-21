package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.*;

import com.ts.cpfr.websocket.SocketMessageHandle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.socket.TextMessage;

import java.io.*;
import java.sql.Blob;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

/**
 * @Classname PersonServiceImpl
 * @Description
 * @Date 2018/11/6 10:45
 * @Created by cjw
 */
@Service
@Transactional
public class PersonServiceImpl implements PersonService {
    @Resource
    private DeviceDao mDeviceDao;
    @Resource
    private PersonDao mPersonDao;
    @Autowired
    private WebMemory memory;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Override
    public ResultData<PageData<ParamData>> getPersonList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectPersonList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Override
    public ResultData<PageData<ParamData>> getPersonBase64List(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectPersonListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Override
    public ResultData<ParamData> addPerson(CommonsMultipartFile file, HttpServletRequest request) {
        if (file.getSize() / 1024 > 65) return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");
        ParamData pd = new ParamData();
        pd.put("person_name", request.getParameter("person_name"));
        pd.put("emp_number", request.getParameter("emp_number"));
        pd.put("blob_image", file.getBytes());
        pd.put("wid", memory.getCache(CommUtil.getTokenFromRequest(request)).getWid());
        if (mPersonDao.insertPerson(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> updatePerson(CommonsMultipartFile file, HttpServletRequest request) throws IOException {
        ParamData pd = new ParamData();
        pd.put("person_id", request.getParameter("person_id"));
        pd.put("person_name", request.getParameter("person_name"));
        pd.put("emp_number", request.getParameter("emp_number"));
        pd.put("blob_image", file.getBytes());
        pd.put("wid", memory.getCache(CommUtil.getTokenFromRequest(request)).getWid());
        if (mPersonDao.updatePersonInfo(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> updatePerson(ParamData pd) throws IOException {
        if (mPersonDao.updatePersonInfo(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> deletePerson(ParamData pd) throws IOException {
        if (mPersonDao.deletePerson(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else return new ResultData<>(HandleEnum.FAIL);
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
        ParamData paramData = mPersonDao.selectImage(pd);
        if (paramData != null) {
            pd.put("base_image", paramData.get("blob_image"));
        }
        pd.remove("wid");
    }

    @Override
    public ResultData<PageData<ParamData>> getAccessDeviceList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> deviceList = mDeviceDao.selectAccessDeviceListByPersonId(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(deviceList));
    }

}
