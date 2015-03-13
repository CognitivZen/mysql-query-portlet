package com.rknowsys.mysql.portlet;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
	
	public static SessionFactory getSessionFactory(){
		Configuration cfg=null;
		SessionFactory factory=null;
		try{
			cfg=new Configuration();
			cfg.configure("hibernate.cfg.xml");
			factory=cfg.buildSessionFactory();
			}
		catch(Exception e){
			e.printStackTrace();
		}
		return factory;
	}
}
