<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<style type="text/css">
    #person_tree {
        width: 250px;
        height: 95%;
        background: #fff;
        overflow-y: auto;
        float: left;
        border-right: solid 1px #e6e6e6;
    }
    #person_content{
        float: left;
        width: calc(100% - 251px);
        height: 95%;
        overflow: auto;
    }
    .avatar-uploader .el-upload {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }

    .avatar-uploader .el-upload:hover {
        border-color: #409EFF;
    }

    .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 178px;
        height: 178px;
        line-height: 178px;
        text-align: center;
    }

    .avatar {
        width: 178px;
        height: 178px;
        display: block;
    }

    .cropper-container {
        width: 100%;
    }

    .cropper-preview {
        margin-left: 5px;
        width: 100%;
        height: 200px;
        background-color: black;
        overflow: hidden;
    }
</style>
<div id="person_tree" class="scrollbar"></div>
<div id="person_content" class="scrollbar"></div>

<script type="text/javascript">
    $("#person_tree").load("${pageContext.request.contextPath}/page/person/person_tree");
    $("#person_content").load("${pageContext.request.contextPath}/page/person/person_tbl");
</script>
