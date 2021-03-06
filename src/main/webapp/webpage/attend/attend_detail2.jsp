<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_box {
        padding: 20px;
    }

</style>


<div class="attend_box">
    <div id="attend_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attend_details}</el-breadcrumb-item>
        </el-breadcrumb>
        <template>
            <el-form ref="form" :model="form">
                <el-form-item label="时间范围：">
                    <el-radio-group v-model="form.resource">
                        <el-radio label="今天"></el-radio>
                        <el-radio label="昨天"></el-radio>
                        <el-radio label="本周"></el-radio>
                        <el-radio label="本月"></el-radio>
                    </el-radio-group>
                    <el-date-picker type="date" placeholder="选择日期" v-model="form.date1"
                                    style="margin-left: 20px" size="small"></el-date-picker>
                </el-form-item>
                <el-form-item>
                    <el-select v-model="form.value" clearable placeholder="请选择部门" size="small">
                        <el-option
                                v-for="item in options"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                    <el-input style="width: 200px;margin-left: 30px" v-model="form.keyword" size="small"
                              placeholder="请输入工号/姓名" @keyup.enter.native="selectattend"></el-input>
                    <el-button type="primary" size="small" @click="selectattend">${search}
                    </el-button>
                    <el-button type="success" size="small" @click="exportLists" style="float: right">导出
                    </el-button>
                </el-form-item>

            </el-form>
        </template>

        <template>
            <el-table ref="multipleTable" :data="tableData" style="width: 100%"
                      @selection-change="handleSelectionChange" stripe>
                <el-table-column prop="number_id" label="工号">
                </el-table-column>
                <el-table-column prop="person_name" label="${name}">
                </el-table-column>
                <el-table-column prop="on_work" label="上班打卡">
                </el-table-column>
                <el-table-column prop="off_work" label="下班打卡">
                </el-table-column>
                <el-table-column prop="device" label="设备">
                </el-table-column>
                <el-table-column prop="status" label="状态">
                </el-table-column>
            </el-table>
        </template>

        <template>
            <div class="block" style="text-align: center">
                <el-pagination ref="pagination"
                               @size-change="handleChange"
                               @current-change="handleChange"
                               :current-page.sync="currentPage"
                               :page-size.sync="pageSize"
                               :page-sizes="pageSizes"
                               prev-text="${previous_page_lang}"
                               next-text="${next_page_lang}"
                               layout="total, sizes, prev, pager, next, jumper"
                               :total="total">
                </el-pagination>
            </div>
        </template>
    </div>
</div>


<script type="text/javascript">
    var vm = new Vue({
        el: "#attend_detail",
        data: function () {
            return {
                form: {
                    resource: '今天',
                    date: '',
                    value: '',
                    keyword: ''
                },
                tableData: [],
                currentPage: 1,
                pageSizes: [5, 10, 20],
                pageSize: 5,
                total: '',
                multipleSelection: [],
                departList: [],
                options: []
            }
        },


        methods: {
            selectattend() {

            }
            ,
            handleChange(val) {
                ajaxRecordList({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize
                });
            }
            ,
            handleSelectionChange(val) {
                this.multipleSelection = val;
            }
            ,
            exportLists() {

            },


        }
    });

    ajaxDepartLists();

    function ajaxDepartLists() {
        ajaxPost({
            url: "${pageContext.request.contextPath}/group/list",
            data: {},
            async: false,
            success: function (result) {
                var list = [];
                for (var i = 0; i < result.data.list.length; i++) {
                    list[i] = {
                        label: result.data.list[i].group_name,
                        value: result.data.list[i].group_name
                    }
                }
                vm.options = list;
            }
        });
    }

</script>
