package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.AttendDao;
import com.ts.cpfr.service.AttendService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @Date 2019/3/14
 * @Created by xwr
 */
@Service
public class AttendServiceImpl implements AttendService {

    @Resource
    private AttendDao mAttendDao;
    @Override
    public ResultData<ParamData> addRule(ParamData pd) {
        if (mAttendDao.insertRule(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        else return new ResultData<>(HandleEnum.FAIL);
    }
}
