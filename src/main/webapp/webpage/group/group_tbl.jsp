<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .group_tbl_box {
        padding: 30px;
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
        <el-form label-width="20px">
            <el-form-item>
                <el-button type="primary" icon="el-icon-plus" @click="addGroup">添加</el-button>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="group_id" label="组ID" width="100">
                </el-table-column>
                <el-table-column prop="group_name" label="组名" width="100">
                </el-table-column>
                <el-table-column label="操作">
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
        el: "#group_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 10
        },
        methods: {
            handleChange(val) {
                ajaxGroupList(this.currentPage, this.pageSize);
            },
            addGroup() {
                this.$prompt('请输入组名', '添加', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消'
                }).then(({value}) => {
                    if (value.trim()) {
                        ajaxAddGroup(value.trim());
                    }
                }).catch(() => {
                });
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
                vm.tableData = result.data;
            }
        });
    }

    function ajaxAddGroup(groupName) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/group/add",
            data: {
                group_name: groupName
            },
            success: function (result) {
                $("#content-container").load("group/group");
            }
        });
    }
</script>
