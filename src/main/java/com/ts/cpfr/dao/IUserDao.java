package com.ts.cpfr.dao;

import com.ts.cpfr.entity.UserInfo;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

public interface IUserDao {

    @Select("select * from users where username=#{username}")
    @Results({
            @Result(id = true, property = "user_id", column = "user_id"),
            @Result(property = "name", column = "name"),
    })
    public UserInfo findByUsername(String username) throws Exception;
}
