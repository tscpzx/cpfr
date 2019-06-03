<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<el-form>
    <el-form-item>
        <el-button type="primary" icon="el-icon-plus" @click="openDialogPerson" size="small">${add}</el-button>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData1" style="width: 100%" stripe>
        <el-table-column prop="person_id" label="${people_id}">
        </el-table-column>
        <el-table-column prop="person_name" label="${name}">
        </el-table-column>
        <el-table-column prop="emp_number" label="${job_number}">
        </el-table-column>
        <el-table-column label="进组时间">
            <template slot-scope="scope">
                <i class="el-icon-time"></i>
                <span style="margin-left: 10px">{{ scope.row.add_group_time}}</span>
            </template>
        </el-table-column>
        <el-table-column label="${operation}">
            <template slot-scope="scope">
                <el-button size="small" type="danger" @click="deleteGroupPerson(scope.row)">${remove_lang}</el-button>
            </template>
        </el-table-column>
    </el-table>
</template>

<template>
    <div class="block">
        <el-pagination ref="pagination1"
                       @size-change="handleChange1"
                       @current-change="handleChange1"
                       :current-page.sync="currentPage1"
                       :page-size.sync="pageSize1"
                       :page-sizes="pageSizes1"
                       prev-text="${previous_page_lang}"
                       next-text="${next_page_lang}"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="total1">
        </el-pagination>
    </div>
</template>