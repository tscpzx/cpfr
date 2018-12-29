<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>

</head>
<body>
<div id="app">

    <el-radio v-model="radio" label="1">备选项</el-radio>
    <el-radio v-model="radio" label="2">备选项</el-radio>

</div>

<script type="text/javascript">
    var Main = {
        data() {
            return {
                radio: '2'
            };
        }
    }
    var Ctor = Vue.extend(Main)
    new Ctor().$mount('#app')
</script>

</body>
</html>
