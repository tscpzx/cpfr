<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_box {
        padding: 20px;
        text-align: center;
    }
    .el-form-item {
        text-align: left;
    }
</style>


<div class="attend_box">
    <div id="attend_report">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attend_report}</el-breadcrumb-item>
        </el-breadcrumb>
    </div>
</div>


<script type="text/javascript">
    var vm = new Vue({
        el: "#attend_report",

    });
</script>