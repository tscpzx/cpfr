package com.ts.cpfr.utils;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Classname SystemConfig
 * @Description
 * @Date 2018/10/18 10:53
 * @Created by cjw
 */
public class SystemConfig {
    public static final boolean DEBUG = true;
    //websocket 地址
    public static final String WEB_SOCKET_URL = "/ws";
    public static final String PROJECT_NAME = "/cpfr";

    //session存活时间 秒
    public static final int SESSION_TIME_LIVE_MAX = 60 * 60 * 12;
    //当对象自从最近一次被访问后，如果处于空闲状态的时间超过了设置的时间，这个对象就会过期
    public static final int SESSION_TIME_TO_IDLE = 60 * 60 * 2;
    //cookie存活时间 秒
    public static final int COOKIE_LIVE_TIME = 60 * 60 * 12;

    //上传文件的地址
    public static String UPLOAD_IMAGE_DIR;
    public static String UPLOAD_RECORD_IMAGE_DIR;

    static {
        if (DEBUG) {
            UPLOAD_IMAGE_DIR = "D:/cpfr_upload/image/";
            UPLOAD_RECORD_IMAGE_DIR = "D:/cpfr_upload/record_image/";
        } else {
            UPLOAD_IMAGE_DIR = "/home/cpfr_upload/image/";
            UPLOAD_RECORD_IMAGE_DIR = "/home/cpfr_upload/record_image/";
        }
    }

    public static CopyOnWriteArrayList<String> allowUrlList = new CopyOnWriteArrayList<>();

    static {
        allowUrlList.add("/user/login");//用户登录
        allowUrlList.add("/user/nologin");//用户未登录
        allowUrlList.add("/user/register");//用户注册
        allowUrlList.add("/app/device_register");
        allowUrlList.add("/app/device_info");
        allowUrlList.add("/app/person_list");
        allowUrlList.add("/app/grant_list");
        allowUrlList.add("/app/upload_record");
    }
}
