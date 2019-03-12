<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp"%>
<div id="dialog_device_list">
    <el-dialog title="${add_device}" :visible.sync="visible" width="500px">
        <el-tree
                style="background-color: white;max-height: 300px;overflow: auto;"
                :data="items"
                :props="defaultProps"
                node-key="device_id"
                show-checkbox
                :default-expanded-keys="[-1]"
                ref="tree"></el-tree>
        <div slot="footer" class="dialog-footer">
            <el-button @click="visible = false">${cancel_lang}</el-button>
            <el-button type="primary" @click="onClickGroupAddDevice">${determine}</el-button>
        </div>
    </el-dialog>
</div>