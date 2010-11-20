<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Permit Person Quick Search</title>
<!--
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
-->

<link rel="stylesheet" type="text/css" media="screen" href="screen.css" />
<script src="jquery/jquery.js" type="text/javascript"></script>
<script src="custom.js" type="text/javascript"></script>
<script src="jquery/jquery.autocomplete.js" type="text/javascript"></script>
   
</head>
<body>
<h1>Person Quick Search</h1>
<br>
<style type="text/css">
.ac_input {
	width: 400px;
}
.ac_results {
	padding: 0px;
	border: 1px solid WindowFrame;
	background-color: Window;
	overflow:auto;
        height:200px;
        width:400px;
}

.ac_results ul {
	width: 100%;
	list-style-position: outside;
	list-style: none;
	padding: 0;
	margin: 0;
}

.ac_results iframe {
	display:none;/*sorry for IE5*/
	display/**/:block;/*sorry for IE5*/
	position:absolute;
	top:0;
	left:0;
	z-index:-1;
	filter:mask();
	width:200px;
	height:200px;
}

.ac_results li {
	margin: 0px;
	padding: 2px 5px;
	cursor: pointer;
	display: block;
	width: 100%;
	font: menu;
	font-size: 12px;
	overflow: hidden;
}
.ac_loading {
	background : url('jquery/indicator.gif') right center no-repeat;
}
.ac_over {
	background-color: Highlight;
	color: HighlightText;
}
</style>
<p>
    <b>Sort By: Type; Search By: Last Name, Kerberos Name; Filter: Show All</b>
    <br>
    <input id='v_205' name='v_205' type='text'> <input type="checkbox" id="toggle_v_205" checked disabled />
</p>
<hr>
<p>
    <b>Sort By: Last Name; Search By: Last Name; Filter: Show All</b>
    <br>    
    <input id='ac_me2' name='ac_me2' type='text'> <input type="checkbox" id="toggle_ac_me2" checked disabled />
</p>
<hr>
<p>
    <b>Sort By: Kerberos Name; Search By: Kerberos Name; Filter: Students, Employees</b>
    <br>    
    <input id='ac_me3' name='ac_me3' type='text'> <input type="checkbox" id="toggle_ac_me3" checked disabled />
</p>
<hr>
<p>
    <b>Sort By: Last Name; Search By: Last Name, Kerberos Name; Filter: Employees</b>
    <br>    
    <input id='ac_me4' name='ac_me4' type='text'> <input type="checkbox" id="toggle_ac_me4" checked disabled />
</p> 
<hr>
<p>
    <b>Sort By: Kerberos Name; Search By: Last Name, Kerberos Name; Filter: Student</b>
    <br>    
    <input id='ac_me5' name='ac_me5' type='text'> <input type="checkbox" id="toggle_ac_me5" checked disabled />
</p>
<!--
<p>
    <a href=# onclick="init_ac();">Click me</a>
</p> -->
<script type="text/javascript">         
function selectItem(li) {
}
function formatItem(row) {
	return row[0] + " <i>" + row[1] + "</i>";
}    
function init_ac() {
	$("#v_205").autocomplete("listPersonRaw.jsp?sort=type&search=both&filter1=E&filter2=S&filter3=O", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me2").autocomplete("listPersonRaw.jsp?sort=last&search=last&filter1=E&filter2=S&filter3=O", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me3").autocomplete("listPersonRaw.jsp?sort=kerberos&search=kerberos&filter1=E&filter2=S", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me4").autocomplete("listPersonRaw.jsp?sort=last&search=both&filter1=E", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me5").autocomplete("listPersonRaw.jsp?sort=kerberos&search=both&filter1=S", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
}

$(document).ready(function() {
	$("#v_205").autocomplete("listPersonRaw.jsp?sort=type&search=both&filter1=E&filter2=S&filter3=O", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me2").autocomplete("listPersonRaw.jsp?sort=last&search=last&filter1=E&filter2=S&filter3=O", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me3").autocomplete("listPersonRaw.jsp?sort=kerberos&search=kerberos&filter1=E&filter2=S", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me4").autocomplete("listPersonRaw.jsp?sort=last&search=both&filter1=E", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
        $("#ac_me5").autocomplete("listPersonRaw.jsp?sort=kerberos&search=both&filter1=S", { minChars:3, matchSubset:1, matchContains:1, cacheLength:10, onItemSelect:selectItem, formatItem:formatItem, selectOnly:1 });
});


</script>  	

</body>
</html>
