<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="vo.*" %>

<%

	
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	//안전장치 코드
	if(request.getParameter("deptNo") == null ||request.getParameter("deptNo") == "" || 
		request.getParameter("deptName") == null || request.getParameter("deptName") == "")
	{
		String msg = URLEncoder.encode("부서번호와 부서이름 입력 필요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	} 

	
	//요청분석
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//이미 존재하는 Key(deptNo)값 동일한 값이 입력되면 예외발생 ->방지 필요
	
	//2-1 dept_no 중복검사
	String sql2="SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?"; //입력하기전에 같은 dept_no가 존재하는지
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next())//결과물이 있으면 같은 deptNo가 존재
	{
		String msg = URLEncoder.encode("부서번호 또는 부서명 사용불가", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	//요청처리
	String sql = "INSERT INTO departments(dept_no, dept_name) VALUES(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
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