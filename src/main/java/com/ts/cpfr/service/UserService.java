package com.ts.cpfr.service;

import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.utils.ParamData;

/**
 * @Classname UserService
 * @Description
 * @Date 2018/10/16 11:03
 * @Created by cjw
 */
public interface UserService {
    LoginUser loginUser(ParamData pd);
}
