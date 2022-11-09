<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
a 
	{
  		text-decoration: none;
	}
a:hover 
	{
  		color: #47C83E;
	}
</style>
</head>
<body>
	<br>
	<div class="container">
	<h1 class="text-center">관리자 메뉴</h1>
	<div class="text-center">
		<div style = "padding: 5px 0px 0px 0px;"><a href="<%=request.getContextPath()%>/dept/deptList.jsp">1. 부서관리</a><br></div>
		<div style = "padding: 5px 0px 0px 0px;"><a href="<%=request.getContextPath()%>/dept/deptList.jsp">2. 사원관리</a><br></div>
		<div style = "padding: 5px 0px 0px 0px;"><a href="<%=request.getContextPath()%>/dept/deptList.jsp">3. 상품관리</a><br></div>
		<div style = "padding: 5px 0px 0px 0px;"><a href="<%=request.getContextPath()%>/dept/deptList.jsp">4. 고객관리</a><br></div>
	</div>
	</div>
</body>
</html>