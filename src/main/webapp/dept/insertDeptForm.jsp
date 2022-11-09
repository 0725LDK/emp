<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<style>

a 
	{
  		text-decoration: none;
	}
tr,td
	{
		text-align: center;
	}
table 
	{
    	width: 400px;
  	}
.box 
	{
  
 		width: 500px;
	}
</style>
</head>
<body>
	<br>
	<form class="container box" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
		<table class="table">
			<tr>
				<div style="float:center;">
					<td colspan="2" ><h1> 부서 추가 </h1></td>
				</div>
			</tr>
			
			<tr>
				<td>부서 번호</td>
				<td><input type="text" name="deptNo"></td>
			</tr>
			
			<tr>
				<td>부서 명</td>
				<td><input type="text" name="deptName"></td>
			</tr>
		
		</table>
	<div style="float:right;">
		<button type="submit">추가 하기</button>
	</div>
	</form>
</body>
</html>