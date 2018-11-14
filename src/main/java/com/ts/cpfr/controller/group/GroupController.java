package com.ts.cpfr.controller.group;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.GroupService;
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
    private Memory memory;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<List<ParamData>> list(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            List<ParamData> groupList = mGroupService.getGroupList(pd);
            return new ResultData<>(HandleEnum.SUCCESS, groupList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

}
