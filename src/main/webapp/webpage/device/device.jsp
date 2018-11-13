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

    #device {
        width: 250px;
        height: 100%;
        background: #EBEFF2;
        overflow-y: auto;
        float: left;
    }

    .el-tree {
        background: #EBEFF2;
    }
</style>
<div id="device">
    <el-tree :data="items" :props="defaultProps" @node-click="onNodeClick" @node-expand="onHandleExpand" node-key="id" :default-expanded-keys="[1]" ref="tree">
      <span class="custom-tree-node" slot-scope="{ node, data }">
            <span v-if="data.online==1" class="circle"></span>
            <span>{{ data.device_sn }}</span>
      </span>
    </el-tree>
</div>
<div id="device_content" style="float: left; width: calc(100% - 250px);"></div>

<script type="text/javascript">
    ajaxInActDeviceList();
    ajaxDeviceList();

    var vmList = new Vue({
        el: "#device",
        data: {
            items: [{
                id: 2,
                device_sn: '未激活设备',
                children: []
            }, {
                id: 1,
                device_sn: '已激活设备',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_sn'
            }
        },
        methods: {
            onNodeClick(data) {
                if (data.device_sn !== "未激活设备" && data.device_sn !== "已激活设备") {
                    $("#device_content").load("${pageContext.request.contextPath}/device/inact/detail?device_sn=" + data.device_sn);
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.device_sn === "已激活设备") {
                    $("#device_content").load("device/device_tbl");
                } else if (data.device_sn === "未激活设备") {
                    $("#device_content").load("device/device_inact_tbl");
                }
            }
        }
    });

    $("#device_content").load("device/device_tbl");

    function ajaxInActDeviceList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact/list",
            data: {},
            success: function (result) {
                vmList.items[0].children = result.data;
            }
        });
    }

    function ajaxDeviceList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (result) {
                vmList.items[1].children = result.data;
            }
        });
    }
</script>
