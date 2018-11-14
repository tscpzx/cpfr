package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname PersonDao
 * @Description
 * @Date 2018/11/6 10:42
 * @Created by cjw
 */
public interface PersonDao {
    ParamData selectPerson(ParamData pd);

    List<ParamData> selectPersonList(ParamData pd);

    boolean insertPerson(ParamData pd);
}