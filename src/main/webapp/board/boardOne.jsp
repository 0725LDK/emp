<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	// 2-1 게시글
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
	
	//댓글 페이징
	//2-2 댓글 목록
	String commentSql = "SELECT comment_no commentNO, board_no boardNo, comment_content commentContent FROM comment WHERE board_no =? ORDER BY comment_no DESC" ;
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	ResultSet commentRs = commentStmt.executeQuery();
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next())
	{
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
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
		.center
			{
				text-align : center;
			}
	</style>

</head>
<body>
	
	<!-- 메뉴 -->
	<div class="center">
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
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
	<br><br>
	
	<div class="container">
		<!-- 댓글 입력 폼 -->
		<h2>댓글입력</h2>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method ="post">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>"><!-- 값은 넘기지만 보여주진 않겠다 -->
			<table  class="table">
				<tr>
					<td class="table-warning">내용</td>
					<td><textarea rows="3" cols="80" name="commentContent"></textarea></td>
					
				</tr>
				<tr>
					<td class="table-warning">비밀번호</td>
					<td><input type="password" name="commentPw"></td>
					
				</tr>
			</table>
			
			<div style="float:right;">
				<button type="submit">댓글달기</button>
			</div>
		</form>
	</div>
	<br><br>
	
	<div class="container">
		<!-- 댓글 목록 -->
		<h2>댓글목록</h2>
		<table  class="table table-hover">
			<tr class="table-warning">
				<td>댓글번호</td>
				<td>댓글내용</td>
			</tr>
			
				<%
					for(Comment c : commentList)
					{
				%>
						<tr>
							<td><%=c.commentNo %></td>
							<td><%=c.commentContent %></td>
						</tr>
				<%
					}
				
				%>
		</table>
	
	</div>
</body>
</html>
