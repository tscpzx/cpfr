package com.ts.cpfr.service;

import com.github.pagehelper.PageInfo;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

/**
 * @Classname RecordService
 * @Description
 * @Date 2018/12/5 10:39
 * @Created by cjw
 */
public interface RecordService {
    ResultData<PageInfo<ParamData>> getRecordBase64List(ParamData pd);
}
