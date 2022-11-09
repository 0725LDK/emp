<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%

	//안전장치 코드
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null)
	{
		response.sendRedirect(request.getContextPath()+"/insertDeptForm.jsp");
		return;
	} 
	//요청분석
	String dept_no = request.getParameter("deptNo");
	String dept_name = request.getParameter("deptName");
	
	//요청처리
	request.setCharacterEncoding("utf-8");
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "UPDATE departments set dept_name= ? WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, dept_name);
	stmt.setString(2, dept_no);
	stmt.executeUpdate();

	//출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>