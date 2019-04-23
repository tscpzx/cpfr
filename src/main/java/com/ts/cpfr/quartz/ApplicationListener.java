package com.ts.cpfr.quartz;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * @Classname ApplicationListener
 * @Description
 * @Date 2019/4/19 15:44
 * @Created by cjw
 */
public class ApplicationListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        System.out.println("ApplicationListener contextInitialized应用程序初始化");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

        System.out.println("ApplicationListener contextDestroyed应用程序销毁");
    }
}
