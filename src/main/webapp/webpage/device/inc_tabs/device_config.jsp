<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<el-form label-width="100px" v-model="deviceModel">
    <el-form-item label="${device_name}">
        <el-input v-model="deviceModel.device_name" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="${open_condition}">
        <el-select v-model="deviceModel.open_door_type" placeholder="${please_choose}" size="small">
            <el-option
                    v-for="item in options1"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
            </el-option>
        </el-select>
    </el-form-item>
    <el-form-item label="${success_text}">
        <el-input v-model="deviceModel.success_msg" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="${fail_text}">
        <el-input v-model="deviceModel.fail_msg" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="">
        <el-button size="small" type="success" @click="changeDeviceInfo">${save}</el-button>
        <el-button size="small" @click="restoreDeviceInfo">${cancel_lang}</el-button>
    </el-form-item>
</el-form>