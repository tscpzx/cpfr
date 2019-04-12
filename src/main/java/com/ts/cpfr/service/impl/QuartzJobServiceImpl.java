package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.QuartzJobDao;
import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.quartz.QuartzJobManager;
import com.ts.cpfr.service.QuartzJobService;

import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @Classname QuartzJobServiceImpl
 * @Description
 * @Date 2019/4/3 11:42
 * @Created by cjw
 */
@Service
public class QuartzJobServiceImpl implements QuartzJobService {
    @Resource
    private QuartzJobDao mQuartzJobDao;
    @Autowired
    QuartzJobManager mQuartzJobManager;

    @Override
    public List<QuartzJobModel> getAll() {

        return null;
    }

    @Override
    public ResultData<ParamData> runJob(ParamData pd) {
        if (mQuartzJobDao.updateJobStatus(pd)) {
            QuartzJobModel quartzJobModel = mQuartzJobDao.selectJob(pd);
            mQuartzJobManager.addJob(quartzJobModel);
            return new ResultData<>(HandleEnum.SUCCESS, "成功生效");
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }


}
