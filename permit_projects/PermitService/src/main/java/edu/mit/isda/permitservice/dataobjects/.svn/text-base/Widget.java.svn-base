/*
 * Widget.java
 * Created on November 19, 2:30 PM
 * Author: David Cohen
 */
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


package edu.mit.isda.permitservice.dataobjects;
import java.util.*;

/**
 * The Category interface for roles service. 
 * <P> 
 * Category is the application or system, such as SAP or the Data Warehouse, to which the {@link Authorization} 
 * applies. Each category is associated with a list of {@link edu.mit.isda.permitservice.dataobjects.Function Functions}
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
/**
                <id name="selection" type="string">
                    <column name="SELECTION_ID" sql-type="number(38)"/>
                    <generator class="assigned"/>
                </id>
                <property name="widgetId" column="PROGRAM_WIDGET_ID" length="38" />
                <property name="widgetName" column="PROGRAM_WIDGET_NAME" length="255" /> **/
public class Widget {
    private String selection;
    private String widgetId;
    private String widgetName;

    /** Creates a new instance of Category */
    public Widget() {
    }
    
    /**
     * getter function for the category code 
     * 
     * @return category code, such as SAP, WRHS
     */
    public String getSelection()
    {
        return selection;
    }
    
    /**
     * Setter function for the category code 
     * 
     * @param categoryCode_in category code for the Category such as SAP, WRHS
     */
    public void setSelection(String selection)
    {
        this.selection = selection;
            
    }
    
    /**
     * getter function for the category description
     * 
     * @return category description such as SAP, WAREHOUSE
     */
    public String getWidgetId()
    {
        return widgetId;
    }
    
    /**
     * setter function for the category description
     *
     * @param description_in category description such as SAP, WAREHOUSE
     */
    public void setWidgetId(String widgetId)
    {
        this.widgetId = widgetId;
    }
    
    /**
     * getter function for the category description
     * 
     * @return category description such as SAP, WAREHOUSE
     */
    public String getWidgetName()
    {
        return widgetName;
    }
    
    /**
     * setter function for the category description
     *
     * @param description_in category description such as SAP, WAREHOUSE
     */
    public void setWidgetName(String widgetName)
    {
        this.widgetName = widgetName;
    }    
    

    /**
     * Stirng representation for the Category object. 
     *
     * @return A String representation for the Category object which has all the field names and values
     */
    public String toString()
    {
        String s = "Selection ID: ";
        if (selection != null)
            s += selection;
        s += "\nWidget Id: ";
        if (widgetId != null)
            s += widgetId;
        s += "\nWidget Name: ";
        if (widgetName != null)
            s += widgetName;
        return s;
    }
    
}
