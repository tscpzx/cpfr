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
    //用户登录
    public static final String SYD_USER_LOGIN = "/user/login";
    //用户未登录
    public static final String SYD_USER_NOLOGIN = "/user/nologin";
    //用户注销
    public static final String SYD_USER_LOGOUT = "/user/logout";
    //设备列表
    public static final String SYD_DEVICE_LIST = "/device/list";

    //session存活时间 秒
    public static final int SESSION_LIVE_TIME_30 = 60 * 30;
    //cookie存活时间 秒
    public static final int COOKIE_LIVE_TIME = 60;

    public static CopyOnWriteArrayList<String> allowUrlList = new CopyOnWriteArrayList<>();

    static {
        allowUrlList.add(SYD_USER_LOGIN);
        allowUrlList.add(SYD_USER_NOLOGIN);
        allowUrlList.add("/user/register");
        allowUrlList.add("/websocket/login");
        allowUrlList.add("/websocket/sendMsg");
    }
}
