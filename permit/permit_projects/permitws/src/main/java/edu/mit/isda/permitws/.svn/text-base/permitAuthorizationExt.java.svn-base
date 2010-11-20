/***********************************************************************
$Rev:: 268                       $:  Revision of last commit
$Author:: cohend                 $:  Author of last commit
$Date:: 2007-06-22 16:17:23 -050#$:  Date of last commit
***********************************************************************/
/*
 * rolesAuthorization.java
 * Created on August 1, 2006, 11:12 AM
 * Author: ZEST
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
        
public class permitAuthorizationExt extends permitAuthorization implements java.io.Serializable {
    
     private String category;
     private String qualifier;
     private String qualifierCode;
     private String qualifierType;
     private String function;
     private String name;
     private String authid;
     private String effectiveDate;
     private String expirationDate;
     private String grantAuth;
     private String doFunction;
     private String modifiedBy;
     private String modifiedDate;
     private boolean isActiveNow;
     
    public permitAuthorizationExt()
    {
    }

    public String getEffectiveDate()
    {
        return effectiveDate;
    }
    public void setEffectiveDate(String uEffdate)
    {
        effectiveDate = uEffdate;
    }
    
    public String getQualifierType()
    {
        return qualifierType;
    }
    public void setQualifierType(String uQualtype)
    {
        qualifierType = uQualtype;
    }
        
    
    public String getExpirationDate()
    {
        return expirationDate;
    }
    public void setExpirationDate(String uExpdate)
    {
        expirationDate = uExpdate;
    }

    public String getAuthorizationID()
    {
        return authid;
    }
    public void setAuthorizationID(String uAuthid)
    {
        authid = uAuthid;
    }
    
    public String getGrantAuth()
    {
        return grantAuth;
    }
    public void setGrantAuth(String grantAuth)
    {
        this.grantAuth = grantAuth;
    }
    
    public String getDoFunction()
    {
        return doFunction;
    }
    public void setDoFunction(String doFunction)
    {
        this.doFunction = doFunction;
    }    
    
    public String getModifiedBy()
    {
        return modifiedBy;
    }
    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }    

    public String getModifiedDate()
    {
        return modifiedDate;
    }
    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }    
    
    public boolean getIsActiveNow()
    {
        return isActiveNow;
    }
    public void setIsActiveNow(boolean isActiveNow)
    {
        this.isActiveNow = isActiveNow;
    }        

    public String toString()
    {
        String s = "Name: ";
        if (name != null)
            s += name;
        s += "\n  Category: ";
        if (category != null)
            s += category;
        s += "\n  Qualifier: ";
        if (qualifier != null)
            s += qualifier;
        s += "\n  Function: ";
        if (function != null)
            s += function;
        return s;
    }
}
