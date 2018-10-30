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
            width: 250px;
            height: 100%;
        }
    </style>
</head>
<body>
<!--包裹层-->
<div class="navMenuBox">

    <div class="input-group">
        <input type="text" class="form-control" placeholder="Search for...">
        <span class="input-group-btn">
        <button class="btn btn-default" type="button">go</button>
      </span>
    </div>

    <!--一级菜单-->
    <ul class="navMenu">
        <!--菜单项-->
        <li>
            <!--arrow类给具有下级菜单项添加箭头图标-->
            <a href="#" class="arrow">未激活设备</a>
            <!--子菜单-->
            <ul class="subMenu" v-cloak id="inact_device_list">
                <li v-for="data in items" v-on:click="onClickItem(data)">
                    <a href="#">{{data.device_sn}}</a>
                </li>
            </ul>
        </li>
        <li>
            <!--arrow类给具有下级菜单项添加箭头图标-->
            <a href="#" class="arrow">设备列表</a>
        </li>
    </ul>
</div>
<script type="text/javascript">
    ajaxInActDeviceList();

    var listVm = new Vue({
        el: "#inact_device_list",
        data: {
            items: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
                l(1)
            }
        }
    });

    function ajaxInActDeviceList() {
        var loading = layLoading1();
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact/list",
            data: {},
            success: function (result) {
                layer.close(loading);
                l(result);
                if (checkSession(result)) {
                    listVm.items = result.data;
                    $(".navMenu li:first").addClass("active");
                    $(".navMenu li:first .subMenu").slideDown();
                }
            }
        });
    }

</script>
</body>
</html>
