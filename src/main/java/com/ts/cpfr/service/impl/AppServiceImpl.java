package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.AppDao;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SystemConfig;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
    @Autowired
    private AppMemory memory;

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
        ParamData paramData = mAppDao.selectDevice(pd);
        return new ResultData<>(HandleEnum.SUCCESS, paramData);
    }

    @Override
    public ResultData<List<ParamData>> getPersonBase64List(ParamData pd) {
        List<ParamData> list = mAppDao.selectPersonListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Override
    public ResultData<List<ParamData>> getGrantList(ParamData pd) {
        List<ParamData> list = mAppDao.selectGrantList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Override
    public ResultData<ParamData> addRecord(CommonsMultipartFile file, HttpServletRequest request) {
        if (file.getSize() / 1024 > 65) return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");
        ParamData pd = new ParamData();
        pd.put(CommConst.DEVICE_SN, memory.getCache(getTokenFromRequest(request)).getDeviceSn());
        pd.put(CommConst.ADMIN_ID, memory.getCache(getTokenFromRequest(request)).getAdminId());
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

    @Override
    public ResultData<ParamData> getCurrentDate() {
        return new ResultData<>(HandleEnum.SUCCESS, mAppDao.selectNow());
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String token = request.getHeader(CommConst.ACCESS_APP_TOKEN);
        if (StringUtils.isEmpty(token)) {
            // 从请求信息中获取token值
            token = request.getParameter(CommConst.ACCESS_APP_TOKEN);
        }

        return token;
    }
}
