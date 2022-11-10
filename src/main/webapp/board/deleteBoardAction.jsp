<%@ page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	/* if(boardNo == null || boardNo.equals("") ||boardPw == null || boardPw.equals("") )
	{
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	} */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	String delSql = "DELETE FROM board WHERE board_no = ? AND board_pw = ?";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setInt(1, boardNo);
	delStmt.setString(2, boardPw);
	
	//디버깅
	int row = delStmt.executeUpdate();
	if(row == 1)
	{
		System.out.println("삭제성공");
	}
	else
	{
		String msg = URLEncoder.encode("잘못된 비밀번호", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		System.out.println("삭제실패");
		return;
		
	} 
	
	//출력
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