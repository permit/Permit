/*
 * QualifierType.java
 * Created on July 6, 2006, 2:31 PM
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
 * The Person Type interface for roles service. 
 * There are three types in the database: employee, student, and other
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class QualifierType {
    String type;
    String description;
    private Set<Qualifier> Qualifiers = new HashSet<Qualifier>();

    /** Creates a new instance of QualifierType */
    public QualifierType() {
    }
    
    /**
     * Getter function for qualifier type
     *
     * @return qualifier type
     */
    public String getType()
    {
        return type;
    }
    
    /**
     * Setter function for qualifier type
     *
     * @param type_in qualifier type
     */
    public void setType(String type_in)
    {
        type = type_in;
    }
    
    /**
     * Getter function for qualifier description
     *
     * @return qualifier description
     */
    public String getDescription()
    {
        return description;
    }
    
    /**
     * Setter function for qualifier description
     *
     * @param description_in  qualifier description
     */
    public void setDescription(String description_in)
    {
        description = description_in;
    }
   
    /**
     * Stirng representation for the Qualifier type object. 
     *
     * @return A String representation for the Qualifier type object which has all the field names and values
     */
    public String toString()
    {
        String s;
        s = "Qualifier Type: ";
        if (type != null)
            s += type;
        s += "\nQualifier Type Description: ";
        if (description != null)
            s+= description;
        return s;
        
    }
     protected Set<Qualifier> getQualifiers() {
        return this.Qualifiers;
    }
    
    protected void setQualifiers(Set<Qualifier> Qualifiers) {
        this.Qualifiers = Qualifiers;
    }

}
