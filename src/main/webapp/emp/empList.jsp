<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//현재 페이지
	int currentPage = 1;
	int count = 0; //총 행 수 저장 변수
	int rowPerPage = 10; //페이지당 볼 행 수
	int lastPage = 0;//원하는 행 수로 전체 행을 나누었을때 생기는 페이지

	//페이지 값이 없으면 현재 페이지로
	if(request.getParameter("currentPage") != null)
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//검색어 받기
	String word = request.getParameter("word");
	
	//검색 후 총 행수 구하는 쿼리
	String wordCountSql = null;
	PreparedStatement wordCountStmt = null;
	//검색 후 페이지에 뜨는 행수 구하는 쿼리
	String wordListEmpSql = null;
	PreparedStatement wordListEmpStmt = null;

	//DB 접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//1) word가 null이거나 공백일때 마지막 페이지 구하기 위한 쿼리 & 페이지 리스트업 쿼리 작성 및 적용
	if(word==null || word.equals(""))
	{
		wordCountSql = "SELECT COUNT(*) FROM employees";//전체 행 수 구하기
		wordCountStmt = conn.prepareStatement(wordCountSql);
		ResultSet countRs = wordCountStmt.executeQuery();//select 쿼리 실행시 사용
			
		if(countRs.next())
		{
			count = countRs.getInt("COUNT(*)");//앞서 받아온 전체 행 수를 총 행 변수에 저장
		}
		
		lastPage = count/rowPerPage;
		if(count % rowPerPage != 0) // 원하는 행 수가 안될때 생기는 마지막 페이지
		{
			lastPage = lastPage + 1;
		}
		
		wordListEmpSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
		wordListEmpStmt = conn.prepareStatement(wordListEmpSql);
		wordListEmpStmt.setInt(1, rowPerPage*(currentPage-1));//첫번째 물음표 어느행부터 보여줄건지
		wordListEmpStmt.setInt(2, rowPerPage);//두번째 물음표 한페이지당 몇행 보여줄건지
		
	}
	else //word에 검색어가 있을때 마지막 페이지 구하기 위한 쿼리 & 페이지 리스트업 쿼리 작성 및 적용
	{
		wordCountSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";//전체 행 수 구하기
		wordCountStmt = conn.prepareStatement(wordCountSql);
		wordCountStmt.setString(1, "%"+word+"%");
		wordCountStmt.setString(2, "%"+word+"%");
		ResultSet countRs = wordCountStmt.executeQuery();//select 쿼리 실행시 사용
			
		if(countRs.next())
		{
			count = countRs.getInt("COUNT(*)");//앞서 받아온 전체 행 수를 총 행 변수에 저장
		}
		
		lastPage = count/rowPerPage;
		if(count % rowPerPage != 0) // 원하는 행 수가 안될때 생기는 마지막 페이지
		{
			lastPage = lastPage + 1;
		}
		
		wordListEmpSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		wordListEmpStmt = conn.prepareStatement(wordListEmpSql);
		wordListEmpStmt.setString(1, "%"+word+"%");
		wordListEmpStmt.setString(2, "%"+word+"%");
		wordListEmpStmt.setInt(3, rowPerPage*(currentPage-1));//세번째 물음표 어느행부터 보여줄건지
		wordListEmpStmt.setInt(4, rowPerPage);//네번째 물음표 한페이지당 몇행 보여줄건지
		
	}
	
	//검색으로 나온 결과 적용 & 저장
	ResultSet wordListEmpRs = wordListEmpStmt.executeQuery();
	ArrayList<Employee> empList = new ArrayList<Employee>();//Employee 클래스의 배열 생성
	while(wordListEmpRs.next())//행에 데이터가 있다면 
	{
		Employee e = new Employee(); //e 라는 Employee 클래스 생성
		e.empNo = wordListEmpRs.getInt("empNo"); //클래스안 필드에 저장
		e.firstName = wordListEmpRs.getString("firstName");
		e.lastName = wordListEmpRs.getString("lastName");
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
			<%
				if(word != null && currentPage>1)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
				else if(word != null && currentPage==1)
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%		
				}
				else if(word == null && currentPage>1)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음으로</a>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
				else if(word == null && currentPage==1)
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%		
				}
			%>
					<span> [ <%=currentPage %> ] </span>
			<%
				if(word != null && currentPage<lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막으로</a>
			<%
				}
				else if(word != null && currentPage==lastPage)
				{
			%>		
					<span>다음</span>	
					<span>마지막으로</span>	
			<%		
				}
				else if(word == null && currentPage<lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
			<%
				}
				else if(word == null && currentPage==lastPage)
				{
			%>		
					<span>다음</span>	
					<span>마지막으로</span>	
			<%		
				}
			%>
		</div>
		<span style="float:left;">
			<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="get">
				<label for="word">사원검색</label>
				
				<%
					if(word==null)
					{
				%>
						<input type="text" name="word" id="word" placeholder="검색어를 입력하세요." onfocus="this.placeholder=''" onblur="this.placeholder='검색어를 입력하세요.'">
				<%
					}
					else
					{
				%>
						<input type="text" name="word" id="word" value="<%=word%>">
				<%
					}
				%>
				<button type="submit">검색</button>
			</form>
		</span>
	</div>
</body>
</html>