package com.ts.cpfr.dao;

import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname QuartzJobDao
 * @Description
 * @Date 2019/4/3 13:13
 * @Created by cjw
 */
public interface QuartzJobDao {
    boolean insertJob(ParamData pd);
    boolean updateJobStatus(ParamData pd);
    QuartzJobModel selectJob(ParamData pd);
    boolean deleteJob(ParamData pd);
    boolean insertPunch(ParamData pd);
}
