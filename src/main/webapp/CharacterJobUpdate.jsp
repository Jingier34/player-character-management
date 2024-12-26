<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Character Job Level and Experience</title>
</head>
<body>
	<h1>Update Character Job Level and Experience</h1>
	<form action="characterjobupdate" method="post">
		<p>
			<label for="characterName">Character Full Name:</label> <span>${fn:escapeXml(characterName)}</span>
			<input type="hidden" id="characterName" name="characterName"
				value="${fn:escapeXml(characterName)}">
		</p>
		<p>
			<label for="jobName">Job Name:</label> <span>${fn:escapeXml(jobName)}</span>
			<input type="hidden" id="jobName" name="jobName"
				value="${fn:escapeXml(jobName)}">
		</p>
		<p>
			<label for="newLevel">New Level</label> <input id="newLevel"
				name="newLevel" type="text" pattern="[0-9]+"
				title="Only numbers allowed" placeholder="${fn:escapeXml(newLevel)}">
		</p>
		<p>
			<label for="newExp">New Experience Points</label> <input id="newExp"
				name="newExp" type="text" pattern="[0-9]+"
				title="Only numbers allowed" placeholder="${fn:escapeXml(newExp)}">
		</p>
		<input type="hidden" name="characterID" value="${param.characterID}">
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