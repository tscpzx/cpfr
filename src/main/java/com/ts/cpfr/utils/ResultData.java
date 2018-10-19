package com.ts.cpfr.utils;


public class ResultData<T> {
    private int code;
    private String msg;
    private T data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public ResultData() {

    }

    public ResultData(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public ResultData(int code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public ResultData(HandleEnum operateEnum) {
        this.code = operateEnum.getCode();
        this.msg = operateEnum.getMessage();
    }

    public ResultData(HandleEnum operateEnum, T data) {
        this.code = operateEnum.getCode();
        this.msg = operateEnum.getMessage();
        this.data = data;
    }

    public ResultData(HandleEnum operateEnum, String msg) {
        this.code = operateEnum.getCode();
        this.msg = msg;
    }

    public ResultData(HandleEnum operateEnum, String msg, T data) {
        this.code = operateEnum.getCode();
        this.msg = msg;
        this.data = data;
    }
}