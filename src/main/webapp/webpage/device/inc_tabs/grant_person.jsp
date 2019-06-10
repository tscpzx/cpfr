<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form>
    <el-form-item>
        <el-row>
            <el-select v-model="selectGroupModel" clearable placeholder="请选择部门" size="small" @change="changeSelectGroup">
                <el-option
                        v-for="item in options2"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                </el-option>
            </el-select>
            <el-button type="primary" icon="el-icon-plus" @click="openDialogPerson" size="small">${add}</el-button>
            <div style="float: right">
                <el-input style="width: 200px;" size="small" v-model="keyword"
                          placeholder="${search_content}"></el-input>
                <el-button type="primary" size="small" @click="selectGrantPersonList">${search}</el-button>
            </div>
        </el-row>
    </el-form-item>
</el-form>
<template>
    <el-table :data="tableData1" style="width: 100%" stripe>
        <el-table-column prop="grant_id" label="${author_id}" min-width="5%">
        </el-table-column>
        <el-table-column prop="person_name" label="${name}" min-width="10%">
        </el-table-column>
        <el-table-column prop="emp_number" label="${job_number}" min-width="10%" >
        </el-table-column>
        <el-table-column prop="sync_status" label="同步状态" min-width="15%" >
            <template slot-scope="scope">
                <span v-if="scope.row.sync_status===0">未同步</span>
                <span v-if="scope.row.sync_status===1">同步成功</span>
                <span v-if="scope.row.sync_status===2">下载失败</span>
                <span v-if="scope.row.sync_status===3">图片失败</span>
                <span v-if="scope.row.sync_status===4">特征值失败</span>
                <span v-if="scope.row.sync_status===5">其他失败</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_number" label="${pass_time}" min-width="15%">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_number===9999999999">${unlimited_number_time}</span>
                <span v-else>{{scope.row.pass_number}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="pass_start_time" label="${passage_period}" min-width="25%">
            <template slot-scope="scope">
                <span v-if="scope.row.pass_start_time==='2286-11-21 01:46:39'||scope.row.pass_end_time==='2286-11-21 01:46:39'">${infinite_time}</span>
                <span v-if="scope.row.pass_start_time!=='2286-11-21 01:46:39'">{{scope.row.pass_start_time}} ${to_lang} {{scope.row.pass_end_time}}</span>
            </template>
        </el-table-column>
        <el-table-column label="${operation}" min-width="20%">
            <template slot-scope="scope">
                <el-button type="success" size="small" @click="openDialogChangeGrant(scope.row)">${modify}</el-button>
                <el-button type="danger" size="small" @click="banGrantPerson(scope)">${ban}</el-button>
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
                       :total="tableTotal">
        </el-pagination>
    </div>
</template>