<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/resource/inc/lang.jsp" %>
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
            <el-breadcrumb-item>${equ_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${device_not_activated}</el-breadcrumb-item>
            <el-breadcrumb-item>${data.device_sn}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form label-width="200px">
            <el-form-item label="${devise_serial_number}">
                <span>${data.device_sn}</span>
            </el-form-item>
            <el-form-item label="${author_code}">
                <el-input id="input_grant_key" value="${data.mac_grant_key}" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="${registration_time}">
                <span>${data.register_time}</span>
            </el-form-item>
            <el-form-item label="${online}">
                <c:if test="${data.online==1}"> <span>${online}</span></c:if>
                <c:if test="${data.online==0}"> <span>${offline}</span></c:if>
            </el-form-item>
            <el-form-item label="${active_state}">
                <c:if test="${data.status==1}">
                    <span>${activated}</span>
                </c:if>
                <c:if test="${data.status==0}">
                    <span>${inactivated}</span>
                    <el-button type="primary" round id="btn_active">${activation}</el-button>
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
            layTip("${device_cannot_empty}");
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
                    $("#device_content").load("${pageContext.request.contextPath}/device/inact_detail?device_sn=" +'${data.device_sn}');
                }
            }
        })
    });
</script>
