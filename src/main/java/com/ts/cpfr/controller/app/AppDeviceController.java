package com.ts.cpfr.controller.app;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.service.DeviceService;
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
@RequestMapping("/app/device")
@SuppressWarnings({"rawtypes", "unchecked"})
public class AppDeviceController extends BaseController {
    @Autowired
    DeviceService mDeviceService;

    @ResponseBody
    @RequestMapping("/register")
    public ResultData<List<ParamData>> login(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            ParamData paramData = mDeviceService.queryInActDevice(pd);
            if (paramData == null) {
                if (mDeviceService.addInActDevice(pd)) {
                    return new ResultData<>(HandleEnum.SUCCESS, "已注册新设备");
                }
            } else return new ResultData<>(HandleEnum.SUCCESS, "设备已注册");
            return new ResultData<>(HandleEnum.FAIL, "设备注册失败，请重新连接");
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
