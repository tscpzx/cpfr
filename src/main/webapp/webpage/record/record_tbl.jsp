<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .record_tbl_box {
        padding: 30px;
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
        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <el-table-column prop="id" label="ID" width="100">
                </el-table-column>
                <el-table-column prop="person_name" label="姓名" width="100">
                </el-table-column>
                <el-table-column prop="device_name" label="设备" width="150">
                </el-table-column>
                <el-table-column label="识别模式" width="100">
                    <template slot-scope="scope">
                        <span v-if="scope.row.recog_type==0">人脸</span>
                        <span v-if="scope.row.recog_type==1">身份证</span>
                        <span v-if="scope.row.recog_type==2">工号</span>
                        <span v-if="scope.row.recog_type==3">人脸+身份证</span>
                        <span v-if="scope.row.recog_type==4">人脸+工号</span>
                    </template>
                </el-table-column>
                <el-table-column label="识别时间">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.record_time|formatDate }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="识别图片" width="120">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
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
        el: "#record_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 5,
            total: ''
        },
        methods: {
            handleChange(val) {
                ajaxRecordList(this.currentPage, this.pageSize);
            }
        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });

    ajaxRecordList(vm.currentPage, vm.pageSize);

    function ajaxRecordList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/record/list_base64",
            data: {
                pageNum: pageNum,
                pageSize: pageSize
            },
            success: function (result) {
                console.log(result);
                vm.tableData = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }
</script>
