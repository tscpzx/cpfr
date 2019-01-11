package com.ts.cpfr.service;

import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.io.IOException;

/**
 * @Classname DeviceService
 * @Description
 * @Date 2018/10/19 11:20
 * @Created by cjw
 */
public interface DeviceService {
    ResultData<PageData<ParamData>> getDeviceList(ParamData pd);

    ResultData<PageData<ParamData>> getInActDeviceList(ParamData pd);

    ResultData<ParamData> activateDevice(ParamData pd) throws Exception;

    void updateDeviceOnline(ParamData pd);

    ParamData queryInActDevice(ParamData pd);

    ParamData queryDevice(ParamData pd);

    ResultData<PageData<ParamData>> getGrantPersonList(ParamData pd);

    ResultData<ParamData> changeDeviceInfo(ParamData pd) throws IOException;

    ResultData<PageData<ParamData>> getAccessDeviceList(ParamData pd);
}
