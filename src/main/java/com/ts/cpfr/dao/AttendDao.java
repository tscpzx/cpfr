package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Date 2019/3/14
 * @Created by xwr
 */
public interface AttendDao {
    boolean insertRule(ParamData pd);

    List<ParamData> selectRuleList(ParamData pd);

    ParamData selectAttend(ParamData pd);

}
