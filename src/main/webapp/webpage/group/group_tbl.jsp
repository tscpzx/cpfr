<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
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
            <el-breadcrumb-item>${group_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${group_list}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <div style="float: right">
                        <el-input style="width: 200px;" v-model="keyword" size="small" placeholder="${search_content}"></el-input>
                        <el-button type="primary" size="small" @click="searchGroupList">${search}
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="group_id" label="${group_id_lang}">
                </el-table-column>
                <el-table-column prop="group_name" label="${group_name}">
                </el-table-column>
                <el-table-column label="${create_time}">
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
        el: "#group_tbl",
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
                ajaxGroupListPage({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize
                });
            },
            searchGroupList(){
                ajaxGroupListPage({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    keyword: this.keyword
                });
            }
        }
    });

    ajaxGroupListPage({
        pageNum: vm.currentPage,
        pageSize: vm.pageSize
    });

    function ajaxGroupListPage(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/group/list",
            data: data,
            success: function (result) {
                vm.total = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }

</script>
