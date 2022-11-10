<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="vo.*"%>

<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createdate = request.getParameter("createdate");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = "SELECT board_no boardNo, board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate from board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	
	Board board = null;
	if(rs.next())
	{
		board = new Board();
		board.boardNo = boardNo;
		board.boardPw = rs.getString("boardPw");
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
		<table>
			
			<tr>
				<td>게시글 번호</td>
				<td><input type="text" name="boardNo" value="<%=board.boardNo%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>게시글 제목</td>
				<td><input type="text" name="boardTitle" value="<%=board.boardTitle %>"></td>
			</tr>
		
			<tr>
				<td>게시글 내용</td>
				<td><textarea cols="50" rows="5" name="boardContent"><%=board.boardContent %></textarea></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><input type="text" name="boardWriter" value="<%=boardWriter%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>작성일</td>
				<td><input type="text" name="createdate" value="<%= createdate%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="text" name="boardPw"></td>
			</tr>
		</table>
			<%
				if(request.getParameter("msg")!= null)
			{
			%>
					<div><span style="color:red">경고! </span><%=request.getParameter("msg") %></div>
			<%		
			}
			%>
	<button type="submit">수정</button>
	</form>

</body>
</html>