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
<div id="group">
    <el-tree :data="items" :props="defaultProps" @node-click="onNodeClick" @node-expand="onHandleExpand" node-key="group_id" :default-expanded-keys="[-1]" ref="tree"></el-tree>
</div>

<script type="text/javascript">
    ajaxGroupList();
    var vmList = new Vue({
        el: "#group",
        data: {
            items: [{
                group_id: -1,
                group_name: '分组列表',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'group_name'
            },
            length: ''
        },
        methods: {
            onNodeClick(data) {
                if (data.group_id !== -1) {
                    $("#group_content").load("${pageContext.request.contextPath}/group/detail?group_id=" + data.group_id);
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.group_id === -1) {
                    $("#group_content").load("group/group_tbl");
                }
            }
        }
    });

    function ajaxGroupList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/group/list",
            data: {},
            success: function (result) {
                vmList.items[0].children = result.data.list;
                vmList.length = result.data.total;
            }
        });
    }
</script>