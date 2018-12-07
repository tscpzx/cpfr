package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.util.List;

/**
 * @Classname GrantDao
 * @Description
 * @Date 2018/11/15 17:25
 * @Created by cjw
 */
public interface GrantService {
    ResultData<List<ParamData>> addGrants(ParamData pd);
}
