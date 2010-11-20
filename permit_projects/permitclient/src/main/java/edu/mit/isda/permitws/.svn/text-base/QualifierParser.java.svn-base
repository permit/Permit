/*
 * QualifierParser.java
 * 
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
 *
 * Created on April 21, 2007, 12:26 AM
 * Copyright 2006 by the Massachusetts Institute of Technology.
 *
 *
 */

package edu.mit.isda.permitws;
import javax.xml.parsers.*;
import org.xml.sax.*;
import java.util.*;
import java.io.*;
import java.net.URLEncoder;
/**
 *
 */
public class QualifierParser extends org.xml.sax.helpers.DefaultHandler {
    private StringBuffer html = null;
    private StringBuffer line_text = null;
    //private StringBuffer root_link = null;
    private StringBuffer expand_link = null;
    private StringBuffer hcText = null;
    private StringBuffer idText = null;
    private StringBuffer nameText = null;
    private StringBuffer codeText = null;
    private StringBuffer eText = null;
    
    private String QUALIFIERS = "qualifiers";
    private String QUALIFIER = "qualifier";
    private String ID = "qid";
    private String NAME = "qname";
    private String CODE = "qcode";
    private String LEVEL = "level";
    private String HASCHILD = "hasChild";
    private String CHILDREN = "qchildren";
    private String EXPANDED = "expanded";
    private String out = "";
    
    private boolean append = true;
    private boolean url_append = false;
    private boolean bId = false;
    private boolean bName = false;
    private boolean bCode= false;
    private boolean bHasChild = false;
    private boolean bExpanded = false;
    private boolean expandable = false;
    private boolean expanded = true;
    private String qualiferFillFunction = "";
    private String qualifierType = "";
    private String exapandFunction = "";
    
    /** Creates a new instance of InputParser */
    public QualifierParser(InputStream xml, int level,String qualiferFillFunction, String expandFunction, String qualifierType) throws IOException{
        this.qualiferFillFunction = qualiferFillFunction;
        this.qualifierType = qualifierType;
        this.exapandFunction = expandFunction;
        html = new StringBuffer();
        try {    
            SAXParserFactory spf = SAXParserFactory.newInstance();
            spf.setNamespaceAware(true);
            SAXParser parser = spf.newSAXParser();
            parser.parse(xml, this);
        } catch (Exception e) {
            if (e.getMessage()!=null) {
                throw new IOException(e.getMessage());
            } else {
                throw new IOException("Error parsing Results xml: "
                        + e.getClass().getName());
            }
        }
    }    

    public QualifierParser(InputStream xml,String qualiferFillFunction, String expandFunction, String qualifierType) throws IOException{
        this(xml, 3, qualiferFillFunction,  expandFunction, qualifierType);
    }
        
     public void startElement(String uri, String localName, String qName, Attributes a) {
        //this is the start of a new one
        //note this will happen for each dissemination, but we don't care about
        //any except the FedoraObject. The others will get tossed
         
        if (localName.equalsIgnoreCase(QUALIFIERS)) {
            //html.append("\n<ul style = \"list-style-type:none\"><li>Qualifier List</li>");
            html.append("\n<form name=\"quallistform\"> <input type=\"hidden\" name=\"qual_type\" value=\"" + qualifierType + "\"> </form>\n");
            
        }
        
        if (localName.equalsIgnoreCase(QUALIFIER)) {
            html.append("\n<ul style = \"list-style-type:none\">");
        }
        if (localName.equalsIgnoreCase(ID)) {
            line_text = new StringBuffer();
            //root_link = new StringBuffer();
            idText = new StringBuffer();
            expand_link = new StringBuffer();
            line_text.append("\n<li>");
            //root_link.append("&nbsp;&nbsp;&nbsp;<a href=\"#anchor\" onclick=\"javascript:get_quals_root('");
            url_append = true;
            append = false;
            bId = true;
        }
        if (localName.equalsIgnoreCase(NAME)) {
            nameText = new StringBuffer();
            bName = true;
        }
        if (localName.equalsIgnoreCase(CODE)) {
            codeText = new StringBuffer();
            bCode = true;
        }
        if (localName.equalsIgnoreCase(LEVEL)) {
            append = false;
        }
        if (localName.equalsIgnoreCase(HASCHILD)) {
            hcText = new StringBuffer();
            append = false;
            bHasChild = true;
        }        
        if (localName.equalsIgnoreCase(EXPANDED)) {
            bExpanded = true;
            eText = new StringBuffer();
            append = false;
        }                
     }
      
    public void characters(char[] ch, int start, int length) {
        if (append) {
            line_text.append(ch, start, length);
            if (bCode) {
                line_text.append("</a>");
                
                try
                {
                    StringBuffer temp = new StringBuffer();
                    temp.append(ch,start,length);
                    String encodedStr = URLEncoder.encode(temp.toString(), "UTF-8");
                    //codeText.append(ch, start, length);
                    codeText.append(encodedStr);
                }
                catch(Exception e)
                {
                    
                }
                
            }
        }
        if (url_append) {
            //root_link.append(ch, start, length);
        }
        if (bHasChild) {
            hcText.append(ch, start, length);
            if (hcText.toString().equals("true")) {
                if (expanded) {
                    expand_link.append("<img src=\"img/minus.png\" id=\"img");
                        expand_link.append(idText.toString());
                    expand_link.append("\" onclick=\"javascript:toggle_span_visible('");
                        expand_link.append(idText.toString());                
                    expand_link.append("');\">&nbsp;");                    
                }
                else {
                    expand_link.append("<img src=\"img/plus.png\" id=\"img");
                        expand_link.append(idText.toString());
                    expand_link.append("\" onclick=\"javascript:" + exapandFunction+ "('");
                        expand_link.append(idText.toString());                

                    expand_link.append("');\">&nbsp;");                    
                }
                expandable = true;
            }
            else {
                expand_link.append(" <img src=\"img/empty.gif\">&nbsp;");
            }
        }
        if (bId) {
            idText.append(ch, start, length);
        }        
        if (bExpanded) {
            eText.append(ch, start, length);
            if (eText.toString().equals("true")) {
                expanded = true;
            }
            else {
                expanded = false;
            }
        }
        if (bName) {
            nameText.append(ch,start,length);
        }
    }
     
     public void endElement(String uri, String localName, String qName) throws SAXException {
        if (localName.equalsIgnoreCase(QUALIFIER)) {
            html.append("\n</span></ul>");
        }
        if (localName.equalsIgnoreCase(ID)) {
            //line_text.append(" - ");
            //root_link.append("');\"><b>&alpha;</b></a>");
            url_append = false;
            append = true;
            bId = false;
        }
        if (localName.equalsIgnoreCase(NAME)) {
            bName = false;
        }
        if (localName.equalsIgnoreCase(CODE)) {
            line_text.append(" - ");
            bCode = false;
        }
       if (localName.equalsIgnoreCase(LEVEL)) {
            append = true;
        }        
        if (localName.equalsIgnoreCase(HASCHILD)) {
            //line_text.append(root_link.toString());
            line_text.append(" </li>");
            expand_link.append("<a href=\"#anchor\" onclick=\"javascript:" + qualiferFillFunction + "('");
            expand_link.append(codeText.toString());

            expand_link.append("','");
            try
            {
                expand_link.append(URLEncoder.encode(nameText.toString().replace("'", " "),"UTF-8"));  
            }                
            catch(Exception e)
            {
                
            }
            expand_link.append("');\">");
            line_text.insert(5, expand_link.toString());
            if (expandable) {
                line_text.append("\n<span id=\"");
                line_text.append(idText.toString());                
                line_text.append("\">");
            }
            else {
                line_text.append("\n<span>");
            }
            html.append(line_text.toString());
            append = true;
            bHasChild = false;
            expandable = false;
        }                
        if (localName.equalsIgnoreCase(QUALIFIERS)) {
            //html.append("\n</ul>");
        }      
        if (localName.equalsIgnoreCase(EXPANDED)) {
            bExpanded = false;
            append = true;
        }             
     }
     
     public String getBuffer() {
         return html.toString();
     }
}