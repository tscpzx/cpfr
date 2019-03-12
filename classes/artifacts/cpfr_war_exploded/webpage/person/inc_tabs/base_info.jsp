<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<el-form label-width="150px" :model="personModel" ref="perBaseInfoForm" :rules="rules">
    <el-form-item label="${people_id}">
        <span>{{data.person_id}}</span>
    </el-form-item>
    <el-form-item label="${registration_time}">
        <span>{{data.add_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="${name}" prop="person_name">
        <el-input v-bind:value="data.person_name" v-model="personModel.person_name" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="${job_number}">
        <el-input :value="data.emp_number" v-model="personModel.emp_number" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="${the_bottom_picture}">
        <%--<img class="image" :src="'data:image/jpeg;base64,'+data.base_image">--%>
        <el-upload class="avatar-uploader"
                   :action="action"
                   :show-file-list="true"
                   :http-request="myUpload"
                   :auto-upload="false"
                   :on-change="onChange"
                   :before-upload="beforeUpload"
                   ref="upload">
            <img v-if="imageUrl" :src="imageUrl" class="image avatar">
        </el-upload>
    </el-form-item>
    <el-form-item label="">
        <el-button type="primary" size="small" @click="onClickUpload()"> ${save}</el-button>
        <el-button type="danger" size="small" @click="deletePerson()">${delete}</el-button>
    </el-form-item>
</el-form>
<%@include file="../inc_dialog/dialog_cropper.jsp" %>
