<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div id="dialog_person_list">
    <el-dialog title="添加人员" :visible.sync="visible" width="500px">
        <el-tree
                style="background-color: white;max-height: 300px;overflow: auto;"
                :data="items"
                :props="defaultProps"
                node-key="person_id"
                show-checkbox
                :default-expanded-keys="[-1]"
                ref="tree"></el-tree>
        <div slot="footer" class="dialog-footer">
            <el-button @click="visible = false">取 消</el-button>
            <el-button type="primary" @click="onClickGroupAddPerson">确 定</el-button>
        </div>
    </el-dialog>
</div>