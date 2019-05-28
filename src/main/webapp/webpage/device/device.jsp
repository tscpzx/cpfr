<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    #device_tree {
        width: 250px;
        height: 95%;
        background: #EBEFF2;
        overflow-y: auto;
        float: left;
    }

    #device_content {
        float: left;
        width: calc(100% - 250px);
        height: 95%;
        overflow: auto;
    }
</style>
<div id="device_tree" class="scrollbar"></div>
<div id="device_content" class="scrollbar"></div>

<script type="text/javascript">
    $("#device_tree").load("${pageContext.request.contextPath}/page/device/device_tree");
    $("#device_content").load("${pageContext.request.contextPath}/page/device/device_tbl");
</script>
