<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
	if (session.getAttribute("userID") != null) { //userID이름으로 세션이 존재하는 회원들은
		userID = (String) session.getAttribute("userID"); //userID에 해당 세션값을 넣어준다.
	}
	if (userID == null) {
		//로그인 안돼있는 사람
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href='login.jsp");
		script.println("</script>");
	}
	int bbsID = 0;
	//매개변수로 넘어온 bbsID 매개변수가 존재한다면 
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	//번호가 없으면 글 목록으로 다시 이동시킴
	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href='bbs.jsp");
		script.println("</script>");
	}
	//글 작성자와 현재사용자 비교
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href='bbs.jsp");
		script.println("</script>");
	}

	else {
		//로그인이 돼있는 사람이 정보를 입력안했다면
		if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			//정보를 다 입력했을 시 데이터베이스에 등록해줌
			BbsDAO bbsDAO = new BbsDAO();
			int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); //0,1,-1,-2 값 담김
			if (result == -1) { //데이터베이스 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('글쓰기에 실패했습니다.')");
		script.println("history.back()");
		script.println("</script>");
			} else { //아무 이상 없을 때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='bbs.jsp'");
		script.println("</script>");
			}
		}
	}
	%>
</body>
</html>