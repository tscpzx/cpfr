<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/pagination.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/jquery.pagination.js"></script>

<style type="text/css">
    .device_inact_tbl_box {
        padding: 30px;
        text-align: center;
    }

    .device_inact_tbl_box .el-table {
        margin: 0 auto;
    }
</style>
<div class="device_inact_tbl_box">
    <div id="device_inact_tbl">
        <template>
            <el-table :data="tableData" style="width: 90%" border>
                <el-table-column prop="id" label="ID" width="180">
                </el-table-column>
                <el-table-column prop="device_sn" label="设备序列号" width="180">
                </el-table-column>
                <el-table-column prop="status" label="状态" width="180">
                </el-table-column>
                <el-table-column prop="online" label="在线" width="180">
                </el-table-column>
                <el-table-column label="注册时间">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.register_time|formatDate }}</span>
                    </template>
                </el-table-column>
            </el-table>
        </template>
    </div>
    <div class="pagination"></div>
</div>

<script type="text/javascript">
    var pageNum = 1;
    var pageSize = 10;

    ajaxGet({
        url: "${pageContext.request.contextPath}/device/inact/list/page",
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
                    ajaxInActDeviceList(pageNum, pageSize);
                }
            });
        }
    });

    var vueInactDeviceList = new Vue({
        el: "#device_inact_tbl",
        data: {
            tableData: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });

    function ajaxInActDeviceList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact/list/page",
            data: {
                pageNum: pageNum + 1,
                pageSize: pageSize
            },
            success: function (result) {
                vueInactDeviceList.tableData = result.data.list;
            }
        });
    }

</script>
