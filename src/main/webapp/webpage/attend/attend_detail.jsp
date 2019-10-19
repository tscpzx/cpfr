<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .attend_box {
        padding: 20px;
    }

    .el-date-editor--daterange.el-input, .el-date-editor--daterange.el-input__inner, .el-date-editor--timerange.el-input, .el-date-editor--timerange.el-input__inner,.el-input.el-input--small.el-input--suffix {
        width: 250px;
    }

    .el-date-editor.el-input.attend_time_picker, .el-date-editor.el-input__inner.attend_time_picker{
        width: 123px;
    }
</style>

<div class="attend_box">
    <div id="attend_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${attend_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${attend_details}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-col :span="6">
            <el-form label-width="100px" size="small" ref="form" :model="model">
                <el-form-item label="选择日期">
                    <el-date-picker
                            unlink-panels
                            class="date_picker_pass_number"
                            v-model="model.date_range"
                            type="daterange"
                            range-separator="${to_lang}"
                            value-format="yyyy-MM-dd"
                            start-placeholder="${start_date}"
                            end-placeholder="${end_date}">
                    </el-date-picker>
                </el-form-item>

                <el-form-item label="上下班时间:">
                    <template>
                        <el-time-picker
                                class="attend_time_picker"
                                v-model="model.am_attend_time"
                                value-format="HH:mm" format="HH:mm"
                                placeholder="上班时间">
                        </el-time-picker>
                        <el-time-picker
                                class="attend_time_picker"
                                v-model="model.pm_attend_time"
                                value-format="HH:mm" format="HH:mm"
                                placeholder="下班时间">
                        </el-time-picker>
                    </template>
                </el-form-item>

                <el-form-item label="上班打卡范围:" prop="am_time_range">
                    <el-time-picker
                            is-range
                            v-model="model.am_time_range"
                            range-separator="至"
                            start-placeholder="开始时间"
                            end-placeholder="结束时间"
                            placeholder="选择时间范围"
                            value-format="HH:mm" format="HH:mm">
                    </el-time-picker>
                </el-form-item>
                <el-form-item label="下班打卡范围:" prop="pm_time_range">
                    <el-time-picker
                            is-range
                            v-model="model.pm_time_range"
                            range-separator="至"
                            start-placeholder="开始时间"
                            end-placeholder="结束时间"
                            placeholder="选择时间范围"
                            value-format="HH:mm" format="HH:mm">
                    </el-time-picker>
                </el-form-item>

                <el-form-item label="请选择部门:">
                    <el-select v-model="selectGroupModel" clearable placeholder="请选择部门" size="small">
                        <el-option
                                v-for="item in options"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>

                <el-form-item>
                    <el-button type="warning" v-on:click="queryAttend" size="small">搜索</el-button>
                    <el-button type="success" v-on:click="exportExcel" size="small">导出excel</el-button>
                </el-form-item>
            </el-form>
        </el-col>
        <el-col :span="18">
            <template>
                <el-table ref="multipleTable" :data="tableData" style="width: 100%">
                    <el-table-column label="日期">
                        <template slot-scope="scope">
                            <span>{{ scope.row.record_time|formatDate }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="person_name" label="${name}">
                    </el-table-column>
                    <el-table-column prop="device_name" label="${device}">
                    </el-table-column>
                    <el-table-column label="上班打卡时间">
                        <template slot-scope="scope">
                            <span>{{ scope.row.am_punch_time|formatDate }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="上班状态">
                        <template slot-scope="scope">
                            <el-tag
                                    v-if="scope.row.am_punch_status===0" :type="'info'"
                                    disable-transitions>正常</el-tag>
                            <el-tag
                                    v-if="scope.row.am_punch_status===1" :type="'warning'"
                                    disable-transitions>迟到</el-tag>
                            <el-tag
                                    v-if="scope.row.am_punch_status===2" :type="'warning'"
                                    disable-transitions>早退</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column label="下班打卡时间">
                        <template slot-scope="scope">
                            <span>{{ scope.row.pm_punch_time|formatDate }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="下班状态">
                        <template slot-scope="scope">
                            <el-tag
                                    v-if="scope.row.pm_punch_status===0" :type="'success'"
                                    disable-transitions>正常</el-tag>
                            <el-tag
                                    v-if="scope.row.pm_punch_status===1" :type="'warning'"
                                    disable-transitions>迟到</el-tag>
                            <el-tag
                                    v-if="scope.row.pm_punch_status===2" :type="'warning'"
                                    disable-transitions>早退</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="group_name" label="组名">
                    </el-table-column>
                </el-table>
            </template>

            <template>
                <div class="block" style="text-align: center">
                    <el-pagination ref="pagination"
                                   @size-change="handleChange"
                                   @current-change="handleChange"
                                   :current-page.sync="currentPage"
                                   :page-size.sync="pageSize"
                                   :page-sizes="pageSizes"
                                   prev-text="${previous_page_lang}"
                                   next-text="${next_page_lang}"
                                   layout="total, sizes, prev, pager, next, jumper"
                                   :total="total">
                    </el-pagination>
                </div>
            </template>
        </el-col>
    </div>
</div>


<script type="text/javascript">
    var vm = new Vue({
        el: "#attend_detail",
        data: function () {
            return {
                tableData: [],
                currentPage: 1,
                pageSizes: [5, 10, 20],
                pageSize: 10,
                total: '',
                model: {
                    date_range: ['2019-01-01','2019-12-31'],
                    am_attend_time:'09:00',
                    pm_attend_time:'18:00',
                    am_time_range: ['00:00', '11:59'],
                    pm_time_range: ['12:00', '23:59']
                },
                selectGroupModel: '',
                options: []
            }
        },
        methods: {
            handleChange(val) {
                this.queryAttend();
            },
            queryAttend() {
                var model = this.$refs.form.model;
                ajaxPost({
                    url: "${pageContext.request.contextPath}/attend/attend_list",
                    data: {
                        pageNum: this.currentPage,
                        pageSize: this.pageSize,
                        date_start: model.date_range[0],
                        date_end: model.date_range[1],
                        am_attend_time:model.am_attend_time,
                        pm_attend_time:model.pm_attend_time,
                        group_id: this.selectGroupModel,
                        am_time_start: model.am_time_range[0],
                        am_time_end: model.am_time_range[1],
                        pm_time_start: model.pm_time_range[0],
                        pm_time_end: model.pm_time_range[1]
                    },
                    success: function (result) {
                        vm.total = result.data.total;
                        vm.tableData = result.data.list;
                    }
                });
            },
            exportExcel(){
                var model = this.$refs.form.model;
                window.open("${pageContext.request.contextPath}/attend/export?"+parseParams({
                    date_start: model.date_range[0],
                    date_end: model.date_range[1],
                    am_attend_time:model.am_attend_time,
                    pm_attend_time:model.pm_attend_time,
                    group_id: this.selectGroupModel,
                    am_time_start: model.am_time_range[0],
                    am_time_end: model.am_time_range[1],
                    pm_time_start: model.pm_time_range[0],
                    pm_time_end: model.pm_time_range[1]
                }));
            }
        }
    });

    ajaxPost({
        url: "${pageContext.request.contextPath}/group/list",
        data: {},
        async: false,
        success: function (result) {
            var list = [];
            for (var i = 0; i < result.data.list.length; i++) {
                list[i] = {
                    label: result.data.list[i].group_name,
                    value: result.data.list[i].group_id
                }
            }
            vm.options = list;
        }
    });

</script>
