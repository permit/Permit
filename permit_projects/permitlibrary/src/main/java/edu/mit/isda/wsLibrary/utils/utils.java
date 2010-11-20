/***********************************************************************
 * $Rev::                           $:  Revision of last commit
 * $Author::                        $:  Author of last commit
 * $Date::                          $:  Date of last commit
 ***********************************************************************/
/*
 * utils.java
 * Created on February 23, 2007, 3:20 PM
 * Author: ZEST
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

package edu.mit.isda.wsLibrary.utils;

import java.util.*;
import java.io.*;
import org.apache.axis.MessageContext;
import org.apache.axis.transport.http.HTTPConstants;
import javax.servlet.http.*;

public class utils
{
    
    public utils()
    {
    }

    public String validateUser(String UserName) throws Exception
    {
       String userName = "";

       try
       {
           if (UserName == null)
               return("");
           if (UserName.length() == 0)
               return("");
           
           userName = UserName.toLowerCase();
           int index = userName.indexOf("@");
           if (index == -1)
           {
               return(userName);
           }
           String domain = userName.substring(index + 1);
           if (domain == null)
               return("");
           if (domain.length() == 0)
               return("");
           if (domain.compareToIgnoreCase("mit.edu") != 0)
           {
               return(null);
           }
           userName = userName.substring(0, index);
           return(userName);
       }
       catch (Exception e)
       {
            throw new Exception(e.getMessage());
       }
    }
    
    public String getOS() throws Exception
    {
        String osName = "";

        try
        {
            MessageContext context = MessageContext.getCurrentContext(); 
            HttpServletRequest request = (HttpServletRequest) context.getProperty(HTTPConstants.MC_HTTP_SERVLETREQUEST);
            if (request == null)
                throw new Exception("Unable to get the Servlet Request");
            osName =  System.getProperty("os.name");
            if (osName == null)
                osName = "";
        }
        catch (Exception e)
        {
            throw new Exception(e.getMessage());
        }
        
        return(osName);
    }

    public String getProperty(String sPath, String KeyValue) throws Exception
    {
        String Server = "";
        FileInputStream inputStream = null;

        Properties props = new Properties();

        String Path = sPath + "/server.properties";
        try
        {
            props.load(inputStream = new FileInputStream(Path));

            if (props.containsKey(KeyValue) == false)
            {
                throw new Exception("Unable to find configuration file.");
            }
            Server = props.getProperty(KeyValue);
            if ((Server == null) || (Server.length() == 0))
            {
                throw new Exception("Unable to get property key: " + KeyValue);
            }
        }
        catch (Exception e)
        {
            throw new Exception(e.getMessage());
            
        }
        return(Server);
    }

    public boolean isNumeric(String str, Class<? extends Number> clazz)
    {
        try
        {
            if (clazz.equals(Byte.class))
            {
                Byte.parseByte(str);
            }
            else if (clazz.equals(Double.class))
            {
                Double.parseDouble(str);
            }
            else if (clazz.equals(Float.class))
            {
                Float.parseFloat(str);
            }
            else if (clazz.equals(Integer.class))
            {
                Integer.parseInt(str);
            }
            else if (clazz.equals(Long.class))
            {
                Long.parseLong(str);
            }
            else if (clazz.equals(Short.class))
            {
                Short.parseShort(str);
            }
        }
        catch (NumberFormatException nfe)
        {
            return false;
        }
 
        return true;
    }


}
