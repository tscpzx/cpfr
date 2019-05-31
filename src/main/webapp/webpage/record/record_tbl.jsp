<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .record_tbl_box {
        padding: 20px;
        text-align: center;
    }

    .el-form-item {
        text-align: left;
    }
</style>


<div class="record_tbl_box">
    <div id="record_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${record_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${record_list}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form onsubmit="return false;">
            <el-form-item>
                <el-row>
                    <el-button type="primary" size="small" @click="deleteRecordLists">${delete_in_batches}
                    </el-button>
                    <el-button type="danger" size="small" @click="clearRecord">${clear_record}</el-button>
                    <div style="float: right">
                        <el-input style="width: 200px;" v-model="keyword" size="small"
                                  placeholder="${search_content}" @keyup.enter.native="selectRecord"></el-input>
                        <el-button type="primary" icon="el-icon-search" size="small" @click="selectRecord"></el-button>

                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table ref="multipleTable" :data="tableData" style="width: 100%"
                      @selection-change="handleSelectionChange" stripe>
                <el-table-column type="selection"></el-table-column>
                <el-table-column prop="record_id" label="${id}">
                </el-table-column>
                <el-table-column prop="person_name" label="${name}">
                </el-table-column>
                <el-table-column prop="device_name" label="${device}">
                </el-table-column>
                <el-table-column label="${mode}">
                    <template slot-scope="scope">
                        <span v-if="scope.row.recog_type==0">${human_face}</span>
                        <span v-if="scope.row.recog_type==1">${id_card}</span>
                        <span v-if="scope.row.recog_type==2">${job_number}</span>
                        <span v-if="scope.row.recog_type==3">${face_and_card}</span>
                        <span v-if="scope.row.recog_type==4">${face_and_num}</span>
                    </template>
                </el-table-column>
                <el-table-column label="${recognition_time}">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.record_time|formatDate }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="${reg_picture}">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                    </template>
                </el-table-column>
                <el-table-column label="${operation}">
                    <template slot-scope="scope">
                        <el-button type="danger" size="small" @click="deleteRecordById(scope)">${delete}</el-button>
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
    var vDevice_id = null;
    if ("undefined" !=${model.device_id}) {
        vDevice_id =
        ${model.device_id}
    }
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
            multipleSelection: []
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

                var arr = [];
                if (this.multipleSelection.length === 0) {
                    layAlert1("${tick_record}");
                } else {
                    this.multipleSelection.forEach(function (item) {
                        arr.push(item.record_id);
                    });
                    var record_ids = arr.join(',');
                    elmDialog("${delete_selected_record}", function () {
                        ajaxGet({
                            url: "${pageContext.request.contextPath}/record/deleteLists",
                            data: {
                                record_ids: record_ids
                            },
                            success: function (result) {
                                layAlert1(result.message);
                                ajaxRecordList({
                                    pageNum: vm.currentPage,
                                    pageSize: vm.pageSize,
                                });
                            }
                        });
                    });
                }
            },
            clearRecord() {
                elmDialog("${sure_clear_records}", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/record/clear",
                        success: function (result) {
                            layAlert1(result.message);
                            ajaxRecordList({
                                pageNum: vm.currentPage,
                                pageSize: vm.pageSize,
                            });
                        }
                    });

                });

            },

            deleteRecordById(scope) {
                elmDialog("${delete_record}", function () {
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
        pageSize: vm.pageSize,
        device_id: vDevice_id
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
