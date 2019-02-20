<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp"%>
<el-form label-width="120px">
    <el-form-item label="${group_id_lang}">
        <span>{{group.group_id}}</span>
    </el-form-item>
    <el-form-item label="${group_name}">
        <el-input v-model="groupModel.group_name" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="${create_time}">
        <span>{{group.create_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="${operation}">
        <el-button size="small" type="success" @click="updateGroupInfo">${cancel_lang}</el-button>
        <el-button size="small" type="danger" @click="deleteGroup">${delete}</el-button>
    </el-form-item>
</el-form>