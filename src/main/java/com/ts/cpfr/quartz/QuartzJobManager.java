package com.ts.cpfr.quartz;

import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.service.QuartzJobService;

import org.quartz.CronTrigger;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * Quartz调度管理器
 *
 * @author Administrator
 */

@Component("quartzJobManager")
public class QuartzJobManager {
    private static final String DEFAULT_JOB_GROUP_NAME = "DefaultJobGroup ";
    private static final String DEFAULT_TRIGGER_GROUP_NAME = "DefaultTriggerGroup ";

    @Autowired
    private SchedulerFactoryBean schedulerFactoryBean;
    @Autowired
    private QuartzJobService mQuartzJobService;

    /**
     * 加载数据库中已定义的定时任务
     *
     * @Title: loadJobs
     * @Description: 加载数据库中已定义的定时任务
     */
    public void loadJobs() {
        List<QuartzJobModel> jobs = mQuartzJobService.getAll();
        if (null != jobs && !jobs.isEmpty()) {
            for (QuartzJobModel job : jobs) {
                addJob(job);
            }
        }
    }

    /**
     * 移除所有定时任务
     *
     * @Title: removeAll
     * @Description: 移除所有定时任务
     */
    public void removeAll() {
        List<QuartzJobModel> jobs = mQuartzJobService.getAll();
        if (null != jobs && !jobs.isEmpty()) {
            for (QuartzJobModel job : jobs) {
                removeJob(job);
            }
        }
    }

    /**
     * 重新加载数据库中已定义的定时任务
     *
     * @Title: reloadJobs
     * @Description: 重新加载数据库中已定义的定时任务
     */
    public void reloadJobs() {
        removeAll();
        loadJobs();
    }

    /**
     * 添加一个新的定时任务
     *
     * @param job QuartzJobModel
     * @Title: addJob
     * @Description: 添加一个新的定时任务
     */
    public void addJob(QuartzJobModel job) {
        try {
            Scheduler scheduler = schedulerFactoryBean.getScheduler();
            JobDetail jobDetail = new JobDetail(job.getJobName(), DEFAULT_JOB_GROUP_NAME, Class.forName(job.getClassName()));// 任务名，任务组，任务执行类
            // 触发器
            CronTrigger trigger = new CronTrigger(job.getJobName(), DEFAULT_TRIGGER_GROUP_NAME);// 触发器名,触发器组
            trigger.setCronExpression(job.getCronExpression());// 触发器时间设定
            scheduler.scheduleJob(jobDetail, trigger);
            // 启动
            if (!scheduler.isStarted()) {
                scheduler.start();
            }
            System.out.println("注册定时任务：" + job.getJobName());
        } catch (Exception e) {
            System.out.println("注册定时任务失败：" + job.getJobName() + e.getMessage());
        }
    }

    /**
     * 添加一个新的定时任务
     *
     * @param job QuartzJobModel
     * @Title: addJob
     * @Description: 添加一个新的定时任务
     */
    public void addJob(QuartzJobModel job, Map map) {
        try {
            Scheduler scheduler = schedulerFactoryBean.getScheduler();
            JobDetail jobDetail = new JobDetail(job.getJobName(), DEFAULT_JOB_GROUP_NAME, Class.forName(job.getClassName()));// 任务名，任务组，任务执行类
            if (map != null)
                jobDetail.setJobDataMap(new JobDataMap(map));
            // 触发器
            CronTrigger trigger = new CronTrigger(job.getJobName(), DEFAULT_TRIGGER_GROUP_NAME);// 触发器名,触发器组
            trigger.setCronExpression(job.getCronExpression());// 触发器时间设定
            scheduler.scheduleJob(jobDetail, trigger);
            // 启动
            if (!scheduler.isStarted()) {
                scheduler.start();
            }
            System.out.println("注册定时任务：" + job.getJobName());
        } catch (Exception e) {
            System.out.println("注册定时任务失败：" + job.getJobName() + e.getMessage());
        }
    }

    /**
     * 修改定时任务
     *
     * @param job QuartzJobModel
     * @Title: modifyJob
     * @Description: 修改定时任务
     */
    public void modifyJob(QuartzJobModel job) {
        removeJob(job);
        addJob(job);
    }

    /**
     * 删除定时任务
     *
     * @param job QuartzJobModel
     * @Title: removeJob
     * @Description: 删除定时任务
     */
    public void removeJob(QuartzJobModel job) {
        try {
            Scheduler scheduler = schedulerFactoryBean.getScheduler();
            scheduler.pauseTrigger(job.getJobName(), DEFAULT_TRIGGER_GROUP_NAME);// 停止触发器
            scheduler.unscheduleJob(job.getJobName(), DEFAULT_TRIGGER_GROUP_NAME);// 移除触发器
            scheduler.deleteJob(job.getJobName(), DEFAULT_JOB_GROUP_NAME);// 删除任务
            System.out.println("移除定时任务：" + job.getJobName());
        } catch (Exception e) {
            System.out.println("移除定时任务失败：" + job.getJobName() + e.getMessage());
        }
    }

    /**
     * 暂停定时任务
     *
     * @param job QuartzJobModel
     * @Title: pauseJob
     * @Description: 暂停定时任务
     */
    public void pauseJob(QuartzJobModel job) {
        Scheduler scheduler = schedulerFactoryBean.getScheduler();
        try {
            scheduler.pauseJob(job.getJobName(), DEFAULT_JOB_GROUP_NAME);
            System.out.println("******暂停定时任务：" + job.getJobName() + " ******");
        } catch (SchedulerException e) {
            System.out.println("暂停定时任务失败：" + job.getJobName() + e.getMessage());
        }
    }

    /**
     * 恢复定时任务
     *
     * @param job QuartzJobModel
     * @Title: resumeJob
     * @Description: 恢复定时任务
     */
    public void resumeJob(QuartzJobModel job) {
        Scheduler scheduler = schedulerFactoryBean.getScheduler();
        try {
            scheduler.resumeJob(job.getJobName(), DEFAULT_JOB_GROUP_NAME);
            System.out.println("******恢复定时任务：" + job.getJobName() + " ******");
        } catch (SchedulerException e) {
            System.out.println("恢复定时任务失败：" + job.getJobName() + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * @Description:启动所有定时任务
     * @Title: QuartzJobManager.java
     */
    public void startJobs() {
        try {
            Scheduler scheduler = schedulerFactoryBean.getScheduler();
            if (!scheduler.isStarted())
                scheduler.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @Description:关闭所有定时任务
     * @Title: QuartzJobManager.java
     */
    public void shutdownJobs() {
        try {
            Scheduler scheduler = schedulerFactoryBean.getScheduler();
            if (scheduler.isStarted()) {
                scheduler.shutdown();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

