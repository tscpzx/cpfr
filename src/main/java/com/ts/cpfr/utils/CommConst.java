package com.ts.cpfr.utils;

public class CommConst {
    public static String WEB_TITLE = "人脸识别管理系统";
    // 接口组装时返回的分页和结果属性
    public static String RESULT_PAGE = "page";
    public static String RESULT_DATA = "data";

    public static final int RESULT_CODE_SUCCESS = 1;
    public static final int RESULT_CODE_FAIL = 0;
    //上传文件的地址
    public static final String UPLOAD_IMAGE = "E:/cpfr_upload/image/";
    public static final String UPLOAD_VIDEO = "E:/cpfr_upload/video/";
    public static final String UPLOAD_AUDIO = "E:/cpfr_upload/audio/";
    //上传临时存放地址，文件过大时
    public static final String UPLOAD_TEMP = "F:/upload/Temp/";

    public static final String CODE = "code";
    public static final String MESSAGE = "message";
    public static final String DATA = "data";
    public static final String ACCESS_CPFR_TOKEN = "access_cpfr_token";
    public static final String ACS_ADMIN_COOKIE = "acs_admin_cookie";
    public static final String DEVICE_SN = "device_sn";
    public static final String ADMIN_ID = "admin_id";

    /////websocket 状态码//////
    public static final int CODE_1000 = 1000;//操作成功
    public static final int CODE_999 = 999;//操作失败
    public static final int CODE_1001 = 1001;//激活成功
}