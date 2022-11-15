<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %><!-- salary 설정 방법 -->

<%
	//요구사항 분석
	//1.페이징
	int currentPage = 1; //넘어오지않으면 1페이지
	if(request.getParameter("currentPage") != null)//넘어오는 페이지가 있을때
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = null;
	word = request.getParameter("word");
	
	int cnt = 0;
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int lastPage = 0;
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement stmt = null;
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	//SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName from salaries s INNER JOIN employees e ON s.emp_no = e.emp_no LIMIT ?, ?

	if(word == null || word.equals(""))
	{
		//word가 null일때 총 행수 구하기
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no";
		cntStmt = conn.prepareStatement(cntSql);
		ResultSet cntRs = cntStmt.executeQuery();
		
		if(cntRs.next())
		{
			cnt = cntRs.getInt("COUNT(*)");
		}
		
		//마지막 페이지
		lastPage = cnt/rowPerPage;
		System.out.println(cnt +"cnt");
		System.out.println(rowPerPage +"rowperpage");
		System.out.println(lastPage +"lastpage");
		if(cnt % rowPerPage != 0)
		{
			lastPage = lastPage + 1;
		}
		
		String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName from salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	}
	else
	{
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name like ? or e.last_name like ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1,"%"+word+"%");
		cntStmt.setString(2,"%"+word+"%");
		ResultSet cntRs = cntStmt.executeQuery();
		
		if(cntRs.next())
		{
			cnt = cntRs.getInt("COUNT(*)");
		}
		
		//마지막 페이지
		lastPage = cnt/rowPerPage;
		System.out.println(cnt +"cnt");
		System.out.println(rowPerPage +"rowperpage");
		System.out.println(lastPage +"lastpage");
		if(cnt % rowPerPage != 0)
		{
			lastPage = lastPage + 1;
		}
		
		String sql = "SELECT s.emp_no empNo, e.first_name firstName, e.last_name lastName, s.salary salary, s.from_date fromDate, s.to_date toDate FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name like ? or e.last_name like ? ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+word+"%");
		stmt.setString(2,"%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
	}
	
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next())
	{
		Salary s = new Salary();
		s.emp = new Employee();
		
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
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
		<h1>사원연봉정보</h1>
		<table class="table table table-hover">
			<tr class="table-warning">
				<td>사원번호</td>
				<td>연봉</td>
				<td>시작일</td>
				<td>종료일</td>
				<td>사원이름</td>
				
			</tr>
			<%
				for(Salary s : salaryList)
				{
			%>
					<tr>
						<td><%=s.emp.empNo %></td>
						<td><%=s.salary %></td>
						<td><%=s.fromDate %></td>
						<td><%=s.toDate %></td>
						<td><%=s.emp.firstName %>&nbsp;<%=s.emp.lastName %></td>
					</tr>
			<%
				}
			%>
		</table>
		<div class="inner-div">
			<%
				if(word != null && currentPage > 1)
				{
			%>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%	
				}
				else if(word == null && currentPage > 1)
				{
			%>		
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=1">처음으로</a>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%	
				}
				else if ( word != null && currentPage == 1 || word == null && currentPage == 1)
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%
				}
			%>
			<span>[ <%=currentPage%> ]</span>
			
			<%
				if(word != null && currentPage < lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막으로</a>
			<%
				}
				else if(word == null && currentPage < lastPage)
				{
			%>		
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<a href="<%=request.getContextPath()%>/salaries/salariesList1.jsp?currentPage=<%=lastPage%>">마지막으로</a>
			<%		
				}
				else if(word != null && currentPage == lastPage || word == null && currentPage == lastPage)
				{
			%>
					<span>다음</span>
					<span>마지막으로</span>	
			<%		
				}
			%>
			
			
		</div>
		<span style="float:left;">
			<form action="<%=request.getContextPath()%>/salaries/salariesList1.jsp" method="get">
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