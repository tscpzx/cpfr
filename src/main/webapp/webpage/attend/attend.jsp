<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<style type="text/css">
    #attend_tree {
        width: 250px;
        height: 95%;
        background: #fff;
        overflow-y: auto;
        float: left;
    }
    #attend_content{
        float: left;
        width: calc(100% - 250px);
        height: 95%;
        overflow: auto;
    }
</style>
<div id="attend_tree" class="scrollbar"></div>
<div id="attend_content" class="scrollbar"></div>

<script type="text/javascript">
    $("#attend_tree").load("${pageContext.request.contextPath}/page/attend/attend_tree");
    $("#attend_content").load("${pageContext.request.contextPath}/page/attend/attend_setting");
</script>