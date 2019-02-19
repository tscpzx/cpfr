package com.ts.cpfr.entity;

/**
 * @Classname AppDevice
 * @Description
 * @Date 2019/2/19 9:51
 * @Created by cjw
 */
public class AppDevice {
    private int adminId;
    private String deviceSn;
    private String token;

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
