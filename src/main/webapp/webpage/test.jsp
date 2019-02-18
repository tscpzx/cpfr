<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
    <title>SpringMVC<spring:message code="internationalisation" /></title>
</head>
<body>


Language:
<a href="?lang=zh_CN"><spring:message code="language.cn" /></a>
&nbsp;&nbsp;&nbsp;
<a href="?lang=en_US"><spring:message code="language.en" /></a>
<h1>
    <!-- 将配置文件中的内容读取 -->
    <spring:message code="welcome" />
</h1>
当前语言: ${pageContext.response.locale }
</body>
</html>