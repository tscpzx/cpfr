<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div id="dialog_device_list">
    <el-dialog title="添加设备" :visible.sync="visible">
        <el-tree
                style="background-color: white"
                :data="items"
                :props="defaultProps"
                node-key="device_id"
                show-checkbox
                :default-expanded-keys="[-1]"
                ref="tree"></el-tree>
        <div slot="footer" class="dialog-footer">
            <el-button @click="visible = false">取 消</el-button>
            <el-button type="primary" @click="onClickGroupAddDevice">确 定</el-button>
        </div>
    </el-dialog>
</div>