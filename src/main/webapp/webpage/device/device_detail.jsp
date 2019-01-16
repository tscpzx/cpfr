<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .device_detail_box {
        padding: 20px;
    }

    .el-form-item .el-input {
        width: 400px;
    }

    .el-date-editor--datetimerange.el-input__inner {
        width: 350px;
    }
</style>
<div class="device_detail_box">
    <div id="device_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>设备管理</el-breadcrumb-item>
            <el-breadcrumb-item>已激活设备</el-breadcrumb-item>
            <el-breadcrumb-item>{{device.device_name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-tabs v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="基本信息" name="first">
                    <%@include file="inc_tabs/device_info.jsp" %>
                </el-tab-pane>
                <%--功能配置--%>
                <el-tab-pane label="功能配置" name="second">
                    <%@include file="inc_tabs/device_config.jsp" %>
                </el-tab-pane>
                <%--已授权人员--%>
                <el-tab-pane label="已授权人员" name="third">
                    <%@include file="inc_tabs/grant_person.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
        <%@include file="inc_dialog/dialog_change_grant.jsp" %>
    </div>
</div>

<script type="text/javascript">
    var device = $.parseJSON('${data}');

    var vm = new Vue({
        el: "#device_detail",
        data: {
            device: device,
            activeName: 'first',
            options: [{
                value: 0,
                label: '人脸'
            }, {
                value: 1,
                label: '身份证'
            }, {
                value: 2,
                label: '工号'
            }, {
                value: 3,
                label: '人脸+身份征'
            }, {
                value: 4,
                label: '人脸+工号'
            }],
            tableData1: [],
            currentPage1: 1,
            pageSizes1: [5, 10, 20],
            pageSize1: 10,
            tableTotal: ''
            ,
            deviceModel: {
                device_name: device.device_name,
                open_door_type: device.open_door_type,
                success_msg: device.success_msg,
                fail_msg: device.fail_msg
            },
            visible: false,
            dialogModel: {
                radio1: '',
                radio2: '',
                pass_number: '',
                dateValue: '',
            },
            grant: '',
            keyword: ''
        },
        methods: {
            handleChange1(val) {
                ajaxGrantPersonList({
                    pageNum: this.currentPage1,
                    pageSize: this.pageSize1,
                    device_sn: device.device_sn
                });
            },
            changeDeviceInfo() {
                ajaxChangeDeviceInfo({
                    device_sn: device.device_sn,
                    device_name: this.deviceModel.device_name,
                    open_door_type: this.deviceModel.open_door_type,
                    success_msg: this.deviceModel.success_msg,
                    fail_msg: this.deviceModel.fail_msg
                })
            },
            restoreDeviceInfo() {
                this.deviceModel.device_name = device.device_name;
                this.deviceModel.open_door_type = device.open_door_type;
                this.deviceModel.success_msg = device.success_msg;
                this.deviceModel.fail_msg = device.fail_msg;
            },
            banGrantPerson(scope) {
                ajaxBanGrantPerson(scope);
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
            openDialogChangeGrant(data) {
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
            changePersonGrant() {
                if (!this.dialogModel.pass_number) {
                    elmMessage1("请填写可通行次数");
                    return;
                } else if (!this.dialogModel.dateValue) {
                    elmMessage1("请填写可通行时段");
                    return;
                }

                ajaxChangePersonGrant({
                    person_ids: this.grant.person_id,
                    device_ids: this.device.device_id,
                    pass_number: this.dialogModel.pass_number,
                    pass_start_time: this.dialogModel.dateValue[0],
                    pass_end_time: this.dialogModel.dateValue[1],
                    grant_id: this.grant.grant_id
                });
            },
            deleteDevice() {
                if (this.device.online === 0)
                    elmDialog("设备处于离线状态,是否要继续删除该设备?", function () {
                        vm.dialog();
                    });
                else this.dialog();
            },
            dialog() {
                elmDialog("注意: 删除设备会删除该设备信息以及相关权限数据,确定要删除该设备吗", function () {
                    ajaxDeleteDevice({
                        device_id: this.device.device_id
                    })
                });
            },
            selectGrantPersonList() {
                ajaxGrantPersonList({
                    pageNum: 1,
                    pageSize: this.pageSize1,
                    device_sn: device.device_sn,
                    keyword: this.keyword
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

    ajaxGrantPersonList({
        pageNum: vm.currentPage1,
        pageSize: vm.pageSize1,
        device_sn: device.device_sn
    });

    function ajaxGrantPersonList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/grant_person_list",
            data: data,
            success: function (result) {
                vm.tableTotal = result.data.total;
                vm.tableData1 = result.data.list;
            }
        });
    }

    function ajaxChangeDeviceInfo(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/change_info",
            data: data,
            success: function (result) {
                layAlert1(result.message);
                var deviceList = vmDeviceTree.items[1].children;
                for (var index in deviceList) {
                    if (data.device_sn === deviceList[index].device_sn) {
                        deviceList[index].device_name = data.device_name;
                    }
                }
            }
        });
    }

    function ajaxBanGrantPerson(scope) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/grant/ban",
            data: {
                device_ids: device.device_id,
                person_ids: scope.row.person_id
            },
            success: function (result) {
                layAlert1(result.message);
                arrayRemoveObj(vm.tableData1, scope.row);
                vm.tableTotal--;
            }
        });
    }

    function ajaxChangePersonGrant(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: data,
            success: function (result) {
                layTip(result.message);
                vm.visible = false;

                var personList = vm.tableData1;
                for (var index in personList) {
                    if (data.grant_id === personList[index].grant_id) {
                        personList[index].pass_number = data.pass_number;
                        personList[index].pass_start_time = data.pass_start_time;
                        personList[index].pass_end_time = data.pass_end_time;
                    }
                }
            }
        })
    }

    function ajaxDeleteDevice(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/device/delete",
            data: data,
            success: function (result) {
                layTip(result.message);
                $("#device_tree").load("device/device_tree");
                $("#device_content").load("device/device_tbl");
            }
        })
    }
</script>
