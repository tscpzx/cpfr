package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

import javax.annotation.PostConstruct;

/**
 * @Classname DeviceService
 * @Description
 * @Date 2018/10/19 11:20
 * @Created by cjw
 */
public interface DeviceService {
    List<ParamData> getDeviceList(ParamData pd);

    boolean activateDevice(ParamData pd);

    ParamData queryInactDevice(ParamData pd);

    boolean addInactDevice(ParamData pd);

    @PostConstruct
    boolean updateInactDeviceOnline(ParamData pd);
}
