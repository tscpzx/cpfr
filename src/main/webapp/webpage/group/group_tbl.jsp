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
                <el-button type="primary" icon="el-icon-plus" id="btn_add_group">添加</el-button>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 80%" border>
                <el-table-column prop="group_id" label="组ID" width="180">
                </el-table-column>
                <el-table-column prop="group_name" label="组名" width="180">
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
    var pageSize = 10;

    $(".pagination").pagination(${param.length}, {
        current_page: pageNum - 1,//当前选中的页面
        items_per_page: pageSize, //每页显示的条目数
        num_display_entries: 5, // 中间页数
        num_edge_entries: 1,// 0没有省略号 1有  两侧显示的首尾分页的条目数
        is_show_skip_page: true,
        prev_text: '上一页',
        next_text: '下一页',
        callback: function (pageNum) {
            ajaxGroupList(pageNum, pageSize);
        }
    });

    var vueGroupList = new Vue({
        el: "#group_tbl",
        data: {
            tableData: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        }
    });

    function ajaxGroupList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/group/page",
            data: {
                pageNum: pageNum + 1,
                pageSize: pageSize
            },
            success: function (result) {
                vueGroupList.tableData = result.data.list;
            }
        });
    }

    $("#btn_add_person").click(function () {
    });

</script>
