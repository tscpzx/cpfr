<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .el-tree-node__content {
        height: 36px;
    }

    .custom-tree-node {
        flex: 1;
        display: flex;
        align-items: center;
        font-size: 14px;
    }

    .el-tree {
        background: #EBEFF2;
    }

    .tree-header-item {
        height: 36px;
        line-height: 36px;
        padding-left: 6px;
        cursor: pointer;
    }

    .tree-header-item:hover {
        background-color: #F5F7FA;
    }

    .tree-header-item i, .tree-header-item span {
        color: #606266;
        font-size: 14px;
    }
</style>
<div id="device">
    <el-tree
            :data="items"
            highlight-current="true"
            :props="defaultProps"
            @node-click="onNodeClick"
            @node-expand="onHandleExpand"
            node-key="device_id"
            :default-expanded-keys="[-1]"
            ref="tree"></el-tree>
</div>
<script type="text/javascript">

    var vmAcDeviceTree = new Vue({

        el: "#device",
        data: {
            items: [{
                device_id: -1,
                device_name: '设备列表',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_name'
            },
        },
        methods: {
            onNodeClick(data) {
                if (data.device_id !== -1) {
                    $("#record_content").load("${pageContext.request.contextPath}/page/record/record_tbl?device_id=" + data.device_id);
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.device_id === -1) {
                    $("#record_content").load("${pageContext.request.contextPath}/page/record/record_tbl?device_id=''");
                }
            }
        }
    });

    ajaxGet({
        url: "${pageContext.request.contextPath}/device/list",
        data: {},
        success: function (result) {
            vmAcDeviceTree.items[0].children = result.data.list;
        }
    });
</script>
