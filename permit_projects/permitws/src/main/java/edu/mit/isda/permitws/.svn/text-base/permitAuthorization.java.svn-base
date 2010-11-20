/***********************************************************************
$Rev:: 268                       $:  Revision of last commit
$Author:: dtanner                $:  Author of last commit
$Date:: 2007-01-09 16:17:23 -050#$:  Date of last commit
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
        
public class permitAuthorization implements java.io.Serializable {
    
     private String category;
     private String qualifier;
     private String qualifierCode;
     private String function;
     private String name;
    
    public permitAuthorization()
    {
    }

    public String getCategory()
    {
        return category;
    }
    
    public void setCategory(String uCategory)
    {
        category = uCategory;
    }

    public String getQualifier()
    {
        return qualifier;
    }
    
    public void setQualifier(String uQualifier)
    {
        qualifier = uQualifier;
    }
    
    public String getFunction()
    {
        return function;
    }

    public String getQualifierCode()
    {
        return qualifierCode;
    }
    
    public void setQualifierCode(String uQualifierCode)
    {
        qualifierCode = uQualifierCode;
    }
    
    public void setFunction(String uFunction)
    {
        function = uFunction;
    }
    
    public String getName()
    {
        return name;
    }
    public void setName(String uName)
    {
        name = uName;
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
