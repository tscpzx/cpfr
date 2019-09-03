package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.AttendDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.QuartzJobDao;
import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.quartz.QuartzJobExample;
import com.ts.cpfr.quartz.QuartzJobManager;
import com.ts.cpfr.service.AttendService;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.ExportExcelUtils;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

/**
 * @Date 2019/3/14
 * @Created by xwr
 */
@Service
public class AttendServiceImpl implements AttendService {

    @Resource
    private AttendDao mAttendDao;
    @Resource
    private QuartzJobDao mQuartzJobDao;
    @Resource
    private TableDao mTableDao;
    @Autowired
    QuartzJobManager mQuartzJobManager;
    @Autowired
    PersonDao mPersonDao;

    @Transactional
    @Override
    public ResultData<ParamData> addRule(ParamData pd) {
        String person_ids = pd.getString("person_ids");
        List<ParamData> list = new ArrayList<>();
        String[] personIdArr = person_ids.split(",");
        for (String personId : personIdArr) {
            ParamData paramData = new ParamData();
            int person_id = Integer.parseInt(personId);
            paramData.put("person_id", person_id);
            list.add(paramData);
        }
        ParamData job = new ParamData();
        job.put("wid", pd.get("wid"));
        job.put("job_name", pd.get("attend_name"));
        job.put("class_name", QuartzJobExample.class.getName());
        String str = (String) pd.get("am_punch_in_start");
        int index = str.indexOf(":");
        job.put("cron_expression", "0 " + str.substring(index + 1, str.length()) + " " + str.substring(0, index) + " ? * " + pd.get("work_day"));
        if (mQuartzJobDao.insertJob(job)) {
            int id = mTableDao.selectLastInsertID();
            pd.put("job_id", id);
            if (mAttendDao.insertRule(pd)) {
                ParamData attend = new ParamData();
                int ruleId = mTableDao.selectLastInsertID();
                attend.put("wid", pd.get("wid"));
                attend.put("attend_id",ruleId);
                attend.put("list",list);
                mPersonDao.updatePersonAttendId(attend);
                return new ResultData<>(HandleEnum.SUCCESS);
            } else return new ResultData<>(HandleEnum.FAIL);
        } else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<PageData<ParamData>> getRuleList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> ruleList = mAttendDao.selectRuleList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(ruleList));
    }

    @Override
    public ParamData queryAttend(ParamData pd) {
        return mAttendDao.selectAttend(pd);
    }

    @Override
    public ResultData<ParamData> deleteRule(ParamData pd) {
        if (mAttendDao.deleteRule(pd)) {
            QuartzJobModel quartzJobModel = mQuartzJobDao.selectJob(pd);
            mQuartzJobManager.removeJob(quartzJobModel);
            mQuartzJobDao.deleteJob(pd);
            mPersonDao.deletePersonAttendId(pd);
            return new ResultData<>(HandleEnum.SUCCESS);
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<PageData<ParamData>> getAttendList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> attendList = mAttendDao.selectAttendList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(attendList));
    }

    @Override
    public void export(ParamData pd, HttpServletResponse response) {
        List<ParamData> attendList = mAttendDao.selectAttendList(pd);
        HashMap<String, String> map = new HashMap<>();
        map.put("person_name","姓名");
        map.put("device_name","设备");
//        map.put("recog_type","识别方式");
        map.put("record_time","识别时间");
        map.put("group_name","组名");
        ExportExcelUtils.<ParamData>export("通行记录报表",attendList,map,response);
    }

}
