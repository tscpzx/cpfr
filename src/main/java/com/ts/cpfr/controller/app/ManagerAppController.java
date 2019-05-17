package com.ts.cpfr.controller.app;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.ManagerAppService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname ConfigController
 * @Description
 * @Date 2018/11/6 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping("/manager")
public class ManagerAppController extends WebBaseController {

    @Autowired
    ManagerAppService mManagerAppService;

    @ResponseBody
    @RequestMapping("/add_person")
    public ResultData<ParamData> addPerson(HttpServletRequest request) {
        try {
            return mManagerAppService.addPersonWithGrant(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
