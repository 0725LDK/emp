<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>게시글 작성하기</h1>
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
		<table>
			<tr>
				<td>게시글 비밀번호</td>
				<td><input type="text" name="boardPw"></td>
			</tr>
			<tr>
				<td>게시글 제목</td>
				<td><input type="text" name="boardTitle"></td>
			</tr>
		
			<tr>
				<td>게시글 내용</td>
				<td><textarea cols="50" rows="5" name="boardContent"></textarea></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><input type="text" name="boardWriter"></td>
			</tr>
			<tr>
				<td>작성일</td>
				<td><input type="date" name="createDate"></td>
			</tr>
		
		</table>
	<button type="submit"> 작성완료 </button>
	
	</form>
</body>
</html>