/*
 * LevelCount.java
 * Created on October 09, 2007, 11:12 PM
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


package edu.mit.isda.permitservice.dataobjects;
import  java.util.*;
/**
 *
 * @author  David Cohen
 * @version 1.0
 * @since 1.0
 */
public class LevelCount {
     private String value;
     private String parameter;

     // Constructors

    /** default constructor */
    public LevelCount() {
    }

    /**
     * getter function for the value field.
     *
     * @return value
     */ 
    public String getValue()
    {
        return value;
    }
    
    /**
     * setter function for the value field.
     *
     * @param value
     */  
    public void setValue(String value)
    {
        this.value = value;
    }
    

    /**
     * getter function for the parameter field.
     *
     * @return value
     */ 
    public String getParameter()
    {
        return parameter;
    }
    
    /**
     * setter function for the value field.
     *
     * @param value
     */  
    public void setParameter(String parameter)
    {
        this.parameter = parameter;
    }    
    
    /**
     * Stirng representation for the levelcount object. 
     *
     * @return A String representation for the levelcount object which has all the field names and values
     */
    public String toString()
    {
        String s ="";
        if (parameter != null)
            s += parameter;
        s += " = ";
        if (value!= null)
            s += value;
        return s;
    }
}
