<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<template>
    <el-transfer
            filterable :filter-method="filterMethod1"
            filter-placeholder="${enter_person_keyword}"
            v-model="value1" :data="person_list" :props="props1"
            :titles="['${optional_staff}', '${authorized_personnel}']"
           >
    </el-transfer>
    <el-transfer
            filterable :filter-method="filterMethod2"
            filter-placeholder="${enter_device_keyword}"
            v-model="value2" :data="device_list" :props="props2"
            :titles="['${authorize_device}', '${optional_device}']"
        >
    </el-transfer>

    <el-form label-width="150px" style="margin-top: 30px;width: 600px;" size="small">
        <el-form-item label="${pass_time}">
            <el-radio-group v-model="radio1" @change="onChangeRadio">
                <el-radio label="1">${specified_number}</el-radio>
                <el-radio label="2">${unlimited_number_time}</el-radio>
            </el-radio-group>
            <el-input v-model="pass_number" autocomplete="off" placeholder="${fill_number_passes}"
                      style="width: 100%;display: none;" class="input_pass_number"></el-input>
        </el-form-item>
        <el-form-item label="${passage_period}">
            <el-radio-group v-model="radio2" @change="onChangeRadio">
                <el-radio label="3">${specified_time}</el-radio>
                <el-radio label="4">${infinite_time}</el-radio>
            </el-radio-group>

            <el-date-picker
                    unlink-panels
                    class="date_picker_pass_number"
                    style="display: none;"
                    v-model="dateValue"
                    type="datetimerange"
                    range-separator="${to_lang}"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    start-placeholder="${start_date}"
                    end-placeholder="${end_date}">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="">
            <el-button type="primary" @click="grantPass()">${author_access}</el-button>
            <el-button type="danger" @click="banPass()">${no_entry}</el-button>
        </el-form-item>
    </el-form>

</template>