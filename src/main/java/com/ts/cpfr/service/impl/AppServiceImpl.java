package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.AppDao;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

import javax.annotation.Resource;

/**
 * @Classname AppServiceImpl
 * @Description
 * @Date 2018/11/22 15:25
 * @Created by cjw
 */
@Service
public class AppServiceImpl implements AppService {
    @Resource
    private AppDao mAppDao;

    @Override
    public boolean addInActDevice(ParamData pd) {
        return mAppDao.insertInActDevice(pd);
    }

    @Override
    public ParamData getDeviceInfo(ParamData pd) {
        return mAppDao.selectDevice(pd);
    }

    @Override
    public int getUserWid(ParamData pd) {
        return mAppDao.selectUserWid(pd);
    }

    @Override
    public List<ParamData> getPersonList(ParamData pd) {
        return mAppDao.selectPersonList(pd);
    }

    @Override
    public List<ParamData> getGrantList(ParamData pd) {
        return mAppDao.selectGrantList(pd);
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
    public boolean addRecord(ParamData pd) {
        return mAppDao.insertRecord(pd);
    }
}
