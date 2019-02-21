package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname UserLoginController
 * @Description
 * @Date 2018/10/16 10:55
 * @Created by cjw
 */
@Controller
@RequestMapping("/user")
@SuppressWarnings({"rawtypes", "unchecked"})
public class UserController extends WebBaseController {
    @Autowired
    private UserService mUserService;

    @ResponseBody
    @RequestMapping("/login")
    public ResultData<ParamData> login(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mUserService.login(paramDataInit(), request, response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/register")
    public ResultData<ParamData> register(HttpServletRequest request) {
        try {
            return mUserService.register(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/logout")
    public ResultData<ParamData> logout(HttpServletRequest request, HttpServletResponse response) {
        try {
            mUserService.logout(request, response, paramDataInit());
            return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/nologin")
    public ResultData<ParamData> noLogin(HttpServletRequest request) {
        try {
            return new ResultData<>(HandleEnum.SESSION_ERROR_102);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/change_password")
    public ResultData<ParamData> changePassword(HttpServletRequest request) {
        try {
            return mUserService.changePassword(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
