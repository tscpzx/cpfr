<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
    <style scoped>
        .el-header {
            background-color: #409EFF;
            color: white;
            text-align: center;
            line-height: 60px;
        }

        .login-container {
            border-radius: 5px;
            -moz-border-radius: 5px;
            background-clip: padding-box;
            margin: 180px auto;
            width: 450px;
            padding: 35px 35px 15px;
            background: white;
            border: 1px solid #eaeaea;
            box-shadow: 0 0 25px #cac6c6;
        }

        .login-container .title {
            margin: 0 auto 40px;
            text-align: center;
            color: #505458;
            font-weight: 600;
        }

        .el-button {
            width: 100%;
        }

        body {
            background: url("../resource/images/bg_login.png") no-repeat;
            background-size: 100% 100%;
            -moz-background-size: 100% 100%;
            overflow-y: hidden;
        }
    </style>
</head>

<body>
<div id="app">
    <div class="container">
        <el-container>
            <el-header>
                <h3><%=CommConst.WEB_TITLE%>
                </h3>
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
                    <h4 class="title">管理员登录</h4>
                    <el-form-item prop="name">
                        <el-input v-model="loginModel.name" type="text" autocomplete="off" placeholder="请输入账号" clearable></el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input v-model="loginModel.password" type="password" autocomplete="off" placeholder="请输入密码" clearable></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" v-on:click="onClickLogin('loginForm')">登录
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
                }
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
                    window.location.href = "web";
                }
            }
        });
    }
</script>
</body>
</html>
