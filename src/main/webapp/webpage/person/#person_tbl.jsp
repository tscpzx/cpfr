<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/pagination.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/jquery.pagination.js"></script>

    <style type="text/css">
        .div_box {
            width: 100%;
            padding: 30px;
            text-align: center;
        }

        .div_box table {
            margin: 0 auto;
        }

        .div_header {
            position: relative;
            height: 35px;
            margin: 10px 0;
        }

        .div_header button {
            top: 0;
            left: 0;
            position: absolute;
        }

        .input-group {
            width: 250px;
            position: absolute;
            top: 0;
            right: 0;
        }
    </style>
</head>
<body>
<div class="div_box">
    <div class="div_header">
        <button type="button" class="btn btn-success">
            <span class="icon fa-plus"></span>添加
        </button>

        <div class="input-group">
            <input type="text" class="form-control" placeholder="搜索设备">
            <span class="input-group-btn">
                        <button class="btn btn-default" type="button">搜索</button>
                      </span>
        </div>
    </div>

    <table border="1px" class="table table-bordered table-hover" v-cloak id="person_list">
        <thead>
        <tr>
            <td>人员ID</td>
            <td>姓名</td>
            <td>工号</td>
            <td>底库图片</td>
            <td>操作</td>
        </tr>
        </thead>

        <tbody>
        <tr v-for="data in items" v-on:click="onClickItem(data)">
            <td>{{data.person_id}}</td>
            <td>{{data.person_name}}</td>
            <td>{{data.emp_number}}</td>
            <td><img class="image" v-bind:src="'data:image/jpeg;base64,'+data.base_image"></td>
            <td></td>
        </tr>
        </tbody>

        <tfoot>
        <tr v-if="items.length==0">
            <td colspan="5"><span>—— 暂无数据 ——</span></td>
        </tr>
        </tfoot>
    </table>
    <div class="pagination"></div>
</div>

<script type="text/javascript">
    var pageNum = 1;
    var pageSize = 10;

    ajaxGet({
        url: "${pageContext.request.contextPath}/person/page",
        data: {
            pageNum: pageNum,
            pageSize: pageSize
        },
        success: function (result) {
            $(".pagination").pagination(result.data.total, {
                current_page: pageNum - 1,//当前选中的页面
                items_per_page: pageSize, //每页显示的条目数
                num_display_entries: 1, // 中间页数
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
        el: "#person_list",
        data: {
            items: [],
            searching: true
        },
        methods: {
            onClickItem: function (data) {
            }
        }
    });

    function ajaxPersonList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/page",
            data: {
                pageNum: pageNum + 1,
                pageSize: pageSize
            },
            success: function (result) {
                vuePersonList.items = result.data.list;
            }
        });
    }

    $(".div_header button").click(function () {
        window.location.href = "person_add";
    });

</script>
</body>
</html>
