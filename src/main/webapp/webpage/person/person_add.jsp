<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .person_add_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

</style>
<div class="person_add_box">
    <div id="person_add">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${people_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${people_list}</el-breadcrumb-item>
            <el-breadcrumb-item>${add_people}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form label-width="120px" :model="model" :rules="rules" ref="uploadForm">

            <el-form-item label=${name} prop="person_name">
                <el-input v-model="model.person_name" type="text" autocomplete="off" placeholder="${input_name_lang}" size="small"></el-input>
            </el-form-item>
            <el-form-item label="${job_number}" prop="emp_number">
                <el-input v-model="model.emp_number" type="text" autocomplete="off" placeholder="${input_job_number_lang}" size="small"></el-input>
            </el-form-item>
            <el-form-item label="${choose_picture_lang}">
                <el-upload class="avatar-uploader"
                           :action="action"
                           :show-file-list="true"
                           :http-request="myUpload"
                           :auto-upload="false"
                           :on-change="onChange"
                           :before-upload="beforeUpload"
                           ref="upload">
                    <img v-if="imageUrl" :src="imageUrl" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" v-on:click="onClickUpload()" size="medium">${add}</el-button>
            </el-form-item>
        </el-form>
        <%@include file="inc_dialog/dialog_cropper.jsp" %>
    </div>
</div>
<script type="text/javascript">
    new Vue({
        el: "#person_add",
        data: function () {
            return {
                model: {
                    person_name: '',
                    emp_number: ''
                },
                rules: {
                    person_name: [
                        {required: true, message: '${input_name_lang}', trigger: 'blur'}
                    ]
                },
                imageUrl: '',
                action: "${pageContext.request.contextPath}/person/add",
                cropperVisible: false,
                file: '',
                replace: false,
                uploadBlob: ''
            }
        },
        methods: {
            onChange(file, fileList) {
                this.$refs.upload.clearFiles();
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

                // this.$refs.upload.uploadFiles[0] = file;
                // this.imageUrl = URL.createObjectURL(file.raw);
                this.file = file;
                this.cropperVisible = true;
            },
            beforeUpload(file) {
                const isLt = this.uploadBlob.size / 1024 < 65;
                if (!isLt) this.$message.error('${image_large}');

                return isLt;
            },
            onClickUpload() {
                this.$refs.uploadForm.validate((isValid) => {
                    if (isValid) {
                        if (this.$refs.upload.uploadFiles.length <= 0) {
                            this.$message.error('${select_picture}');
                            return;
                        } else if (this.$refs.upload.uploadFiles.length > 1) {
                            this.$message.error('${picture_selected}');
                            return;
                        }
                        this.$refs.upload.submit();
                    }
                });
            },
            myUpload() {
                var model = this.$refs.uploadForm.model;
                // var file = this.$refs.upload.uploadFiles[0].raw;
                var file = this.uploadBlob;

                var loading = layLoading3("${uploading}");
                var formData = new FormData();
                formData.append("person_name", model.person_name);
                formData.append("emp_number", model.emp_number);
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
                        if (0 === result.code) {
                            $("#person_tree").load("${pageContext.request.contextPath}/page/person/person_tree");
                            $("#person_content").load("${pageContext.request.contextPath}/page/person/person_add");
                        }
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
                this.$refs.upload.uploadFiles[0] = this.file;
                this.uploadBlob = dataURLtoBlob(base64url);//生成base64格式的blob
                this.cropperVisible = false;
                this.imageUrl = base64url;
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
