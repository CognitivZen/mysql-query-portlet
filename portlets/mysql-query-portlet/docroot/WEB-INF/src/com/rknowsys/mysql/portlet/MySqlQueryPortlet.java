/**
 * Copyright (c) 2000-2007 Liferay, Inc. All rights reserved.
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

package com.rknowsys.mysql.portlet;


import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

import com.liferay.portal.kernel.util.ParamUtil;

public class MySqlQueryPortlet extends GenericPortlet {
// Kindly do not delete below line as it is being used for svn version maintenance
public static final String svnRevision =  "$Id: JSPPortlet.java 3160 2012-07-21 07:47:53Z ajit $";
	private static final String EXECUTE = "Execute";
	public void init() throws PortletException {
		editJSP = getInitParameter("edit-jsp");
		helpJSP = getInitParameter("help-jsp");
		viewJSP = getInitParameter("view-jsp");
	}

	public void doDispatch(RenderRequest req, RenderResponse res)
		throws IOException, PortletException {

		String jspPage = req.getParameter("jspPage");

		System.out.println("in doDispatch");
		if (jspPage != null) {
			include(jspPage, req, res);
		}
		else {
			super.doDispatch(req, res);
		}
	}

	public void doEdit(RenderRequest req, RenderResponse res)
		throws IOException, PortletException {

		if (req.getPreferences() == null) {
			super.doEdit(req, res);
		}
		else {
			include(editJSP, req, res);
		}
	}

	public void doHelp(RenderRequest req, RenderResponse res)
		throws IOException, PortletException {

		include(helpJSP, req, res);
	}

	public void doView(RenderRequest req, RenderResponse res)
		throws IOException, PortletException {
		if (ParamUtil.getString(req, "action").equals("Query")) {
			include("/query.jsp", req, res);
		}else	
		include(viewJSP, req, res);
	}

	public void processAction(ActionRequest req, ActionResponse res)
		throws IOException, PortletException {
				
		//PortletSession session = req.getPortletSession();
		/*UserInformation ui = (UserInformation) session.getAttribute("uinfo", PortletSession.APPLICATION_SCOPE);
		if (ui == null) {
			ui = DataSource.getUserInformation(Integer.parseInt(req.getRemoteUser()));
			session.setAttribute("uinfo", ui, PortletSession.APPLICATION_SCOPE);
		}*/
		String s = req.getParameter("action");

		if (ParamUtil.getString(req, "action").equalsIgnoreCase(EXECUTE)) {
			String query = ParamUtil.getString(req, "query");
			req.setAttribute("query", query);
			res.setRenderParameter("action", "Query");
		}
	}

	protected void include(String path, RenderRequest req, RenderResponse res)
		throws IOException, PortletException {

		PortletRequestDispatcher prd =
			getPortletContext().getRequestDispatcher(path);

		if (prd == null) {
			_log.error(path + " is not a valid include");
		}
		else {
			prd.include(req, res);
		}
	}

	protected String editJSP;
	protected String helpJSP;
	protected String viewJSP;

	private static Log _log = LogFactoryUtil.getLog(MySqlQueryPortlet.class);

}