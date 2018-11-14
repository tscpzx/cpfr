package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.service.GroupService;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;

import java.util.List;

import javax.annotation.Resource;

/**
 * @Classname GroupServiceImpl
 * @Description
 * @Date 2018/11/14 10:20
 * @Created by cjw
 */
@Service
public class GroupServiceImpl implements GroupService {
    @Resource
    private GroupDao mGroupDao;

    @Override
    public List<ParamData> getGroupList(ParamData pd) {
        return mGroupDao.selectGroupList(pd);
    }
}
