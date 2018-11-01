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

    ParamData selectInActDevice(ParamData pd);

    boolean insertInActDevice(ParamData pd);

    boolean updateInActDeviceMacGrantKeyAndStatus(ParamData pd);

    @PostConstruct
    boolean updateInActDeviceOnline(ParamData pd);

    List<ParamData> selectInActDeviceList(ParamData pd);

    boolean insertDevice(ParamData pd);
}
