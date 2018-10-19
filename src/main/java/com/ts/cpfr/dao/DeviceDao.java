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
    List<ParamData> selectDeviceList();
}
