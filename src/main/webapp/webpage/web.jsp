<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>

    <style type="text/css">
    </style>
</head>
<body>
<div class="nav background-color">
    <h4 align="left" class="nav_title"><%=CommConst.WEB_TITLE%>
    </h4>
</div>
<button type="button" class="btn btn-primary logout">注销</button>

<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>device_sn</th>
            </tr>
        </thead>
        <tbody v-cloak id="list">
            <tr v-for="data in items" v-on:click="onClickItem(data)">
                <td>{{data.device_sn}}</td>
            </tr>
        </tbody>
    </table>
</div>
<script type="text/javascript">
    // ajaxDeviceList();
    ajaxInActDeviceList();

    var listVm=new Vue({
        el:"#list",
        data:{
            items:[],
            searching:true
        },
        methods:{
            onClickItem:function (data) {
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
                    listVm.items=result.data;
                }
            }
        });
    }


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
                layTip(data.message);
            }
        });
    }
</script>
</body>
</html>
