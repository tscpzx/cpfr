<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="150px">
    <el-form-item label="人员ID:">
        <span>{{data.person_id}}</span>
    </el-form-item>
    <el-form-item label="注册时间:">
        <span>{{data.add_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="姓名:">
        <el-input v-bind:value="data.person_name" :disabled="true" type="text" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="工号:">
        <el-input :value="data.emp_number" :disabled="true" type="text" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="底库图片:">
        <img class="image" :src="'data:image/jpeg;base64,'+data.base_image">
    </el-form-item>
    <el-form-item label="">
        <el-button type="primary" size="small" @click="clickBase(1)">编辑</el-button>
        <el-button type="danger" size="small" @click="clickBase(0)">删除</el-button>
    </el-form-item>
</el-form>
