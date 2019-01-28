package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname UserService
 * @Description
 * @Date 2018/10/16 11:03
 * @Created by cjw
 */
public interface UserService {
    ResultData<ParamData> login(ParamData pd, HttpServletRequest request, HttpServletResponse response);

    ResultData<ParamData> register(ParamData pd);

    void logout();

    ResultData<ParamData> changePassword(ParamData pd);
}
