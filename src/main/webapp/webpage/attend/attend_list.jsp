<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_rule_box {
        padding: 20px;
        text-align: center;
    }

    .attend_rule_box.el-table {
        margin: 0 auto;
    }

    .el-form-item {
        text-align: left;
    }
    .el-button{
        color: #000;
    }
</style>
<div class="attend_rule_box">
    <div id="attend_rule">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attend_setting}</el-breadcrumb-item>
            <el-breadcrumb-item>规则列表</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="attend_id" label="考勤规则ID">
                </el-table-column>
                <el-table-column prop="am_punch_in_time" label="上班时间">
                </el-table-column>
                <el-table-column prop="pm_punch_out_time" label="下班时间">
                </el-table-column>
                <el-table-column  prop="work_day" label="工作日">
                </el-table-column>
                <el-table-column label="${operation}">
                    <template slot-scope="scope">
                        <el-button  @click="deleteRule(scope.row)" type="text" style="color:#409EFF"><i class="el-icon-edit"></i></el-button>
                        <el-button  @click="deleteRule(scope.row)" type="text" style="color:#F56C6C"><i class="el-icon-delete"></i></el-button>


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
        el: "#attend_rule",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 10,
            total: '',
        },
        methods: {
            handleChange(val) {
                ajaxRuleListPage({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize
                });
            },
            deleteRule(scope){

            }
        }
    });

    ajaxRuleListPage({
        pageNum: vm.currentPage,
        pageSize: vm.pageSize
    });

    function ajaxRuleListPage(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/attend/rule_list",
            data: data,
            success: function (result) {
                vm.total = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }

</script>
