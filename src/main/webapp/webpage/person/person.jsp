<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<style type="text/css">
    #person_tree {
        width: 250px;
        height: 100%;
        background: #EBEFF2;
        overflow-y: auto;
        float: left;
    }
    #person_content{
        float: left;
        width: calc(100% - 250px);
        height: 100%;
        overflow: auto;
    }
</style>
<div id="person_tree"></div>
<div id="person_content"></div>

<script type="text/javascript">
    $("#person_tree").load("person/person_tree");
    $("#person_content").load("person/person_tbl");
</script>
