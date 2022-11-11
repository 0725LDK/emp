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
				vertical-align : middle;
			}
		.inner-div 
			{
			 	width : 300px;
			 	height : 30px;
			 	margin: auto;
			}
		.my-div 
			{
				justify-content : center;
				align-items : center;
			}
		input
			{
				width : 350px; 
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
		<h1>게시물 수정 하기</h1>
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
			<table class="table table-hover">
				<tr>
					<td class="table-warning my-div">게시글 번호</td>
					<td><input type="text" name="boardNo" value="<%=board.boardNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="table-warning my-div">게시글 제목</td>
					<td><input type="text" name="boardTitle" value="<%=board.boardTitle %>"></td>
				</tr>
			
				<tr>
					<td class="table-warning my-div">게시글 내용</td>
					<td><textarea cols="45" rows="5" name="boardContent"><%=board.boardContent %></textarea></td>
				</tr>
				<tr>
					<td class="table-warning my-div">작성자</td>
					<td><input type="text" name="boardWriter" value="<%=boardWriter%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="table-warning my-div">작성일</td>
					<td><input type="text" name="createdate" value="<%= createdate%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="table-warning my-div">비밀번호</td>
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
				
			<div style="float:right;">
				<button type="submit"> 수정완료 </button>
			</div>
		</form>
	</div>
</body>
</html>