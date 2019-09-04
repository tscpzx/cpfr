package com.ts.cpfr.websocket;

import com.ts.cpfr.spring.WebSocketInterceptor;
import com.ts.cpfr.utils.SystemConfig;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * @Classname WebSocketConfig
 * @Description websocket服务端实现类
 * @Date 2018/10/23 9:54
 * @Created by cjw
 */
@Component
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {

    private Logger mLogger = LoggerFactory.getLogger(WebSocketConfig.class);
    //需要用注入的方式，SocketMessageHandle才能交给spring管理
    @Autowired
    SocketMessageHandle handle;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        mLogger.info("==========================socket配置==========================");
        //注册websocket server实现类，"/webSocketServer"访问websocket的地址
        registry.addHandler(handle, SystemConfig.WEB_SOCKET_URL).addInterceptors(new WebSocketInterceptor());
        //使用socketjs的注册方法 兼容低端浏览器,不加还不行？
        //        registry.addHandler(handle, SystemConfig.WEB_SOCKET_URL + "/sockjs")
        //          .addInterceptors(new WsHandshakeInterceptor())
        //          .withSockJS();
    }
}
