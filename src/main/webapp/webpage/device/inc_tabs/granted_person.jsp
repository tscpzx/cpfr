<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<template>
    <el-table :data="tableData1" style="width: 100%" stripe>
        <el-table-column prop="person_id" label="人员ID">
        </el-table-column>
        <el-table-column prop="person_name" label="姓名">
        </el-table-column>
        <el-table-column prop="emp_number" label="工号">
        </el-table-column>
        <el-table-column prop="type" label="是否通行">
            <template slot-scope="scope">
                <span v-if="scope.row.type===1">允许</span>
                <span v-if="scope.row.type===0">禁止</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_number" label="通行次数">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_number===9999999999">无限次数</span>
                <span v-else>{{scope.row.pass_number}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_start_time" label="通行时段" width="400">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_start_time==='2286-11-21 01:46:39'||scope.row.pass_end_time==='2286-11-21 01:46:39'">无限时段</span>
                <span v-if="scope.row.pass_start_time!=='2286-11-21 01:46:39'">{{scope.row.pass_start_time}} 至 {{scope.row.pass_start_time}}</span>
            </template>
        </el-table-column>
        <el-table-column label="操作">
            <template slot-scope="scope">
                <el-button type="success" size="small">修改</el-button>
                <el-button type="danger" size="small">删除</el-button>
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
                       prev-text="上一页"
                       next-text="下一页"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="tableTotal">
        </el-pagination>
    </div>
</template>