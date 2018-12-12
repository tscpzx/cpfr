package com.ts.cpfr.controller;

import com.alibaba.fastjson.JSON;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname PersonController
 * @Description
 * @Date 2018/11/6 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping("/person")
public class PersonController extends BaseController {

    @Autowired
    private PersonService mPersonService;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<PageData<ParamData>> list(HttpServletRequest request) {
        try {
            return mPersonService.getPersonList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/list_base64")
    public ResultData<PageData<ParamData>> listBase64(HttpServletRequest request) {
        try {
            return mPersonService.getPersonBase64List(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request) {
        try {
            return mPersonService.addPerson(file, request);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/detail")
    public String detail(Model model, HttpServletRequest request) {
        try {
            ParamData paramData = mPersonService.queryPerson(paramDataInit());
            model.addAttribute(CommConst.DATA, JSON.toJSONString(paramData));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "person/person_detail";
    }

    @ResponseBody
    @RequestMapping("/image")
    public ResultData<ParamData> image(HttpServletRequest request, HttpServletResponse response) {
        try {
            mPersonService.loadImageFile(paramDataInit(), response);
            return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
