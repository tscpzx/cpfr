package com.ts.cpfr.controller.app;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.service.AppService;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.service.PersonService;
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
public class AppController extends BaseController {
    @Autowired
    DeviceService mDeviceService;
    @Autowired
    PersonService mPersonService;
    @Autowired
    AppService mAppService;

    @ResponseBody
    @RequestMapping("/device_register")
    public ResultData<List<ParamData>> deviceRegister(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            ParamData paramData = mDeviceService.queryInActDevice(pd);
            if (paramData == null) {
                if (mAppService.addInActDevice(pd)) {
                    return new ResultData<>(HandleEnum.SUCCESS, "已注册新设备");
                }
            } else return new ResultData<>(HandleEnum.SUCCESS, "设备已注册");
            return new ResultData<>(HandleEnum.FAIL, "设备注册失败，请重新连接");
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/device_info")
    public ResultData<ParamData> deviceInfo(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", mAppService.getUserWid(pd));
            ParamData paramData = mAppService.getDeviceInfo(pd);
            return new ResultData<>(HandleEnum.SUCCESS, paramData);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/person_list")
    public ResultData<List<ParamData>> personList(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", mAppService.getUserWid(pd));
            List<ParamData> list = mAppService.getPersonBase64List(pd);
            return new ResultData<>(HandleEnum.SUCCESS, list);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/grant_list")
    public ResultData<List<ParamData>> grantList(HttpServletRequest request, HttpServletResponse response) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", mAppService.getUserWid(pd));
            List<ParamData> list = mAppService.getGrantList(pd);
            return new ResultData<>(HandleEnum.SUCCESS, list);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/upload_record")
    public ResultData<ParamData> uploadRecord(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request) {
        try {
            if (file.getSize() / 1024 > 65) return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
            ParamData pd = new ParamData();
            pd.put("device_sn", request.getParameter("device_sn"));
            pd.put("admin_id", request.getParameter("admin_id"));
            pd.put("person_id", request.getParameter("person_id"));
            pd.put("recog_type", request.getParameter("recog_type"));
            pd.put("record_image", file.getBytes());
            pd.put("wid", mAppService.getUserWid(pd));
            if (mAppService.addRecord(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
        return new ResultData<>(HandleEnum.FAIL);
    }
}
