package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.AppBaseController;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname AppDeviceController
 * @Description
 * @Date 2018/10/25 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping("/app")
@SuppressWarnings({"rawtypes", "unchecked"})
public class AppController extends AppBaseController {
    @Autowired
    AppService mAppService;

    @ResponseBody
    @RequestMapping("/device_register")
    public ResultData<ParamData> deviceRegister(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mAppService.register(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/device_info")
    public ResultData<ParamData> deviceInfo(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mAppService.getDeviceInfo(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/person_list")
    public ResultData<List<ParamData>> personList(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mAppService.getPersonBase64List(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/grant_list")
    public ResultData<List<ParamData>> grantList(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mAppService.getGrantList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/upload_record")
    public ResultData<ParamData> uploadRecord(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request) {
        try {
            return mAppService.addRecord(file, request);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/current_date")
    public ResultData<ParamData> currentDate(HttpServletRequest request) {
        try {
            return mAppService.getCurrentDate();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/disconnect")
    public ResultData<ParamData> disconnect(HttpServletRequest request) {
        return new ResultData<>(HandleEnum.FAIL, "未与服务器建立连接!");
    }

    @ResponseBody
    @RequestMapping("/add_person")
    public ResultData<ParamData> addPerson(@RequestParam("file") CommonsMultipartFile file,HttpServletRequest request) {
        try {
            return mAppService.addPersonWithGrant(file, request);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
