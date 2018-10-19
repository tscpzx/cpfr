package com.ts.cpfr.controller.user;

import com.alibaba.fastjson.JSONObject;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.ehcache.ThreadToken;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.HttpUtil;
import com.ts.cpfr.utils.MD5Util;
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
            LoginUser cpUser = mUserService.queryUser(pd);
            if (cpUser != null) {
                LoginUser sydUser = mUserService.querySydUser(pd);
                String name = sydUser.getName();
                String password = sydUser.getPassword();
                String md5Password = MD5Util.md5(password);
                String sub = md5Password.substring(0, 18);
                password = MD5Util.md5(sub + "SYD_ACS");

                pd.put("name", name);
                pd.put("password", password);

                String path = SystemConfig.SYD_USER_LOGIN;
                String body = "name=" + name + "&password=" + password;
                String checksum = MD5Util.md5(path + body + SystemConfig.SYD_CHECKSUM_KEY);
                JSONObject jsonObject = HttpUtil.doPost(SystemConfig.SYD_BASE_URL + SystemConfig.SYD_USER_LOGIN + "?checksum=" + checksum, pd);
                ResultData<JSONObject> sydJson = JSONObject.toJavaObject(jsonObject, ResultData.class);
                if (0 == sydJson.getCode()) {//登录实义德成功
                    String sydToken = sydJson.getData().getString(CommConst.TOKEN);
                    memory.saveLoginUser(cpUser, sydToken);

                    //存入cookie中
                    Cookie cpCookie = new Cookie(CommConst.TOKEN, ThreadToken.getToken());
                    Cookie sydCookie = new Cookie(CommConst.ACS_ADMIN_COOKIE, sydToken);
                    cpCookie.setMaxAge(SystemConfig.COOKIE_LIVE_TIME_1);
                    sydCookie.setMaxAge(SystemConfig.COOKIE_LIVE_TIME_1);
                    cpCookie.setPath(request.getContextPath() + "/");
                    sydCookie.setPath(request.getContextPath() + "/");
                    //写回浏览器
                    response.addCookie(cpCookie);
                    response.addCookie(sydCookie);

                    ParamData paramData = new ParamData();
                    paramData.put("user_id", cpUser.getId());
                    paramData.put("token", cpUser.getToken());

                    return new ResultData<ParamData>(HandleEnum.SUCCESS, paramData);
                } else {
                    return new ResultData<ParamData>(HandleEnum.FAIL, "syd操作异常");
                }
            } else return new ResultData<ParamData>(HandleEnum.FAIL, "登录失败，账号或者密码有误");

        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<ParamData>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
