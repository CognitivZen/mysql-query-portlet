package com.rknowsys.mysql.portlet;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;

import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.util.Constants;
public class MySqlQueryPortletConfigurationAction extends DefaultConfigurationAction{
	
	@Override
	public void processAction(PortletConfig portletConfig,
            ActionRequest actionRequest, ActionResponse actionResponse)
            throws Exception {
		
		super.processAction(portletConfig, actionRequest, actionResponse);
		String test=actionRequest.getParameter(Constants.CMD);
		System.out.println("Db pref="+test);
		PortletPreferences prefs=actionRequest.getPreferences();
		
        String show_addrs=prefs.getValue("SelectUserOperation", "true");
        HibernateConnectionUtil hbc=new HibernateConnectionUtil();
        if(test.equals("DBCONFIG")){
        	hbc.getPreferencesValues(actionRequest);
        }
        //String show_addrs2=prefs.getValue("UpdateUserOperation", "true");
        System.out.println("showLocationAddress=" + show_addrs +
                " in ConfigurationActionImpl.processAction().");

    }
}
