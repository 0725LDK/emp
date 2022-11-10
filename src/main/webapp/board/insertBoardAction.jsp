<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	request.setCharacterEncoding("utf-8");
	//요청처리 넘어오는 데이터
	request.setCharacterEncoding("utf-8");
	int boardPw = Integer.parseInt(request.getParameter("boardPw"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createDate = request.getParameter("createDate");
	
	//요청분석
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = "INSERT INTO board(board_pw, board_title, board_content, board_writer, createdate) VALUES(?, ?, ?, ?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardPw);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardWriter);
	stmt.setString(5, createDate);
	stmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
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