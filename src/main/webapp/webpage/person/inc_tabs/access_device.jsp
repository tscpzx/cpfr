<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<el-form>
    <el-form-item>
        <el-row>
            <%--     <el-button type="primary" icon="el-icon-plus" size="small">添加</el-button>--%>
            <div style="float: right">
                <el-input style="width: 200px;" size="small" placeholder="${search_content}"
                          v-model="keyword"></el-input>
                <el-button type="primary" size="small" @click="searchDeviceLists">${search}</el-button>
            </div>
        </el-row>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData" style="width: 100%" stripe>
        <el-table-column prop="grant_id" label="权限ID" v-if="show">
        </el-table-column>
        <el-table-column prop="device_id" label="${device_id}">
        </el-table-column>
        <el-table-column prop="device_name" label="${device_name}">
        </el-table-column>
        <el-table-column prop="pass_number" label="${pass_time}">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_number===9999999999">${unlimited_number_time}</span>
                <span v-else>{{scope.row.pass_number}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_start_time" label="${passage_period}" width="320">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_start_time==='2286-11-21 01:46:39'||scope.row.pass_end_time==='2286-11-21 01:46:39'"> ${infinite_time}</span>
                <span v-if="scope.row.pass_start_time!=='2286-11-21 01:46:39'">{{scope.row.pass_start_time}} 至 {{scope.row.pass_start_time}}</span>
            </template>
        </el-table-column>
        <el-table-column label="${operation}" width="160">
            <template slot-scope="scope">
                <el-button type="success" size="small" @click="openDialogUpdateGrant(scope.row)"> ${modify}</el-button>
                <el-button type="danger" size="small" @click="banGrantDevice(scope)"> ${ban}</el-button>
            </template>
        </el-table-column>
    </el-table>
</template>

<template>
    <div class="block">
        <el-pagination ref="pagination"
                       @size-change="handleChange"
                       @current-change="handleChange"
                       :current-page.sync="currentPage"
                       :page-size.sync="pageSize"
                       :page-sizes="pageSizes"
                       prev-text="${previous_page_lang}"
                       next-text="${next_page_lang}"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="tableTotal">
        </el-pagination>
    </div>
</template>
