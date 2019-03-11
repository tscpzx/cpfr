<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attendance_box {
        padding: 20px;
        text-align: center;
    }
    .el-form-item {
        text-align: left;
    }
</style>


<div class="attendance_box">
    <div id="attendance_report">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attendance_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attendance_report}</el-breadcrumb-item>
        </el-breadcrumb>
    </div>
</div>


<script type="text/javascript">
    var vm = new Vue({
        el: "#attendance_report",

    });
</script>