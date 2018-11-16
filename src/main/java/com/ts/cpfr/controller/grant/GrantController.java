package com.ts.cpfr.controller.grant;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname GrantController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping("/grant")
@SuppressWarnings({"rawtypes", "unchecked"})
public class GrantController extends BaseController {

    @Autowired
    private GrantService mGrantService;

    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<List<ParamData>> add(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            String person_ids = pd.getString("person_ids");
            String device_ids = pd.getString("device_ids");
            String type = pd.getString("type");
            String pass_number = pd.getString("pass_number");
            String pass_start_time = pd.getString("pass_start_time");
            String pass_end_time = pd.getString("pass_end_time");

            List<ParamData> list = new ArrayList<>();
            String[] personIdArr = person_ids.split(",");
            String[] deviceIdArr = device_ids.split(",");
            for (String personId : personIdArr) {
                for (String deviceId : deviceIdArr) {
                    ParamData paramData = new ParamData();
                    int person_id = Integer.parseInt(personId);
                    int device_id = Integer.parseInt(deviceId);
                    paramData.put("person_id", person_id);
                    paramData.put("device_id", device_id);
                    paramData.put("type", type);
                    paramData.put("pass_number", pass_number);
                    paramData.put("pass_start_time", pass_start_time);
                    paramData.put("pass_end_time", pass_end_time);
                    list.add(paramData);
                }
            }

            ParamData paramData = new ParamData();
            paramData.put("wid", memory.getLoginUser().getWId());
            paramData.put("list", list);
            if (mGrantService.addGrants(paramData)) return new ResultData<>(HandleEnum.SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
        return new ResultData<>(HandleEnum.FAIL);
    }

}
