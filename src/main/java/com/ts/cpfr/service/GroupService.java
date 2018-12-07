package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import java.util.List;

/**
 * @Classname GroupService
 * @Description
 * @Date 2018/11/14 10:17
 * @Created by cjw
 */
public interface GroupService {
    ResultData<List<ParamData>> getGroupList(ParamData pd);

    ParamData queryGroup(ParamData pd);

    ResultData<ParamData> addGroup(ParamData pd);

    ResultData<ParamData> addGroupPerson(ParamData pd);

    ResultData<ParamData> addGroupDevice(ParamData pd);
}
