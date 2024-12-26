<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find By Player</title>
<style>
#sortBy {
    width: 200px;
}
</style>
</head>
<body>
<form action="findplayers" method="get">
    <h1>Search for a Player and Associated Characters by Username</h1>
    <p>
        <label for="username">User Name:</label>
        <input id="username" name="username" value="${fn:escapeXml(param.username)}">
    </p>
    <p>
        <input type="submit">
        <br />
        <br />
        <span id="successMessage"><b>${messages.success}</b></span>
    </p>
</form>
<br />
<div>
    <a href="playercreate">Create Player</a>
</div>
<br />

<h1>Matching Players</h1>
<table border="1">
    <tr>
        <th>User Name</th>
        <th>Email</th>
        <th>Update UserName</th>
        <th>Delete User</th>
    </tr>
    <c:forEach items="${players}" var="player">
        <tr>
            <td><c:out value="${player.userName}" /></td>
            <td><c:out value="${player.email}" /></td>
            <td><a href="playerupdate?username=${player.userName}">Update</a></td>
            <td><a href="playerdelete?username=${player.userName}&returnUsername=${param.username}">Delete</a></td>
        </tr>
    </c:forEach>
</table>

<h1>Associated Characters</h1>
<div style="margin-bottom: 20px;">
    <form id="sortForm" action="findplayers" method="get">
        <label for="sortBy">Sort by:</label>
        <input type="text" id="sortBy" name="sortBy" value="${param.sortBy}"
            placeholder="name/player/job/hp/level/exp">
        <label for="sortOrder">Sort order:</label>
        <input type="text" id="sortOrder" name="sortOrder" value="${param.sortOrder}"
            placeholder="ASC/DESC">
        <input type="hidden" name="username" value="${param.username}">
        <input type="submit" value="Sort">
    </form>
    <br />
    <span style="color: red;"><b>${messages.sortMessage}</b></span>
</div>

<table border="1">
    <tr>
        <th>Character Name</th>
        <th>Player</th>
        <th>Job</th>
        <th>Max HP</th>
        <th>Job Level</th>
        <th>Experience Points</th>
        <th>Details</th>
    </tr>
    <c:forEach items="${characters}" var="character">
        <tr>
            <td><c:out value="${character.firstName} ${character.lastName}" /></td>
            <td><c:out value="${character.player.userName}" /></td>
            <td><c:out value="${characterJobs[character].job.jobName}" /></td>
            <td><c:out value="${character.maxHP}" /></td>
            <td><c:out value="${characterJobs[character].level}" /></td>
            <td><c:out value="${characterJobs[character].experiencePoints}" /></td>
            <td class="actions">
                <a href="CharacterEquipmentServlet?characterID=${character.characterID}&searchUsername=${param.username}">Equipments</a>
                | <a href="inventoryDetail?characterID=${character.characterID}&searchUsername=${param.username}">Inventory</a>
                | <a href="attributes?characterID=${character.characterID}&searchUsername=${param.username}">Attributes</a>
                | <a href="characterjobupdate?characterID=${character.characterID}&searchUsername=${param.username}">Update Job Level & Experience Points</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>

<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find By Player</title>
<style>
#sortBy {
	width: 200px;
}
</style>
</head>
<body>
	<form action="findplayers" method="get">
		<h1>Search for a Player and Associated Characters by Username</h1>
		<p>
			<label for="username">User Name:</label> <input id="username"
				name="username" value="${fn:escapeXml(param.username)}">
		</p>
		<p>
			<input type="submit"> <br />
			<br /> <span id="successMessage"><b>${messages.success}</b></span>
		</p>
	</form>
	<br />
	<div>
		<a href="playercreate">Create Player</a>
	</div>
	<br />

	<h1>Matching Players</h1>
	<table border="1">
		<tr>
			<th>User Name</th>
			<th>Email</th>
			<th>Update UserName</th>
			<th>Delete User</th>
		</tr>
		<c:forEach items="${players}" var="player">
			<tr>
				<td><c:out value="${player.userName}" /></td>
				<td><c:out value="${player.email}" /></td>
				<td><a href="playerupdate?username=${player.userName}">Update</a>
				</td>
				<td><a
					href="playerdelete?username=${player.userName}&returnUsername=${param.username}">Delete</a>
				</td>
			</tr>
		</c:forEach>
	</table>

	<h1>Associated Characters</h1>
	<div style="margin-bottom: 20px;">
		<form id="sortForm" action="findplayers" method="get">
			<label for="sortBy">Sort by:</label> <input type="text" id="sortBy"
				name="sortBy" value="${param.sortBy}"
				placeholder="name/player/job/hp/level"> <label
				for="sortOrder">Sort order:</label> <input type="text"
				id="sortOrder" name="sortOrder" value="${param.sortOrder}"
				placeholder="ASC/DESC"> <input type="hidden" name="username"
				value="${param.username}"> <input type="submit" value="Sort">
		</form>
		<br /> <span style="color: red;"><b>${messages.sortMessage}</b></span>
	</div>

	<table border="1">
		<tr>
			<th>Character Name</th>
			<th>Player</th>
			<th>Job</th>
			<th>Max HP</th>
			<th>Job Level</th>
			<th>Experience Points</th>
			<th>Details</th>
		</tr>
		<c:forEach items="${characters}" var="character">
			<tr>
				<td><c:out value="${character.firstName} ${character.lastName}" /></td>
				<td><c:out value="${character.player.userName}" /></td>
				<td><c:out value="${characterJobs[character].job.jobName}" /></td>
				<td><c:out value="${character.maxHP}" /></td>
				<td><c:out value="${characterJobs[character].level}" /></td>
				<td><c:out value="${characterJobs[character].experiencePoints}" /></td>
				<td class="actions"><a
					href="CharacterEquipmentServlet?characterID=${character.characterID}&searchUsername=${param.username}">Equipments</a>
					| <a
					href="inventoryDetail?characterID=${character.characterID}&searchUsername=${param.username}">Inventory</a>
					| <a
					href="attributes?characterID=${character.characterID}&searchUsername=${param.username}">Attributes</a>
					| <a
					href="characterjobupdate?characterID=${character.characterID}&searchUsername=${param.username}">Update
						Job Level & Experience Points </a></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html> --%>