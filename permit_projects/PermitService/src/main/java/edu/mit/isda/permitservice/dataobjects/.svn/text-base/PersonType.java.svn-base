/*
 * PersonType.java
 * Created on July 5, 2006, 2:58 PM
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

/**
 * The Person Type interface for roles service.
 * <P> 
 * There are three types in the database: employee, student, and other
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class PersonType {
    private Character type;
    private String description;
    /** Creates a new instance of PersonType */
    public PersonType() {
    }
    
    /**
     * Getter function for person type.
     *
     * @return person's type. values are "S", "E", and "O"
     */
    public Character getType()
    {
        return type;
    }
    
    /**
     * Setter function for person type.
     *
     * @param type_in person's type. values are "S", "E", and "O"
     */
    public void setType(Character type_in)
    {
        type = type_in;
    }
    
    /**
     * Getter function for person type descriptiuon.
     *
     * @return person's type description. values are "Student", "Employee", and "Other"
     */
     public String getDescription()
    {
        return description;
    }
   
    /**
     * Setter function for person type descriptiuon.
     *
     * @param description_in person's type description. values are "Student", "Employee", and "Other"
     */
    public void setDescription(String description_in)
    {
        description = description_in;
    }
    
    /**
     * Stirng representation for the Person Type object. 
     *
     * @return A String representation for the Person Type object which has all the field names and values
     */
    public String toString()
    {
        String s;
        s = "Person Type: ";
        if (type != null)
            s += type;
        s+= "\nDescription: ";
        if (description != null)
            s += description;
        return s;
    }
    
}
