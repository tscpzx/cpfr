package com.ts.cpfr.controller;

import com.alibaba.fastjson.JSON;
import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.DeviceService;
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
 * @Classname DeviceController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping("/device")
@SuppressWarnings({"rawtypes", "unchecked"})
public class DeviceController extends WebBaseController {

    @Autowired
    private DeviceService mDeviceService;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<PageData<ParamData>> list(HttpServletRequest request) {
        try {
            return mDeviceService.getDeviceList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/inact_list")
    public ResultData<PageData<ParamData>> inactList(HttpServletRequest request) {
        try {
            return mDeviceService.getInActDeviceList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/activate")
    public ResultData<ParamData> activate(HttpServletRequest request) {
        try {
            return mDeviceService.activateDevice(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/inact_detail")
    public String inactDetail(Model model) {
        try {
            ParamData paramData = mDeviceService.queryInActDevice(paramDataInit());
            model.addAttribute(CommConst.DATA, paramData);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "device/device_inact_detail";
    }

    @RequestMapping("/detail")
    public String detail(Model model) {
        try {
            ParamData data = mDeviceService.queryDevice(paramDataInit());
            model.addAttribute(CommConst.DATA, JSON.toJSONString(data));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "device/device_detail";
    }

    @ResponseBody
    @RequestMapping("/grant_person_list")
    public ResultData<PageData<ParamData>> personList(HttpServletRequest request) {
        try {
            return mDeviceService.getGrantPersonList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/change_info")
    public ResultData<ParamData> changeInfo(HttpServletRequest request) {
        try {
            return mDeviceService.changeDeviceInfo(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/delete")
    public ResultData<ParamData> delete(HttpServletRequest request) {
        try {
            return mDeviceService.deleteDevice(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
