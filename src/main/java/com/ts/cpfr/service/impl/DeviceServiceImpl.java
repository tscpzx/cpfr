package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.UserDao;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.ParamData;

import org.apache.http.util.TextUtils;
import org.springframework.stereotype.Service;

import java.util.List;

import javax.annotation.Resource;

/**
 * @Classname DeviceServiceImpl
 * @Description
 * @Date 2018/10/19 11:22
 * @Created by cjw
 */
@Service
public class DeviceServiceImpl implements DeviceService {
    @Resource
    private DeviceDao mDeviceDao;
    @Resource
    private UserDao mUserDao;

    @Override
    public List<ParamData> getDeviceList(ParamData pd) {
        return mDeviceDao.selectDeviceList(pd);
    }

    @Override
    public boolean activateDevice(ParamData pd) {
        return mDeviceDao.updateInActDeviceMacGrantKeyAndStatus(pd);
    }

    @Override
    public ParamData queryInActDevice(ParamData pd) {
        return mDeviceDao.selectInActDevice(pd);
    }

    @Override
    public boolean addInActDevice(ParamData pd) {
        return mDeviceDao.insertInActDevice(pd);
    }

    @Override
    public boolean updateAllDeviceOnline(ParamData pd) {
        boolean b = mDeviceDao.updateInActDeviceOnline(pd);
        String adminId = pd.getString(CommConst.ADMIN_ID);
        if (!TextUtils.isEmpty(adminId)) {
            int wid = mUserDao.selectWidByAdminId(adminId);
            pd.put("wid",wid);
            mDeviceDao.updateDeviceOnline(pd);
        }
        return b;
    }

    @Override
    public List<ParamData> getInActDeviceList(ParamData pd) {
        return mDeviceDao.selectInActDeviceList(pd);
    }

    @Override
    public boolean addDevice(ParamData pd) {
        return mDeviceDao.insertDevice(pd);
    }
}
