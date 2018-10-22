<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>
</head>
<body>

<script type="text/javascript">
    ajaxDeviceList();

    function ajaxDeviceList() {
        var loading = layLoading1();
        ajaxGet({
            url: "${pageContext.request.contextPath}/device/list",
            data: {},
            success: function (data) {
                layer.close(loading);
                l(data);
                if (checkSession(data)) {
                }
            }
        });
    }

    function ajaxLogout() {
        var loading = layLoading1();
        ajaxPost({
            url: "${pageContext.request.contextPath}/user/logout",
            data: {},
            success: function (data) {
                layer.close(loading);
                l(data);
            }
        });
    }
</script>
</body>
</html>
