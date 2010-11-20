/*
 * Authorization.java
 * Created on July 14, 2006, 11:12 PM
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

public class Authorization {
     private AuthorizationPK authorizationPK;
     private Boolean isActiveNow;
     private String grantAuthorization;
     private String modifiedBy;
     private Date modifiedDate;
     private Character doFunction;
     //private String grantAndView;
     //private Character descend;
     private Date effectiveDate;
     private Date expirationDate;
     private Person  person;
     private Category category;
     private Function function;
     private Qualifier qualifier;

     // Constructors

    /** default constructor */
    public Authorization() {
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
    public Person getPerson() {
        return this.person;
    }
    
    /**
     * setter function for the person object
     *
     * @param person_in person object for the authorization
     */
    public void setPerson(Person person_in) {
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
    
    /**
    public String getGrantAndView() {
        return this.grantAndView;
    }
    
    public void setGrantAndView(String grantAndView) {
        this.grantAndView = grantAndView;
    }
    

    public Character getDescend() {
        return this.descend;
    }
    
    public void setDescend(Character descend) {
        this.descend = descend;
    }
      **/
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
     * getter function for the Category object
     *
     * @return Category object for the authorization
     */
    public Category getCategory() {
        return this.category;
    }
    
    /** 
     * setter function for the Category object
     *
     * @param category_in Category object for the authorization
     */
    public void setCategory(Category category_in) {
        this.category = category_in;
    }
    
    /** 
     * getter function for the Function Object
     *
     * @return Function object for the authorization
     */
    public Function getFunction() {
        return this.function;
    }
    
    /** 
     * setter function for the Function Object
     *
     * @param function_in Function object for the authorization
     */
    public void setFunction(Function function_in) {
        this.function = function_in;
    }
    
    /** 
     * getter function for the Qualifier Object
     *
     * @return Qualifier object for the authorization
     */
    public Qualifier getQualifier() {
        return this.qualifier;
    }
    
    /** 
     * setter function for the Qualifier Object 
     *
     * @param qualifier_in Qualifier object for the authorization
     */
    public void setQualifier(Qualifier qualifier_in) {
        this.qualifier = qualifier_in;
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
        
      /* s += "\nModified By: ";
        if (modifiedBy != null)
            s += modifiedBy;
        s += "\nModified Date: ";
        if (modifiedDate != null)
            s += modifiedDate.toString();
        s += "\nDo Function: ";
        if (doFunction != null)
            s += doFunction;
        s += "\nGrand And View: ";
        if (grantAndView != null)
            s += grantAndView;
        s += "\nDescend: ";
        if (descend != null)
            s += descend;
        s += "\nEffective Date: ";
        if (effectiveDate != null)
            s += effectiveDate.toString();
        s += "\nExpiration Date: ";
        if (expirationDate != null)
            s += expirationDate;
      */     
        return s;
        
    }
 
}
