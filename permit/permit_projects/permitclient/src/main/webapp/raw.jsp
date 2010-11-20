<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!--
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
-->
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
        <title>Permit - Authorizations for a Person</title>

        <!-- Source file --> 
        <script type="text/javascript" src="source.js"></script>
        <!-- Calendar Source files --> 
        <script src="jquery/jquery.js" type="text/javascript"></script>
        <style type="text/css">@import url(jquery/ui.datepicker.css);</style> 
        <script type="text/javascript" src="jquery/ui.datepicker.js"></script>
        
        <script>
            $(document).ready(function(){
                var Yesterday = new Date();
                Yesterday.setDate(Yesterday.getDate() - 1);
                $('#effective_date').datepicker({ dateFormat: 'mmddyy', minDate: Yesterday });
                $('#expiration_date').datepicker({ dateFormat: 'mmddyy', minDate: Yesterday });
            });
        </script>
    </head>
    
    <body onload="javascript:viewcats();" class=" yui-skin-sam">
        <a name="anchor"></a>
        <table width="100%">
            <td><h1>Permit - Authorizations for a Person</h1></td>
            <td align="right"><span name="loading" id="loading"></span></td>
        </table>
      <table>
        <td ALIGN=LEFT TYPE=TEXT ><a href="index.jsp"><span class='boldText'>Return to Master Test Page</span></a></td>
      </table>

        <table cellpadding=15 width="80%">
            <tr>
                <td valign="top" colspan="3">
                    <table>
                        <tr><td valign="top">
                                <div name="formspan" id="formspan" style="display: none">
                                    <form name="authform" id="authform">
                                        <table valign="top" align="left">
                                            <tr><td>Kerberos Name: <br> <input type='text' name='kerberos_name' size=10></td></tr>
                                            <tr>
                                                <td>Category: <br> 
                                                    <select id='function_category' name='function_category' onChange="javascript:list_functions_oc();">
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Function Name: <br> 
                                                    <select id='function_name' name='function_name' onChange="javascript:get_qtype();">
                                                    </select>
                                                </td>
                                            </tr>                                
                                            <tr>
                                                <td>Qualifier Code: <br> <input type='text' name='qualifier_code' size=17></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Qualifier Type: <br> <input type='text' name='qualifier_type' size=6 disabled>&nbsp;&nbsp;
                                                    <a href="#" onclick="javascript:get_quals(this.parentNode);">Lookup Qualifiers</a>
                                                </td>
                                            </tr>
                                            <tr><td colspan=2>Qualifier Name: <br> <input type='text' name='qualifier_name' size=54 disabled></td></tr>
                                            <tr>
                                                <td>Effective Date: <br>  <input type='text' name='effective_date' id="effective_date" size=10> </td>
                                            </tr>
                           
                                            <tr><td>Expiration Date: <br> <input type='text' name='expiration_date' id="expiration_date" size=10></td></tr>
                                            <tr><td>Modified By: <br> <input type='text' name='modified_by' size=10 disabled></td></tr>
                                            <tr><td>Modified Date: <br> <input type='text' name='modified_date' size=10 disabled></td></tr>
                                            <tr>
                                                <td>
                                                    Do Function: <br> 
                                                    <input type="radio" name="do_function" value="Y"> Yes
                                                    &nbsp;&nbsp;
                                                    <input type="radio" name="do_function" value="N"> No
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Grant Authorization: <br> 
                                                    <input type="radio" name="grant_auth" value="Y"> Yes
                                                    &nbsp;&nbsp;
                                                    <input type="radio" name="grant_auth" value="N"> No
                                                </td>
                                            </tr>                                            
                                            <tr><td>Authorization ID: <br> <input type='text' name='auth_id' onkeyup="javascript:check_authid();" size=12 disabled></td></tr>
                                            <tr><td colspan="2"><input type='hidden' name='qualifier_id'></td></tr>
                                            <tr>
                                                <td>
                                                    <input type='button' name='create' value='Create' onclick="javascript:create_auth();">                          
                                                    <input type='button' name='update' value='Replace' onclick="javascript:update_auth(this.parentNode);">
                                                    <input type='button' name='del' value='Delete' onclick="javascript:delete_auth(this.parentNode);">
                                                </td>
                                            </tr>
                                        </table> 
                                    </form>
                                </div>                
                            </td>
                        </tr>      
                        <tr>                            
                            <td valign="top"><span name="requeststatus" id="requeststatus"></span></td>
                        </tr>       
                        <tr>
                            <td valign="top">
                                <form name="myform" id="myform" action="javascript:get(this.parentNode);">
                                    <table valign="top" align="left">
                                        <tr><td>Kerberos Name:</td><td><input type='text' name='username' size=10> </td></tr>
                                        <!-- <tr><td>Category:</td><td><input type='text' name='catagory'></td></tr> -->
                                        <tr><td>Category:</td>
                                        <td colspan="2">
                                            <select id='function_category' name='function_category'">
                                            </select>
                                        </td>
                                    </tr>                            
                                    <tr><td><input type="button" id="getauths" name="getauths" value="Submit" onclick="javascript:get(this.parentNode);" disabled></td>
                                    <tr><td><input type="button" id="newauth" name="newauth" value="New Authorization" onclick="javascript:newform();" disabled></td>
                                </table>
                            </form>
                        </td>
                    </tr>         
                        <tr>
                            <td colspan="1" valign="top"><span name="myspan" id="myspan"></span></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
