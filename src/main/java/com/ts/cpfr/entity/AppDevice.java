package com.ts.cpfr.entity;

import java.io.Serializable;

/**
 * @Classname AppDevice
 * @Description
 * @Date 2019/2/19 9:51
 * @Created by cjw
 */
public class AppDevice implements Serializable {
    private int wid;
    private String deviceSn;
    private String token;

    public AppDevice(String deviceSn, int wid) {
        this.deviceSn = deviceSn;
        this.wid = wid;
    }

    public int getWid() {
        return wid;
    }

    public void setWid(int wid) {
        this.wid = wid;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getDeviceSn() {
        return deviceSn;
    }

    public void setDeviceSn(String deviceSn) {
        this.deviceSn = deviceSn;
    }
}
