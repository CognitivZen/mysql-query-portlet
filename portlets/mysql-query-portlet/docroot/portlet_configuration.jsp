<%@page import="com.liferay.portal.service.GroupLocalService"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@include file="init.jsp" %>

<liferay-ui:success key="potlet-config-saved-dsjfkdsjfsjk" message="Portlet Configuration have been successfully saved" />
<liferay-portlet:actionURL var="configurationActionURL" portletConfiguration="true"/>
<%
String showLocationAddress_cfg = GetterUtil.getString(portletPreferences.getValue("SelectUserOperation", StringPool.TRUE));
//boolean showLocationAddress_cfg2=GetterUtil.getBoolean(portletPreferences.getValue("showLocationAddress2", StringPool.TRUE));
%>
<label class="headlabel">Select User Operation</label>

<aui:form action="<%=configurationActionURL%>" method="post" name="configurationForm">

	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input id="123" name="preferences--SelectUserOperation--" inlineLabel="right" type="radio" label="Select" value="Select" 
	checked='<%=showLocationAddress_cfg.equals("Select") %>'></aui:input>
	<aui:input  id="xyz" inlineLabel="right" name="preferences--SelectUserOperation--" type="radio" label="Update" value="Update"
	checked='<%=showLocationAddress_cfg.equals("Update") %>'></aui:input>
	<aui:button type="submit" name="Save Configuration" value="Save Configuration"></aui:button>
</aui:form>
