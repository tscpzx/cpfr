<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <!--avMenu-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/navMenu.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/navMenu.js"></script>
    <style type="text/css">
        .nav {
            height: 52px;
        }

        .main_body {
            height: calc(100vh - 52px);
        }

        .menu ul {
            width: 100%;
            height: calc(100% - 52px);
        }

        .if_window {
            width: 100%;
            height: 99.9%;
            border: 0;
            padding-top: 1px;
        }

        .font_white_15 {
            color: white;
            font-size: 15px;
        }

        .font_center {
            display: inline-block;
            width: 100%;
            text-align: center;
        }

        .navMenuBox {
            height: 100%;
            background-color: #333743;
        }

        .navMenu > li > a, .subMenu > li > a {
            color: white;
            padding: 15px 0 15px 10px;
        }

        .navMenu > li > a:before {
            display: block;
            float: left;
            margin: 0 5px;
            font-size: 20px;
            line-height: 40px;
            font-family: FontAwesome;
            font-weight: 300;
            text-shadow: none;
        }

        .navMenu > li.active > a,
        .navMenu > li > a:hover,
        .subMenu > li.active > a,
        .subMenu > li > a:hover {
            color: white;
            background-color: #292C36;
        }
    </style>
</head>
<body>
<div class="container">
    <%-- 导航栏 --%>
    <div class="nav">
        <table width="100%" style="height: 100%;">
            <tr>
                <td width="50%">
                    <h4 align="left" class="nav_title"><%=CommConst.WEB_TITLE%>
                    </h4>
                </td>
                <td></td>
                <td id="username" width="8%">
                    <div class="font_white_15 font_center">${sessionScope.user.name},您好!</div>
                </td>
                <td id="change_password" width="8%">
                    <a href="#" class="font_white_15 font_center">修改密码</a>
                </td>
                <td id="logout" width="8%">
                    <a href="#" class="font_white_15 font_center" onclick="ajaxLogout()">退出登录</a>
                </td>
            </tr>
        </table>
    </div>

    <%-- 主body --%>
    <div class="main_body">
        <table width="100%" style="height: 100%;">
            <tr>
                <td width="12.5%" class="menu">
                    <div class="navMenuBox">
                        <!--一级菜单-->
                        <ul class="navMenu">
                            <!--菜单项-->
                            <li>
                                <a href="device/device.jsp" class="fa-microchip" target="iframe_window">设备管理</a>
                            </li>
                            <li>
                                <a href="#" class="fa-user arrow">人员管理</a>
                                <!--子菜单-->
                                <ul class="subMenu">
                                    <li><a href="#">人员列表</a></li>
                                    <li><a href="#">批量上传</a></li>
                                </ul>
                            </li>
                            <li><a href="#" class="fa-group">分组管理</a></li>
                            <li><a href="#" class="fa-newspaper-o">记录管理</a></li>
                            <li><a href="#" class="fa-address-book-o">账号管理</a></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <iframe class="if_window" name="iframe_window"></iframe>
                </td>
            </tr>
        </table>
    </div>
</div>
<script type="text/javascript">
    function ajaxLogout() {
        var loading = layLoading1();
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/logout",
            data: {},
            success: function (data) {
                layer.close(loading);
                l(data);
                layTip(data.message);
                if (0 === data.code) {
                    window.location.href = "login";
                }
            }
        });
    }
</script>
</body>
</html>
