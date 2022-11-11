<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		<h1>게시글 작성하기</h1>
		<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table  class="table table-hover">
				<tr >
					<td class="table-warning my-div">게시글 비밀번호</td>
					<td><input type="text" name="boardPw"></td>
				</tr >
				<tr>
					<td class="table-warning my-div">게시글 제목</td>
					<td><input type="text" name="boardTitle"></td>
				</tr>
			
				<tr>
					<td class="table-warning my-div">게시글 내용</td>
					<td><textarea cols="45" rows="5" name="boardContent"></textarea></td>
				</tr>
				<tr>
					<td class="table-warning my-div">작성자</td>
					<td><input type="text" name="boardWriter"></td>
				</tr>
				<tr>
					<td class="table-warning my-div">작성일</td>
					<td><input type="date" name="createDate"></td>
				</tr>
			
			</table>
		<div style="float:right;">
			<button type="submit"> 작성완료 </button>
		</div>
		</form>
	</div>
</body>
</html>