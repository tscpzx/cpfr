<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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

</style>
<div id="device">
    <el-tree :data="items"
             accordion="true"
             highlight-current="true"
             :props="defaultProps"
             @node-click="onNodeClick"
             @node-expand="onHandleExpand"
             node-key="device_id"
             :default-expanded-keys="[-2]"
             ref="tree">
      <span class="custom-tree-node" slot-scope="{ node, data }">
            <span v-if="data.online==1" class="circle"></span>
            <span>{{ data.device_name }}</span>
      </span>
    </el-tree>
</div>

<script type="text/javascript">
    var vmDeviceTree = new Vue({
        el: "#device",
        data: {
            items: [{
                device_id: -1,
                device_name: '${device_not_activated}',
                children: []
            }, {
                device_id: -2,
                device_name: '${activated_device}',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_name'
            }
        },
        methods: {
            onNodeClick(data) {
                if (data.device_id > 0) {
                    if (data.status === 0) {
                        $("#device_content").load("${pageContext.request.contextPath}/device/inact_detail?device_sn=" + data.device_name);
                    } else {
                        $("#device_content").load("${pageContext.request.contextPath}/device/detail?device_sn=" + data.device_sn);
                    }
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.device_id === -2) {
                    $("#device_content").load("${pageContext.request.contextPath}/page/device/device_tbl");
                } else if (data.device_id === -1) {
                    $("#device_content").load("${pageContext.request.contextPath}/page/device/device_inact_tbl");
                }
            }
        }
    });

    ajaxGet({
        url: "${pageContext.request.contextPath}/device/inact_list",
        data: {},
        success: function (result) {
            vmDeviceTree.items[0].children = result.data.list;
        }
    });

    ajaxGet({
        url: "${pageContext.request.contextPath}/device/list_by_group",
        data: {},
        success: function (result) {
            for (var i = 0; i < result.data.list.length; i++) {
                vmDeviceTree.items[1].children[i] = {
                    device_id: -1,
                    device_name: result.data.list[i].group_name,
                    children: result.data.list[i].device_list
                }
            }
        }
    });
</script>
