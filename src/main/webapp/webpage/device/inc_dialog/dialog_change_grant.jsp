<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-dialog title="修改通行权限"
           :visible.sync="visible"
           @opened="opened"
           width="650px">

    <el-form label-width="150px" style="margin-top: 30px;width: 500px;" size="small" v-model="dialogModel">
        <el-form-item label="通行次数">
            <el-radio-group v-model="dialogModel.radio1" @change="onChangeRadio">
                <el-radio label="1">指定次数</el-radio>
                <el-radio label="2">无限次数</el-radio>
            </el-radio-group>
            <el-input v-model="dialogModel.pass_number" autocomplete="off" placeholder="请输入次数" style="width: 100%;display: none;" class="input_pass_number"></el-input>
        </el-form-item>
        <el-form-item label="通行时间">
            <el-radio-group v-model="dialogModel.radio2" @change="onChangeRadio">
                <el-radio label="3">指定时间</el-radio>
                <el-radio label="4">无限时间</el-radio>
            </el-radio-group>

            <el-date-picker
                    class="date_picker_pass_number"
                    style="display: none;"
                    v-model="dialogModel.dateValue"
                    type="datetimerange"
                    range-separator="至"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="">
            <el-button @click="visible =false">取消</el-button>
            <el-button type="primary" @click="changePersonGrant">保存</el-button>
        </el-form-item>
    </el-form>
</el-dialog>