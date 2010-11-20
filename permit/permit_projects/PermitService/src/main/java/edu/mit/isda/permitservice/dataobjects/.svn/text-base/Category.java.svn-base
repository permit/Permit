/*
 * Category.java
 * Created on July 6, 2006, 1:43 PM
 * Author: Qing Dong
 */
/*
 *  Copyright (C) 2006-2010 Massachusetts Institute of Technology
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
public class Category {
    private String category;
    private String description;
    private Character authSensitive;
    private Set<Function> functions = new HashSet<Function>();
    /** Creates a new instance of Category */
    public Category() {
    }
    
    /**
     * getter function for the category code 
     * 
     * @return category code, such as SAP, WRHS
     */
    public String getCategory()
    {
        return category;
    }
    
    /**
     * Setter function for the category code 
     * 
     * @param categoryCode_in category code for the Category such as SAP, WRHS
     */
    public void setCategory(String categoryCode_in)
    {
        category = categoryCode_in;
            
    }
    
    /**
     * getter function for the category description
     * 
     * @return category description such as SAP, WAREHOUSE
     */
    public String getDescription()
    {
        return description;
    }
    
    /**
     * setter function for the category description
     *
     * @param description_in category description such as SAP, WAREHOUSE
     */
    public void setDescription(String description_in)
    {
        description = description_in;
    }
    
    /**
     * getter function for the auth sensitive field
     *
     * @return auth sensitive field
     */
    public Character getAuthSensitive()
    {
        return authSensitive;
    }
    
    /**
     * setter function for the auth sensitive field
     *
     * @param authSensitive_in auth sensitive field
     */
    public void setAuthSensitive(Character authSensitive_in)
    {
        authSensitive = authSensitive_in;
    }
    
    /**
     * getter function for the list of functions associated with the category
     *
     * @return a set of functions
     */
    protected Set<Function> getFunctions()
    {
        return functions;
    }
    
    /**
     * setter function for the list of functions associated with the category
     *
     * @param functions_in a set of functions
     */
    protected void setFunctions(Set<Function> functions_in)
    {
        functions = functions_in;
    }

    /**
     * Stirng representation for the Category object. 
     *
     * @return A String representation for the Category object which has all the field names and values
     */
    public String toString()
    {
        String s = "Category: ";
        if (category != null)
            s += category;
        s += "\nDescription: ";
        if (description != null)
            s += description;
        s += "\nAuth Sensitive: ";
        if (authSensitive != null)
            s += authSensitive;
        return s;
    }
    
}
