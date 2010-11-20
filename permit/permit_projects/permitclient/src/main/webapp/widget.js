/*
 *  Copyright (C) 2008-2010 Massachusetts Institute of Technology
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
            var r;
            var cat_globe;

            function widget_selector(widget_name) {
                if (widget_name=="function") {
                    alert("Here");
                    list_categories();
                }

                return r;
            }

            function list_categories() {
                document.getElementById('requeststatus').innerHTML = "";    
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + name_globe + "&";
                getstr += "time=" + time.getTime();
                genericRequest('listPickableCategories.jsp', getstr, catAlert);
            }
           
            function catAlert() {
                var matched = 0;
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        result_array = result.split("^^");
                        r = "<select name='function_category' id='function_category' onChange='javascript:list_functions_oc();'><option value='nothing'>Pick a Category</option>";
                        for (var i = 0; i < result_array.length; i++) {
                            cat_display = result_array[i].split("||");
                            r += "<option value='" + cat_display[0] + "'>" + cat_display[0] + " - " + cat_display[1] + "</option>";
                        }
                        r += "</select>";
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }
           
            function get_request() {
                http_request = false;
                if (window.XMLHttpRequest) { // Mozilla, Safari,...
                    http_request = new XMLHttpRequest();
                if (http_request.overrideMimeType) {
                    http_request.overrideMimeType('text/html');
                }
                } else if (window.ActiveXObject) { // IE
                    try {
                        http_request = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            http_request = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e) {}
                    }
                }
                return http_request;
            }

            function genericRequest(url, parameters, callback) {
                http_request = false;
                http_request = get_request();
                if (!http_request) {
                    alert('Cannot create XMLHTTP instance');
                    return false;
                }
                http_request.onreadystatechange = callback;
                http_request.open('GET', url + parameters, true);
                http_request.send(null);
            }     