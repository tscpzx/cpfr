<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .person_tbl_box {
        padding: 30px;
        text-align: center;
    }

    .person_tbl_box .el-table {
        margin: 0 auto;
    }

    .el-form-item {
        text-align: left;
    }
</style>
<div class="person_tbl_box">
    <div id="person_tbl">
        <el-form label-width="20px">
            <el-form-item>
                <el-button type="primary" icon="el-icon-plus" id="btn_add_person">添加</el-button>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="person_id" label="人员ID" width="100">
                </el-table-column>
                <el-table-column prop="person_name" label="姓名" width="100">
                </el-table-column>
                <el-table-column prop="emp_number" label="工号" width="100">
                </el-table-column>
                <el-table-column label="底库图片" width="120">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                        <%--<img class="image_tbl" v-bind:src="'${pageContext.request.contextPath}/person/image?image_path='+scope.row.image_path">--%>
                    </template>
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
                               :total="total">
                </el-pagination>
            </div>
        </template>
    </div>
</div>

<script type="text/javascript">
    var vm = new Vue({
        el: "#person_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 5,
            total:''
        },
        methods: {
            handleChange(val) {
                ajaxPersonPage(this.currentPage, this.pageSize);
            }
        }
    });

    ajaxPersonPage(vm.currentPage, vm.pageSize);

    function ajaxPersonPage(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list_base64",
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

    $("#btn_add_person").click(function () {
        $("#person_content").load("person/person_add");
    });

</script>
