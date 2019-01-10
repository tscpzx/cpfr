<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<template>
    <el-transfer
            filterable :filter-method="filterMethod1"
            filter-placeholder="请输入人员关键字"
            v-model="value1" :data="person_list" :props="props1"
            :titles="['可选人员', '授权人员']"
            :button-texts="['移除', '添加']">
    </el-transfer>
    <el-transfer
            filterable :filter-method="filterMethod2"
            filter-placeholder="请输入设备关键字"
            v-model="value2" :data="device_list" :props="props2"
            :titles="['授权设备', '可选设备']"
            :button-texts="['添加', '移除']">
    </el-transfer>

    <el-form label-width="150px" style="margin-top: 30px;width: 500px;" size="small">
        <el-form-item label="通行次数">
            <el-radio-group v-model="radio1" @change="onChangeRadio">
                <el-radio label="1">指定次数</el-radio>
                <el-radio label="2">无限次数</el-radio>
            </el-radio-group>
            <el-input  v-model="pass_number" autocomplete="off" placeholder="请输入次数" style="width: 100%;display: none;" class="input_pass_number"></el-input>
        </el-form-item>
        <el-form-item label="通行时间">
            <el-radio-group v-model="radio2" @change="onChangeRadio">
                <el-radio label="3">指定时间</el-radio>
                <el-radio label="4">无限时间</el-radio>
            </el-radio-group>

            <el-date-picker
                    class="date_picker_pass_number"
                    style="display: none;"
                    v-model="dateValue"
                    type="datetimerange"
                    range-separator="至"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="">
            <el-button type="primary" @click="grantPass()">授权通行</el-button>
            <el-button type="danger" @click="banPass()">禁止通行</el-button>
        </el-form-item>
    </el-form>

</template>