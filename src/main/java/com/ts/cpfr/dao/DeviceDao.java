package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

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

    boolean updateInActDeviceOnline(ParamData pd);

    boolean updateDeviceOnline(ParamData pd);

    List<ParamData> selectInActDeviceList(ParamData pd);

    boolean insertDevice(ParamData pd);

    ParamData selectDevice(ParamData pd);

    boolean updateDeviceGroupID(ParamData pd);
}
