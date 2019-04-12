package com.ts.cpfr.service;

import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.util.List;

/**
 * @Classname QuartzJobService
 * @Description
 * @Date 2019/4/3 11:40
 * @Created by cjw
 */
public interface QuartzJobService {
    List<QuartzJobModel> getAll();

    ResultData<ParamData> runJob(ParamData pd);


}
