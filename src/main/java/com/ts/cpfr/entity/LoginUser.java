package com.ts.cpfr.entity;

import java.io.Serializable;

/**
 * Created by Administrator on 2018/1/4.
 */
public class LoginUser implements Serializable {
    private int id;
    private int sydAdminId;
    private String name;
    private String password;
    private String token;
    private String sydToken;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSydAdminId() {
        return sydAdminId;
    }

    public void setSydAdminId(int sydAdminId) {
        this.sydAdminId = sydAdminId;
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

    public String getSydToken() {
        return sydToken;
    }

    public void setSydToken(String sydToken) {
        this.sydToken = sydToken;
    }
}
