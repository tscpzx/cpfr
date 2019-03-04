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
public class WebSocketInterceptor implements HandshakeInterceptor {

    /**
     * 握手前
     */
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler webSocketHandler, Map<String, Object> attributes) {
        try {
            System.out.println("握手前");
            if (request instanceof ServletServerHttpRequest) {
                HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
                String deviceSn = servletRequest.getHeader(CommConst.DEVICE_SN);
                if (TextUtils.isEmpty(deviceSn))
                    deviceSn = servletRequest.getParameter(CommConst.DEVICE_SN);

                if (TextUtils.isEmpty(deviceSn))
                    return false;
                attributes.put(CommConst.DEVICE_SN, deviceSn);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 握手后
     */
    @Override
    public void afterHandshake(ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse, WebSocketHandler webSocketHandler, Exception e) {
        System.out.println("握手后");
    }
}
