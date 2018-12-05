package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname RecordService
 * @Description
 * @Date 2018/12/5 10:39
 * @Created by cjw
 */
public interface RecordService {
    List<ParamData> getRecordBase64List(ParamData pd);
}
