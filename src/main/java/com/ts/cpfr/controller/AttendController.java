package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.AttendService;
import com.ts.cpfr.service.QuartzJobService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

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
    @Autowired
    private QuartzJobService mQuartzJobService;

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(HttpServletRequest request) {
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
            model.addAttribute(CommConst.DATA, paramData.toJsonString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "attend/attend_rule_detail";
    }

    @ResponseBody
    @RequestMapping("/run_job")
    public ResultData<ParamData> runJob(HttpServletRequest request) {
        try {
            return mQuartzJobService.runJob(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/delete")
    public ResultData<ParamData> deleteRule(HttpServletRequest request) {
        try {
            return mAttendService.deleteRule(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/attend_list")
    public ResultData<PageData<ParamData>> attendList(HttpServletRequest request) {
        try {
            return mAttendService.getAttendList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
