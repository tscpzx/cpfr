<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <%@include file="../resource/inc/lang.jsp" %>
    <style scoped>
        .el-header {
            margin-top: 100px;
            color: white;
            text-align: center;
            line-height: 60px;
        }

        .login-container {
            border-radius: 5px;
            -moz-border-radius: 5px;
            background-clip: padding-box;
            margin: auto;
            width: 350px;
            padding: 25px 35px 15px;
            background: white;
            filter: alpha(opacity:90);
            opacity: 0.9;
            border: 1px solid #eaeaea;
            box-shadow: 0 0 25px #cac6c6;
        }

        .login-container .title {
            margin: 0 auto 25px;
            text-align: center;
            color: #222222;
            font-size: 17px;
        }

        .el-button {
            width: 100%;
        }

        a {
            color: #222222;
        }

        body {
            background: url("${pageContext.request.contextPath}/resource/images/img.jpg") no-repeat;
            background-size: 100% 100%;
            -moz-background-size: 100% 100%;
            overflow-y: hidden;
        }

        .el-dropdown-link {
            cursor: pointer;
            color: #409EFF;
        }
    </style>
</head>

<body>
<div id="app">
    <div class="container">
        <el-container>
            <el-header>
                <p style="font-size:26px;font-weight: 500 ">${face_recognition_management_system}
                </p>
            </el-header>
            <%--
             model:数据对象
             prop:传入model中的字段
             rules:验证规则
             ref:组件元素本身

             注意：在el-form中，需要用冒号 :model  :rules
             --%>
            <el-main>
                <el-form class="demo-ruleForm login-container" :model="loginModel" :rules="loginRules" ref="loginForm">
                    <p class="title">${admin_login}</p>
                    <el-form-item prop="name">
                        <el-input v-model="loginModel.name" type="text" autocomplete="off" placeholder="请输入账号"
                                  clearable></el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input v-model="loginModel.password" type="password" autocomplete="off" placeholder="请输入密码" @keyup.enter.native="onClickLogin('loginForm')"
                                  clearable></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-dropdown trigger="click" style="float: right;" @command="handleCommand">
                          <span class="el-dropdown-link" style="cursor:default;">
                            {{dropdownTitle}}<i class="el-icon-sort el-icon--right"></i>
                          </span>
                            <el-dropdown-menu slot="dropdown">
                                <el-dropdown-item command="zh_CN">
                                    <spring:message code="language.cn"/></el-dropdown-item>
                                <el-dropdown-item command="en_US">
                                    <spring:message code="language.en"/></el-dropdown-item>
                            </el-dropdown-menu>
                        </el-dropdown>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" v-on:click="onClickLogin('loginForm')">${login}
                        </el-button>
                    </el-form-item>
                </el-form>
            </el-main>
        </el-container>
    </div>
</div>

<script type="text/javascript">
    new Vue({
        el: '#app',
        data: function () {
            var checkInput = function (rule, value, callback) {
                var pattern = /^[0-9a-zA-Z]{4,12}$/;
                if (!pattern.test(value)) {
                    callback(new Error("需要4个字符以上，并且只能是数字或者字母组成"));
                } else callback()
            };

            return {
                loginModel: {
                    name: '',
                    password: ''
                },
                loginRules: {
                    name: [
                        {required: true, message: '请输入账号', trigger: 'blur'},
                        {validator: checkInput, trigger: 'blur'}
                    ],
                    password: [
                        {required: true, message: '请输入密码', trigger: 'blur'},
                        {validator: checkInput, trigger: 'blur'}
                    ]
                },
                dropdownTitle: '<spring:message code="switch_language"/>'
            }
        },
        methods: {
            onClickLogin(formName) {
                this.$refs[formName].validate((isValid) => {
                    var model = this.$refs[formName].model;
                    if (isValid) {
                        ajaxLogin(model.name, model.password)
                    }
                });
            },
            handleCommand(command) {
                window.location.href = "${pageContext.request.contextPath}/login?lang=" + command;
            }
        }
    });

    function ajaxLogin(name, password) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/login",
            data: {
                name: name,
                password: password
            },
            success: function (data) {
                layTip(data.message);
                if (0 === data.code) {
                    var locale = '${pageContext.response.locale}';
                    if (locale === 'en_US' && '<spring:message code="language.en"/>' !== 'English')
                        locale = 'zh_CN';

                    window.location.href = "${pageContext.request.contextPath}/web?lang=" + locale;
                }
            }
        });
    }
</script>
</body>
</html>
