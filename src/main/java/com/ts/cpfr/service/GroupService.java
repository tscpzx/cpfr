package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname GroupService
 * @Description
 * @Date 2018/11/14 10:17
 * @Created by cjw
 */
public interface GroupService {
    List<ParamData> getGroupList(ParamData pd);

    ParamData queryGroup(ParamData pd);

    boolean addGroup(ParamData pd);

    boolean addGroupPerson(ParamData pd);

    boolean addGroupDevice(ParamData pd);
}
