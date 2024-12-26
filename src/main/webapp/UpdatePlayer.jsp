<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Player</title>
</head>
<body>
	<h1>Update Player</h1>
	<form action="playerupdate" method="post">
		<p>
			<label for="oldUsername">Current Username</label> <input
				id="oldUsername" name="oldUsername"
				value="${fn:escapeXml(param.username)}" readonly>
		</p>
		<p>
			<label for="newUsername">New Username</label> <input id="newUsername"
				name="newUsername" value="">
		</p>
		<p>
			<input type="submit">
		</p>
	</form>
	<br />
	<br />
	<p>
		<span id="successMessage"><b>${messages.success}</b></span>
	</p>
	<br />
</body>
</html>