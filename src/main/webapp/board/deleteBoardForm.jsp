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
		<h1>게시물 삭제 하기</h1>
		<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=boardNo%>" method="post">
			<table class="table table-hover">
				<tr>
					<td class="table-warning my-div">게시글 일련번호</td>
					<td><input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly"> </td>
				</tr>
				<tr>
					<td class="table-warning my-div">게시글 비밀번호</td>
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
			<div style="float:right;">
				<button type="submit"> 삭제완료 </button>
			</div>
		</form>
	</div>
</body>
</html>