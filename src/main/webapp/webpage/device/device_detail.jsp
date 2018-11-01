<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>

    <style type="text/css">
        .device_info_box {
            padding: 20px;
        }

        .form-control {
            width: 400px;
            display: inline-block;
        }

        .div_group {
            margin: 10px 10px 20px 10px;
        }

        .div_group label {
            width: 150px;
            line-height: 32px;
            text-align: right;
            padding-right: 10px;
            font-size: 14px;
            color: #606266;
            font-weight: 500;
        }

        #btn_active {
            width: 100px;
            margin-left: 20px;
        }
    </style>
</head>
<body>
<div class="device_info_box">
    <div class="div_group">
        <label>设备指纹：&nbsp;</label>
        <input type="text" class="form-control" placeholder="" readonly="readonly" value="${data.device_sn}">
    </div>
    <div class="div_group">
        <label>设备授权码：&nbsp;</label>
        <input type="text" id="input_grant_key" class="form-control" placeholder="">
    </div>
    <div class="div_group">
        <label>注册时间：&nbsp;</label>
        <span>${data.register_time}</span>
    </div>
    <div class="div_group">
        <label>激活状态：&nbsp;</label>
        <c:choose>
            <c:when test="${data.status==0}">
                <span>未激活</span>
                <button id="btn_active" type="button" class="btn btn-success">激活
                </button>
            </c:when>
            <c:otherwise>
                <span>已激活</span>
                <button id="btn_active" type="button" class="btn btn-success" disabled="disabled">
                    已激活
                </button>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script type="text/javascript">
    $('#btn_active').click(function () {
        var mac_grant_key = $('#input_grant_key').val().trim();
        if (!mac_grant_key) {
            layTip("设备授权码不能为空");
            return;
        }
        ajaxPost({
            url: "${pageContext.request.contextPath}/device/activate",
            data: {
                device_sn: '${data.device_sn}',
                mac_grant_key: mac_grant_key
            },
            success: function (result) {
                layAlert1(result.message);
                if (0 === result.code) {
                    parent.location.reload();
                }
            }
        })
    });
</script>
</body>
</html>
