package pm4.servlet;

import pm4.dal.*;
import pm4.model.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * FindUsers is the primary entry point into the application.
 * 
 * Note the logic for doGet() and doPost() are almost identical. However, there is a difference:
 * doGet() handles the http GET request. This method is called when you put in the /findusers
 * URL in the browser.
 * doPost() handles the http POST request. This method is called after you click the submit button.
 * 
 * To run:
 * 1. Run the SQL script to recreate your database schema: http://goo.gl/86a11H.
 * 2. Insert test data. You can do this by running blog.tools.Inserter (right click,
 *    Run As > JavaApplication.
 *    Notice that this is similar to Runner.java in our JDBC example.
 * 3. Run the Tomcat server at localhost.
 * 4. Point your browser to http://localhost:8080/BlogApplication/findusers.
 */



@WebServlet("/findplayers")
public class FindPlayers extends HttpServlet {
   
   protected PlayersDao playersDao;
   protected CharacterInfoDao characterInfoDao;
   protected CharacterJobsDao characterJobsDao;
 
   
   @Override
   public void init() throws ServletException {
       playersDao = PlayersDao.getInstance();
       characterInfoDao = CharacterInfoDao.getInstance();
       characterJobsDao = CharacterJobsDao.getInstance();

   }
   
   @Override
   public void doGet(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
      Map<String, String> messages = new HashMap<String, String>();
      req.setAttribute("messages", messages);

      List<Players> players = new ArrayList<Players>();
      
      String userName = req.getParameter("username");
      if (userName == null || userName.trim().isEmpty()) {
          messages.put("success", "Please enter a valid username.");
      } else {
          try {
              players = playersDao.getPlayersByPartialUsername(userName);
              messages.put("success", "Displaying results for " + userName);
              messages.put("previousUserName", userName);
          } catch (SQLException e) {
              e.printStackTrace();
              throw new IOException(e);
          }
      }
      req.setAttribute("players", players);
      
      List<CharacterInfo> characters = new ArrayList<>();
      Map<CharacterInfo, CharacterJobs> characterInfoJobs = new HashMap<>();
      try {
          for (Players player : players) {
              List<CharacterInfo> playerCharacters = characterInfoDao.getCharactersByPlayerID(player.getPlayerID());
           // In both doGet() and doPost() methods, replace the existing characterJobs loop with:
              for (CharacterInfo character : playerCharacters) {
                  characters.add(character);
                  List<CharacterJobs> jobs = characterJobsDao.getCharacterJobsByCharacter(character);
                  for (CharacterJobs job : jobs) {
                      if (job.isCurrentJob()) {  // Only add current job
                          characterInfoJobs.put(character, job);
                          break;  // Exit once current job is found
                      }
                  }
              }
          }
      } catch (SQLException e) {
          e.printStackTrace();
          throw new IOException(e);
      }
      req.setAttribute("characters", characters);
      req.setAttribute("characterJobs", characterInfoJobs);
      
      req.getRequestDispatcher("/FindPlayers.jsp").forward(req, resp);
   }
   
   @Override
   public void doPost(HttpServletRequest req, HttpServletResponse resp)
           throws ServletException, IOException {
       Map<String, String> messages = new HashMap<String, String>();
       req.setAttribute("messages", messages);

       List<Players> players = new ArrayList<Players>();
       
       String userName = req.getParameter("username");
       if (userName == null || userName.trim().isEmpty()) {
           messages.put("success", "Please enter a valid username.");
       } else {
           try {
               players = playersDao.getPlayersByPartialUsername(userName);
               messages.put("success", "Displaying results for " + userName);
           } catch (SQLException e) {
               e.printStackTrace();
               throw new IOException(e);
           }
       }
       req.setAttribute("players", players);
       
       List<CharacterInfo> characters = new ArrayList<>();
       Map<CharacterInfo, CharacterJobs> characterInfoJobs = new HashMap<>();
  
       try {
    	   for (Players player : players) {
    		    List<CharacterInfo> playerCharacters = characterInfoDao.getCharactersByPlayerID(player.getPlayerID());
    		
    		    for (CharacterInfo character : playerCharacters) {
    		        characters.add(character);
    		        List<CharacterJobs> jobs = characterJobsDao.getCharacterJobsByCharacter(character);
    		        for (CharacterJobs job : jobs) {
    		            if (job.isCurrentJob()) {  // Only add current job
    		                characterInfoJobs.put(character, job);
    		                break;  // Exit once current job is found
    		            }
    		        }
    		    }
    		}
       } catch (SQLException e) {
           e.printStackTrace();
           throw new IOException(e);
       }
       req.setAttribute("characters", characters);
       req.setAttribute("characterJobs", characterInfoJobs);
    
       
       req.getRequestDispatcher("/FindPlayers.jsp").forward(req, resp);
   }
}