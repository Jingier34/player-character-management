package pm4.servlet;

import pm4.dal.*;
import pm4.model.*;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/playerdelete")
public class PlayerDelete extends HttpServlet {
	protected PlayersDao playersDao;

	@Override
	public void init() throws ServletException {
		playersDao = PlayersDao.getInstance();
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String returnUsername = req.getParameter("returnUsername");

		try {
			Players player = playersDao.getPlayerFromUserName(username);
			if (player != null) {
				playersDao.delete(player);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new IOException(e);
		}

		if (returnUsername != null && !returnUsername.trim().isEmpty()) {
			resp.sendRedirect("findplayers?username=" + returnUsername);
		} else {
			resp.sendRedirect("findplayers");
		}
	}
}
