<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- partial jsp 페이지 사용코드 -->

	<div>
		<a href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp">게시글관리</a>
	</div>
