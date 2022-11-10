<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	//String boardPw = request.getParameter("boardPw");
	/* if(boardPw == null || boardPw.equals(""))
	{
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	} */
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "SELECT board_no FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=boardNo%>" method="post">
		<table>
			<tr>
				<td>게시글 일련번호</td>
				<td><input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly"> </td>
			</tr>
			<tr>
				<td>게시글 비밀번호</td>
				<td><input type="text" name="boardPw" ></td>
			</tr>
		</table>
		<div>
			<%
				if(request.getParameter("msg")!= null)
			{
			%>
					<div><span style="color:red">경고! </span><%=request.getParameter("msg") %></div>
			<%		
			}
			%>
		</div>
	<button type="submit">삭제하기</button>
	</form>

</body>
</html>