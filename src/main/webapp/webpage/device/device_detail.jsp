<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .device_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }
</style>
<div class="device_detail_box">
    <div id="device_detail">
        <el-form label-width="150px">
            <el-form-item label="设备序列号:">
                <el-input value="${data.device_sn}" :disabled="true" type="text" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="设备名称:">
                <el-input value="${data.device_name}" type="text" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="授权码:">
                <el-input value="${data.mac_grant_key}" :disabled="true" type="text" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="在线:">
                <c:if test="${data.online==1}"> <span>在线</span></c:if>
                <c:if test="${data.online==0}"> <span>离线</span></c:if>
            </el-form-item>
        </el-form>
    </div>
</div>

<script type="text/javascript">
    new Vue({
        el: "#device_detail"
    })
</script>
