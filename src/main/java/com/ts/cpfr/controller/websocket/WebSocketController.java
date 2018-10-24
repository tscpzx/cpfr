package com.ts.cpfr.controller.websocket;

import com.ts.cpfr.controller.base.BaseController;
import com.ts.cpfr.websocket.MsgScoketHandle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.socket.TextMessage;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname WebSocketController
 * @Description
 * @Date 2018/10/23 11:06
 * @Created by cjw
 */
@Controller
@RequestMapping("/websocket")
public class WebSocketController extends BaseController{
    @Autowired
    private MsgScoketHandle msgScoketHandle;

    @RequestMapping("/login")
    public String login(HttpServletRequest request){
        request.getSession().setAttribute("user_id",request.getParameter("user_id"));
        return "/index";
    }

    @ResponseBody
    @RequestMapping("/sendMsg")
    public String sendMag(String content,String user_id){
        TextMessage textMessage = new TextMessage(content);
        msgScoketHandle.sendMessageToUser(user_id,textMessage);
        return "200";
    }
}
