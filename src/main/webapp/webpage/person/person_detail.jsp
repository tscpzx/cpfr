<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .person_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

    .div_group {
        margin: 10px 0 10px 0;
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
        <template>
            <el-tabs type="card" v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="基本信息" name="first">
                    <%@include file="inc_tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--可通行设备--%>
                <el-tab-pane label="可通行设备" name="second">
                    <%@include file="inc_tabs/access_device.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
        <%@ include file="../device/inc_dialog/dialog_change_grant.jsp"%>
    </div>
</div>

<script type="text/javascript">
    var data = '${data}';
    //base64去换行
    data = data.replace(/<\/?.+?>/g, "");
    data = data.replace(/[\r\n]/g, "");
    data = $.parseJSON(data);
    var vue =  new Vue({
        el: "#person_detail",
        data: function () {
            return {
                data: data,
                activeName: 'first',
                personModel: {
                    person_name:data.person_name ,
                    emp_number:data.emp_number
                },
                show:false,
                tableData: [],
                currentPage: 1,
                pageSizes: [5, 10, 20],
                pageSize: 10,
                tableTotal:'',
                pass_number: '',
                visible:false,
                dialogModel: {
                    radio1: '',
                    radio2: '',
                    pass_number: '',
                    dateValue: '',
                },
                grant:'',
                searchVal:''
            }
        },

        methods: {
            updatePerson(formName) {
                var model = this.$refs[formName].model;
                ajaxUpdatePersonInfo({
                    person_id: data.person_id,
                    person_name: model.person_name,
                    emp_number:model.emp_number
                });
            },
            deletePerson() {
                elmDialog("确定要删除该员工吗", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/person/delete",
                        data: {
                            person_id: data.person_id
                        },
                        success: function (result) {
                            vue.dialogVisible = false;
                            layTip(result.message);
                            var personList = vmPersonTree.items[0].children ;
                            for (var index in personList) {
                                if (data.person_id === personList[index].person_id) {
                                    personList.splice(index);
                                    $("#person_content").load("person/person_tbl");
                                }
                            }
                        }
                    });
                });
            },

            handleChange(val) {
              ajaxAccessDeviceList(this.currentPage, this.pageSize);
            },

            banGrantDevice(scope){
                elmDialog("确定这台设备禁止该员工通行吗？", function () {
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
                    elmMessage1("请填写可通行次数");
                    return;
                } else if (!this.dialogModel.dateValue) {
                    elmMessage1("请填写可通行时段");
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

            searchDevice(searchVal){
                ajaxGet({
                    url: "${pageContext.request.contextPath}/person/search_device",
                    data: {
                        device_name: searchVal,
                        person_id: data.person_id
                    },
                    success: function (result) {
                        vue.tableTotal = result.data.total;
                        vue.tableData = result.data.list;
                    }
                });
            },

        },

        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });


    ajaxAccessDeviceList(vue.currentPage, vue.pageSize);


    function ajaxAccessDeviceList(pageNum, pageSize) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/access_device_list",
            data: {
                pageNum: pageNum,
                pageSize: pageSize,
                person_id: data.person_id
            },
            success: function (result) {
                vue.tableTotal = result.data.total;
                vue.tableData = result.data.list;
            }
        });
    }



    function ajaxUpdatePersonInfo(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/update_info",
            data: data,
            success: function (result) {
                layAlert1(result.message);
                var personList = vmPersonTree.items[0].children ;
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
                var  deviceList = vue.tableData;
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
</script>