<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
--%>
<%--
 -  Copyright (C) 2008-2010 Massachusetts Institute of Technology
 -  For contact and other information see: http://mit.edu/permit/
 -
 -  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General 
 -  Public License as published by the Free Software Foundation; either version 2 of the License.
 -
 -  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even 
 -  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
 -  License for more details.
 -
 -  You should have received a copy of the GNU General Public License along with this program; if not, write 
 -  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 -
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
<%
    String httpAddress;
    String httpsAddress;
    ServletContext sContext = this.getServletContext();
    HttpSession sSession = request.getSession();
    String hostname = request.getLocalName();
    int Port = request.getLocalPort();
    if ((Port ==80) || (Port == 443))
    {
        httpAddress = hostname;
        httpsAddress = hostname;
    }
    else
    {
        httpAddress = hostname + ":8080";
        httpsAddress = hostname + ":8443";
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ROLESWS WSDL</title>
        <STYLE TYPE="text/css">
        <!--
            .centeralign {text-align:center}
        -->
        </STYLE>
    </head>
    <body>
    <h1 ALIGN=CENTER>PERMITWS Permit WDSL Page</h1>
    <BR>
    <h3 ALIGN=CENTER>Select the type of WSDL you want</h3>
    <BR>
    <P CLASS="centeralign">1)&nbsp;&nbsp;Click&nbsp;<A HREF="https://<%=httpsAddress%>/permitws/services/permit?wsdl"><B>here</B></A>&nbsp;to get the permit WSDL that uses MIT certificates.</P>
    
    </body>
</html>
