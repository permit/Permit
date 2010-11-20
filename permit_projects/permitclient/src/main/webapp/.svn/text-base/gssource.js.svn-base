/*
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
            var http_request = false;
            var result = new String();
            var cat_globe = "";
            var name_globe = "";
            var func_globe = "";
            var id_globe = "";
            var r;
            var widget_list = "";
            var selected_category = "";
            var selected_function = "";
            var currentSel = "";
            var currentSelTitle = "";
            var newOrView = "new";
            var start = "false";
            var canChangeAuth = "false";
            var majorChange = "false";
            var checked_ids = "";
	    var crit_list_qual_type = "";
            var currentQualTypeCriteriaId = "";
            function initForm(){
                start = "true";
                list_selections();
                setTimeout("initFormPause()", 1000);
            }
            function initFormPause() {
                var Yesterday = new Date();
                Yesterday.setDate(Yesterday.getDate() - 1);
                $('#effective_date').datepicker({ dateFormat: 'mm/dd/yy',  showOn: 'button', buttonImage: 'img/calendar.gif', buttonImageOnly: true });
                $('#expiration_date').datepicker({ dateFormat: 'mm/dd/yy', showOn: 'button', buttonImage: 'img/calendar.gif', buttonImageOnly: true});
                 $('#kerberos_name').autocomplete("listPersonRaw.jsp?sort=last&search=both&filter1=E&filter2=S&filter3=O", { minChars:3, formatMatch:formatMatch, formatResult:formatResult,  matchContains:true, cacheLength:200, max:300, highlight:false, onItemSelect:selectItem, 
                              formatItem:formatItem, scroll:true, selectOnly:1 });
               // $('#mitId').autocomplete("listPersonRaw.jsp?sort=last&search=both&filter1=E&filter2=S&filter3=O", { minChars:9, matchSubset:1, matchContains:'word', cacheLength:200, onItemSelect:selectItem, onFindValue:findValue,
               //               formatItem:formatItem, selectOnly:1 });
            }


            // Begin Sort functions
            function sortTable(id, col, rev) {
                // Get the table or table section to sort.
                var tblEl = document.getElementById(id);

                // The first time this function is called for a given table, set up an
                // array of reverse sort flags.
                if (tblEl.reverseSort == null) {
                    tblEl.reverseSort = new Array();
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
                        // Sort by the second column if those values are equal.
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
            var colClsNmA = "sortedColumnA";
            var colClsNmZ = "sortedColumnZ";

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
                        if (j == col) {
                            if(tblEl.reverseSort[col]) {
                                cellEl.className += " " + colClsNmZ;
                            }
                            else {
                                cellEl.className += " " + colClsNmA;
                            }
                        }
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
                        if (i == col) {
                            if(tblEl.reverseSort[col]) {
                                cellEl.className += " " + colClsNmZ;
                            }
                            else {
                                cellEl.className += " " + colClsNmA;
                            }
                        }
                    cellEl.className = normalizeString(cellEl.className);
                }
            }
            // End Sort Functions

            function get(obj) {
                var getstr = "?";
                var time = new Date();
                currentSel = document.selectform.selection_id.value;
                
                currentSelTitle = document.getElementById('selection_id')[document.getElementById('selection_id').selectedIndex].innerHTML;
                if (document.selectform.selection_id.value == "") {
                    document.getElementById('authspan').innerHTML = "<div class='alert'>Please select a criteria set.</div>";
                    document.getElementById('loading').innerHTML = "";    
                }
                else {
                    document.getElementById('authspan').innerHTML = "";
                    getstr += "selectionID=" + encode(document.selectform.selection_id.value) + "&";
                    getstr += "time=" + encode(time.getTime());
                    genericRequest('getCriteria.jsp', getstr, alertContents);
                }
            }

            function start_page(start_selection_id) {
                var getstr = "?";
                var time = new Date();
                currentSel = start_selection_id;
                document.selectform.selection_id.options[1].selected=true;
                document.getElementById('authspan').innerHTML = "";
                currentSelTitle = document.getElementById('selection_id')[document.getElementById('selection_id').selectedIndex].innerHTML;
                getstr += "selectionID="+encode(start_selection_id) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('getCriteria.jsp', getstr, startContents);
            }
            
            function get_auth() {
                var crit_string = "";
                var criteriaCount = 0;
                document.getElementById('authspan').style.display="";
                var container = document.getElementById("authspan");
                
                // clear all rows from authspan div tag
                if ( container.hasChildNodes() )
                {
                    while ( container.childNodes.length >= 1 )
                    {
                        container.removeChild( container.firstChild );
                    }
                }
		
                if (document.submitform) {
                    for (var i = 0; i < document.submitform.apply.length; i++) 
                    {
                        if (document.submitform.apply[i].checked) {
                            var id = document.submitform.apply[i].value.substring(2);
                            var val = document.getElementById("v_" + id);
                            if (val != null && val.type != "radio") {
                                crit_string += id + "||" + val.value + "||";
                            }
                            else {
                                var ycheck = document.getElementById("y_v_" + id);
                                var ncheck = document.getElementById("n_v_" + id);
                                if (ycheck.checked == true) {
                                    crit_string += id + "||" + "Y" + "||";
                                }
                                else {
                                    crit_string += id + "||" + "N" + "||";
                                }
                            }
                            criteriaCount++;
                        }
                    }
                    var getstr = "?";
                    var time = new Date();
                    if (criteriaCount > 0)
                    {
                      getstr += "critString=" + encode(crit_string) + "&";
                      getstr += "time=" + encode(time.getTime());
                      
                      genericRequest('getAuthsByCrits.jsp', getstr, authContents);
                    }
                    else
                    {
                      alert("You must select at least one selection criteria.")
                    }
                }
                else {
                    document.getElementById('loading').innerHTML = "";    
                }
            }

            function get_auth_start() {
                start = "false";
                var crit_string = "";
                if (document.submitform) {
                    for (var i = 0; i < document.submitform.apply.length; i++) 
                    {
                        if (document.submitform.apply[i].checked) {
                            var id = document.submitform.apply[i].value.substring(2);
                            var val = document.getElementById("v_" + id);
                            if (val != null && val.type != "radio") {
                                crit_string += id + "||" + val.value + "||";
                            }
                            else {
                                var ycheck = document.getElementById("y_v_" + id);
                                var ncheck = document.getElementById("n_v_" + id);
                                if (ycheck.checked == true) {
                                    crit_string += id + "||" + "Y" + "||";
                                }
                                else {
                                    crit_string += id + "||" + "N" + "||";
                                }
                            }
                        }
                    }
                    var getstr = "?";
                    var time = new Date();

                    getstr += "critString=" + encode(crit_string) + "&";
                    getstr += "time=" + encode(time.getTime());
                    genericRequest('getAuthsByCrits.jsp', getstr, authContents);
                }
                else {
                    document.getElementById('loading').innerHTML = "";    
                }
            }

            function hide_quals() {
                document.getElementById('quallist').innerHTML = "";    
                document.getElementById('quallist').style.display="none";
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
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                //document.getElementById('myspan').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        jsonPopulate();
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }    


            function startContents() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                //document.getElementById('myspan').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        jsonPopulate("start");
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }          

            function authContents() {
   	
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                //document.getElementById('authspan').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {	
                    if (http_request.status == 200) {
                        var time = new Date();
                        authPopulate();
                        time = new Date();
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }    

            function jsonPopulate(opt) {
                var resp =  http_request.responseText;
                //alert(resp);
                var myJSONObject = eval('(' + resp + ')');
                var tableString = "<form name=\"submitform\"><fieldset><div class=\"closeIt\"> <a href=\"#\" onclick=\"javascript:hideform('myspan');\">close | x</a></div><legend><b>Select Criteria</b></legend><div  id=\"authDetailMedium\" ><table  id=\"critTable\" cellspacing=\"0\" >";
                
                var argString = "";
                
                tableString += "<thead>";
                tableString += "<tr>";
                tableString += "<th scope=\"col\">Apply</th>";
                tableString += "<th scope=\"col\">Criteria Name</th>";
                tableString += "<th scope=\"col\">Value</th>";
//              tableString += "<th scope=\"col\">Pick-List</th>";
                tableString += "</tr>";
                tableString += "</thead>";

                //tableString += "<tbody id=\"critBody\">";
       
                for(var i = 0; i < myJSONObject.criteria.length; i++) {
                    tableString += "<tr>";
                    
                    // Check boxes
               	    // If criteria value cannot be changed, disable the checkbox
                    if (myJSONObject.criteria[i].apply == "Y") {
                    	if (myJSONObject.criteria[i].noChange == "Y") 
                        	tableString += "<td><input type=checkbox name=\"apply\" value=\"a_" + myJSONObject.criteria[i].criteriaId + "\" id=\"a_" + myJSONObject.criteria[i].criteriaId + "\" checked disabled></td>";
                   	else
                        	tableString += "<td><input type=checkbox name=\"apply\" value=\"a_" + myJSONObject.criteria[i].criteriaId + "\" id=\"a_" + myJSONObject.criteria[i].criteriaId + "\" checked></td>";
                   	
                   }
                   else 
                   {
                    	if (myJSONObject.criteria[i].noChange == "Y") 
                        	tableString += "<td><input type=checkbox name=\"apply\" value=\"a_" + myJSONObject.criteria[i].criteriaId + "\" id=\"a_" + myJSONObject.criteria[i].criteriaId + "\" disabled></td>";
			else 
                        	tableString += "<td><input type=checkbox name=\"apply\" value=\"a_" + myJSONObject.criteria[i].criteriaId + "\" id=\"a_" + myJSONObject.criteria[i].criteriaId + "\" ></td>";
 		   }
                   tableString += "<td scope=\"row\"> <b>" + myJSONObject.criteria[i].criteriaName + "</b></td>";
                   if (myJSONObject.criteria[i].noChange == "Y") {
                        tableString += "<td><input type=text name=\"v_" + myJSONObject.criteria[i].criteriaId + "\" id=\"v_" + myJSONObject.criteria[i].criteriaId + "\" value=\"" + myJSONObject.criteria[i].value + "\" disabled></td>";
                    }
                    else {
                        //tableString += "<td><input type=text name=\"v_" + myJSONObject.criteria[i].criteriaId + "\" id=\"v_" + myJSONObject.criteria[i].criteriaId + "\" value=\"" + myJSONObject.criteria[i].value + "\"></td>";
                        tableString += getWidget(myJSONObject.criteria[i].nextScreen, myJSONObject.criteria[i].criteriaId, myJSONObject.criteria[i].value, myJSONObject.criteria[i].widget);
                        //alert(myJSONObject.criteria[i].criteriaId + ' ' + myJSONObject.criteria[i].value);
  
                    }
                    tableString += "</tr>";

                }
                tableString += "</table></div></fieldset></form>";      
                tableString += "<button id=\"findmatchauth\" name=\"newauth\" onclick=\"javascript:clearErrorMessage();init_check_list();get_auth();\">Find Matching Authorizations</button>";
                tableString += "<input type='button' id='savecrit' name='savecrit' onclick=\"javascript:clearErrorMessage();saveCriteria();\" value=\"Save Default Criteria\" title='Save these criteria for the lookup set chosen above' /><br clear=\"all\" />";

                document.getElementById('myspan').innerHTML = tableString;
                document.getElementById('loading').innerHTML = "";   
                populateWidgets();
                init_validate();
                if(document.getElementById('myspan').style.display == "none") {
                    document.getElementById('myspan').style.display="block";
                }
                widget_list="";
            }

	function init_check_list()
	{
		checked_ids = "";
	}

	function changeBatchuser()
	{
		 selCounter();
	}

	function authPopulate() {
                var resp =  http_request.responseText;
                //alert(resp);
                if (resp.indexOf("\"authorizations\"") == -1) {
                    document.getElementById('authspan').innerHTML = "<div class='alert'>" + resp + "</div>";
                    if (resp == "null") {
                        document.getElementById('authspan').innerHTML = "<div class='alert'>Please select at least one criteria for your search.</div>";
                    }
                }
                else {


                var myJSONObject = eval('(' + resp + ')');
              
	
                //var tableString = "<table id=\"authTable\" cellpadding=5 border=1>";
                var tableString = "<h2>" + currentSelTitle + "</h2><form name=\"checkform\" id=\"checkform\"><table id=\"authTable\" cellspacing=\"0\">";
                var argString = "";
                tableString += "<thead id=\"authHead\">";
                tableString += "<tr>";
                tableString += "<th class=\"bkgrndgcolor\" nowrap=\"nowrap\">Select<br /><input type=\"checkbox\" name=\"selectall\" id=\"selectall1\" onclick=\"javascript:selectAll(1);\" \></th>";
		tableString += "<th class=\"bkgrndgcolor\">View</th>";
                tableString += "<th class=\"sortcol\"><a href=\"\" onclick=\"return sortTable('authBody', 2, true)\">Kerberos Name</a></th>";
                tableString += "<th class=\"sortcol\"><a href=\"\" onclick=\"return sortTable('authBody', 3, true)\">Category</a></th>";
                tableString += "<th class=\"sortcol\"><a href=\"\" onclick=\"return sortTable('authBody', 4, true)\">Function Name</a></th>";
                tableString += "<th class=\"sortcol\"><a href=\"\" onclick=\"return sortTable('authBody', 5, true)\">Qualifier Code</a></th>";
                tableString += "<th class=\"sortcol\"><a href=\"\" onclick=\"return sortTable('authBody', 6, true)\">Qualifier</a></th>";
                tableString += "<th class=\"bkgrndgcolor\">Effective Date</th>";

                tableString += "</tr></thead>";
                tableString += "<tfoot>";
  
                tableString += "<tr>";
                tableString += "<th class=\"bkgrndgcolor\" nowrap=\"nowrap\"><input type=\"checkbox\" name=\"selectall\" id=\"selectall2\" onclick=\"javascript:selectAll(2);\" \><br />Select</th>";

                tableString += "<td colspan=\"2\"><label for=\"batchdel\" id=\"numSel\">[ 0 ] selected</label>";
                tableString += "<input type='button' name='selectallrows' value='Select All' onclick=\"javascript:selectAll(3);\"> ";      
                tableString += "<input class=\"disbutton\" type='button' name='batchdel' value='Delete Selected' onclick=\"javascript:batchDelete();\"></td>";      
                tableString += "<td colspan=\"3\"><label for=\"batchusername\">Copy/Reassign selected authorization(s) to new user</label><span class=\"formHint\">To (Kerberos name): </span><input type='text' id='batchusername' name='batchusername' onchange='javascript:changeBatchuser()'> <br><input class=\"disbutton\" type='button' name='batchcreate' value='Copy Selected' title='Copy to the new user' onclick=\"javascript:batchCreate();\" disabled=\"disabled\"><input class=\"disbutton\" type='button' name='batchreplace' value='Reassign Selected' title='Remove from current user and add to the new user' onclick=\"javascript:batchReplace();\" disabled=\"disabled\"></td>";
                tableString += "<td colspan=\"2\"><label>Change Expiration Date(s): </label><span class=\"formHint\">To:</span><input type='text' id='batchupdateexp' name='batchupdateexp' onchange='javascript:selCounter();' value=\"mm/dd/yyyy\" size=\"10\"> <input class=\"disbutton\" type='button' name='batchup' value='Change' onclick=\"javascript:batchUpdate();\" disabled=\"disabled\"></td>";      
                tableString += "</tr>"; 
                tableString += "<tr><td></td> </tr><tr><td></td> </tr><tr><td></td> </tr><tr><td></td> </tr><tr><td></td> </tr> <tr><td></td> </tr><tr><td></td> </tr><tr><td/></tr><tr> <td/> <td/> <td/> <td/> <td/><td/><td/><td><a href=\"https://rolesweb.mit.edu\"><B>Go to Permit web Home</B></a></td>  </tr>";
                tableString += "</tfoot>";
                tableString += "<tbody id=\"authBody\">";
		var str = "";
	 
		for(var i = 0; i < myJSONObject.authorizations.length; i++) 
		{
                    var row_class = "";
                    var row_id = "#row_" + myJSONObject.authorizations[i].authorizationID;
		
                    if (myJSONObject.authorizations[i].active == "true") 
                    {
                          row_class = "viewauthcol";
                    }
                    else 	
                    {
                          row_class = "viewauthcol_disabled";
                    }
		
		
                    str = 	str+	"<tr id='" + row_id + "'"+ " class='" + row_class +"'>"
				    			+ "<td><input value='" + myJSONObject.authorizations[i].authorizationID + "'" +  " id='check' name='check' type='checkbox'>"
				    			+ "</td><td><a id=\""+ myJSONObject.authorizations[i].authorizationID + "\"" + " href=\"#\" title=\"View more info about this Authorization\"> <img src=\"img/magnifying-glass-16x16.gif\" alt=\"\" height=\"16\" width=\"16\"></a>"
				    			+ "</td><td>" + myJSONObject.authorizations[i].kerberosName 
				    			+ "</td><td>" + myJSONObject.authorizations[i].category 
				    			+ "</td><td>" + myJSONObject.authorizations[i].functionName   
				    			+ "</td><td>" + myJSONObject.authorizations[i].qualifierCode 
				    			+ "</td><td>" + myJSONObject.authorizations[i].qualifierName
				    			+ "</td><td>" + myJSONObject.authorizations[i].effectiveDate + " - " + myJSONObject.authorizations[i].expirationDate 
		    					+ "</td></tr>";  


		}
            tableString += str;		
            tableString += "</tbody></table></form>";

            var newdiv = document.createElement("div");
            newdiv.innerHTML = tableString;
            var container = document.getElementById("authspan");
            container.appendChild(newdiv);
		
            for(var i = 0; i < myJSONObject.authorizations.length; i++) 
            {
		
                   argString = "\"" + myJSONObject.authorizations[i].kerberosName + "\" , \"" + myJSONObject.authorizations[i].category + "\" , \"" 
                    + myJSONObject.authorizations[i].functionName       + "\" , \"" + myJSONObject.authorizations[i].qualifierName   + "\" , \"" 
                    + myJSONObject.authorizations[i].qualifierCode      + "\" , \"" + myJSONObject.authorizations[i].authorizationID + "\" , \""
                    + myJSONObject.authorizations[i].effectiveDate      + "\" , \"" + myJSONObject.authorizations[i].expirationDate  + "\" , \""
                    + myJSONObject.authorizations[i].qualifierType      + "\" , \"" + myJSONObject.authorizations[i].modifiedBy      + "\" , \""
                    + myJSONObject.authorizations[i].modifiedDate       + "\" , \"" + myJSONObject.authorizations[i].doFunction      + "\" , \""
                    + myJSONObject.authorizations[i].grantAuthorization + "\" , \"" + myJSONObject.authorizations[i].firstName       + "\" , \""
                    + myJSONObject.authorizations[i].lastName           + "\"";      

                    //alert(myJSONObject.authorizations[i].firstName + " " + myJSONObject.authorizations[i].lastName);

                    argString = argString.replace("'", "&apos");

                    var jq_id       = "#" + myJSONObject.authorizations[i].authorizationID;
                    var row_auth_id = "#row_" + myJSONObject.authorizations[i].authorizationID;
                    var kname       =     myJSONObject.authorizations[i].kerberosName;
		    var cat         =       myJSONObject.authorizations[i].category;
		    var fname       =     myJSONObject.authorizations[i].functionName;
		    var fdesc       =     myJSONObject.authorizations[i].functionDesc;
		    var qname       =     myJSONObject.authorizations[i].qualifierName;
		    var qcode       =     myJSONObject.authorizations[i].qualifierCode;
		    var authid      =    myJSONObject.authorizations[i].authorizationID;
		    var effdate     =   myJSONObject.authorizations[i].effectiveDate;
		    var expdate     =   myJSONObject.authorizations[i].expirationDate;
		    var qtype       =     myJSONObject.authorizations[i].qualifierType;
		    var modby       =     myJSONObject.authorizations[i].modifiedBy;
		    var moddate     =   myJSONObject.authorizations[i].modifiedDate;
		    var dofunc      =    myJSONObject.authorizations[i].doFunction;
		    var grantauth   = myJSONObject.authorizations[i].grantAuthorization;
		    var firstName   = myJSONObject.authorizations[i].firstName; 
		    var lastName    = myJSONObject.authorizations[i].lastName;
		    var authId      = myJSONObject.authorizations[i].authorizationID;
		
		   init_ahref(jq_id, authId,kname, cat, fname,fdesc, qname, qcode, authid, effdate, expdate, qtype, modby, moddate, dofunc, grantauth, firstName, lastName);
		   init_dblclick(row_auth_id, authId,kname, cat, fname,fdesc, qname, qcode, authid, effdate, expdate, qtype, modby, moddate, dofunc, grantauth, firstName, lastName);
		}
		 selCounter();
            }
            document.getElementById('loading').innerHTML = ""; 
            init_ac("batchusername");
            init_date("batchupdateeff");
            init_date("batchupdateexp");
            init_checkbox("#check");
         }
            
        function selectBatchButtons()
        {
            alert('selected');
        }

            function getWidget(id, crit, value, widget) {

               
                if (widget == "1") {
                    widget_list+= "a_v_" + crit + "||";
                    return("<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('" + crit + "');\"> </td>");
                }
                if (widget == "2") {
                    widget_list+= "d_v_" + crit + "||";
                    return("<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('" + crit + "');\" class=\"required date\"></td>");
                }
                //if (crit == "210") {
                if (widget == "3") {
                    selected_category=value;
                    return widget_selector("category");
                }
                //if (crit == "215") {
                if (widget == "4") {
                    selected_function=value;
                    widget_list+="functions||";
                    return widget_selector("function");
                }
                if (crit == "220" || crit == "221" || crit == "229"  )
		{
                        return "<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('\" + crit + \"');\">" +
                        "<a href=\"#\" id=\"qualifier_link\" onclick=\"javascript:get_crit_quals(this.parentNode);\">Lookup Qualifiers</a>"
			+ "</td>";
		}
                if (crit == "230"  )
		{
			return "<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('\" + crit + \"');\">" +
			"<a href=\"#\" id=\"qualifier_link\" onclick=\"javascript:get_qualtype_quals(this.parentNode,'v_230','DEPT')\";\">Lookup Dept</a>"
			+ "</td>";
		}               
                if (crit == "231"  )
		{
			return "<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('\" + crit + \"');\">" +
			"<a href=\"#\" id=\"qualifier_link\" onclick=\"javascript:get_qualtype_quals(this.parentNode,'v_231','DEPT')\";\">Lookup Dept</a>"
			+ "</td>";
		}               
				
                  if (crit == "225"  )
		{
			return "<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('\" + crit + \"');\">" +
			"<a href=\"#\" id=\"qualifier_link\" onclick=\"javascript:get_qualtype_quals(this.parentNode,'v_225','FUND')\";\">Lookup Funds</a>"
			+ "</td>";
		}              

                if (crit == "218"  )
		{
			return "<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('\" + crit + \"');\">" +
			"<a href=\"#\" id=\"qualifier_link\" onclick=\"javascript:get_qualtype_quals(this.parentNode,'v_218','')\";\">Lookup Qualifiers</a>"
			+ "</td>";
		}              

                if (widget == "5") {
                    if (value.indexOf("Y") >= 0) {
                        var ret_string = "<td><input type=\"radio\" name=\"v_" + crit + "\" id=\"y_v_" + crit + "\" value=\"Y\" onclick=\"javascript:check_it('" + crit + "');\" checked>Yes";
                        ret_string += "<input type=\"radio\" name=\"v_" + crit + "\" id=\"n_v_" + crit + "\" value=\"N\" onclick=\"javascript:check_it('" + crit + "');\">No</td>";
                    }
                    else {
                        var ret_string = "<td><input type=\"radio\" name=\"v_" + crit + "\" id=\"y_v_" + crit + "\" value=\"Y\" onclick=\"javascript:check_it('" + crit + "');\" >Yes";
                        ret_string += "<input type=\"radio\" name=\"v_" + crit + "\" id=\"n_v_" + crit + "\" value=\"N\" onclick=\"javascript:check_it('" + crit + "');\" checked >No</td>";
                    }
                    return ret_string;
                }
                else {
                    return("<td><input type=text name=\"v_" + crit + "\" id=\"v_" + crit + "\" value=\"" + value + "\" onchange=\"javascript:check_it('" + crit + "');\"></td>");
                }
            } 

            function widget_selector(name) {
                if (name == "category") {
                    return "<td><select id='v_210' name='v_210' onchange='javascript:list_functions_oc();'></select></td>";
                }
                else if (name=="function") {
                    return "<td><select id='v_215' name='v_215' onchange=\"javascript:check_it('215');\"></select></td>";
                }
            }

            function populateWidgets() {
                widget_list = widget_list.slice(0,-2);
                var widgets = widget_list.split("||");
                for (var i = 0; i < widgets.length; i++) {
                    if (widgets[i] == "functions") {
                        list_categories();
                    }
                    else if (widgets[i].indexOf("a_") != -1) {
                        var id = widgets[i].substring(2);
                        init_ac(id);
                    }
                    else if (widgets[i].indexOf("d_") != -1) {
                        var id = widgets[i].substring(2);
                        init_date(id);
                    }
                }
            }

            function check_it(id) {
                var ref =  "a_" + id;
                for (var i = 0; i < document.submitform.apply.length; i++) 
                {
                    if (document.submitform.apply[i].value == ref) {
                        document.submitform.apply[i].checked = true;
                    }
                }
            }

            function list_categories() {
                var getstr = "?";
                var time = new Date();
                getstr += "time=" + encode(time.getTime());
                genericRequest('listViewableCategories.jsp', getstr, catAlert);
            }
           
            function catAlert() {
                var matched = 0;
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        result_array = result.split("^^");
                        document.submitform.v_210.options.length = 0;
                        document.submitform.v_210.options[0] = new Option("Pick a Category", "");
                        for (var i = 0; i < result_array.length; i++) {
                            cat_display = result_array[i].split("||");
                            document.submitform.v_210.options[i+1] = new Option(cat_display[0] + " - " + cat_display[1], cat_display[0]);
                            // if (cat_globe != null && cat_globe != "") {
                            //    if (cat_globe.toUpperCase().replace(/^\s+|\s+$/g, '') == cat_display[0].toUpperCase().replace(/^\s+|\s+$/g, '')) {
                            //        document.submitform.v_210.options[i+1].selected=true;
                            //        matched = 1;
                            //    }
                            //} 
                            if (selected_category != null && selected_category != "") {
                                if (selected_category.toUpperCase().replace(/^\s+|\s+$/g, '') == cat_display[0].toUpperCase().replace(/^\s+|\s+$/g, '')) {
                                    document.submitform.v_210.options[i+1].selected=true;
                                    matched = 1;
                                }
                                cat_globe=selected_category;
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
                var getstr = "?";
                var time = new Date();
                getstr += "category=" + encode(cat_globe) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listViewableFunctions.jsp', getstr, funcAlert);
            }
            
             function list_functions_oc() {
                check_it('210');
                var cat = document.submitform.v_210[document.submitform.v_210.selectedIndex].value;
                func_globe = "";
                var getstr = "?";
                var time = new Date();
                getstr += "category=" + encode(cat) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listViewableFunctions.jsp', getstr, funcAlert);
            }
            
            function funcAlert() {
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        document.submitform.v_215.options.length=0;
                        if (document.submitform.v_210[document.submitform.v_210.selectedIndex].value != "") {
                            result = http_request.responseText;
                            result_array = result.split("^^");
                            for (var i = 0; i < result_array.length; i++) {
                                func_display = result_array[i].split("||");
                                document.submitform.v_215.options[i] = new Option(func_display[0], func_display[0]);
                                if (i == 0) {
                                  if (func_display[2] == "undefined") {
                                      //document.submitform.qualifier_type.value = "NULL";
                                      //document.submitform.qualifier_code.value = "NULL";
                                  }
                                  else {
                                      //document.submitform.qualifier_type.value = func_display[2];
                                  }
                                }
                                if (func_globe.toUpperCase() == func_display[0].toUpperCase()) {
                                    document.submitform.v_215.options[i].selected=true;
                                }
                                else if (selected_function.toUpperCase() == func_display[0].toUpperCase()) {
                                    document.submitform.v_215.options[i].selected=true;
                                }
                            }
                        }
                        document.getElementById('loading').innerHTML = "";   
                        if (start == "true") {
                            get_auth_start();
                        }
                   } else {
                        alert('There was a problem with the request.');
                    }
                }
            }       
             
            function get_qtype() {
                resetStatus();
                var cat = document.submitform.v_210[document.submitform.v_210.selectedIndex].value;
                var func = document.submitform.v_215[document.submitform.v_215.selectedIndex].value;
                var name = document.submitform.kerberos_name.value;
                var time = new Date();
                var getstr = "?";
                getstr += "category=" + cat + "&";
                getstr += "function_name=" + encode(func) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('getQualType.jsp', getstr, qualAlert);
            }    

            function qualAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.submitform.qualifier_type.value = result;
                        document.submitform.qualifier_code.value = "";
                        if (document.submitform.qualifier_type.value == "NULL") {
                            document.submitform.qualifier_code.value = "NULL";
                        }
                        document.submitform.qualifier_name.value = "";
                        document.getElementById('loading').innerHTML = "";   
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }

            function batchDelete() {
                
                if(confirm('Are you sure you want to delete all selected authorizations?'))
                {
                  var getstr = "?";
                  var time = new Date();
                  var boxes = document.checkform.check;
                  var ids = "";

               if (boxes.length != null)
               { 
                    for (i = 0; i < boxes.length; i++) {
                    if(boxes[i].checked) {
                        ids += boxes[i].value + ",";
                    }
                  }
               }
               else
               {
                     ids = boxes.value + ",";
               }
                  ids = ids.slice(0,-1);
                  getstr += "ids=" + encode(ids) + "&";
                  getstr += "time=" + encode(time.getTime());
                  
		// Save the Check Boxes in Auth table to keep them checked after bulk operations
		checked_ids = ids;
                  
                  genericRequest('batchDelete.jsp', getstr, updateContents);
                }
            }

            function batchCreate() {
                var getstr = "?";
                var time = new Date();
                var boxes = document.checkform.check;
                var ids = "";
                var kname = document.checkform.batchusername.value;

               if (boxes.length != null)
               { 
                    for (i = 0; i < boxes.length; i++) {
                    if(boxes[i].checked) {
                        ids += boxes[i].value + ",";
                    }
                  }
               }
               else
               {
                     ids = boxes.value + ",";
               }
                ids = ids.slice(0,-1);
                
                getstr += "ids=" + encode(ids) + "&";
                getstr += "kerberos_name=" + encode(kname) + "&";
                getstr += "time=" + encode(time.getTime());

		// Save the Check Boxes in Auth table to keep them checked after bulk operations
		checked_ids = ids;

                genericRequest('batchCreate.jsp', getstr, updateContents);
            }

            function batchReplace() {
                var getstr = "?";
                var time = new Date();
                var boxes = document.checkform.check;
                var ids = "";
                var kname = document.checkform.batchusername.value;

               if (boxes.length != null)
               { 
                    for (i = 0; i < boxes.length; i++) {
                    if(boxes[i].checked) {
                        ids += boxes[i].value + ",";
                    }
                  }
               }
               else
               {
                     ids = boxes.value + ",";
               }
               ids = ids.slice(0,-1);
                
                getstr += "ids=" + encode(ids) + "&";
                getstr += "kerberos_name=" + encode(kname) + "&";
                getstr += "time=" + encode(time.getTime());
                
		// Save the Check Boxes in Auth table to keep them checked after bulk operations
		checked_ids = ids;
                
                genericRequest('batchReplace.jsp', getstr, updateContents);
            }

	function batchUpdate() 
	{
                var getstr = "?";
                var time = new Date();
                var boxes = document.checkform.check;
                var ids = "";
                var expDate = document.checkform.batchupdateexp.value.replace(/\//g,"");
                
		var expDate_check = document.checkform.batchupdateexp.value;
		                
		var myregex = "(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d";
                
		if (expDate_check != ''  && !(expDate_check.match(myregex)) ) 
		{
			document.getElementById("requeststatus").innerHTML = "<font color=\"red\">Expiration Date must be in the format: mm/dd/yyyy</font>";
                }		
		else 
		{
                       document.getElementById("requeststatus").innerHTML = "";
                       if (boxes.length != null)
                       { 
                            for (i = 0; i < boxes.length; i++) {
                            if(boxes[i].checked) {
                                ids += boxes[i].value + ",";
                            }
                          }
                       }
                        else
                        {
                             ids = boxes.value + ",";
                        }                        
                        ids = ids.slice(0,-1);

			getstr += "ids=" + encode(ids) + "&";
			getstr += "effDate=&";
			getstr += "expDate=" + encode(expDate) + "&";
			getstr += "time=" + encode(time.getTime());

                        // Save the Check Boxes in Auth table to keep them checked after bulk operations
                        checked_ids = ids;
			genericRequest('batchUpdate.jsp', getstr, updateContents);
		}

 	
            }


	    function saveCriteria() 
            {
                var selectionId = currentSel;
                var criteriaList = "";
                var valueList= "";
                var applyList = "";
                var getstr = "?";
                var time = new Date();

		var criteriaCount = 0;
		document.getElementById('authspan').style.display="";

                for (var i = 0; i < document.submitform.apply.length; i++) 
                {
                    var id = document.submitform.apply[i].value.substring(2);
                    var val = document.getElementById("v_" + id);
                    criteriaList += id + ",";
                    if (val != null)
                    {
                      valueList += val.value + ",";
                    }
                    else
                    {
                    	valueList += 'null' + ",";
                    }
                    if (document.submitform.apply[i].checked) 
                    {
                        applyList += "Y,";
                        criteriaCount++;
                    }
                    else 
                    {
                        applyList += "N,";
                    }
                }
                if (criteriaCount > 0)
                {
			criteriaList = criteriaList.slice(0,-1);
			valueList = valueList.slice(0,-1);
			applyList = applyList.slice(0,-1);

			getstr += "selectionId=" + encode(selectionId) + "&";
			getstr += "criteriaList=" + encode(criteriaList) + "&";
			getstr += "valueList=" + encode(valueList) + "&";
			getstr += "applyList=" + encode(applyList) + "&";
			getstr += "time=" + encode(time.getTime());
			genericRequest('saveCriteria.jsp', getstr, saveCritAlert);
                }
                else
		{
			alert("You must select at least one selection criteria.")
                }
            }

            function saveCritAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Saving, please wait...</strong>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = currentSelTitle + " - " + http_request.responseText;
                        document.getElementById('authspan').innerHTML = "<div class='note'>"  + result + "</div>";
                        document.getElementById('loading').innerHTML = "";   
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            
            function selectAll(id) {
                var box;
                if (id == 1) {
                    box = document.checkform.selectall1;
                    document.checkform.selectall2.checked = box.checked;
                }
                else if (id == 2){
                    box = document.checkform.selectall2;
                    document.checkform.selectall1.checked = box.checked;
                }
                else
                {
                	
			document.checkform.selectall1.checked = true;
			document.checkform.selectall2.checked = true;
			box = document.checkform.selectall1;
                }
                var boxes = document.checkform.check;
                if (boxes.length != null)
                {
                    for (i = 0; i < boxes.length; i++) {
                        boxes[i].checked = box.checked;
                    }
                }
                else
                {
                        boxes.checked = box.checked;
                }
                selCounter();
                if (id !=1 && id!= 2)
                {
                        processHighLights();
                }
            }
            function processHighLights()
            {
               selCounter();
                highLightAuthorization();

            }

            function selCounter() {
              if (document.getElementById("check") != null) {
                var boxes = document.checkform.check;
                var counter = 0;
                if (boxes.length != null)
                {
                  for (i = 0; i < boxes.length; i++) {
                      if(boxes[i].checked == true) {
                          counter++;
                      }
                  }
                  updateNumSel(boxes.length,counter);
                }
                else
                {
                      if(boxes.checked == true) 
                      {
                          updateNumSel(1,1);
                      }
                      else
                      {
                          updateNumSel(1,0); 
                      }
                }
                        
                }
            }

            function updateNumSel(totalCount, selectedCount) {
                
                var myregex = "(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d";
                var expDate = document.checkform.batchupdateexp.value; 
                if (selectedCount > 0) {
                    document.checkform.batchdel.disabled=false;
                    document.checkform.batchdel.className="";
                    if (document.checkform.batchusername.value != null && document.checkform.batchusername.value.length > 0)
                    {
			    document.checkform.batchcreate.disabled=false;
			    document.checkform.batchreplace.disabled=false;

			    document.checkform.batchcreate.className="";
			    document.checkform.batchreplace.className="";

                    }
                    else
                    {
 			    document.checkform.batchcreate.disabled=true;
			    document.checkform.batchreplace.disabled=true;
			    document.checkform.batchcreate.className="disbutton";
			    document.checkform.batchreplace.className="disbutton";
                    }

                    if (document.checkform.batchupdateexp.value != '' && (document.checkform.batchupdateexp.value.length < 10 || !(expDate.match(myregex))))
                    {
                    	document.checkform.batchup.disabled=true;
		    	document.checkform.batchup.className="disbutton";
                    }
                    else
                    {
		    	
			 document.checkform.batchup.disabled=false;
			 document.checkform.batchup.className="";	    
		    	
		    }

                }
                else {
                    document.checkform.batchdel.disabled=true;
                    document.checkform.batchcreate.disabled=true;
                    document.checkform.batchreplace.disabled=true;
                    document.checkform.batchup.disabled=true;
                    document.checkform.batchdel.className="disbutton";
                    document.checkform.batchcreate.className="disbutton";
                    document.checkform.batchreplace.className="disbutton";
                     document.checkform.batchup.className="disbutton";
                }
                document.getElementById("numSel").innerHTML = "Total: " + totalCount + " - [ " + selectedCount + " ] selected";
            }

            function detailToggle() {
               id1 = "extra_detail";
               id2 = "detTog";
               if(document.getElementById(id1).style.display == "none") {
                 document.getElementById(id1).style.display="block";
                 document.getElementById(id2).innerHTML = "Less Detail";
               }
               else {
                 document.getElementById(id1).style.display="none";
                 document.getElementById(id2).innerHTML = "More Detail";
               }
            }

            function blankQualName() {
                document.authform.qualifier_name.value = "";
            }

            function blankPname() {
                if (document.authform.kerberos_name.value == '')
                {
                    document.authform.personname.value = "";
                }  
            }

	function resetAuthFormActions()
	{
                    document.authform.create.disabled=true;
                    document.authform.update.disabled=true;
                    document.authform.del.disabled=true;
                    document.authform.create.className="disbutton";
                    document.authform.update.className="disbutton";
                    document.authform.del.className="disbutton";
	}
        
        function clearErrorMessage()
        {
              document.getElementById('requeststatus').innerHTML = '' ;   
              document.getElementById('requeststatus2').innerHTML = '' ;             
        }

        //************************************************
        function updateContents() 
        {
        	
		document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
		if (http_request.readyState == 4) {
		  if (http_request.status == 200) 
		  {
                        result = http_request.responseText;
                        if (result.indexOf("||") != -1) 
                        {
                        	
                            result_array = result.split("||");
                            	document.getElementById('requeststatus').innerHTML = result_array[0] ;   
				document.getElementById('requeststatus2').innerHTML = result_array[0] ;  
                            document.authform.auth_id.value = result_array[1];
                        }
                        else 
                        {    
				document.getElementById('requeststatus').innerHTML = result;   
				document.getElementById('requeststatus2').innerHTML = result;  
				// reset button in authform
				resetAuthFormActions();

                        }
                        get_auth();
                        check_authid();
			// reset button in authform
			resetAuthFormActions();
                        
                        //document.getElementById('loading').innerHTML = ""; 
                        clearSelectFormMessage();

                  } 
                  else 
                  {
			alert('There was a problem with the request.');
                  }
                }
                

        }

            function qualContents() {
     
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;

                        document.getElementById('quallist').innerHTML = result;            
                        document.getElementById('quallist').style.display="block";
                        document.getElementById('loading').innerHTML = "";   
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }     
            
            function qualCritContents() {
	                    document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
	                    crit_list_qual_type = '';
	                    if (http_request.readyState == 4) {
	                        if (http_request.status == 200) {
	                            result = http_request.responseText;
	                            document.getElementById('quallist').innerHTML = result;            
	                            document.getElementById('quallist').style.display="block";
	                            document.getElementById('loading').innerHTML = "";  
	                            crit_list_qual_type = document.quallistform.qual_type.value;
	                        } else {
	                            alert('There was a problem with the request.');
	                            
	                        }
	                    }
            }  
            
            function newform() {
            
                newOrView = "new";

                var today = new Date();
                var year = today.getFullYear().toString();
                var month;
                var month_int = parseInt(today.getMonth().toString());
                month_int++;
                cat_globe = "";
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
                var date_string = month + "/" + day + "/" + year;
                
		document.getElementById("function_category").style.display=''; 
		document.getElementById("function_name").style.display=''; 
		document.getElementById("function_category_static").style.display="none"; 
		document.getElementById("function_name_static").style.display="none";                
                document.getElementById("qualifier_link").style.display='';
		document.getElementById("do_function").disabled=''; 	
		document.getElementById("grant_auth").disabled=''; 
		document.getElementById("kerberos_name").disabled = '';
		document.getElementById("personname").disabled = 'true';
		document.authform.do_function.checked = false;

              
                list_categories_authform_fill();
                resetStatus();
                document.authform.kerberos_name.value="";
                document.authform.personname.value="";
                document.authform.qualifier_code.value="";
                document.authform.qualifier_type.value="";
                document.authform.qualifier_name.value="";
                document.authform.auth_id.value="";
                document.authform.function_desc.value="";

                document.authform.modified_by.value="";
                document.authform.modified_date.value="";
                document.authform.effective_date.value=date_string;
                document.authform.expiration_date.value="";
                document.authform.do_function.checked=true;
                document.authform.grant_auth.checked=false;
                check_authid();
                document.getElementById("extra_detail").style.display="none";
                document.getElementById("detTog").innerHTML = "More Detail";
                document.getElementById("update").style.display = 'none';
                document.getElementById("del").style.display = 'none';
                

               
                document.authform.create.disabled=true;
		document.authform.create.className="disbutton";

 
            }
            
            
            function fillform(name, cat, func,funcDesc, qual, qualcode, auth_id, effdate, expdate, qualtype, modifiedby, modifieddate, dofunction, grantauth, firstName, lastName) {
                cat_globe = cat;
                name_globe = name;
                func_globe = func;
                newOrView = "view";
		majorChange = "false";
                
                 document.authform.kerberos_name.value=name;
                document.authform.personname.value=lastName + ", " + firstName;
		document.getElementById("personname").disabled = 'true';
                
                document.authform.function_name.value=func;
                document.authform.function_desc.value=funcDesc;
                
                document.authform.qualifier_code.value=qualcode;
                document.authform.qualifier_type.value=qualtype;
                document.authform.qualifier_name.value=qual.replace("&apos", "'");
                document.authform.auth_id.value=auth_id;
                document.authform.effective_date.value=effdate;
                document.authform.expiration_date.value=expdate;
                document.authform.modified_by.value=modifiedby;
                document.authform.modified_date.value=modifieddate;

                if (dofunction == "Y") {
                  document.authform.do_function.checked = true;
                }
                else {
                  document.authform.do_function.checked = false;
                }
                
                if (grantauth == "G") {
                  document.authform.grant_auth.checked = true;
                }
                else {
                  document.authform.grant_auth.checked = false;
                }                
                list_categories_authform_fill();
                resetStatus();
                check_authid();
                location.href = "#";
                document.getElementById("extra_detail").style.display="block";
                document.getElementById("detTog").innerHTML = "Less Detail";
                document.getElementById("update").style.display = '';
                document.getElementById("del").style.display = '';
                
                if (canChangeAuth == 'true')
                {
                	document.getElementById("kerberos_name").disabled = '';
                	
                	document.getElementById("function_category").style.display=''; 
                 	document.getElementById("function_name").style.display=''; 
               		document.getElementById("function_category_static").style.display="none"; 
			document.getElementById("function_name_static").style.display="none";
			
			
			document.getElementById("qualifier_code").disabled = '';
			document.getElementById("qualifier_link").style.display='';
			document.getElementById("effective_date").disabled = '';
			document.getElementById("expiration_date").disabled = '';

			
			document.getElementById("do_function").disabled=''; 	
			document.getElementById("grant_auth").disabled=''; 

			
			document.getElementById("update").style.display=''; 
			document.getElementById("del").style.display=''; 
			document.getElementById("create").style.display=''; 

                }
 		else
 		{
			document.getElementById("kerberos_name").disabled = "true";
			
			document.getElementById("function_category").style.display="none"; 
			document.getElementById("function_category_static").style.display=''; 
			document.getElementById("function_category_static").value=cat; 
			document.getElementById("function_category_static").disabled = "true";

			document.getElementById("function_name").style.display="none"; 
			document.getElementById("function_name_static").style.display=''; 
			document.getElementById("function_name_static").value=func; 
			document.getElementById("function_name_static").disabled = "true";
			
			document.getElementById("qualifier_code").disabled = "true";
			document.getElementById("qualifier_link").style.display="none";
			document.getElementById("effective_date").disabled = "true";
			document.getElementById("expiration_date").disabled = "true";
			
			
 			document.getElementById("do_function").disabled="true"; 	
			document.getElementById("grant_auth").disabled="true"; 	
			
			document.getElementById("update").style.display="none"; 
			document.getElementById("del").style.display="none"; 
			document.getElementById("create").style.display="none"; 
			
			

		}

                
            }
            
            function processEditableAuthFillForm(authorizationId)
            {
                    var getstr = "?";

                getstr += "authId=" + encode(authorizationId) + "&";
            	genericRequest('getEditableAuthorization.jsp', getstr, processAuthForm);

                
            }
            
	    function processAuthForm()
	    {
	    	    
	                    document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
	    	        
	                    if (http_request.readyState == 4) 
	                    {
	    	                if (http_request.status == 200) 
	    	                {
	    	                            result = http_request.responseText;
	    	                            
	    	                           
	    	                	    
					    var myJSONObject = eval('(' + result + ')');
						var kname =     myJSONObject.authorizations[0].kerberosName;
						var cat =       myJSONObject.authorizations[0].category;
						var fname =     myJSONObject.authorizations[0].functionName;
						var fdesc =     myJSONObject.authorizations[0].functionDesc;
						var qname =     myJSONObject.authorizations[0].qualifierName;
						var qcode =     myJSONObject.authorizations[0].qualifierCode;
						var authid =    myJSONObject.authorizations[0].authorizationID;
						var effdate =   myJSONObject.authorizations[0].effectiveDate;
						var expdate =   myJSONObject.authorizations[0].expirationDate;
						var qtype =     myJSONObject.authorizations[0].qualifierType;
						var modby =     myJSONObject.authorizations[0].modifiedBy;
						var moddate =   myJSONObject.authorizations[0].modifiedDate;
						var dofunc =    myJSONObject.authorizations[0].doFunction;
						var grantauth = myJSONObject.authorizations[0].grantAuthorization;
						var firstName = myJSONObject.authorizations[0].firstName; 
						var lastName  = myJSONObject.authorizations[0].lastName;
						canChangeAuth = myJSONObject.authorizations[0].isEditable;

					    fillform(kname, cat,
					             fname, fdesc,qname,
					             qcode, authid,
					             effdate, expdate,
					             qtype, modby,
					             moddate, dofunc,
					             grantauth, firstName, lastName);
	    	                	    
	    	                            
	    
	    	         	} 
	    	         	else 
	    	         	{
	    	                        
	    	         		alert('There was a problem with the request.');
	    	        	}
	                    }
	                    	                
	    }
 
            
            
            function canModifyOrCreateOrDelete( userName,  functionName,  qualifierCode)
            
            {
		resetStatus();
		var getstr = "?";
		getstr += "username=" + encode(userName.toUpperCase()) + "&"; // need to pass upper case 
		getstr += "function=" + encode(functionName) + "&";
		getstr += "qualifierCode=" + encode(qualifierCode);
		canChangeAuth = "false";
		genericRequest('checkAuthEditPermissions.jsp', getstr, canChangeAuthProcess);
            }     
            function canChangeAuthProcess()
	    {
	    
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
	        
                if (http_request.readyState == 4) 
                {
	                if (http_request.status == 200) 
	                {
	                            result = http_request.responseText;
	                            
	                            if (result == 'Y')
	                            {
	                              canChangeAuth = "true";
	                            }
	                            else
	                            {
	                              canChangeAuth = "false";
	                	    }
	                            

	         	} 
	         	else 
	         	{
	                        
	         		alert('There was a problem with the request.');
	        	}
                }
                	                
	    }
            
          function fill_crit_qual(code, name) {
            
                if (document.submitform.v_220 != null)
		{
                    document.submitform.v_220.value=code;
                }
                if (document.submitform.v_221 != null)
		{
                    document.submitform.v_221.value=code;
                }
                if (document.submitform.v_229 != null)
		{
                    document.submitform.v_229.value=code;
                }
                document.getElementById('quallist').innerHTML="";
                document.getElementById('quallist').style.display="none";
            }

          function fill_qualtype_qual(code, name) {
            
                if (currentQualTypeCriteriaId == 'v_230' && document.submitform.v_230 != null)
		{
                    document.submitform.v_230.value=code;
                }
                if (currentQualTypeCriteriaId == 'v_231' && document.submitform.v_231 != null)
		{
                    document.submitform.v_231.value=code;
                }
                if (currentQualTypeCriteriaId == 'v_225' && document.submitform.v_225 != null)
		{
                    document.submitform.v_225.value=code;
                }  
                if (currentQualTypeCriteriaId == 'v_218' && document.submitform.v_218 != null)
		{
                    document.submitform.v_218.value=code;
                }                    
                document.getElementById('quallist').innerHTML="";
                document.getElementById('quallist').style.display="none";
            }
            
          function fill_qual(code, name) {
                document.authform.qualifier_code.value=code;
                document.authform.qualifier_name.value=name;
                document.getElementById('quallist').innerHTML="";
                document.getElementById('quallist').style.display="none";
                checkFormReady(0);
            }
            
            function displayform() {
                if(document.getElementById('formspan').style.display == "none") {
                    document.getElementById('formspan').style.display="block";
                    check_authid();
                    //document.authform.kerberos_name.focus();
                    //var kname = document.authform.kerberos_name.value;
                    //if (kname != "" && kname != null) {
                    //  get_person_name(document.authform.kerberos_name.value);
                    //}
                    if (newOrView == "view") {
                        checkFormReady(1);
                    }
                    else {
                        checkFormReady(0);
                    }                    
                }
                else {
                    var selcat = document.authform.function_category[document.authform.function_category.selectedIndex].value;
                    checkAuthTest(selcat);
                }
             }
            
            function hideform(id) {
               if(document.getElementById(id).style.display != "none") {
                 document.getElementById(id).style.display="none";
               }
               var elements = getElementsByClass("ac_results");
               for (var i = 0; i < elements.length; i++) {
                    elements[i].style.display="none";
               }
            }

            function hidecrits() {
                if(document.getElementById('myspan').style.display != "none") {
                    document.getElementById('myspan').style.display="none";
                }
            }
        
            function toggle_span_visible(id) {
               var imgId = "img" + id;
               if(document.getElementById(id).style.display == "none") {
                 document.getElementById(id).style.display="block";
                 document.getElementById(imgId).src="img/minus.png";
               }
               else {
                 document.getElementById(id).style.display="none";
                   document.getElementById(imgId).src="img/plus.png";
               }
            }
            
            function clearSelectFormMessage()
            {
		document.getElementById('authspan').innerHTML = ""; 
          	document.getElementById('authspan').style.display="none";
            	
            }
            
            function create_auth() {
                var getstr = "?";
                var time = new Date();
                var effDate_check = document.authform.effective_date.value;
                var expDate_check = document.authform.expiration_date.value;
                

		var myregex = "(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d";
                
		if (!(effDate_check.match(myregex))) 
		{
                    document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
                    if (expDate_check != "" && !(expDate_check.match(myregex)) ) 
                    {
                        document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
                    }
                }
                else if (expDate_check != "" && !(expDate_check.match(myregex)) ) 
                {
                    document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
                }
                else 
                {
			var date1= getDateFromFormat(document.authform.effective_date.value,'mm/dd/yyyy');
			var date2= getDateFromFormat(document.authform.expiration_date.value,'mm/dd/yyyy');
			if (date1 == 0 || (document.authform.expiration_date.value != '' && date2 == 0))
			{
				document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
			}
			else if (document.authform.expiration_date.value != '' && date1 >= date2)
			{
				document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Expiration date cannot be same or earlier than Effective date</font>";
			}
			else 
			{
				document.getElementById("requeststatus2").innerHTML = "";
                
				var effDate = document.authform.effective_date.value.replace(/\//g,"");
				var expDate = document.authform.expiration_date.value.replace(/\//g,"");

				getstr += "kerberos_name="   + document.authform.kerberos_name.value + "&";
				getstr += "function_name="   + document.authform.function_name[document.authform.function_name.selectedIndex].value + "&";
				getstr += "qualifier_code="  + document.authform.qualifier_code.value + "&";
				getstr += "effective_date="  + effDate + "&";
				getstr += "expiration_date=" + expDate + "&";


				if (document.authform.do_function.checked) 
				{
				    getstr += "do_function="     + "Y&";
				}
				else 
				{
				    getstr += "do_function="     + "N&";
				}
				if (document.authform.grant_auth.checked) 
				{
				    getstr += "grant_auth="     + "G&";
				}
				else 
				{
				    getstr += "grant_auth="     + "N&";
				}
				getstr += "time=" + encode(time.getTime());
				
				genericRequest('ajaxResponse.jsp', getstr, updateContents);      
			}	
                }
                
            }   
            
            function update_auth(obj) 
            {
                var getstr = "?";
                var time = new Date();

                var effDate_check = document.authform.effective_date.value;
                var expDate_check = document.authform.expiration_date.value;
                
		var myregex = "(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d";
		                
		if (!(effDate_check.match(myregex)) ) 
		{
			document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
		}
                else if (expDate_check != "" && !(expDate_check.match(myregex)) ) 
                {
                    document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
                }

		else
		{
		
			var date1= getDateFromFormat(document.authform.effective_date.value,'mm/dd/yyyy');
			var date2= getDateFromFormat(document.authform.expiration_date.value,'mm/dd/yyyy');
			if (date1 == 0 || (document.authform.expiration_date.value != '' && date2 == 0))
			{
				document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Dates must be in the format: mm/dd/yyyy</font>";
			}
			else if (document.authform.expiration_date.value != '' && date1 >= date2)
			{
				document.getElementById("requeststatus2").innerHTML = "<font color=\"red\">Expiration date cannot be same or earlier than Effective date</font>";
			}
			else 
			{
				document.getElementById("requeststatus2").innerHTML = "";

				var effDate = document.authform.effective_date.value.replace(/\//g,"");
				var expDate = document.authform.expiration_date.value.replace(/\//g,"");


				getstr += "kerberos_name="   + document.authform.kerberos_name.value + "&";
				getstr += "function_name="   + document.authform.function_name[document.authform.function_name.selectedIndex].value + "&";
				getstr += "qualifier_code="  + document.authform.qualifier_code.value + "&";
				getstr += "effective_date="  + effDate + "&";
				getstr += "expiration_date=" + expDate + "&";
				getstr += "auth_id="         + document.authform.auth_id.value + "&";
				if (document.authform.do_function.checked) {
				    getstr += "do_function="     + "Y&";
				}
				else {
				    getstr += "do_function="     + "N&";
				}
				if (document.authform.grant_auth.checked) {
				    getstr += "grant_auth="     + "Y&";
				}
				else {
				    getstr += "grant_auth="     + "N&";
				}                
				getstr += "time=" + encode(time.getTime());
				genericRequest('updateAuthorizationResponse.jsp', getstr, updateContents);     
			}
		}	
            }
            
            function delete_auth(obj) {
            	if(confirm('Are you sure you want to delete this authorization?'))
                {
			var getstr = "?";
			var time = new Date();
			getstr += "kerberos_name=" + encode(document.authform.kerberos_name.value) + "&";
			getstr += "auth_id=" + encode(document.authform.auth_id.value) + "&";
			getstr += "time=" + encode(time.getTime());
			genericRequest('deleteAuthorizationResponse.jsp', getstr, updateContents);
			hideform('formspan');
                }
            }           

                  
           function get_crit_quals(obj) {
                var getstr = "?";
                var time = new Date();
                
 
                if (document.submitform.a_210.checked  == false || document.submitform.v_210.value  == null  || document.submitform.v_210.value  == '' 
                    ||  document.submitform.a_215.checked  == false || document.submitform.v_215.value == null || document.submitform.v_215.value == '')
                {
	                alert("Please select a Category and Function and select Apply checkbox of Category and Function in order to lookup for Qualifers");
                }
                else
                {
			getstr += "function_name="   + encode(document.submitform.v_215.value) + "&";
			getstr += "category="   + encode(document.submitform.v_210.value) + "&";
	                        getstr += "fill_function="     + encode("fill_crit_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_crit_quals") + "&";
			getstr += "time=" + encode(time.getTime());
			genericRequest('criteriaQualifierResponse.jsp', getstr, qualCritContents);  
                }
            }                 

          function get_qualtype_quals(obj, crit_id,qualtype) {
                var getstr = "?";
                var time = new Date();
                
                currentQualTypeCriteriaId = crit_id;
                
                // Special case... Crieteria set 173 and Authorizations related to qualifier_code
                if (qualtype == '' && crit_id == 'v_218')
                {
                    qualtype = document.submitform.v_219.value;    
                }
  	        getstr += "qualifier_type="    + encode(qualtype) + "&";
	        getstr += "fill_function="     + encode("fill_qualtype_qual") + "&";
	        getstr += "expand_function="   + encode("expand_qualtype_quals") + "&";
		getstr += "time=" + encode(time.getTime());
		genericRequest('criteriaQualifierResponse.jsp', getstr, qualCritContents);  

            }                 

            
	    function get_quals(obj) {

	                    var getstr = "?";
	                    var time = new Date();
	                    getstr += "function="   + encode(document.authform.function_name.value) + "&";
	                    getstr += "qtype="      + encode(document.authform.qualifier_type.value) + "&";
	                        getstr += "fill_function="     + encode("fill_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_quals") + "&";
	                    getstr += "time=" + encode(time.getTime());
	                    genericRequest('qualResponse.jsp', getstr, qualContents);  
	}            
            
            
            function get_quals_root(root_id) {
    
                var getstr = "?";
                var time = new Date();
                getstr += "root_id="   + root_id + "&";
                getstr += "root=true"  + "&";
                getstr += "qtype="     + encode(document.authform.qualifier_type.value) + "&";
	                        getstr += "fill_function="     + encode("fill_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_quals") + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('qualRootResponse.jsp', getstr, qualContents);  
            }                       
            
             function get_crit_quals_root(root_id) {
    
                var getstr = "?";
                var time = new Date();
                getstr += "root_id="   + root_id + "&";
                getstr += "root=true"  + "&";
                getstr += "qtype="     + encode(crit_list_qual_type) + "&";
	                        getstr += "fill_function="     + encode("fill_crit_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_crit_quals") + "&";
                getstr += "time=" + encode(time.getTime());
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
            
            function list_categories_authform() {

              resetStatus();
               var getstr = "?";
                var time = new Date();
                getstr += "username=" + encode(name_globe) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listPickableCategories.jsp', getstr, catAlert_auth);
            }
           
            function catAlert_auth() {
                var matched = 0;
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        result_array = result.split("^^");
                        document.authform.function_category.options.length = 0;
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
                        list_functions_auth();
                    } else {
                    
                        alert('There was a problem with the request.');
                    }
                }
            }
            
            function list_functions_auth() {
                resetStatus();
                var getstr = "?";
                var time = new Date();
                if (cat_globe.length <= 0)
                {
                        cat_globe = 'nothing';
                }
                getstr += "username=" + encode(name_globe) + "&";
                getstr += "category=" + encode(cat_globe) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listPickableFunctions.jsp', getstr, funcAlert_auth);
                
                
            }
            
             function list_functions_oc_auth() {
                 
                 resetStatus();
                
                var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;
                
                var name = document.authform.kerberos_name.value;
                func_globe = "";
                var getstr = "?";
                var time = new Date();
                if (cat.length <= 0)
                {
                        cat = 'nothing';
                        // set desc to empty
                        document.authform.function_desc.value = "";
                 }     
		document.authform.qualifier_type.value = "";
		document.authform.qualifier_code.value = "";
		document.authform.qualifier_name.value="";
		
                
                getstr += "username=" + encode(name) + "&";
                getstr += "category=" + encode(cat) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listPickableFunctions.jsp', getstr, funcAlert_auth);
               var qcode = document.authform.qualifier_code.value;
                var func = "";
           	if (document.authform.function_name.length > 0) {
                	func = document.authform.function_name[document.authform.function_name.selectedIndex].value;
            	
                }
   
            
                if (name.length == 0 || qcode.length == 0 || cat.length == 0 || func.length == 0) {
		                document.authform.create.disabled=true;
		                document.authform.update.disabled=true;
		                document.authform.del.disabled=true;
		                document.authform.create.className="disbutton";
		                document.authform.update.className="disbutton";
		                document.authform.del.className="disbutton";
            	}            
               
            }
            
            function funcAlert_auth() {
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
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
                                    document.authform.function_desc.value = func_display[1];
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
                  
                   } else {
                        alert('There was a problem with the request.');
                    }
                }
            }       
             
           
            function qualAlert_auth() {

                 document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
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
                        get_func_desc();	// Get function description after process qualifier code
                        
                        checkFormReady(0);
                        
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            	
            }
            
            
            function funcDescAlert() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.authform.function_desc.value = result;
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
                    getstr += "root_id="   + encode(id )+ "&";
                    getstr += "root=false" + "&";
	            getstr += "fill_function="     + encode("fill_qual") + "&";
                    getstr += "expand_function="     + encode("expand_quals") + "&";
                    getstr += "qtype="     + encode(document.authform.qualifier_type.value) + "&";
                    getstr += "time=" + encode(time.getTime());
              		
              	    genericRequest('qualExp.jsp', getstr, qualExpandContents);
                }
                else {
                    toggle_span_visible(id);
                }
            }
            
	   function expand_crit_quals(id) {
	      
	                    if (document.getElementById(id).innerHTML.toString().length < 2) {
	                    
	                        var getstr = "?";
	                        id_globe = id;
	                        var time = new Date();
	                        getstr += "root_id="   + encode(id )+ "&";
	                        getstr += "root=false" + "&";
	                        getstr += "qtype="     + encode(crit_list_qual_type) + "&";
	                        getstr += "fill_function="     + encode("fill_crit_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_crit_quals") + "&";
	                        getstr += "time=" + encode(time.getTime());
	                  		
                                genericRequest('qualExp.jsp', getstr, qualExpandContents);
	                    }
	                    else {
	                        toggle_span_visible(id);
	                    }
            }          
            
	   function expand_qualtype_quals(id) {
	      
	                    if (document.getElementById(id).innerHTML.toString().length < 2) {
	                    
	                        var getstr = "?";
	                        id_globe = id;
	                        var time = new Date();
	                        getstr += "root_id="   + encode(id )+ "&";
	                        getstr += "root=false" + "&";
	                        getstr += "qtype="     + encode(crit_list_qual_type) + "&";
	                        getstr += "fill_function="     + encode("fill_qualtype_qual") + "&";
	                        getstr += "expand_function="     + encode("expand_qualtype_quals") + "&";
	                        getstr += "time=" + encode(time.getTime());
	                  		
	                  	    genericRequest('qualExp.jsp', getstr, qualExpandContents);
	                    }
	                    else {
	                        toggle_span_visible(id);
	                    }
            }               
            
            function qualExpandContents() {
                document.getElementById(id_globe).innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        document.getElementById(id_globe).innerHTML = result;  
                        var imgId = "img" + id_globe;
                        document.getElementById(imgId).src="img/minus.png";
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }                   
            
            function viewcats() {
                
                resetStatus();
                
                var getstr = "?";
                
                var time = new Date();
                getstr += "time=" + encode(time.getTime());
                genericRequest('viewCatsResponse.jsp', getstr, viewcatAlert_auth);                
            }
            
            function viewcatAlert_auth() {
                document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
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

    function findValue(li) {
        
            var sValue = "";
            if( li != null ) {
            
            // if coming from an AJAX call, let's use the personname as the value
            if( !!li.extra ) 
                sValue = li.extra[0];

            // otherwise, let's just display the value in the text box
            else 
                 sValue = li[1];
             
             // truncate affiliation that comes along with the name   - other or - student or - staff
             var idx = sValue.search("-");
             if (idx > 0)
             {
                     sValue = sValue.substring(0,idx-1);
             }
              return sValue;
            }
            return "";
    }
    
        function findMitId(li) {
        
            var sValue = "";
            if( li != null ) {
            
            // if coming from an AJAX call, let's use the personname as the value
            if( !!li.extra ) 
            {
                 sValue = li.extra[2];
              }   
            
 
            // otherwise, let's just display the value in the text box
            else 
            {
                sValue = li.selectValue[2];
 
            }
         
              return sValue;
            }
            return "";
    }

        function selectItem(li) {
          var name = findValue(li);
            document.authform.personname.value = name;
              
        }
        
	function formatMatch(row, i, max) {
	            return row[0] +  " " +   row[1]    ;
	            
        }  
        
	function formatResult(row) {
            return row[0]     ;
                    
        }  
        function formatItem(row, i, max) {
            return row[0] +  " - " +  " <i> " + row[1] + "</i>"   ;
        }    

        function init_ac(id) {
            var ac = "#" + id;
            
                $(ac).autocomplete("listPersonRaw.jsp?sort=last&search=both&filter1=E&filter2=S&filter3=O", { minChars:3, formatMatch:formatMatch, formatResult:formatResult,  matchContains:true, cacheLength:200, max:300, highlight:false, onItemSelect:selectItem, 
                              formatItem:formatItem, scroll:true, selectOnly:1 });
        }
        
        function init_date(id){
                var date = "#" + id;
                var Yesterday = new Date();
                Yesterday.setDate(Yesterday.getDate() - 1);
                //$(date).datepicker({ dateFormat: 'mmddyy', minDate: Yesterday });
                $(date).datepicker({ dateFormat: 'mm/dd/yy',  showOn: 'button', buttonImage: 'img/calendar.gif', buttonImageOnly: true });
        }
        


        function init_ahref(jq_id, authId, kname, cat, fname, fdesc, qname, qcode, authid, effdate, expdate, qtype, modby, moddate, dofunc, grantauth, firstName, lastName) 
        {
            $(jq_id).click( function() {
            	hideform('formspan');
		
		processEditableAuthFillForm(authId);
                        });
        }

        function init_dblclick(jq_id, authId, kname, cat, fname, fdesc,qname, qcode, authid, effdate, expdate, qtype, modby, moddate, dofunc, grantauth, firstName, lastName) 
        {

            $(jq_id).dblclick( function() {
            	
            	hideform('formspan');
            	processEditableAuthFillForm(authId);
                        });
        }

        function init_checkbox(jq_id) {
            $(":checkbox").click( function() {
                selCounter();
                highLightAuthorization();
                        });
              // Restore check boxes in Auth table if the authorization is still in the table after the Bulk operation
              var idvals = checked_ids.split(',');
              var new_boxes = document.checkform.check;
              if (idvals.length > 0 && new_boxes.length > 0)
              {
                            for (i = 0; i < new_boxes.length; i++) 
                            {
                                    var auth_id = new_boxes[i].value;
                                    for (j=0;j<idvals.length;j++)
                                    {
                                            if (idvals[j] == auth_id)
                                            {

                                                    document.checkform.check[i].checked = true;
                                            }

                                    }
                            }
                }
        
         }

                  
        function list_selections() {
            var getstr = "?";
            var time = new Date();
            getstr += "time=" + encode(time.getTime());
            genericRequest('selectionList.jsp', getstr, selAlert);
        }
           
        function selAlert() {
            document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";   
            if (http_request.readyState == 4) {
                if (http_request.status == 200) {
                    selPopulate();
                } else {
                    alert('There was a problem with the request.');
                }
            }
        }

        function selPopulate() {
            var resp =  http_request.responseText;
            var j = eval('(' + resp + ')');
            
		var start_selection_id = '';
            for (var i = 0; i < j.selectionList.length; i++) {
                document.selectform.selection_id.options[i+1] = new Option(j.selectionList[i].selectionName, j.selectionList[i].id);
                    if (j.selectionList[i].flag=="Y") {
                        document.selectform.selection_id.options[i+1].selected=true;
                    }
                    if (i == 0)
                    {
                    	start_selection_id = j.selectionList[0].id;
                    }
            } 
            start_page(start_selection_id);
            document.getElementById('loading').innerHTML = "";
        }

        function getElementsByClass(searchClass,node,tag) {
            var classElements = new Array();
            if ( node == null )
            	node = document;
            if ( tag == null )
		tag = '*';
            var els = node.getElementsByTagName(tag);
            var elsLen = els.length;
            var pattern = new RegExp("(^|\\\\s)"+searchClass+"(\\\\s|$)");
            for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
            }
            return classElements;
        }


        function checkAuthTest(category) {
            var code =  "CAT" + category;
            var time = new Date();
            var getstr = "?";
            getstr += "qualifier_code=" + encode(code) + "&";
            getstr += "time=" + encode(time.getTime());
            genericRequest('checkAuthorization.jsp', getstr, checkAuthAlert);
        }   

        function checkAuthAlert() {
            if (http_request.readyState == 4) {
                if (http_request.status == 200) {
                    result = http_request.responseText;
                    if (result.indexOf("true") >= 0) {
                        checkFormReady(1);
                    }
                    else {
                        document.authform.create.disabled=true;
                        document.authform.update.disabled=true;
                        document.authform.del.disabled=true;   
                    }
                } else {
                    alert('There was a problem with the request.');
                }
            }
        }

        function get_qtype_auth() {
                resetStatus();   
                var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;

                var func = document.authform.function_name[document.authform.function_name.selectedIndex].value;
                var name = document.authform.kerberos_name.value;

                var time = new Date();
                var getstr = "?";
                getstr += "username=" + encode(name) + "&";
                getstr += "category=" + encode(cat) + "&";
                getstr += "function_name=" + encode(func) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('getQualType.jsp', getstr, qualAlert_auth);
                
                
            }    

      function get_func_desc() {
                resetStatus();   
                var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;

                var func = document.authform.function_name[document.authform.function_name.selectedIndex].value;
                var name = document.authform.kerberos_name.value;

                var getstr = "?";
                getstr += "username=" + encode(name) + "&";
                getstr += "category=" + encode(cat) + "&";
                getstr += "function_name=" + encode(func);
                genericRequest('getFunctionDesc.jsp', getstr, funcDescAlert);
            }    

        function checkFormReady(start) {
            var name = document.authform.kerberos_name.value;
            
            
            var qcode = document.authform.qualifier_code.value;
            var cat = document.authform.function_category[document.authform.function_category.selectedIndex].value;

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
            var date_string = month + "/" + day + "/" + year;

            if (document.authform.function_name.length > 0) {
                var func = document.authform.function_name[document.authform.function_name.selectedIndex].value;
            }
            else {
                var func = "";
            }
               
               //alert(qcode.length +  ':' + qcode);
            if (name.length > 0 && qcode.length > 0 && cat.length > 0 && func.length > 0) {
                if (newOrView == "new") {
                    document.authform.create.disabled=false;
                    document.authform.update.disabled=true;
                    document.authform.del.disabled=true;
                    document.authform.create.className="";
                    document.authform.update.className="disbutton";
                    document.authform.del.className="disbutton";
                }
                if (newOrView == "view") {
                    	if (start == 0) {
                    		majorChange = "true";
				document.authform.create.disabled=false;
				document.authform.update.disabled=false;
				document.authform.del.disabled=true;
				document.authform.create.className="";
				document.authform.update.className="";
				document.authform.del.className="disbutton";
			}
			else if (start == 2 && majorChange == 'false') {
		                        document.authform.update.disabled=false;
		                        document.authform.update.className="";
					document.authform.del.disabled=false;
					document.authform.del.className="";
                    }
                    else {
                    	if (majorChange == 'true')
                    	{
				document.authform.create.disabled=false;
				document.authform.create.className="";
				document.authform.update.disabled=true;
				document.authform.update.className="disbutton";
				document.authform.del.disabled=true;                       
 				document.authform.del.className="disbutton";
                   	}
                    	else
                    	{
				document.authform.create.disabled=true;
				document.authform.update.disabled=true;
				document.authform.del.disabled=false;                       
				document.authform.create.className="disbutton";
				document.authform.update.className="disbutton";
				document.authform.del.className="";
                    	}
                    }
                }
            }
            else {
                document.authform.create.disabled=true;
                document.authform.update.disabled=true;
                document.authform.del.disabled=true;
                document.authform.create.className="disbutton";
                document.authform.update.className="disbutton";
                document.authform.del.className="disbutton";
            }
        }



// Category listing from the fill_form action as opposed to the on change action.

            function list_categories_authform_fill() {
                resetStatus();
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + encode(name_globe )+ "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listPickableCategories.jsp', getstr, catAlert_auth_fill);
            }
           
            function catAlert_auth_fill() {
                var matched = 0;
                if (http_request.readyState == 4) {
                    if (http_request.status == 200) {
                        result = http_request.responseText;
                        result_array = result.split("^^");
                        document.authform.function_category.options.length = 0;
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
                        list_functions_auth_fill();
                    } else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            
            function list_functions_auth_fill() {
                resetStatus();   
                var getstr = "?";
                var time = new Date();
                getstr += "username=" + encode(name_globe) + "&";
                getstr += "category=" + encode(cat_globe) + "&";
                getstr += "time=" + encode(time.getTime());
                genericRequest('listPickableFunctions.jsp', getstr, funcAlert_auth_fill);
            }
           
            function funcAlert_auth_fill() {
                //document.getElementById('loading').innerHTML = "<img src='loading.gif'><strong>Loading, please wait...</strong>";
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
            
            // Reset status element to blank
            function resetStatus()
            {
                document.getElementById('requeststatus').innerHTML = "";    
                document.getElementById('requeststatus2').innerHTML = "";    
                
            }
            
            // ------------------------------------------------------------------
	    // getDateFromFormat( date_string , format_string )
	    //
	    // This function takes a date string and a format string. It matches
	    // If the date string matches the format string, it returns the 
	    // getTime() of the date. If it does not match, it returns 0.
	    // ------------------------------------------------------------------
	    function getDateFromFormat(val,format) {
	    	val=val+"";
	    	format=format+"";
	    	var i_val=0;
	    	var i_format=0;
	    	var c="";
	    	var token="";
	    	var token2="";
	    	var x,y;
	    	var now=new Date(val  );
	    	var year=now.getYear();
	    	var month=now.getMonth()+1;
	    	var date=1;
	    	var hh=now.getHours();
	    	var mm=now.getMinutes();
	    	var ss=now.getSeconds();
	    	var ampm="";
	    	
	    	while (i_format < format.length) {
	    		// Get next token from format string
	    		c=format.charAt(i_format);
	    		token="";
	    		while ((format.charAt(i_format)==c) && (i_format < format.length)) {
	    			token += format.charAt(i_format++);
	    			}
	    		// Extract contents of value based on format token
	    		if (token=="yyyy" || token=="yy" || token=="y") {
	    			if (token=="yyyy") { x=4;y=4; }
	    			if (token=="yy")   { x=2;y=2; }
	    			if (token=="y")    { x=2;y=4; }
	    			year=_getInt(val,i_val,x,y);
	    			if (year==null) { return 0; }
	    			i_val += year.length;
	    			if (year.length==2) {
	    				if (year > 70) { year=1900+(year-0); }
	    				else { year=2000+(year-0); }
	    				}
	    			}
	    		else if (token=="MMM"||token=="NNN"){
	    			month=0;
	    			for (var i=0; i<MONTH_NAMES.length; i++) {
	    				var month_name=MONTH_NAMES[i];
	    				if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) {
	    					if (token=="MMM"||(token=="NNN"&&i>11)) {
	    						month=i+1;
	    						if (month>12) { month -= 12; }
	    						i_val += month_name.length;
	    						break;
	    						}
	    					}
	    				}
	    			if ((month < 1)||(month>12)){return 0;}
	    			}
	    		else if (token=="EE"||token=="E"){
	    			for (var i=0; i<DAY_NAMES.length; i++) {
	    				var day_name=DAY_NAMES[i];
	    				if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) {
	    					i_val += day_name.length;
	    					break;
	    					}
	    				}
	    			}
	    		else if (token=="MM"||token=="M") {
	    			month=_getInt(val,i_val,token.length,2);
	    			if(month==null||(month<1)||(month>12)){return 0;}
	    			i_val+=month.length;}
	    		else if (token=="dd"||token=="d") {
	    			date=_getInt(val,i_val,token.length,2);
	    			if(date==null||(date<1)||(date>31)){return 0;}
	    			i_val+=date.length;}
	    		else if (token=="hh"||token=="h") {
	    			hh=_getInt(val,i_val,token.length,2);
	    			if(hh==null||(hh<1)||(hh>12)){return 0;}
	    			i_val+=hh.length;}
	    		else if (token=="HH"||token=="H") {
	    			hh=_getInt(val,i_val,token.length,2);
	    			if(hh==null||(hh<0)||(hh>23)){return 0;}
	    			i_val+=hh.length;}
	    		else if (token=="KK"||token=="K") {
	    			hh=_getInt(val,i_val,token.length,2);
	    			if(hh==null||(hh<0)||(hh>11)){return 0;}
	    			i_val+=hh.length;}
	    		else if (token=="kk"||token=="k") {
	    			hh=_getInt(val,i_val,token.length,2);
	    			if(hh==null||(hh<1)||(hh>24)){return 0;}
	    			i_val+=hh.length;hh--;}
	    		else if (token=="mm"||token=="m") {
	    			mm=_getInt(val,i_val,token.length,2);
	    			if(mm==null||(mm<0)||(mm>59)){return 0;}
	    			i_val+=mm.length;}
	    		else if (token=="ss"||token=="s") {
	    			ss=_getInt(val,i_val,token.length,2);
	    			if(ss==null||(ss<0)||(ss>59)){return 0;}
	    			i_val+=ss.length;}
	    		else if (token=="a") {
	    			if (val.substring(i_val,i_val+2).toLowerCase()=="am") {ampm="AM";}
	    			else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") {ampm="PM";}
	    			else {return 0;}
	    			i_val+=2;}
	    		else {
	    			if (val.substring(i_val,i_val+token.length)!=token) {return 0;}
	    			else {i_val+=token.length;}
	    			}
	    		}
	    	// If there are any trailing characters left in the value, it doesn't match
	    	if (i_val != val.length) { return 0; }
	    	// Is date valid for month?
	    	if (month==2) {
	    		// Check for leap year
	    		if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
	    			if (date > 29){ return 0; }
	    			}
	    		else { if (date > 28) { return 0; } }
	    		}
	    	if ((month==4)||(month==6)||(month==9)||(month==11)) {
	    		if (date > 30) { return 0; }
	    		}
	    	// Correct hours value
	    	if (hh<12 && ampm=="PM") { hh=hh-0+12; }
	    	else if (hh>11 && ampm=="AM") { hh-=12; }
	    	var newdate=new Date(year,month-1,date,hh,mm,ss);
	    	return newdate.getTime();
	    }
	    
	    // ------------------------------------------------------------------
	    // parseDate( date_string [, prefer_euro_format] )
	    //
	    // This function takes a date string and tries to match it to a
	    // number of possible date formats to get the value. It will try to
	    // match against the following international formats, in this order:
	    // y-M-d   MMM d, y   MMM d,y   y-MMM-d   d-MMM-y  MMM d
	    // M/d/y   M-d-y      M.d.y     MMM-d     M/d      M-d
	    // d/M/y   d-M-y      d.M.y     d-MMM     d/M      d-M
	    // A second argument may be passed to instruct the method to search
	    // for formats like d/M/y (european format) before M/d/y (American).
	    // Returns a Date object or null if no patterns match.
	  // ------------------------------------------------------------------
	  function parseDate(val) 
          {
                var preferEuro=(arguments.length==2)?arguments[1]:false;
                generalFormats=new Array('y-M-d','MMM d, y','MMM d,y','y-MMM-d','d-MMM-y','MMM d');
                monthFirst=new Array('M/d/y','M-d-y','M.d.y','MMM-d','M/d','M-d');
                dateFirst =new Array('d/M/y','d-M-y','d.M.y','d-MMM','d/M','d-M');
                var checkList=new Array('generalFormats',preferEuro?'dateFirst':'monthFirst',preferEuro?'monthFirst':'dateFirst');
                var d=null;
	    	for (var i=0; i<checkList.length; i++) 
                {
                  var l=window[checkList[i]];
                  for (var j=0; j<l.length; j++) {
	    		d=getDateFromFormat(val,l[j]);
	    		if (d!=0) { return new Date(d); }
                  }
	    	}
	    	return null;
          }

        // ------------------------------------------------------------------
        // Utility functions for parsing in getDateFromFormat()
        // ------------------------------------------------------------------
        function _isInteger(val) 
        {
              var digits="1234567890";
              for (var i=0; i < val.length; i++) 
              {
                  if (digits.indexOf(val.charAt(i))==-1) { return false; }
              }
              return true;
        }
        function _getInt(str,i,minlength,maxlength) 
        {
                for (var x=maxlength; x>=minlength; x--) 
                {
                  var token=str.substring(i,i+x);
                  if (token.length < minlength) { return null; }
                  if (_isInteger(token)) { return token; }
		}
                return null;
	}

        function encode(str) 
        {
		return escape(this._utf8_encode(str));
        }
 
	// public method for url decoding
        function decode  (str) 
        {
		return this._utf8_decode(unescape(str));
        }
 
        // private method for UTF-8 encoding
        function _utf8_encode (str) 
        {
		var utftext = "";
 
		for (var n = 0; n < str.length; n++) {
 
			var c = str.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
        }
 
      // method for UTF-8 decoding
      function _utf8_decode (utftext) 
      {
		var str = "";
		var i = 0;
		var c = c1 = c2 = 0;
 
		while ( i < utftext.length ) {
			c = utftext.charCodeAt(i);
			if (c < 128) {
				str += String.fromCharCode(c);
				i++;
			}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				str += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				str += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
                }
      }	

      function highLightAuthorization() 
      {
                  var time = new Date();
                  var boxes = document.checkform.check;
                  var ids = "";
                  if (boxes.length != null)
                  {
                      for (i = 0; i < boxes.length; i++) 
                      {
                         ids = boxes[i];
                         var row = "#row_" + boxes[i].value;  
                         if(boxes[i].checked) 
                         {
                                      var  c= document.getElementById(row).getAttribute("class"); 
                                      c = c.replace("d0", "");
                                      c = c.replace("d1", "");
                                      if (c.indexOf('disabled') > 0)
                                      {
                                        document.getElementById(row).setAttribute("class", c + " d1");
                                      }
                                      else
                                      {
                                        document.getElementById(row).setAttribute("class", c + " d0");
                                      }
                         }
                         else
                         {
                                      var  c1 = document.getElementById(row).getAttribute("class"); 
                                      if (null != c1)
                                      {
                                            c1 = c1.replace("d0", "");
                                            c1 = c1.replace("d1", "");
                                            document.getElementById(row).setAttribute("class", c1);
                                      }
                        }
                      }
                  }
                  else
                  {
                      var row = "#row_" + boxes.value;
                      if (boxes.checked)
                      {
                                   var  c= document.getElementById(row).getAttribute("class");
                                    c = c.replace("d0", "");
                                  c = c.replace("d1", "");
                                  if (c.indexOf('disabled') > 0)
                                  {
                                    document.getElementById(row).setAttribute("class", c + " d1");
                                  }
                                  else
                                  {
                                    document.getElementById(row).setAttribute("class", c + " d0");
                                  }
                      }
                      else
                      {
                                  var  c1 = document.getElementById(row).getAttribute("class");
                                  if (null != c1)
                                  {
                                        c1 = c1.replace("d0", "");
                                        c1 = c1.replace("d1", "");
                                        document.getElementById(row).setAttribute("class", c1);
                                  }
                      }
                  }
        }