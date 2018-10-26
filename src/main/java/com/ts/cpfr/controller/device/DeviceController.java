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
    public ResultData<List<ParamData>> list(HttpServletRequest request) {
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

    @ResponseBody
    @RequestMapping("/activate")
    public ResultData<List<ParamData>> activate(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            ParamData paramData = mDeviceService.queryInactDevice(pd);
            if (paramData == null) return new ResultData<>(HandleEnum.FAIL, "设备不存在");
            if ("1".equals(paramData.getString("status"))) {
                if (mDeviceService.activateDevice(pd)) {
                    //激活成功，往对应仓库插入设备，返回
                    return new ResultData<>(HandleEnum.SUCCESS);
                } else return new ResultData<>(HandleEnum.FAIL);
            } else {
                return new ResultData<>(HandleEnum.FAIL, "设备不在线");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
