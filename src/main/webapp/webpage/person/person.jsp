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

    #person {
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
<div id="person">
    <el-tree
            :data="items"
            :props="defaultProps"
            @node-click="onNodeClick"
            @node-expand="onHandleExpand"
            node-key="person_id"
            :default-expanded-keys="[-1]"
            ref="tree"></el-tree>
</div>
<div id="person_content" style=" float: left;
    width: calc(100% - 250px);
    height: 100%;
    overflow: auto;"></div>

<script type="text/javascript">
    ajaxPersonList();
    var vmList = new Vue({
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
                    $("#person_content").load("person/person_tbl?length=" + this.length);
                }
            }
        }
    });

    function ajaxPersonList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list",
            data: {},
            success: function (result) {
                vmList.items[0].children = result.data;
                vmList.length = result.data.length;

                $("#person_content").load("person/person_tbl?length=" + vmList.length);
            }
        });
    }
</script>
