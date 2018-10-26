package com.ts.cpfr.websocket;

import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.ParamData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.PongMessage;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


/**
 * @Classname SocketMessageHandle
 * @Description socket处理消息类
 * @Date 2018/10/23 10:12
 * @Created by cjw
 */
@Component
public class SocketMessageHandle implements WebSocketHandler {

    @Autowired
    DeviceService mDeviceService;
    /**
     * 已经连接的用户map
     */
    private static ConcurrentHashMap<String, WebSocketSession> userMap;

    static {
        userMap = new ConcurrentHashMap<>();
    }

    /**
     * 建立链接
     *
     * @param webSocketSession
     * @throws Exception
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession webSocketSession) throws Exception {
        //将用户信息添加到map中
        Map<String, Object> attributes = webSocketSession.getAttributes();
        if (attributes != null) {
            String deviceSn = (String) attributes.get(CommConst.DEVICE_SN);
            userMap.put(deviceSn, webSocketSession);
            System.out.println("=====================建立连接成功==========================");
            System.out.println("当前连接设备======" + deviceSn);
            System.out.println("设备连接数量=====" + userMap.size());
            ParamData pd = new ParamData();
            pd.put(CommConst.DEVICE_SN, deviceSn);
            pd.put("online", 1);
            mDeviceService.updateInactDeviceOnline(pd);
        }
    }

    /**
     * 接收消息
     *
     * @param webSocketSession
     * @throws Exception
     */
    @Override
    public void handleMessage(WebSocketSession webSocketSession, WebSocketMessage<?> message) throws Exception {
        Map<String, Object> attributes = webSocketSession.getAttributes();
        if (attributes != null) {
            String deviceSn = (String) attributes.get(CommConst.DEVICE_SN);
            if (message instanceof TextMessage) {
                System.out.println("TextMessage消息");
            } else if (message instanceof BinaryMessage) {
                System.out.println("BinaryMessage的消息");
            } else if (message instanceof PongMessage) {
                System.out.println("BinaryMessage的消息");
            } else {
                throw new IllegalStateException("Unexpected WebSocket message type: " + message);
            }
            System.out.println("收到用户:" + deviceSn + "的消息");
            System.out.println(message.getPayload().toString());


            sendMessageToDevice(deviceSn, new TextMessage("服务端收到了"));
            System.out.println("===========================================");
        }
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
        Map<String, Object> attributes = webSocketSession.getAttributes();
        if (attributes != null) {
            String deviceSn = (String) attributes.get(CommConst.DEVICE_SN);
            userMap.remove(deviceSn);
        }
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
        //移除用户
        Map<String, Object> attributes = webSocketSession.getAttributes();
        if (attributes != null) {
            String deviceSn = (String) attributes.get(CommConst.DEVICE_SN);
            userMap.remove(deviceSn);
            System.out.println(deviceSn + "断开连接");
            ParamData pd = new ParamData();
            pd.put(CommConst.DEVICE_SN, deviceSn);
            pd.put("online", 0);
            mDeviceService.updateInactDeviceOnline(pd);
        }

    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }

    /**
     * 发送消息给指定的用户
     */
    public void sendMessageToDevice(String toDeviceSn, TextMessage messageInfo) throws IOException {
        Iterator<Map.Entry<String, WebSocketSession>> it = userMap.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, WebSocketSession> next = it.next();
            if (next.getKey().equals(toDeviceSn)) {
                WebSocketSession socketSession = next.getValue();
                if (socketSession.isOpen()) {
                    socketSession.sendMessage(messageInfo);
                    System.out.println("发送消息给：" + toDeviceSn + "内容：" + messageInfo);
                }
            }
        }
    }
}
