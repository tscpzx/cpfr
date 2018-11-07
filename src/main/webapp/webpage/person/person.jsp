<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>
    <!--navMenu-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/navMenu.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/navMenu.js"></script>
    <style type="text/css">
        .navMenuBox {
            height: 100%;
        }

        .input-group {
            margin: 15px 10px 15px 10px;
        }

    </style>
</head>
<body>
<table style="width:100%;height: 100%;">
    <tr>
        <td width="250px;">
            <!--包裹层-->
            <div class="navMenuBox">

                <div class="input-group">
                    <input type="text" class="form-control" placeholder="搜索设备">
                    <span class="input-group-btn">
                        <button class="btn btn-default" type="button">搜索</button>
                      </span>
                </div>

                <!--一级菜单-->
                <ul class="navMenu">
                    <!--菜单项-->
                    <li>
                        <a class="arrow" onclick="onClickPersonMenu(this)">人员列表</a>
                        <!--子菜单-->
                        <ul class="subMenu" v-cloak id="person_list">
                            <li v-for="data in items" v-on:click="onClickItem(data)">
                                <a v-bind:href="'${pageContext.request.contextPath}/person/detail?person_id='+data.person_id" target="if_person">{{data.person_name}}</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </td>
        <td>
            <iframe class="if_window" name="if_person" src="person_tbl.jsp"></iframe>
        </td>
    </tr>
</table>
<script type="text/javascript">
    ajaxPersonList();
    var personList = new Vue({
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

    function ajaxPersonList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list",
            data: {},
            success: function (result) {
                personList.items = result.data;
                $(".navMenu li:eq(0)").addClass("active");
                $(".navMenu li:eq(0) .subMenu").slideDown();
            }
        });
    }

    function onClickPersonMenu(e) {
        if (!$(e).parent().hasClass("active")) {
            $(".if_window").attr("src", "person_tbl.jsp");
        }
    }
</script>
</body>
</html>
