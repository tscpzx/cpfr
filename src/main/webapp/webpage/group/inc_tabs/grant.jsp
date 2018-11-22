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

    <el-form label-width="60px" style="margin-top: 30px;">
        <el-row>
            <el-button type="primary" @click="clickGrantPass">授权通行</el-button>
            <el-button type="danger" @click="clickGrantBan">禁止通行</el-button>
        </el-row>
    </el-form>

</template>