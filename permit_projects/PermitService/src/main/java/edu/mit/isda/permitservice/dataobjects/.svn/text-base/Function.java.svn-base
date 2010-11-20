/*
 * Function.java
 * Created on July 6, 2006, 1:02 PM
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
 * The Function interface for roles service. 
 * <P>
 * A function is what a person may do in {@link Authorization}. Functions are groups into {@link edu.mit.isda.permitservice.dataobjects.Category Categories}.
 * Examples of functions are "CAN SPEND OR COMMIT FUNDS', 'ENTER BUDEGES', ETC. 
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class Function {
    private int id;
    private String name;
    private String description;
    private Category category;
    private String creator;
    private String modifiedBy;
    private Date modifiedDate;
    private QualifierType fqt;
    private Character primaryAuthorizable;
    private Character isPrimaryAuthParent;
    private String primaryAuthGroup;
    
    /** Creates a new instance of Function */
    public Function() {
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
    public Category getCategory()
    {
        return category;
    }
    
    /**
     * Setter function for function category
     *
     * @param category_in input parameter for function category
     */
    public void setCategory(Category category_in)
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
     * Getter function for function creator.
     *
     * @return function creator's kerberos ID
     */
    public String getCreator()
    {
        return creator;
    }
    
    /** 
     * Setter function for function creator
     *
     * @param creator_in input parameter for function creator's kerberos ID
     */
    public void setCreator(String creator_in)
    {
        creator = creator;
    }
    
    /**
     * Getter function for function modified by. 
     *
     * @return kerberos ID of the user who last modified the function
     */
    public String getModifiedBy()
    {
        return modifiedBy;
    }
    
    /**
     * Setter function for function modified by.
     *
     * @param modifiedBy_in input parameter for the kerberos ID of the user who last modified the function
     */
    public void setModifiedBy(String modifiedBy_in)
    {
        modifiedBy = modifiedBy_in;
    }
    
    /**
     * Getter function for function modified date. 
     *
     * @return Date on which the function was last modified
     */
    public Date getModifiedDate()
    {
        return modifiedDate;
    }
    
    /**
     * Setter function for function modified date.
     *
     * @param modifiedDate_in input parameter for the date on which the function was last modified.
     */
    public void setModifiedDate(Date modifiedDate_in)
    {
        modifiedDate = modifiedDate_in;
    }
   
    /** 
     * Getter function for the qualifier type associated with the function.
     *
     * @return Qualifier Type associated with the function
     */
    public QualifierType getFqt()
    {
        return fqt;
    }
    
    /**
     * Setter function for the qualifier type associated with the function.
     *
     * @param fqt_in input parameter for qualifier type associated with the function.
     */
    public void setFqt(QualifierType fqt_in)
    {
        fqt = fqt_in;
    }
    
    /** 
     * Getter function for if the function is grantable by primary authorizer
     *
     * @return "D" for DLC-BASED, "Y" for yes, "N" for No. 
     */
    public Character getPrimaryAuthorizable()
    {
        return primaryAuthorizable;
    }
    
    /** 
     * Setter function for if the function is grantable by primary authorizer
     *
     * @param  primaryAuthorizable_in "D" for DLC-BASED, "Y" for yes, "N" for No. 
     */
    public void setPrimaryAuthorizable(Character primaryAuthorizable_in)
    {
        primaryAuthorizable = primaryAuthorizable_in;
    }
    
    /**
     * Getter function for is_primary_auth_parent
     *
     * @return "Y" for yes
     */
    public Character getIsPrimaryAuthParent()
    {
        return isPrimaryAuthParent;
    }
    
    
     /**
     * Setter function for is_primary_auth_parent
     *
     * @param isPrimaryAuthParent_in "Y" for yes
     */
    public void setIsPrimaryAuthParent(Character isPrimaryAuthParent_in)
    {
        isPrimaryAuthParent = isPrimaryAuthParent_in;
    }
    
    /**
     * Getter function for primary auth group. 
     *
     * @return "FIN" for financial primary authorizer, "HR" for HR primary authorizer
     */
    public String getPrimaryAuthGroup()
    {
        return primaryAuthGroup;
    }
    
    /**
     * Setter function for primary auth group. 
     *
     * @param primaryAuthGroup_in  "FIN" for financial primary authorizer, "HR" for HR primary authorizer
     */
    public void setPrimaryAuthGroup(String primaryAuthGroup_in)
    {
        primaryAuthGroup = primaryAuthGroup_in;
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
     //   s+="\nFunction Category: " + category.getCategory()+"("+category.getDescription()+")";
      //  s+="\nQualifier Type: " + fqt.getType()+"("+fqt.getDescription()+")";
        s+="\nCreator: ";
        if (creator != null)
            s += creator;
        s+="\nModified by: " ;
        if (modifiedBy != null)
            s += modifiedBy;
        s+="\nModified date: " ;
        if (modifiedDate != null)
            s +=  modifiedDate.toString();
        return s;
    }
    
    
}
