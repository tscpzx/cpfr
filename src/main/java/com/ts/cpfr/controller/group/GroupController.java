package com.ts.cpfr.controller.group;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageHelper;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.service.GroupService;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname GroupController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping("/group")
@SuppressWarnings({"rawtypes", "unchecked"})
public class GroupController extends BaseController {

    @Autowired
    private GroupService mGroupService;
    @Autowired
    private PersonService mPersonService;
    @Autowired
    private DeviceService mDeviceService;
    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<List<ParamData>> list(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();     //初始化分页参数
            int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
            int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据
            pd.put("wid", memory.getLoginUser().getWId());

            List<ParamData> groupList;
            if (pageSize == 0) {//查询出所有结果
                groupList = mGroupService.getGroupList(pd);
            } else {
                PageHelper.startPage(pageNum, pageSize);
                groupList = mGroupService.getGroupList(pd);
            }

            return new ResultData<>(HandleEnum.SUCCESS, groupList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/detail")
    public String detail(Model model, HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            ParamData group = mGroupService.queryGroup(pd);
            List<ParamData> personList = mPersonService.getPersonList(pd);
            List<ParamData> deviceList = mDeviceService.getDeviceList(pd);
            ParamData data = new ParamData();
            data.put("group", group);
            data.put("person_list", personList);
            data.put("device_list", deviceList);
            model.addAttribute(CommConst.DATA, JSON.toJSONString(data));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "group/group_detail";
    }

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            if (mGroupService.addGroup(pd)) return new ResultData<>(HandleEnum.SUCCESS);
            else return new ResultData<>(HandleEnum.FAIL);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add_person")
    public ResultData<ParamData> addPerson(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            String person_ids = pd.getString("person_ids");

            List<ParamData> list = new ArrayList<>();
            String[] personIdArr = person_ids.split(",");
            for (String personId : personIdArr) {
                ParamData paramData = new ParamData();
                int person_id = Integer.parseInt(personId);
                paramData.put("person_id", person_id);
                list.add(paramData);
            }

            ParamData paramData = new ParamData();
            paramData.put("wid", memory.getLoginUser().getWId());
            paramData.put("group_id", pd.getString("group_id"));
            paramData.put("list", list);
            if (mGroupService.addGroupPerson(paramData))
                return new ResultData<>(HandleEnum.SUCCESS);
            else return new ResultData<>(HandleEnum.FAIL);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add_device")
    public ResultData<ParamData> addDevice(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            String device_ids = pd.getString("device_ids");

            List<ParamData> list = new ArrayList<>();
            String[] deviceIdArr = device_ids.split(",");
            for (String deviceId : deviceIdArr) {
                ParamData paramData = new ParamData();
                int device_id = Integer.parseInt(deviceId);
                paramData.put("device_id", device_id);
                list.add(paramData);
            }

            ParamData paramData = new ParamData();
            paramData.put("wid", memory.getLoginUser().getWId());
            paramData.put("group_id", pd.getString("group_id"));
            paramData.put("list", list);
            if (mGroupService.addGroupDevice(paramData))
                return new ResultData<>(HandleEnum.SUCCESS);
            else return new ResultData<>(HandleEnum.FAIL);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
