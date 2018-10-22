package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.ParamData;

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

    @Override
    public List<ParamData> getDeviceList(ParamData pd) {
        return mDeviceDao.selectDeviceList(pd);
    }
}
