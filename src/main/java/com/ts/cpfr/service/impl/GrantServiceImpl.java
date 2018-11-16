package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.GrantDao;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @Classname GrantService
 * @Description
 * @Date 2018/11/15 17:26
 * @Created by cjw
 */
@Service
public class GrantServiceImpl implements GrantService{

    @Resource
    private GrantDao mGrantDao;

    @Override
    public boolean addGrants(ParamData pd) {
        return mGrantDao.insertGrants(pd);
    }
}
