<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .group_tbl_box {
        padding: 20px;
        text-align: center;
    }

    .group_tbl_box .el-table {
        margin: 0 auto;
    }

    .el-form-item {
        text-align: left;
    }
</style>
<div class="group_tbl_box">
    <div id="group_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>分组管理</el-breadcrumb-item>
            <el-breadcrumb-item>分组列表</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="group_id" label="组ID">
                </el-table-column>
                <el-table-column prop="group_name" label="组名">
                </el-table-column>
                <el-table-column label="创建时间">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.create_time}}</span>
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
        el: "#group_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 10,
            total:''
        },
        methods: {
            handleChange(val) {
                ajaxGroupList(this.currentPage, this.pageSize);
            }
        }
    });

    ajaxGroupList(vm.currentPage, vm.pageSize);

    function ajaxGroupList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/group/list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize
            },
            success: function (result) {
                vm.total = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }

</script>
