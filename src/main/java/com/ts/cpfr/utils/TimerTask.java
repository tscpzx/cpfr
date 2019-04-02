package com.ts.cpfr.utils;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.ejb.Schedule;

/**
 * @Date 2019/4/2
 * @Created by xwr
 */
@Component
public class TimerTask {
    //CronTrigger配置完整格式为： [秒] [分] [小时] [日] [月] [周] [年]
    @Scheduled(cron="0 0 5 ? * MON-FRI")
    public void TimerAdd(){

    }
}
