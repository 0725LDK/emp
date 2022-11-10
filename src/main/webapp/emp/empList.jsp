<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//현재 페이지
	int currentPage = 1;

	//페이지 값이 없으면 현재 페이지로
	if(request.getParameter("currentPage") != null)
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//DB 접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//마지막 페이지 구하기 위한 쿼리 작성 및 적용
	String countSql = "SELECT COUNT(*) FROM employees";//전체 행 수 구하기
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();//select 쿼리 실행시 사용
	
	int rowPerPage = 10; //페이지당 볼 행 수
	
	int count = 0; //총 행 수 저장 변수
	if(countRs.next())
	{
		count = countRs.getInt("COUNT(*)");//앞서 받아온 전체 행 수를 총 행 변수에 저장
	}
	
	int lastPage = count/rowPerPage;//원하는 행 수로 전체 행을 나누었을때 생기는 페이지
	
	if(count % rowPerPage != 0) // 원하는 행 수가 안될때 생기는 마지막 페이지
	{
		lastPage = lastPage + 1;
	}
	
	//사원 데이터 가져오기 위한 쿼리 작성 및 적용
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage*(currentPage-1));//첫번째 물음표 어느행부터 보여줄건지
	empStmt.setInt(2, rowPerPage);//두번째 물음표 한페이지당 몇행 보여줄건지
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();//Employee 클래스의 배열 생성
	while(empRs.next())//행에 데이터가 있다면 
	{
		Employee e = new Employee(); //e 라는 Employee 클래스 생성
		e.empNo = empRs.getInt("empNo"); //클래스안 필드에 저장
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e); // Employee 클래스의 배열에 저장
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
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
	</div>
	
	
	<div class="container">
	<h1>사원 목록</h1>
	<table class="table table table-hover">
		<tr class="table-warning">
			<td>사원 번호</td>
			<td>성</td>
			<td>이름</td>
		</tr>
		<%
			for(Employee e : empList)
			{
		%>
				<tr>
					<td><%=e.empNo %></td>
					<td><%=e.lastName %></td>
					<td><%=e.firstName %></td>
				</tr>
		<%		
				
			}
		%>
	</table>
	
		<div class="inner-div">
			<!-- 페이지 넘기는 목록 출력 -->
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음으로</a>
			<%
				if(currentPage>1)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1 %>">이전</a>
			<%
				}
				else if(currentPage==1)
				{
			%>	
					<span>이전</span>
			<%		
				}
			%>
					<span> [ <%=currentPage %> ] </span>
			<%
				if(currentPage<lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
			<%
				}
				else if(currentPage==lastPage)
				{
			%>		
					<span>다음</span>	
			<%		
				}
			%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage %>">마지막으로</a>
			
		</div>
		
	</div>
</body>
</html>