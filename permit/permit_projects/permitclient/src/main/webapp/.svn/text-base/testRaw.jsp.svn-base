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
<%
   ServletContext sContext = this.getServletContext();
   HttpSession sSession = request.getSession();
   edu.mit.isda.permitws.permitclient permitClient = new edu.mit.isda.permitws.permitclient();
   permitService_pkg.RolesAuthorizationExt[] authArray = permitClient.listAuthorizationsRaw(request);
   String argString = null;
   if (null != authArray) {
%>
        <table id="authTable" cellpadding=5 border=1>
            <thead id="authHead"><tr>
                    <th><b><a href="" onclick="return sortTable('authBody', 0, true)">Kerberos<br>Name</b></a></th>
                    <th><b><a href="" onclick="return sortTable('authBody', 1, true)">Category</b></a></th>
                    <th><b><a href="" onclick="return sortTable('authBody', 2, true)">Function<br>Name</b></a></th>
                    <th><b><a href="" onclick="return sortTable('authBody', 3, true)">Qualifier<br>Code</b></a></th>
                    <th><b><a href="" onclick="return sortTable('authBody', 4, true)">Qualifier</b></a></td>
                    <th><b>Effective<br>Date</b></th>
                    <!-- <td><b>Expiration<br>Date</b></td> -->
                    <td><b>Select<br>Authorization</b></th>
            </tr></thead>
            <tbody id="authBody">
                <%
                
                for (int i = 0; i < authArray.length; i++) {
                argString = "&quot;" + authArray[i].getName() + "&quot; , &quot;" + authArray[i].getCategory() + "&quot; , &quot;" 
                + authArray[i].getFunction() + "&quot; , &quot;" + authArray[i].getQualifier() + "&quot; , &quot;" 
                + authArray[i].getQualifierCode() + "&quot; , &quot;" + authArray[i].getAuthorizationID() + "&quot; , &quot;"
                + authArray[i].getEffectiveDate() + "&quot; , &quot;" + authArray[i].getExpirationDate() + "&quot; , &quot;"
                + authArray[i].getQualifierType() + "&quot;";
                argString = argString.replaceAll("'", "&apos");
                out.print("<tr>");
                out.print("<td>");
                out.print(authArray[i].getName());
                out.print("</td>");
                out.print("<td>");
                out.print(authArray[i].getCategory());
                out.print("</td>");
                out.print("<td>");
                out.print(authArray[i].getFunction());
                out.print("</td>");
                out.print("<td>");
                out.print(authArray[i].getQualifierCode());
                out.print("</td>");                    
                out.print("<td>");
                out.print(authArray[i].getQualifier());
                out.print("</td>");      
                out.print("<td>");
                out.print(authArray[i].getEffectiveDate().substring(0,2));
                out.print("/");
                out.print(authArray[i].getEffectiveDate().substring(2,4));
                out.print("/");
                out.print(authArray[i].getEffectiveDate().substring(4));
                out.print(" -<br>");
                if (authArray[i].getExpirationDate().length() != 0) {
                out.print(authArray[i].getExpirationDate().substring(0,2));
                out.print("/");
                out.print(authArray[i].getExpirationDate().substring(2,4));
                out.print("/");
                out.print(authArray[i].getExpirationDate().substring(4));
                }
                out.print("</td>");     
                out.print("<td>");
                out.print("<input type='button' value='Select' onclick='javascript:fillform(" + argString + ");'>");
                out.print("</td>");
                out.print("</tr>");
                }
                }
                else {
                out.print("<table cellpadding=5>");
                out.print("<tr><td><b>There were no results for that request.</b>");
                out.print("<br><a href='#' onclick='javascript:displayform()'> Click Here to Open Create/Update/Delete form </a>");
                out.print("</td></tr>");
                }                
                %>
            </tbody>
        </table>