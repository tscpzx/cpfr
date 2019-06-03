package com.ts.cpfr.dao;

import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname UserDao
 * @Description
 * @Date 2018/10/16 14:50
 * @Created by cjw
 */
public interface UserDao {
    LoginUser selectUserByName(ParamData pd);

    boolean insertAdminUser(ParamData pd);

    int selectWidByAdminId(String adminId);

    void updateUserLoginTime(ParamData pd);

    boolean updateUserPassword(ParamData pd);

    List<ParamData> selectWidList();
}
