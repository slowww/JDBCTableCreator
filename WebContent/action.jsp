<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String nomeTab = request.getParameter("nometab");
if(request.getParameter("numCampi")!=null){
	int numCampi = Integer.parseInt(request.getParameter("numCampi"));
	String query = "";
	int i=0;
	try {
		Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");//richiamo la libreria
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		out.println("Impossibile caricare driver.");
	}
	query = "CREATE TABLE " + nomeTab;
	query += "(id COUNTER PRIMARY KEY,";

	for(i=0;i<=numCampi;i++) {
		String tipo = "";
		if(request.getParameter("tipocampo"+i)!=null){
			switch (request.getParameter("tipocampo"+i)){
				case "Datetime":
					tipo = "datetime";
					break;
				case "Numerico":
					tipo = "numeric(12,3)";
					break;
				default: //type: text
					tipo = "text(400)";
			}
			if(i==numCampi) {
				query += request.getParameter("campo"+i) + " "	+ tipo; //nessuna virgola sull'ultimo campo della query
			}else {
				query += request.getParameter("campo"+i) + " "	+ tipo + ", ";
			}
		}
	}
	query += ")";
	try (Connection connect = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "tableCreator.accdb")) {//ottengo la connessione al db
		Statement stm = connect.createStatement();//canale di comunicazione per scrivere sul db
		stm.execute(query);
		out.println("Tabella creata con successo!");

	}catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		out.println("Errore, impossibile creare la tabella.");
	}
}
%>
