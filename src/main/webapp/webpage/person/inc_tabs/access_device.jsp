<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<el-form>
    <el-form-item>
        <el-row>
       <%--     <el-button type="primary" icon="el-icon-plus" size="small">添加</el-button>--%>
            <div style="float: right">
                <spring:message code="please_enter_the_search_content" var = "search_content"/>
                <el-input style="width: 200px;" size="small" placeholder="${search_content}" v-model="keyword"></el-input>
                <el-button type="primary" size="small" @click="searchDeviceLists"><spring:message code="search"/></el-button>
            </div>
        </el-row>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData" style="width: 100%" stripe>
        <el-table-column prop="grant_id" label="权限ID" v-if="show" >
        </el-table-column>
        <spring:message code="device_id" var="device_id"/>
        <el-table-column prop="device_id" label="${device_id}" >
        </el-table-column>
        <spring:message code="device_name" var="device_name"/>
        <el-table-column prop="device_name" label="${device_name}" >
        </el-table-column>
        <spring:message code="pass_time" var="pass_time"/>
        <el-table-column prop="pass_number" label="${pass_time}">
            <template slot-scope="scope">

                <span v-if="scope.row.pass_number===9999999999"> <spring:message code="unlimited_number_of_times"/></span>
                <span v-else>{{scope.row.pass_number}}</span>
            </template>
        </el-table-column>
        <spring:message code="passage_period" var="passage_period"/>
        <el-table-column prop="pass_start_time" label="${passage_period}" width="320">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_start_time==='2286-11-21 01:46:39'||scope.row.pass_end_time==='2286-11-21 01:46:39'"> <spring:message code="infinite_time" /></span>
                <span v-if="scope.row.pass_start_time!=='2286-11-21 01:46:39'">{{scope.row.pass_start_time}} 至 {{scope.row.pass_start_time}}</span>
            </template>
        </el-table-column>
        <spring:message code="operation" var="operation"/>
        <el-table-column label="${operation}" width="150">
            <template slot-scope="scope">
                <el-button type="success" size="small" @click="openDialogUpdateGrant(scope.row)"> <spring:message code="modify"/></el-button>
                <el-button type="danger" size="small" @click="banGrantDevice(scope)"> <spring:message code="ban"/></el-button>
            </template>
        </el-table-column>
    </el-table>
</template>

<template>
    <div class="block">
        <spring:message code="next_page" var="next_page_lang"/>
        <spring:message code="previous_page" var="previous_page_lang"/>
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
