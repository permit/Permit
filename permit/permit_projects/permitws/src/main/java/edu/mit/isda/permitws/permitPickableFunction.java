/*
 * rikesPickableFunction.java
 * Created on June 29, 2007, 1:02 PM
 * Author: David Cohen
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



package edu.mit.isda.permitws;

/**
 * The Function interface for roles service. 
 * <P>
 * A function is what a person may do in {@link Authorization}. Functions are groups into {@link edu.mit.isda.permitservice.dataobjects.Category Categories}.
 * Examples of functions are "CAN SPEND OR COMMIT FUNDS', 'ENTER BUDEGES', ETC. 
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class permitPickableFunction implements java.io.Serializable {
    private String kname;
    private int id;
    private String name;
    private String description;
    private String category;
    private String fqt;
        
    /** Creates a new instance of Function */
    public permitPickableFunction() {
    }
   
    /** 
     * Getter function for function name.
     *
     * @return function name
     */
    public String getKname()
    {
        return kname;
    }
    
    /**
     * Setter function for function name
     *
     * @param name_in input parameter for function name
     */
    public void setKname(String kname_in)
    {
        kname = kname_in;
    }
        
    /**
     * Getter function for ID.
     *
     * @return function Id, an identifier that uniquely identifies the function
     */
    public int getId()
    {
        return id;
    }
    
    /**
     * Setter function for ID
     *
     * @param id_in input parameter for identifier
     */
    public void setId(int id_in)
    {
        id = id_in;
    }
   
    /** 
     * Getter function for function name.
     *
     * @return function name
     */
    public String getName()
    {
        return name;
    }
    
    /**
     * Setter function for function name
     *
     * @param name_in input parameter for function name
     */
    public void setName(String name_in)
    {
        name = name_in;
    }
    
    /**
     * Getter function for function category.
     *
     * @return function category
     */
    public String getCategory()
    {
        return category;
    }
    
    /**
     * Setter function for function category
     *
     * @param category_in input parameter for function category
     */
    public void setCategory(String category_in)
    {
        category = category_in;
    }
    
    /**
     * Getter function for function description.
     *
     * @return function description
     */
     public String getDescription()
    {
        return description;
    }
     
     /** 
      * Setter function for function description.
      *
      * @param description_in input parameter for function description
      */
    public void setDescription(String description_in)
    {
        description = description_in;
    }
    
    /** 
     * Getter function for the qualifier type associated with the function.
     *
     * @return Qualifier Type associated with the function
     */
    public String getFqt()
    {
        return fqt;
    }
    
    /**
     * Setter function for the qualifier type associated with the function.
     *
     * @param fqt_in input parameter for qualifier type associated with the function.
     */
    public void setFqt(String fqt_in)
    {
        fqt = fqt_in;
    }
    
     /**
     * Stirng representation for the Function object. 
     *
     * @return A String representation for the Function object which has all the field names and values
     */
    public String toString()
    {
        String s;
        s ="Function Name: ";
        if (name != null)
            s += name;
        s+="\nFunction Description: ";
        if (description != null)
            s += description;
        return s;
    }
}