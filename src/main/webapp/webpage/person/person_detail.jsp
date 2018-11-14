<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .person_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

    .div_group {
        margin: 10px 0 10px 0;
    }

    .div_group label {
        width: 150px;
        text-align: right;
        float: left;
        font-size: 14px;
        color: #606266;
        line-height: 40px;
        padding: 0 12px 0 0;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
    }
</style>
<div class="person_detail_box">
    <div id="person_detail">
        <el-form label-width="150px">
            <el-form-item label="人员ID:">
                <span>${data.person_id}</span>
            </el-form-item>
            <el-form-item label="注册时间:">
                <span>${data.add_time}</span>
            </el-form-item>
            <el-form-item label="姓名:">
                <el-input value="${data.person_name}" :disabled="true" type="text" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="工号:">
                <el-input value="${data.emp_number}" :disabled="true" type="text" autocomplete="off"></el-input>
            </el-form-item>
        </el-form>
    </div>
    <div class="div_group">
        <label>底库图片:</label>
        <img class="image" src="data:image/jpeg;base64,${data.base_image}">
    </div>
</div>

<script type="text/javascript">
    new Vue({
        el: "#person_detail"
    });
</script>