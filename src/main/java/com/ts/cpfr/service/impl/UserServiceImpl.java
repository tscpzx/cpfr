package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.dao.UserDao;
import com.ts.cpfr.ehcache.TokenProcessor;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.entity.UserInfo;
import com.ts.cpfr.service.UserService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SystemConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

/**
 * @Classname UserServiceImpl
 * @Description
 * @Date 2018/10/16 14:50
 * @Created by cjw
 */
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao mUserDao;
    @Resource
    private TableDao mTableDao;
    @Autowired
    private WebMemory memory;

    @Transactional
    @Override
    public ResultData<ParamData> login(ParamData pd, HttpServletRequest request, HttpServletResponse response) {
        UserInfo userInfo = mUserDao.selectUserMapByName(pd);
        if (userInfo != null) {
            if (userInfo.getPassword().equals(pd.getString("password"))) {
                memory.putCache(userInfo);

                HttpSession session = request.getSession();
                session.setMaxInactiveInterval(SystemConfig.SESSION_TIME_LIVE_MAX);
                session.setAttribute("user", userInfo);

                //存入cookie中
                Cookie cookie = new Cookie(CommConst.ACCESS_CPFR_TOKEN, userInfo.getToken());
                cookie.setMaxAge(SystemConfig.COOKIE_LIVE_TIME);
                cookie.setPath(request.getContextPath() + "/");
                //写回浏览器
                response.addCookie(cookie);

                ParamData paramData = new ParamData();
                paramData.put(CommConst.USER_ID, userInfo.getUserId());
                paramData.put(CommConst.ACCESS_CPFR_TOKEN, userInfo.getToken());

                mUserDao.updateUserLoginTime(paramData);

                return new ResultData<>(HandleEnum.SUCCESS, paramData);
            } else {
                return new ResultData<>(HandleEnum.PASSWORD_ERROR_104);
            }
        } else return new ResultData<>(HandleEnum.ADMIN_NOT_EXIST_103);
    }

    @Transactional
    @Override
    public ResultData<ParamData> register(ParamData pd) {
        UserInfo userInfo = mUserDao.selectUserMapByName(pd);
        if (userInfo == null) {
            boolean result = mUserDao.insertUser(pd);
            if (result) {
                //注册成功，建立对应仓库
                int wid = mTableDao.selectLastInsertID();
                mTableDao.createTableWarehouse(wid);
                return new ResultData<>(HandleEnum.SUCCESS);
            } else return new ResultData<>(HandleEnum.FAIL);
        } else return new ResultData<>(HandleEnum.ADMIN_EXISTED_100);
    }

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, ParamData pd) {
        String seed = TokenProcessor.getInstance().generateSeed(memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getUserId() + "");
        memory.removeCache(seed);
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if (CommConst.ACCESS_CPFR_TOKEN.equals(cookie.getName())) {
                cookie.setMaxAge(0); //清空cookie
                cookie.setPath(request.getContextPath() + "/");
                response.addCookie(cookie);
                break;
            }
        }
    }

    @Transactional
    @Override
    public ResultData<ParamData> changePassword(ParamData pd) {
        pd.put("name", memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getName());
        pd.put("user_id", memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getUserId());
        UserInfo userInfo = mUserDao.selectUserMapByName(pd);
        if (userInfo.getPassword().equals(pd.getString("old_password"))) {
            if (mUserDao.updateUserPassword(pd)) return new ResultData<>(HandleEnum.SUCCESS);
            else return new ResultData<>(HandleEnum.FAIL);
        } else return new ResultData<>(HandleEnum.FAIL, "原密码输入有误");
    }
}
