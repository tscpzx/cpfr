<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .person_detail_box {
        padding: 20px;
    }

    .el-form-item .el-input {
        width: 400px;
    }

    .div_group {
        margin: 10px 0 10px 0;
    }

    .el-date-editor--datetimerange.el-input__inner {
        width: 350px;
    }

    .div_group label {
        width: 150px;
        text-align: right;
        float: left;
        font-size: 14px;
        color: #606266;
        line-height: 40px;
        padding: 0 12px 0 0;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
    }
</style>
<div class="person_detail_box">
    <div id="person_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">

            <el-breadcrumb-item>${people_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${people_list}</el-breadcrumb-item>
            <el-breadcrumb-item>{{data.person_name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-tabs type="card" v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="${basic_info}" name="first">
                    <%@include file="inc_tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--可通行设备--%>
                <el-tab-pane label="${accessible_device}" name="second">
                    <%@include file="inc_tabs/access_device.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
        <%@ include file="../device/inc_dialog/dialog_change_grant.jsp" %>
    </div>
</div>
<%@include file="inc_dialog/dialog_device_list.jsp" %>

<script type="text/javascript">
    var data = '${data}';
    //base64去换行
    data = data.replace(/<\/?.+?>/g, "");
    data = data.replace(/[\r\n]/g, "");
    data = $.parseJSON(data);
    var vue = new Vue({
        el: "#person_detail",
        data: function () {
            return {
                data: data,
                rules: {
                    person_name: [
                        {required: true, message: '${enter_name}', trigger: 'blur'}
                    ]
                },
                activeName: 'first',
                personModel: {
                    person_name: data.person_name,
                    emp_number: data.emp_number
                },
                show: false,
                tableData: [],
                currentPage: 1,
                pageSizes: [5, 10, 20],
                pageSize: 10,
                tableTotal: '',
                pass_number: '',
                visible: false,
                dialogModel: {
                    radio1: '',
                    radio2: '',
                    pass_number: '',
                    dateValue: '',
                },
                grant: '',
                keyword: '',
                imageUrl: 'data:image/jpeg;base64,' + data.base_image,
                action: "${pageContext.request.contextPath}/person/update_info",
                cropperVisible: false,
                file: '',
                replace: false,
                uploadBlob: '',
                selectGroupModel:'',
                options2:[]
            }
        },

        methods: {
            deletePerson() {
                elmDialog("${sure_delete}", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/person/delete",
                        data: {
                            person_id: data.person_id
                        },
                        success: function (result) {
                            layTip(result.message);
                            var personList = vmPersonTree.items[0].children;
                            for (var index in personList) {
                                if (data.person_id === personList[index].person_id) {
                                    personList.splice(index, 1);
                                    $("#person_content").load("${pageContext.request.contextPath}/page/person/person_tbl");
                                }
                            }
                        }
                    });
                });
            },
            handleChange(val) {
                ajaxAccessDeviceList({
                    pageNum: this.currentPage,
                    pageSize: this.pageSize,
                    person_id: data.person_id
                });
            },
            banGrantDevice(scope) {
                elmDialog("${sure_ban}", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/grant/ban",
                        data: {
                            device_ids: scope.row.device_id,
                            person_ids: data.person_id
                        },
                        success: function (result) {
                            layAlert1(result.message);
                            arrayRemoveObj(vue.tableData, scope.row);
                            vue.tableTotal--;
                        }
                    });
                });
            },
            openDialogUpdateGrant(data) {
                this.visible = true;
                this.grant = data;
                this.dialogModel.pass_number = data.pass_number;
                this.dialogModel.dateValue = [data.pass_start_time, data.pass_end_time];
                if (data.pass_number === 9999999999) {
                    this.dialogModel.radio1 = '2';
                } else {
                    this.dialogModel.radio1 = '1';
                }
                if (dateToStamp(data.pass_start_time) === 9999999999 || dateToStamp(data.pass_end_time) === 9999999999) {
                    this.dialogModel.radio2 = '4';
                } else {
                    this.dialogModel.radio2 = '3';
                }
            },
            opened() {
                var $input = $('.input_pass_number');
                var $datePicker = $('.date_picker_pass_number');
                if (this.dialogModel.radio1 === '2') $input.hide();
                else $input.show();
                if (this.dialogModel.radio2 === '4') $datePicker.hide();
                else $datePicker.show();
            },
            onChangeRadio(index) {
                var $input = $('.input_pass_number');
                var $datePicker = $('.date_picker_pass_number');
                switch (index) {
                    case '1':
                        if (this.grant.pass_number === 9999999999)
                            this.dialogModel.pass_number = '';
                        else
                            this.dialogModel.pass_number = this.grant.pass_number;
                        $input.show();
                        break;
                    case '2':
                        this.dialogModel.pass_number = 9999999999;
                        $input.hide();
                        break;
                    case '3':
                        if (dateToStamp(this.grant.pass_start_time) === 9999999999 || dateToStamp(this.grant.pass_end_time) === 9999999999) {
                            this.dialogModel.dateValue = '';
                        } else {
                            this.dialogModel.dateValue = [this.grant.pass_start_time, this.grant.pass_end_time];
                        }
                        $datePicker.show();
                        break;
                    case '4':
                        this.dialogModel.dateValue = [stampToDate(9999999999), stampToDate(9999999999)];
                        $datePicker.hide();
                        break;
                }
            },
            changePersonGrant() {
                if (!this.dialogModel.pass_number) {
                    elmMessage1("${fill_number_passes}");
                    return;
                } else if (!this.dialogModel.dateValue) {
                    elmMessage1("${fill_passable_time}");
                    return;
                }

                ajaxChangePersonGrant({
                    person_ids: data.person_id,
                    device_ids: this.grant.device_id,
                    pass_number: this.dialogModel.pass_number,
                    pass_start_time: this.dialogModel.dateValue[0],
                    pass_end_time: this.dialogModel.dateValue[1],
                    grant_id: this.grant.grant_id
                });
            },
            searchDeviceLists() {
                ajaxAccessDeviceList({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    person_id: data.person_id,
                    keyword: this.keyword
                });
            },

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

                this.file = file;
                this.cropperVisible = true;
            },
            beforeUpload(file) {
                var isLt = true;
                if (this.uploadBlob) {
                    isLt = this.uploadBlob.size / 1024 < 65;
                    if (!isLt) this.$message.error('${image_large}');
                }

                return isLt;
            },
            onClickUpload() {
                this.$refs.perBaseInfoForm.validate((isValid) => {
                    if (isValid) {
                        if (this.$refs.upload.uploadFiles.length < 1) {
                            var model = this.$refs.perBaseInfoForm.model;
                            ajaxUpdatePersonInfo({
                                person_id: data.person_id,
                                person_name: model.person_name,
                                emp_number: model.emp_number
                            });
                        } else if (this.$refs.upload.uploadFiles.length > 1) {
                            this.$message.error('${picture_selected}');
                        } else
                            this.$refs.upload.submit();
                    }
                });
            },
            myUpload() {
                var model = this.$refs.perBaseInfoForm.model;
                var file = this.uploadBlob;

                var loading = layLoading3("${uploading}");
                var formData = new FormData();
                formData.append("person_id", data.person_id);
                formData.append("person_name", model.person_name);
                formData.append("emp_number", model.emp_number);
                formData.append("file", file);

                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/person/update_img_info",
                    contentType: false,//必须false才会自动加上正确的Content-Type
                    processData: false,//必须false才会避开jQuery对 formdata 的默认处理
                    data: formData,
                    beforeSend: function (xhr) {//setRequestHeader
                    },
                    xhr: function () { //获取ajaxSettings中的xhr对象，为它的upload属性绑定progress事件的处理函数
                        xhr = $.ajaxSettings.xhr();
                        if (xhr.upload) { //检查upload属性是否存在
                            //绑定progress事件的回调函数7
                            xhr.upload.addEventListener('progress', function (e) {
                                l(Math.round(((e.loaded / e.total) || 0) * 100));
                            }, false);
                        }
                        return xhr; //xhr对象返回给jQuery使用
                    },
                    success: function (result) {
                        layTip(result.message);
                        var personList = vmPersonTree.items[0].children;
                        for (var index in personList) {
                            if (data.person_id === personList[index].person_id) {
                                personList[index].person_name = model.person_name;
                            }
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
            },
            changeSelectGroup(value){
                ajaxAccessDeviceList({
                    pageNum: vue.currentPage,
                    pageSize: vue.pageSize,
                    person_id: data.person_id,
                    group_id:value
                });
            }
        },

        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });


    ajaxAccessDeviceList({
        pageNum: vue.currentPage,
        pageSize: vue.pageSize,
        person_id: data.person_id
    });


    function ajaxAccessDeviceList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/access_device_list",
            data: data,
            success: function (result) {
                vue.tableTotal = result.data.total;
                vue.tableData = result.data.list;
            }
        });
    }


    function ajaxUpdatePersonInfo(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/person/update_info",
            data: data,
            success: function (result) {
                layAlert1(result.message);
                var personList = vmPersonTree.items[0].children;
                for (var index in personList) {
                    if (data.person_id === personList[index].person_id) {
                        personList[index].person_name = data.person_name;
                    }
                }
            }
        });
    }

    function ajaxChangePersonGrant(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: data,
            success: function (result) {
                vue.visible = false;
                layTip(result.message);
                var deviceList = vue.tableData;
                for (var index in deviceList) {
                    if (data.grant_id === deviceList[index].grant_id) {
                        deviceList[index].pass_number = data.pass_number;
                        deviceList[index].pass_start_time = data.pass_start_time;
                        deviceList[index].pass_end_time = data.pass_end_time;
                    }
                }

            }
        });
    }

    var vmDialogDeviceList = new Vue({
        el: "#dialog_device_list",
        data: {
            items: [{
                device_id: -1,
                device_name: '${device_list}',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_name'
            },
            visible: false
        },
        methods: {
            onClickAddGrantDevice() {
                var device_ids = this.$refs.tree.getCheckedKeys();
                device_ids = removeArrMinusOne(device_ids).toString();

                var pass_number = 9999999999;
                var pass_start_time = stampToDate(9999999999);
                var pass_end_time = stampToDate(9999999999);
                ajaxPost({
                    url: "${pageContext.request.contextPath}/grant/add",
                    data: {
                        device_ids: device_ids,
                        person_ids: data.person_id,
                        pass_number: pass_number,
                        pass_start_time: pass_start_time,
                        pass_end_time: pass_end_time
                    },
                    success: function (result) {
                        layTip(result.message);
                        vmDialogDeviceList.visible = false;
                        ajaxAccessDeviceList({
                            pageNum: vue.currentPage,
                            pageSize: vue.pageSize,
                            person_id: data.person_id
                        });
                    }
                });
            }
        }
    });

    function openDialogDevice() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/group_device_list",
            data: {},
            success: function (result) {
                for (var i = 0; i < result.data.list.length; i++) {
                    vmDialogDeviceList.items[i] = {
                        device_id: -1,
                        device_name: result.data.list[i].group_name,
                        children: result.data.list[i].device_list
                    }
                }
                vmDialogDeviceList.visible = true;
            }
        });
    }

    /* 给选择部门的下拉框赋值 */
    for (var i = 0; i < data.group_list.length; i++) {
        vue.options2[i] = {
            label: data.group_list[i].group_name,
            value: data.group_list[i].group_id
        }
    }
</script>