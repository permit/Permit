 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
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
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
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
    //if ((Port ==80) || (Port == 443) || (Port == 553))
    if ((Port ==80) || (Port == 443))
    {
        httpAddress = hostname;
        httpsAddress = hostname;
    }
    else
    {
        httpAddress = hostname + ":8080";
        //httpsAddress = hostname + ":8443";
        httpsAddress = hostname + ":8443";
    }
%>    

<%
        String redirectURL = "https://" + httpsAddress + "/permitclient/permitui.html";
        response.sendRedirect(redirectURL);
%>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Permitws Test Page</title>
    </head>
    <STYLE TYPE="text/css">
        <!--
        .centeralign {text-align:center}
        -->
    </STYLE>
    <body>
    <h1 ALIGN=CENTER>Permit Application Test Page</h1>
    <BR>
    <h3 ALIGN=CENTER>select the test you want to execute.</h3>
    <BR>
    <table align="center">
        <tr>
            <td>
                <OL>
                    <li>&nbsp;&nbsp;Click&nbsp;<A HREF="https://<%=httpsAddress%>/permitclient/raw.jsp"><B>here</B></A>&nbsp;to execute <b>Authorizations for a Person</b> test.
                    <li>&nbsp;&nbsp;Click&nbsp;<A HREF="https://<%=httpsAddress%>/permitclient/generalSelection.html"><B>here</B></A>&nbsp;to execute <b>General Selection</b> test.
                    <li>&nbsp;&nbsp;Click&nbsp;<A HREF="https://<%=httpsAddress%>/permitclient/listPerson.jsp"><B>here</B></A>&nbsp;to execute <b>Autocomplete</b> test.
                    <li>&nbsp;&nbsp;Click&nbsp;<A HREF="https://<%=httpsAddress%>/permitclient/permitui.html"><B>here</B></A>&nbsp;to execute <b>Permit UI</b> test.
                </OL>
            </td>
        </tr>
    </table>
    <!--
    <P CLASS="centeralign">1)&nbsp;&nbsp;Click&nbsp;<A HREF="listAuthorizationsByPerson.jsp"><B>here</B></A>&nbsp;to execute <b>listAuthorizationsByPerson</b> test.</P>
    <P CLASS="centeralign">2)&nbsp;&nbsp;Click&nbsp;<A HREF="isUserAuthorized.jsp"><B>here</B></A>&nbsp;to execute <b>isUserAuthorized</b> test.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</P>
    <P CLASS="centeralign">3)&nbsp;&nbsp;Click&nbsp;<A HREF="createAuthorization.jsp"><B>here</B></A>&nbsp;to execute <b>createAuthorization</b> test.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</P>
    -->
    </body>
</html>
