<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:message code="please_put_the_avatar_in_the_box" var="avatar_box_lang"/>
<el-dialog title="${avatar_box_lang}"
           :visible.sync="cropperVisible"
           @opened="open"
           @closed="closed"
           width="650px">
    <el-row>
        <el-col :span="16">
            <div class="cropper-container">
                <img>
            </div>
        </el-col>
        <el-col :span="8">
            <div class="cropper-preview"></div>
        </el-col>
    </el-row>

    <div slot="footer" class="dialog-footer">
        <el-button @click="visible = false"><spring:message code="cancel_lang"/></el-button>
        <el-button type="primary" @click="onClickCropper"><spring:message code="determine"/></el-button>
    </div>
</el-dialog>