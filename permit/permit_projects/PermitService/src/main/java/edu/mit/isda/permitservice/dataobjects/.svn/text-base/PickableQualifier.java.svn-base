/*
 * QualifierType.java
 * Created on July 6, 2006, 2:31 PM
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
 * The Person Type interface for roles service. 
 * There are three types in the database: employee, student, and other
 *
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class PickableQualifier {
    private Long qid;
    private String kname;
    private String fname;
    private Integer fid;
    private String qtype; 
    private String qcode;
    private Qualifier id = new Qualifier();
    private Set<Qualifier> q = new HashSet<Qualifier>(0);

    /** Creates a new instance of QualifierType */
    public PickableQualifier() {
    }
    
    /**
     * Getter function for kerberos name
     *
     * @return kerberos name
     */
    public Long getQid()
    {
        return qid;
    }
    
    /**
     * Setter function for kerboeros name
     *
     * @param kname_in kerberos_name
     */
    public void setQid(Long qid_in)
    {
        qid = qid_in;
    }    
    
    /**
     * Getter function for kerberos name
     *
     * @return kerberos name
     */
    public String getKname()
    {
        return kname;
    }
    
    /**
     * Setter function for kerboeros name
     *
     * @param kname_in kerberos_name
     */
    public void setKname(String kname_in)
    {
        kname = kname_in;
    }
    
    /**
     * Getter function for function name
     *
     * @return function name
     */
    public String getFname()
    {
        return fname;
    }
    
    /**
     * Setter function for function name
     *
     * @param fname_in  function name
     */
    public void setFname(String fname_in)
    {
        fname = fname_in;
    }
    
    /**
     * Getter function for function ID
     *
     * @return function ID
     */
    public Integer getFid()
    {
        return fid;
    }
    
    /**
     * Setter function for function id
     *
     * @param fid_in function id
     */
    public void setFid(Integer fid_in)
    {
        fid = fid_in;
    }   
    
    /**
     * Getter function for qualifier type
     *
     * @return qualifier type
     */
    public String getQtype()
    {
        return qtype;
    }
    
    /**
     * Setter function for qualifier type
     *
     * @param qtype_in qualifier type
     */
    public void setQtype(String qtype_in)
    {
        qtype = qtype_in;
    }
    
    /**
     * Getter function for qualifier code
     *
     * @return qualifier code
     */
    public String getQcode()
    {
        return qcode;
    }
    
    /**
     * Setter function for qualifier code
     *
     * @param qcode_in  qualifier code
     */
    public void setQcode(String qcode_in)
    {
        qcode = qcode_in;
    }    
    
    public Qualifier getId() {
        return id;
    }
    
    public void setId(Qualifier id_in) {
        id = id_in;
    }
    
    /**
     * Stirng representation for the Qualifier type object. 
     *
     * @return A String representation for the Qualifier type object which has all the field names and values
     */
    public String toString()
    {
        String s;
        s = "Qualifier: ";
        if (null != id) {
            s += id.toString();
        }
        else {
            s += "Qualifier not found";
        }
        return s;
    }
    
    protected Set<Qualifier> getChildren() {
        q = id.getChildren();
        return q;
    }
    
    protected void setChildren(Set<Qualifier> q) {
        this.q = q;
    } 
}
