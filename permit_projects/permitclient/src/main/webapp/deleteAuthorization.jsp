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
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Permitws Delete Authorization</title>
    </head>
    <body>

    <h1>Permitws Web Service deleteAuthorization Test Page</h1>
    <form action="index.jsp" method="POST">
      <table>
        <td ALIGN=LEFT TYPE=TEXT ><a href="index.jsp"><span class='boldText'>Return to Master Test Page</span></a></td>
      </table>
    </form>

    <form action="deleteAuthorizationResponse.jsp" method="POST">
      <table>
        <tr><td>User:</td><td><input type='text' name='kerberos_name'></td></tr>
        <tr><td>Authorization ID:</td><td><input type='text' name='auth_id'></td></tr>

        <tr><td colspan='2'><input name="submit" type="submit"></td></tr>
        <tr><td colspan='2'><input name="reset" type="reset"></td></tr>
      </table>
    </form>

    </body>
</html>