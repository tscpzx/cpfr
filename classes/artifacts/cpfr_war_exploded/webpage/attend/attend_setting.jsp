<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_box {
        padding: 20px;
        text-align: center;
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
        <el-form ref="form" :model="form" label-width="120px">
            <el-col :span="12">
                <el-form-item label="上班时间:">
                    <el-time-picker placeholder="选择时间" v-model="form.date1" size="medium" value-format="HH:mm"
                                    format="HH:mm"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="上班打卡范围:">
                    <el-time-picker
                            is-range
                            v-model="form.date2"
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
                    <el-time-picker placeholder="选择时间" v-model="form.date3" size="medium" value-format="HH:mm"
                                    format="HH:mm"></el-time-picker>
                    <el-checkbox v-model="checked1">不考勤</el-checkbox>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="午休结束时间:">
                    <el-time-picker placeholder="选择时间" v-model="form.date4" size="medium" value-format="HH:mm"
                                    format="HH:mm"></el-time-picker>
                    <el-checkbox v-model="checked2">不考勤</el-checkbox>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="下班时间:">
                    <el-time-picker placeholder="选择时间" v-model="form.date5" size="medium" value-format="HH:mm"
                                    format="HH:mm"></el-time-picker>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <el-form-item label="下班打卡范围:">
                    <el-time-picker
                            is-range
                            v-model="form.date6"
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
                <el-form-item label="工作日:">
                    <template>
                        <el-checkbox-group v-model="checkList">
                            <el-checkbox label="周一"></el-checkbox>
                            <el-checkbox label="周二"></el-checkbox>
                            <el-checkbox label="周三"></el-checkbox>
                            <el-checkbox label="周四"></el-checkbox>
                            <el-checkbox label="周五"></el-checkbox>
                            <el-checkbox label="周六"></el-checkbox>
                            <el-checkbox label="周日"></el-checkbox>
                        </el-checkbox-group>
                    </template>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item label="选择成员：">
                    <el-button icon="el-icon-plus" circle size="medium"></el-button>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item label="选择设备：">
                    <el-button icon="el-icon-plus" circle size="medium"/>
                </el-form-item>
            </el-col>
            <el-col :span="24">
                <el-form-item>
                    <el-button type="success" v-on:click="saveSetting" size="medium">${save}</el-button>
                </el-form-item>
            </el-col>
        </el-form>

    </div>
</div>


<script type="text/javascript">
    var vm = new Vue({
        el: "#attend_setting",
        data: {
            form: {},
            checked1: false,
            checked2: false,
            checkList: []
        },
        methods: {
            saveSetting() {

            }
        }
    });

</script>