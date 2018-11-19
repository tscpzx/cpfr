<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="60px">
    <el-form-item label="组ID:">
        <span>{{group.group_id}}</span>
    </el-form-item>
    <el-form-item label="组名:">
        <el-input id="" v-bind:value="group.group_name" type="text" autocomplete="off"></el-input>
    </el-form-item>
</el-form>