<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .device_tbl_box {
        padding: 20px;
    }

    .device_tbl_box .el-table {
        margin: 0 auto;
    }
</style>
<div class="device_tbl_box">
    <div id="device_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${equ_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${activated_device}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <div style="float: right">
                        <el-input style="width: 200px;" v-model="keyword" size="small"
                                  placeholder="${search_content}"></el-input>
                        <el-button type="primary" size="small" @click="searchDeviceList">${search}
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="device_id" label="${device_id}" min-width="10%">
                </el-table-column>
                <el-table-column prop="device_name" label="${device_name}" min-width="20%" >
                </el-table-column>
                <el-table-column prop="device_sn" label="${devise_serial_number}" min-width="20%">
                </el-table-column>
                <el-table-column prop="online" label="${online}" min-width="10%">
                    <template slot-scope="scope">
                        <span v-if="scope.row.online===1">${online}</span>
                        <span v-if="scope.row.online===0">${offline}</span>
                    </template>
                </el-table-column>
                <el-table-column label="${registration_time}" min-width="20%">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.register_time}}</span>
                    </template>
                </el-table-column>
                <el-table-column label="${active_time}" min-width="20%">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.activate_time}}</span>
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
        el: "#device_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 10,
            total: '',
            keyword: ''
        },
        methods: {
            handleChange(val) {
                ajaxDeviceList({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize
                });
            },
            searchDeviceList() {
                ajaxDeviceList({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    keyword: this.keyword
                });
            }
        }
    });

    ajaxDeviceList({
        pageNum: vm.currentPage,
        pageSize: vm.pageSize
    });

    function ajaxDeviceList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: data,
            success: function (result) {
                vm.tableData = result.data.list;
                vm.total = result.data.total;
            }
        });
    }

</script>
