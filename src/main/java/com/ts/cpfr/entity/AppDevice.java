package com.ts.cpfr.entity;

import com.ts.cpfr.websocket.MyWebSocketSession;

import org.springframework.web.socket.WebSocketSession;

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
    private MyWebSocketSession session;

    public AppDevice(String deviceSn, int adminId, MyWebSocketSession session) {
        this.deviceSn = deviceSn;
        this.adminId = adminId;
        this.session = session;
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

    public WebSocketSession getSession() {
        return session;
    }

    public void setSession(MyWebSocketSession session) {
        this.session = session;
    }
}
