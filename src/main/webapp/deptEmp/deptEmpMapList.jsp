<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	//요청 페이지 정보 
	int currentPage = 1;
	if(request.getParameter("currentPage") != null)
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//요청 검색 정보
	String word = null;
	word = request.getParameter("word");
	
	//페이징 위한 변수 초기화
	int rowPerPage = 10;
	int begineRow = (currentPage-1)*rowPerPage;
	int count = 0;
	int lastPage = 0;
	
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	String conURL = "jdbc:mariadb://localhost:3306/employees";
	String conUser = "root";
	String conPw = "java1234";
	Connection conn = DriverManager.getConnection(conURL,conUser,conPw);
	
	//쿼리변수 초기화
	String cntSql = null;
	PreparedStatement cntStmt = null;
	String sql = null;
	PreparedStatement stmt =null;
	ResultSet rs = null;
	
	
	if(word == null || word.equals("")) //
	{//word가 null 이거나 빈칸일때 총 행수 구하기
		cntSql = "SELECT COUNT(*) FROM dept_emp de";
		cntStmt = conn.prepareStatement(cntSql);
		ResultSet cntRs = cntStmt.executeQuery();
		while(cntRs.next())
		{
			count = cntRs.getInt("COUNT(*)");
		}
		//System.out.println(count); 디버깅
		lastPage = count/rowPerPage;
		if(count%rowPerPage != 0)
		{
			lastPage = lastPage+1;
		}
		
		//리스트에 보여지는 정보
		sql = "SELECT e.emp_no empNo, d.dept_name deptName ,de.dept_no deptNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, begineRow);
		stmt.setInt(2, rowPerPage);
		rs = stmt.executeQuery();
	}
	else
	{//word가 null이 아닐때 총 행수 구하기
		cntSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
		ResultSet cntRs = cntStmt.executeQuery();
		while(cntRs.next())
		{
			count = cntRs.getInt("COUNT(*)");
		}
		lastPage = count/rowPerPage;
		if(count%rowPerPage != 0)
		{
			lastPage = lastPage + 1;
		}
		//리트스에 보여지는 정보
		sql = "SELECT e.emp_no empNo, d.dept_name deptName ,de.dept_no deptNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, begineRow);
		stmt.setInt(4, rowPerPage);
		rs = stmt.executeQuery();
	}
	
	//HashMap을 이용한 ArrayList
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	while(rs.next())
	{
		HashMap<String, Object> hMap = new HashMap<String, Object>();
		hMap.put("empNo", rs.getInt("empNo"));
		hMap.put("firstName", rs.getString("firstName"));
		hMap.put("lastName", rs.getString("lastName"));
		hMap.put("deptName", rs.getString("deptName"));
		hMap.put("fromDate", rs.getString("fromDate"));
		hMap.put("toDate", rs.getString("toDate"));
		mapList.add(hMap);
	}
	
	rs.close();//rs 연결을 끊는것
	stmt.close();//stmt 연결을 끊는것
	conn.close();//conn 연결을 끊는것 마지막에 쓸것

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
</head>
<body>

	<!-- 메뉴 -->
	<div class="center">
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
	</div>
	
	<div class="container">
		<h1>사원&부서 정보목록</h1>
		<table class="table table table-hover">
			<tr class="table-warning">
				<td>사원번호</td>
				<td>사원이름</td>
				<td>부서이름</td>
				<td>시작일</td>
				<td>종료일</td>
			</tr>
			<%
				for(HashMap<String, Object> hMap : mapList )
				{
			%>		
					<tr>
						<td><%=hMap.get("empNo") %></td>
						<td><%=hMap.get("firstName")%>&nbsp;<%=hMap.get("lastName")%></td>
						<td><%=hMap.get("deptName")%></td>
						<td><%=hMap.get("fromDate")%></td>
						<td><%=hMap.get("toDate")%></td>
					</tr>	
			<%		
				}
			%>
		</table>
	
		<div class="inner-div">
			<%
				if(word == null && currentPage>1)
				{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음으로</a>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
				else if(word != null && currentPage>1 )
				{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
				else if( word == null && currentPage == 1 || word != null && currentPage == 1)
				{
			%>	
					<span>처음으로</span>	
					<span>이전</span>	
			<%
				}
			%>
			
			<span> [ <%=currentPage %> ] </span>
			
			<%
				if(word == null && currentPage<lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
			<%
				}
				else if ( word != null && currentPage<lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막으로</a>
			<%		
				}
				else if(word == null && currentPage==lastPage || word != null && currentPage==lastPage)
				{
			%>
					<span>다음</span>	
					<span>마지막으로</span>
			<%
				}
			%>
			
		</div>
	
		<span style="float:left;">
			<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="get">
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