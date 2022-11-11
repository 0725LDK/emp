<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>

<%
	//요청
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	//삭제쿼리
	String delSql = "DELETE FROM comment WHERE board_no = ? AND comment_no = ? AND comment_pw = ?";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setInt(1, boardNo);
	delStmt.setInt(2, commentNo);
	delStmt.setString(3, commentPw);
	
	//쿼리 실행 및 디버깅
	int row = delStmt.executeUpdate();
	if(row==1)
	{
		System.out.println("삭제성공");
	}
	else //실패하면 form페이지로 넘김
	{
		String msg =URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
		System.out.println("삭제실패");
		return;
	}
	
	//성공시 one 페이지로 넘김
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
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