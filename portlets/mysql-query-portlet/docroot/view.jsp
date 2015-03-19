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

<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@page import="javax.portlet.PortletMode"%>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.portlet.LiferayWindowState" %>
<%@ page session="true" %>
<%@ page language="java" import="java.sql.Connection" %>
<%@ page language="java" import="java.sql.DatabaseMetaData" %>
<%@ page language="java" import="java.sql.DriverManager" %>
<%@ page language="java" import="java.sql.ResultSet" %>
<%@ page language="java" import="java.sql.Statement" %>
<%@ page language="java" import="java.sql.ResultSetMetaData" %>
<%@ page language="java" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>

<%@page import="com.rknowsys.mysql.portlet.HibernateConnectionUtil"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.SessionFactory" %>
 <%@page import="java.util.*" %>
<%--<%@page import="java.text.*" %>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.UserLocalService"%>
<%@include file="init.jsp"%>
 --%>
<head>
	<script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
	<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
	<link type="text/css" rel="stylesheet" href="/<%=config.getServletContext().getServletContextName() %>/css/main.css" />
</head>

<portlet:defineObjects />

<% 	
Connection con=null;
Session dbconSession=null;
  try{
	SessionFactory factory=HibernateConnectionUtil.getSessionFactory();
	dbconSession=factory.openSession();
	con = dbconSession.connection();
  }catch(Exception ex){%>
  <h3>please choose DataBase Settings from Configuration Page</h3>
	  
 <% }
	boolean success = true;
	String errorMessage ="";
%>

<div class="query-browser">
	<div class="left-sec">
		<p class="heading">Schemata</p>
		<div class="scheema">
			<table id="tableName">
				<%
				
		try{
					Statement schemastmt=null;
					ResultSet proceduresRS=null;
					String schema_name=null;
			if(con!=null){
					 schemastmt=con.createStatement();//for getting schema's info
					
					ResultSet rs = schemastmt.executeQuery(" SELECT * FROM information_schema.SCHEMATA ");
					while(rs.next()){
						schema_name = rs.getString("SCHEMA_NAME");
						if (schema_name.equals("lportal-22")) continue;
				%>
				<tr>
					<td>
						<img id="arrow_<%= schema_name %>"  src="/<%= config.getServletContext().getServletContextName() %>/images/right.png" onclick="toggleTableDisplay('<%= schema_name %>', 1);" >
				<img src="/<%= config.getServletContext().getServletContextName() %>/images/schema.png">
				<b><%=schema_name %></b>
					</td>
				</tr>
				<%	
				Statement tablesstmt=con.createStatement();//for getting tables info
				String query = "show tables from "+schema_name;
				ResultSet tablesRS = tablesstmt.executeQuery(query);
				while(tablesRS.next()){
					String tbl_name = tablesRS.getString(1);
				%>
				<tr>
					<td class="<%= schema_name %>" style="display:none; padding-left:17px;" onClick="<portlet:namespace />_getQuery('<%=schema_name %>','<%=tbl_name  %>');" 
				onmouseover="this.style.backgroundColor='#F0EDC3'" onmouseout="this.style.backgroundColor=''" >
				<img src="/<%= config.getServletContext().getServletContextName() %>/images/table.png">&nbsp;<%=tbl_name%>
					</td>
				</tr>
				<%			}
				Statement procedursstmt=con.createStatement();//for getting  procedures info	
				String procedureQuery = "SHOW PROCEDURE STATUS where db='"+schema_name+"'";
				proceduresRS = procedursstmt.executeQuery(procedureQuery);//for stored procedures
					}
					
				try{
					String proc_name;
					String columnReturnTypeName;
					while (proceduresRS.next()){
						proc_name = proceduresRS.getString("name");
						boolean valid_proc = true;
					
						DatabaseMetaData dbMetaData = con.getMetaData();
						ResultSet procColRS = dbMetaData.getProcedureColumns(null,null,schema_name+"."+proc_name,"%");
						Object columnName = null;
						
						while(procColRS.next()) {
						    // get stored procedure metadata
						    try{
							    columnName  = procColRS.getObject("COLUMN_NAME");
							    columnReturnTypeName = procColRS.getString("TYPE_NAME");
						    } catch(Exception e){
						    	//com.mpp.Log.error(765, "", "", "", "Error getting mata-data for MySQL tables/procedures SQL Query portlet. "+e.toString());
						    	valid_proc = false;
						    	break;
						    }
						    
						 
						if (valid_proc == true){
				%>
				<tr>
					<td class="<%= schema_name %>" style="display:none; padding-left:17px;" onClick="<portlet:namespace />_getProc('<%=schema_name %>','<%=proc_name  %>');" 
				onmouseover="this.style.backgroundColor='#F0EDC3'" onmouseout="this.style.backgroundColor=''" >
				<img src="/<%= config.getServletContext().getServletContextName() %>/images/procedure.png">&nbsp;<%=proc_name%>
					</td>
				</tr>
				<tr>
				<%				
				procColRS.beforeFirst();
				while(procColRS.next()) {
				    // get stored procedure metadata
				    columnName  = procColRS.getObject("COLUMN_NAME");
				    columnReturnTypeName = procColRS.getString("TYPE_NAME");
				%>
				<td class="<%= schema_name %>" style="display:none; padding-left:20px;">
				<img src="/<%= config.getServletContext().getServletContextName() %>/images/procparam.png">&nbsp;<%=columnName%>:&nbsp;<%=columnReturnTypeName%>
					</td>
				</tr>
				<%		
									} 
								}
							}	
				
						}
						}catch(Exception e){
							//com.mpp.Log.error(765, "", "", "", "Error in SQL Query Portlet "+e.toString());
							success = false;
							errorMessage = e.getMessage();
						}
					}	         
				}catch(Exception e){
					e.printStackTrace();
					//com.mpp.Log.error(765, "", "", "", "Error in SQL Query Portlet "+e.toString());
					
				}finally{
					try{
					con = null;
					dbconSession.close();//closing session.
					}catch(Exception ex){}
				}
				//alert the actual error message
				if (success == false){
					StringTokenizer st = new StringTokenizer(errorMessage,".");
					while(st.hasMoreTokens()){
						errorMessage = st.nextToken();
						break;
					}
				%>
				<script type="text/javascript">
				alert('<%=errorMessage %>');
				</script>
						<%				
				}
				%>		
			</table>
		</div>
	</div>
		<div class="right-sec">
			<p class="heading">Query</p>
			<div class="query">
				<div class="query-box">
					<textarea name="query" style= "width:98%;" id="<portlet:namespace/>_query"/></textarea>
				</div>
				<div class="query-btn">
					<input type="button" value='<liferay-ui:message key="execute" />' name="execute" id="<portlet:namespace/>ExecuteQuery"/>
				</div>
			</div>
			<p class="heading">Result</p>
			<div class="result">
				<div id="<portlet:namespace/>veiwQuery"></div>
			</div>
		</div>
	</div>
<script type="text/javascript">
	jQuery(document).ready(function() {	
		path_to_animated_gif = "/<%=config.getServletContext().getServletContextName() %>/images/ajax-loader.gif";
		jQuery("#" + "<portlet:namespace/>ExecuteQuery").click(function(event){
			event.preventDefault();
			//var query = jQuery('#' + '<portlet:namespace/>_query').attr("value");
			var queryEle = jQuery('#<portlet:namespace/>_query');
			var query = queryEle.val();
			if(query ==	""){
				alert("enter-a-valid-sql-query" );
			}else if (query.indexOf(".") < 0){
				alert("No Database selected, Please select schema" );
			}else{
				var url = '<portlet:actionURL windowState="<%= LiferayWindowState.EXCLUSIVE.toString() %>" />';
				url += '&<portlet:namespace/>query='+ encodeURIComponent (query);
				url += '&<portlet:namespace/>action=' + 'Execute';
				url += '&<portlet:namespace/>timestamp=' + new Date().getTime();
				divToUpdate = jQuery("#" + "<portlet:namespace/>veiwQuery");
				divToUpdate.html('<div style="text-align:center;"><img src="' + path_to_animated_gif + '" /></div>');
				divToUpdate.load(url);
			}
		});
	});
	
	function <portlet:namespace />_getQuery(schema , tablename) {
				
		var query = 'select * from '+schema+ '.'+tablename+' LIMIT 0,1000';
		jQuery('#' + '<portlet:namespace/>_query').val(query);	

	}
	function <portlet:namespace />_getProc(schema , procedurename) {
		var query = 'CALL '+schema+ '.'+procedurename+' ()';
		jQuery('#' + '<portlet:namespace/>_query').val(query);		
	}
	function toggleTableDisplay(schema_name, status){		
		var imgUp = "/<%= config.getServletContext().getServletContextName() %>/images/right.png";
		var imgDown = "/<%= config.getServletContext().getServletContextName() %>/images/down.png";
		
		jQuery("." + schema_name).toggle();

		var img = document.getElementById('arrow_'+ schema_name);
		if(status == 1) {			
			img.onclick = function(){ toggleTableDisplay(schema_name, 0) };
			img.setAttribute("src", imgDown);
		} else {
			img.onclick = function(){ toggleTableDisplay(schema_name, 1) };
			img.setAttribute("src", imgUp);
		}		
	}
</script>

  