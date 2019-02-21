package com.ts.cpfr.spring;

import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.utils.CommConst;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname AppInterceptor
 * @Description
 * @Date 2019/2/18 16:49
 * @Created by cjw
 */
public class AppInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    private AppMemory memory;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 检查请求的token值是否为空
        String token = getTokenFromRequest(request);
        if (StringUtils.isEmpty(token) || !memory.checkCache(token)) {
            request.getRequestDispatcher("/app/disconnect").forward(request, response);
            return false;
        }
        return true;
    }

    /**
     * 从请求信息中获取token值
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String token = request.getHeader(CommConst.ACCESS_APP_TOKEN);
        if (StringUtils.isEmpty(token)) {
            // 从请求信息中获取token值
            token = request.getParameter(CommConst.ACCESS_APP_TOKEN);
        }

        return token;
    }
}
