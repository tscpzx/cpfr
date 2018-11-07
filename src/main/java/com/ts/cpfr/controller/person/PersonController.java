package com.ts.cpfr.controller.person;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.ehcache.Memory;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import sun.misc.BASE64Encoder;

/**
 * @Classname PersonController
 * @Description
 * @Date 2018/11/6 10:38
 * @Created by cjw
 */
@Controller
@RequestMapping("/person")
public class PersonController extends BaseController {

    @Autowired
    private PersonService mPersonService;
    @Autowired
    private Memory memory;

    @ResponseBody
    @RequestMapping("/list")
    public ResultData<List<ParamData>> list(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            List<ParamData> personList = mPersonService.getPersonList(pd);
            return new ResultData<>(HandleEnum.SUCCESS, personList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/list/page")
    public ResultData<PageInfo<ParamData>> listPage(HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();     //初始化分页参数
            int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
            int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据
            PageHelper.startPage(pageNum, pageSize);
            pd.put("wid", memory.getLoginUser().getWId());
            List<ParamData> deviceList = mPersonService.getPersonList(pd);
            PageInfo<ParamData> pageInfo = new PageInfo<>(deviceList);
            return new ResultData<>(HandleEnum.SUCCESS, pageInfo);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping("/add")
    public ResultData<ParamData> add(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request) {
        try {
            ParamData pd = new ParamData();
            pd.put("person_name", request.getParameter("person_name"));
            pd.put("emp_number", request.getParameter("emp_number"));
            pd.put("base_image", file.getBytes());
            pd.put("wid", memory.getLoginUser().getWId());
            if (mPersonService.addPerson(pd)) return new ResultData<>(HandleEnum.SUCCESS);
            return new ResultData<>(HandleEnum.FAIL);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultData<>(HandleEnum.FAIL, e.getMessage());
        }
    }

    @RequestMapping("/detail")
    public String detail(Model model,HttpServletRequest request) {
        try {
            ParamData pd = paramDataInit();
            pd.put("wid", memory.getLoginUser().getWId());
            ParamData paramData = mPersonService.queryPerson(pd);
            byte[] bytes = (byte[]) paramData.get("base_image");
            BASE64Encoder base64Encoder = new BASE64Encoder();
            String base64 = base64Encoder.encode(bytes);
            paramData.put("base_image", base64);
            model.addAttribute(CommConst.DATA, paramData);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "person/person_detail";
    }

}
