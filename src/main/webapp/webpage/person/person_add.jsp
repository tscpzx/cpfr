<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../../resource/inc/incCss.jsp" %>
    <%@include file="../../resource/inc/incJs.jsp" %>

    <style type="text/css">
        .person_add_box {
            padding: 20px;
        }

        .form-control {
            width: 400px;
            display: inline-block;
        }

        .div_group {
            margin: 10px 10px 20px 10px;
        }

        .div_group label {
            width: 150px;
            line-height: 32px;
            text-align: right;
            padding-right: 10px;
            font-size: 14px;
            color: #606266;
            font-weight: 500;
        }

        .div_group label.radio-inline {
            width: 50px;
        }

        input[type=radio] {
            margin: 10px 0 0 20px;
        }

        input[type=file] {
            display: inline-block;
        }

        .div_group:last-child {
            padding-left: 150px;
        }
    </style>
</head>
<body>
<div class="person_add_box">
    <form>
        <div class="div_group">
            <label>姓名：&nbsp;</label>
            <input id="input_name" type="text" class="form-control" placeholder="输入姓名">
        </div>
        <div class="div_group">
            <label>工号：&nbsp;</label>
            <input id="input_empno" type="number" class="form-control" placeholder="输入工号">
        </div>
        <div class="div_group">
            <label>性别：&nbsp;</label>
            <label class="radio-inline"><input type="radio" value="1" checked>男</label>
            <label class="radio-inline"><input type="radio" value="0">女</label>
        </div>
        <div class="div_group">
            <label>选择图片：&nbsp;</label>
            <input type="file"/>
        </div>
        <div class="div_group">
            <button id="btn_add_person" type="button" class="btn btn-success">添加</button>
        </div>
    </form>
</div>
<script type="text/javascript">
    $("#btn_add_person").click(function () {
        var person_name = $("#input_name").val().trim();
        var emp_number = $("#input_empno").val().trim();
        var files = $("input[type=file]")[0].files;

        if (!person_name)
            layTip("姓名不能为空");
        else if (files.length <= 0)
            layTip("未选择图片");
        else if (files.length > 1)
            layTip("只能选择一张图片");
        else if (files[0].type.indexOf("image") === -1)
            layTip("不支持该类型的文件");
        else {
            uploadToAddPerson(person_name, emp_number, files[0]);
        }
    });

    function uploadToAddPerson(person_name, emp_number, file) {
        var loading=layLoading3("上传中...");
        var formData = new FormData();
        formData.append("person_name", person_name);
        formData.append("emp_number", emp_number);
        formData.append("file", file);
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/person/add",
            contentType: false,//必须false才会自动加上正确的Content-Type
            processData: false,//必须false才会避开jQuery对 formdata 的默认处理
            data: formData,
            beforeSend: function (xhr) {//setRequestHeader
            },
            xhr: function () { //获取ajaxSettings中的xhr对象，为它的upload属性绑定progress事件的处理函数
                xhr = $.ajaxSettings.xhr();
                if (xhr.upload) { //检查upload属性是否存在
                    //绑定progress事件的回调函数
                    xhr.upload.addEventListener('progress', function (e) {
                        l(Math.round(((e.loaded / e.total) || 0) * 100));
                    }, false);
                }
                return xhr; //xhr对象返回给jQuery使用
            },
            success: function (result) {
                layTip(result.message);
                window.location.reload();
            },
            error: function (error) {
                layAlert1(result.message);
            },
            complete:function (xhr, textStatus) {
                top.layer.close(loading);
            }
        });
    }
</script>
</body>
</html>
