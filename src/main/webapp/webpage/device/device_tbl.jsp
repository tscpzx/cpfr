<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .device_tbl_box {
        padding: 30px;
        text-align: center;
    }

    .device_tbl_box .el-table {
        margin: 0 auto;
    }
</style>
<div class="device_tbl_box">
    <div id="device_tbl">
        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
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
                <el-pagination ref="pagination"
                               @size-change="handleChange"
                               @current-change="handleChange"
                               :current-page.sync="currentPage"
                               :page-size.sync="pageSize"
                               :page-sizes="pageSizes"
                               prev-text="上一页"
                               next-text="下一页"
                               layout="total, sizes, prev, pager, next, jumper"
                               :total="${param.length}">
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
            pageSize: 10
        },
        methods: {
            handleChange(val) {
                ajaxDeviceList(this.currentPage, this.pageSize);
            }
        }
    });

    ajaxDeviceList(vm.currentPage, vm.pageSize);

    function ajaxDeviceList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize
            },
            success: function (result) {
                vm.tableData = result.data;
            }
        });
    }

</script>
