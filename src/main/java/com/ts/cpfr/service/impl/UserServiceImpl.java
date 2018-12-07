package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.dao.UserDao;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @Classname UserServiceImpl
 * @Description
 * @Date 2018/10/16 14:50
 * @Created by cjw
 */
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao mUserDao;
    @Resource
    private TableDao mTableDao;

    @Override
    public LoginUser queryUserByName(ParamData pd) {
        return mUserDao.selectUserByName(pd);
    }

    @Override
    public boolean addAdminUser(ParamData pd) {
        return mUserDao.insertAdminUser(pd);
    }

    @Override
    public void createTableWarehouse() {
        int wid = mTableDao.selectLastInsertID();
        mTableDao.createTableWarehouse(wid);
    }

    @Override
    public void updateUserLoginTime(ParamData pd) {
        mUserDao.updateUserLoginTime(pd);
    }

}
