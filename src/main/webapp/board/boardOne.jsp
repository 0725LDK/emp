<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// 1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	// 3 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<style>

a 
	{
  		text-decoration: none;
	}
tr,td
	{
		text-align: center;
	}
.inner-div 
	{
	  width : 300px;
	  height : 30px;
	  margin: auto;
	}
</style>

</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<div class="container">
	<h1>게시글 상세보기</h1>
	<table  class="table table-hover">
		<tr class="table-warning">
			<td style="width: 25%">번호</td>
			<td><%=board.boardNo%></td>
		</tr>
		<tr>
			<td>제목</td>
			<td><%=board.boardTitle%></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><%=board.boardContent%></td>
		</tr>
		<tr>
			<td>글쓴이</td>
			<td><%=board.boardWriter%></td>
		</tr>
		<tr>
			<td>생성날짜</td>
			<td><%=board.createdate%></td>
		</tr>
	</table>
		<div style="float:right;">
			<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>&boardWriter=<%=board.boardWriter%>&createdate=<%=board.createdate%>">[ &#9997; 수정 ]&nbsp;</a><!-- 수정 이모지 -->
			<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">&nbsp;[ &#10060; 삭제 ]&nbsp;</a><!-- 삭제 이모지 -->
			<a href="<%=request.getContextPath()%>/board/boardList.jsp">&nbsp;[ &#128072; 돌아가기 ]&nbsp;</a><!-- 돌아가기 이모지 -->
		</div>
	</div>
</body>
</html>
