<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>
    <!--navMenu-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/navMenu.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/navMenu.js"></script>
    <style type="text/css">
        .navMenuBox {
            height: 100%;
        }

        .input-group {
            margin: 15px 10px 15px 10px;
        }

        .i_circle {
            float: left;
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background-color: #4cae4c;
            margin: 15px 0 15px 10px;
        }

    </style>
</head>
<body>
<table style="width:100%;height: 100%;">
    <tr>
        <td width="250px;">
            <!--包裹层-->
            <div class="navMenuBox">

                <div class="input-group">
                    <input type="text" class="form-control" placeholder="搜索设备">
                    <span class="input-group-btn">
                        <button class="btn btn-default" type="button">搜索</button>
                      </span>
                </div>

                <!--一级菜单-->
                <ul class="navMenu">
                    <!--菜单项-->
                    <li>
                        <a href="#" class="arrow">未激活设备</a>
                        <!--子菜单-->
                        <ul class="subMenu" v-cloak id="inact_device_list">
                            <li v-for="data in items" v-on:click="onClickItem(data)">
                                <i v-if="data.online==1" class="i_circle"></i><a v-bind:href="'${pageContext.request.contextPath}/device/inact/detail?device_sn='+data.device_sn" target="if_device">{{data.device_sn}}</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#" class="arrow">设备列表</a>
                        <!--子菜单-->
                        <ul class="subMenu" v-cloak id="device_list">
                            <li v-for="data in items" v-on:click="onClickItem(data)">
                                <i v-if="data.online==1" class="i_circle"></i><a v-bind:href="'${pageContext.request.contextPath}/device/detail?device_sn='+data.device_sn" target="if_device">{{data.device_sn}}</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </td>
        <td>
            <iframe class="if_window" name="if_device"></iframe>
        </td>
    </tr>
</table>
<script type="text/javascript">
    ajaxInActDeviceList();
    ajaxDeviceList();

    var vueInactDeviceList = new Vue({
        el: "#inact_device_list",
        data: {
            items: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        }
    });

    function ajaxInActDeviceList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact/list",
            data: {},
            success: function (result) {
                vueInactDeviceList.items = result.data;
                $(".navMenu li:first").addClass("active");
                $(".navMenu li:first .subMenu").slideDown();
            }
        });
    }

    var vueDeviceList = new Vue({
        el: "#device_list",
        data: {
            items: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        }
    });

    function ajaxDeviceList() {

        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (result) {
                vueDeviceList.items = result.data;
            }
        });
    }

</script>
</body>
</html>
