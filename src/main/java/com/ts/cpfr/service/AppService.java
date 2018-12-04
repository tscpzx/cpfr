package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

/**
 * @Classname AppService
 * @Description
 * @Date 2018/11/22 15:24
 * @Created by cjw
 */
public interface AppService {
    boolean addInActDevice(ParamData pd);

    ParamData getDeviceInfo(ParamData pd);

    int getUserWid(ParamData pd);

    List<ParamData> getPersonList(ParamData pd);

    List<ParamData> getGrantList(ParamData pd);

    boolean uploadRecordImage(CommonsMultipartFile file, ParamData pd) throws Exception;

    boolean addRecord(ParamData pd);
}
