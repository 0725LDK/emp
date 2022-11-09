<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="vo.*"%>

<%
 	String deptNo = request.getParameter("deptNo");
 	//String deptName = request.getParameter("deptName");
	if(deptNo==null)
	{
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql =  "SELECT dept_name deptName FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	 stmt.setString(1, deptNo);
	 ResultSet rs = stmt.executeQuery(); 

	 Department dept = null;   
	   if (rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
	      dept = new Department();
	      dept.deptNo = deptNo;
	      dept.deptName = rs.getString("deptName");
	   }

%>
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

	<%
		if(request.getParameter("msg")!= null)
		{
	%>
		
			<div><%=request.getParameter("msg") %></div>
	<%		
		}
	%>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
	</div>
	<form  class="container box" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
		
		<table class="table">
			<tr>
				<div style="float:center;">
					<td colspan="2" ><h1> 부서 정보 수정 </h1></td>
				</div>
			</tr>
			
			<tr>
				<td>부서 번호</td>
				<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
			</tr>
			
			<tr>
				<td>부서 명</td>
				<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
			</tr>
		
		</table>
	<div style="float:right;">
	<!-- msg 파라메타 값이 있으면 출력 -->
	
		<button type="submit">수정 완료</button>
	</div>
	
	</form>
</body>
</html>