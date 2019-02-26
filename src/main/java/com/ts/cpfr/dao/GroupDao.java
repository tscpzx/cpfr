package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname GroupDao
 * @Description
 * @Date 2018/11/14 10:17
 * @Created by cjw
 */
public interface GroupDao {
    List<ParamData> selectGroupList(ParamData pd);

    ParamData selectGroup(ParamData pd);

    boolean insertGroup(ParamData pd);

    boolean updateGroupInfo(ParamData pd);

    boolean deleteGroup(ParamData pd);

    ParamData selectGroupByGroupName(ParamData pd);
}
