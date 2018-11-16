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
        width: 250px;
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
                    <el-form label-width="60px">
                        <el-form-item label="组ID:">
                            <span>{{group.group_id}}</span>
                        </el-form-item>
                        <el-form-item label="组名:">
                            <el-input id="" v-bind:value="group.group_name" type="text" autocomplete="off"></el-input>
                        </el-form-item>
                    </el-form>
                </el-tab-pane>
                <%--人员列表--%>
                <el-tab-pane label="人员列表" name="second">授权人员</el-tab-pane>
                <%--设备列表--%>
                <el-tab-pane label="设备列表" name="third">授权设备</el-tab-pane>
                <%--分配权限--%>
                <el-tab-pane label="分配权限" name="fourth">
                    <template>
                        <el-transfer
                                filterable :filter-method="filterMethod1"
                                filter-placeholder="请输入人员关键字"
                                v-model="value1" :data="person_list" :props="props1"
                                :titles="['可选人员', '授权人员']"
                                :button-texts="['移除', '添加']">
                        </el-transfer>
                        <el-transfer
                                filterable :filter-method="filterMethod2"
                                filter-placeholder="请输入设备关键字"
                                v-model="value2" :data="device_list" :props="props2"
                                :titles="['授权设备', '可选设备']"
                                :button-texts="['添加', '移除']">
                        </el-transfer>

                        <el-form label-width="60px" style="margin-top: 30px;">
                            <el-form-item>
                                <el-button type="primary" @click="clickGrant">授权</el-button>
                            </el-form-item>
                        </el-form>

                    </template>
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
    new Vue({
        el: '#group_detail',
        data: function () {
            return {
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
                filterMethod1(query, item) {
                    return item.person_name.indexOf(query) > -1;
                },
                filterMethod2(query, item) {
                    return item.device_name.indexOf(query) > -1;
                }
            };
        },
        methods: {
            clickGrant() {
                var selectedPersonID = this.value1.join(',');
                var selectedDeviceID = $.arrayIntersect(value2, this.value2).join(',');

                ajaxGrant(selectedPersonID, selectedDeviceID);
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
</script>
