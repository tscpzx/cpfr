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
    </style>
</head>
<body>
<div class="device_info_box">
    <ul class="nav nav-tabs">
        <li class="active">
            <a href="#base_info" data-toggle="tab">基本信息</a>
        </li>
        <li><a href="#fun_config" data-toggle="tab">功能配置</a></li>
        <li><a href="#grant_person" data-toggle="tab">授权人员</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade in active" id="base_info">
            <div class="div_group">
                <label>设备编号：&nbsp;</label>
                <span>${data.device_sn}</span>
            </div>
            <div class="div_group">
                <label>设备名称：&nbsp;</label>
                <span>${data.device_name}</span>
            </div>
            <div class="div_group">
                <label>授权码：&nbsp;</label>
                <span>${data.mac_grant_key}</span>
            </div>
            <div class="div_group">
                <label>在线：&nbsp;</label>
                <c:if test="${data.online==1}"> <span>在线</span></c:if>
                <c:if test="${data.online==0}"> <span>离线</span></c:if>
            </div>
        </div>

        <div class="tab-pane fade" id="fun_config">
            <div class="div_group">
                <label>设备序列号：&nbsp;</label>
                <input type="text" class="form-control" readonly="readonly" value="${data.device_sn}">
            </div>
            <div class="div_group">
                <label>设备授权码：&nbsp;</label>
                <input type="text" class="form-control" readonly="readonly" value="${data.mac_grant_key}">
            </div>
            <div class="div_group">
                <label>设备名：&nbsp;</label>
                <input type="text" class="form-control" placeholder="输入设备名" value="${data.device_name}">
            </div>
        </div>

        <div class="tab-pane fade" id="grant_person">
            <p>iOS 是一个由苹果公司开发和发布的手机操作系统。最初是于 2007 年首次发布 iPhone、iPod Touch 和 Apple
                TV。iOS 派生自 OS X，它们共享 Darwin 基础。OS X 操作系统是用在苹果电脑上，iOS 是苹果的移动版本。</p>
        </div>
    </div>
</div>

<script type="text/javascript">
</script>
</body>
</html>
