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
*/            var http_request = false;
            var result = new String();
            var cat_globe = "";
            var name_globe = "";
            var func_globe = "";
            var id_globe = "";
            
            // Begin Sort functions
            function sortTable(id, col, rev) {
                // Get the table or table section to sort.
                var tblEl = document.getElementById(id);

                // The first time this function is called for a given table, set up an
                // array of reverse sort flags.
                if (tblEl.reverseSort == null) {
                    tblEl.reverseSort = new Array();
                    // Also, assume the team name column is initially sorted.
                    tblEl.lastColumn = 1;
                }

                // If this column has not been sorted before, set the initial sort direction.
                if (tblEl.reverseSort[col] == null)
                    tblEl.reverseSort[col] = rev;

                // If this column was the last one sorted, reverse its sort direction.
                if (col == tblEl.lastColumn)
                    tblEl.reverseSort[col] = !tblEl.reverseSort[col];

                // Remember this column as the last one sorted.
                tblEl.lastColumn = col;

                // Set the table display style to "none" - necessary for Netscape 6 
                // browsers.
                var oldDsply = tblEl.style.display;
                tblEl.style.display = "none";

                // Sort the rows based on the content of the specified column using a
                // selection sort.

                var tmpEl;
                var i, j;
                var minVal, minIdx;
                var testVal;
                var cmp;

                for (i = 0; i < tblEl.rows.length - 1; i++) {
                    // Assume the current row has the minimum value.
                    minIdx = i;
                    minVal = getTextValue(tblEl.rows[i].cells[col]);

                    // Search the rows that follow the current one for a smaller value.
                    for (j = i + 1; j < tblEl.rows.length; j++) {
                        testVal = getTextValue(tblEl.rows[j].cells[col]);
                        cmp = compareValues(minVal, testVal);
                        // Negate the comparison result if the reverse sort flag is set.
                        if (tblEl.reverseSort[col])
                            cmp = -cmp;
                        // Sort by the second column (team name) if those values are equal.
                        if (cmp == 0 && col != 1)
                            cmp = compareValues(getTextValue(tblEl.rows[minIdx].cells[1]),
                        getTextValue(tblEl.rows[j].cells[1]));
                        // If this row has a smaller value than the current minimum, remember its
                        // position and update the current minimum value.
                        if (cmp > 0) {
                            minIdx = j;
                            minVal = testVal;
                        }
                    }

                    // By now, we have the row with the smallest value. Remove it from the
                    // table and insert it before the current row.
                    if (minIdx > i) {
                        tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
                        tblEl.insertBefore(tmpEl, tblEl.rows[i]);
                    }   
                }

                // Make it look pretty.
                makePretty(tblEl, col);

                // Restore the table's display style.
                tblEl.style.display = oldDsply;

                return false;
            }

            //-----------------------------------------------------------------------------
            // Functions to get and compare values during a sort.
            //-----------------------------------------------------------------------------

            // This code is necessary for browsers that don't reflect the DOM constants
            // (like IE).
            if (document.ELEMENT_NODE == null) {
                document.ELEMENT_NODE = 1;
                document.TEXT_NODE = 3;
            }

            function getTextValue(el) {
                var i;
                var s;

                // Find and concatenate the values of all text nodes contained within the
                // element.
                s = "";
                for (i = 0; i < el.childNodes.length; i++)
                    if (el.childNodes[i].nodeType == document.TEXT_NODE)
                        s += el.childNodes[i].nodeValue;
                    else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
                            el.childNodes[i].tagName == "BR")
                        s += " ";
                    else
                        // Use recursion to get text within sub-elements.
                        s += getTextValue(el.childNodes[i]);

                return normalizeString(s);
            }

            function compareValues(v1, v2) {
                var f1, f2;

                // If the values are numeric, convert them to floats.
                f1 = parseFloat(v1);
                f2 = parseFloat(v2);
                if (!isNaN(f1) && !isNaN(f2)) {
                    v1 = f1;
                    v2 = f2;
                }

                // Compare the two values.
                if (v1 == v2)
                    return 0;
                if (v1 > v2)
                    return 1
                return -1;
            }

            // Regular expressions for normalizing white space.
            var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
            var whtSpMult = new RegExp("\\s\\s+", "g");

            function normalizeString(s) {
                s = s.replace(whtSpMult, " ");  // Collapse any multiple whites space.
                s = s.replace(whtSpEnds, "");   // Remove leading or trailing white space.

                return s;
            }

            //-----------------------------------------------------------------------------
            // Functions to update the table appearance after a sort.
            //-----------------------------------------------------------------------------

            // Style class names.
            var rowClsNm = "alternateRow";
            var colClsNm = "sortedColumn";

            // Regular expressions for setting class names.
            var rowTest = new RegExp(rowClsNm, "gi");
            var colTest = new RegExp(colClsNm, "gi");

            function makePretty(tblEl, col) {
                var i, j;
                var rowEl, cellEl;
            
                // Set style classes on each row to alternate their appearance.
                for (i = 0; i < tblEl.rows.length; i++) {
                    rowEl = tblEl.rows[i];
                    rowEl.className = rowEl.className.replace(rowTest, "");
                    if (i % 2 != 0)
                        rowEl.className += " " + rowClsNm;
                    rowEl.className = normalizeString(rowEl.className);
                    // Set style classes on each column (other than the name column) to
                    // highlight the one that was sorted.
                    for (j = 2; j < tblEl.rows[i].cells.length; j++) {
                        cellEl = rowEl.cells[j];
                        cellEl.className = cellEl.className.replace(colTest, "");
                        if (j == col)
                            cellEl.className += " " + colClsNm;
                        cellEl.className = normalizeString(cellEl.className);
                    }
                }

                // Find the table header and highlight the column that was sorted.
                var el = tblEl.parentNode.tHead;
                rowEl = el.rows[el.rows.length - 1];
                // Set style classes for each column as above.
                for (i = 2; i < rowEl.cells.length; i++) {
                    cellEl = rowEl.cells[i];
                    cellEl.className = cellEl.className.replace(colTest, "");
                    // Highlight the header of the sorted column.
                    if (i == col)
                        cellEl.className += " " + colClsNm;
                    cellEl.className = normalizeString(cellEl.className);
                }
            }
            // End Sort Functions


            function updateContents() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                var getstr = "?";
                var time = new Date();
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.getElementById('requeststatus').innerHTML = result;       
                        getstr += "username=" + document.authform.kerberos_name.value + "&";
                        //getstr += "catagory=" + document.authform.function_category.value + "&";
                        getstr += "catagory=" + document.myform.function_category[document.myform.function_category.selectedIndex].value + "&";
                        getstr += "time=" + time.getTime();
                        genericRequest('rawResponse.jsp', getstr, alertContents);
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }            

            function alertContents_Back() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.getElementById('myspan').innerHTML = result;            
                        document.getElementById('loading').innerHTML = "";   
                        if (null != document.getElementById('authBody')) {
                            sortTable('authBody', 4, false);
                            sortTable('authBody', 3, false);
                            sortTable('authBody', 2, false);
                            sortTable('authBody', 1, false);
                        }
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }

            function qualContents() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.getElementById('requeststatus').innerHTML = result;            
                        document.getElementById('loading').innerHTML = "";   
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }                 
   
            function get(obj) {
                document.getElementById('requeststatus').innerHTML = "";    
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + document.myform.username.value + "&";
                getstr += "catagory=" + document.myform.function_category[document.myform.function_category.selectedIndex].value + "&";
                getstr += "time=" + time.getTime();
                genericRequest('rawResponse.jsp', getstr, alertContents);
            }
            
            function newform() {
                name_globe=document.myform.username.value;
                cat_globe=document.myform.function_category[document.myform.function_category.selectedIndex].value;
                var today = new Date();
                var year = today.getFullYear().toString();
                var month;
                var month_int = parseInt(today.getMonth().toString());
                month_int++;
                var day;
                if (today.getDate().toString().length < 2) {
                    day = "0" + today.getDate().toString();
                }
                else {
                    day = today.getDate().toString();
                }
                if (month_int < 10) {
                    month = "0" + month_int.toString();
                }
                else {
                    month = month_int.toString();
                }
                var date_string = month + day + year;
                list_categories();
                document.getElementById('requeststatus').innerHTML = "";
                document.authform.kerberos_name.value=name_globe;
                document.authform.qualifier_code.value="";
                document.authform.qualifier_type.value="";
                document.authform.qualifier_name.value="";
                document.authform.auth_id.value="";
                document.authform.modified_by.value="";
                document.authform.modified_date.value="";
                document.authform.effective_date.value=date_string;
                document.authform.expiration_date.value="";
                document.authform.do_function[0].checked=true;
                document.authform.grant_auth[1].checked=true;
                check_authid();
            }
            
            function fillform(name, cat, func, qual, qualcode, auth_id, effdate, expdate, qualtype, modifiedby, modifieddate, dofunction, grantauth) {
                cat_globe = cat;
                name_globe = name;
                func_globe = func;
                document.authform.kerberos_name.value=name;
                document.authform.function_name.value=func;
                document.authform.qualifier_code.value=qualcode;
                document.authform.qualifier_type.value=qualtype;
                document.authform.qualifier_name.value=qual.replace("&apos", "'");
                document.authform.auth_id.value=auth_id;
                document.authform.effective_date.value=effdate;
                document.authform.expiration_date.value=expdate;
                document.authform.modified_by.value=modifiedby;
                document.authform.modified_date.value=modifieddate;
                if (dofunction == "Y") {
                  document.authform.do_function[0].checked = true;
                }
                else {
                  document.authform.do_function[1].checked = true;
                }
                
                if (grantauth == "G") {
                  document.authform.grant_auth[0].checked = true;
                }
                else {
                  document.authform.grant_auth[1].checked = true;
                }                
                list_categories();
                document.getElementById('requeststatus').innerHTML = ""; 
                check_authid();
                location.href = "#";
            }
            
            function fill_qual(code, name) {
                document.authform.qualifier_code.value=code;
                document.authform.qualifier_name.value=name;
                document.getElementById('requeststatus').innerHTML="";
            }
            
            function displayform() {
               if(document.getElementById('formspan').style.display == "none") {
                 document.getElementById('formspan').style.display="block";
                 check_authid();
                 document.authform.kerberos_name.focus();
               }
            }
            
            function hideform() {
               if(document.getElementById('formspan').style.display != "none") {
                 document.getElementById('formspan').style.display="none";
               }
            }
            
            function toggle_span_visible(id) {
               var imgId = "img" + id;
               if(document.getElementById(id).style.display == "none") {
                 document.getElementById(id).style.display="block";
                 document.getElementById(imgId).src="minus.gif";
               }
               else {
                 document.getElementById(id).style.display="none";
                   document.getElementById(imgId).src="plus.gif";
               }
            }
            
            function create_auth() {
                var getstr = "?";
                var time = new Date();
                getstr += "kerberos_name="   + document.authform.kerberos_name.value + "&";
                getstr += "function_name="   + document.authform.function_name[document.authform.function_name.selectedIndex].value + "&";
                getstr += "qualifier_code="  + document.authform.qualifier_code.value + "&";
                getstr += "effective_date="  + document.authform.effective_date.value + "&";
                getstr += "expiration_date=" + document.authform.expiration_date.value + "&";
                if (document.authform.do_function[0].checked) {
                    getstr += "do_function="     + "Y&";
                }
                else {
                    getstr += "do_function="     + "N&";
                }
                if (document.authform.grant_auth[0].checked) {
                    getstr += "grant_auth="     + "G&";
                }
                else {
                    getstr += "grant_auth="     + "N&";
                }
                getstr += "time=" + time.getTime();
                genericRequest('ajaxResponse.jsp', getstr, updateContents);      
            }   
            
            function update_auth(obj) {
                var getstr = "?";
                var time = new Date();
                getstr += "kerberos_name="   + document.authform.kerberos_name.value + "&";
                getstr += "function_name="   + document.authform.function_name[document.authform.function_name.selectedIndex].value + "&";
                getstr += "qualifier_code="  + document.authform.qualifier_code.value + "&";
                getstr += "effective_date="  + document.authform.effective_date.value + "&";
                getstr += "expiration_date=" + document.authform.expiration_date.value + "&";
                getstr += "auth_id="         + document.authform.auth_id.value + "&";
                if (document.authform.do_function[0].checked) {
                    getstr += "do_function="     + "Y&";
                }
                else {
                    getstr += "do_function="     + "N&";
                }
                if (document.authform.grant_auth[0].checked) {
                    getstr += "grant_auth="     + "Y&";
                }
                else {
                    getstr += "grant_auth="     + "N&";
                }                
                getstr += "time=" + time.getTime();
                genericRequest('updateAuthorizationResponse.jsp', getstr, updateContents);     
            }
            
            function delete_auth(obj) {
                var getstr = "?";
                var time = new Date();
                getstr += "kerberos_name=" + document.authform.kerberos_name.value + "&";
                getstr += "auth_id=" + document.authform.auth_id.value + "&";
                getstr += "time=" + time.getTime();
                genericRequest('deleteAuthorizationResponse.jsp', getstr, updateContents);
                hideform();
            }           

            function get_quals(obj) {
                var getstr = "?";
                var time = new Date();
                getstr += "username="   + document.authform.kerberos_name.value + "&";
                getstr += "function="   + document.authform.function_name.value + "&";
                getstr += "qtype="      + document.authform.qualifier_type.value + "&";
                getstr += "time=" + time.getTime();
                genericRequest('qualResponse.jsp', getstr, qualContents);  
            }            
            
            function get_quals_root(root_id) {
                var getstr = "?";
                var time = new Date();
                getstr += "root_id="   + root_id + "&";
                getstr += "root=true"  + "&";
                getstr += "qtype="     + document.authform.qualifier_type.value + "&";
                getstr += "time=" + time.getTime();
                genericRequest('qualRootResponse.jsp', getstr, qualContents);  
            }                       
            
            function check_authid() {
                if (document.authform.auth_id.value == "") {
                    document.authform.update.disabled=true;
                    document.authform.del.disabled=true;
                }
                else {
                    document.authform.update.disabled=false;
                    document.authform.del.disabled=false;
                }
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
                        document.authform.function_category.options[0] = new Option("Pick a Category", "");
                        for (var i = 0; i < result_array.length; i++) {
                            cat_display = result_array[i].split("||");
                            document.authform.function_category.options[i+1] = new Option(cat_display[0] + " - " + cat_display[1], cat_display[0]);
                            if (cat_globe != null && cat_globe != "") {
                                if (cat_globe.toUpperCase().replace(/^\s+|\s+$/g, '') == cat_display[0].toUpperCase().replace(/^\s+|\s+$/g, '')) {
                                    document.authform.function_category.options[i+1].selected=true;
                                    matched = 1;
                                }
                            }
                            else {
                                cat_globe = "nothing";
                            }
                        }
                        if (matched == 0) {
                            cat_globe = "nothing";
                        }
                        list_functions();
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            
            function list_functions() {
                document.getElementById('requeststatus').innerHTML = "";    
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + name_globe + "&";
                getstr += "category=" + cat_globe + "&";
                getstr += "time=" + time.getTime();
                genericRequest('listPickableFunctions.jsp', getstr, funcAlert);
            }
            
             function list_functions_oc() {
                document.getElementById('requeststatus').innerHTML = "";    
                var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;
                var name = document.authform.kerberos_name.value;
                func_globe = "";
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + name + "&";
                getstr += "category=" + cat + "&";
                getstr += "time=" + time.getTime();
                genericRequest('listPickableFunctions.jsp', getstr, funcAlert);
            }
            
            function funcAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        document.authform.function_name.options.length=0;
                        if (document.authform.function_category[document.authform.function_category.selectedIndex].value != "") {
                            result = http_request.responseText;
                            result_array = result.split("^^");
                            for (var i = 0; i < result_array.length; i++) {
                                func_display = result_array[i].split("||");
                                document.authform.function_name.options[i] = new Option(func_display[0], func_display[0]);
                                if (i == 0) {
                                  if (func_display[2] == "undefined") {
                                      document.authform.qualifier_type.value = "NULL";
                                      document.authform.qualifier_code.value = "NULL";
                                  }
                                  else {
                                      document.authform.qualifier_type.value = func_display[2];
                                  }
                                }
                                if (func_globe.toUpperCase() == func_display[0].toUpperCase()) {
                                    document.authform.function_name.options[i].selected=true;
                                }
                            }
                        }
                        document.getElementById('loading').innerHTML = "";   
                        displayform();                         
                   } else {
                        alert('There was a problem with the request.');
                    }
                }
            }       
             
            function get_qtype() {
                document.getElementById('requeststatus').innerHTML = "";    
                var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;
                var func = document.authform.function_name[document.authform.function_name.selectedIndex].value;
                var name = document.authform.kerberos_name.value;
                var time = new Date();
                var getstr = "?";
                getstr += "username=" + name + "&";
                getstr += "category=" + cat + "&";
                getstr += "function_name=" + func + "&";
                getstr += "time=" + time.getTime();
                genericRequest('getQualType.jsp', getstr, qualAlert);
            }    

            function qualAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.authform.qualifier_type.value = result;
                        document.authform.qualifier_code.value = "";
                        if (document.authform.qualifier_type.value == "NULL") {
                            document.authform.qualifier_code.value = "NULL";
                        }
                        document.authform.qualifier_name.value = "";
                        document.getElementById('loading').innerHTML = "";   
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            
            function expand_quals(id) {
                if (document.getElementById(id).innerHTML.toString().length < 2) {
                    var getstr = "?";
                    id_globe = id;
                    var time = new Date();
                    getstr += "root_id="   + id + "&";
                    getstr += "root=false" + "&";
                    getstr += "qtype="     + document.authform.qualifier_type.value + "&";
                    getstr += "time=" + time.getTime();
                    genericRequest('qualExp.jsp', getstr, qualExpandContents);
                }
                else {
                    toggle_span_visible(id);
                }
            }
            
            function qualExpandContents() {
                document.getElementById(id_globe).innerHTML = "<ul style = \"list-style-type:none\"><li><img src='loading.gif'><b>Loading, please wait...</b></li></ul>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.getElementById(id_globe).innerHTML = result;  
                        var imgId = "img" + id_globe;
                        document.getElementById(imgId).src="minus.gif";
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }                   
            
            function viewcats() {
                document.getElementById('requeststatus').innerHTML = "";    
                var getstr = "?";
                var time = new Date();
                getstr += "time=" + time.getTime();
                genericRequest('viewCatsResponse.jsp', getstr, viewcatAlert);                
            }
            
            function viewcatAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                var trimmed = "";

                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        result_array = result.split("^^");
                        for (var i = 0; i < result_array.length; i++) {
                            cat_display = result_array[i].split("||");
                            trimmed = cat_display[1].replace(/^\s+|\s+$/g, '');
                            document.myform.function_category.options[i] = new Option(cat_display[0] + " - " + trimmed, cat_display[0]);
                            if (i == 0) {
                                document.myform.function_category.options[i] = new Option(trimmed, cat_display[0]);
                            }                                
                        }
                        document.getElementById('loading').innerHTML = "";   
                        document.myform.getauths.disabled=false;
                        document.myform.newauth.disabled=false;
                    } else {
                        alert('There was a problem with the request.');
                        document.getElementById('loading').innerHTML = "";   
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

            function alertContents() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><b>Loading, please wait...</b>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        jsonPopulate();
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }            

            function jsonPopulate() {
                var resp =  http_request.responseText;
                if (resp.indexOf('authorizations') == -1) {
                    document.getElementById('myspan').innerHTML = "<font color='red'><b>" + resp + "</b></font>";
                    if (resp == "null") {
                        document.getElementById('myspan').innerHTML = "<font color='red'><b>You do not have permission to view these authorizations.</b></font>";
                    }
                }
                else {
                var myJSONObject = eval('(' + resp + ')');
                var tableString = "<table id=\"authTable\" cellpadding=5 border=1>";
                var argString = "";
                tableString += "<thead id=\"authHead\"><tr>";
                tableString += "<th><b><a href=\"\" onclick=\"return sortTable('authBody', 0, true)\">Kerberos<br>Name</b></a></th>";
                tableString += "<th><b><a href=\"\" onclick=\"return sortTable('authBody', 1, true)\">Category</b></a></th>";
                tableString += "<th><b><a href=\"\" onclick=\"return sortTable('authBody', 2, true)\">Function<br>Name</b></a></th>";
                tableString += "<th><b><a href=\"\" onclick=\"return sortTable('authBody', 3, true)\">Qualifier<br>Code</b></a></th>";
                tableString += "<th><b><a href=\"\" onclick=\"return sortTable('authBody', 4, true)\">Qualifier</b></a></td>";
                tableString += "<th><b>Effective<br>Date</b></th>";
                tableString += "<td><b>Select<br>Authorization</b></th>";
                tableString += "</tr></thead>";
                tableString += "<tbody id=\"authBody\">";
            
                for(var i = 0; i < myJSONObject.authorizations.length; i++) {
                 argString = "&quot;" + myJSONObject.authorizations[i].kerberosName + "&quot; , &quot;" + myJSONObject.authorizations[i].category + "&quot; , &quot;" 
                + myJSONObject.authorizations[i].functionName  + "&quot; , &quot;" + myJSONObject.authorizations[i].qualifierName   + "&quot; , &quot;" 
                + myJSONObject.authorizations[i].qualifierCode + "&quot; , &quot;" + myJSONObject.authorizations[i].authorizationID + "&quot; , &quot;"
                + myJSONObject.authorizations[i].effectiveDate + "&quot; , &quot;" + myJSONObject.authorizations[i].expirationDate  + "&quot; , &quot;"
                + myJSONObject.authorizations[i].qualifierType + "&quot; , &quot;" + myJSONObject.authorizations[i].modifiedBy      + "&quot; , &quot;"
                + myJSONObject.authorizations[i].modifiedDate  + "&quot; , &quot;" + myJSONObject.authorizations[i].doFunction      + "&quot; , &quot;"
                + myJSONObject.authorizations[i].grantAuthorization + "&quot;";      
                argString = argString.replace("'", "&apos");
                    tableString += "<td>" + myJSONObject.authorizations[i].kerberosName;
                    tableString += "</td><td>" + myJSONObject.authorizations[i].category;
                    tableString += "</td><td>" + myJSONObject.authorizations[i].functionName;
                    tableString += "</td><td>" + myJSONObject.authorizations[i].qualifierCode;
                    tableString += "</td><td>" + myJSONObject.authorizations[i].qualifierName;
                    tableString += "</td><td>" + myJSONObject.authorizations[i].effectiveDate + " - <br>" + myJSONObject.authorizations[i].expirationDate;
                    tableString += "</td><td><input type='button' value='Select' onclick='javascript:fillform(" + argString + ");'>";
                    tableString += "</td></tr>";
                }
                tableString += "</tbody></table>";      
                document.getElementById('myspan').innerHTML = tableString;
                if (null != document.getElementById('authBody')) {
                    sortTable('authBody', 4, false);
                    sortTable('authBody', 3, false);
                    sortTable('authBody', 2, false);
                    sortTable('authBody', 1, false);
                }      
                }
                document.getElementById('loading').innerHTML = "";   
            }