package com.ts.cpfr.entity;

import java.io.Serializable;

/**
 * @Classname AppDevice
 * @Description
 * @Date 2019/2/19 9:51
 * @Created by cjw
 */
public class AppDevice implements Serializable {
    private int adminId;
    private String deviceSn;
    private String token;

    public AppDevice(String deviceSn, int adminId) {
        this.deviceSn = deviceSn;
        this.adminId = adminId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
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
