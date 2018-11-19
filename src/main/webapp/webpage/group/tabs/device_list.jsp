<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="20px">
    <el-form-item>
        <el-button type="primary" icon="el-icon-plus" id="">添加</el-button>
    </el-form-item>
</el-form>
<template>
    <el-table :data="tableData2" style="width: 100%" stripe>
        <el-table-column prop="device_id" label="设备ID" width="100">
        </el-table-column>
        <el-table-column prop="device_name" label="设备名称" width="150">
        </el-table-column>
        <el-table-column prop="online" label="在线" width="100">
        </el-table-column>
        <el-table-column prop="device_sn" label="设备序列号" width="150">
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
                       prev-text="上一页"
                       next-text="下一页"
                       layout="total, sizes, prev, pager, next, jumper"
                       :total="data.device_list.length">
        </el-pagination>
    </div>
</template>
