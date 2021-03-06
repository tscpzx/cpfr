<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="200px">
    <el-form-item label="${sn_number}">
        <span>{{device.device_sn}}</span>
    </el-form-item>
    <el-form-item label="${online}">
        <span v-if="device.online===1">${online}</span>
        <span v-if="device.online===0">${offline}</span>
    </el-form-item>
    <el-form-item label="${author_code}">
        <span>{{device.arcface_appid}}</span>
    </el-form-item>
    <el-form-item label="${registration_time}">
        <span>{{device.register_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="${active_time}">
        <span>{{device.activate_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="${last_online}">
        <span>{{device.last_online_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="${last_offline}">
        <span>{{device.last_offline_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="同步成功">
        <span>{{device.sync_success}}</span>
    </el-form-item>
    <el-form-item label="同步失败">
        <span>{{device.sync_fail}}</span>
    </el-form-item>
    <el-form-item label="未同步">
        <span>{{device.without_sync}}</span>
    </el-form-item>
    <el-form-item label="当前app版本">
        <span>{{device.app_version}}</span>
        <el-button size="small" type="success" @click="checkUpdate">更新</el-button>
    </el-form-item>
    <el-form-item label="${operation}">
        <el-button size="small" type="danger" @click="deleteDevice">${delete}</el-button>
    </el-form-item>
</el-form>