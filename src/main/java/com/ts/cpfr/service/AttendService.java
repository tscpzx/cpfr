package com.ts.cpfr.service;

import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

/**
 * @Date 2019/3/14
 * @Created by xwr
 */
public interface AttendService {
    ResultData<ParamData> addRule(ParamData pd);

    ResultData<PageData<ParamData>> getRuleList(ParamData pd);

    ParamData queryAttend(ParamData pd);
    ResultData<ParamData> deleteRule(ParamData pd);
}
