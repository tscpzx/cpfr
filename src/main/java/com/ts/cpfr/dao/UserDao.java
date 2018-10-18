package com.ts.cpfr.dao;

import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.utils.ParamData;

/**
 * @Classname UserDao
 * @Description
 * @Date 2018/10/16 14:50
 * @Created by cjw
 */
public interface UserDao {
    LoginUser selectUser(ParamData pd);

    LoginUser selectSydUser(ParamData pd);
}
