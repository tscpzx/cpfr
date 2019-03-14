package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.AttendService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
        System.out.println("工作日："+request.getParameter("work_day"));
        try {
            return mAttendService.addRule(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

}
