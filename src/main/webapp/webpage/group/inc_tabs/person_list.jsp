<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="20px">
    <el-form-item>
        <el-button type="primary" icon="el-icon-plus" @click="openDialogPerson">添加</el-button>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData1" style="width: 100%" stripe>
        <el-table-column prop="person_id" label="人员ID" width="100">
        </el-table-column>
        <el-table-column prop="person_name" label="姓名" width="100">
        </el-table-column>
        <el-table-column prop="emp_number" label="工号" width="100">
        </el-table-column>
        <el-table-column label="底库图片" width="120">
            <template slot-scope="scope">
                <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                <%--<img class="image_tbl" v-bind:src="'${pageContext.request.contextPath}/person/image?image_path='+scope.row.image_path">--%>
            </template>
        </el-table-column>
        <el-table-column label="操作">
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
                       prev-text="上一页"
                       next-text="下一页"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="data.person_list.length">
        </el-pagination>
    </div>
</template>