<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/resource/inc/lang.jsp" %>
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
            <el-breadcrumb-item>${equ_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${authorize_device}</el-breadcrumb-item>
            <el-breadcrumb-item>{{device.device_name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-tabs v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="${basic_info}" name="first">
                    <%@include file="inc_tabs/device_info.jsp" %>
                </el-tab-pane>
                <%--功能配置--%>
                <el-tab-pane label="${function_config}" name="second">
                    <%@include file="inc_tabs/device_config.jsp" %>
                </el-tab-pane>
                <%--已授权人员--%>
                <el-tab-pane label="${author_person}" name="third">
                    <%@include file="inc_tabs/grant_person.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
        <%@include file="inc_dialog/dialog_change_grant.jsp" %>
    </div>
</div>
<%@include file="inc_dialog/dialog_person_list.jsp" %>

<script type="text/javascript">
    var device = $.parseJSON('${data}');

    let vm = new Vue({
        el: "#device_detail",
        data: {
            device: device,
            activeName: 'first',
            options1: [{
                value: 0,
                label: '${human_face}'
            }, {
                value: 1,
                label: '${id_card}'
            }, {
                value: 2,
                label: '${job_number}'
            }, {
                value: 3,
                label: '${face_and_card}'
            }, {
                value: 4,
                label: '${face_and_num}'
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
            keyword: '',
            selectGroupModel: '',
            options2: [],
            group_id: ''
        },
        methods: {
            handleChange1(val) {
                ajaxGrantPersonList({
                    pageNum: this.currentPage1,
                    pageSize: this.pageSize1,
                    keyword: this.keyword,
                    group_id: this.group_id,
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
                    elmMessage1("${fill_number_passes}");
                    return;
                } else if (!this.dialogModel.dateValue) {
                    elmMessage1("${fill_passable_time}");
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
                    elmDialog("${offline_delete_device}", function () {
                        vm.dialog();
                    });
                else this.dialog();
            },
            dialog() {
                elmDialog("${note_delete_device}", function () {
                    ajaxDeleteDevice({
                        device_id: device.device_id
                    })
                });
            },
            selectGrantPersonList() {
                ajaxGrantPersonList({
                    pageNum: 1,
                    pageSize: this.pageSize1,
                    group_id: this.group_id,
                    device_sn: device.device_sn,
                    keyword: this.keyword
                });
            },
            checkUpdate() {
                ajaxPost({
                    url: "${pageContext.request.contextPath}/device/check_update",
                    data: {
                        device_sn: device.device_sn,
                    },
                    success: function (result) {
                        if (result.code === 105) {
                            elmAlert1(result.message)
                        } else
                            elmAlert1("未发现新版本")
                    }
                })
            }, openDialogPerson() {
                ajaxGet({
                    url: "${pageContext.request.contextPath}/person/group_person_list",
                    data: {
                        device_sn: device.device_sn
                    },
                    success: function (result) {
                        for (var i = 0; i < result.data.list.length; i++) {
                            vmDialogPersonList.items[i] = {
                                person_id: -1,
                                person_name: result.data.list[i].group_name,
                                children: result.data.list[i].person_list
                            }
                        }
                        vmDialogPersonList.visible = true;
                    }
                });
            },
            changeSelectGroup(value) {
                this.group_id=value
                ajaxGrantPersonList({
                    pageNum: vm.currentPage1,
                    pageSize: vm.pageSize1,
                    keyword: vm.keyword,
                    device_sn: device.device_sn,
                    group_id: value
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

    function ajaxGrantPersonList(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/grant_person_list",
            data: data,
            success: function (result) {
                vm.tableTotal = result.data.total;
                vm.tableData1 = result.data.list;
            }
        });
    };

    ajaxGrantPersonList({
        pageNum: vm.currentPage1,
        pageSize: vm.pageSize1,
        group_id: vm.group_id,
        keyword: vm.keyword,
        device_sn: device.device_sn
    });

    function ajaxChangeDeviceInfo(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/change_info",
            data: data,
            success: function (result) {
                layAlert1(result.message);
                var deviceList = vmDeviceTree.items[1].children;
                deviceList.find(device => {
                    if (data.device_sn === device.device_sn) {
                        device.device_name = data.device_name;
                    }
                })
            }
        });
    };

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
    };

    function ajaxChangePersonGrant(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: data,
            success: function (result) {
                layTip(result.message);
                vm.visible = false;

                let personList = vm.tableData1;
                personList.find(person => {
                    if (data.grant_id === person.grant_id) {
                        person.pass_number = data.pass_number;
                        person.pass_start_time = data.pass_start_time;
                        person.pass_end_time = data.pass_end_time;
                    }
                });
            }
        })
    };

    function ajaxDeleteDevice(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/device/delete",
            data: data,
            success: function (result) {
                layTip(result.message);
                $("#device_tree").load("${pageContext.request.contextPath}/page/device/device_tree");
                $("#device_content").load("${pageContext.request.contextPath}/page/device/device_tbl");
            }
        })
    };

    var vmDialogPersonList = new Vue({
        el: "#dialog_person_list",
        data: {
            items: [{
                person_id: -1,
                person_name: '${people_list}',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'person_name'
            },
            visible: false
        },
        methods: {
            onClickAddGrantPerson() {
                var person_ids = this.$refs.tree.getCheckedKeys();
                person_ids = removeArrMinusOne(person_ids).toString();

                var pass_number = 9999999999;
                var pass_start_time = stampToDate(9999999999);
                var pass_end_time = stampToDate(9999999999);
                ajaxPost({
                    url: "${pageContext.request.contextPath}/grant/add",
                    data: {
                        person_ids: person_ids,
                        device_ids: device.device_id,
                        pass_number: pass_number,
                        pass_start_time: pass_start_time,
                        pass_end_time: pass_end_time
                    },
                    success: (result) => {
                        layTip(result.message);
                        vmDialogPersonList.visible = false;
                        ajaxGrantPersonList({
                            pageNum: vm.currentPage1,
                            keyword: vm.keyword,
                            group_id: vm.group_id,
                            pageSize: vm.pageSize1,
                            device_sn: device.device_sn
                        });
                    }
                });
            }
        }
    });

    /* 给选择部门的下拉框赋值 */
    for (var i = 0; i < device.group_list.length; i++) {
        vm.options2[i] = {
            label: device.group_list[i].group_name,
            value: device.group_list[i].group_id
        }
    }
</script>
