<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="100px" v-model="configModel">
    <el-form-item label="设备名称:">
        <el-input v-bind:value="device.device_name" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="开门条件:">
        <el-select v-model="configModel.open_door_type" placeholder="请选择" size="small">
            <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
            </el-option>
        </el-select>
    </el-form-item>
    <el-form-item label="成功文本:">
        <el-input v-bind:value="device.success_msg" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="失败文本:">
        <el-input v-bind:value="device.fail_msg" type="text" autocomplete="off" size="small"></el-input>
    </el-form-item>
    <el-form-item label="">
        <el-button size="small" type="success">保存</el-button>
        <el-button size="small">取消</el-button>
    </el-form-item>
</el-form>