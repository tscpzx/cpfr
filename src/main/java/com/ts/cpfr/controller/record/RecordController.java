package com.ts.cpfr.controller.record;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.RecordService;
import com.ts.cpfr.utils.CommUtil;
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
 * @Classname RecordController
 * @Description
 * @Date 2018/11/6 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping("/record")
public class RecordController extends BaseController {

    @Autowired
    private RecordService mRecordService;
    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/list_base64")
    public ResultData<PageInfo<ParamData>> listBase64(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();     //初始化分页参数
            int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
            int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据
            pd.put("wid", memory.getLoginUser().getWId());

            List<ParamData> recordList;
            if (pageSize == 0) {//查询出所有结果
                recordList = mRecordService.getRecordBase64List(pd);
            } else {
                PageHelper.startPage(pageNum, pageSize);
                recordList = mRecordService.getRecordBase64List(pd);
            }

            PageInfo<ParamData> pageInfo = new PageInfo<>(recordList);
            return new ResultData<>(HandleEnum.SUCCESS, pageInfo);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }
}
