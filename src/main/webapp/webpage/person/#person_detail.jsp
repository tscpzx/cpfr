<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>

    <style type="text/css">
        .person_info_box {
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
<div class="person_info_box">
    <ul class="nav nav-tabs">
        <li class="active">
            <a href="#base_info" data-toggle="tab">基本信息</a>
        </li>
        <li><a href="#grant_device" data-toggle="tab">可通行设备</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade in active" id="base_info">
            <div class="div_group">
                <label>人员ID：&nbsp;</label>
                <span>${data.person_id}</span>
            </div>
            <div class="div_group">
                <label>添加时间：&nbsp;</label>
                <span>${data.add_time}</span>
            </div>
            <div class="div_group">
                <label>姓名：&nbsp;</label>
                <input type="text" class="form-control" readonly="readonly" value="${data.person_name}">
            </div>
            <div class="div_group">
                <label>工号：&nbsp;</label>
                <input type="text" class="form-control" readonly="readonly" value="${data.emp_number}">
            </div>
            <div class="div_group">
                <label>底库图片：&nbsp;</label>
                <img class="image" src="data:image/jpeg;base64,${data.base_image}">
            </div>
        </div>

        <div class="tab-pane fade" id="grant_device">
        </div>

    </div>
</div>

<script type="text/javascript">
</script>
</body>
</html>
