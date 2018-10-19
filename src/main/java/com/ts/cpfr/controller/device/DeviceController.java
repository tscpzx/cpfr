package com.ts.cpfr.controller.device;

import com.alibaba.fastjson.JSONObject;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.HttpUtil;
import com.ts.cpfr.utils.MD5Util;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname DeviceController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping("/device")
@SuppressWarnings({"rawtypes", "unchecked"})
public class DeviceController extends BaseController {

    @Autowired
    DeviceService mDeviceService;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<JSONObject> login(HttpServletRequest request, HttpServletResponse response) {
        try {
            String path = SystemConfig.SYD_DEVICE_LIST;
            String body = "";
            String checksum = MD5Util.md5(path + body + SystemConfig.SYD_CHECKSUM_KEY);
            JSONObject jsonObject = HttpUtil.doGet(SystemConfig.SYD_BASE_URL + SystemConfig.SYD_DEVICE_LIST + "?checksum=" + checksum);
            mDeviceService.getDeviceList();
            return new ResultData<JSONObject>(HandleEnum.SUCCESS, jsonObject);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<JSONObject>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
