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
<div id="person">
    <el-tree
            :data="items"
            highlight-current="true"
            :props="defaultProps"
            @node-click="onNodeClick"
            @node-expand="onHandleExpand"
            node-key="person_id"
            :default-expanded-keys="[-1]"
            ref="tree"></el-tree>
</div>

<script type="text/javascript">
    ajaxPersonList();
    var vmPersonTree = new Vue({
        el: "#person",
        data: {
            items: [{
                person_id: -1,
                person_name: '人员列表',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'person_name'
            },
            length: ''
        },
        methods: {
            onNodeClick(data) {
                if (data.person_id !== -1) {
                    $("#person_content").load("${pageContext.request.contextPath}/person/detail?person_id=" + data.person_id);
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.person_id === -1) {
                    $("#person_content").load("person/person_tbl");
                }
            }
        }
    });

    function ajaxPersonList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list",
            data: {},
            success: function (result) {
                vmPersonTree.items[0].children = result.data.list;
                vmPersonTree.length = result.data.total;
            }
        });
    }
</script>
