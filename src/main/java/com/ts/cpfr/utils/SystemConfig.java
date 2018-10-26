package com.ts.cpfr.utils;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Classname SystemConfig
 * @Description
 * @Date 2018/10/18 10:53
 * @Created by cjw
 */
public class SystemConfig {
    //实义德第三方调用校验秘钥
    public static final String SYD_CHECKSUM_KEY = "4200efc681e2d01dca19dea30f2bca6b";
    //实义德服务器基本地址
    public static final String SYD_BASE_URL = "http://132.232.4.69:9090";

//    public static final String PROJECT_NAME = "/cpfr";//发布war
    public static final String PROJECT_NAME = "";

    //session存活时间 秒
    public static final int SESSION_LIVE_TIME_30 = 60 * 30;
    //cookie存活时间 秒
    public static final int COOKIE_LIVE_TIME = 60;

    public static CopyOnWriteArrayList<String> allowUrlList = new CopyOnWriteArrayList<>();

    static {
        allowUrlList.add(PROJECT_NAME + "/user/login");//用户登录
        allowUrlList.add(PROJECT_NAME + "/user/nologin");//用户未登录
        allowUrlList.add(PROJECT_NAME + "/user/register");//用户注册
        allowUrlList.add(PROJECT_NAME + "/app/device/register");
    }
}
