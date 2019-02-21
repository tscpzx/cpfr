package com.ts.cpfr.spring;

import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.utils.CommUtil;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by Administrator on 2017/12/27.
 */
public class WebInterceptor extends HandlerInterceptorAdapter {
    @Autowired
    private WebMemory memory;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 检查请求的token值是否为空
        String token = CommUtil.getTokenFromRequest(request);
        if (StringUtils.isEmpty(token) || !memory.checkCache(token)) {
            request.getRequestDispatcher("/user/nologin").forward(request, response);
            return false;
        }
        return true;
    }
}
