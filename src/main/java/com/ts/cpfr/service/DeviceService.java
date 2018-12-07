package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.util.List;

/**
 * @Classname DeviceService
 * @Description
 * @Date 2018/10/19 11:20
 * @Created by cjw
 */
public interface DeviceService {
    ResultData<List<ParamData>> getDeviceList(ParamData pd);

    ResultData<List<ParamData>> getInActDeviceList(ParamData pd);

    ResultData<ParamData> activateDevice(ParamData pd) throws Exception;

    void updateDeviceOnline(ParamData pd);

    ParamData queryInActDevice(ParamData pd);

    ParamData queryDevice(ParamData pd);
}
