<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style type="text/css">
    .grant_box {
        padding: 20px;
    }

    .el-col {
        font-size: 14px;
        font-weight: 500;
        color: #303133;
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
        width: 450px;
    }

    .el-transfer-panel .el-transfer-panel__header .el-checkbox .el-checkbox__label {
        font-size: 14px;
    }

    .el-transfer-panel .el-transfer-panel__header {
        padding-left: 5px;
    }
</style>

<div id="grant_box" class="grant_box">
    <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
        <el-breadcrumb-item>权限管理</el-breadcrumb-item>
        <el-breadcrumb-item>权限操作</el-breadcrumb-item>
    </el-breadcrumb>
    <%@include file="inc_tabs/grant.jsp" %>
</div>
<script type="text/javascript">
    var vmGrant = new Vue({
        el: '#grant_box',
        data: {
            group: '',
            person_list: [],
            device_list: [],
            value1: [],
            value2: [],
            value2model: [],
            props1: {
                label: 'person_name',
                key: 'person_id'
            },
            props2: {
                label: 'device_name',
                key: 'device_id'
            },
            radio1: '2',
            radio2: '4',
            pass_number: '',
            dateValue: '',
        },
        methods: {
            grantPass() {
                var person_ids = this.value1.join(',');
                var device_ids = $.arrayIntersect(this.value2model, this.value2).join(',');
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
                var device_ids = $.arrayIntersect(this.value2model, this.value2).join(',');
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

    ajaxGet({
        url: "${pageContext.request.contextPath}/person/list",
        data: {},
        success: function (result) {
            vmGrant.person_list = result.data.list;
        }
    });

    ajaxGet({
        url: "${pageContext.request.contextPath}/device/list",
        data: {},
        success: function (result) {
            vmGrant.device_list = result.data.list;
            for (var i = 0; i < vmGrant.device_list.length; i++) {
                vmGrant.value2[i] = vmGrant.device_list[i].device_id;
            }
            vmGrant.value2model = vmGrant.value2;
        }
    });
</script>