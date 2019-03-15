<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_rule_box {
        padding: 20px;
    }
</style>
<div class="attend_rule_box">
    <div id="rule_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>规则列表</el-breadcrumb-item>
            <el-breadcrumb-item>{{data.attend_name}}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form ref="ruleForm" :model="ruleForm" label-width="120px">
            <el-form-item label="考勤名称:">
                <span>{{data.attend_name}}</span>
            </el-form-item>
            <el-col :span="12">
                <el-form-item label="上班时间:" prop="am_punch_in_time">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.am_punch_in_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" autocomplete="off" :disabled="disabledEdit"></el-time-picker>
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
                            value-format="HH:mm" format="HH:mm" :disabled="disabledEdit">
                    </el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="午休开始时间:">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.noon_punch_out_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" :disabled="disabledEdit"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="午休结束时间:">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.noon_punch_in_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" :disabled="disabledEdit"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="下班时间:" prop="pm_punch_out_time">
                    <el-time-picker placeholder="选择时间" v-model="ruleForm.pm_punch_out_time" size="medium"
                                    value-format="HH:mm"
                                    format="HH:mm" :disabled="disabledEdit"></el-time-picker>
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
                            value-format="HH:m" format="HH:m" :disabled="disabledEdit">
                    </el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item label="工作日:" prop="work_day">
                    <template>
                        <el-checkbox-group v-model="ruleForm.work_day" :disabled="disabledEdit">
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
                <el-form-item>
                    <el-button type="success" v-on:click="saveRule('ruleForm')" size="small" v-show="saveShow">保存
                    </el-button>
                    <el-button type="info" v-on:click="cancel()" size="small" v-show="cancelShow">取消</el-button>
                    <el-button type="primary" v-on:click="updateRule()" size="small" v-show="updateShow">编辑</el-button>
                    <el-button type="danger" v-on:click="deleteRule('ruleForm')" size="small">删除</el-button>

                </el-form-item>
            </el-col>
        </el-form>
    </div>

</div>
</div>

<script type="text/javascript">
    var data = $.parseJSON('${data}');
    l(data);
    l("时间：" + new Date(data.am_punch_in_time));
    var vm_rule = new Vue({
        el: '#rule_detail',
        data: {
            ruleForm: {
                attend_name: data.attend_name,
                work_day: data.work_day.split(",")
            },
            checked: false,
            disabledEdit: true,
            cancelShow: false,
            saveShow: false,
            updateShow: true
        },
        methods: {
            deleteRule(scope) {

            },
            updateRule() {
                vm_rule.disabledEdit = false;
                vm_rule.cancelShow = true;
                vm_rule.saveShow = true;
                vm_rule.updateShow = false;
            },
            saveRule(scope) {
                vm_rule.disabledEdit = true;
                vm_rule.cancelShow = false;
                vm_rule.updateShow = true;
                vm_rule.saveShow = false;
            },
            cancel() {
                vm_rule.disabledEdit = true;
                vm_rule.cancelShow = false;
                vm_rule.updateShow = true;
                vm_rule.saveShow = false;
            }
        }
    });

</script>
