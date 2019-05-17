package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

/**
 * @Classname ManagerAppService
 * @Description
 * @Date 2019/5/16 16:09
 * @Created by cjw
 */
public interface ManagerAppService {
    ResultData<ParamData> addPersonWithGrant(ParamData pd) throws Exception;
}
