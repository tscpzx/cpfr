<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
            <el-breadcrumb-item><spring:message code="record_management"/></el-breadcrumb-item>
            <el-breadcrumb-item><spring:message code="record_list"/></el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <el-button type="primary" size="small" @click="deleteRecordLists"><spring:message code="delete_in_batches"/>
                    </el-button>
                    <div style="float: right">
                        <spring:message code="please_enter_the_search_content" var="search_content"/>

                        <el-input style="width: 200px;" v-model="keyword" size="small" placeholder="${search_content}"></el-input>
                        <el-button type="primary" size="small" @click="selectRecord"><spring:message code="search"/>
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table ref="multipleTable" :data="tableData" style="width: 100%"
                      @selection-change="handleSelectionChange" stripe>
                <el-table-column type="selection"></el-table-column>
                <spring:message code="id" var="id"/>
                <el-table-column prop="record_id" label="${id}">
                </el-table-column>
                <spring:message code="name" var="name"/>
                <el-table-column prop="person_name" label="${name}">
                </el-table-column>
                <spring:message code="device" var="device"/>
                <el-table-column prop="device_name" label="${device}">
                </el-table-column>
                <spring:message code="recognition_mode" var="mode"/>
                <el-table-column label="${mode}">
                    <template slot-scope="scope">
                        <span v-if="scope.row.recog_type==0"><spring:message code="human_face"/></span>
                        <span v-if="scope.row.recog_type==1"><spring:message code="id_card"/></span>
                        <span v-if="scope.row.recog_type==2"><spring:message code="job_number"/></span>
                        <span v-if="scope.row.recog_type==3"><spring:message code="face_and_card"/></span>
                        <span v-if="scope.row.recog_type==4"><spring:message code="face_and_num"/></span>
                    </template>
                </el-table-column>
                <spring:message code="registration_time" var="reg_time"/>
                <el-table-column label="${reg_time}">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.record_time|formatDate }}</span>
                    </template>
                </el-table-column>
                <spring:message code="recognition_picture" var="reg_picture"/>
                <el-table-column label="${reg_picture}">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                    </template>
                </el-table-column>
                <spring:message code="operation" var="operate"/>
                <el-table-column label="${operate}">
                    <template slot-scope="scope">
                        <el-button type="danger" size="small" @click="deleteRecordById(scope)"><spring:message code="delete"/></el-button>
                    </template>
                </el-table-column>
            </el-table>
        </template>

        <template>
            <div class="block">
                <spring:message code="next_page" var="next_page_lang"/>
                <spring:message code="previous_page" var="previous_page_lang"/>
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
<spring:message code="delete_record" var="delete_record"/>
<spring:message code="tick_record" var="tick_record"/>
<spring:message code="delete_selected_record" var="delete_selected_record"/>

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
                                    pageSize: vm.pageSize
                                });
                            }
                        });
                    });
                }
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
