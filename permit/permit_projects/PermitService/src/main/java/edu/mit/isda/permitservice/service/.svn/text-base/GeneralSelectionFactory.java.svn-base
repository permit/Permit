/*
 * GeneralSelectionFactory.java
 * Created on September 21, 2007, 2:40 AM
 *  Copyright (C) 2007-2010 Massachusetts Institute of Technology
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


package edu.mit.isda.permitservice.service;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.dao.*;
import java.io.*;
import java.util.*;

import edu.mit.isda.permitservice.dataobjects.*;
/**
 *
 */
public class GeneralSelectionFactory {
    private static final ApplicationContext ctx;
    
     static {
        String WsName = "permitws";
        String contDir = findWebserviceContainer(WsName, "/home/www/etc/containers");
        String Path = "/isda/" + WsName + "/generalSelectionApplicationContext.xml";
        
        if (null != contDir) {
            if (contDir.trim().length() > 0) {
                Path = "/home/www/etc/containers/" + contDir + "/" + WsName + "/generalSelectionApplicationContext.xml";
            }
        }         
        
        String[] paths = {"generalSelectionApplicationContext.xml"};
        //String[] paths = {Path};
        ctx = new ClassPathXmlApplicationContext(paths); 
    }
     
    private GeneralSelectionFactory()
    {
    }
    public static GeneralSelectionManager getManager()throws AuthorizationException
    {
        return (GeneralSelectionManager)ctx.getBean("GeneralSelectionManager");
    }
   

    private static String findWebserviceContainer(String webserviceName, String containerDirectory)
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
 
    private static String[] readDirectoryContents(String directory)
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
