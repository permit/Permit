/*
 * Qualifier.java
 * Created on July 11, 2006, 3:21 PM
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
 * This is a class to get a single qualifier without grabbing every parent/child of that qualifier.
 *
 * Author: David Cohen
 * Date:   07/26/2007
 *
 */
public class QualBase {
     private Long id;
     private String code;
     private String name;
     private Boolean hasChild;

     // Constructors

     /** Creates a new instance of QualBase */
     public QualBase() {
    }

	
    /**
     * Getter function for qualifier ID.
     *
     * @return qualifier ID, an identifier that uniquely identifies the qualifier
     */
     public Long getId() {
        return this.id;
    }
    
    /**
     * Setter function for qualifier ID.
     *
     * @param id_in qualifier ID, an identifier that uniquely identifies the qualifier
     */
    public void setId(Long id_in) {
        this.id = id_in;
    }
    
    /**
     * Getter function for qualifier code.
     *
     * @return qualifier Code
     */
    public String getCode() {
        return this.code;
    }
    
    /**
     * Setter function for qualifier code.
     *
     * @param code_in qualifier Code
     */
    public void setCode(String code_in) {
        this.code = code_in;
    }
    
    /**
     * Getter function for qualifier name.
     *
     * @return qualifier name
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Setter function for qualifier name.
     *
     * @param name_in qualifier name
     */
    public void setName(String name_in) {
        this.name = name_in;
    }
    
    /**
     * Getter function for if qualifier has children.
     *
     * @return if qualifier has children. "N" for no, and "Y" for yes
     */
    public Boolean getHasChild() {
        return this.hasChild;
    }
    
    /**
     * Setter function for if qualifier has children.
     *
     * @param hasChild_in if qualifier has children. "N" for no, and "Y" for yes
     */
    public void setHasChild(Boolean hasChild_in) {
        this.hasChild = hasChild_in;
    }
    
    /**
     * Stirng representation for the Qualifier object. 
     *
     * @return A String representation for the Qualifier object which has all the field names and values
     */
    public String toString()
    {
        String s ;
        s = "Qualifier Id: ";
        if (id != null)
            s += id.toString();
        s += "\nQualifier Code: ";
        if (code != null)
            s += code;
        s += "\nQualifier Name: ";
        if (name != null)
            s += name;
     //   s += "\nQualifier Type: " + type.getDescription();
        s += "\nhas child: ";
        if (hasChild != null)
            s += hasChild ? "Y" :"N";
        return s;
    }
}
