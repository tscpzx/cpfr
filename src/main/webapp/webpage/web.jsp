<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/sockjs.min.js"></script>
</head>
<body>
<button type="button" class="btn btn-primary logout">注销</button>

<input type="text" id="text">
<button id="btn1" value="发送给后台">发送给后台</button>
<button id="btn2" value="发送给其他用户">发送给其他用户</button>
<button id="btn3" value="登录">登录</button>
<div id="msg"></div>
<script type="text/javascript">
    $(function () {
        var ws;
        if ('WebSocket' in window) {
            ws = new WebSocket("ws://" + window.location.host + "/webSocketServer?user_id=1234");
        } else if ('MozWebSocket' in window) {
            ws = new MozWebSocket("ws://" + window.location.host + "/webSocketServer");
        } else {
            //如果是低版本的浏览器，则用SockJS这个对象，对应了后台“sockjs/webSocketServer”这个注册器，
            //它就是用来兼容低版本浏览器的
            ws = new SockJS("http://" + window.location.host + "/sockjs/webSocketServer");
        }
        ws.onopen = function (evnt) {
            console.log(evnt);
        };
        //接收到消息
        ws.onmessage = function (evnt) {
            console.log(evnt.data);
            $("#msg").html(evnt.data);
        };
        ws.onerror = function (evnt) {
            console.log(evnt)
        };
        ws.onclose = function (evnt) {
            console.log(evnt);
        }

        $("#btn1").click(function () {

            ws.send($("#text").val());
        });
        $("#btn2").bind("click", function () {
            var url = "${pageContext.request.contextPath}/websocket/sendMsg";
            var content = $("#text").val();
            var user_id = "123";
            $.ajax({
                data: "content=" + content + "&user_id=" + user_id,
                type: "get",
                dataType: 'text',
                async: false,
                contentType: "application/x-www-form-urlencoded;charset=UTF-8",
                encoding: "UTF-8",
                url: url,
                success: function (data) {
                    console.log(data.toString());
                },
                error: function (msg) {
                    console.log(msg);
                }
            });
        });
        $("#btn3").bind("click", function () {
            var url = "${pageContext.request.contextPath}/websocket/login";
            var user_id = "123";
            $.ajax({
                data: "user_id=" + user_id,
                type: "get",
                dataType: 'text',
                async: false,
                contentType: "application/x-www-form-urlencoded;charset=UTF-8",
                encoding: "UTF-8",
                url: url,
                success: function (data) {
                    console.log(data.toString());
                },
                error: function (msg) {
                    console.log(msg);
                }
            });
        })
    });

</script>
<script type="text/javascript">
    // ajaxDeviceList();

    function ajaxDeviceList() {
        var loading = layLoading1();
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (data) {
                layer.close(loading);
                l(data);
                if (checkSession(data)) {
                }
            }
        });
    }

    $('.logout').click(function () {
        ajaxLogout();
    });

    function ajaxLogout() {
        var loading = layLoading1();
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/logout",
            data: {},
            success: function (data) {
                layer.close(loading);
                l(data);
            }
        });
    }
</script>
</body>
</html>
