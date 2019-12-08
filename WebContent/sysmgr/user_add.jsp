<%@page import="com.yc.drp.bean.User"%>
<%@page import="com.yc.drp.manager.UserManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String command = request.getParameter("command");
	String userId = "";
	String userName = "";
	String contactTel = "";
	String email = "";
	if ("add".equals(command)) {
		User user = UserManager.getInstance().findUserById(request.getParameter("userId"));
		if (user == null) {
			User u = new User();
			u.setUserId(request.getParameter("userId"));
			u.setUserName(request.getParameter("userName"));
			u.setPassword(request.getParameter("password"));
			u.setContactTel(request.getParameter("contactTel"));
			u.setEmail(request.getParameter("email"));
			
			UserManager.getInstance().addUser(u);
			out.println("添加用户成功！");
		}else{
			userId=request.getParameter("userId");
			userName = request.getParameter("userName");
			contactTel = request.getParameter("contactTel");
			email =request.getParameter("email");
			out.println("用户代码已经存在，代码=【" + request.getParameter("userId") + "】");
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/drp.css" />
<title>Insert title here</title>
<script type="text/javascript">
	function goBack() {
		window.self.location = "user_maint.html"
	}
	function addUser() {
		var userIdField = document.getElementById("userId");
		if (userIdField.value.trim() == "") {
			alert("用户代码不能为空！");
			userIdField.focus();
			return;
		}
		//用户代码至少四个字符
		if (userIdField.value.trim().length < 4) {
			alert("用户代码至少4个字符！");
			userIdField.focus();
			return;
		}

		//第一个字符必须是字母
		if (!userIdField.value.trim().charAt(0) >= 'a'
				&& userIdField.value.trim().charAt(0) <= 'z') {
			alert("用户代码首字符必须为字母！");
			userIdField.focus();
			return;
		}
		//采用正则表达式判断用户代码只能是数字或字母，为4~6位（中午作业）
		var re = new RegExp(/^[a-zA-Z0-9]{4,6}$/);
		if (!re.test(userIdField.value.trim())) {
			alert("用户代码必须为数字或字母,只能为4~6位！");
			userIdField.focus();
			return;
		}
		//用户名称必须输入，不能和用户代码不能为空一致（中午作业）
		if (document.getElementById("userName").value.trim().length == 0) {
			alert("用户名称不能为空！");
			document.getElementById("userName").focus();
			return;
		}

		//密码至少6位（中午作业）
		if (document.getElementById("password").value.trim().length < 6) {
			alert("密码至少6位！");
			document.getElementById("password").focus();
			return;
		}
		//如果联系电话不为空，进行判断，判断规则：都为数字，采用两种方式：1、采用正则，2、不采用正则（中午作业）
		var contactTelField = document.getElementById("contactTel");
		if (contactTelField.value.trim() != "") {
			//采用正則
			re.compile(/^[0-9]*$/);
			if (!re.test(contactTelField.value.trim())) {
				alert("电话不合法");
				contactTelField.focus();
				return;
			}
		}
		var emailField = document.getElementById("email");
		if (emailField.value.trim().length != 0) {
			var emailValue = emailField.value.trim();
			if ((emailValue.indexOf("@") == 0)
					|| (emailValue.indexOf("@") == (emailValue.length - 1))) {
				alert("email地址不正确！");
				emailField.focus();
				return;
			}
			if (emailValue.indexOf("@") < 0) {
				alert("email地址不正确！");
				emailField.focus();
				return;
			}
		}
		if (document.getElementById("spanUserId").innerHTML != "") {
			alert("用户代码已经存在！");
			userIdField.focus();
			return;
		}
		//等同上面的写法
		with (document.getElementById("userForm")) {
			action = "user_add.jsp";
			method = "post";
			submit();
		}

	}
	function init() {
		document.getElementById("userId").focus();
	}
	function userIdOnKeyPress() {
		//alert(window.event.keyCode);
		if (!(event.keyCode >= 97 && event.keyCode <=122)) {
			event.keyCode = 0;
		}
	}
	var xmlHttp;
	function createXMLHttpRequest() {
		//表示当前浏览器不是ie,如ns,firefox
		if (window.XMLHttpRequest) {
			xmlHttp = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	function validate(field) {

		if (field.value.trim().length != 0) {
			createXMLHttpRequest();
			var url = "user_validate.jsp?userId=" + field.value.trim()
					+ "&time=" + new Date().getTime();
			xmlHttp.open("GET", url, true);
			//将方法地址复制给onreadystatechange属性
			//类似于电话号码
			xmlHttp.onreadystatechange = callback;

			//将设置信息发送到Ajax引擎
			xmlHttp.send(null);
		} else {
			document.getElementById("spanUserId").innerHTML = "";
		}
	}

	function callback() {
		//alert(xmlHttp.readyState);
		//Ajax引擎状态为成功
		if (xmlHttp.readyState == 4) {
			//HTTP协议状态为成功
			if (xmlHttp.status == 200) {
				if (xmlHttp.responseText.trim() != "") {
					//alert(xmlHttp.responseText);
					document.getElementById("spanUserId").innerHTML = "<font color='red'>"
							+ xmlHttp.responseText + "</font>"
				} else {
					document.getElementById("spanUserId").innerHTML = "";
				}
			} else {
				alert("请求失败，错误码=" + xmlHttp.status);
			}
		}
	}
	function userIdOnKeyPress() {
		if (!(event.keyCode >= 97 && event.keyCode <= 122)) {
			console.log(event.keyCode);
			event.keyCode = 0;
			
		}
	}
</script>
</head>
<body class="body1" onload="init()">
	<form name="userForm" target="_self" id="userForm">
		<input type="hidden" name="command" value="add">
		<div align="center">
			<table width="95%" border="0" cellspacing="2" cellpadding="2">
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table width="95%" border="0" cellspacing="0" cellpadding="0"
				height="25">
				<tr>
					<td width="522" class="p1" height="25" nowrap><img
						src="../images/mark_arrow_03.gif" width="14" height="14">
						&nbsp; <b>系统管理&gt;&gt;用户维护&gt;&gt;添加</b></td>
				</tr>
			</table>
			<hr width="97%" align="center" size=0>
			<table width="95%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="22%" height="29">
						<div align="right">
							<font color="#FF0000">*</font>用户代码:&nbsp;
						</div>
					</td>
					<td width="78%"><input name="userId" type="text" class="text1"
						id="userId" size="10" maxlength="10"
						onkeypress="userIdOnKeyPress()" value="" onblur="validate(this)">
						<span id="spanUserId"></span></td>
				</tr>
				<tr>
					<td height="26">
						<div align="right">
							<font color="#FF0000">*</font>用户名称:&nbsp;
						</div>
					</td>
					<td><input name="userName" type="text" class="text1"
						id="userName" size="20" maxlength="20" value=""></td>
				</tr>
				<tr>
					<td height="26">
						<div align="right">
							<font color="#FF0000">*</font>密码:&nbsp;
						</div>
					</td>
					<td><label> <input name="password" type="password"
							class="text1" id="password" size="20" maxlength="20">
					</label></td>
				</tr>
				<tr>
					<td height="26">
						<div align="right">联系电话:&nbsp;</div>
					</td>
					<td><input name="contactTel" type="text" class="text1"
						id="contactTel" size="20" maxlength="20" value=""></td>
				</tr>
				<tr>
					<td height="26">
						<div align="right">email:&nbsp;</div>
					</td>
					<td><input name="email" type="text" class="text1" id="email"
						size="20" maxlength="20" value=""></td>
				</tr>
			</table>
			<hr width="97%" align="center" size=0>
			<div align="center">
				<input name="btnAdd" class="button1" type="button" id="btnAdd"
					value="添加" onClick="addUser()"> &nbsp;&nbsp;&nbsp;&nbsp; <input
					name="btnBack" class="button1" type="button" id="btnBack"
					value="返回" onClick="goBack()" />
			</div>
		</div>
	</form>
</body>
</html>