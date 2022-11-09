<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="vo.*" %>

<%
	//요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	//안전장치 코드
	if(request.getParameter("deptNo")==deptNo && request.getParameter("deptName") == "" || 
			request.getParameter("deptNo")==deptNo && request.getParameter("deptName") == null)
	{	
		String msg = URLEncoder.encode("부서번호와 부서이름 입력 필요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
		return;
	} 
	
	
	//요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql2 = "SELECT * FROM departments WHERE dept_name = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptName);
	ResultSet rs = stmt2.executeQuery();
	
	if(rs.next())
	{
		String msg = URLEncoder.encode("중복된 부서명", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
		return;
	}
	
	String sql = "UPDATE departments set dept_name= ? WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
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