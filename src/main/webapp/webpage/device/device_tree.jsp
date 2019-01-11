<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
             :props="defaultProps"
             @node-click="onNodeClick"
             @node-expand="onHandleExpand"
             node-key="id"
             :default-expanded-keys="[-2]"
             ref="tree">
      <span class="custom-tree-node" slot-scope="{ node, data }">
            <span v-if="data.online==1" class="circle"></span>
            <span>{{ data.device_name }}</span>
      </span>
    </el-tree>
</div>

<script type="text/javascript">
    ajaxInActDeviceList();
    ajaxDeviceList();

    var vmDeviceTree = new Vue({
        el: "#device",
        data: {
            items: [{
                id: -1,
                device_name: '未激活设备',
                children: []
            }, {
                id: -2,
                device_name: '已激活设备',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_name'
            },
            device_length: '',
            inact_device_length: ''
        },
        methods: {
            onNodeClick(data) {
                if (data.id !== -1 && data.id !== -2) {
                    if (data.status === 0) {
                        $("#device_content").load("${pageContext.request.contextPath}/device/inact_detail?device_sn=" + data.device_name);
                    } else {
                        $("#device_content").load("${pageContext.request.contextPath}/device/detail?device_sn=" + data.device_sn);
                    }
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.id === -2) {
                    $("#device_content").load("device/device_tbl");
                } else if (data.id === -1) {
                    $("#device_content").load("device/device_inact_tbl");
                }
            }
        }
    });

    function ajaxInActDeviceList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact_list",
            data: {},
            success: function (result) {
                vmDeviceTree.items[0].children = result.data.list;
                vmDeviceTree.inact_device_length = result.data.list.length;
            }
        });
    }

    function ajaxDeviceList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (result) {
                vmDeviceTree.items[1].children = result.data.list;
                vmDeviceTree.device_length = result.data.list.length;
            }
        });
    }
</script>
