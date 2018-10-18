package com.ts.cpfr.utils;


public enum HandleEnum {
    FAIL(-1,"操作异常"),
    SUCCESS(0,"操作成功");

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