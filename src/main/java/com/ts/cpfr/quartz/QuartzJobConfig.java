package com.ts.cpfr.quartz;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

/**
 * @Classname QuartzJobConfig
 * @Description
 * @Date 2019/4/3 9:55
 * @Created by cjw
 */
@Configuration
@EnableScheduling
public class QuartzJobConfig {
    @Autowired
    private MyJobFactory myJobFactory;

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();
        factory.setOverwriteExistingJobs(true);
        factory.setStartupDelay(20);
        factory.setJobFactory(myJobFactory);
        return factory;
    }
}

