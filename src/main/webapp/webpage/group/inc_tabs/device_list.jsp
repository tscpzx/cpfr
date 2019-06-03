<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp"%>
<el-form>
    <el-form-item>
        <el-button type="primary" icon="el-icon-plus" @click="openDialogDevice" size="small">${add}</el-button>
    </el-form-item>
</el-form>
<template>
    <el-table :data="tableData2" style="width: 100%" stripe>
        <el-table-column prop="device_id" label="${device_id}">
        </el-table-column>
        <el-table-column prop="device_name" label="${device_name}">
        </el-table-column>
        <el-table-column prop="device_sn" label="${devise_serial_number}">
        </el-table-column>
        <el-table-column prop="online" label="${online}">
            <template slot-scope="scope">
                <span v-if="scope.row.online===1">${online}</span>
                <span v-if="scope.row.online===0">${offline}</span>
            </template>
        </el-table-column>
        <el-table-column label="进组时间">
            <template slot-scope="scope">
                <i class="el-icon-time"></i>
                <span style="margin-left: 10px">{{ scope.row.add_group_time}}</span>
            </template>
        </el-table-column>
        <el-table-column label="${operation}">
            <template slot-scope="scope">
                <el-button size="small" type="danger" @click="deleteGroupDevice(scope.row)">${remove_lang}</el-button>
            </template>
        </el-table-column>
    </el-table>
</template>

<template>
    <div class="block">
        <el-pagination ref="pagination2"
                       @size-change="handleChange2"
                       @current-change="handleChange2"
                       :current-page.sync="currentPage2"
                       :page-size.sync="pageSize2"
                       :page-sizes="pageSizes2"
                       prev-text="${previous_page_lang}"
                       next-text="${next_page_lang}"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="total2">
        </el-pagination>
    </div>
</template>
