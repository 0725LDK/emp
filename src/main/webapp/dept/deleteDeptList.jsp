<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	//요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	//System.out.println(deptNo+"<===deptNo");//디버깅
	
	//요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "DELETE FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	
	 //디버깅
	int row = stmt.executeUpdate();
	if(row == 1)
	{
		System.out.println("삭제성공");
	}
	else
	{
		System.out.println("삭제실패");
	} 

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