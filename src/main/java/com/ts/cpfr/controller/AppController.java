package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.AppBaseController;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    public ResultData<ParamData> uploadRecord(HttpServletRequest request) {
        try {
            return mAppService.addRecord(paramDataInit());
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
    public ResultData<ParamData> addPerson(HttpServletRequest request) {
        try {
            return mAppService.addPersonWithGrant(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/compare_downl_num")
    public ResultData<List<ParamData>> compareDownlNum(HttpServletRequest request) {
        try {
            return mAppService.comparePersonDownlNum(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/last_version_info")
    public ResultData<ParamData> lastVersionInfo(HttpServletRequest request) {
        try {
            return mAppService.getLastVersionInfo(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/downl_apk")
    public ResultData<ParamData> downlOnlineApk(HttpServletRequest request, HttpServletResponse response) {
        try {
            mAppService.downloadApk(paramDataInit(), request, response);
            return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/person_list2")
    public ResultData<List<ParamData>> personList2(HttpServletRequest request, HttpServletResponse response) {
        try {
            return mAppService.getPersonList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/downl_image")
    public ResultData<ParamData> downlImage(HttpServletRequest request, HttpServletResponse response) {
        try {
            mAppService.downloadImage(paramDataInit(), response);
            return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
