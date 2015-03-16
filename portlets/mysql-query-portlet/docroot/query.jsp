
<%
/**
 * Copyright (c) 2000-2008 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="javax.portlet.PortletMode"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayWindowState" %>
<%@ page session="true" %>
<%@ page import="com.rknowsys.mysql.portlet.HibernateUtil" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ page language="java" import="java.sql.Connection" %>
<%@ page language="java" import="java.sql.DatabaseMetaData" %>
<%@ page language="java" import="java.sql.DriverManager" %>
<%@ page language="java" import="java.sql.ResultSet" %>
<%@ page language="java" import="java.sql.Statement" %>
<%@ page language="java" import="java.sql.ResultSetMetaData" %>
<%@ page language="java" import="java.sql.*" %>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.Query"%>
<%@page import="org.hibernate.Transaction"%><jsp:directive.page import="java.util.*" />
<%@page import="javax.portlet.ActionRequest" %>
<%@page import="com.liferay.portlet.PortletPreferencesFactoryUtil" %>
<%@page import="javax.portlet.PortletPreferences" %>


<head>
<script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
</head>

<jsp:directive.page import="java.text.*" />
<portlet:defineObjects />
 <%
 	//PortletPreferences portletPreferences=null;
 	String show_view=GetterUtil.getString(portletPreferences.getValue("SelectUserOperation", StringPool.TRUE));
 	System.out.println(show_view);
	
%>

<%
	Session dbconSession = HibernateUtil.getSessionFactory().openSession();
	Connection con = dbconSession.connection();//getting connection oobject
	
	String query = (String) renderRequest.getAttribute("query");
	ResultSet rs=null;
	Statement stmt=null;
	String modifiedQuery = null;
	boolean success = true;
	String errorMessage = "";

		//checking for update and delete operations
	try{
		if(query.trim().startsWith("delete") || query.trim().startsWith("DELETE") || query.trim().startsWith("update") ||query.trim().startsWith("UPDATE") ||
			query.trim().startsWith("drop") || query.trim().startsWith("DROP") || query.trim().startsWith("insert") || query.trim().startsWith("INSERT") ||
			query.trim().startsWith("create") || query.trim().startsWith("CREATE") )
		{	
			if(show_view.equals("Update"))
			{
				Transaction tx = dbconSession.beginTransaction();
				Query querystr = dbconSession.createSQLQuery(query);
				querystr.executeUpdate();
				tx.commit();
				if(query.trim().startsWith("update") || query.trim().startsWith("UPDATE") ) {
				%>
					<div style="font-weight:bold; color:green">Query updated  successfully!</div>
				<%		   
	
				}
				else if(query.trim().startsWith("create") || query.trim().startsWith("CREATE")){
													
				%>
					<div style="font-weight:bold; color:green">Table Created Successfully!</div>
				<%	
				
				} else if(query.trim().startsWith("delete") || query.trim().startsWith("DELETE")){
				%>
					<div style="font-weight:bold; color:green">Query deleted successfully!</div>
				<%
				
				}
				else if(query.trim().startsWith("insert") || query.trim().startsWith("INSERT")){
				%>
					<div style="font-weight:bold; color:green">Query inserted successfully!</div>
				<%	
				
				}
				else{
				%>
					<div style="font-weight:bold; color:green">Query dropped successfully!</div>
				<%
				
				}
			}
			else{
					%>
					<div style="font-weight:bold; color:green">Sorry, but you do not have access to anything but (SELECT) - contact your admin for more privileges</div>
					<%			
			}
			
		}
		else if(show_view.equals("Select") || show_view.equalsIgnoreCase("Update"))
			{
				if(query.trim().startsWith("select") || query.trim().startsWith("SELECT")){//select operations
					modifiedQuery = query;
				}else if(query.trim().startsWith("call") || query.trim().startsWith("CALL")) {//calling the procedures
					modifiedQuery = query;
				}
		
				if(modifiedQuery != null){
				stmt=con.createStatement();
				rs = stmt.executeQuery(modifiedQuery);
				ResultSetMetaData md = rs.getMetaData();
				int col = md.getColumnCount();
				//out.println(col);
	%>

<style type="text/css">
	div.scrollabletable{
		width:600px;
		height:450px;
		border: 1px solid #ccc;
		overflow:scroll;
	}
</style>

<div class="scrollabletable">
<table CELLSPACING="5" CELLPADDING="5" border="1" >
	<tr>
		
<%     
		//displaying the result coloumn names
		for (int i = 1; i <= col; i++){
		          String col_name = md.getColumnName(i);
		      
%>
<td align="center"><b><%=col_name %></b></td>
<%		         
		}
%>
	
	</tr>
	<tr>		
<%
		//displaying the query result data
		while(rs.next()){
			for (int i = 1; i<=col; i++) {
								
%>
<td bgcolor="#eeffaa" valign="top"><%=rs.getString(i)%></td>
<% 	
			
			}
%>
</tr>
<%			
       	}
%>
</table>
</div>
<div style="font-weight:bold; color:green">Query successfully executed..</div>
<%
		}
	}
		else
		{
			%>
			<div style="font-weight:bold; color:green">you don't have permission to execute this query</div>
			<%	
			}
		}
		catch(SQLException e){
		success = false;
		e.printStackTrace();
		errorMessage = "Unable to execute query";
		
	}
	catch(Exception e){
		success = false;
		e.printStackTrace();
		errorMessage = e.getMessage();
	}
	finally{
	
		if(dbconSession != null){
			con = null;
			dbconSession.close();
		}		
	}
	
	//alert the actual error message
	if(success == false){
%>
<script type="text/javascript">
	alert('<%=errorMessage %>');
</script>
<%
	}
%>