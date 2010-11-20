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
 * The Qualifier interface for roles service. 
 * <P>
 * Qualifiers can be Funds, Fund Centers, Organizational Units, etc.. 
 * (See a list of qualifier types.) In each Authorization, the type of Qualifier must 
 * fit the Function. For example, an Authorization for CAN SPEND OR COMMIT FUNDS must have 
 * a Qualifier of type "FUND" (Fund or Fund Center), whereas an Authorization for 
 * "REPORT BY CO/PC" must have a Qualifier of type COST (Profit Center or Cost Object). 
 * <P>
 * Some Functions, such as the various JV Functions, are either "on or off", and are not restricted 
 * by a Qualifier. (Or, in the case of "REQUISITIONER" or "CREDIT CARD VERIFIER", the Function is linked 
 * to the Qualifier on "CAN SPEND OR COMMIT FUNDS" authorizations.) All Authorizations for these 
 * Functions have a Qualifier of NULL. The Person is allowed to perform the Function, and NULL is
 * a simply a placeholder for the Qualifier field. 
 * <P>
 * Qualifiers are associated with a qualifier type and are organized into hierarchies. Qualifiers of a given 
 * qualifier type start at a root node, and include two or more levels. The qualifier component of an 
 * {@link Authorization} can be the root, a node, or a leaf within the tree. If an authorization applies to a
 * qualifier, it also implies that it applies to all the children of that qualifier.
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class Qualifier {
     private Long id;
     private String code;
     private String name;
     private Boolean hasChild;
     private Integer level;
     private QualifierType type;
     private Set<Qualifier> children = new HashSet<Qualifier>(0);
     private Set<Qualifier> parents = new HashSet<Qualifier>(0);

     // Constructors

     /** Creates a new instance of Qualifier */
     public Qualifier() {
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
     * Getter function for qualifier level in hierarchy
     *
     * @return qualifier level in hierarchy. the root level is 1. 
     */
    public Integer getLevel() {
        return this.level;
    }
    
    /**
     * Setter function for qualifier level in hierarchy
     *
     * @param level_in qualifier level in hierarchy. the root level is 1. 
     */
    public void setLevel(Integer level_in) {
        this.level = level_in;
    }
    
    
    /**
     * Getter function for qualifier type.
     *
     * @return qualifier type associated with the qualifier
     */
    public QualifierType getType() {
        return this.type;
    }
    
    /**
     * Setter function for qualifier type.
     *
     * @param type_in qualifier type associated with the qualifier
     */
    public void setType(QualifierType type_in) {
        this.type = type_in;
    }
   
    protected Set<Qualifier> getChildren() {
        return this.children;
    }
    
    protected void setChildren(Set<Qualifier> q) {
        this.children = q;
    }
    
     protected Set<Qualifier> getParents() {
        return this.parents;
    }
    
    protected void setParents(Set<Qualifier> q) {
        this.parents = q;
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
        s += "\nQualifier Level: ";
        if (level != null)
            s += level.toString();
      
        return s;
        
        
    }
    
}
