package com.ts.cpfr.spring;

import com.ts.cpfr.service.DeviceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

/**
 * @Classname SystemStartupListener
 * @Description
 * @Date 2019/4/3 10:01
 * @Created by cjw
 */
@Component("StartupListener")
public class SystemStartupListener implements ApplicationListener<ApplicationEvent> {
    @Autowired
    DeviceService mDeviceService;

    /**
     * @see org.springframework.context.ApplicationListener#onApplicationEvent(org.springframework.context.ApplicationEvent)
     */
    @Override
    public void onApplicationEvent(ApplicationEvent event) {
        if(event instanceof ContextRefreshedEvent){//监听初始化
            if(((ContextRefreshedEvent) event).getApplicationContext().getParent()!=null){
                System.out.println("系统启动");
            }

        }else if(event instanceof ContextClosedEvent){//监听销毁
            if(((ContextClosedEvent) event).getApplicationContext().getParent()!=null){
                System.out.println("系统关闭");
                //将设备在线状态修改为离线
                mDeviceService.updateAllDeviceOffline();
            }
        }
    }
}

