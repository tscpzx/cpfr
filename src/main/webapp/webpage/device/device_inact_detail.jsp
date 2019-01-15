<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .device_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

    #btn_active {
        margin-left: 20px;
    }
</style>
<div class="device_detail_box">
    <div id="device_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>设备管理</el-breadcrumb-item>
            <el-breadcrumb-item>未激活设备</el-breadcrumb-item>
            <el-breadcrumb-item>${data.device_sn}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form label-width="120px">
            <el-form-item label="设备序列号:">
                <span>${data.device_sn}</span>
            </el-form-item>
            <el-form-item label="授权码:">
                <el-input id="input_grant_key" value="${data.mac_grant_key}" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="注册时间:">
                <span>${data.register_time}</span>
            </el-form-item>
            <el-form-item label="在线:">
                <c:if test="${data.online==1}"> <span>在线</span></c:if>
                <c:if test="${data.online==0}"> <span>离线</span></c:if>
            </el-form-item>
            <el-form-item label="激活状态:">
                <c:if test="${data.status==1}">
                    <span>已激活</span>
                </c:if>
                <c:if test="${data.status==0}">
                    <span>未激活</span>
                    <el-button type="primary" round id="btn_active">激活</el-button>
                </c:if>
            </el-form-item>
        </el-form>
    </div>
</div>

<script type="text/javascript">
    new Vue({
        el: "#device_detail"
    });
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
                    $("#device_tree").load("device/device_tree");
                    $("#device_content").load("${pageContext.request.contextPath}/device/inact_detail?device_sn=" +${data.device_sn});
                }
            }
        })
    });
</script>
