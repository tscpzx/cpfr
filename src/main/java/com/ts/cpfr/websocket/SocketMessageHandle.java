package com.ts.cpfr.websocket;

import com.alibaba.fastjson.JSONObject;
import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.entity.AppDevice;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.SocketEnum;

import org.apache.commons.lang.StringUtils;
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
import java.util.HashMap;
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

    private static final int STATUS_0_DEVICE_INACTIVAT = 0;
    private static final int STATUS_1_DEVICE_ACTIVATED = 1;
    private static final int STATUS_0_DEVICE_OFFLINE = 0;
    private static final int STATUS_1_DEVICE_ONLINE = 1;

    @Autowired
    DeviceService mDeviceService;
    @Autowired
    AppMemory mAppMemory;
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

            //判断设备是否已激活
            ParamData pd = new ParamData();
            pd.put(CommConst.DEVICE_SN, deviceSn);
            pd.put("online", STATUS_1_DEVICE_ONLINE);
            //更新设备在线状态
            mDeviceService.updateDeviceOnline(pd);
            //已激活
            if (STATUS_1_DEVICE_ACTIVATED == (int) pd.get("device_status")) {
                //保存缓存
                AppDevice device = new AppDevice(deviceSn, (int) pd.get("wid"));
                mAppMemory.putCache(device);
                //返回token给app端
                ParamData data = new ParamData();
                data.put(CommConst.ACCESS_APP_TOKEN, device.getToken());
                sendMessageToDevice(deviceSn, obtainMessage(SocketEnum.CODE_1006_ACCESS_APP_TOKEN, data));
                sendMessageToDevice(deviceSn, obtainMessage(SocketEnum.CODE_1002_DEVICE_UPDATE, null));
            } else {
                sendMessageToDevice(deviceSn, obtainMessage(SocketEnum.CODE_1007_DEVICE_INACT, null));
            }
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
        throwable.printStackTrace();
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
            System.out.println(deviceSn + "断开连接error");

            ParamData pd = new ParamData();
            pd.put(CommConst.DEVICE_SN, deviceSn);
            pd.put("online", STATUS_0_DEVICE_OFFLINE);
            mAppMemory.removeCache(deviceSn);
            mDeviceService.updateDeviceOnline(pd);
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
            System.out.println(deviceSn + "断开连接Closed");
            ParamData pd = new ParamData();
            pd.put(CommConst.DEVICE_SN, deviceSn);
            pd.put("online", STATUS_0_DEVICE_OFFLINE);
            mAppMemory.removeCache(deviceSn);
            mDeviceService.updateDeviceOnline(pd);
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
        if (!StringUtils.isEmpty(toDeviceSn)) {
            WebSocketSession socketSession = userMap.get(toDeviceSn);
            if (socketSession != null && socketSession.isOpen()) {
                socketSession.sendMessage(messageInfo);
                System.out.println("发送消息给：" + toDeviceSn + "内容：" + messageInfo);
            }
        }
    }

    /**
     * @param code
     * @param message
     * @param data
     * @return
     */
    public TextMessage obtainMessage(int code, String message, ParamData data) {
        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put(CommConst.CODE, code);
        if (data == null)
            jsonMap.put(CommConst.DATA, "");
        else
            jsonMap.put(CommConst.DATA, data);
        jsonMap.put(CommConst.MESSAGE, message);
        return new TextMessage(JSONObject.toJSONString(jsonMap));
    }


    public TextMessage obtainMessage(SocketEnum socketEnum, ParamData data) {
        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put(CommConst.CODE, socketEnum.getCode());
        jsonMap.put(CommConst.DATA, data);
        jsonMap.put(CommConst.MESSAGE, socketEnum.getMessage());
        return new TextMessage(JSONObject.toJSONString(jsonMap));
    }
}
