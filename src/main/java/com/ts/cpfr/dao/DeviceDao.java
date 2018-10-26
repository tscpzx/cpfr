package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

import javax.annotation.PostConstruct;

/**
 * @Classname DeviceDao
 * @Description
 * @Date 2018/10/19 11:23
 * @Created by cjw
 */
public interface DeviceDao {
    List<ParamData> selectDeviceList(ParamData pd);

    ParamData selectInactDevice(ParamData pd);

    boolean insertInactDevice(ParamData pd);

    boolean updateInactDeviceMacGrantKeyAndStatus(ParamData pd);

    @PostConstruct
    boolean updateInactDeviceOnline(ParamData pd);
}
