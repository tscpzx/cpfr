package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.AppDao;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;

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
}
