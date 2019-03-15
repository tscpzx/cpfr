package com.ts.cpfr.controller;

import com.alibaba.fastjson.JSON;
import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.AttendService;
import com.ts.cpfr.utils.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Date 2019/3/14
 * @Created by xwr
 */
@Controller
@RequestMapping("/attend")
public class AttendController extends WebBaseController {
    @Autowired
    private AttendService mAttendService;

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(HttpServletRequest request) {
        System.out.println("工作日：" + request.getParameter("work_day"));
        try {
            return mAttendService.addRule(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }


    @ResponseBody
    @RequestMapping("/rule_list")
    public ResultData<PageData<ParamData>> ruleList(HttpServletRequest request) {
        try {
            return mAttendService.getRuleList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/rule_detail")
    public String detail(Model model, HttpServletRequest request) {
        try {
            ParamData paramData = mAttendService.queryAttend(paramDataInit());
            model.addAttribute(CommConst.DATA, JSON.toJSONString(paramData));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "attend/attend_rule_detail";
    }

}
