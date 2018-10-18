package com.ts.cpfr.spring;

import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.SystemConfig;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

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
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache, must-revalidate");
            if (StringUtils.isEmpty(token)) {
                request.setAttribute("message", "Token不能为空");
            } else if (!memory.checkLoginUser(token)) {
                request.setAttribute("message", "Session已过期，请重新登录");
            }

            request.getRequestDispatcher("/user/nologin").forward(request, response);
            return false;
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
        // 默认从header里获取token值
        String token = request.getHeader(CommConst.TOKEN);
        if (StringUtils.isEmpty(token)) {
            // 从请求信息中获取token值
            token = request.getParameter(CommConst.TOKEN);
        }
        return token;
    }
}
