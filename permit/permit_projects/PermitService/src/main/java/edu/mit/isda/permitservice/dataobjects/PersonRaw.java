/*
 * PersonRaw.java
 * Created on November 26, 2007, 1:01 PM
 * Author: David Cohen
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

import java.util.*;

/**
 * The Person interface for roles service. 
 * 
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class PersonRaw {
    private String kerberosName;
    private String mitId;
    private String lastName;
    private String firstName;
    private String emailAddress;
    private String type;
    
    /** Creates a new instance of Person */
    public PersonRaw() {
    }
    
    /**
     * Getter function for person's kerberos ID.
     *
     * @return person's kerberos ID
     */
    public String getKerberosName()
    {
        return kerberosName;
    }
    
    /**
     * Setter function for person's kerberos ID.
     *
     * @param kerberosName_in person's kerberos ID
     */
    public void setKerberosName(String kerberosName_in)
    {
        kerberosName = kerberosName_in;
    }
    
    /**
     * Getter function for person's MIT ID.
     *
     * @return person's MIT ID
     */
    public String getMitId()
    {
        return mitId;
    }
    
    /**
     * Setter function for person's MIT ID.
     *
     * @param mitId_in  person's MIT ID
     */
    public void setMitId(String mitId_in)
    {
        mitId = mitId_in;
    }
    
    /**
     * Getter function for person's last name.
     *
     * @return Person's last name
     */
    public String getLastName()
    {
        return lastName;
    }
    
    /**
     * Setter function for person's last name.
     *
     * @param lastName_in input parameter for person's last name
     */
    public void setLastName(String lastName_in)
    {
        lastName = lastName_in;
    }
      
    /**
     * Getter function for person's first name.
     *
     * @return Person's first name
     */
    public String getFirstName()
    {
        return firstName;
    }
   
    /**
     * Setter function for person's first name.
     *
     * @param firstName_in input parameter for person's last name
     */
    public void setFirstName(String firstName_in)
    {
        firstName = firstName_in;
    }
    
    /**
     * Getter function for person's email address.
     *
     * @return person's email address
     */
    public String getEmailAddress()
    {
        return emailAddress;
    }
    
    /**
     * Setter function for person's email address.
     *
     * @param emailAddress_in  person's email address
     */
    public void setEmailAddress(String emailAddress_in)
    {
        emailAddress = emailAddress_in;
    }
    
    /**
     * Getter function for person's type.
     *
     * @return person's type 
     */
    public String getType()
    {
        return type;
    }
    
    /**
     * Setter function for person's tyoe.
     *
     * @param type person's type
     */
    public void setType(String type)
    {
        this.type = type;
    }    
    
    /**
     * Stirng representation for the Person object. 
     *
     * @return A String representation for the Person object which has all the field names and values
     */
    public String toString()
    {
        String s = "Kerberos name: ";
        if (kerberosName != null)
            s += kerberosName;
        s+="\nMIT ID:";        
        if (mitId != null)
            s+= mitId;        
        s+="\nLast Name: ";
        if (lastName != null)
            s += lastName;
        s+="\nFirst Name: ";
        if (firstName != null)
            s += firstName;
        s+="\nEmail Address: ";
        if (emailAddress != null)
            s += emailAddress;
        s+="\nType: ";
        if (type != null)
            s += type;
            s +="\n\n";
        return s;
    }
    
    
}
