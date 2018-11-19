<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    .person_add_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
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
</style>
<div class="person_add_box">
    <div id="person_add">
        <el-form label-width="150px" :model="model" :rules="rules" ref="uploadForm">
            <el-form-item label="姓名:" prop="person_name">
                <el-input v-model="model.person_name" type="text" autocomplete="off" placeholder="请输入姓名"></el-input>
            </el-form-item>
            <el-form-item label="工号:" prop="emp_number">
                <el-input v-model="model.emp_number" type="text" autocomplete="off" placeholder="请输入工号"></el-input>
            </el-form-item>
            <el-form-item label="选择图片:">
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
                <el-button type="primary" v-on:click="onClickUpload()">添加</el-button>
            </el-form-item>
        </el-form>
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
                        {required: true, message: '请输入姓名', trigger: 'blur'}
                    ]
                },
                imageUrl: '',
                action: "${pageContext.request.contextPath}/person/add",
            }
        },
        methods: {
            onChange(file, fileList) {
                this.$refs.upload.clearFiles();
                this.imageUrl = URL.createObjectURL(file.raw);
                this.$refs.upload.uploadFiles[0] = file;
            },
            beforeUpload(file) {
                const isSuppType = file.type.indexOf("image") !== -1;
                const isLt3M = file.size / 1024 / 1024 < 3;

                if (!isSuppType) {
                    this.$message.error('不支持该类型的文件!');
                }
                if (!isLt3M) {
                    this.$message.error('上传图片大小不能超过 3MB!');
                }
                return isSuppType && isLt3M;
            },
            onClickUpload() {
                this.$refs.uploadForm.validate((isValid) => {
                    if (isValid) {
                        if (this.$refs.upload.uploadFiles.length <= 0) {
                            this.$message.error('请选择图片!');
                            return;
                        } else if (this.$refs.upload.uploadFiles.length > 1) {
                            this.$message.error('只能选择一张图片!');
                            return;
                        }
                        this.$refs.upload.submit();
                    }
                });
            },
            myUpload() {
                var model = this.$refs.uploadForm.model;
                var file = this.$refs.upload.uploadFiles[0].raw;

                var loading = layLoading3("上传中...");
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
                    },
                    error: function (error) {
                        layAlert1(error.statusText);
                    },
                    complete: function (xhr, textStatus) {
                        top.layer.close(loading);
                    }
                });
            }
        }
    });
</script>
