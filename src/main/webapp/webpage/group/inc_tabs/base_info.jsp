<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="120px">
    <el-form-item label="组ID:">
        <span>{{group.group_id}}</span>
    </el-form-item>
    <el-form-item label="组名:">
        <el-input v-model="groupModel.group_name" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="创建时间:">
        <span>{{group.create_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="组别操作:">
        <el-button size="small" type="success" @click="updateGroupInfo">保存</el-button>
        <el-button size="small" type="danger" @click="deleteGroup">删除</el-button>
    </el-form-item>
</el-form>