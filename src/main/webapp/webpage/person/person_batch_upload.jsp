<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .batch_upload_box {
        padding: 20px;
        text-align: center;
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
<div class="batch_upload_box">
    <div id="batch_upload_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${people_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${patch_upload}</el-breadcrumb-item>
        </el-breadcrumb>
        <el-form>
            <el-form-item>
                <span>请先按照 "部门-姓名.jpg"或"姓名.jpg" 的格式命名图片再上传</span>
            </el-form-item>
            <el-form-item>
            <el-upload class="avatar-uploader"
                       multiple="true"
                       :show-file-list="true"
                       :http-request="myUpload"
                       :auto-upload="false"
                       :on-change="onChange"
                       :before-upload="beforeUpload"
                       ref="upload">
                <i class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
            <el-button type="primary" v-on:click="onClickUpload()" size="medium">${add}</el-button>
            </el-form-item>
        </el-form>
        <%@include file="inc_dialog/dialog_cropper.jsp" %>
    </div>
</div>

<script type="text/javascript">
    var formData = new FormData();
    new Vue({
        el: "#batch_upload_detail",
        data: function () {
            return {
                cropperVisible: false,
                file: '',
                replace: false
            }
        },
        methods: {
            onChange(file, fileList) {
                const isSuppType = file.raw.type.indexOf("image") !== -1;
                const isLt3M = file.raw.size / 1024 / 1024 < 3;

                if (!isSuppType) {
                    this.$message.error('${dont_supported}');
                    return;
                }
                if (!isLt3M) {
                    this.$message.error('${image_exceed}');
                    return;
                }

                this.file = file;
                this.cropperVisible = true;
            },
            beforeUpload(file) {
                return true;
            },
            onClickUpload() {
                this.myUpload();
            },
            myUpload() {
                var loading = layLoading3("${uploading}");
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/person/batch_upload",
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
                    },
                    error: function (error) {
                        layAlert1(error.statusText);
                    },
                    complete: function (xhr, textStatus) {
                        top.layer.close(loading);
                    }
                });
            },
            onClickCropper() {
                var canvas = $('.cropper-container>img').cropper('getCroppedCanvas', {
                    width: 480,
                    height: 480,
                    minWidth: 240,
                    minHeight: 240,
                    maxWidth: 480,
                    maxHeight: 480,
                    fillColor: '#000',
                    imageSmoothingEnabled: false,//如果图像被设置为平滑(true，默认)
                    imageSmoothingQuality: 'high'//设置图像的质量
                });

                var fileSize = this.file.raw.size / 1024;
                var quality;
                if (fileSize > 2048) quality = 0.6;
                else if (fileSize > 1024 && fileSize < 2048) quality = 0.7;
                else if (fileSize > 65 && fileSize < 1024) quality = 0.75;
                else quality = 0.9;

                var base64url = canvas.toDataURL('image/jpeg', quality);
                var uploadBlob = dataURLtoBlob(base64url);//生成base64格式的blob
                var fileName = this.file.name;
                formData.append('file[]', uploadBlob, fileName);
                this.cropperVisible = false;
            },
            open() {
                if (this.replace) {
                    $('.cropper-container>img').cropper('replace', URL.createObjectURL(this.file.raw));
                } else {
                    $('.cropper-container>img').attr('src', URL.createObjectURL(this.file.raw)).cropper({
                        aspectRatio: 1,
                        viewMode: 0,
                        preview: ".cropper-preview"
                    });
                    this.replace = true;
                }
            },
            closed() {
                this.file = '';
            }
        }
    });
</script>