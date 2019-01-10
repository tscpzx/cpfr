<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .device_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }
</style>
<div class="device_detail_box">
    <div id="device_detail">
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
            model: {
                device_name: device.device_name,
                open_door_type: device.open_door_type,
                success_msg: device.success_msg,
                fail_msg: device.fail_msg
            }
        },
        methods: {
            handleChange1(val) {
                ajaxGrantPersonList(this.currentPage1, this.pageSize1);
            },
            changeDeviceInfo() {
                ajaxChangeDeviceInfo({
                    device_sn: device.device_sn,
                    device_name: this.model.device_name,
                    open_door_type: this.model.open_door_type,
                    success_msg: this.model.success_msg,
                    fail_msg: this.model.fail_msg
                })
            },
            restoreDeviceInfo() {
                this.model.device_name = device.device_name;
                this.model.open_door_type = device.open_door_type;
                this.model.success_msg = device.success_msg;
                this.model.fail_msg = device.fail_msg;
            },
            banGrantPerson(scope) {
                ajaxBanGrantPerson(scope);
            }
        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });

    ajaxGrantPersonList(vm.currentPage1, vm.pageSize1);

    function ajaxGrantPersonList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/grant_person_list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                device_sn: device.device_sn
            },
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
            }
        });
    }

    function ajaxBanGrantPerson(scope) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/grant/ban",
            data:{
                device_ids:device.device_id,
                person_ids:scope.row.person_id
            },
            success: function (result) {
                layAlert1(result.message);
                arrayRemoveObj(vm.tableData1,scope.row);
                vm.tableTotal--;
            }
        });
    }
</script>
