package com.ts.cpfr.spring;

import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.ehcache.ThreadToken;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.SystemConfig;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by Administrator on 2017/12/27.
 */
public class LoginInterceptor extends HandlerInterceptorAdapter {
    @Autowired
    private Memory memory;

    private static final PathMatcher PATH_MATCHER = new AntPathMatcher();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //如果是登录页面则放行
        if (!checkAllowAccess(request.getRequestURI())) {
            // 检查请求的token值是否为空
            String token = getTokenFromRequest(request);
            if (StringUtils.isEmpty(token) || !memory.checkLoginUser(token)) {
                request.getRequestDispatcher("/user/nologin").forward(request, response);
                return false;
            } else {
                // 保存当前token，用于Controller层获取登录用户信息
                ThreadToken.setToken(token);
                response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                response.setCharacterEncoding("UTF-8");
                response.setHeader("Cache-Control", "no-cache, must-revalidate");
                return true;
            }
        }
        return true;
    }


    /**
     * 检查URI是否放行
     *
     * @return 返回检查结果
     */
    private boolean checkAllowAccess(String URI) {
        for (String allow : SystemConfig.allowUrlList) {
            if (PATH_MATCHER.match(allow, URI)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 从请求信息中获取token值
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        // 默认从Cookie里获取token值
        Cookie[] cookies = request.getCookies();
        String token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                String cookieName = cookie.getName();
                if (CommConst.ACCESS_CPFR_TOKEN.equals(cookieName)) {
                    token = cookie.getValue();
                    System.out.println("从cookie中获取token:" + token);
                }
            }
        }
        if (StringUtils.isEmpty(token)) {
            token = request.getHeader(CommConst.ACCESS_CPFR_TOKEN);
            System.out.println("从header中获取token:" + token);
            if (StringUtils.isEmpty(token)) {
                // 从请求信息中获取token值
                token = request.getParameter(CommConst.ACCESS_CPFR_TOKEN);
                System.out.println("从url中获取token:" + token);
            }
        }

        return token;
    }
}
