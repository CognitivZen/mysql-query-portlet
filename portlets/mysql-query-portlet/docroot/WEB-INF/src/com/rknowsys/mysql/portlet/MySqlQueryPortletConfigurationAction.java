package com.rknowsys.mysql.portlet;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;

import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
public class MySqlQueryPortletConfigurationAction extends DefaultConfigurationAction{
	
	@Override
	public void processAction(PortletConfig portletConfig,
            ActionRequest actionRequest, ActionResponse actionResponse)
            throws Exception {
		
		super.processAction(portletConfig, actionRequest, actionResponse);
		
		PortletPreferences prefs=actionRequest.getPreferences();
		
		
        /*String select = ParamUtil.getString(actionRequest, "SelectUserOperation");
        String portletResource = ParamUtil.getString(actionRequest,"portletResource");
        System.out.println("select"+select);
        PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);
        preferences.setValue("select", select);*/
        String show_addrs=prefs.getValue("SelectUserOperation", "true");
        //String show_addrs2=prefs.getValue("UpdateUserOperation", "true");
        System.out.println("showLocationAddress=" + show_addrs +
                " in ConfigurationActionImpl.processAction().");

       
    }
}
