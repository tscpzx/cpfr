package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

/**
 * @Classname ConfigAppService
 * @Description
 * @Date 2019/5/16 16:09
 * @Created by cjw
 */
public interface ConfigAppService {
    ResultData<ParamData> addPersonWithGrant(ParamData pd) throws Exception;
}
