package pm4.servlet;

import pm4.dal.*;
import pm4.model.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/characterjobupdate")
public class CharacterJobUpdate extends HttpServlet {
	protected CharacterJobsDao characterJobsDao;
	protected CharacterInfoDao characterInfoDao;
	protected JobsDao jobsDao;

	@Override
	public void init() throws ServletException {
		characterJobsDao = CharacterJobsDao.getInstance();
		characterInfoDao = CharacterInfoDao.getInstance();
		jobsDao = JobsDao.getInstance();
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, String> messages = new HashMap<String, String>();
		req.setAttribute("messages", messages);

		String characterId = req.getParameter("characterID");

		try {
			if (characterId != null) {
				CharacterInfo character = characterInfoDao.getCharactersByCharacterID(Integer.parseInt(characterId));
				if (character != null) {
					String fullName = character.getFirstName() + " " + character.getLastName();
					req.setAttribute("characterName", fullName);

					List<CharacterJobs> jobs = characterJobsDao.getCharacterJobsByCharacter(character);
					if (!jobs.isEmpty()) {
						CharacterJobs currentJob = jobs.get(0);
						req.setAttribute("jobName", currentJob.getJob().getJobName());
						req.setAttribute("newLevel", String.valueOf(currentJob.getLevel()));
						req.setAttribute("newExp", String.valueOf(currentJob.getExperiencePoints()));
					} else {
						req.setAttribute("jobName", "");
						req.setAttribute("newLevel", "");
						req.setAttribute("newExp", "");
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new IOException(e);
		}

		req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, String> messages = new HashMap<String, String>();
		req.setAttribute("messages", messages);

		String characterId = req.getParameter("characterID");
		String newLevel = req.getParameter("newLevel");
		String newExp = req.getParameter("newExp");

		req.setAttribute("characterName", req.getParameter("characterName"));
		req.setAttribute("jobName", req.getParameter("jobName"));
		req.setAttribute("newLevel", newLevel);
		req.setAttribute("newExp", newExp);

		if ((newLevel == null || newLevel.trim().isEmpty()) && (newExp == null || newExp.trim().isEmpty())) {
			messages.put("success", "Please fill in at least one field (Level or Experience Points)");
			req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
			return;
		}

		if (newLevel != null && !newLevel.trim().isEmpty() && !isValidNumeric(newLevel)) {
			messages.put("success", "Invalid level value");
			req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
			return;
		}

		if (newExp != null && !newExp.trim().isEmpty() && !isValidNumeric(newExp)) {
			messages.put("success", "Invalid experience points value");
			req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
			return;
		}

		try {
			CharacterInfo character = characterInfoDao.getCharactersByCharacterID(Integer.parseInt(characterId));
			if (character == null) {
				messages.put("success", "Character not found.");
				req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
				return;
			}

			List<CharacterJobs> jobs = characterJobsDao.getCharacterJobsByCharacter(character);
			if (jobs.isEmpty()) {
				messages.put("success", "No jobs found for this character");
				req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
				return;
			}

			CharacterJobs characterJob = jobs.get(0);

			try {
				Integer levelValue = null;
				Integer expValue = null;

				if (newLevel != null && !newLevel.trim().isEmpty()) {
					levelValue = Integer.parseInt(newLevel);
					if (levelValue <= 0) {
						messages.put("success", "Level must be positive");
						req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
						return;
					}
				}

				if (newExp != null && !newExp.trim().isEmpty()) {
					expValue = Integer.parseInt(newExp);
					if (expValue < 0) {
						messages.put("success", "Experience Points must be non-negative");
						req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
						return;
					}
				}

				if (levelValue == null) {
					levelValue = characterJob.getLevel();
				}
				if (expValue == null) {
					expValue = characterJob.getExperiencePoints();
				}

				characterJob = characterJobsDao.updateLevelAndExperience(characterJob, levelValue, expValue);

				if (characterJob != null) {
					StringBuilder successMessage = new StringBuilder("Successfully updated ");
					successMessage.append(character.getFirstName()).append(" ").append(character.getLastName())
							.append("'s ").append(characterJob.getJob().getJobName());

					if (newLevel != null && !newLevel.trim().isEmpty()) {
						successMessage.append(" level to ").append(newLevel);
					}
					if (newExp != null && !newExp.trim().isEmpty()) {
						if (newLevel != null && !newLevel.trim().isEmpty()) {
							successMessage.append(" and");
						}
						successMessage.append(" experience to ").append(newExp);
					}
					messages.put("success", successMessage.toString());
				} else {
					messages.put("success", "Failed to update job");
				}
			} catch (NumberFormatException e) {
				messages.put("success", "Invalid level or experience value");
				req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
				return;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			messages.put("success", "Error: " + e.getMessage());
		}

		req.getRequestDispatcher("/CharacterJobUpdate.jsp").forward(req, resp);
	}

	private boolean isValidNumeric(String input) {
		return input != null && input.matches("\\d+");
	}
}