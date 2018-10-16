package com.ts.cpfr.controller.user;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.HandleEnum;
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
public class UserLoginController extends BaseController{
    @Autowired
    private UserService mUserService;

    @ResponseBody
    @RequestMapping("/login")
    public ResultData<ParamData> login(HttpServletRequest request){
        try {



            LoginUser user = mUserService.getUser(paramDataInit());
            if(user!=null){
                return new ResultData<ParamData>(HandleEnum.SUCCESS);
            }
            return new ResultData<ParamData>(HandleEnum.FAIL,"登陆失败");
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<ParamData>(HandleEnum.FAIL);
        }
    }
}
