package com.ts.cpfr.solrj;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import org.apache.solr.client.solrj.beans.Field;

/**
 * @Classname User
 * @Description
 * @Date 2018/12/11 11:40
 * @Created by cjw
 */
@JsonIgnoreProperties(ignoreUnknown = true)//jackSon注解：忽略未匹配到的字段
public class User {

    // solr查询若直接将数据转为对象，需要指定Field，该值需要和managed-schema配置Field的name一致
    @Field("admin_id")
    private String admin_id;

    @Field("name")
    private String name;

    public User() {
        super();
    }

    public User(String admin_id, String name) {
        super();
        this.admin_id = admin_id;
        this.name = name;
    }

    public String getAdminId() {
        return admin_id;
    }

    public void setId(String admin_id) {
        this.admin_id = admin_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "User [admin_id=" + admin_id + ", name=" + name + "]";
    }
}

