/*
 * Person.java
 * Created on July 5, 2006, 1:01 PM
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
 * The Person interface for roles service. 
 * 
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class Person {
    private String kerberosName;
    private String mitId;
    private String lastName;
    private String firstName;
    private String emailAddress;
    private String deptCode;
    private PersonType type;
  //  private Long unitId;
    private Character active;
    private Character statusCode;
    private Date statusDate;
    private Set<Authorization> authorizations = new HashSet<Authorization>();
    
    /** Creates a new instance of Person */
    public Person() {
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
     * Getter function for person's department code.
     *
     * @return person's department code
     */
    public String getDeptCode()
    {
        return deptCode;
    }
    
    /** 
     * Setter function for person's department code.
     *
     * @param deptCode_in  person's department code
     */
    public void setDeptCode(String deptCode_in)
    {
        deptCode = deptCode_in;
    }
    
   /**
    * Getter function for person's type.
    *
    * @return person's type. "S" is for student, "E" is for employee, "O" is for other
    */
    public PersonType getType()
    {
        return type;
    }
    
    /**
    * Setter function for person's type.
    *
    * @param type_in  person's type. "S" is for student, "E" is for employee, "O" is for other
    */
    public void setType(PersonType type_in)
    {
        type = type_in;
    }
    
   /* public Long getUnitId()
    {
        return unitId;
    }
    
    public void setUnitId(Long l)
    {
        unitId = l;
    }*/
    
    /**
     * Getter function for is the person active.
     *
     * @return "Y" is for yes
     */
    public Character getActive()
    {
        return active;
    }
    
    /**
     * Setter function for is the person active.
     *
     * @param active_in  "Y" is for yes
     */
    public void setActive(Character active_in)
    {
        active = active_in;
    }
    
    /**
     * Getter function for the person's status code.
     *
     * @return person's status code
     */
    public Character getStatusCode()
    {
        return statusCode;
    }
    
    /**
     * Setter function for the person's status code.
     *
     * @param statusCode_in person's status code
     */
    public void setStatusCode(Character statusCode_in)
    {
        statusCode = statusCode_in;
    }
    
    /**
     * Getter function for the date of the person's status.
     *
     * @return Date for the status
     */
     public Date getStatusDate()
    {
        return statusDate;
    }
    
     /**
     * Setter function for the date of the person's status.
     *
     * @param statusDate_in Date for the status
     */
    public void setStatusDate(Date statusDate_in)
    {
        statusDate = statusDate_in;
    }
    
    protected Set<Authorization> getAuthorizations()
    {
        return authorizations;
    }
    
    protected void setAuthorizations(Set<Authorization> s)
    {
        authorizations = s;
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
        s+="\nDepartment Code: ";
        if (deptCode != null)
            s += deptCode;

     //   s+="\nPerson Type: " + getType().getDescription();
    /*    s+="\nUnit Id: ";
        if (unitId != null)
            s += unitId.toString();*/
        s+="\nActive: ";
        if (active != null)
            s += active;
        s+="\nStatus Code: "; 
        if (statusCode != null)
            s += statusCode;
        s+="\nStatus Date: ";
        if (statusDate != null)
            s += statusDate.toString();
        return s;
    }
    
    
}
