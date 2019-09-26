package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;
import com.ts.cpfr.service.RecordService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname RecordController
 * @Description
 * @Date 2018/11/6 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping(value = "/record",method = {RequestMethod.GET,RequestMethod.POST})
public class RecordController extends WebBaseController {

    @Autowired
    private RecordService mRecordService;

    @ResponseBody
    @RequestMapping("/list_base64")
    public ResultData<PageData<ParamData>> listBase64(HttpServletRequest request) {
        try {
            return mRecordService.getRecordBase64List(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }

    }

    /**
     * 删除记录
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/delete")
    public ResultData<ParamData> delete(HttpServletRequest request) {
        try {
            return mRecordService.deleteRecord(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    /**
     * 批量删除
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/deleteLists")
    public ResultData<ParamData> deleteLists(HttpServletRequest request) {
        try {
            return mRecordService.deleteRecordLists(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }


    /**
     * 清空
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/clear")
    public ResultData<ParamData> clear(HttpServletRequest request) {
        try {
            return mRecordService.clearRecord(paramDataInit());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
