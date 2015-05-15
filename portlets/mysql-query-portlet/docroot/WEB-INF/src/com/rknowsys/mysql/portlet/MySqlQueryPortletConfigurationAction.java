/**
 * This class is used to set the Preferences for DBDetailsForm and PermissionForm and setup the Configuration
 */

package com.rknowsys.mysql.portlet;
import java.sql.Connection;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.Constants;
public class MySqlQueryPortletConfigurationAction extends DefaultConfigurationAction{
	
	@SuppressWarnings("deprecation")
	@Override
	public void processAction(PortletConfig portletConfig,
            ActionRequest actionRequest, ActionResponse actionResponse)
            throws Exception{
		
		super.processAction(portletConfig, actionRequest, actionResponse);
		
		String test=actionRequest.getParameter(Constants.CMD);
		System.out.println("Db pref="+test);
		PortletPreferences preferences=actionRequest.getPreferences();
		
		System.out.println("jdbc url from MSQPC= "+preferences.getValue("jdbc_url", ""));
        String show_addrs=preferences.getValue("SelectUserOperation", "Select");
        Connection con=null;
        if(test.equals("DBCONFIG")){
        	 preferences = actionRequest.getPreferences();
     		String jdbcURL=actionRequest.getParameter("jdbc_url");
    		String userName=actionRequest.getParameter("uname");
    		String password=actionRequest.getParameter("pwd");	

    		preferences.setValue("jdbc_url", jdbcURL);
    		preferences.setValue("uname", userName);
    		preferences.setValue("pwd", password);
    		preferences.store();
        	System.out.println("JDBC URL from preference obj: "+preferences.getValue("jdbc_url", ""));
        	
			HibernateConnectionUtil.getPreferencesValues(jdbcURL,userName,password);
        	try
        	{	
        		Session dbconSession=null;
        		SessionFactory factory=HibernateConnectionUtil.getSessionFactory();
        		dbconSession=factory.openSession();
        		System.out.println("dbsession is "+dbconSession);
        		con = dbconSession.connection();
        		System.out.println("connection is "+con);
      
        		//con.createStatement();
        		//con.commit();
        	}
        	catch(Exception ex){
        		SessionMessages.add(actionRequest, "formFail");
        	}
        }
        //String show_addrs2=prefs.getValue("UpdateUserOperation", "true");
        System.out.println("showLocationAddress=" + show_addrs +
                " in ConfigurationActionImpl.processAction().");
        if(con!=null){
        	SessionMessages.add(actionRequest, "formSubmit");
        }
    }
}
