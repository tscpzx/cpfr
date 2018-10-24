package com.ts.cpfr.spring;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname WebSocketHandshakeInterceptor
 * @Description 主要是获取到当前连接的用户，并把用户保存到WebSocketSession中
 * @Date 2018/10/23 10:05
 * @Created by cjw
 */
public class WebSocketHandshakeInterceptor implements HandshakeInterceptor {

    /**
     * 握手前
     */
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler webSocketHandler, Map<String, Object> attributes) throws Exception {
        System.out.println("握手前");
        if (request instanceof ServletServerHttpRequest) {
            HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
//            if(servletRequest.getContextPath().contains("/webSocketServer"))return true;
//            HttpSession session = servletRequest.getSession(false);
//            if (session != null) {
//                //从session中获取当前用户
//                int user_id = (Integer) session.getAttribute("user_id");
//                System.out.println("user_id"+user_id);
//                attributes.put("user_id", user_id);
//            }
            attributes.put("user_id",servletRequest.getParameter("user_id"));
        }
        return true;
    }

    /**
     * 握手后
     */
    @Override
    public void afterHandshake(ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse, WebSocketHandler webSocketHandler, Exception e) {
        System.out.println("握手后");
    }
}
