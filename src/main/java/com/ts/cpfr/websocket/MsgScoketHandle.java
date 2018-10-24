package com.ts.cpfr.websocket;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.ArrayList;

/**
 * @Classname MsgScoketHandle
 * @Description socket处理消息类
 * @Date 2018/10/23 10:12
 * @Created by cjw
 */
@Component
public class MsgScoketHandle implements WebSocketHandler {

    /**
     * 已经连接的用户
     */
    private static final ArrayList<WebSocketSession> users;

    static {
        //保存当前连接用户
        users = new ArrayList<WebSocketSession>();
    }

    /**
     * 建立链接
     *
     * @param webSocketSession
     * @throws Exception
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession webSocketSession) throws Exception {
        //将用户信息添加到list中
        users.add(webSocketSession);
        System.out.println("=====================建立连接成功==========================");
        String user_id = (String) webSocketSession.getAttributes().get("user_id");
            System.out.println("当前连接用户======" + user_id);
        System.out.println("webSocket连接数量=====" + users.size());
    }

    /**
     * 接收消息
     *
     * @param webSocketSession
     * @param webSocketMessage
     * @throws Exception
     */
    @Override
    public void handleMessage(WebSocketSession webSocketSession, WebSocketMessage<?> webSocketMessage) throws Exception {
        String user_id = (String) webSocketSession.getAttributes().get("user_id");
        System.out.println("收到用户:" + user_id + "的消息");
        System.out.println(webSocketMessage.getPayload().toString());
        System.out.println("===========================================");

    }

    /**
     * 异常处理
     *
     * @param webSocketSession
     * @param throwable
     * @throws Exception
     */
    @Override
    public void handleTransportError(WebSocketSession webSocketSession, Throwable throwable) {
        if (webSocketSession.isOpen()) {
            //关闭session
            try {
                webSocketSession.close();
            } catch (IOException e) {
            }
        }
        //移除用户
        users.remove(webSocketSession);
    }

    /**
     * 断开链接
     *
     * @param webSocketSession
     * @param closeStatus
     * @throws Exception
     */
    @Override
    public void afterConnectionClosed(WebSocketSession webSocketSession, CloseStatus closeStatus) throws Exception {
        users.remove(webSocketSession);
        String user_id = (String) webSocketSession.getAttributes().get("user_id");
        System.out.println(user_id + "断开连接");
    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }

    /**
     * 发送消息给指定的用户
     */
    public void sendMessageToUser(String to_id, TextMessage messageInfo) {
        for (WebSocketSession session : users) {
            String user_id = (String) session.getAttributes().get("user_id");
            //根据用户名去判断用户接收消息的用户
            if (to_id.equals(user_id) ) {
                try {
                    if (session.isOpen()) {
                        session.sendMessage(messageInfo);
                        System.out.println("发送消息给：" + user_id + "内容：" + messageInfo);
                    }
                    break;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
