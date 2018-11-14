<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/pagination.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/jquery.pagination.js"></script>

<style type="text/css">
    .person_tbl_box {
        padding: 30px;
        text-align: center;
    }

    .person_tbl_box .el-table {
        margin: 0 auto;
    }

    .el-form-item{
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
            <el-table :data="tableData" style="width: 80%" border>
                <el-table-column prop="person_id" label="人员ID" width="180">
                </el-table-column>
                <el-table-column prop="person_name" label="姓名" width="180">
                </el-table-column>
                <el-table-column prop="emp_number" label="工号" width="180">
                </el-table-column>
                <el-table-column label="底库图片" width="180">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                    </template>
                </el-table-column>
                <el-table-column label="操作">
                </el-table-column>
            </el-table>
        </template>
    </div>
    <div class="pagination"></div>
</div>

<script type="text/javascript">
    var pageNum = 1;
    var pageSize = 5;

    ajaxGet({
        url: "${pageContext.request.contextPath}/person/list/page",
        data: {
            pageNum: pageNum,
            pageSize: pageSize
        },
        success: function (result) {
            $(".pagination").pagination(result.data.total, {
                current_page: pageNum - 1,//当前选中的页面
                items_per_page: pageSize, //每页显示的条目数
                num_display_entries: 5, // 中间页数
                num_edge_entries: 1,// 0没有省略号 1有  两侧显示的首尾分页的条目数
                is_show_skip_page: true,
                prev_text: '上一页',
                next_text: '下一页',
                callback: function (pageNum) {
                    ajaxPersonList(pageNum, pageSize);
                }
            });
        }
    });

    var vuePersonList = new Vue({
        el: "#person_tbl",
        data: {
            tableData: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        }
    });

    function ajaxPersonList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list/page",
            data: {
                pageNum: pageNum + 1,
                pageSize: pageSize
            },
            success: function (result) {
                vuePersonList.tableData = result.data.list;
            }
        });
    }

    $("#btn_add_person").click(function () {
        $("#person_content").load("person/person_add");
    });

</script>
