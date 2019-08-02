<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <%@include file="../resource/inc/lang.jsp" %>
    <style type="text/css">
        .el-container {
            height: 100%;
        }

        .el-header {
            background-color: #409EFF;
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

        .el-menu{
            border: 0px;
        }

        .el-form-item {
            margin-bottom: 18px;
        }


        .scrollbar::-webkit-scrollbar { /*滚动条整体样式*/
            width: 12px; /*高宽分别对应横竖滚动条的尺寸*/
            height: 1px;
        }

        .scrollbar::-webkit-scrollbar-thumb { /*滚动条里面小方块*/
            border-radius: 12px;
            background: #CCCCCC;
        }

        .scrollbar::-webkit-scrollbar-track { /*滚动条里面轨道*/
            border-radius: 12px;
            background: #E1E1E1;
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
                        <p class="nav_title">
                            ${face_recognition_management_system}
                        </p>
                    </div>
                </el-col>
                <el-col :span="9">
                    <div style="height: 60px;"></div>
                </el-col>
                <el-col :span="2">
                    <div style="float: right">
                        <a href="#">${sessionScope.user.name} , ${hello}</a></div>
                </el-col>
                <el-col :span="3">
                    <div style="float: right" v-on:click="visible=true;"><a href="#">${change_password}</a>
                    </div>
                </el-col>
                <el-col :span="2">
                    <div style="float: right" v-on:click="ajaxLogout"><a href="#">${sign_out}</a>
                    </div>
                </el-col>
            </el-row>
        </el-header>

        <el-container>
            <el-aside width="200px" style="height: 100%;background:#fff;border-right: solid 1px #e6e6e6;">
                <el-menu default-active="device/device" class="el-menu-vertical-demo" background-color="#fff"
                         text-color="#000" active-text-color="#ffd04b">
                    <el-menu-item index="device/device" @click="onClick($event)">
                        <i class="el-icon-mobile-phone"></i>
                        <span slot="title">${equ_management}</span>
                    </el-menu-item>
                    <el-submenu index="person">
                        <template slot="title">
                            <i class="el-icon-service"></i>
                            <span>${people_management}</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="person/person" @click="onClick($event)">${people_list}
                            </el-menu-item>
                            <el-menu-item index="person/person_batch_upload" @click="onClick($event)">${patch_upload}</el-menu-item>
                        </el-menu-item-group>
                    </el-submenu>
                    <el-menu-item index="grant/grant" @click="onClick($event)">
                        <i class="el-icon-printer"></i>
                        <span slot="title">权限管理</span>
                    </el-menu-item>
                    <el-menu-item index="group/group" @click="onClick($event)">
                        <i class="el-icon-menu"></i>
                        <span slot="title">${group_management}</span>
                    </el-menu-item>
                    <el-menu-item index="record/record" @click="onClick($event)">
                        <i class="el-icon-document"></i>
                        <span slot="title">${record_management}</span>
                    </el-menu-item>

                    <el-submenu index="attend">
                        <template slot="title">
                            <i class="el-icon-bell"></i>
                            <span>${attend_management}</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="attend/attend_detail" @click="onClick($event)">${attend_details}
                            </el-menu-item>
                      <%--      <el-menu-item index="attend/attend" @click="onClick($event)">${attend_setting}
                            </el-menu-item>
                            <el-menu-item index="attend/attend_report" @click="onClick($event)">${attend_report}
                            </el-menu-item>--%>
                        </el-menu-item-group>
                    </el-submenu>

                    <%--   <el-menu-item index="5">
                           <i class="el-icon-edit-outline"></i>
                           <span slot="title">账号管理</span>
                       </el-menu-item>--%>
                </el-menu>
            </el-aside>

            <el-main id="content-container" class="scrollbar" style="overflow:scroll;">

            </el-main>
        </el-container>
    </el-container>

    <el-dialog title="${change_password}"
               :visible.sync="visible"
               width="600px">
        <el-form :model="model" label-width="25%" :rules="rules" ref="ref">
            <el-form-item label="${old_password}" prop="old_password">
                <el-input v-model="model.old_password" type="password" autocomplete="off"
                          placeholder="${enter_old_password}" size="small" style="width: 75%;"></el-input>
            </el-form-item>
            <el-form-item label="${new_password}" prop="new_password">
                <el-input v-model="model.new_password" type="password" autocomplete="off"
                          placeholder="${enter_new_password}" size="small" style="width: 75%;"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="visible = false" size="small">${cancel_lang}</el-button>
            <el-button type="primary" @click="changePassword" size="small">${determine}</el-button>
        </div>
    </el-dialog>
</div>

<script type="text/javascript">
    /* elementui中英文切换 */
    if ('${pageContext.response.locale}' === 'en_US')
        ELEMENT.locale(ELEMENT.lang.en);
    else
        ELEMENT.locale(ELEMENT.lang.zhCN);

    var vmWeb = new Vue({
        el: '#web',
        data: {
            visible: false,
            model: {
                old_password: '',
                new_password: ''
            },
            rules: {
                old_password: [
                    {required: true, message: '${enter_old_password}', trigger: 'blur'}
                ],
                new_password: [
                    {required: true, message: '${enter_new_password}', trigger: 'blur'}
                ]
            },
        },
        methods: {
            onClick(event) {
                $("#content-container").load("${pageContext.request.contextPath}/page/" + $(event)[0].index);
            },
            ajaxLogout() {
                ajaxPost({
                    url: "${pageContext.request.contextPath}/user/logout",
                    data: {},
                    success: function (data) {
                        layTip(data.message);
                        window.location.href = "/cpfr/";
                    }
                });
            },
            changePassword() {
                this.$refs.ref.validate((valid) => {
                    if (valid) {
                        ajaxPost({
                            url: "${pageContext.request.contextPath}/user/change_password",
                            data: {
                                old_password: this.model.old_password,
                                new_password: this.model.new_password
                            },
                            success: function (data) {
                                layTip(data.message);
                                vmWeb.visible = false;
                            }
                        });
                    }
                });
            }
        }
    });
    $("#content-container").load("${pageContext.request.contextPath}/page/device/device");
</script>
</body>
</html>
