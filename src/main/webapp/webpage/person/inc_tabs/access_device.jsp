<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form>
    <el-form-item>
        <el-row>
            <el-button type="primary" icon="el-icon-plus" size="small">添加</el-button>
            <div style="float: right">
                <el-input style="width: 200px;" size="small" placeholder="请输入搜索内容" v-model="searchVal"></el-input>
                <el-button type="primary" size="small" @click="searchDevice(searchVal)">查找</el-button>
            </div>
        </el-row>
    </el-form-item>
</el-form>

<template>
    <el-table :data="tableData" style="width: 100%" stripe>
        <el-table-column prop="grant_id" label="权限ID" v-if="show" >
        </el-table-column>
        <el-table-column prop="device_id" label="设备ID" >
        </el-table-column>
        <el-table-column prop="device_name" label="设备名称" >
        </el-table-column>
        <el-table-column prop="pass_number" label="通行次数">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_number===9999999999">无限次数</span>
                <span v-else>{{scope.row.pass_number}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_start_time" label="通行时段" width="320">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_start_time==='2286-11-21 01:46:39'||scope.row.pass_end_time==='2286-11-21 01:46:39'">无限时段</span>
                <span v-if="scope.row.pass_start_time!=='2286-11-21 01:46:39'">{{scope.row.pass_start_time}} 至 {{scope.row.pass_start_time}}</span>
            </template>
        </el-table-column>

        <el-table-column label="操作" width="150">
            <template slot-scope="scope">
                <el-button type="success" size="small" @click="openDialogUpdateGrant(scope.row)">修改</el-button>
                <el-button type="danger" size="small" @click="banGrantDevice(scope)">禁止</el-button>
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
                       prev-text="上一页"
                       next-text="下一页"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="tableTotal">
        </el-pagination>
    </div>
</template>
