package com.ts.cpfr.spring;

import com.ts.cpfr.utils.CommConst;

import org.apache.http.util.TextUtils;
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
public class WsHandshakeInterceptor implements HandshakeInterceptor {

    /**
     * 握手前
     */
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler webSocketHandler, Map<String, Object> attributes) throws Exception {
        System.out.println("握手前");
        if (request instanceof ServletServerHttpRequest) {
            HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
            String device_sn = servletRequest.getHeader(CommConst.DEVICE_SN);
            if (TextUtils.isEmpty(device_sn)) {
                device_sn = servletRequest.getParameter(CommConst.DEVICE_SN);
            }
            attributes.put("device_sn", device_sn);
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
