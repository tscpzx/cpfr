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
                    <%@include file="tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--人员列表--%>
                <el-tab-pane label="人员列表" name="second">
                    <%@include file="tabs/person_list.jsp" %>
                </el-tab-pane>
                <%--设备列表--%>
                <el-tab-pane label="设备列表" name="third">
                    <%@include file="tabs/device_list.jsp" %>
                </el-tab-pane>
                <%--分配权限--%>
                <el-tab-pane label="分配权限" name="fourth">
                    <%@include file="tabs/grant.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
    </div>
</div>
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
            pageSize2: 5
        },
        methods: {
            clickGrant() {
                var selectedPersonID = this.value1.join(',');
                var selectedDeviceID = $.arrayIntersect(value2, this.value2).join(',');

                ajaxGrant(selectedPersonID, selectedDeviceID);
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

    function ajaxGrant(person_ids, device_ids) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/grant/add",
            data: {
                person_ids: person_ids,
                device_ids: device_ids,
                type: 1,
                pass_number: -1,
                pass_start_time: -1,
                pass_end_time: -1
            },
            success: function (result) {
                layTip("授权成功");
            }
        })
    }

    ajaxPersonList(vm.currentPage1, vm.pageSize1);

    function ajaxPersonList(pageNum, pageSize) {
        l(pageNum + "," + pageSize)
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list",
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
        l(pageNum + "," + pageSize)
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
</script>
