package com.ts.cpfr.controller.user;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.ehcache.ThreadToken;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @Classname UserLoginController
 * @Description
 * @Date 2018/10/16 10:55
 * @Created by cjw
 */
@Controller
@RequestMapping("/user")
@SuppressWarnings({"rawtypes", "unchecked"})
public class UserController extends BaseController {
    @Autowired
    private UserService mUserService;
    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/login")
    public ResultData<ParamData> login(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            LoginUser user = mUserService.queryUserByName(pd);
            if (user != null) {
                ////todo 解密对比
                if (user.getPassword().equals(pd.getString("password"))) {
                    memory.saveLoginUser(user);

                    HttpSession session = request.getSession();
                    session.setMaxInactiveInterval(SystemConfig.SESSION_TIME_LIVE_MAX);
                    session.setAttribute("user",user);

                    //存入cookie中
                    Cookie cookie = new Cookie(CommConst.ACCESS_CPFR_TOKEN, ThreadToken.getToken());
                    cookie.setMaxAge(SystemConfig.COOKIE_LIVE_TIME);
                    cookie.setPath(request.getContextPath() + "/");
                    //写回浏览器
                    response.addCookie(cookie);

                    ParamData paramData = new ParamData();
                    paramData.put("admin_id", user.getAdminId());
                    paramData.put("token", user.getToken());

                    mUserService.updateUserLoginTime(paramData);

                    return new ResultData<>(HandleEnum.SUCCESS, paramData);
                } else {
                    return new ResultData<>(HandleEnum.PASSWORD_ERROR_104);
                }
            } else return new ResultData<>(HandleEnum.ADMIN_NOT_EXIST_103);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/register")
    public ResultData<ParamData> register(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            LoginUser user = mUserService.queryUserByName(pd);
            if (user == null) {
                boolean result = mUserService.addAdminUser(pd);
                if (result) {
                    //注册成功，建立对应仓库
                    mUserService.createTableWarehouse();
                    return new ResultData<>(HandleEnum.SUCCESS);
                } else return new ResultData<>(HandleEnum.FAIL);
            } else return new ResultData<>(HandleEnum.ADMIN_EXISTED_100);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/logout")
    public ResultData<ParamData> logout(HttpServletRequest request) {
        try {
            memory.clearLoginUser();
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
}
