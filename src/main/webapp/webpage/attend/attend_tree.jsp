<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .tree-item {
        height: 36px;
        line-height: 36px;
        padding-left: 6px;
        cursor: pointer;
    }

    .tree-item:hover {
        background-color: #F5F7FA;
    }

    .tree-item i, .tree-item span {
        color: #606266;
        font-size: 14px;
        margin-left: 18px;
    }

    .el-tree-node__content {
        height: 36px;
    }

    .el-tree {
        background: #EBEFF2;
    }
</style>
<div id="attend">
    <div class="tree-item" v-on:click="addSetting()">
        <span>设置规则</span>
    </div>
    <el-tree
            :data="items"
            highlight-current="true"
            :props="defaultProps"
            @node-click="onNodeClick"
            @node-expand="onHandleExpand"
            node-key="attend_id"
            :default-expanded-keys="[-1]"
            ref="tree"></el-tree>
</div>
<script type="text/javascript">
    ajaxAttendList();
    var attend_tree = new Vue({
        el: "#attend",
        data: {
            items: [{
                attend_id: -1,
                attend_name: '规则列表',
                children: []
            }],
            defaultProps: {
                children: 'children',
                label: 'attend_name'
            },
            length: ''
        },
        methods: {
            addSetting() {
                $("#attend_content").load("attend/attend_setting");
            },
            ruleList() {
                $("#attend_content").load("attend/attend_list");
            },
            onNodeClick(data) {
                if (data.attend_id !== -1) {
                    $("#attend_content").load("${pageContext.request.contextPath}/attend/rule_detail?attend_id=" + data.attend_id);
                }
            },
            onHandleExpand(data, node, tree) {
                if (data.person_id === -1) {
                    $("#attend_content").load("attend/attend_setting");
                }
            }
        }
    });


    function ajaxAttendList() {
        ajaxGet({
            url: "${pageContext.request.contextPath}/attend/rule_list",
            data: {},
            success: function (result) {
                attend_tree.items[0].children = result.data.list;
                attend_tree.length = result.data.total;
            }
        });
    }
</script>
