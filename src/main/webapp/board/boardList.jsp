<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//1.요청 분석
	int currentPage = 1; //넘어오지않으면 1페이지
	if(request.getParameter("currentPage") != null)//넘어오는 페이지가 있을때
	{
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");
	
	//2.요청 처리 후 모델데이터 생성 % 페이지 변수 초기화
	final int ROW_PER_PAGE = 10;//final은 상수로 바뀜(정하면 변하지 않음), 전부 대문자 & 스네이크 방식으로 변수 표기	
	int beginRow = (currentPage-1)*ROW_PER_PAGE;//.... LIMIT beginRow, ROW_PER_PAGE
	int lastPage = 0;
	int cnt = 0;//전체 행수
	
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//쿼리 변수 초기화
	//검색 후 총 행수 구하는 쿼리
	String wordSql = null;
	PreparedStatement wordStmt = null;
	//검색 후 페이지에 뜨는 행수 구하는 쿼리 	
	String wordListSql = null;
	PreparedStatement wordListStmt = null;
	
	//1) word가 null 이거나 "" 공백일떄 총 행수 & 리스트에 나오는 행수
	if(word == null || word.equals(""))
	{
		wordSql = "SELECT COUNT(*) cnt FROM board";
		wordStmt = conn.prepareStatement(wordSql);
		ResultSet wordRs = wordStmt.executeQuery();
		
		if(wordRs.next())//총 행수 구하기
		{
			cnt = wordRs.getInt("cnt");
		}
		
		String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?,?";
		wordListStmt = conn.prepareStatement(listSql);
		wordListStmt.setInt(1, beginRow);
		wordListStmt.setInt(2, ROW_PER_PAGE);
		
	}
	else //2) word에 검색단어가 들어올때 총 행수 & 리스트에 나오는 행수
	{
		wordSql = "SELECT COUNT(*) cnt FROM board WHERE board_title LIKE ?";
		wordStmt = conn.prepareStatement(wordSql);
		wordStmt.setString(1, "%"+word+"%");
		ResultSet wordRs = wordStmt.executeQuery();
		
		if(wordRs.next())//총 행수 구하기
		{
			cnt = wordRs.getInt("cnt");
		}
		
		String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no ASC LIMIT ?,?";
		wordListStmt = conn.prepareStatement(listSql);
		wordListStmt.setString(1, "%"+word+"%");
		wordListStmt.setInt(2, beginRow);
		wordListStmt.setInt(3, ROW_PER_PAGE);
		
	}
	
	//마지막 페이지 구하기
	//올림을 하게되면 6.3 -> 7 , 5.0->5.0
	lastPage =(int) Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	
	//int lastPage =(int) Math.ceil((double)cnt / (double)ROW_PER_PAGE);//새로운 방법
	//System.out.println(lastPage+"<===lastpage"); 디버깅

	//배열 생성 & 저장
	ResultSet wordListRs = wordListStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(wordListRs.next())
	{
		Board b = new Board();
		b.boardNo = wordListRs.getInt("boardNo");
		b.boardTitle = wordListRs.getString("boardTitle");
		boardList.add(b);
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
		<h1>게시판</h1>
		<!-- 3-1 모델데이터(ArrayList<Board>) 출력 -->
		<table class="table table-hover">
			<tr  class="table-warning">
				<td>번호</td>
				<td>제목</td>
			</tr>
			<%
				for(Board b : boardList)
				{
			%>
					<tr>
						<td><%=b.boardNo %></td>
						<!-- 제목 클릭시 상세보기 이동 -->
						<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle %></a></td>
					</tr>	
			<%	
				}
			%>
		</table>
		
		<!-- 3.2 페이징 -->
		<div class="inner-div">
			<%
				if(word == null && currentPage!=1 )
				{
			%>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=1">처음으로</a>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%	
				}
				else if(word == null && currentPage==1 )
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%		
				}
				else if(word != null && currentPage!=1 )
				{
			%>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
				else if(word != null && currentPage==1)
				{
			%>
					<span>처음으로</span>
					<span>이전</span>
			<%
				}
			%>
				<span>[ <%=currentPage %> ]</span>
			<%
				if(word == null && currentPage < lastPage)
				{
			%>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
			<%
				}
				else if (word == null && currentPage == lastPage)
				{
			%>		
					<span>다음</span>
					<span>마지막으로</span>
			<%		
				}
				else if(word != null && currentPage < lastPage)
				{
			%>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
					<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막으로</a>
			<%
				}
				else if(word != null && currentPage == lastPage)
				{
			%>
					<span>다음</span>
					<span>마지막으로</span>
			<%	
				}
			%>
		</div>
		
		<span style="float:left;">
			<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="get">
				<label for="word">제목검색</label>
				<%
					if(word != null)
					{
				%>
						<input type="text" name="word" id="word" value="<%=word%>">
				<%	
					}
					else if(word == null)
					{
				%>		
						<input type="text" name="word" id="word" placeholder="검색어를 입력하세요." onfocus="this.placeholder=''" onblur="this.placeholder='검색어를 입력하세요.'">
				<%		
					}
				%>
				<button type="submit">검색</button>
			</form>
		</span>
	
		<div style="float:right;">
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">&#10133;게시글 작성 하기</a>
		</div>
	</div>
</body>
</html>