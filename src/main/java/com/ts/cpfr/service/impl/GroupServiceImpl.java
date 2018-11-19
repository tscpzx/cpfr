package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.dao.PersonDao;
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
    @Resource
    private PersonDao mPersonDao;
    @Resource
    private DeviceDao mDeviceDao;

    @Override
    public List<ParamData> getGroupList(ParamData pd) {
        return mGroupDao.selectGroupList(pd);
    }

    @Override
    public ParamData queryGroup(ParamData pd) {
        return mGroupDao.selectGroup(pd);
    }

    @Override
    public boolean addGroup(ParamData pd) {
        return mGroupDao.insertGroup(pd);
    }

    @Override
    public boolean addGroupPerson(ParamData pd) {
        return mPersonDao.updatePersonGroupID(pd);
    }

    @Override
    public boolean addGroupDevice(ParamData pd) {
        return mDeviceDao.updateDeviceGroupID(pd);
    }
}
