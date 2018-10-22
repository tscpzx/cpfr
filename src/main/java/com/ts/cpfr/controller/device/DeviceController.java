package com.ts.cpfr.controller.device;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
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
    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<List<ParamData>> login(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            List<ParamData> deviceList = mDeviceService.getDeviceList(pd);
            return new ResultData<>(HandleEnum.SUCCESS, deviceList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
