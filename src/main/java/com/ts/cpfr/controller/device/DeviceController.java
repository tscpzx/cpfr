package com.ts.cpfr.controller.device;

import com.alibaba.fastjson.JSONObject;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.socket.TextMessage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    private DeviceService mDeviceService;
    @Autowired
    private Memory memory;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

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
    public ResultData<ParamData> activate(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            LoginUser user = memory.getLoginUser();
            ParamData paramData = mDeviceService.queryInActDevice(pd);
            if (paramData == null) return new ResultData<>(HandleEnum.FAIL, "设备不存在");
            pd.put("admin_id", user.getAdminId());
            if (1 == (Integer) paramData.get("online")) {
                if (mDeviceService.activateDevice(pd)) {
                    //激活成功，往对应仓库插入设备，返回
                    ParamData insertPd = mDeviceService.queryInActDevice(pd);
                    insertPd.put("wid", user.getWId());
                    if (mDeviceService.addDevice(insertPd)) {
                        //增加websocketsession的admin_id
                        mSocketMessageHandle.saveAdminIdToSession(insertPd.getString(CommConst.DEVICE_SN),user.getAdminId());

                        //通知设备激活成功
                        String device_sn = insertPd.getString(CommConst.DEVICE_SN);
                        Map<String, Object> jsonMap = new HashMap<>();
                        jsonMap.put("code", 101);
                        jsonMap.put("admin_id", user.getAdminId());
                        jsonMap.put("content", "激活成功");
                        mSocketMessageHandle.sendMessageToDevice(device_sn, new TextMessage(JSONObject
                          .toJSONString(jsonMap)));
                        return new ResultData<>(HandleEnum.SUCCESS);
                    }
                }
                return new ResultData<>(HandleEnum.FAIL);
            } else {
                return new ResultData<>(HandleEnum.FAIL, "设备不在线");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/inact/list")
    public ResultData<List<ParamData>> inactList(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            List<ParamData> inActDeviceList = mDeviceService.getInActDeviceList(pd);
            return new ResultData<>(HandleEnum.SUCCESS, inActDeviceList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/inact/detail")
    public String sysDetail(Model model) {
        try {
            ParamData pd = paramDataInit();
            ParamData paramData = mDeviceService.queryInActDevice(pd);
            model.addAttribute(CommConst.DATA, paramData);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "../webpage/device/device_inact";
    }
}
