package com.ts.cpfr.service;

import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.util.List;

/**
 * @Classname RecordService
 * @Description
 * @Date 2018/12/5 10:39
 * @Created by cjw
 */
public interface RecordService {
    ResultData<PageData<ParamData>> getRecordBase64List(ParamData pd);
    ResultData<ParamData> deleteRecord(ParamData pd);
}
