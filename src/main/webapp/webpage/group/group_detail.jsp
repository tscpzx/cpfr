<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    }

    .el-transfer-panel {
        width: 200px;
        height: 400px;
    }

    .el-transfer-panel__list.is-filterable {
        height: 300px;
    }
</style>
<div class="group_detail_box">
    <div id="group_detail">
        <template>
            <el-tabs v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="基本信息" name="first">
                    <%@include file="inc_tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--人员列表--%>
                <el-tab-pane label="人员列表" name="second">
                    <%@include file="inc_tabs/person_list.jsp" %>
                </el-tab-pane>
                <%--设备列表--%>
                <el-tab-pane label="设备列表" name="third">
                    <%@include file="inc_tabs/device_list.jsp" %>
                </el-tab-pane>
                <%--分配权限--%>
                <el-tab-pane label="分配权限" name="fourth">
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
    var vm = new Vue({
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
            pageSize1: 5
            ,
            tableData2: [],
            currentPage2: 1,
            pageSizes2: [5, 10, 20],
            pageSize2: 10
        },
        methods: {
            clickGrantPass() {
                var selectedPersonID = this.value1.join(',');
                var selectedDeviceID = $.arrayIntersect(value2, this.value2).join(',');

                ajaxGrant(selectedPersonID, selectedDeviceID, 1);
            },
            clickGrantBan() {
                var selectedPersonID = this.value1.join(',');
                var selectedDeviceID = $.arrayIntersect(value2, this.value2).join(',');

                ajaxGrant(selectedPersonID, selectedDeviceID, 0);
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
            }
        }
    });

    function ajaxGrant(person_ids, device_ids, type) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: {
                person_ids: person_ids,
                device_ids: device_ids,
                type: type,
                pass_number: -1,
                pass_start_time: -1,
                pass_end_time: -1
            },
            success: function (result) {
                layTip(result.message);
            }
        })
    }

    ajaxPersonList(vm.currentPage1, vm.pageSize1);

    function ajaxPersonList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list_base64",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                group_id: data.group.group_id
            },
            success: function (result) {
                vm.tableData1 = result.data;
            }
        });
    }

    ajaxDeviceList(vm.currentPage2, vm.pageSize2);

    function ajaxDeviceList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                group_id: data.group.group_id
            },
            success: function (result) {
                vm.tableData2 = result.data;
            }
        });
    }

    var vmDialogPersonList = new Vue({
        el: "#dialog_person_list",
        data: {
            items: [{
                person_id: -1,
                person_name: '人员列表',
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
                        $("#group_content").load("${pageContext.request.contextPath}/group/detail?group_id=" + data.group.group_id);
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
                device_name: '设备列表',
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
                        $("#group_content").load("${pageContext.request.contextPath}/group/detail?group_id=" + data.group.group_id);
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
                vmDialogPersonList.items[0].children = result.data;
                vmDialogPersonList.visible = true;
            }
        });
    }

    function openDialogDevice() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (result) {
                vmDialogDeviceList.items[0].children = result.data;
                vmDialogDeviceList.visible = true;
            }
        });
    }
</script>
