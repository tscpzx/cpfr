package com.ts.cpfr.quartz;

import com.ts.cpfr.dao.QuartzJobDao;
import com.ts.cpfr.utils.ParamData;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * quartz示例定时器类
 *
 * @author Administrator
 */
public class QuartzJobExample extends MethodInvokingJobDetailFactoryBean.StatefulMethodInvokingJob {
    @Resource
    private QuartzJobDao mQuartzJobDao;

    @Override
    protected void executeInternal(JobExecutionContext cts) throws JobExecutionException {
        JobDataMap jobDataMap = cts.getJobDetail().getJobDataMap();
        String personIds = jobDataMap.getString("ids");
        int wid = Integer.parseInt(jobDataMap.getString("wid"));
        String[] arr = personIds.split(",");
        System.out.println("***********************************wid:" + wid);
        System.out.println("***********************************ids:" + personIds);
        List<ParamData> pd = new ArrayList<>();
        for (String s : arr) {
            ParamData pd1 = new ParamData();
            pd1.put("person_id", Integer.valueOf(s));
            pd.add(pd1);
        }
        ParamData data = new ParamData();
        data.put("wid", wid);
        data.put("list", pd);
        mQuartzJobDao.insertPunch(data);


    }
}
