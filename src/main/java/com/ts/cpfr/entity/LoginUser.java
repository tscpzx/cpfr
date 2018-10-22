package com.ts.cpfr.entity;

import java.io.Serializable;

/**
 * Created by Administrator on 2018/1/4.
 */
public class LoginUser implements Serializable {
    private int adminId;
    private int wid;
    private String name;
    private String password;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getWId() {
        return wid;
    }

    public void setWId(int wid) {
        this.wid = wid;
    }
}
