        /***********************************************************************
$Rev:: 341                       $:  Revision of last commit
$Author:: dtanner                $:  Author of last commit
$Date:: 2007-02-23 13:58:42 -050#$:  Date of last commit
***********************************************************************/
/*
 * AuthenticateRemoteClient.java
 * Author: ZEST
 * Created on December 1, 2006, 10:00 AM
 * Copyright 2006 Massachusetts Institute of Technology (M.I.T) . All rights reserved. Use is subject to license terms. 
 */
/*
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
*/

package edu.mit.isda.wsLibrary.security;

import java.security.cert.CertificateExpiredException;
import java.util.*;
import java.io.*;
import org.apache.axis.MessageContext;
import org.apache.axis.transport.http.HTTPConstants;
import javax.servlet.http.*;
import javax.servlet.*;
import javax.security.auth.x500.X500Principal;
import java.security.cert.*;

public class AuthenticateRemoteClient 
{

    public AuthenticateRemoteClient() 
    {
    }
    
    public String authenticateClient(String WsName) throws Exception
    {
        String ApplicationID = "";
        String remoteClient = "";
        X500Principal SubjectX500Principal;
        FileInputStream inputStream = null;
        
        Properties props = new Properties();
        
        try
        {
            MessageContext context = MessageContext.getCurrentContext(); 
            HttpServletRequest request = (HttpServletRequest) context.getProperty(HTTPConstants.MC_HTTP_SERVLETREQUEST);
            if (request == null)
                throw new Exception("Unable to verify client identity.  Access denied. 1");
            X509Certificate[] certificate = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");
            if (certificate != null)
            {
                SubjectX500Principal = certificate[0].getSubjectX500Principal();
                String temp = SubjectX500Principal.getName();
                int StartIndex = temp.indexOf("CN=");
                StartIndex += 3;
                int EndIndex = temp.indexOf(",", StartIndex);
                remoteClient = temp.substring(StartIndex, EndIndex);
            }
            else
            {
                remoteClient = (String) request.getAttribute("SSL_CLIENT_S_DN_CN"); 
                if (remoteClient == null)
                    remoteClient = "";

            }
            if (remoteClient.length() == 0)
                throw new Exception("Unable to verify client identity.  Access denied. 2" + remoteClient + ".");
            remoteClient = remoteClient.replace(' ', '_');
            
            String configProps = System.getenv("WSETCDIR") + File.separator + "webserviceConfig.properties";
            String path = null;
            if (null != configProps)
            {
                        //Path = containerDir + File.separator + WsName + File.separator + "allowedLocations.properties";
                    Properties p = new Properties();
                    p.load(new FileInputStream(configProps));
                    path = p.getProperty("containersdir");
                    props.load(inputStream = new FileInputStream(path + File.separator + "permit" + File.separator + WsName + File.separator + "allowedLocations.properties"));

            }

            if (null == props || props.containsKey(remoteClient) == false)
            {
                throw new Exception("Unable to verify client identity.  Access denied. 3" + remoteClient + ".");
            }
            ApplicationID = props.getProperty(remoteClient);
            if (inputStream != null)
            {
                inputStream.close();
                inputStream = null;
            }
            if (ApplicationID == null)
            {
                ApplicationID = "";
            }
        }
        catch (Exception e)
        {
            if (inputStream != null)
            {
                inputStream.close();
                inputStream = null;
                
            }
            throw new Exception(e.getMessage());
        }
        return(ApplicationID);
    }
    
    private String findWebserviceContainer(String webserviceName, String containerDirectory)
    {
        String[] directoryNames = readDirectoryContents(containerDirectory);
        if (null != directoryNames) {
            for (String dName: directoryNames)
            {
                try
                {
                    String[] fNames = readDirectoryContents(containerDirectory + "/" + dName);
                    if (fNames.length != 0)
                    {
                        for (String fName: fNames)
                        {
                            if (webserviceName.equalsIgnoreCase(fName) == true)
                            {
                                return(dName);
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }
        else {
            return null;
        }
        return null;
    }
 
    private String[] readDirectoryContents(String directory)
    {
        String fileList[];
        try {
            File dDirectory = new File(directory);
 
            fileList = dDirectory.list();
            if (fileList.length != 0)
                Arrays.sort(fileList);
            return(fileList);
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }    
}
