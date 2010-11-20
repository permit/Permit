/*
 * Authorization.java
 * Created on July 14, 2006, 11:12 PM
 * Author: Qing Dong
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
import  java.util.*;
/**
 * The authorization interface for roles service. 
 *<P>
 * In the Roles Database, an Authorization is a rule that lets you perform a specific business function within a computer-based 
 * application. Authorizations have three main parts: {@link Person}, {@link Function}, and {@link Qualifier}, 
 * plus some flags and timestamp fields. A Person can perform a business Function limited by a Qualifier. 
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class EditableAuthorizationRaw {
     private AuthorizationPK authorizationPK;
     private Boolean isActiveNow;
     private String grantAuthorization;
     private String modifiedBy;
     private Date modifiedDate;
     private Character doFunction;
     private Date effectiveDate;
     private Date expirationDate;
     private String person;
     private String category;
     private String function;
     private String qualifierName;
     private String qualifierCode;
     private String qualifierType;
     private String firstName;
     private String lastName;
     private String functionDesc; 
     private boolean editable;
     private String  requestingUser;

    /** default constructor */
    public EditableAuthorizationRaw() {
    }
   
   /**
     * Is this authroization editable by requestingUser
     * @return
   */
   public boolean isEditable() {
        return editable;
    }

    /**
     * setter for editab
     * @return
     */
   public void setEditable(boolean editable) {
        this.editable = editable;
    }

   /**
    * getter for re requestingUser
    * @return
    */
    public String getRequestingUser() {
        return requestingUser;
    }

    /**
     * 
     * @param requestingUser
     */
    public void setRequestingUser(String requestingUser) {
        this.requestingUser = requestingUser;
    }
    /** 
     * getter function for the authorization ID field. Authorization Id is a database generated identifier that uniquely identifies the authorization
     *
     * @return authorization ID
     */
    public AuthorizationPK getAuthorizationPK() {
        return this.authorizationPK;
    }
    
    /**
     * setter function for the authorization ID field
     *
     *@param id_in authorization ID to set
     **/
    public void setAuthorizationPK(AuthorizationPK id_in) {
        this.authorizationPK = id_in;
    }
    
    /**
     * getter function for the is active now field which indicates if the authorization is currently active
     *
     * @return "Y" if currently active, otherwise "N"
     */
    public Boolean getIsActiveNow()
    {
        return isActiveNow;
    }
    
    /**
     * setter function for is active now field
     *
     * @param isActiveNow_in "Y" if currently active, otherwise "N"
     */
    public void setIsActiveNow(Boolean isActiveNow_in)
    {
        isActiveNow = isActiveNow_in;
    }
    
    /**
     * getter function for the grant authorization field.
     *
     * @return "Y" if Person can grant the Authorization otherwise "N"
     */ 
    public String getGrantAuthorization()
    {
        return grantAuthorization;
    }
    
    /**
     * setter function for the grant authorization field.
     *
     * @param  grantAuthorization_in "Y" if Person can grant the Authorization, otherwise "N"
     */  
    public void setGrantAuthorization(String grantAuthorization_in)
    {
        grantAuthorization = grantAuthorization_in;
    }
    
    /**
     * getter function for the person object
     *
     * @return Person object for the authorization
     */
    public String getPerson() {
        return this.person;
    }
    
    /**
     * setter function for the person object
     *
     * @param person_in person object for the authorization
     */
    public void setPerson(String person_in) {
        this.person = person_in;
    }
   
    public String getModifiedBy() {
        return this.modifiedBy;
    }
    
    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }
    
    public Date getModifiedDate() {
        return this.modifiedDate;
    }
    
    public void setModifiedDate(Date modifiedDate) {
        this.modifiedDate = modifiedDate;
    }
    
    public Character getDoFunction() {
        return this.doFunction;
    }
    
    public void setDoFunction(Character doFunction) {
        this.doFunction = doFunction;
    }
    
    public Date getEffectiveDate() {
        return this.effectiveDate;
    }
    
    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }
    public Date getExpirationDate() {
        return this.expirationDate;
    }
    
    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    
    /** 
     * getter function for the Category name
     *
     * @return Category name for the authorization
     */
    public String getCategory() {
        return this.category;
    }
    
    /** 
     * setter function for the Category name
     *
     * @param category_in Category name for the authorization
     */
    public void setCategory(String category_in) {
        this.category = category_in;
    }
    
    /** 
     * getter function for the Function Name
     *
     * @return Function name for the authorization
     */
    public String getFunction() {
        return this.function;
    }
    
    /** 
     * setter function for the Function Name
     *
     * @param function_in Function name for the authorization
     */
    public void setFunction(String function_in) {
        this.function = function_in;
    }
    
    /** 
     * getter function for the Qualifier Name
     *
     * @return Qualifier Name for the authorization
     */
    public String getQualifierName() {
        return this.qualifierName;
    }
    
    /** 
     * setter function for the Qualifier Name 
     *
     * @param qualifierName Qualifier Name for the authorization
     */
    public void setQualifierName(String qualifierName) {
        this.qualifierName = qualifierName;
    }
    
    /** 
     * getter function for the Qualifier Code
     *
     * @return Qualifier Code for the authorization
     */
    public String getQualifierCode() {
        return this.qualifierCode;
    }
    
    /** 
     * setter function for the Qualifier Code 
     *
     * @param qualifierName Qualifier Code for the authorization
     */
    public void setQualifierCode(String qualifierCode) {
        this.qualifierCode = qualifierCode;
    }
    
    /** 
     * getter function for the Qualifier Type
     *
     * @return Qualifier Type for the authorization
     */
    public String getQualifierType() {
        return this.qualifierType;
    }
    
    /** 
     * setter function for the Qualifier Type 
     *
     * @param qualifierName Qualifier Type for the authorization
     */
    public void setQualifierType(String qualifierType) {
        this.qualifierType = qualifierType;
    }    
    
    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }            
    
    public String getLastName() {
        return this.lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }    
    
    /**
     * getter for Function Desc
     * @return
     */
     public String getFunctionDesc() {
        return functionDesc;
    }

     /**
      * setter for Function Desc
      * @param functionDesc
      */
    public void setFunctionDesc(String functionDesc) {
        this.functionDesc = functionDesc;
    }
    
    /**
     * Stirng representation for the authorization object. 
     *
     * @return A String representation for the authorization object which has all the field names and values
     */
    public String toString()
    {
        String s ="";
       
        if (authorizationPK != null)
            s += authorizationPK.toString();
         
        s += "\nIs Active Now: ";
        if (isActiveNow != null)
            s += isActiveNow ? "Y" : "N";
        
        s += "\nGrant Authorization: ";
        if (grantAuthorization != null)
            s += grantAuthorization;
        
        s += "\nModified By: ";
        if (modifiedBy != null)
            s += modifiedBy;
        
        s += "\nModified Date: ";
        if (modifiedDate != null)
            s += modifiedDate.toString();
        
        s += "\nDo Function: ";
        if (doFunction != null)
            s += doFunction;
        
        s += "\nEffective Date: ";
        if (effectiveDate != null)
            s += effectiveDate.toString();
        
        s += "\nExpiration Date: ";
        if (expirationDate != null)
            s += expirationDate;
        
        s += "\nName: ";
        if (firstName != null && lastName != null)
            s+= lastName + ", " + firstName;
           
        return s;
        
    }
}