package com.ts.cpfr.controller;

import com.alibaba.fastjson.JSON;
import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.GroupService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname GroupController
 * @Description
 * @Date 2018/10/19 11:17
 * @Created by cjw
 */
@Controller
@RequestMapping(value = "/group",method = {RequestMethod.GET,RequestMethod.POST})
@SuppressWarnings({"rawtypes", "unchecked"})
public class GroupController extends WebBaseController {

    @Autowired
    private GroupService mGroupService;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<PageData<ParamData>> list(HttpServletRequest request) {
        try {
            return mGroupService.getGroupList(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/detail")
    public String detail(Model model, HttpServletRequest request) {
        try {
            ParamData data = mGroupService.queryGroup(paramDataInit());
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
            return mGroupService.addGroup(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add_person")
    public ResultData<ParamData> addPerson(HttpServletRequest request) {
        try {
            return mGroupService.addGroupPerson(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add_device")
    public ResultData<ParamData> addDevice(HttpServletRequest request) {
        try {
            return mGroupService.addGroupDevice(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/update_info")
    public ResultData<ParamData> updateInfo(HttpServletRequest request) {
        try {
            return mGroupService.updateGroupInfo(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/delete")
    public ResultData<ParamData> delete(HttpServletRequest request) {
        try {
            return mGroupService.deleteGroup(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/delete_person")
    public ResultData<ParamData> deletePerson(HttpServletRequest request) {
        try {
            return mGroupService.deleteGroupPerson(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/delete_device")
    public ResultData<ParamData> deleteDevice(HttpServletRequest request) {
        try {
            return mGroupService.deleteGroupDevice(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
