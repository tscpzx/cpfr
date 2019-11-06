<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .device_inact_tbl_box {
        padding: 20px;
        text-align: center;
    }

    .device_inact_tbl_box .el-table {
        margin: 0 auto;
    }
</style>
<div class="device_inact_tbl_box">
    <div id="device_inact_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${equ_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${device_not_activated}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form onsubmit="return false;">
            <el-form-item>
                <el-row>
                    <div style="float: right">
                        <el-input style="width: 200px;" size="small" v-model="keyword" autocomplete="off" placeholder="${search_content}" @keyup.enter.native="searchInActDeviceList"></el-input>
                        <el-button type="primary" size="small" @click="searchInActDeviceList">${search}</el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="device_id" label="ID">
                </el-table-column>
                <el-table-column prop="device_name" label="${devise_serial_number}">
                </el-table-column>
                <el-table-column prop="status" label="${active_state}">
                    <template slot-scope="scope">
                        <span v-if="scope.row.status===0">${inactivated}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="online" label="${online_status}">
                    <template slot-scope="scope">
                        <span v-if="scope.row.online===1">${online}</span>
                        <span v-if="scope.row.online===0">${offline}</span>
                    </template>
                </el-table-column>
                <el-table-column label="${registration_time}">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.register_time|formatDate }}</span>
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
    var vm = new Vue({
        el: "#device_inact_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 10,
            total:'',
            keyword:''
        },
        methods: {
            handleChange(val) {
                ajaxInActDeviceList({
                    pageNum: this.currentPage,
                    keyword: this.keyword,
                    pageSize: this.pageSize
                });
            },
            searchInActDeviceList(){
                ajaxInActDeviceList({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    keyword: this.keyword
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

    ajaxInActDeviceList({
        pageNum: vm.currentPage,
        keyword: vm.keyword,
        pageSize: vm.pageSize
    });

    function ajaxInActDeviceList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact_list",
            data: data,
            success: function (result) {
                vm.tableData = result.data.list;
                vm.total = result.data.total;
            }
        });
    }

</script>
