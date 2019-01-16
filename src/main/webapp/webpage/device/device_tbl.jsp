<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
            <el-breadcrumb-item>设备管理</el-breadcrumb-item>
            <el-breadcrumb-item>已激活设备</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <div style="float: right">
                        <el-input style="width: 200px;" v-model="keyword" size="small" placeholder="请输入搜索内容"></el-input>
                        <el-button type="primary" size="small" @click="searchDeviceList">查找
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="device_id" label="设备ID">
                </el-table-column>
                <el-table-column prop="device_name" label="设备名称">
                </el-table-column>
                <el-table-column prop="device_sn" label="设备序列号">
                </el-table-column>
                <el-table-column prop="online" label="在线">
                    <template slot-scope="scope">
                        <span v-if="scope.row.online===1">在线</span>
                        <span v-if="scope.row.online===0">离线</span>
                    </template>
                </el-table-column>
                <el-table-column label="注册时间">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.register_time}}</span>
                    </template>
                </el-table-column>
                <el-table-column label="激活时间">
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
