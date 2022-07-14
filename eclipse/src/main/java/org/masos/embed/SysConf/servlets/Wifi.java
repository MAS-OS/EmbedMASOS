package org.masos.embed.SysConf.servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.masos.embed.SysConf.controller.SSHaux;
import org.masos.embed.SysConf.controller.Connection;
import org.masos.embed.SysConf.controller.ShellCommands;
import org.masos.embed.SysConf.model.User;

/**
 * Servlet implementation class Wifi
 */
@WebServlet("/Wifi")
public class Wifi extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Wifi() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
	
		String action = request.getParameter("action");		
		RequestDispatcher dispatcher = request.getRequestDispatcher("wifiscan.jsp"); 						/*default*/
			
		User userSession = new User();
		userSession = (User) request.getSession().getAttribute("userSession");
		
		SSHaux serverSession = new SSHaux();
		serverSession = (SSHaux) request.getSession().getAttribute("serverSession");

		Connection conn = new Connection(userSession.getUsername(),userSession.getPassword(),
				serverSession.getHostname(),serverSession.getPort());
		
		ShellCommands cmd = new ShellCommands();
		
		if(action!=null) {
			if(action.equals("scan")){	
				conn.scanWLAN();
				request.setAttribute("resposta",conn.listWLANs());
			}
			else if(action.equals("status")){
				conn.refreshWLAN();
				request.setAttribute("resposta",conn.statusWLAN());
			}
			else if(action.equals("apmode")){
				
				serverSession.connect(userSession.getUsername(), userSession.getPassword());
				serverSession.exec(cmd.createTask());
				serverSession.exec(cmd.addTask(cmd.getAPModeWLAN()));
				serverSession.exec(cmd.addTask(cmd.getRestartWLAN()));
				serverSession.exec(cmd.playTask());
				serverSession.disconnect();
				
				userSession.logout();

				request.setAttribute("resposta","Configuração em Andamento. Aguarde!");
				dispatcher = request.getRequestDispatcher("home.jsp");

			}else if(action.equals("delconf")) {
				serverSession.connect(userSession.getUsername(), userSession.getPassword());
				serverSession.exec(cmd.createTask());
				serverSession.exec(cmd.addTask(cmd.getDelWLANsConf()));
				serverSession.exec(cmd.playTask());
				serverSession.disconnect();
				
				request.setAttribute("resposta","Configurações de WLAN apagadas!");
				dispatcher = request.getRequestDispatcher("wifiscan.jsp");
			}else if(action.equals("listconf")) {
				
				String list = "<hr>Redes cadastradas<br>";
				serverSession.connect(userSession.getUsername(), userSession.getPassword());
				list = list + serverSession.exec("sudo cat "+cmd.getJavinoPath()+"WLANs/lan_*.conf | grep ssid");
				serverSession.disconnect();
				list = list+"<hr>";
				
				request.setAttribute("resposta",list.replaceAll("\t", "<br>"));
				dispatcher = request.getRequestDispatcher("wifiscan.jsp");
			}
			else if(action.equals("saveconf")) {
				serverSession.connect(userSession.getUsername(), userSession.getPassword());
				serverSession.exec(cmd.createTask());
				serverSession.exec(cmd.addTask(cmd.getNewWLANConf(request.getParameter("connectESSID"), request.getParameter("connectKEY"))));
				serverSession.exec(cmd.playTask());
				serverSession.disconnect();

				request.setAttribute("resposta","Configuração de WLAN adicionada com sucesso!");
				dispatcher = request.getRequestDispatcher("wifiscan.jsp");
			}else if(action.equals("restartwlan")) {
				serverSession.connect(userSession.getUsername(), userSession.getPassword());
				serverSession.exec(cmd.createTask());
				serverSession.exec(cmd.addTask(cmd.getCreateWPAfile()));
				serverSession.exec(cmd.addTask(cmd.getRestartWLAN()));
				serverSession.exec(cmd.addTask("rm -rf /tmp/javinoAPMode"));
				serverSession.exec(cmd.playTask());
				serverSession.disconnect();
				
				userSession.logout();

				request.setAttribute("resposta","Configuração em Andamento. Aguarde!");
				dispatcher = request.getRequestDispatcher("home.jsp");
			}
		}
		dispatcher.forward(request, response);
	}

}
