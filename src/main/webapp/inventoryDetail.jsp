<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Character Inventory Details</title>
</head>
<body>
	<h1>Character Info</h1>
	<p>First Name: ${character.firstName}</p>
	<p>Last Name: ${character.lastName}</p>

	<h1>Inventory Details</h1>
	<table border="1">
		<tr>
			<th>Position</th>
			<th>Item Name</th>
			<th>Quantity</th>
			<th>Unit Price</th>
			<th>Total Value</th>
		</tr>
		<c:forEach items="${inventory}" var="item">
			<tr>
				<td><c:out value="${item.stackPosition}" /></td>
				<td><c:out value="${item.items.itemName}" /></td>
				<td><c:out value="${item.stackSize}" /></td>
				<td><c:out value="${item.items.vendorPrice}" /></td>
				<td><c:out value="${item.stackSize * item.items.vendorPrice}" /></td>
			</tr>
		</c:forEach>
		<c:if test="${empty inventory}">
			<tr>
				<td colspan="5">No items found in inventory.</td>
			</tr>
		</c:if>
	</table>

</body>
</html>