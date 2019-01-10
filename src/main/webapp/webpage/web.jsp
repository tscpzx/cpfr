<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <style type="text/css">
        .el-container {
            height: 100%;
        }

        .el-header {
            background-color: #63BBD0;
        }

        .el-col, .nav_title {
            color: white;
            line-height: 60px;
            font-weight: 500;
            font-size: 18px;
        }

        .el-header a {
            color: white;
            font-size: 16px;
        }

        .el-main {
            padding: 0;
        }

        .el-form-item {
            margin-bottom: 18px;
        }
    </style>
</head>
<body style="margin:0;padding:0;overflow:hidden" scroll="no">
<div id="web" style="height: 100%">
    <el-container>
        <el-header>
            <el-row>
                <el-col :span="8">
                    <div>
                        <p class="nav_title"><%=CommConst.WEB_TITLE%>
                        </p>
                    </div>
                </el-col>
                <el-col :span="10">
                    <div style="height: 60px;"></div>
                </el-col>
                <el-col :span="2">
                    <div style="float: right">
                        <a href="#">${sessionScope.user.name},您好!</a></div>
                </el-col>
                <el-col :span="2">
                    <div style="float: right"><a href="register.jsp">修改密码</a>
                    </div>
                </el-col>
                <el-col :span="2">
                    <div style="float: right" onclick="ajaxLogout()"><a href="#">退出登录</a>
                    </div>
                </el-col>
            </el-row>
        </el-header>

        <el-container>
            <el-aside width="200px" style="height: 100%;background:#545c64;">
                <el-menu default-active="device/device" class="el-menu-vertical-demo" background-color="#545c64"
                         text-color="#fff" active-text-color="#ffd04b">
                    <el-menu-item index="device/device" @click="onClick($event)">
                        <i class="el-icon-mobile-phone"></i>
                        <span slot="title">设备管理</span>
                    </el-menu-item>
                    <el-submenu index="person">
                        <template slot="title">
                            <i class="el-icon-service"></i>
                            <span>人员管理</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="person/person" @click="onClick($event)">人员列表
                            </el-menu-item>
                            <%--<el-menu-item index="1-2">批量上传</el-menu-item>--%>
                        </el-menu-item-group>
                    </el-submenu>
                    <el-menu-item index="group/group" @click="onClick($event)">
                        <i class="el-icon-menu"></i>
                        <span slot="title">分组管理</span>
                    </el-menu-item>
                    <el-menu-item index="record/record_tbl" @click="onClick($event)">
                        <i class="el-icon-document"></i>
                        <span slot="title">记录管理</span>
                    </el-menu-item>
                    <el-menu-item index="5">
                        <i class="el-icon-edit-outline"></i>
                        <span slot="title">账号管理</span>
                    </el-menu-item>
                </el-menu>
            </el-aside>

            <el-main id="content-container"></el-main>
        </el-container>
    </el-container>
</div>

<script type="text/javascript">
    new Vue({
        el: '#web',
        methods: {
            onClick(event) {
                $("#content-container").load($(event)[0].index);
            }
        }
    });

    $("#content-container").load("device/device");

    function ajaxLogout() {
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/logout",
            data: {},
            success: function (data) {
                layTip(data.message);
                window.location.href = "/cpfr/";
            }
        });
    }
</script>
</body>
</html>
