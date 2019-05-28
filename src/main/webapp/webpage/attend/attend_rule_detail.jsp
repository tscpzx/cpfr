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
                            value-format="HH:mm" format="HH:mm" :disabled="disabledEdit">
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
            <el-form-item label="状态:">
                <%--<el-switch v-model="value1"  active-color="#13ce66"--%>
                <%--inactive-color="#ff4949"--%>
                <%--active-text="已启动"--%>
                <%--inactive-text="未启动"></el-switch>--%>
                <%--</el-switch>--%>
                <el-tag v-if="data.status===1" :type="'success'"
                        disable-transitions>已启动
                </el-tag>
                <el-tag v-if="data.status===0" :type="'info'" disable-transitions>未启动</el-tag>
                <span v-if="data.status===2" :type="'warning'" disable-transitions>暂停</span>
            </el-form-item>

            <el-col :span="24">
                <el-form-item>
                    <el-button type="success" v-on:click="saveRule('ruleForm')" size="small" v-show="saveShow">保存
                    </el-button>
                    <el-button type="info" v-on:click="cancel()" size="small" v-show="cancelShow">取消</el-button>
                    <el-button type="primary" v-on:click="updateRule()" size="small" v-show="updateShow">编辑</el-button>
                    <el-button type="danger" v-on:click="deleteRule('ruleForm')" size="small">删除</el-button>
                    <el-button type="success" v-on:click="runJob('ruleForm')" size="small" style="margin-left: 20px"
                               v-show="runShow">启动
                    </el-button>
                    <span style="font-size: 12px;color:#909399;" v-show="runShow">（<i style="color: #F56C6C;">*</i> 使当前考勤设置生效）</span>
                    <el-button type="warning" v-on:click="stopJob('ruleForm')" size="small" style="margin-left: 20px"
                               v-show="stopShow">暂停
                    </el-button>
                    <span style="font-size: 12px;color:#909399;" v-show="stopShow">（<i style="color: #F56C6C;">*</i> 使当前考勤设置失效）</span>
                </el-form-item>
            </el-col>
        </el-form>
    </div>

</div>
</div>

<script type="text/javascript">
    var data = $.parseJSON('${data}');
    var jobStatus = '';
    if (data.status == 0) {
        jobStatus = true;
    } else {
        jobStatus = false;
    }
    var vm_rule = new Vue({
        el: '#rule_detail',
        data: {
            ruleForm: {
                attend_name: data.attend_name,
                am_punch_in_time: data.am_punch_in_time,
                work_day: data.work_day.split(","),
                am_punch_range: [data.am_punch_in_start, data.am_punch_in_end],
                pm_punch_out_time: data.pm_punch_out_time,
                pm_punch_range: [data.pm_punch_out_start, data.pm_punch_out_end],
                status: data.status,
            },
            checked: false,
            disabledEdit: true,
            cancelShow: false,
            saveShow: false,
            updateShow: true,
            runShow: jobStatus,
            stopShow: false
        },
        methods: {
            deleteRule(scope) {
                elmDialog("确定删除该考勤设置吗？相关人员将无法进行考勤！请慎重考虑！", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/attend/delete",
                        data: {
                            attend_id: data.attend_id,
                            job_id: data.job_id
                        },
                        success: function (result) {
                            layTip(result.message);
                            var rule = attend_tree.items[0].children;
                            for (var index in rule) {
                                if (data.attend_id === rule[index].attend_id) {
                                    rule.splice(index, 1);
                                    $("#attend_content").load("${pageContext.request.contextPath}/page/attend/attend_setting");
                                }
                            }
                        }
                    });
                });
            },
            updateRule() {
                if (jobStatus) {
                    vm_rule.stopShow = false;
                } else {
                    vm_rule.stopShow = true;
                }
                vm_rule.disabledEdit = false;
                vm_rule.cancelShow = true;
                vm_rule.saveShow = true;
                vm_rule.updateShow = false;
            },
            saveRule(form) {
                vm_rule.disabledEdit = true;
                vm_rule.cancelShow = false;
                vm_rule.updateShow = true;
                vm_rule.saveShow = false;
                vm_rule.stopShow = false;
                var data = {
                    attend_name: vm_rule.ruleForm.attend_name,
                    am_punch_in_time: vm_rule.ruleForm.am_punch_in_time,
                    am_punch_in_start: vm_rule.ruleForm.am_punch_range[0],
                    am_punch_in_end: vm_rule.ruleForm.am_punch_range[1],
                    pm_punch_out_time: vm_rule.ruleForm.pm_punch_out_time,
                    pm_punch_out_start: vm_rule.ruleForm.pm_punch_range[0],
                    pm_punch_out_end: vm_rule.ruleForm.pm_punch_range[1],
                    work_day: vm_rule.ruleForm.checkList.join(","),
                    status: vm_rule.ruleForm.status,
                };
                ajaxUpdateRule(data);

            },
            runJob(form) {
                elmDialog("您将启用该考勤设置吗？", function () {
                    ajaxGet({
                        url: "${pageContext.request.contextPath}/attend/run_job",
                        data: {
                            job_id: data.job_id
                        },
                        success: function (result) {
                            layTip(result.message);
                            $("#attend_content").load("${pageContext.request.contextPath}/attend/rule_detail?attend_id=" + data.attend_id);
                        }
                    });
                });
            },
            stopJob(form) {

            },
            cancel() {
                vm_rule.disabledEdit = true;
                vm_rule.cancelShow = false;
                vm_rule.updateShow = true;
                vm_rule.saveShow = false;
                vm_rule.stopShow = false;
            }
        }
    });

    function ajaxUpdateRule(data) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/attend/update",
            data: data,
            success: function (result) {
                layTip(result.message);
                if (0 === result.code) {
                    $("#attend_content").load("${pageContext.request.contextPath}/page/attend/attend_rule_detail");
                }
            }
        });
    }

</script>
