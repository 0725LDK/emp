<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	String createdate = request.getParameter("createdate");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//제목 중복체크 쿼리
	String chkSql = "SELECT * FROM board WHERE board_title =?";
	PreparedStatement chkStmt = conn.prepareStatement(chkSql);
	chkStmt.setString(1, boardTitle);
	ResultSet chkRs = chkStmt.executeQuery();
	
	if(chkRs.next())
	{
		String msg = URLEncoder.encode("중복된 제목", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo+"&boardWriter="+boardWriter+"&createdate="+createdate);
		return;
	}
	
	//업데이트 쿼리
	String upSql = "UPDATE board SET board_title = ?, board_content = ? WHERE board_no = ? AND board_pw = ?";
	PreparedStatement upStmt = conn.prepareStatement(upSql);
	upStmt.setString(1, boardTitle);
	upStmt.setString(2, boardContent);
	upStmt.setInt(3, boardNo);
	upStmt.setString(4, boardPw);
	
	int a = upStmt.executeUpdate(); //upStmt.executeUpdate() 은 0(싶래)아님 1(성공)로 반환
	if(a == 0)
	{
		String msg = URLEncoder.encode("잘못된 비밀번호", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo+"&boardWriter="+boardWriter+"&createdate="+createdate);
		return;
	}
	
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