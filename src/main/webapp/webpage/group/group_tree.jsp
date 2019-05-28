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
<div id="group">
    <div class="tree-header-item" v-on:click="addGroup()">
        <i class="el-icon-circle-plus-outline"></i>
        <span>${add_group}</span>
    </div>
    <el-tree :data="items"
             :props="defaultProps"
             @node-click="onNodeClick"
             @node-expand="onHandleExpand"
             node-key="group_id"
             :default-expanded-keys="[-1]"
             highlight-current="true"
             ref="tree"></el-tree>
</div>

<script type="text/javascript">
    ajaxGroupList();
    var vmGroupTree = new Vue({
        el: "#group",
        data: {
            items: [{
                group_id: -1,
                group_name: '${group_list}',
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
                    $("#group_content").load("${pageContext.request.contextPath}/page/group/group_tbl");
                }
            },
            addGroup() {
                this.$prompt('${enter_group}', '${add}', {
                    confirmButtonText: '${determine}',
                    cancelButtonText: '${cancel_lang}'
                }).then(({value}) => {
                    if (value.trim()) {
                        ajaxAddGroup(value.trim());
                    }
                }).catch(() => {
                });
            }
        }
    });

    function ajaxGroupList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/group/list",
            data: {},
            success: function (result) {
                vmGroupTree.items[0].children = result.data.list;
                vmGroupTree.length = result.data.total;
            }
        });
    }

    function ajaxAddGroup(groupName) {
        ajaxPost({
            url: "${pageContext.request.contextPath}/group/add",
            data: {
                group_name: groupName
            },
            success: function (result) {
                $("#content-container").load("${pageContext.request.contextPath}/page/group/group");
            }
        });
    }
</script>
