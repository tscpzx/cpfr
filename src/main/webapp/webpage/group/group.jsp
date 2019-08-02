<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    #group_tree {
        width: 250px;
        height: 95%;
        background: #fff;
        overflow-y: auto;
        float: left;
        border-right: solid 1px #e6e6e6;
    }

    #group_content{
        float: left;
        width: calc(100% - 251px);
        height: 95%;
        overflow: auto;
    }
</style>
<div id="group_tree" class="scrollbar"></div>
<div id="group_content" class="scrollbar"></div>

<script type="text/javascript">
    $("#group_tree").load("${pageContext.request.contextPath}/page/group/group_tree");
    $("#group_content").load("${pageContext.request.contextPath}/page/group/group_tbl");
</script>
