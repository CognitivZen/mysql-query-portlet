<%@page import="com.liferay.portal.service.GroupLocalService"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@include file="init.jsp" %>

<liferay-ui:success key="potlet-config-saved-dsjfkdsjfsjk" message="Portlet Configuration have been successfully saved" />

<liferay-portlet:actionURL var="configurationActionDB" portletConfiguration="true">
	<liferay-portlet:param name="<%=Constants.CMD %>" value='<%="DBCONFIG" %>'></liferay-portlet:param>
</liferay-portlet:actionURL>

<liferay-portlet:actionURL var="configurationActionURL" portletConfiguration="true"/>

<aui:form action="<%= configurationActionDB  %>" method="post" class="form-horizontal">
	<aui:fieldset label="Database Settings">
  	  <aui:layout>
  	   <table style="margin-left:20px;width:100px;">
				<tr><td><label>JDBC Url</label></td><td><aui:input type="text" name="jdbc_url" label="" placeholder="jdbc:mysql://localhost:3306/lportal"/></td></tr>
				<tr><td><label>UserName</label></td><td><aui:input type="text" name="uname" label=""/></td></tr>
				<tr><td><label>Password</label></td><td><aui:input type="password" name="pwd" label=""/></td></tr>
				<tr><td></td><td><aui:button type="submit" value="Save DB Details" name="saveDetails"/></td></tr>
	  </table>
	 </aui:layout>
	</aui:fieldset>
</aui:form>
<%
String showLocationAddress_cfg = GetterUtil.getString(portletPreferences.getValue("SelectUserOperation", StringPool.TRUE));
//boolean showLocationAddress_cfg2=GetterUtil.getBoolean(portletPreferences.getValue("showLocationAddress2", StringPool.TRUE));
%>

<aui:form action="<%=configurationActionURL%>" method="post" name="configurationForm">
  <aui:fieldset label="Permissions">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input style="margin-left:15px;" id="123" name="preferences--SelectUserOperation--" inlineLabel="right" type="radio" label="Allow only select statements" value="Select" 
	checked='<%=showLocationAddress_cfg.equals("Select") %>'></aui:input>
	<aui:input style="margin-left:15px;" id="xyz" inlineLabel="right" name="preferences--SelectUserOperation--" type="radio" label="Allow both select and update statements" value="Update"
	checked='<%=showLocationAddress_cfg.equals("Update") %>'></aui:input><br>
	<aui:button style="margin-left:35px;" type="submit" name="Save Configuration" value="Save Configuration"></aui:button>
  </aui:fieldset>
</aui:form>
