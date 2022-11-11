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
		.center
			{
				text-align : center;
			}
	</style>

</head>
<body>

	
	<!-- 메뉴 -->
	<div class="center">
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
	</div>
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
	<!-- msg 파라메타 값이 있으면 출력 -->
	<%
		if(request.getParameter("msg")!= null)
		{
	%>
			<div><span style="color:red">경고! </span><%=request.getParameter("msg") %></div>
	<%		
		}
	%>
	</form>
</body>
</html>