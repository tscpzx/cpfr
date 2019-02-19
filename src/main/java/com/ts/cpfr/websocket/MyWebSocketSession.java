package com.ts.cpfr.websocket;

import org.springframework.http.HttpHeaders;
import org.springframework.web.socket.adapter.standard.StandardWebSocketSession;

import java.io.Serializable;
import java.net.InetSocketAddress;
import java.security.Principal;
import java.util.Map;

/**
 * @Classname MyWebSocketSession
 * @Description
 * @Date 2019/2/19 14:31
 * @Created by cjw
 */
public class MyWebSocketSession extends StandardWebSocketSession implements Serializable {
    public MyWebSocketSession(HttpHeaders headers, Map<String, Object> attributes, InetSocketAddress localAddress, InetSocketAddress remoteAddress) {
        super(headers, attributes, localAddress, remoteAddress);
    }

    public MyWebSocketSession(HttpHeaders headers, Map<String, Object> attributes, InetSocketAddress localAddress, InetSocketAddress remoteAddress, Principal user) {
        super(headers, attributes, localAddress, remoteAddress, user);
    }
}
