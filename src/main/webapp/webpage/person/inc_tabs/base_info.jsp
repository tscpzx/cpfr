<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-form label-width="150px"  :model="personModel"  ref="perBaseInfoForm" >
    <el-form-item label="人员ID:">
        <span>{{data.person_id}}</span>
    </el-form-item>
    <el-form-item label="注册时间:">
        <span>{{data.add_time|formatDate}}</span>
    </el-form-item>
    <el-form-item label="姓名:">
        <el-input v-bind:value="data.person_name"  v-model="personModel.person_name" type="text" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="工号:">
        <el-input :value="data.emp_number"  v-model="personModel.emp_number" type="text" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="底库图片:">
        <img class="image" :src="'data:image/jpeg;base64,'+data.base_image">
    </el-form-item>
    <el-form-item label="">
        <el-button type="primary" size="small" @click="updatePerson('perBaseInfoForm')">保存</el-button>
        <el-button type="danger" size="small" @click="dialogVisible = true">删除</el-button>
    </el-form-item>
</el-form>
<el-dialog title="提示" :visible.sync="dialogVisible" width="30%">
    <span>确定删除该员工吗？</span>
    <span slot="footer" class="dialog-footer">
    <el-button size="small"  @click="dialogVisible = false">取 消</el-button>
    <el-button size="small" type="primary" @click="deletePerson()">确 定</el-button>
  </span>
</el-dialog>
