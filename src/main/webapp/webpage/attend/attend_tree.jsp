<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
<div id="attend">
    <div class="tree-header-item" v-on:click="addSetting()">
        <i class="el-icon-circle-plus-outline"></i>
        <span>新建规则</span>
    </div>
</div>
<script type="text/javascript">
    var vmPersonTree = new Vue({

        el: "#person",
        data: {},
        methods: {
            addPerson() {
                $("#person_content").load("attend/attend_setting");
            }
        }
    });
</script>
