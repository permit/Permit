/*
 * AuthorizationPK.java
 * Author: Qing Dong
 * Created on August 31, 2006, 11:11 PM
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

import java.io.*;

/**
 *
 *
 */
public class AuthorizationPK implements Serializable {
    private Long authorizationId;
    private Integer functionId;
    private Long qualifierId;
    
    
    /** Creates a new instance of AuthorizationPK */
    public AuthorizationPK() {
    }
    
    /**
     * compare two objects
     *
     * @param o object to compare
     * @return true if two objects are equal, otherwise false
     */
    public boolean equals(Object o)
    {
        if (this == o)  return true;
        if (o == null)  return false;
        if (!(o instanceof AuthorizationPK)) return false;
        final AuthorizationPK pk = (AuthorizationPK) o;
        if (authorizationId==null || pk.getAuthorizationId() == null || !authorizationId.equals(pk.getAuthorizationId()))
            return false;
        if (functionId == null || pk.getFunctionId() == null ||  !functionId.equals(pk.getFunctionId()))
            return false;
        if (qualifierId == null || pk.getQualifierId() == null || !qualifierId.equals(pk.getQualifierId()))
            return false;
        return true;
    }
    
    
    /**
     * Computes a composite hash code from the hash codes of the property values
     *
     * @return hashcode
     */
    public int hashCode()
    {
        int result = 17; 

      result = 37 * result + this.getAuthorizationId().intValue(); 
      result = 37 * result + this.getFunctionId().intValue(); 
      result = 37 * result + this.getQualifierId().intValue(); 
      return result; 

    }
     /**
     * Getter function for ID.
     *
     * @return function Id, an identifier that uniquely identifies the function
     */
    public Long getAuthorizationId()
    {
        return authorizationId;
    }
    
    /**
     * Setter function for ID
     *
     * @param id_in input parameter for identifier
     */
    public void setAuthorizationId(Long id_in)
    {
        authorizationId = id_in;
    }
    /**
     * Getter function for ID.
     *
     * @return function Id, an identifier that uniquely identifies the function
     */
    public Integer getFunctionId()
    {
        return functionId;
    }
    
    /**
     * Setter function for ID
     *
     * @param id_in input parameter for identifier
     */
    public void setFunctionId(int id_in)
    {
        functionId = id_in;
    }
    /**
     * Getter function for ID.
     *
     * @return function Id, an identifier that uniquely identifies the function
     */
    public Long getQualifierId()
    {
        return qualifierId;
    }
    
    /**
     * Setter function for ID
     *
     * @param id_in input parameter for identifier
     */
    public void setQualifierId(long id_in)
    {
        qualifierId = id_in;
    }
   
    public String toString()
    {
        String s = "Authorization Id: ";
        s += authorizationId.toString();
        s += "\nFunction Id: ";
        s += functionId.toString();
        s += "\nQualifier Id: ";
        s += qualifierId.toString();
        return s;
    }
}
