<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %><!-- hashMap<키,값> ArrayList<요소>-->

<%
	//1)요청분석
	//페이징 currentPage ...
	int currentPage = 1;
	
	if(request.getParameter("currentPage") != null)
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));	
	}
	String word = null;
	word = request.getParameter("word");
	
	//2)요청처리
	//페이징 rowPerPage
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int count = 0; //총 행수 저장
	int lastPage = 0;
	//db 연결 -> 모델 생성
	
	//매개변수 자리엔 변수를 만들어 사용하는게 좋다
	String driver =  "org.mariadb.jdbc.Driver";
	String dbUrl =  "jdbc:mariadb://localhost:3306/employees";
	String dbUser =  "root";
	String dbPw =  "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl,dbUser,dbPw);//conn에 쿼리 저장, 롤백, 클로즈 등등
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	if(word==null)
	{
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no";
		cntStmt = conn.prepareStatement(cntSql);
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
		//System.out.println(count+"<====count"); 디버깅
		//System.out.println(lastPage+"<====lastPage"); 디버깅 
		
		//쿼리//join은 행과 행을 연결
		sql = "SELECT s.emp_no empNo, s.salary salary , s.from_date fromDate, CONCAT(e.first_name,' ' ,e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		
	}
	else
	{
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
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
		//System.out.println(count+"<====count"); 디버깅
		//System.out.println(lastPage+"<====lastPage"); 디버깅 
		
		//쿼리//join은 행과 행을 연결
		sql = "SELECT s.emp_no empNo, s.salary salary , s.from_date fromDate, CONCAT(e.first_name,' ' ,e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
		
	}
	
	rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next())
	{
		HashMap<String, Object> m = new HashMap<String, Object>();
		//put
		m.put("empNo",rs.getInt("empNo"));
		m.put("salary",rs.getInt("salary"));
		m.put("fromDate",rs.getString("fromDate"));
		m.put("name",rs.getString("name"));
		list.add(m);
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
<body>
	<!-- 메뉴 -->
	<div class="center">
		<jsp:include page="/inc/menu.jsp"></jsp:include><!-- jsp action tag include는 서버입장에서 호출하는것 contextpath 명을 적지 않는다 -->
	</div>
	
	<div class="container">
		<h1>연봉 목록</h1>
		<table class="table table table-hover">
			<tr class="table-warning">
				<td>사원번호</td>
				<td>연봉</td>
				<td>계약일자</td>
				<td>사원이름</td>
			</tr>
			<%
				for(HashMap<String,Object> m : list)
				{
			%>
					<tr>
						<td><%=m.get("empNo") %></td>
						<td><%=m.get("salary") %></td>
						<td><%=m.get("fromDate") %></td>
						<td><%=m.get("name") %></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<div class="inner-div">
			<%
				if(word == null && currentPage >1)
				{
			%>		
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=1">처음으로</a>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%		
				}
				else if(word != null && currentPage >1)
				{
			%>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
				else if (word == null && currentPage == 1 || word != null && currentPage == 1)
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%
				}
			%>
			
			<span> [ <%=currentPage%> ] </span>

			<%
				if(word == null && currentPage < lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=lastPage%>">마지막으로</a>		
			<%		
				}
				else if ( word != null && currentPage < lastPage)
				{
			%>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<a href="<%=request.getContextPath()%>/salaries/salaryMapList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막으로</a>
			<%		
				}
				else if(word == null && currentPage == lastPage || word != null && currentPage == lastPage)
				{
			%>
					<span>다음</span>
					<span>마지막으로</span>
			<%
				}
			%>
			
		</div>
		
		<span style="float:left;">
			<form action="<%=request.getContextPath()%>/salaries/salaryMapList.jsp" method="get">
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