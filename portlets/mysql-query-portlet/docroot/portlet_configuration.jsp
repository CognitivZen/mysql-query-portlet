<!-- This jsp is creating DBDetailsForm and Provides Permissions for select and update queries -->

<%@page import="com.liferay.portal.service.GroupLocalService"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionMessages"%>
<%@include file="init.jsp" %>
<% 
if(SessionMessages.contains(renderRequest.getPortletSession(),"formFail")){%>
	<p><liferay-ui:success key="formFail" message="Enter Valid UserName & password " /></p>
<%} 
else{
%>
	<p><liferay-ui:success key="formSubmit" message="Database Settings Saved Sucessfully" /></p>
<%} 
%>

<liferay-portlet:actionURL var="configurationActionDB" portletConfiguration="true">
	<liferay-portlet:param name="<%=Constants.CMD %>" value='<%="DBCONFIG" %>'></liferay-portlet:param>
</liferay-portlet:actionURL>

<liferay-portlet:actionURL var="configurationActionURL" portletConfiguration="true"/>


<aui:form action="<%=configurationActionDB%>" method="post" class="form-horizontal">
	<aui:fieldset label="Database Settings">
  	  <aui:layout>
  	   <table style="margin-left:20px;width:100px;" class="table table-condensed">
				<tr><td><label>JDBC Url</label></td><td><aui:input type="text" name="jdbc_url" label="" placeholder="enter url">
					<aui:validator name="required"></aui:validator>
				</aui:input></td></tr>
				<tr><td><label>UserName</label></td><td><aui:input type="text" name="uname" label="" placeholder="enter user name">
				
				<aui:validator name="required"></aui:validator></aui:input></td></tr>
						
				<tr><td><label>Password</label></td><td><aui:input type="password" name="pwd" label="" placeholder="enter password">
				
				<aui:validator name="required"></aui:validator></aui:input></td></tr>
				
				<tr><td></td><td><aui:button type="submit" value="Save DB Details" name="saveDetails"/></td></tr>
	  </table>
	 </aui:layout>
	</aui:fieldset>
</aui:form>
<%
String showLocationAddress_cfg = GetterUtil.getString(portletPreferences.getValue("SelectUserOperation", StringPool.TRUE));
%>

<aui:form action="<%=configurationActionURL%>" method="post" name="configurationForm">
  <aui:fieldset label="Permissions">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input style="margin-left:15px;" id="abc" name="preferences--SelectUserOperation--" inlineLabel="right" type="radio" label="Allow only select statements" value="Select" checked="true"></aui:input>
	<aui:input style="margin-left:15px;" id="xyz" inlineLabel="right" name="preferences--SelectUserOperation--" type="radio" label="Allow both select and update statements" value="Update"
	checked='<%=showLocationAddress_cfg.equals("Update") %>'>
	</aui:input><br>
	<aui:button style="margin-left:35px;" type="submit" name="Save Configuration" value="Save Configuration"></aui:button>
  </aui:fieldset>
</aui:form>
