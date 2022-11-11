<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>


<%
	//요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	//댓글생성 쿼리
	String commentSql = "INSERT INTO comment(board_no, comment_pw, comment_content, createdate) VALUES(?, ?, ?, CURDATE())";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setString(2, commentPw);
	commentStmt.setString(3, commentContent);
	
	//쿼리 업데이트
	commentStmt.executeQuery();
	
	//출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&commentContent="+commentContent);
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