<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/resource/inc/lang.jsp" %>
<el-dialog title="${modify_access}"
           :visible.sync="visible"
           @opened="opened"
           width="650px">

    <el-form label-width="25%" style="margin-top: 30px;width: 500px;" size="small" v-model="dialogModel">
        <el-form-item label="${pass_time}">
            <el-radio-group v-model="dialogModel.radio1" @change="onChangeRadio">
                <el-radio label="1">${specified_number}</el-radio>
                <el-radio label="2">${unlimited_number_time}</el-radio>
            </el-radio-group>
            <el-input v-model="dialogModel.pass_number" autocomplete="off" placeholder="${fill_number_passes}"
                      style="width: 100%;display: none;" class="input_pass_number"></el-input>
        </el-form-item>
        <el-form-item label="${passage_period}">
            <el-radio-group v-model="dialogModel.radio2" @change="onChangeRadio">
                <el-radio label="3">${specified_time}</el-radio>
                <el-radio label="4">${infinite_time}</el-radio>
            </el-radio-group>

            <el-date-picker
                    unlink-panels
                    class="date_picker_pass_number"
                    style="display: none;"
                    v-model="dialogModel.dateValue"
                    type="datetimerange"
                    range-separator="${to_lang}"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    start-placeholder="${start_date}"
                    end-placeholder="${end_date}">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="">
            <el-button @click="visible =false">${cancel_lang}</el-button>
            <el-button type="primary" @click="changePersonGrant">${save}</el-button>
        </el-form-item>
    </el-form>
</el-dialog>