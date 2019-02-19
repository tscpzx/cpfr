<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
<div id="person">
    <div class="tree-header-item" v-on:click="addPerson()">
        <i class="el-icon-circle-plus-outline"></i>
        <span><spring:message code="add_people"/></span>
    </div>
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
<spring:message code="people_list" var="people_list_lang"/>
<script type="text/javascript">

    ajaxPersonList();
    var vmPersonTree = new Vue({

        el: "#person",
        data: {
            items: [{
                person_id: -1,
                person_name:  '${people_list_lang}',
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
            },
            addPerson(){
                $("#person_content").load("person/person_add");
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
