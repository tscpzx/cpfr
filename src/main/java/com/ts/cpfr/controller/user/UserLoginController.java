package com.ts.cpfr.controller.user;

import com.alibaba.fastjson.JSONObject;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.HttpUtil;
import com.ts.cpfr.utils.MD5Util;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname UserLoginController
 * @Description
 * @Date 2018/10/16 10:55
 * @Created by cjw
 */
@Controller
@RequestMapping("/user")
@SuppressWarnings({"rawtypes", "unchecked"})
public class UserLoginController extends BaseController {
    @Autowired
    private UserService mUserService;

    @ResponseBody
    @RequestMapping("/login")
    public ResultData<JSONObject> login(HttpServletRequest request) {
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

                String path = CommConst.SYD_USER_LOGIN;
                String body = "name=" + name + "&password=" + password;
                String checksum = MD5Util.md5(path + body + CommConst.SYD_CHECKSUM_KEY);
                JSONObject jsonObject = HttpUtil.doPost(CommConst.SYD_BASE_URL + CommConst.SYD_USER_LOGIN + "?checksum=" + checksum, pd);
                ResultData<JSONObject> resultData = JSONObject.toJavaObject(jsonObject, ResultData.class);
                if (0 == resultData.getCode()) {//登录实义德成功
                    ////todo
                    return resultData;
                } else {
                    return new ResultData<JSONObject>(HandleEnum.FAIL, "syd操作异常");
                }
            } else return new ResultData<JSONObject>(HandleEnum.FAIL, "登录失败，账号或者密码有误");

        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<JSONObject>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
