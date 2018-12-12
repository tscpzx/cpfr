<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    #device_tree {
        width: 250px;
        height: 100%;
        background: #EBEFF2;
        overflow-y: auto;
        float: left;
    }

    #device_content{
        float: left;
        width: calc(100% - 250px);
        height: 100%;
        overflow: auto;
    }
</style>
<div id="device_tree"></div>
<div id="device_content"></div>

<script type="text/javascript">
    $("#device_tree").load("device/device_tree");
    $("#device_content").load("device/device_tbl");
</script>
