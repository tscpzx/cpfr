package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname DeviceService
 * @Description
 * @Date 2018/10/19 11:20
 * @Created by cjw
 */
public interface DeviceService {
    List<ParamData> getDeviceList(ParamData pd);

    boolean activateDevice(ParamData pd);

    ParamData queryInActDevice(ParamData pd);

    boolean addInActDevice(ParamData pd);

    boolean updateInActDeviceOnline(ParamData pd);

    List<ParamData> getInActDeviceList(ParamData pd);
}
