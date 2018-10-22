package com.ts.cpfr.utils;


public enum HandleEnum {
    FAIL(-1,"操作异常"),
    SUCCESS(0,"操作成功"),
    ADMIN_EXISTED_100(100,"该管理员用户已注册"),
    PARAM_ERROR_101(101,"参数错误"),
    SESSION_ERROR_102(102,"session失效或者未登录"),
    ADMIN_NOT_EXIST_103(103,"没有该管理员用户"),
    PASSWORD_ERROR_104(104,"密码错误"),
    ;

    private int code;
    private String message;

    HandleEnum(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
		return code;
	}

	public String getMessage() {
		return message;
	}

	public static HandleEnum codeOf(int index){
        for (HandleEnum code : values()){
            if (code.getCode()==index){
                return code;
            }
        }
        return null;
    }
}