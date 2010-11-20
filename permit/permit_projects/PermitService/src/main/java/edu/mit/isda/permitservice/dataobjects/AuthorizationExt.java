/*
 * AuthorizationExt.java
 * Created on April 28, 2008, 11:12 PM
 * Author: David Cohen
 * 
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
 * @author  David Cohen
 * @version 1.0
 * @since 1.0
 */
public class AuthorizationExt {
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
     private String baseQualifierCode;
     private String realOrImp;

     // Constructors

    /** default constructor */
    public AuthorizationExt() {
    }
   
    public AuthorizationPK getAuthorizationPK() {
        return this.authorizationPK;
    }
    
    public void setAuthorizationPK(AuthorizationPK id_in) {
        this.authorizationPK = id_in;
    }
    
    public Boolean getIsActiveNow()
    {
        return isActiveNow;
    }
    
    public void setIsActiveNow(Boolean isActiveNow_in)
    {
        isActiveNow = isActiveNow_in;
    }
    
    public String getGrantAuthorization()
    {
        return grantAuthorization;
    }
    
    public void setGrantAuthorization(String grantAuthorization_in)
    {
        grantAuthorization = grantAuthorization_in;
    }
    
    public String getPerson() {
        return this.person;
    }
    
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

    public String getCategory() {
        return this.category;
    }
    
    public void setCategory(String category_in) {
        this.category = category_in;
    }

    public String getFunction() {
        return this.function;
    }

    public void setFunction(String function_in) {
        this.function = function_in;
    }

    public String getQualifierName() {
        return this.qualifierName;
    }

    public void setQualifierName(String qualifierName) {
        this.qualifierName = qualifierName;
    }
    
    public String getQualifierCode() {
        return this.qualifierCode;
    }
   
    public void setQualifierCode(String qualifierCode) {
        this.qualifierCode = qualifierCode;
    }
    
    public String getQualifierType() {
        return this.qualifierType;
    }
    
    public void setQualifierType(String qualifierType) {
        this.qualifierType = qualifierType;
    }    
    
    public String getBaseQualifierCode() {
        return this.baseQualifierCode;
    }
    
    public void setBaseQualifierCode(String baseQualifierCode) {
        this.baseQualifierCode = baseQualifierCode;
    }
    
    public String getRealOrImp() {
        return this.realOrImp;
    }
    
    public void setRealOrImp(String realOrImp) {
        this.realOrImp = realOrImp;
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
           
        return s;
    }
}
