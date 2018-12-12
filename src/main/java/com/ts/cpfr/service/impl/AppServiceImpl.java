package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.AppDao;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

/**
 * @Classname AppServiceImpl
 * @Description
 * @Date 2018/11/22 15:25
 * @Created by cjw
 */
@Service
@Transactional
public class AppServiceImpl implements AppService {
    @Resource
    private AppDao mAppDao;
    @Resource
    private DeviceDao mDeviceDao;

    @Override
    public ResultData<ParamData> register(ParamData pd) {
        ParamData paramData = mDeviceDao.selectInActDevice(pd);
        if (paramData == null) {
            if (mAppDao.insertInActDevice(pd)) {
                return new ResultData<>(HandleEnum.SUCCESS, "已注册新设备");
            }
        } else return new ResultData<>(HandleEnum.SUCCESS, "设备已注册");
        return new ResultData<>(HandleEnum.FAIL, "设备注册失败，请重新连接");
    }

    @Override
    public ResultData<ParamData> getDeviceInfo(ParamData pd) {
        pd.put("wid", mAppDao.selectUserWid(pd));
        ParamData paramData = mAppDao.selectDevice(pd);
        return new ResultData<>(HandleEnum.SUCCESS, paramData);
    }

    @Override
    public ResultData<List<ParamData>> getPersonBase64List(ParamData pd) {
        pd.put("wid", mAppDao.selectUserWid(pd));
        List<ParamData> list = mAppDao.selectPersonListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Override
    public ResultData<List<ParamData>> getGrantList(ParamData pd) {
        pd.put("wid", mAppDao.selectUserWid(pd));
        List<ParamData> list = mAppDao.selectGrantList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Override
    public ResultData<ParamData> addRecord(CommonsMultipartFile file, HttpServletRequest request) {
        if (file.getSize() / 1024 > 65) return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        ParamData pd = new ParamData();
        pd.put("device_sn", request.getParameter("device_sn"));
        pd.put("admin_id", request.getParameter("admin_id"));
        pd.put("person_id", request.getParameter("person_id"));
        pd.put("recog_type", request.getParameter("recog_type"));
        pd.put("record_image", file.getBytes());
        pd.put("wid", mAppDao.selectUserWid(pd));
        if (mAppDao.insertRecord(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public boolean uploadRecordImage(CommonsMultipartFile file, ParamData pd) throws Exception {
        BufferedOutputStream fos = null;
        try {
            String realPath = SystemConfig.UPLOAD_RECORD_IMAGE_DIR;
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
}
