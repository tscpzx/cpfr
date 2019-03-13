package com.ts.cpfr.utils;

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

    //虹软授权ID
    public static final String ARCSOFT_APPID = "Co4RfcU3B6v2s9MvHWYtzJv2JAqmJwWgc9j1pGmNEgeu";
    public static final String ARCSOFT_SDKKEY = "7ijdL3ip6mS5bqx49jHZwz6CwK3osoznwCa6YPrkH5Dx";

    static {
        if (DEBUG) {
            UPLOAD_IMAGE_DIR = "D:/cpfr_upload/image/";
            UPLOAD_RECORD_IMAGE_DIR = "D:/cpfr_upload/record_image/";
        } else {
            UPLOAD_IMAGE_DIR = "/home/cpfr_upload/image/";
            UPLOAD_RECORD_IMAGE_DIR = "/home/cpfr_upload/record_image/";
        }
    }
}
