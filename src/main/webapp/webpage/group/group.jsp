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

    #group {
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
<div id="group">
    <el-tree :data="items" :props="defaultProps" @node-click="onNodeClick"></el-tree>
</div>
<div id="group_content" style="float: left"></div>

<script type="text/javascript">
    ajaxGroupList();

    var vmList = new Vue({
        el: "#group",
        data: {
            items: [{
                device_sn: '分组列表',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'device_sn'
            }
        },
        methods: {
            onNodeClick(data) {
                $("#group_content").load();
            }
        }
    });

    function ajaxGroupList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/inact/list",
            data: {},
            success: function (result) {
                vmList.items[0].children = result.data;
            }
        });
    }
</script>
