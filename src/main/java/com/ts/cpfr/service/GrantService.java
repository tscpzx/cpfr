package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

/**
 * @Classname GrantDao
 * @Description
 * @Date 2018/11/15 17:25
 * @Created by cjw
 */
public interface GrantService {
    ResultData<ParamData> addGrant(ParamData pd) throws Exception;

    ResultData<ParamData> banGrant(ParamData pd) throws Exception;
}
