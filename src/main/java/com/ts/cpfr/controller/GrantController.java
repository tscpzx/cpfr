package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname GrantController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping("/grant")
@SuppressWarnings({"rawtypes", "unchecked"})
public class GrantController extends BaseController {

    @Autowired
    private GrantService mGrantService;

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<List<ParamData>> add(HttpServletRequest request) {
        try {
            return mGrantService.addGrants(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

}
