<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form>
    <el-form-item>
        <el-row>
            <el-button type="primary" icon="el-icon-plus" size="small">添加</el-button>
            <div style="float: right">
                <el-input style="width: 200px;" size="medium" placeholder="请输入搜索内容"></el-input>
                <el-button type="primary" size="small">查找</el-button>
            </div>
        </el-row>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData" style="width: 100%" stripe>
        <el-table-column prop="device" label="设备" >
        </el-table-column>
        <el-table-column prop="access_time" label="通行时间" >
        </el-table-column>
        <el-table-column prop="access_num" label="通行次数">
        </el-table-column>
        <el-table-column prop="time_name" label="时段名称" >
        </el-table-column>
        <el-table-column prop="time_name" label="操作">
        </el-table-column>
    </el-table>
</template>
