package pm4.servlet;

import pm4.dal.*;
import pm4.model.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/playerupdate")
public class PlayerUpdate extends HttpServlet {
	protected PlayersDao playersDao;

	@Override
	public void init() throws ServletException {
		playersDao = PlayersDao.getInstance();
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Maps to store the messages.
		Map<String, String> messages = new HashMap<String, String>();
		req.setAttribute("messages", messages);

		String username = req.getParameter("username");
		if (username == null || username.trim().isEmpty()) {
			messages.put("success", "Please enter a valid username.");
		}

		req.getRequestDispatcher("/UpdatePlayer.jsp").forward(req, resp);
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, String> messages = new HashMap<String, String>();
		req.setAttribute("messages", messages);

		String oldUsername = req.getParameter("oldUsername");
		String newUsername = req.getParameter("newUsername");

		if (newUsername == null || newUsername.trim().isEmpty()) {
			messages.put("success", "Please enter a valid new username");
		} else {
			try {
				Players player = playersDao.getPlayerFromUserName(oldUsername);
				if (player == null) {
					messages.put("success", "User does not exist.");
				} else {
					player = playersDao.updatePlayerUserName(player, newUsername);
					if (player == null) {
						messages.put("success", "Failed to update user");
					} else {
						messages.put("success", "Successfully updated " + oldUsername + " to " + newUsername);
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
				throw new IOException(e);
			}
		}

		req.getRequestDispatcher("/UpdatePlayer.jsp").forward(req, resp);
	}
}