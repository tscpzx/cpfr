package com.ts.cpfr.websocket;

import com.ts.cpfr.spring.WebSocketHandshakeInterceptor;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.WebSocketHandler;
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
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        System.out.println("==========================注册socket");
        //注册websocket server实现类，"/webSocketServer"访问websocket的地址
        registry.addHandler(msgSocketHandle(), "/webSocketServer")
          .addInterceptors(new WebSocketHandshakeInterceptor());
        //使用socketjs的注册方法
        registry.addHandler(msgSocketHandle(), "/sockjs/webSocketServer")
          .addInterceptors(new WebSocketHandshakeInterceptor())
          .withSockJS();
    }

    /**
     * @return 消息发送的Bean
     */
    @Bean(name = "msgSocketHandle")
    public WebSocketHandler msgSocketHandle() {
        return new MsgScoketHandle();
    }
}
