<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_box {
        padding: 20px;
    }

    .el-form-item {
        text-align: left;
    }

</style>


<div class="attend_box">
    <div id="attend_setting">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attend_setting}</el-breadcrumb-item>
        </el-breadcrumb>
        <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="120px">
            <el-col :span="12">
                <el-form-item label="上班时间:" prop="am_punch_in_time">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.am_punch_in_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" autocomplete="off"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="上班打卡范围:" prop="am_punch_range">
                    <el-time-picker
                            is-range
                            v-model="ruleForm.am_punch_range"
                            range-separator="至"
                            start-placeholder="开始时间"
                            end-placeholder="结束时间"
                            placeholder="选择时间范围"
                            size="medium"
                            value-format="HH:mm" format="HH:mm">
                    </el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="午休开始时间:">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.noon_punch_out_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" :disabled="disabledEdit"></el-time-picker>
                    <el-checkbox v-model="checked" @change="handleCheckedAttend">不考勤</el-checkbox>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="午休结束时间:">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.noon_punch_in_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" :disabled="disabledEdit"></el-time-picker>
                    <el-checkbox v-model="checked" @change="handleCheckedAttend">不考勤</el-checkbox>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="下班时间:" prop="pm_punch_out_time">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.pm_punch_out_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="下班打卡范围:" prop="pm_punch_range">
                    <el-time-picker
                            is-range
                            v-model="ruleForm.pm_punch_range"
                            range-separator="至"
                            start-placeholder="开始时间"
                            end-placeholder="结束时间"
                            placeholder="选择时间范围"
                            size="medium"
                            value-format="HH:mm" format="HH:mm">
                    </el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item label="工作日:" prop="checkList">
                    <template>
                        <el-checkbox-group v-model="ruleForm.checkList">
                            <el-checkbox label="1">周一</el-checkbox>
                            <el-checkbox label="2">周二</el-checkbox>
                            <el-checkbox label="3">周三</el-checkbox>
                            <el-checkbox label="4">周四</el-checkbox>
                            <el-checkbox label="5">周五</el-checkbox>
                            <el-checkbox label="6">周六</el-checkbox>
                            <el-checkbox label="7">周日</el-checkbox>
                        </el-checkbox-group>
                    </template>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item label="选择成员：">
                    <el-button icon="el-icon-plus" circle size="medium" @click="openDialogPeople"></el-button>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item>
                    <el-button type="success" v-on:click="saveSetting('ruleForm')" size="medium">${save}</el-button>
                    <el-button type="primary" v-on:click="resetForm('ruleForm')" size="medium">重置</el-button>

                </el-form-item>
            </el-col>
        </el-form>
    </div>
    <%@include file="inc_dialog/dialog_person_list.jsp" %>
</div>

<script type="text/javascript">
    var vm = new Vue({
        el: "#attend_setting",
        data: {
            ruleForm: {
                am_punch_in_time: '',
                am_punch_range: '',
                pm_punch_out_time: '',
                pm_punch_range: '',
                checkList: [],
                noon_punch_in_time: '',
                noon_punch_out_time: ''
            },
            checked: false,
            disabledEdit: false,
            rules: {
                am_punch_in_time: [
                    {required: true, message: '请选择上班时间', trigger: 'change'}
                ],
                am_punch_range: [{
                    required: true, message: '请选择上班打卡范围', trigger: 'change'
                }],
                pm_punch_out_time: [{required: true, message: '请选择下班时间', trigger: 'change'}],
                pm_punch_range: [{required: true, message: '请选择下班打卡范围', trigger: 'change'}],
                checkList: [{type: 'array', required: true, message: '请至少选择一个工作日', trigger: 'change'}]
            }
        },
        methods: {
            saveSetting(formName) {
                l(vm.ruleForm.checkList);
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        var data = {
                            am_punch_in_time: vm.ruleForm.am_punch_in_time,
                            am_punch_in_start: vm.ruleForm.am_punch_range[0],
                            am_punch_in_end: vm.ruleForm.am_punch_range[1],
                            pm_punch_out_time: vm.ruleForm.pm_punch_out_time,
                            pm_punch_out_start: vm.ruleForm.pm_punch_range[0],
                            pm_punch_out_end: vm.ruleForm.pm_punch_range[1],
                            work_day: vm.ruleForm.checkList.join(",")
                        };
                        ajaxAddRule(data);
                    } else {
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            },
            handleCheckedAttend(event) {
                if (vm.checked) {
                    vm.disabledEdit = true;
                } else {
                    vm.disabledEdit = false;
                }
            },


        }
    });

    function ajaxAddRule(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/attend/add",
            data: data,
            success: function (result) {
                layTip(result.message);
                if (0 === result.code) {
                    $("#content-container").load("attend/attend_setting");
                }
            }
        });

    }

    var vmDialogPersonList = new Vue({
        el: "#dialog_person_list",
        data: {
            items: [],
            defaultProps: {
                children: 'children',
                label: 'person_name'
            },
            visible: false
        },
        methods: {}
    });

    function openDialogPeople() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/listByGroup",
            data: {},
            success: function (result) {
                for (var i = 0; i < result.data.list.length; i++) {
                    vmDialogPersonList.items[i] = {
                        person_name: result.data.list[i].group_name,
                        children: result.data.list[i].person_list
                    }
                }
                vmDialogPersonList.visible = true;
            }
        });

    }


</script>