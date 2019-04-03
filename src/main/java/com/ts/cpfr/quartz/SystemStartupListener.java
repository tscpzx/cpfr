package com.ts.cpfr.quartz;

import com.ts.cpfr.entity.QuartzJobModel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

/**
 * @Classname SystemStartupListener
 * @Description
 * @Date 2019/4/3 10:01
 * @Created by cjw
 */
@Component("StartupListener")
public class SystemStartupListener implements ApplicationListener<ContextRefreshedEvent> {
    private int runTime = 0;

    @Autowired
    QuartzJobManager mQuartzJobManager;

    /**
     * @see org.springframework.context.ApplicationListener#onApplicationEvent(org.springframework.context.ApplicationEvent)
     */

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        runTime++;
        if (2 == runTime) {
            System.out.println("系统启动了");

            QuartzJobModel job = new QuartzJobModel();
            job.setClassName("com.ts.cpfr.quartz.QuartzJobExample");
            job.setJobName("test");
            job.setCronExpression("0/1 * * * * ?");
            mQuartzJobManager.addJob(job);

            QuartzJobModel job2 = new QuartzJobModel();
            job2.setClassName("com.ts.cpfr.quartz.QuartzJobExample2");
            job2.setJobName("test2");
            job2.setCronExpression("0/1 * * * * ?");
            mQuartzJobManager.addJob(job2);
        }
    }

}

