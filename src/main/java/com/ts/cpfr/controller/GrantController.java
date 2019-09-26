package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname GrantController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping(value = "/grant",method = {RequestMethod.GET,RequestMethod.POST})
@SuppressWarnings({"rawtypes", "unchecked"})
public class GrantController extends WebBaseController {

    @Autowired
    private GrantService mGrantService;

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(HttpServletRequest request) {
        try {
            return mGrantService.addGrant(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/ban")
    public ResultData<ParamData> ban(HttpServletRequest request) {
        try {
            return mGrantService.banGrant(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
