<%@page import="com.yc.drp.manager.UserManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = request.getParameter("userId");
	if(UserManager.getInstance().findUserById(userId)!=null){
		out.println("用户代码存在");
	}
	
%>