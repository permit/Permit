/***********************************************************************
$Rev:: 396                       $:  Revision of last commit
$Author:: cohend                 $:  Author of last commit
$Date:: 2007-03-19 13:14:17 -040#$:  Date of last commit
***********************************************************************/
/*
 * mitidclient.java
 * 
 *  Copyright (C) 2006-2010 Massachusetts Institute of Technology
 *  For contact and other information see: http://mit.edu/permit/
 *
 *  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
 *  Public License as published by the Free Software Foundation; either version 2 of the License.
 *
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
 *  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
 *  License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with this program; if not, write 
 *  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Created on August 7, 2006, 12:47 PM
 * Author: cohend
 * 
  */

package edu.mit.isda.permitws;

import java.io.*;
import permitService_pkg.*;
import permitService_pkg.PermitAuthorization;
import javax.servlet.http.*;
import java.security.cert.X509Certificate;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.net.URLDecoder;
import permitService_pkg.PermitException;

public class permitclient {

    private String UserName;
    private String PName;
    private String Catagory;
    private String Category;
    private String Function;
    private String Qualifier;
    private boolean bwillExpand;
    private boolean bisActive;
    private static Properties configProperties =  null;
    
    private final static  String CONFIG_PROPERTY_FILE =  "config.properties";
    private final static  String PERMIT_SERVICE_URL =  "https://%1$s/permitws/services/permit";
 
    private static final Log log = LogFactory.getLog(permitclient.class);

    private static final String KEY_STORE_FILE = "KeyStore.File";
    private static final String KEY_STORE_PASS = "KeyStore.Password";
    private static final String TRUST_STORE_FILE = "TrustStore.File";
    private static final String TRUST_STORE_PASS = "TrustStore.Password";
  
    private static final String JAVA_KEY_STORE_FILE_PROP = "javax.net.ssl.keyStore";
    private static final String JAVA_KEY_STORE_PASS_PROP = "javax.net.ssl.keyStorePassword";
    private static final String JAVA_TRUST_STORE_FILE_PROP = "javax.net.ssl.trustStore";
    private static final String JAVA_TRUST_STORE_PASS_PROP = "javax.net.ssl.trustStorePassword";
    
  
 
    public permitclient()
    {
    }
    
    public String getpermitserviceURL() throws IOException
    {
        Properties prop = getConfigProperties();
        String server = prop.getProperty("server");
        return java.lang.String.format(PERMIT_SERVICE_URL, server);
    }
    
    private String getUserInput(HttpServletRequest request)
    {

        UserName = request.getParameter("username");
        PName = request.getParameter("proxyname");
        Catagory = request.getParameter("catagory");
         Category = request.getParameter("category");
       Function = request.getParameter("function");
        Qualifier = request.getParameter("qualifier");
        String willExpand = request.getParameter("willExpand");
        bwillExpand = false;
        if (willExpand != null)
        {
            if (willExpand.length() != 0)
            {
                if (willExpand.compareToIgnoreCase("yes") == 0)
                {
                    bwillExpand = true;
                }
            }
        }
        String isActive = request.getParameter("isActive");
        bisActive = true;
        if (isActive != null)
        {
            if (isActive.length() != 0)
            {
                if (isActive.compareToIgnoreCase("no") == 0)
                {
                    bisActive = false;
                }
            }
        }

        String sName = getRemoteUser(request);
        X509Certificate[] certificate = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");
        
        // Check for Remote User. Enable for Touchstone
        if (null != sName)
        {
                    sName = sName.toUpperCase().trim();
                    int j = sName.indexOf('@');
                    if (j != -1)
                    {
                        if (sName.substring(j+1, j + 1 +"MIT.EDU".length()).equals("MIT.EDU"))
                        {
                             log.info("***** REMOTE_USER without Domain - " + sName.substring(0, j));
                            return(sName.substring(0, j));
                        }
 
                    }
        }
        // If no Touchstone .. look for certificate
        else if (certificate != null)
        {
            sName = certificate[0].getSubjectDN().getName();
            if (sName == null)
                return(PName);
            else
            {
                int i = sName.indexOf('=', 0);
                if (i != -1)
                {
                    ++i;
                    int j = sName.indexOf('@', i);
                    if (j != -1)
                    {
                        if (sName.substring(j+1, j + 1 +"MIT.EDU".length()).equals("MIT.EDU"))
                        {
                            return(sName.substring(i, j));
                        }
                    }
                }
            }
        }
        return(PName);
    }
    
    public String isUserAuthorized(HttpServletRequest request) 
    {
        boolean rResponse;
        StringBuffer sb = new StringBuffer();

        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
            java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.isUserAuthorized(UserName, Catagory, Function, Qualifier, ProxyName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return(sb.toString());
        }
        sb.append("<BR>\r\n");
        sb.append("User&nbsp;" + UserName + " is ");
        if (rResponse == false)
            sb.append("NOT AUTHORIZED for:");
        else
            sb.append("AUTHORIZED for:");
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Category:&nbsp&nbsp" + Catagory);
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Function:&nbsp&nbsp" + Function);
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Qualifier:&nbsp&nbsp" + Qualifier);
        sb.append("<BR>\r\n");
        return(sb.toString());
    }
    
    
    public String isUserAuthorizedExt(HttpServletRequest request) 
    {
        boolean rResponse;
        StringBuffer sb = new StringBuffer();

        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
            java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);

            rResponse = service.isUserAuthorizedExt(UserName, Catagory, Function, Qualifier, ProxyName, null);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return(sb.toString());
        }
        sb.append("<BR>\r\n");
        sb.append("User&nbsp;" + UserName + " is ");
        if (rResponse == false)
            sb.append("NOT AUTHORIZED for:");
        else
            sb.append("AUTHORIZED for:");
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Category:&nbsp&nbsp" + Catagory);
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Function:&nbsp&nbsp" + Function);
        sb.append("<BR>\r\n");
        sb.append("&nbsp;&nbsp;Qualifier:&nbsp&nbsp" + Qualifier);
        sb.append("<BR>\r\n");
        return(sb.toString());
    }    

    public boolean checkAuthorization(HttpServletRequest request) 
    {
        boolean rResponse;
        StringBuffer sb = new StringBuffer();

        String sName = getSName(request);
        if (null == sName) {
            sName = "";
        }

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return false;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
           Permit service = sl.getpermit(endpoint);

            rResponse = service.isUserAuthorized(sName, "META", "CREATE AUTHORIZATIONS", (String)request.getParameter("qualifier_code"), sName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return(false);
        }

        return(rResponse);
    }    
    
    public String listAuthorizationsByPerson(HttpServletRequest request) {
        
        PermitAuthorization rResponse[] = null;
        StringBuffer sb = new StringBuffer();

        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
           Permit service = sl.getpermit(endpoint);
           rResponse = service.listAuthorizationsByPerson(UserName, Catagory, bisActive, bwillExpand, ProxyName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return(sb.toString());
        }

        if (rResponse != null)
        {
             for (int i = 0; i < rResponse.length; i++)
            {
                sb.append("<BR>\r\n");
                sb.append("Name:&nbsp;&nbsp;" + rResponse[i].getName());
                sb.append("<BR>\r\n");
                sb.append("&nbsp&nbspCategory:&nbsp;&nbsp;" + rResponse[i].getCategory());
                sb.append("<BR>\r\n");
                sb.append("&nbsp&nbspQualifier:&nbsp;&nbsp;" + rResponse[i].getQualifier());
                sb.append("<BR>\r\n");
                sb.append("&nbsp&nbspQualifierCode:&nbsp;&nbsp;" + rResponse[i].getQualifierCode());
                sb.append("<BR>\r\n");
                sb.append("&nbsp&nbspFunction:&nbsp;&nbsp;" + rResponse[i].getFunction());
                sb.append("<BR>\r\n");
            }
        }
        return(sb.toString());
    }

    public String createAuthorization(HttpServletRequest request) {
        
        PermitAuthorization rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        String ret = new String();
        String rval = null;
        
        if (null == sName) {
            sName = "";
        }
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rval = service.createAuthorization(sName, (String)request.getParameter("function_name"), (String)request.getParameter("qualifier_code"), 
                                                       (String)request.getParameter("kerberos_name"), (String)request.getParameter("effective_date"), 
                                                       (String)request.getParameter("expiration_date"), (String)request.getParameter("do_function"),
                                                       (String)request.getParameter("grant_auth"));
        }
        catch(Exception e) {
            sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
            ret = sb.toString();
            if (ret.indexOf("ORA-") != -1) {
                ret = ret.substring(ret.indexOf("ORA-") + 10, ret.indexOf("\n", ret.indexOf("ORA-")));
            }
            return(ret);            
        }

        sb.append(rval);
        return(sb.toString());
    }

    public String updateAuthorization(HttpServletRequest request) {
        
        PermitAuthorization rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        String ret = new String();
        if (null == sName) {
            sName = "";
        }
        boolean rval;

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rval = service.updateAuthorization(sName, (String)request.getParameter("auth_id"), 
                                                       (String)request.getParameter("function_name"), (String)request.getParameter("qualifier_code"), 
                                                       (String)request.getParameter("kerberos_name"), (String)request.getParameter("effective_date"), 
                                                       (String)request.getParameter("expiration_date"), (String)request.getParameter("do_function"),
                                                       (String)request.getParameter("grant_auth"));
            //System.out.println("Return value = " + rval);
        }
        catch(Exception e) {
            sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
            ret = sb.toString();
            if (ret.indexOf("ORA-") != -1) {
                ret = ret.substring(ret.indexOf("ORA-") + 10, ret.indexOf("\n", ret.indexOf("ORA-")));
            }
            return(ret);            
        }

        sb.append(rval);
        
        return(sb.toString());
    }    
    
    public String deleteAuthorization(HttpServletRequest request) {
        
        PermitAuthorization rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        String ret = new String();
        if (null == sName) {
            sName = "";
        }
        boolean rval;

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return("Cannot find Certificate keystore.");
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rval = service.deleteAuthorization(sName, (String)request.getParameter("auth_id"));
            //System.out.println("Return value = " + rval);
        }
        catch(Exception e) {
            sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
            ret = sb.toString();
            if (ret.indexOf("ORA-") != -1) {
                ret = ret.substring(ret.indexOf("ORA-") + 10, ret.indexOf("\n", ret.indexOf("ORA-")));
            }
            return(ret);            
        }

        sb.append(rval);
        
        return(sb.toString());
    }        

    public PermitAuthorizationExt[] listAuthorizationsRaw(HttpServletRequest request) {
        
        PermitAuthorizationExt rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.listAuthorizationsByPersonExt(UserName, Catagory, bisActive, bwillExpand, sName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        return rResponse;
    }    
    
    public String listAuthorizationsExtXML(HttpServletRequest request) {
        String xml = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            //xml = service.listAuthorizationsByPersonXML(UserName, Catagory, bisActive, bwillExpand, sName);
            //xml = service.listAuthByPersonExtend1(UserName, Catagory, bisActive, bwillExpand, sName);
            xml = service.listAuthByPersonExtend1XML(UserName, Catagory, bisActive, bwillExpand, sName, null,
                                          null, null, null, null, null, null, null, null, null);
            //System.out.println("XML = " + xml);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        return xml;        
    }
    
    public String listAuthorizationsXML(HttpServletRequest request) {
        
        String xml = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            //xml = service.listAuthorizationsByPersonXML(UserName, Catagory, bisActive, bwillExpand, sName);
            xml = service.listAuthorizationsByPersonRawXML(UserName, Catagory, bisActive, bwillExpand, sName);
            //System.out.println("XML = " + xml);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        return xml;
    }        

     public String listAuthorizationsByCriteria(HttpServletRequest request) {
        
        String json = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);
        String crit_list = (String)request.getParameter("critString");
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)  
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            json = service.listAuthorizationsByCriteria(ProxyName, crit_list);
        }
        catch (PermitException re) {
                log.info(re.getLocalizedMessage());
                return "ERROR: " + re.getMessage();
        }        
        catch(Exception e)
        {
                sb.append(e.getMessage());      
                  log.info(e.getLocalizedMessage());
              if (e.getMessage().indexOf("ORA-00933") >= 0) {
                    return "Please select at least one criteria.";
                }
                else if (e.getMessage().indexOf("ORA-00936") >= 0) {
                    return "Not authorized to view these authorizations.";
                }
                else if (e.getMessage().indexOf("ORA-20005") >= 0) {
                    return "User is not authorized to look up authorizations in this category.";
                }                
                else {
                    return e.getMessage();
                }
        }
  try
        {
            return URLDecoder.decode(json, "UTF-8");
        }
        catch(Exception e)
        {
                log.info(e.getLocalizedMessage());
          return null;  
        }
    }      
    public String checkAuthEditPermissions(HttpServletRequest request) {
        
        String canCreate = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String proxyName = getUserInput(request);
        String function = (String)request.getParameter("function");
        String qualifierCode = (String)request.getParameter("qualifierCode");
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)  
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            canCreate  = service.checkAuthEditPermissions(proxyName, function, qualifierCode);
        }
        catch (PermitException re) {
                log.info(re.getLocalizedMessage());
                return "ERROR: " + re.getMessage();
        }        
        catch(Exception e)
        {
                sb.append(e.getMessage());      
                log.info(e.getLocalizedMessage());
                if (e.getMessage().indexOf("ORA-00933") >= 0) {
                    return "Please select at least one criteria.";
                }
                else if (e.getMessage().indexOf("ORA-00936") >= 0) {
                    return "Not authorized to view these authorizations.";
                }
                else if (e.getMessage().indexOf("ORA-20005") >= 0) {
                    return "User is not authorized to look up authorizations in this category.";
                }                
                else {
                    return e.getMessage();
                }
        }
        return canCreate;
    }    
    
    public String getEditableAuthorizationById(HttpServletRequest request) {
        
        String json = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);
        String authId = (String)request.getParameter("authId");
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)  
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            json = service.listEditableAuthorizationByAuthId(authId,ProxyName);
        }
        catch (PermitException re) {
                log.info(re.getLocalizedMessage());
                return "ERROR: " + re.getMessage();
        }        
        catch(Exception e)
        {
                sb.append(e.getMessage());      
                log.info(e.getLocalizedMessage());
                if (e.getMessage().indexOf("ORA-00933") >= 0) {
                    return "Please select at least one criteria.";
                }
                else if (e.getMessage().indexOf("ORA-00936") >= 0) {
                    return "Not authorized to view these authorizations.";
                }
                else if (e.getMessage().indexOf("ORA-20005") >= 0) {
                    return "User is not authorized to look up authorizations in this category.";
                }                
                else {
                    return e.getMessage();
                }
        }
   try
        {
            return URLDecoder.decode(json, "UTF-8");
        }
        catch(Exception e)
        {
          return null;  
        }
    }  
    
    public String getCriteriaSet(HttpServletRequest request) {
        
        String xml = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            xml = service.getCriteriaSet((String)request.getParameter("selectionID"), sName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        try
        {
            return URLDecoder.decode(xml, "UTF-8");
        }
        catch(Exception e)
        {
          return null;  
        }
    }        
    
    public String listPersonRaw(HttpServletRequest request) {
        
        String xml = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);
        String name = (String)request.getParameter("q").toUpperCase();
        String search = (String)request.getParameter("search").toLowerCase();
        String sort = (String)request.getParameter("sort").toLowerCase();
        String filter1 = (String)request.getParameter("filter1");
        String filter2 = (String)request.getParameter("filter2");
        String filter3 = (String)request.getParameter("filter3");
        name += "%";
        //System.out.println(name);
        //System.out.println(search);
        //System.out.println(sort);
        //System.out.println(filter1);
        //System.out.println(filter2);
        //System.out.println(filter3);
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            xml = service.listPersonRaw(sName, name, search, sort, filter1, filter2, filter3);
       }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
      try
        {
            return URLDecoder.decode(xml, "UTF-8");
        }
        catch(Exception e)
        {
          return null;  
        }
    }        
    
    public String listPersonJSON(HttpServletRequest request) {
        
        String xml = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);
        sName = sName.toUpperCase();
        String ProxyName = getUserInput(request);
        String name = (String)request.getParameter("q").toUpperCase();
        String search = (String)request.getParameter("search").toLowerCase();
        String sort = (String)request.getParameter("sort").toLowerCase();
        String filter1 = (String)request.getParameter("filter1");
        String filter2 = (String)request.getParameter("filter2");
        String filter3 = (String)request.getParameter("filter3");
        name += "%";
        //System.out.println(sName);
        //System.out.println(name);
        //System.out.println(search);
        //System.out.println(sort);
        //System.out.println(filter1);
        //System.out.println(filter2);
        //System.out.println(filter3);
        
        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            xml = service.listPersonJSON(sName, name, search, sort, filter1, filter2, filter3);
       }
        catch(Exception e)
        {
                 log.info(e.getLocalizedMessage());
               sb.append(e.getMessage());
                return null;
        }
      try
        {
            return URLDecoder.decode(xml, "UTF-8");
        }
        catch(Exception e)
        {
          return null;  
        }
    }            
    
    public PermitPickableCategory[] listPickableCategories(HttpServletRequest request) {
        
        PermitPickableCategory rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);    
        sName = sName.toUpperCase();
        //System.out.println("In listPickableCategories and sName = " + sName);

        String ProxyName = getUserInput(request);

        try
        {
            System.out.println("listPickableCategories");
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;

           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.listFunctionCategories(sName);
             System.out.println("listPickableCategories succeeded");
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                e.printStackTrace();
                 System.out.println(e.getLocalizedMessage());
                return null;
        }

        return rResponse;
    }    
        
    public PermitPickableFunction[] listPickableFunctionsByCategory(HttpServletRequest request) {
        
        PermitPickableFunction rResponse[] = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        sName = sName.toUpperCase();
        //System.out.println("In listPickableFunctionsByCategory and sName = " + sName);

        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.listPickableFunctionsByCategory(sName, Category);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        return rResponse;
    }    
            
    public String getQualifierXML(HttpServletRequest request) {
        
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);    
        sName = sName.toUpperCase();
        //System.out.println("In getQualifierXML and sName = " + sName);
 
        String ProxyName = getUserInput(request);
       String fillFunctionName = "fill_qual";
       if (request.getParameter("fill_function") != null && !((String)request.getParameter("fill_function")).equals(""))
       {
            fillFunctionName = (String) request.getParameter("fill_function");
       }
       String expandFunctionName = "expand_equals";
       if (request.getParameter("expand_function") != null && !((String)request.getParameter("expand_function")).equals(""))
       {
            expandFunctionName = (String) request.getParameter("expand_function");
       }

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            //System.out.print("Function = " + Function);
            rResponse = service.getQualifierXML(sName, Function, (String)request.getParameter("qtype"));
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        //System.out.println("Response = " + rResponse);
        String ret = converXMLToHTML(rResponse,fillFunctionName,expandFunctionName,(String)request.getParameter("qtype"));
        if (null == ret) {
            ret = "Invalid Response";
        }
//      try
//        {
//            return URLDecoder.decode(rResponse, "UTF-8");
//        }
//        catch(Exception e)
//        {
//          ret = "Invalid Response";  
//        }
        return ret;
    }  
  
    
 public String getQualifierXMLForCriteriaQuery(HttpServletRequest request) 
  {
        String rResponse;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String functionName = (String)request.getParameter("function_name");
        String category = (String)request.getParameter("category");
         String qualifierType = (String)request.getParameter("qualifier_type");
       
        
        try
        {
            functionName = URLDecoder.decode(functionName,"UTF-8");
            System.out.println("Function Name ="+functionName);
        }
        catch(Exception e)
        {
                log.info(e.getLocalizedMessage());
        }
       sName = sName.toUpperCase();
 
       String fillFunctionName = "fill_crit_qual";
       if (request.getParameter("fill_function") != null && !((String)request.getParameter("fill_function")).equals(""))
       {
            fillFunctionName = (String) request.getParameter("fill_function");
       }
       String expandFunctionName = "expand_crit_equals";
       if (request.getParameter("expand_function") != null && !((String)request.getParameter("expand_function")).equals(""))
       {
            expandFunctionName = (String) request.getParameter("expand_function");
       }
       try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
           Permit service = sl.getpermit(endpoint);
            
           if (null == qualifierType || "".equals(qualifierType.trim()))
           {
                qualifierType = service.getQualifierTypeForFunction(sName, category, functionName);
                 rResponse = service.getQualifierXMLForCriteriaQuery(sName, functionName, null);
           }
           else
           {
                 rResponse = service.getQualifierXMLForCriteriaQuery(sName, null, qualifierType);
               
           }
          
           
           sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                e.printStackTrace();
                return null;
        }
        String ret = converXMLToHTML(rResponse,fillFunctionName, expandFunctionName,qualifierType );
        if (null == ret) {
            ret = "Invalid Response";
        }
        return ret;
  }
    
    
            
    public String getFunctionDesc(HttpServletRequest request) {
         
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        sName = sName.toUpperCase();
        //System.out.println("In getQualifierTypeForFunction and sName = " + sName);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
             String ServiceName = sl.getpermitAddress();
          java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            if (SetKeystore(ServiceName) != 0)
                return null;
            rResponse = service.getFunctionDesc(sName,(String)request.getParameter("category"), 
                                                            (String)request.getParameter("function_name"));
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        //System.out.println("Response = " + rResponse);

        return rResponse;       
    }    
    
            
    public String getQualifierTypeForFunction(HttpServletRequest request) {
         
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        sName = sName.toUpperCase();
        //System.out.println("In getQualifierTypeForFunction and sName = " + sName);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
             String ServiceName = sl.getpermitAddress();
          java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            if (SetKeystore(ServiceName) != 0)
                return null;
            rResponse = service.getQualifierTypeForFunction(sName, 
                                                            (String)request.getParameter("category"), 
                                                            (String)request.getParameter("function_name"));
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        //System.out.println("Response = " + rResponse);

        return rResponse;       
    }    
    
    public String getQualifierRootXML(HttpServletRequest request) {
        
        String rResponse = null;
        StringBuffer sb = new StringBuffer();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.getQualifierRootXML((String)request.getParameter("root_id"), (String)request.getParameter("root"), 
                                                    (String)request.getParameter("qtype"));
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        //System.out.println("Response = " + rResponse);
       String fillFunctionName = "fill_qual";
       if (request.getParameter("fill_function") != null && !((String)request.getParameter("fill_function")).equals(""))
       {
            fillFunctionName = (String) request.getParameter("fill_function");
       }
       String expandFunctionName = "expand_equals";
       if (request.getParameter("expand_function") != null && !((String)request.getParameter("expand_function")).equals(""))
       {
            expandFunctionName = (String) request.getParameter("expand_function");
       }
        try
        {
            String ret = converXMLToHTML(rResponse,fillFunctionName,expandFunctionName,(String)request.getParameter("qtype"));
            if (ret !=null)
                return ret;
            else
                 return "Invalid Response";  
        }
        catch(Exception e)
        {
                log.info(e.getLocalizedMessage());
          return "Invalid Response";  
        }    
    }    
    
    public String listViewableCategories(HttpServletRequest request) {
        
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.listViewableCategories(sName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return rResponse;
    }     
    
    public String listViewableFunctionsByCategory(HttpServletRequest request) {
        
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        sName = sName.toUpperCase();

        String ProxyName = getUserInput(request);

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.listViewableFunctionsByCategory(Category);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }

        return rResponse;
    }        
    
    public String getSelectionList(HttpServletRequest request) {
        String rResponse = null;
        StringBuffer sb = new StringBuffer();
            String sName = getSName(request);  
            sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.getSelectionList(sName);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return rResponse;
    }
    
    public String batchCreate(HttpServletRequest request) {
        
        String rResponse = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String authIDs = (String)request.getParameter("ids");
        String kerberos_name = (String)request.getParameter("kerberos_name");
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.batchCreate(sName, kerberos_name, authIDs);
            sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return sb.toString();
    }    
    
    public String batchReplace(HttpServletRequest request) {
        
        String rResponse = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String authIDs = (String)request.getParameter("ids");
        String kerberos_name = (String)request.getParameter("kerberos_name");
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.batchReplace(sName, kerberos_name, authIDs);
            sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return sb.toString();
    }        
        
    public String batchDelete(HttpServletRequest request) {
        
        String rResponse;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String deleteIDs = (String)request.getParameter("ids");
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.batchDelete(sName, deleteIDs);
            sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return sb.toString();
    }      
    
    public String batchUpdate(HttpServletRequest request) {
        
        String rResponse = new String();
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String authIDs = (String)request.getParameter("ids");
        String effDate = (String)request.getParameter("effDate");
        String expDate = (String)request.getParameter("expDate");
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint  = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.batchUpdate(sName, authIDs, effDate, expDate);
            sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return sb.toString();
    }         

    public String saveCriteria(HttpServletRequest request) {
        
        String rResponse;
        StringBuffer sb = new StringBuffer();
        String sName = getSName(request);  
        String selectionId = (String)request.getParameter("selectionId");
        String criteriaList = (String)request.getParameter("criteriaList");
        String valueList = (String)request.getParameter("valueList");
        String applyList = (String)request.getParameter("applyList");
        sName = sName.toUpperCase();

        try
        {
            PermitServiceLocator sl = new PermitServiceLocator();
            String ServiceName = sl.getpermitAddress();
            if (SetKeystore(ServiceName) != 0)
                return null;
           java.net.URL endpoint = new java.net.URL(getpermitserviceURL());
            Permit service = sl.getpermit(endpoint);
            rResponse = service.saveCriteria(sName, selectionId, criteriaList, valueList, applyList);
            sb.append(rResponse);
        }
        catch(Exception e)
        {
                sb.append(e.getMessage());
                log.info(e.getLocalizedMessage());
                return null;
        }
        return sb.toString();
    }          
    
    
 
    private  Properties getConfigProperties() throws IOException
    {
        InputStream stream = null;
        Properties prop = new Properties();
        
 
       // String propertyFile = CONFIG_PROPERTY_FILE;
        
      //  String path = null;
 

        // Get the property as stream.
       // stream = this.getClass().getResourceAsStream(propertyFile );
    
        //load the stream to Property object.
        //prop.load(stream );
 
        String configProps = System.getenv("WSETCDIR") + File.separator + CONFIG_PROPERTY_FILE;
        if (null != configProps)
        {
            prop.load(new FileInputStream(configProps));
        }
        return prop;

    }
    
    private int SetKeystore(String ServiceName)
    {
        try
        {
            // Get the property as stream.
            if (configProperties == null)
            {
                configProperties =  getConfigProperties();
            }
            String keyStoreFile = configProperties.getProperty(KEY_STORE_FILE);
            String keyStorePass =configProperties.getProperty(KEY_STORE_PASS);
            String trustStoreFile = configProperties.getProperty(TRUST_STORE_FILE);
            String trustStorePass =configProperties.getProperty(TRUST_STORE_PASS);

            File fFile = new File(keyStoreFile);
            if (!fFile.exists())
            {
                System.out.println("Invalid KetStore File name " + keyStoreFile);
                return(1);
            }
            System.setProperty(JAVA_KEY_STORE_FILE_PROP, keyStoreFile); 
            System.setProperty(JAVA_KEY_STORE_PASS_PROP,keyStorePass);

            System.setProperty(JAVA_TRUST_STORE_FILE_PROP, trustStoreFile); 
            System.setProperty(JAVA_TRUST_STORE_PASS_PROP,trustStorePass);   

         }
        catch(Exception e)
        {
            e.printStackTrace();
        }        
        
 

        return(0);
    }
    
    /**
     * get Remote user
     * @param request
     * @return
     */
    protected String getRemoteUser(HttpServletRequest request)
    {
        String user = request.getRemoteUser();
        if (null == user)
        {
            user = (String) request.getAttribute("REMOTE_USER");
        }
        System.out.println("***** REMOTE_USER - " + user);
        return user;
        
    }
    public String getSName(HttpServletRequest request) {
        
        String sName = getRemoteUser(request);
        X509Certificate[] certificate = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");
        if (null != sName)
        {
                    sName = sName.trim().toUpperCase();
                    int j = sName.indexOf('@');
                    if (j != -1)
                    {
                        if (sName.substring(j+1, j + 1 +"MIT.EDU".length()).equals("MIT.EDU"))
                        {
                             System.out.println("***** REMOTE_USER without Domain - " + sName.substring(0, j));
                            return(sName.substring(0, j));
                        }
 
                    }
            
        }
        else if (certificate != null)
        {
            sName = certificate[0].getSubjectDN().getName();
            if (sName == null)
                return(null);
            else
            {
                sName = sName.trim().toUpperCase();
                int i = sName.indexOf('=', 0);
                if (i != -1)
                {
                    ++i;
                    int j = sName.indexOf('@', i);
                    if (j != -1)
                    {
                        if (sName.substring(j+1, j + 1 +"MIT.EDU".length()).equals("MIT.EDU"))
                        {
                            return(sName.substring(i, j));
                        }
                    }
                }
            }
        }
        return null;
    }
    
    
    public String converXMLToHTML(String xmlIn, String fillQualFunction, String expandFunctionName, String qualifierType){
        //Reader reader = new StringReader(xmlIn);
        InputStream in = new ByteArrayInputStream(xmlIn.getBytes());
        try {
            QualifierParser parse = new QualifierParser(in,fillQualFunction,expandFunctionName,qualifierType);
            return parse.getBuffer();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}