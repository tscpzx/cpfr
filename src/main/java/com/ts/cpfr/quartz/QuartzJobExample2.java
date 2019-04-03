package com.ts.cpfr.quartz;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * quartz示例定时器类
 *
 * @author Administrator
 *
 */
public class QuartzJobExample2 extends MethodInvokingJobDetailFactoryBean.StatefulMethodInvokingJob {

    @Override
    protected void executeInternal(JobExecutionContext cts) throws JobExecutionException {
        System.out.println(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "★★★★★★★★★★★22222");
    }
}
