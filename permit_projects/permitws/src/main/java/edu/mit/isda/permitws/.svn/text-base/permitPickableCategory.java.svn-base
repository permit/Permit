/***********************************************************************
$Rev:: 268                       $:  Revision of last commit
$Author:: dtanner                $:  Author of last commit
$Date:: 2007-01-09 16:17:23 -050#$:  Date of last commit
***********************************************************************/
/*
 * rolesPickableCategory.java
 * Created on June 27, 2007, 11:12 AM
 * Author: COHEND
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
        
public class permitPickableCategory implements java.io.Serializable {
    
     private String category;
     private String description;
    
    public permitPickableCategory()
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

    public String getDescription()
    {
        return description;
    }
    
    public void setDescription(String uDescription)
    {
        description = uDescription;
    }
    

    public String toString()
    {
        String s = "Category: ";
        if (category != null)
            s += category;
        s += "\n  Description: ";
        if (description != null)
            s += description;
        return s;
    }
}
