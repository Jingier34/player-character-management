<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find By Player</title>
</head>
<body>
    <form action="findplayers" method="post">
        <h1>Search for a Player by Name</h1>
        <p>
            <label for="username">User Name:</label>
            <input id="username" name="username" value="${fn:escapeXml(param.username)}">
        </p>
        <p>
            <input type="submit">
            <br/><br/>
            <span id="successMessage"><b>${messages.success}</b></span>
        </p>
    </form>
    <br/>
    <div><a href="playercreate">Create Player</a></div>
    <br/>

    <h1>Matching Players</h1>
    <table style="text-align: center; border-spacing: 20px; border-collapse: separate;">
        <tr>
            <th>PlayerID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
        <c:forEach items="${players}" var="player">
            <tr>
                <td><c:out value="${player.playerID}" /></td>
                <td><c:out value="${player.userName}" /></td>
                <td><c:out value="${player.email}" /></td>
                <td>
                    <a href="playerupdate?playerid=${player.playerID}">Update</a> |
                    <a href="playerdelete?playerid=${player.playerID}">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>

    <h1>Characters</h1>
    <table style="text-align: center; border-spacing: 20px; border-collapse: separate;">
        <tr>
            <th>Character Name</th>
            <th>Player</th>
            <th>Job</th>
            <th>Max HP</th>
            <th>Level</th>
            <th>Actions</th>
        </tr>
        <c:forEach items="${characters}" var="character">
            <tr>
                <td><c:out value="${character.firstName} ${character.lastName}" /></td>
                <td><c:out value="${character.player.userName}" /></td>
                <td><c:out value="${characterJobs[character].job.jobName}" /></td>
                <td><c:out value="${character.maxHP}" /></td>
              	<td><c:out value="${characterJobs[character].level}" /></td>
                <td class="actions">
				    <a href="CharacterEquipmentServlet?characterID=${character.characterID}">Equipment</a> |
				    <a href="inventoryDetail?characterID=${character.characterID}">Inventory</a> |
				    <a href="characterattributes?characterID=${character.characterID}">Attributes</a> |
				    <a href="characterjobupdate?characterID=${character.characterID}">Update</a> |
				    <a href="characterdelete?characterID=${character.characterID}">Delete</a>
				</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
