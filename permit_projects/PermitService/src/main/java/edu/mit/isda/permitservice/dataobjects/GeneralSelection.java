/*
 * GeneralSelection.java
 * Created on September 21, 2007, 12:46 PM
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
import edu.mit.isda.permitservice.service.GeneralSelectionManager;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.dao.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.HibernateException;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.jdbc.object.StoredProcedure;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.SqlOutParameter;
        
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.*;
import java.sql.SQLException;
import java.sql.Types;
import javax.sql.DataSource;
import javax.xml.*;
import javax.xml.parsers.SAXParser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 *
 */
public class GeneralSelection extends HibernateDaoSupport implements GeneralSelectionManager {
     private static Log log = LogFactory.getLog("GeneralSelection.class");

    /** Creates a new instance of HibernateAuthorizationMgr */
    public GeneralSelection() {
    }
    
    /**
     * retrieves a Criteria Set by selection ID and certificate username.
     *
     * @param   selectionID
     * @param   username
     * @return  {@link Category} matching the category code
     * @throws  InvalidInputException   If the category code is NULL or more than 4 characters long
     * @throws  ObjectNotFoundException If no category is found in the database matching the category code
     * @throws  AuthorizationException  in case of hibernate error   
     */
     public Collection<Criteria> getCriteriaSet(String selectionID, String userName) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
     {
        if (null == userName) 
            throw new InvalidInputException();

               String name = userName.trim().toUpperCase();
                
        if (name.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection crits = null;
        try{
            crits = t.findByNamedQuery("GET_CRITERIA", new String[]{ name,selectionID});
            t.initialize(crits);
        }
        catch(DataAccessException e){
            Exception  re = (Exception) e.getCause();
            re.printStackTrace();
              SQLException se = null;
              if(re instanceof org.hibernate.exception.SQLGrammarException)
              {
                  se = ((org.hibernate.exception.SQLGrammarException) re).getSQLException();
              }
              else if(e.getCause() instanceof SQLException){
                se = (SQLException)e.getCause();
              }
               if (null != se)
               {
                   int i = se.getErrorCode();
                   String msg = se.getMessage();
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
                   int index =msg.indexOf("\n");
                   if (index >0)
                       msg = msg.substring(0, index);
                   if (i == InvalidInputException.FunctionCategoryInvalidLength || i == InvalidInputException.FunctionNameInvalidLength ||
                           i == InvalidInputException.NeedKerberosName || i==InvalidInputException.NeedFunctionCategory || 
                           i==InvalidInputException.InvalidFunction || i==InvalidInputException.QualifierTypeInvalidLength)
                       throw new InvalidInputException(errorMessage, i);

                    else
                     throw new AuthorizationException(errorMessage);
            }
           else
                throw new AuthorizationException(e.getMessage());
        }
       catch(Exception e){
        e.printStackTrace();
       }
        if (crits == null )
        {
            throw new AuthorizationException("error retrieving viewable categories");
        }

               return crits;
    }   
     
    /**
     * retrieves a selection list by certificate username.
     *
     * @param   username
     * @return  {@link Category} matching the category code
     * @throws  InvalidInputException   If the category code is NULL or more than 4 characters long
     * @throws  ObjectNotFoundException If no category is found in the database matching the category code
     * @throws  AuthorizationException  in case of hibernate error   
     */
     public Collection<SelectionList> getSelectionList(String userName) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
     {
        
        if (null == userName)
        {
            throw new InvalidInputException();
        }
     
        String name = userName.trim().toUpperCase();
                
        if (name.length() <= 0)
            throw new InvalidInputException();

        HibernateTemplate t = getHibernateTemplate();
        Collection crits = null;
        try{
           crits = t.findByNamedQuery("SELECTION_LIST", new String[]{name, name});
            t.initialize(crits);
        }
        catch(DataAccessException e){
            Exception  re = (Exception) e.getCause();
            re.printStackTrace();
           
            SQLException se = null;
            if(re instanceof org.hibernate.exception.SQLGrammarException)
            {
                  se = ((org.hibernate.exception.SQLGrammarException) re).getSQLException();
            }
            else if(e.getCause() instanceof SQLException)
            {
                se = (SQLException)e.getCause();
            }
            if (null != se)
            {
                   int i = se.getErrorCode();
                   String msg = se.getMessage();
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
                    int index =msg.indexOf("\n");
                   if (index >0)
                       msg = msg.substring(0, index);
                   if (i == InvalidInputException.FunctionCategoryInvalidLength || i == InvalidInputException.FunctionNameInvalidLength ||
                           i == InvalidInputException.NeedKerberosName || i==InvalidInputException.NeedFunctionCategory || 
                           i==InvalidInputException.InvalidFunction || i==InvalidInputException.QualifierTypeInvalidLength)
                       throw new InvalidInputException(errorMessage, i);

                    else
                    {
                        throw new AuthorizationException(errorMessage);
                    }
           }
           else
           {
                throw new AuthorizationException(e.getMessage());
           }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println(e.getMessage());

        }
        if (crits == null )
        {
            throw new AuthorizationException("error retrieving viewable categories");
        }

        return crits;
    }            
     
     
    
     
    /**
    * retrieve a set of Authorizations based on a criteria list
    *
    * @param criteriaXML XML string containing criteria information
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Collection<Authorization> listAuthorizationsByCriteria(String[] criteria) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
        if (criteria == null) 
            throw new InvalidInputException();
                
        HibernateTemplate t = getHibernateTemplate();
        List alist = new ArrayList();
               
        Collection authorizations = null;
        for (int i=0;i<criteria.length;i++)
        {
            log.debug("Criteria " + i + ":" + criteria[i]);
        }

        try{
          authorizations = t.findByNamedQuery("LISTAUTHSBYCRIT_RAW",criteria);
         //  authorizations = t.findByNamedQuery("LISTAUTHSBYCRIT_SP", obj);
            t.initialize(authorizations);
        }
       
         
        catch(DataAccessException e){
            Exception  re = (Exception) e.getCause();
           
              SQLException se = null;
              if(re instanceof org.hibernate.exception.SQLGrammarException)
              {
                  se = ((org.hibernate.exception.SQLGrammarException) re).getSQLException();
              }
              else if(e.getCause() instanceof SQLException){
                se = (SQLException)e.getCause();
              }
               if (null != se)
               {
                   int i = se.getErrorCode();
                   String msg = se.getMessage();
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
   
                   int index =msg.indexOf("\n");
                   if (index >0)
                       msg = msg.substring(0, index);
                   if (i == InvalidInputException.FunctionCategoryInvalidLength || i == InvalidInputException.FunctionNameInvalidLength ||
                           i == InvalidInputException.NeedKerberosName || i==InvalidInputException.NeedFunctionCategory || 
                           i==InvalidInputException.InvalidFunction || i==InvalidInputException.QualifierTypeInvalidLength)
                       throw new InvalidInputException(errorMessage, i);

                   else if (i == PermissionException.ProxyNotAuthorized || i == PermissionException.ServerNotAuthorized)
                     throw new PermissionException(errorMessage, i);
                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage() );
        }
       
        return authorizations;
    }    
    
    /**
    * retrieve a set of people based on a kerberos or last name
    *
    * @param criteriaXML XML string containing criteria information
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Collection<PersonRaw> listPersonRaw(String name, String search, String sort, String filter1, String filter2, String filter3) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
        if (name == null) 
            throw new InvalidInputException();
                
        HibernateTemplate t = getHibernateTemplate();
        List alist = new ArrayList();
        String last_only = "%";
        String kerb_only = "%";
        String both = "%";
        String mitId = name;
        
        if (search.equals("kerberos")) {
            kerb_only = name;
        }
        else if (search.equals("last")) {
            last_only = name;
        }
        else if (search.equals("both")) {
            both = name;
        }
        if (name.endsWith("%") )
        {
            mitId = name.substring(0, name.length()-1).trim();
        }
        else
        {
             mitId = name.trim();
        }
        System.out.println("******************* LAST: " + last_only);
        System.out.println("******************* KERB ID: " + kerb_only);
        System.out.println("*******************  BOTH: " + both);
        System.out.println("******************* MIT ID: " + mitId);
        Collection people = null;

        try{
            if (sort.equals("last"))
                people = t.findByNamedQuery("QUICK_PERSON", new String[] {last_only, kerb_only, both, both,mitId, filter1, filter2, filter3});
            else if (sort.equals("kerberos"))
                people = t.findByNamedQuery("QUICK_PERSON_KERBSORT", new String[] {last_only, kerb_only, both, both,mitId, filter1, filter2, filter3});
            else if (sort.equals("type")) 
                people = t.findByNamedQuery("QUICK_PERSON_TYPESORT", new String[] {last_only, kerb_only, both, both,mitId, filter1, filter2, filter3});
            else {
                people = t.findByNamedQuery("QUICK_PERSON", new String[] {last_only, kerb_only, both, both,mitId, filter1, filter2, filter3});
            }
            t.initialize(people);
        }
       
         
        catch(DataAccessException e){
           Exception  re = (Exception) e.getCause();
           
              SQLException se = null;
              if(re instanceof org.hibernate.exception.SQLGrammarException)
              {
                  se = ((org.hibernate.exception.SQLGrammarException) re).getSQLException();
              }
              else if(e.getCause() instanceof SQLException){
                se = (SQLException)e.getCause();
              }
               if (null != se)
               {
                   int i = se.getErrorCode();
                   String msg = se.getMessage();
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
 
                   int index =msg.indexOf("\n");
                   if (index >0)
                       msg = msg.substring(0, index);
                   if (i == InvalidInputException.FunctionCategoryInvalidLength || i == InvalidInputException.FunctionNameInvalidLength ||
                           i == InvalidInputException.NeedKerberosName || i==InvalidInputException.NeedFunctionCategory || 
                           i==InvalidInputException.InvalidFunction || i==InvalidInputException.QualifierTypeInvalidLength)
                       throw new InvalidInputException(errorMessage, i);

                   else if (i == PermissionException.ProxyNotAuthorized || i == PermissionException.ServerNotAuthorized)
                     throw new PermissionException(errorMessage, i);
                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
        return people;
    }     
 }
