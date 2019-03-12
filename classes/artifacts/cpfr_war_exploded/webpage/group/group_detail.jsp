<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .el-col {
        font-size: 14px;
        font-weight: 500;
        color: #303133;
    }

    .group_detail_box {
        padding: 20px;
    }

    .el-form-item .el-input {
        width: 400px;
    }

    .el-transfer {
        display: inline-block;
        width: 49%;
    }

    .el-transfer-panel {
        width: 38%;
        height: 400px;
    }

    .el-transfer-panel__list.is-filterable {
        height: 300px;
    }

    .el-date-editor--datetimerange.el-input__inner {
        width: 350px;
    }
    .el-transfer-panel .el-transfer-panel__header .el-checkbox .el-checkbox__label {
        font-size: 14px;
    }
    .el-transfer-panel .el-transfer-panel__header{
        padding-left: 5px;
    }
</style>
<div class="group_detail_box">
    <div id="group_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${group_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${group_list}</el-breadcrumb-item>
            <el-breadcrumb-item>{{data.group.group_name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <template>
            <el-tabs v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="${basic_info}" name="first">
                    <%@include file="inc_tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--人员列表--%>
                <el-tab-pane label="${people_list}" name="second">
                    <%@include file="inc_tabs/person_list.jsp" %>
                </el-tab-pane>
                <%--设备列表--%>
                <el-tab-pane label="${device_list}" name="third">
                    <%@include file="inc_tabs/device_list.jsp" %>
                </el-tab-pane>
                <%--分配权限--%>
                <el-tab-pane label="${assign_permission}" name="fourth">
                    <%@include file="inc_tabs/grant.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
    </div>
</div>
<%@include file="inc_dialog/dialog_person_list.jsp" %>
<%@include file="inc_dialog/dialog_device_list.jsp" %>
<script type="text/javascript">
    var data = $.parseJSON('${data}');

    var value2 = [];
    for (var i = 0; i < data.device_list.length; i++) {
        value2[i] = data.device_list[i].device_id;
    }
    var vmGroupDetail = new Vue({
        el: '#group_detail',
        data: {
            group: data.group,
            person_list: data.person_list,
            device_list: data.device_list,
            value1: [],
            value2: value2,
            props1: {
                label: 'person_name',
                key: 'person_id'
            },
            props2: {
                label: 'device_name',
                key: 'device_id'
            },
            activeName: 'first',
            tableData1: [],
            currentPage1: 1,
            pageSizes1: [5, 10, 20],
            pageSize1: 5,
            total1:''
            ,
            tableData2: [],
            currentPage2: 1,
            pageSizes2: [5, 10, 20],
            pageSize2: 10,
            total2:''
            ,
            radio1: '2',
            radio2: '4',
            pass_number: '',
            dateValue: '',
            groupModel: {
                group_name: data.group.group_name
            }
        },
        methods: {
            grantPass() {
                var person_ids = this.value1.join(',');
                var device_ids = $.arrayIntersect(value2, this.value2).join(',');
                var pass_number = 9999999999;
                var pass_start_time = stampToDate(9999999999);
                var pass_end_time = stampToDate(9999999999);

                if (!person_ids) {
                    elmMessage1("${add_authorized_person}");
                    return;
                }
                if (!device_ids) {
                    elmMessage1("${add_authorized_device}");
                    return;
                }

                if (this.radio1 === '1') {
                    if (!this.pass_number.trim()) {
                        elmMessage1("${fill_number_passes}");
                        return;
                    }
                    pass_number = this.pass_number;
                }
                if (this.radio2 === '3') {
                    if (!this.dateValue) {
                        elmMessage1("${fill_passable_time}");
                        return;
                    }
                    pass_start_time = this.dateValue[0];
                    pass_end_time = this.dateValue[1];
                }
                var data = {
                    person_ids: person_ids,
                    device_ids: device_ids,
                    pass_number: pass_number,
                    pass_start_time: pass_start_time,
                    pass_end_time: pass_end_time
                };
                ajaxGrantPass(data);
            },
            banPass() {
                var person_ids = this.value1.join(',');
                var device_ids = $.arrayIntersect(value2, this.value2).join(',');
                if (!person_ids) {
                    elmMessage1("${add_authorized_person}");
                    return;
                }
                if (!device_ids) {
                    elmMessage1("${add_authorized_device}");
                    return;
                }

                var data = {
                    person_ids: person_ids,
                    device_ids: device_ids
                };
                ajaxBanPass(data);
            },
            filterMethod1(query, item) {
                return item.person_name.indexOf(query) > -1;
            },
            filterMethod2(query, item) {
                return item.device_name.indexOf(query) > -1;
            },
            handleChange1(val) {
                ajaxPersonList(this.currentPage1, this.pageSize1);
            },
            handleChange2(val) {
                ajaxDeviceList(this.currentPage2, this.pageSize2);
            },
            onChangeRadio(index) {
                var $input = $('.input_pass_number');
                var $datePicker = $('.date_picker_pass_number');
                switch (index) {
                    case '1':
                        $input.show();
                        break;
                    case '2':
                        $input.hide();
                        break;
                    case '3':
                        $datePicker.show();
                        break;
                    case '4':
                        $datePicker.hide();
                        break;
                }
            },
            updateGroupInfo() {
                ajaxPost({
                    url: "${pageContext.request.contextPath}/group/update_info",
                    data: {
                        group_id: data.group.group_id,
                        group_name: this.groupModel.group_name
                    },
                    success: function (result) {
                        layAlert1(result.message);
                        var groupList = vmGroupTree.items[0].children;
                        for (var index in groupList) {
                            if (data.group.group_id === groupList[index].group_id) {
                                groupList[index].group_name = vmGroupDetail.groupModel.group_name;
                            }
                        }
                    }
                })
            },
            deleteGroup() {
                elmDialog("${delete_group}", function () {
                    ajaxPost({
                        url: "${pageContext.request.contextPath}/group/delete",
                        data: {
                            group_id: data.group.group_id
                        },
                        success: function (result) {
                            layAlert1(result.message);
                            var groupList = vmGroupTree.items[0].children;
                            for (var index in groupList) {
                                if (data.group.group_id === groupList[index].group_id) {
                                    groupList.splice(index, 1);
                                    $("#group_content").load("group/group_tbl");
                                }
                            }
                        }
                    })
                });
            },
            deleteGroupPerson(person) {
                ajaxPost({
                    url: "${pageContext.request.contextPath}/group/delete_person",
                    data: {
                        group_id: data.group.group_id,
                        person_id: person.person_id
                    },
                    success: function (result) {
                        arrayRemoveObj(vmGroupDetail.tableData1, person);
                        vmGroupDetail.total1--;
                    }
                })
            },
            deleteGroupDevice(device) {
                ajaxPost({
                    url: "${pageContext.request.contextPath}/group/delete_device",
                    data: {
                        group_id: data.group.group_id,
                        device_id: device.device_id
                    },
                    success: function (result) {
                        arrayRemoveObj(vmGroupDetail.tableData2, device);
                        vmGroupDetail.total2--;
                    }
                })
            },
        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });

    function ajaxGrantPass(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: data,
            success: function (result) {
                layTip(result.message);
            }
        })
    }

    function ajaxBanPass(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/ban",
            data: data,
            success: function (result) {
                layTip(result.message);
            }
        })
    }

    ajaxPersonList(vmGroupDetail.currentPage1, vmGroupDetail.pageSize1);

    function ajaxPersonList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list_base64",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                group_id: data.group.group_id
            },
            success: function (result) {
                vmGroupDetail.tableData1 = result.data.list;
                vmGroupDetail.total1 = result.data.total;
            }
        });
    }

    ajaxDeviceList(vmGroupDetail.currentPage2, vmGroupDetail.pageSize2);

    function ajaxDeviceList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                group_id: data.group.group_id
            },
            success: function (result) {
                vmGroupDetail.tableData2 = result.data.list;
                vmGroupDetail.total2 = result.data.total;
            }
        });
    }

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
            onClickGroupAddPerson() {
                var person_ids = this.$refs.tree.getCheckedKeys().join(",");
                ajaxPost({
                    url: "${pageContext.request.contextPath}/group/add_person",
                    data: {
                        person_ids: person_ids,
                        group_id: data.group.group_id
                    },
                    success: function (result) {
                        layTip(result.message);
                        vmDialogPersonList.visible = false;
                        ajaxPersonList(vmGroupDetail.currentPage1, vmGroupDetail.pageSize1);
                    }
                });
            }
        }
    });

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
            onClickGroupAddDevice() {
                var device_ids = this.$refs.tree.getCheckedKeys().join(",");
                ajaxPost({
                    url: "${pageContext.request.contextPath}/group/add_device",
                    data: {
                        device_ids: device_ids,
                        group_id: data.group.group_id
                    },
                    success: function (result) {
                        layTip(result.message);
                        vmDialogDeviceList.visible = false;
                        ajaxDeviceList(vmGroupDetail.currentPage2, vmGroupDetail.pageSize2);
                    }
                });
            }
        }
    });

    function openDialogPerson() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list",
            data: {},
            success: function (result) {
                vmDialogPersonList.items[0].children = result.data.list;
                vmDialogPersonList.visible = true;
            }
        });
    }

    function openDialogDevice() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (result) {
                vmDialogDeviceList.items[0].children = result.data.list;
                vmDialogDeviceList.visible = true;
            }
        });
    }
</script>
