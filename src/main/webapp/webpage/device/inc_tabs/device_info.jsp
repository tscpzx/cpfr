<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="150px">
    <el-form-item label="设备SN编号:">
        <span>{{device.device_sn}}</span>
    </el-form-item>
    <el-form-item label="在线:">
        <span v-if="device.online===1">在线</span>
        <span v-if="device.online===0">离线</span>
    </el-form-item>
    <el-form-item label="授权码:">
        <span>{{device.mac_grant_key}}</span>
    </el-form-item>
    <el-form-item label="注册时间:">
        <span>{{device.register_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="激活时间:">
        <span>{{device.activate_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="最后一次上线时间:">
        <span>{{device.last_online_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="最后一次下线时间:">
        <span>{{device.last_offine_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="设备操作:">
        <el-button size="small" type="danger" @click="deleteDevice">删除</el-button>
    </el-form-item>
</el-form>