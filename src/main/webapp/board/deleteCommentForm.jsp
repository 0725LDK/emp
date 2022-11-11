<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>


<%
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));

	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");

	//게시글 번호와 댓글 번호 가져오기
	String sql = "SELECT board_no boardNo, comment_no commentNo FROM comment WHERE board_no = ? AND comment_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, commentNo);
	ResultSet rs = stmt.executeQuery();
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
		<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?boardNo=<%=boardNo %>&commentNo=<%=commentNo %>" method="post">
			<h1>댓글 삭제</h1>
			<table class="table">
				<tr class="table-warning my-div">
					<td>게시물 번호</td>
					<td>댓글 번호</td>
					<td>비밀번호 확인</td>
				</tr>
				<tr>
					<td><%=boardNo%></td>
					<td><%=commentNo%></td>
					<td><input type="text" name="commentPw" ></td>
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
				<button type="submit">삭제하기</button>
			</div>
		</form>
	</div>
</body>
</html>