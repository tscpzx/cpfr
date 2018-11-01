<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>

    <style type="text/css">
        form.form_login {
            width: 60%;
            max-width: 450px;
            margin: auto;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            margin-top: 20%;
        }

        button.login {
            width: 100%;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="nav background-color">
        <h3 align="center" class="nav_title"><%=CommConst.WEB_TITLE%>
        </h3>
    </div>
    <form class="form_login">
        <div class="form-group">
            <input type="text" class="form-control" id="account" placeholder="账号">
        </div>
        <div class="form-group">
            <input type="password" class="form-control" id="password" placeholder="密码">
        </div>
        <div class="form-group">
            <input type="password" class="form-control" id="password_confirm" placeholder="再输入密码">
        </div>
        <button type="button" class="btn btn-primary login">注册</button>
    </form>
</div>

<script type="text/javascript">
    $('.form_login button.login').click(function () {
        var name = $('input#account').val().trim();
        var password = $('input#password').val().trim();
        var passwordConfirm = $('input#password_confirm').val().trim();
        var pattern = /^[0-9a-zA-Z]{4,12}$/;

        if (!name)
            layTip("账号不能为空");
        else if (!password || !passwordConfirm)
            layTip("密码不能为空");
        else if (!pattern.test(name))
            layTip("账号需要4个字符以上，并且只能是数字或者字母组成");
        else if (!pattern.test(password))
            layTip("密码需要4个字符以上，并且只能是数字或者字母组成");
        else if (password !== passwordConfirm)
            layTip("两次输入的密码不一致");
        else
            ajaxRegister(name, password);
    });

    function ajaxRegister(name, password) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/register",
            data: {
                name: name,
                password: password
            },
            success: function (data) {
                layTip(data.message);
                if (0 === data.code) {
                    window.location.href = "login";
                }
            }
        });
    }
</script>
</body>
</html>
