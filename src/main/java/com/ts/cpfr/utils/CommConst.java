package com.ts.cpfr.utils;

/**
 * 常量
 */
public class CommConst {
    public static String WEB_TITLE = "人脸识别管理系统";
    // 接口组装时返回的分页和结果属性
    public static String RESULT_PAGE = "page";
    public static String RESULT_DATA = "data";

    public static final int RESULT_CODE_SUCCESS = 1;
    public static final int RESULT_CODE_FAIL = 0;

    public static final String CODE = "code";
    public static final String MESSAGE = "message";
    public static final String DATA = "data";
    public static final String ACCESS_APP_TOKEN = "access_app_token";
    public static final String ACCESS_CPFR_TOKEN = "access_cpfr_token";
    public static final String DEVICE_SN = "device_sn";
    public static final String USER_ID = "user_id";

    /////websocket 状态码//////
    public static final int CODE_999 = 999;//操作失败
    public static final int CODE_1000 = 1000;//操作成功
    public static final int CODE_1001 = 1001;//激活成功
    public static final int CODE_1002 = 1002;//设备更新
    public static final int CODE_1003 = 1003;//人员更新
    public static final int CODE_1004 = 1004;//权限更新
    public static final int CODE_1005 = 1005;//设备删除
}