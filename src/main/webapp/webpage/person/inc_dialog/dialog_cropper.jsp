<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<el-dialog title="请将头像位于框中"
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
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" @click="onClickCropper">确 定</el-button>
    </div>
</el-dialog>