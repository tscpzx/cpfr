<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .record_tbl_box {
        padding: 20px;
        text-align: center;
    }

    .record_tbl_box .el-table {
        margin: 0 auto;
    }

    .el-form-item {
        text-align: left;
    }
</style>
<div class="record_tbl_box">
    <div id="record_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>记录管理</el-breadcrumb-item>
            <el-breadcrumb-item>记录列表</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <el-button type="primary" size="small" @click="deleteRecordLists">批量删除
                    </el-button>
                    <div style="float: right">
                        <el-input style="width: 200px;" v-model="keyword" size="small" placeholder="请输入搜索内容"></el-input>
                        <el-button type="primary" size="small" @click="selectRecord">查找
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table ref="multipleTable" :data="tableData" style="width: 100%"
                      @selection-change="handleSelectionChange" stripe>
                <el-table-column type="selection">全选/全不选
                </el-table-column>
                <el-table-column prop="record_id" label="ID">
                </el-table-column>
                <el-table-column prop="person_name" label="姓名">
                </el-table-column>
                <el-table-column prop="device_name" label="设备">
                </el-table-column>
                <el-table-column label="识别模式">
                    <template slot-scope="scope">
                        <span v-if="scope.row.recog_type==0">人脸</span>
                        <span v-if="scope.row.recog_type==1">身份证</span>
                        <span v-if="scope.row.recog_type==2">工号</span>
                        <span v-if="scope.row.recog_type==3">人脸+身份证</span>
                        <span v-if="scope.row.recog_type==4">人脸+工号</span>
                    </template>
                </el-table-column>
                <el-table-column label="识别时间">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.record_time|formatDate }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="识别图片">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                    </template>
                </el-table-column>
                <el-table-column label="操作">
                    <template slot-scope="scope">
                        <el-button type="danger" size="small" @click="deleteRecordById(scope)">删除</el-button>
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
                               :total="total">
                </el-pagination>
            </div>
        </template>
    </div>
</div>

<script type="text/javascript">
    var vm = new Vue({
        el: "#record_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 5,
            total: '',
            keyword: '',
            multipleSelection: [],
            recordIds: [],
            i: 0
        },
        methods: {
            handleChange(val) {
                ajaxRecordList({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize
                });
            },
            selectRecord() {
                ajaxRecordList({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    keyword: this.keyword
                });
            },
            handleSelectionChange(val) {
                this.multipleSelection = val;
            },
            deleteRecordLists() {
                let record_ids = [];
                if (this.multipleSelection.length == 0) {
                    layAlert1("请勾选待删除记录");
                } else {
                    this.multipleSelection.forEach(function (item) {
                        record_ids.push(item.record_id);
                    });
                    l(record_ids);
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/record/deleteLists",
                        data: {
                            record_ids: record_ids
                        },
                        success: function (result) {
                            layAlert1(result.message);
                            arrayRemoveObj(vm.tableData, this.multipleSelection);
                            vm.total--;
                        }
                    });
                }


            },

            deleteRecordById(scope) {
                elmDialog("确定删除该条记录吗？", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/record/delete",
                        data: {
                            record_id: scope.row.record_id
                        },
                        success: function (result) {
                            layAlert1(result.message);
                            arrayRemoveObj(vm.tableData, scope.row);
                            vm.total--;
                        }
                    });
                });
            }
        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });

    ajaxRecordList({
        pageNum: vm.currentPage,
        pageSize: vm.pageSize
    });

    function ajaxRecordList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/record/list_base64",
            data: data,
            success: function (result) {
                vm.total = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }
</script>
