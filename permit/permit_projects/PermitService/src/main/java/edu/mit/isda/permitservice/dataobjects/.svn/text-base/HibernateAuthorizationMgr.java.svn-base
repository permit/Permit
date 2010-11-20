/*
 * HibernateAuthorizationMgr.java
 * Created on January 10, 2007, 12:46 PM
 *
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
import edu.mit.isda.permitservice.service.AuthorizationManager;
import edu.mit.isda.permitservice.service.BatchActionDao;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.dao.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.HibernateException;
import org.hibernate.NonUniqueResultException;
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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 *
 */
public class HibernateAuthorizationMgr extends HibernateDaoSupport implements AuthorizationManager {
   
    private int total_qualifiers;
    private BatchActionDao  batchActionDao;
    private static Log log = LogFactory.getLog("HibernateAuthorizationMgr.class");
    
    public BatchActionDao getBatchActionDao()
    {
        return batchActionDao;
    }
    public void setBatchActionDao( BatchActionDao batchActionDao)
    {
        this.batchActionDao = batchActionDao;
    }
    
    
        
    /** Creates a new instance of HibernateAuthorizationMgr */
    public HibernateAuthorizationMgr() {
    }
   
    /**
    * retrieve a set of Authorizations by a person's kerberosId
    *
    * @param userName user's kerberos Id
    * @param category Authorization Category code, such as "SAP"
    * @param isActive if you are only interested in authorizations that are currently active, use Boolean.TRUE, otherwise, use Boolean.FALSE
    * @param willExpand if you want to expand the qualifier to get the implicit authorization or not 
    * @param proxyUserName  the user who is executing this query
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Set<Authorization> listAuthorizationsByPerson(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
      
        if (userName == null || category == null || isActive == null || willExpand == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String categoryCode = category.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String pUser = proxyUserName.trim().toUpperCase();
        
        //if (pname.length() <= 0 || categoryCode.length()<=0 || aname.length()<=0 || pUser.length() <=0)
        if (pname.length() <= 0 || aname.length()<=0 || pUser.length() <=0)
            throw new InvalidInputException();
        
        
        
        if (categoryCode.length() > 0)
        {
            while (categoryCode.length()<4)
            {
                categoryCode+=" ";
            }
        }
        String active = isActive ? "Y" :"N";
        String expand = willExpand ? "Y" :"N";
        HibernateTemplate t = getHibernateTemplate();
               
        Collection authorizations = null;
        try{
            authorizations = t.findByNamedQuery("LISTAUTHSBYPERSON_SP", new String[]{aname, pUser, pname, categoryCode, expand, active});
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
                throw new AuthorizationException(e.getMessage());
        }
       
        
        if (authorizations == null )
            throw new AuthorizationException("error retrieving authorizations for user " + userName);
       
        Set<Authorization> authSet = new HashSet<Authorization>(authorizations);
        return authSet;
        
    }
    
 /**
    * retrieve a set of Authorizations by a person's kerberosId
    *
    * @param userName user's kerberos Id
    * @param category Authorization Category code, such as "SAP"
    * @param isActive if you are only interested in authorizations that are currently active, use Boolean.TRUE, otherwise, use Boolean.FALSE
    * @param willExpand if you want to expand the qualifier to get the implicit authorization or not 
    * @param proxyUserName  the user who is executing this query
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Collection<AuthorizationExt> listAuthByPersonExtend1(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName, String realOrImplied,
            String function_name, String function_id, String function_qualifier_type, String qualifier_code, String qualifier_id, String base_qual_code, 
            String base_qual_id, String parent_qual_code, String parent_qual_id) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
      
        if (userName == null || category == null || isActive == null || willExpand == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String categoryCode = category.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String pUser = proxyUserName.trim().toUpperCase();
        String rori = "B";
        
        if (null != realOrImplied) {
            rori = realOrImplied.trim().toUpperCase();
        }
        
        //if (pname.length() <= 0 || categoryCode.length()<=0 || aname.length()<=0 || pUser.length() <=0)
        if (pname.length() <= 0 || aname.length()<=0 || pUser.length() <=0)
            throw new InvalidInputException();
        
        
        
        if (categoryCode.length() > 0)
        {
            while (categoryCode.length()<4)
            {
                categoryCode+=" ";
            }
        }
        String active = isActive ? "Y" :"N";
        String expand = willExpand ? "Y" :"N";
        HibernateTemplate t = getHibernateTemplate();
               
        Collection authorizations = null;
        try{
             authorizations = t.findByNamedQuery("LISTAUTHBYPERSON_EXT", new String[]{aname, pUser, pname, categoryCode, expand, active, rori, function_name, 
                                                function_id, function_qualifier_type, qualifier_code, qualifier_id, base_qual_code, base_qual_id, parent_qual_code, 
                                                parent_qual_id});
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
                throw new AuthorizationException(e.getMessage());
        }
       
        
        if (authorizations == null )
            throw new AuthorizationException("error retrieving authorizations for user " + userName);
       
        return authorizations;
    }
        
    
    /**
    * retrieve a set of Authorizations by a person's kerberosId
    *
    * @param userName user's kerberos Id
    * @param category Authorization Category code, such as "SAP"
    * @param isActive if you are only interested in authorizations that are currently active, use Boolean.TRUE, otherwise, use Boolean.FALSE
    * @param willExpand if you want to expand the qualifier to get the implicit authorization or not 
    * @param proxyUserName  the user who is executing this query
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Collection<AuthorizationRaw> listAuthorizationsByPersonRaw(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
      
        if (userName == null || category == null || isActive == null || willExpand == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String categoryCode = category.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String pUser = proxyUserName.trim().toUpperCase();
        
        //if (pname.length() <= 0 || categoryCode.length()<=0 || aname.length()<=0 || pUser.length() <=0)
        if (pname.length() <= 0 || aname.length()<=0 || pUser.length() <=0)
            throw new InvalidInputException();
        
        
        
        if (categoryCode.length() > 0)
        {
            while (categoryCode.length()<4)
            {
                categoryCode+=" ";
            }
        }
        String active = isActive ? "Y" :"N";
        String expand = willExpand ? "Y" :"N";
        HibernateTemplate t = getHibernateTemplate();
               
        Collection authorizations = null;
        try{
            authorizations = t.findByNamedQuery("LISTAUTHRAW", new String[]{aname, pUser, pname, categoryCode, expand, active});
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
                throw new AuthorizationException(e.getMessage());
        }
       
        
        if (authorizations == null )
            throw new AuthorizationException("error retrieving authorizations for user " + userName);
       
        return authorizations;
    }
    
    
    /**
     * If the user is authorized to do function X within qualifier Y. 
     *
     * @param userName user's kerberos Id
     * @param function_category function category code such as "SAP"
     * @param function_name function name such as "can spend or commit fund"
     * @param qualifier_code  qualifier_code such as "CATSAP"
     * @param proxyUserName  the user who is executing this query
     * @param applicationName  the application that is executing this query 
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Boolean isUserAuthorized(String userName, String function_category, String function_name, String qualifier_code, 
        String applicationName, String proxyUserName) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null || function_name == null || qualifier_code == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
        
        String pname = userName.trim().toUpperCase();
        String category = function_category.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        String qcode = qualifier_code.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String proxy = proxyUserName.trim().toUpperCase();
        
        if (pname.length() <=0 || category.length() <= 0 || fname.length() <=0 || qcode.length() <= 0 || aname.length() <= 0
                || proxy.length() <= 0)
            throw new InvalidInputException();
        
        String answer=""; 
        String sql;
        sql = "select rolessrv.IS_USER_AUTHORIZED(?,?,?,?,?,?) from dual";
        
        try{
            Session s = getSession();
            answer = (String)s.createSQLQuery(sql)
            .setString(0, aname)
            .setString(1, proxy)
            .setString(2, pname)
            .setString(3, category)
            .setString(4, fname)
            .setString(5, qcode)
            .uniqueResult();
            
        }
        
         catch(HibernateException e){
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

        if (answer.equals("Y"))
            return Boolean.TRUE;
        else
            return Boolean.FALSE;
    }
    
    /**
     * If the user is authorized to do function X within qualifier Y. 
     *
     * @param userName user's kerberos Id
     * @param function_category function category code such as "SAP"
     * @param function_name function name such as "can spend or commit fund"
     * @param qualifier_code  qualifier_code such as "CATSAP"
     * @param proxyUserName  the user who is executing this query
     * @param applicationName  the application that is executing this query 
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Boolean isUserAuthorized(String userName, Integer function_id, Long qualifier_id, 
            String applicationName, String proxyUserName) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null || function_id == null || qualifier_id == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
       
        String aname = applicationName.trim().toUpperCase();
        String proxy = proxyUserName.trim().toUpperCase();
        
        if (pname.length() <=0 || aname.length() <= 0 || proxy.length() <= 0)
            throw new InvalidInputException();
        
        String answer=""; 
        String sql;
        sql = "select rolessrv.IS_USER_AUTHORIZED(?,?,?,?,?) from dual";
       
        try{
            Session s = getSession();
            answer = (String)s.createSQLQuery(sql)
            .setString(0, aname)
            .setString(1, proxy)
            .setString(2, pname)
            .setString(3, function_id.toString())
            .setString(4, qualifier_id.toString())
            .uniqueResult();
            
        }
        catch(HibernateException e){
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
    
        
        if (answer.equals("Y"))
            return Boolean.TRUE;
        else
            return Boolean.FALSE;
    }
    
    /**
     * If the user is authorized to do function X within qualifier Y. 
     *
     * @param userName user's kerberos Id
     * @param function_category function category code such as "SAP"
     * @param function_name function name such as "can spend or commit fund"
     * @param qualifier_code  qualifier_code such as "CATSAP"
     * @param proxyUserName  the user who is executing this query
     * @param applicationName  the application that is executing this query 
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Boolean isUserAuthExtend1(String userName, String function_category, String function_name, String qualifier_code, 
        String applicationName, String proxyUserName, String realOrImplied) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null || function_name == null || qualifier_code == null || applicationName == null || proxyUserName == null || realOrImplied == null) 
            throw new InvalidInputException();
        
        String pname = userName.trim().toUpperCase();
        String category = function_category.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        String qcode = qualifier_code.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String proxy = proxyUserName.trim().toUpperCase();
        String roi =  realOrImplied.trim().toUpperCase();
        
        if (pname.length() <=0 || category.length() <= 0 || fname.length() <=0 || qcode.length() <= 0 || aname.length() <= 0
                || proxy.length() <= 0)
            throw new InvalidInputException();
        
        if (roi.length() <= 0) 
            roi = "B";
        
        String answer=""; 
        String sql;
        sql = "select rolessrv.IS_USER_AUTHORIZED_EXTENDED(?,?,?,?,?,?,?) from dual";
        
        try{
            Session s = getSession();
            answer = (String)s.createSQLQuery(sql)
            .setString(0, aname)
            .setString(1, proxy)
            .setString(2, pname)
            .setString(3, category)
            .setString(4, fname)
            .setString(5, qcode)
            .setString(6, roi)
            .uniqueResult();
        }
        
         catch(HibernateException e){
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
    
        if (answer.equals("Y"))
            return Boolean.TRUE;
        else
            return Boolean.FALSE;
    }    
    
    /**
     * retrieves children of the specified qualifier Id 
     *
     * @param   id  Qualifier Id
     * @return  all the children {@link Qualifier} of the supplied qualifier Id
     * @throws  InvalidInputException if id is NULL
     * @throws  ObjectNotFoundException If no children is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */
    public Set<Qualifier> listChildrenByQualifier(Long id) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
    {
        if (id == null)
            throw new InvalidInputException();
        Qualifier q = null;
        Set<Qualifier> children = null;
        HibernateTemplate t = getHibernateTemplate();
         try{
            q = (Qualifier)t.load(Qualifier.class, id);
            children = q.getChildren();
            t.initialize(children);
         }
         catch(ObjectRetrievalFailureException e){
            throw new ObjectNotFoundException("Can not find qualifier with id " + id + " in the database");
        }
        catch(DataAccessException e)
        {
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

               
                    else
                     throw new AuthorizationException(errorMessage);
             }
        }

        return children;
    }
    
    /**
     * retrieves all the Categories in the database
     *
     * @return  all the {@link Category} in the database
     * @throws  ObjectNotFoundException If no category is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */
      @SuppressWarnings("unchecked")
    public Set<Category> listCategories() throws ObjectNotFoundException, AuthorizationException
    {
        List l = null;
        HibernateTemplate t = getHibernateTemplate();
        try{
            l = t.find("from Category c");
        }
        catch(DataAccessException e)
        {
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
                       throw new AuthorizationException(errorMessage);
                }
               else
                    throw new AuthorizationException(e.getLocalizedMessage());
        }
        if (l == null )
            throw new ObjectNotFoundException("No Categories found in database");
        
        Set<Category> catSet = new HashSet<Category>(l);
        return catSet;
    }
     
     /**
     * retrieves the QualifierType by a qualifier type code . Qualifier type code are maxium 4 characters long
     *
     * @param   qualifierTypeCode   Qualifier Type code
     * @return  {@link QualifierType}  matching the code
     * @throws  InvalidInputException   If the qualifier type code is NULL or the qualifier type code is more than 4 characters long
     * @throws  ObjectNotFoundException If no qualifier type is found in the database matching the code
     * @throws  AuthorizationException  in case of hibernate error   
     */
   public  QualifierType getQualifierType(String qualifierTypeCode) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
    {
         if (qualifierTypeCode == null || qualifierTypeCode.length() > 4)
             throw new InvalidInputException();
        String qualifier_type = qualifierTypeCode.toUpperCase();
        QualifierType qt = null;
        while (qualifier_type.length()<4)
        {
            qualifier_type+=" ";
        }
        HibernateTemplate t = getHibernateTemplate();
        try{
            qt = (QualifierType)t.load(QualifierType.class, qualifier_type);
        }
         catch(ObjectRetrievalFailureException e){
            throw new ObjectNotFoundException("Can not find qualifier type " + qualifierTypeCode + " in the database");
        }
        catch(DataAccessException e)
        {
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
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
 

                     throw new AuthorizationException(errorMessage);
           }
           else
               throw new AuthorizationException(e.getMessage());
        }
        
       
        return qt;
        
        
    }
   
    /**
     * retrieves all the QualifierTypes in the database
     *
     * @return  all the {@link QualifierType} in the database
     * @throws  ObjectNotFoundException If no QualifierType is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */
    
    @SuppressWarnings("unchecked")
     public Set<QualifierType> listQualifierTypes() throws ObjectNotFoundException, AuthorizationException
    {
         List l = null;
         HibernateTemplate t = getHibernateTemplate();
         try{
            l = t.find("from QualifierType c");
         }
         catch(DataAccessException e)
         {
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
                    String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
 

                     throw new AuthorizationException(errorMessage);
           }
               else
                 throw new AuthorizationException(e.getMessage());
         }
         if (l == null)
             throw new ObjectNotFoundException("No Qualifier Type found in database");
         
         Set<QualifierType> qSet = new HashSet<QualifierType>(l);
         return qSet;
        
    }
   
     /**
     * retrieves all the Functions associated with a category code such as SAP or ADMN. Category code are maxium 4 characters long
     *
     * @param   categoryCode  Category Code
     * @return  all the {@link Function} associated with the category code
     * @throws  InvalidInputException if categoryCode is NULL or if categoryCode is more than 4 characters long
     * @throws  ObjectNotFoundException If no function is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Set<Function> listFunctionsByCategory(String categoryCode)throws InvalidInputException, ObjectNotFoundException, AuthorizationException
    {
        if (categoryCode == null || categoryCode.length() > 4)
            throw new InvalidInputException();
        String categoryName = categoryCode.toUpperCase();
        Category cat = null;
        Set<Function> functions = null;
        while (categoryName.length()<4)
        {
            categoryName+=" ";
        }
        HibernateTemplate t = getHibernateTemplate();
        try{
            cat = (Category)t.load(Category.class, categoryName);
            functions = cat.getFunctions();
            t.initialize(functions);
        }
         catch(ObjectRetrievalFailureException e){
            throw new ObjectNotFoundException("Can not find category " + categoryCode + " in the database");
        }
        catch(DataAccessException e)
        {
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

                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
 
 
                     throw new AuthorizationException(errorMessage);
           }
           else
               throw new AuthorizationException(e.getMessage());
        }
        
        return functions;
        
    }
    
    /**
     * retrieves parents of the specified qualifier Id 
     *
     * @param   id  Qualifier Id
     * @return  all the parent {@link Qualifier} of the supplied qualifier Id
     * @throws  InvalidInputException if id is NULL
     * @throws  ObjectNotFoundException If no parents is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */
    public Set<Qualifier> listParentsByQualifier(Long id) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
    {
        if (id == null)
            throw new InvalidInputException();
        Qualifier q = null;
        Set<Qualifier> parents = null;
        HibernateTemplate t = getHibernateTemplate();
        try{
            q = (Qualifier)t.load(Qualifier.class, id);
            parents = q.getParents();
            t.initialize(parents);
         }
         catch(ObjectRetrievalFailureException e){
            throw new ObjectNotFoundException("Can not find qualifier with id " + id + " in the database");
        }
        catch(DataAccessException e)
        {
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
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
 
 
                     throw new AuthorizationException(errorMessage);
           }
           else
               throw new AuthorizationException(e.getMessage());
        }
        
        return parents;
    }
    
    
    /**
     * retrieves all the Qualifiers associated with a qualifier type code such as COST or FUND. Qualifier type are maxium 4 characters long
     *
     * @param   type  Qualifier Type code
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Qualifier getRootQualifierByType(String type) throws InvalidInputException, ObjectNotFoundException, AuthorizationException 
    {
        if (type == null)
            throw new InvalidInputException();
        
        String qualifier_type = type.toUpperCase();
        QualifierType qt = null;
        Set<Qualifier> qualifiers = null;
        while (qualifier_type.length()<4)
        {
            qualifier_type+=" ";
        }
        HibernateTemplate t = getHibernateTemplate();
        try{
            qt = (QualifierType)t.load(QualifierType.class, qualifier_type);
            qualifiers = qt.getQualifiers();
            t.initialize(qualifiers);
        }
         catch(ObjectRetrievalFailureException e){
            throw new InvalidInputException("Can not find qualifier type " + type + " in the database", InvalidInputException.InvalidQualifierType);
        }
        catch(DataAccessException e)
        {
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
                   String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;
                     throw new AuthorizationException(errorMessage);
           }
           else
               throw new AuthorizationException(e.getMessage());
        }
        
       if (qualifiers == null)
           throw new ObjectNotFoundException("Can not find qualifiers for qualifier type " + type);
       Iterator<Qualifier> it = qualifiers.iterator();
       Qualifier ret = null;
       if (it.hasNext())
        ret = it.next();
       
       return ret;
    }
   
    @SuppressWarnings("unchecked")
    public Set<Qualifier> listQualifiersByName(String name, int searchCriteria) throws InvalidInputException, ObjectNotFoundException, AuthorizationException{  
        if (name == null )
            throw new InvalidInputException(); 
        if (searchCriteria != AuthorizationManager.BEGINWITH && searchCriteria != AuthorizationManager.CONTAINS && searchCriteria != AuthorizationManager.EXACT)
            throw new InvalidInputException(); 
        List results = null;
        String searchC = Integer.toString(searchCriteria);
        HibernateTemplate t = getHibernateTemplate();
        try{
            results = t.findByNamedQuery("QING_TEST_GETQUALIFIERSBYNAME_SP", new String[]{name, searchC});
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
       
        if (results == null)
            throw new ObjectNotFoundException("no qualifier found in database");
        
        Set<Qualifier> resultSet = new HashSet<Qualifier>(results);
       
        return resultSet;
        
    }
    
    @SuppressWarnings("unchecked")
    public Set<Qualifier> listQualifiersByCode(String code, int searchCriteria) throws InvalidInputException,  ObjectNotFoundException, AuthorizationException {
         if (code == null )
            throw new InvalidInputException();
          
        if (searchCriteria != AuthorizationManager.BEGINWITH && searchCriteria != AuthorizationManager.CONTAINS && searchCriteria != AuthorizationManager.EXACT)
            throw new InvalidInputException(); 
        List results = null;
        String searchC = Integer.toString(searchCriteria);
        HibernateTemplate t = getHibernateTemplate();
        try{
            results = t.findByNamedQuery("QING_TEST_GETQUALIFIERSBYCODE_SP", new String[]{code, searchC});
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
       
        if (results == null)
            throw new ObjectNotFoundException("no qualifier found in database");
        
        Set<Qualifier> resultSet = new HashSet<Qualifier>(results);
       
        return resultSet;
    }
    
    @SuppressWarnings("unchecked")
    public Set<Function> listFunctionsByName(String name, int searchCriteria)throws InvalidInputException,  ObjectNotFoundException, AuthorizationException {
       if (name == null )
            throw new InvalidInputException();
        
       if (searchCriteria != AuthorizationManager.BEGINWITH && searchCriteria != AuthorizationManager.CONTAINS && searchCriteria != AuthorizationManager.EXACT)
            throw new InvalidInputException();  
        List results = null;
        String searchC = Integer.toString(searchCriteria);
        HibernateTemplate t = getHibernateTemplate();
        try{
            results = t.findByNamedQuery("QING_TEST_GETFUNCTIONSBYNAME_SP", new String[]{name, searchC});
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
       
        if (results == null)
            throw new ObjectNotFoundException("no function found in database");
        
        Set<Function> resultSet = new HashSet<Function>(results);
       
        return resultSet;
    }
    
    
    @SuppressWarnings("unchecked")
    public Set<Function> listFunctionsByDescription(String desc, int searchCriteria) throws InvalidInputException, ObjectNotFoundException, AuthorizationException {
        if (desc == null)
            throw new InvalidInputException();
         
        if (searchCriteria != AuthorizationManager.BEGINWITH && searchCriteria != AuthorizationManager.CONTAINS && searchCriteria != AuthorizationManager.EXACT)
            throw new InvalidInputException();
            
        List results = null;
        String searchC = Integer.toString(searchCriteria);
    
        HibernateTemplate t = getHibernateTemplate();
        try{
            results = t.findByNamedQuery("QING_TEST_GETFUNCTIONSBYDESC_SP", new String[]{desc, searchC});
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
       
        if (results == null)
            throw new ObjectNotFoundException("no function found in database");
        
        Set<Function> resultSet = new HashSet<Function>(results);
       
        return resultSet;
    }
    
   /**
     * Create a new authorization
     *
     * @param userName Proxy user name
    *  @param appName Server Name
     * @param function_name function name such as "can spend or commit fund"
     * @param qualifier_code  qualifier_code such as "CATSAP"
     * @param kerberos_name kerberos Id for the auth
     * @param effective_date effective_date when authorization is effective
     * @param expiration_date expiration_date when authorization expires
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String createAuthorization(String userName, String appName, String function_name, String qualifier_code, String kerberos_name,
        String effective_date, String expiration_date, String do_function, String grant_auth) throws InvalidInputException, PermissionException, AuthorizationException, DataAccessException
    {
        if (userName == null || function_name == null || qualifier_code == null || effective_date == null || kerberos_name == null) 
            throw new InvalidInputException();
                
        String pname = userName.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        String qcode = qualifier_code.trim().toUpperCase();
        String kname = kerberos_name.trim().toUpperCase();
        String effdate = effective_date.trim();
        String expdate = expiration_date.trim();
        String var = new String();
        
        if (pname.length() <=0 || kname.length() <= 0 || fname.length() <=0 || qcode.length() <= 0 || effdate.length() <= 0)
            throw new InvalidInputException();
        
        ApplicationContext ctx;
        Map results = null;
        String[] paths = {"rolesApplicationContext.xml"};
        ctx = new ClassPathXmlApplicationContext(paths); 
        
        DataSource datasource = null; 
        String datasourceID = "commonsDataSource";  
        datasource = (DataSource)ctx.getBean(datasourceID);

        CreateAuthProc proc = new CreateAuthProc(datasource);
        results = proc.execute(appName, pname, fname, qcode, kname, effdate, expdate, do_function, grant_auth);
         
        if (null != results.get("modified_by") && null != results.get("modified_date") && null != results.get("authorization_id")) {
            return results.get("authorization_id").toString();
        }
        else {
            return "false";
        }
    }
    
   /**
     * Update an authorization
     *
     * @param userName Proxy User Name
     * @param appName Server Name
     * @param auth_id authorization Id to update
     * @param function_name function name such as "can spend or commit fund"
     * @param qualifier_code  qualifier_code such as "CATSAP"
     * @param kerberos_name kerberos Id for the auth
     * @param effective_date effective_date when authorization is effective
     * @param expiration_date expiration_date when authorization expires
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Boolean updateAuthorization(String userName, String appName, String auth_id, String function_name, String qualifier_code, String kerberos_name,
        String effective_date, String expiration_date, String do_function, String grant_auth) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null || function_name == null || qualifier_code == null || effective_date == null || kerberos_name == null || auth_id == null) 
            throw new InvalidInputException();
        
        String pname = userName.trim().toUpperCase();
        String aId = auth_id.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        String qcode = qualifier_code.trim().toUpperCase();
        String kname = kerberos_name.trim().toUpperCase();
        String effdate = effective_date.trim();
        String expdate = expiration_date.trim();
        String var = new String();
        
        if (pname.length() <=0 || kname.length() <= 0 || fname.length() <=0 || qcode.length() <= 0 || effdate.length() <= 0 || aId.length() <= 0)
            throw new InvalidInputException();
        
        ApplicationContext ctx;
        Map results = null;
        String[] paths = {"rolesApplicationContext.xml"};
        ctx = new ClassPathXmlApplicationContext(paths); 
        
        DataSource datasource = null; 
        String datasourceID = "commonsDataSource";  
        datasource = (DataSource)ctx.getBean(datasourceID);

        UpdateAuthProc proc = new UpdateAuthProc(datasource);
        results = proc.execute(appName, pname, aId, fname, qcode, kname, effdate, expdate, do_function, grant_auth);
        
        if (null != results.get("modified_by") && null != results.get("modified_date")) {
            proc =  null;
            results = null;
            System.gc();
            return Boolean.TRUE;
        }
        else {
           proc =  null;
            results = null;
            System.gc();
            return Boolean.FALSE;
        }
   }    
    
   /**
     * Delete an authorization
     *
     * @param userName Proxy User name
     * @param appName Server Name
     * @param auth_id authorization Id to update
     * @return Boolean.TRUE if the user has such authorization, Boolean.False otherwise
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Boolean deleteAuthorization(String userName, String appName, String auth_id) 
                    throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null || auth_id == null) 
            throw new InvalidInputException();
        
        String pname = userName.trim().toUpperCase();
        String aId = auth_id.trim().toUpperCase();
        
        if (pname.length() <=0 || auth_id.length() <= 0)
            throw new InvalidInputException();
        
        //DeleteAuthProc proc = new DeleteAuthProc(datasource);
        Map results = batchActionDao.batchDelete(appName, pname, aId);
        
        results = null;
        System.gc();
        return Boolean.TRUE;
    }        
    
   /**
     * Delete a batch of authorizations
     *
     * @param userName user's kerberos Id
     * @param deleteIDs comma delimited string of authorization IDs to delete
     * @return Boolean.TRUE if the user can delete the authorizations, false otherwise
     * @return  all the {@link Qualifier} associated with the qualifier type code
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String batchDelete(String userName, String appName, String deleteIDs) 
                    throws InvalidInputException, PermissionException, AuthorizationException
    {
        Boolean each = Boolean.FALSE;

        
        if (userName == null || deleteIDs == null) 
            throw new InvalidInputException();
        
        String pname = userName.trim().toUpperCase();
        
        if (pname.length() <=0)
            throw new InvalidInputException();
        
        String[] ids = deleteIDs.split(",");
        
        int count = 0;
        int notAuth = 0;
         int kerbError = 0;
        int unknown = 0;
       for (int i=0; i<ids.length; i++) 
        {
            try
            {
                each = deleteAuthorization(pname, appName, ids[i]);
                if (each)
                {
                    count++;
                }
            }
            catch(Exception e)
            {
                 if ((e.getMessage().indexOf("ORA-20014") >= 0) || (e.getMessage().indexOf("ORA-20003") >= 0)) {
                    notAuth++;
                }
                 else if (e.getMessage().indexOf("ORA-20030") >= 0) {
                    kerbError++;
                }
                else {
                    unknown++;
                }              
            }
        }
        String resultStr = "" ;
           if (count > 0) {
                   resultStr += count + " authorization(s) successfully deleted; ";
           }
            if (notAuth > 0) {
                  resultStr +=  notAuth + " authorization(s) not deleted  because you  are not authorized; ";
            }
             if (kerbError > 0) {
                resultStr += kerbError + " authorization(s) were not deleted because Kerberos name does not exist;";
            }           
            if (unknown > 0) {
                  resultStr +=   unknown + " authorization(s) not deleted  for unknown reason; ";
            }

       
        return resultStr;
    }     
    
   /**
     * Create a batch of new authorizations
     *
     * @param userName user's kerberos Id
     * @param kerberos_name kerberos name to which new authorizations are assigned
     * @param authIDs comma delimited string of authorization IDs to create
     * @return string of authorization IDs that were updated
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String batchCreate(String userName, String appName, String kerberos_name, String authIDs) throws InvalidInputException, PermissionException, AuthorizationException, DataAccessException
    {
        if (null == userName || null == authIDs || null == kerberos_name ) 
            throw new InvalidInputException();
                
        String pname = userName.trim().toUpperCase();
        String kname = kerberos_name.trim().toUpperCase();
        int noChange = 0;
        int notAuth = 0;
        int kerbError = 0;        
        int unknown = 0;
        int updated = 0;
        String retString = new String();
        

        String[] ids = authIDs.split(",");

        String idString = new String();
        boolean success = true;
        
        if (pname.length() <=0 || kname.length() <= 0 )
            throw new InvalidInputException();
        
        ApplicationContext ctx;
        Map results = null;
        String[] paths = {"rolesApplicationContext.xml"};
        ctx = new ClassPathXmlApplicationContext(paths); 
        
        DataSource datasource = null; 
        String datasourceID = "commonsDataSource";  
        datasource = (DataSource)ctx.getBean(datasourceID);

        //BatchCreateAuthProc proc = new BatchCreateAuthProc(datasource);
        for (int i=0; i<ids.length; i++) 
        {
            try 
            {
                 results = batchActionDao.batchCreate(appName, pname, kname, ids[i]);
                if (null != results.get("modified_by") && null != results.get("modified_date") && null != results.get("authorization_id")) {
                    idString += results.get("authorization_id").toString() + ",";
                    updated++;
                }
                else {
                    success = false;
                }
            }
            catch (DataAccessException e) 
            {
                success = false;
                System.out.println(e.getMessage());
                if ((e.getMessage().indexOf("ORA-20014") >= 0) || (e.getMessage().indexOf("ORA-20003") >= 0)) {
                    notAuth++;
                }
                else if (e.getMessage().indexOf("ORA-20007") >= 0) {
                    noChange++;
                }
                else if (e.getMessage().indexOf("ORA-20030") >= 0) {
                    kerbError++;
                }
                else {
                    unknown++;
                }
            }
        }
        
        if (success) {
            return "All " + updated + " authorization(s) created successfully";
        }
        else if (idString.length() == 0) {
            
            if (updated > 0)
                   retString += updated + " authorization(s) successfully created; ";
            if (notAuth > 0) {
                  retString +=  notAuth + " authorization(s) not created  because you  are not authorized; ";
            }
             if (kerbError > 0) {
                retString += kerbError + " authorization(s) were not created because Kerberos name (" + kname + ") does not exist; ";
            }           
            if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not created  for unknown reason; ";
            }
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not created  because the authorization(s) already exist";
 
            }
            retString += ".";
            return retString;            
 

        }
        else {
            if (updated > 0)
                   retString += updated + " authorization(s) successfully created; ";
            if (notAuth > 0) {
                  retString +=  notAuth + " authorization(s) not created  because you  are not authorized; ";
            }
             if (kerbError > 0) {
                retString += kerbError + " authorization(s) were not created because Kerberos name (" + kname + ") does not exist;";
            }           
            if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not created  for unknown reason; ";
            }
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not created  because the authorization(s) already exist.";
 
            }
            return retString;
        }
    }    
       

   /**
     * Replace a batch of authorizations
     *
     * @param userName user's kerberos Id
     * @param kerberos_name kerberos name to which new authorizations are assigned
     * @param authIDs comma delimited string of authorization IDs to replace
     * @return string of authorization IDs that were updated
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String batchReplace(String userName, String appName, String kerberos_name, String authIDs) throws InvalidInputException, PermissionException, AuthorizationException, DataAccessException
    {
        if (null == userName || null == authIDs || null == kerberos_name ) 
            throw new InvalidInputException();
                
        String pname = userName.trim().toUpperCase();
        String kname = kerberos_name.trim().toUpperCase();

        String[] ids = authIDs.split(",");
        int noChange = 0;
        int notAuth = 0;
        int kerbError = 0;        
        int unknown = 0;
        String retString = new String();        

        String idString = new String();
        String delIDs = new String();
        boolean success = true;
        
        if (pname.length() <=0 || kname.length() <= 0 )
            throw new InvalidInputException();
        
        Map results = null;

        int createdIdCount = 0;
            for (int i=0; i<ids.length; i++) 
            {
                    try 
                    {
                            Boolean b = batchActionDao.batchReplace(appName, pname, kname, ids[i]);
                            if ( b ) 
                            {
                                 createdIdCount++;
                            }
                             else {
                                success = false;
                            }                          
                    }
                    catch(Exception e)
                    {   
                        success = false;
                        Throwable t = e.getCause();
                        SQLException se = null;
                          if(t != null && t instanceof org.hibernate.exception.SQLGrammarException)
                          {
                                se = ((org.hibernate.exception.SQLGrammarException) t).getSQLException();
                          }
                          else if(e.getCause() instanceof SQLException){
                                se = (SQLException)e.getCause();
                          }
                          if (null != se)
                          {
                                 if ((e.getMessage().indexOf("ORA-20014") >= 0 || (e.getMessage().indexOf("ORA-20003") >= 0))) {
                                    notAuth++;
                                }
                                else if (e.getMessage().indexOf("ORA-20002") >= 0) {
                                    noChange++;
                                }
                                else if (e.getMessage().indexOf("ORA-20030") >= 0) {
                                    kerbError++;
                                }
                                else if (e.getMessage().indexOf("ORA-20007") >= 0) {
                                noChange++;
                                }  
                                else {
                                    unknown++;
                                } 
                           }
                          else
                              unknown++;                        
                    }
            }
        
          if (success ) {
            return "All " + createdIdCount + " authorization(s) replaced successfully. " ;
        }
        else {
            
                   retString += createdIdCount + " authorization(s) successfully replaced.  ";
  
            if (notAuth > 0) {
                  retString +=   notAuth + " authorization(s) not replaced  because you are not authorized. ";
            }
            if (kerbError > 0) {
                retString +=  kerbError + " authorization(s) were not replaced because Kerberos name (" + kname + ") does not exist. ";
            }          
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not replaced  because the authorization(s) already exist. ";
            }
                
             if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not replaced  for unknown reason. ";
            }

            return retString;

        }                     
                        /*
                     }
        int createdIdCount = 0;
            for (int i=0; i<ids.length; i++) 
            {
                    try 
                    {
                            results = null;
                            results = batchActionDao.batchCreate(appName, pname, kname, ids[i]);
                            if ( null != results.get("authorization_id")  ) 
                            {
                                idString +=  results.get("authorization_id") + ",";
                                delIDs +=  results.get("authorization_id") + ",";
                                createdIdCount++;
                            }
                            else {
                                success = false;
                                System.out.println("False");
                            }
                    }
                    catch(Exception e)
                    {
                        success = false;
                        Throwable t = e.getCause();
                        SQLException se = null;
                          if(t != null && t instanceof org.hibernate.exception.SQLGrammarException)
                          {
                                se = ((org.hibernate.exception.SQLGrammarException) t).getSQLException();
                          }
                          else if(e.getCause() instanceof SQLException){
                                se = (SQLException)e.getCause();
                          }
                          if (null != se)
                          {
                                 if ((e.getMessage().indexOf("ORA-20014") >= 0 || (e.getMessage().indexOf("ORA-20003") >= 0))) {
                                    notAuth++;
                                }
                                else if (e.getMessage().indexOf("ORA-20002") >= 0) {
                                    noChange++;
                                }
                                else if (e.getMessage().indexOf("ORA-20030") >= 0) {
                                    kerbError++;
                                }
                                else if (e.getMessage().indexOf("ORA-20007") >= 0) {
                                noChange++;
                                }  
                                else {
                                    unknown++;
                                } 
                           }
                          else
                              unknown++;
 
                    }                    
                    
            }
       
        
        int deletedCount = 0;
        int deleteError = 0;
        String deleteException = "";
        if (idString.length() > 0)
        {
            idString = idString.substring(0, idString.length()-1);
            delIDs = delIDs.substring(0, idString.length()-1);
            Boolean delStatus =  null;

            String[] delids = delIDs.split(",");

            
            for (int i=0; i<delids.length; i++) 
            {
                try
                {
                    Boolean each = deleteAuthorization(pname, appName, delids[i]);
                    if (each)
                    {
                        deletedCount++;
                    }
                }
                catch(Exception e)
                {
                        deleteError++;
                        Throwable t = e.getCause();
                        SQLException se = null;
                          if(t != null && t instanceof org.hibernate.exception.SQLGrammarException)
                          {
                                se = ((org.hibernate.exception.SQLGrammarException) t).getSQLException();
                          }
                          else if(e.getCause() instanceof SQLException){
                                se = (SQLException)e.getCause();
                          }
                          if (null != se)
                          {
                            deleteException = deleteException +  " Delete Error: " + e.getLocalizedMessage() + ";";
                          }
                }
            }
        }
    
        if (success && createdIdCount == ids.length && deletedCount == createdIdCount) {
            return "All " + createdIdCount + " authorization(s) replaced successfully. " + delIDs + " deleted. ";
        }
        else if (idString.length() == 0) {
            
           if (deletedCount == createdIdCount && createdIdCount > 0)
                   retString += createdIdCount + " authorization(s) successfully replaced.  "+ delIDs + " deleted. ";
           else if (deletedCount < createdIdCount)
           {
                    retString += createdIdCount + " authorization(s) successfully created. " + delIDs + " deleted. ";
             
           }
           //if (deleteError > 0)
           //{
            //   retString += deleteException;
          // }
            if (notAuth > 0) {
                  retString +=   notAuth + " authorization(s) not replaced  because you are not authorized. ";
            }
            if (kerbError > 0) {
                retString +=  kerbError + " authorization(s) were not replaced because Kerberos name (" + kname + ") does not exist. ";
            }          
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not replaced  because the authorization(s) already exist. ";
            }
                
             if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not replaced  for unknown reason. ";
            }

            return retString;

        }
        else {
            if (deletedCount == createdIdCount && createdIdCount > 0)
                   retString += createdIdCount + " authorization(s) successfully replaced. " + delIDs + " deleted. ";
           else if (deletedCount < createdIdCount)
           {
                    retString += createdIdCount + " authorization(s) successfully created. " + delIDs + " deleted. ";
             
           }
            if (notAuth > 0) {
                  retString +=   notAuth + " authorization(s) not replaced  because you are not authorized. ";
            }
           // if (deleteError > 0)
          // {
         //      retString += deleteException;
         //  }
          
           if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not replaced  for unknown reason ";
            }
            if (kerbError > 0) {
                retString +=  kerbError + " authorization(s) were not replaced because Kerberos name (" + kname + ") does not exist; ";
            }          
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not replaced  because the authorization(s) already exist";
 
            }

            return retString;
        }
          */
    }    
        
    
   /**
     * Update a batch of authorizations
     *
     * @param userName user's kerberos Id
     * @param appName application Name
     * @param authIDs comma delimited string of authorization IDs to update
     * @param effective_date effective_date when authorization is effective
     * @param expiration_date expiration_date when authorization expires
     * @return Output message
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String batchUpdate(String userName, String appName, String authIDs, String effective_date, String expiration_date ) throws InvalidInputException, PermissionException, AuthorizationException, DataAccessException
    {
        if (null == userName || null == authIDs || null == effective_date) 
            throw new InvalidInputException();
                
        String pname = userName.trim().toUpperCase();
        int noChange = 0;
        int notAuth = 0;
        int unknown = 0;
        int updated = 0;
        String retString = new String();

        String[] ids = authIDs.split(",");

        String idString = new String();        
        boolean success = true;
        
        if (pname.length() <=0)
            throw new InvalidInputException();
        
        
        //BatchUpdateAuthProc proc = new BatchUpdateAuthProc(datasource);
        
        try 
        {
            for (int i=0; i<ids.length; i++) 
            {
                try
                {
                    Map results = batchActionDao.batchUpdate(appName, pname, ids[i], effective_date, expiration_date);
                    if (null != results.get("modified_by") && null != results.get("modified_date")) {
                        idString += ids[i] + ",";
                        updated++;
                    }
                    else {
                        success = false;
                }               }
                catch(Exception e)
                {
                        success = false;
                        Throwable t = e.getCause();
                        SQLException se = null;
                          if(t != null && t instanceof org.hibernate.exception.SQLGrammarException)
                          {
                                se = ((org.hibernate.exception.SQLGrammarException) t).getSQLException();
                          }
                          else if(e.getCause() instanceof SQLException){
                                se = (SQLException)e.getCause();
                          }
                          if (null != se)
                          {
                                String msg = se.getMessage();
                                String errorMessage = se.getMessage() +  " Error Code: " + se.getErrorCode() ;                        
                                if (e.getMessage().indexOf("ORA-20014") >= 0) {
                                    notAuth++;
                                }
                                else if (e.getMessage().indexOf("ORA-20002") >= 0) {
                                    noChange++;
                                }
                                else {
                                    unknown++;
                                } 
                           }
                          else
                              unknown++;
 
                    }
        }
        }
        catch (Exception e) {
            success = false;
            System.out.println(e.getMessage());
            if (e.getMessage().indexOf("ORA-20014") >= 0) {
              notAuth++;
            }
            else if (e.getMessage().indexOf("ORA-20002") >= 0) {
                noChange++;
            }
            else {
                unknown++;
            }
        }
        
        
        if (success) {
            return "All " + updated + " authorization(s) updated successfully";
        }
        else if (idString.length() == 0) {
            if (updated > 0)
                   retString += updated + " authorization(s) successfully updated; ";
            if (notAuth > 0) {
                  retString +=  notAuth + " authorization(s) not updated  because you  are not authorized; ";
            }
            if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not updated  for unknown reason; ";
            }
            if (noChange > 0) {
                retString +=   noChange + " authorization(s) not updated  as there were no changes to be made.";
 
            }

            return retString;
        }
        else {
             if (updated > 0)
                   retString += updated + " authorization(s) successfully updated; ";
            if (notAuth > 0) {
                  retString +=   notAuth + " authorization(s) not updated  because you  are not authorized; ";
            }
            if (unknown > 0) {
                  retString +=   unknown + " authorization(s) not updated  for unknown reason; ";
            }
            if (noChange > 0) {
                retString +=  noChange + " authorization(s) not updated  as there were no changes to be made.";
 
            }
            return retString;
         }
    }        
    
   /**
     * Save criteria
     *
     * @param userName user's kerberos Id
     * @param appName application Id
     * @param selection_id selection id of criteria
     * @param criteria_list list of criteria
     * @param value_list list of values
     * @param apply_list list of Y/N values for apply
     * @return string of authorization IDs that were updated
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String saveCriteria(String userName, String appName, String selection_id, String criteria_list, String value_list, String apply_list) throws InvalidInputException
    {
        if (null == userName || null == appName || null == selection_id || null == criteria_list || null == value_list || null == apply_list) 
            throw new InvalidInputException();
                
        String pname = userName.trim().toUpperCase();

        String[] crits = criteria_list.split(",");
        String[] values = value_list.split(",");
        String[] applys = apply_list.split(",");

        String idString = new String();
        boolean success = true;
        
        if (pname.length() <= 0)
            throw new InvalidInputException();
        
        ApplicationContext ctx;
        Map results = null;
        String[] paths = {"rolesApplicationContext.xml"};
        ctx = new ClassPathXmlApplicationContext(paths); 
        
        DataSource datasource = null; 
        String datasourceID = "commonsDataSource";  
        datasource = (DataSource)ctx.getBean(datasourceID);

        SaveCriteriaProc proc = new SaveCriteriaProc(datasource);
        try {
            for (int i=0; i<crits.length; i++) {
                results = proc.execute(appName, selection_id, crits[i], pname, applys[i], values[i]);
            }
        }
        catch (DataAccessException e) {
            System.out.println(e.getMessage());
            success = false;
        }
        
        
        if (success) {
            return "Criteria set successfully saved";
        }
        else {
            return "Criteria set could not saved successfully";
        }
    }        
    
    /**
     * Select Categories for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Collection<PickableCategory> listFunctionCategories(String userName) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (userName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        
        if (pname.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
               
        Collection categories = null;
        try{
            categories = t.findByNamedQuery("FUNCTION_CATEGORY_LIST", pname);
            //categories = t.findByNamedQuery("FUNCTION_CATEGORY_LIST");
            t.initialize(categories);
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
        
        if (categories == null )
            throw new AuthorizationException("error retrieving categories for user " + userName);
       
        return categories;
    }
    
    /**
     * Select Functions for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Collection<PickableFunction> listPickableFunctionsByCategory(String userName, String category) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || null == category) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String cat = category.trim().toUpperCase();
        
        if (pname.length() <= 0 || cat.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection functions = null;
        try{
            functions = t.findByNamedQuery("FUNCTION_LIST_FOR_CATEGORY", new String[]{pname, cat});
            //System.out.println(t.toString());
            t.initialize(functions);
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
        
        if (functions == null )
            throw new AuthorizationException("error retrieving functions for user " + userName);
       
        return functions;
    }    
    
    /**
     * Select QualifierType for given Function
     *
     * @param userName user's kerberos Id
     * @param category function category
     * @param function_name function name
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String getQualifierTypeforFunction(String userName, String category, String function_name) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || null == category || null == function_name) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String cat = category.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        
        if (pname.length() <= 0 || cat.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<Function> functions = null;
        try{
            functions = t.findByNamedQuery("GET_FUNCTION_BY_CATEGORY_FUNCTION_NAME", new String[]{cat, fname});
            //System.out.println(t.toString());
            t.initialize(functions);
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


                    else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
               
        if (functions == null )
            throw new AuthorizationException("error retrieving functions for user " + userName);
            
        return functions.iterator().next().getFqt().getType();
    }     
    
    
     /**
     * Select QualifierType for given Function
     *
     * @param userName user's kerberos Id
     * @param category function category
     * @param function_name function name
     * @throws  InvalidInputException if function desc code is NULL 
     * @throws  ObjectNotFoundException If no Function is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String getFunctionDesc(String userName, String category, String function_name) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || null == category || null == function_name) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String cat = category.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        
        if (pname.length() <= 0 || cat.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<PickableFunction> descs = null;
        try{
            descs = t.findByNamedQuery("QUERY_GETFUNCTIONDESC", new String[]{pname, cat, fname});
            //System.out.println(t.toString());
            t.initialize(descs);
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
               
        if (descs == null || descs.size() == 0)
            throw new AuthorizationException("error retrieving functions desc for func " + userName);
         
        PickableFunction  f = descs.iterator().next();
        return (f.getDescription());
    }        
        
    /**
     * Select Qualifiers for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @param function_name funtion name
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Set<PickableQualifier> listPickableQualifiers(String userName, String function_name) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || null == function_name) 
            throw new InvalidInputException();
     
        String pname = userName.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        
        if (pname.length() <= 0 || fname.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection quals = null;
        try{
            quals = t.findByNamedQuery("PICKABLE_QUALIFIER_LIST", new String[]{pname, fname, pname, fname, pname, fname,pname, fname,pname, fname });
            //System.out.println(t.toString());
            t.initialize(quals);
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
       
        
        if (quals == null )
            throw new AuthorizationException("error retrieving qualifiers for user " + userName);
       
        Set<PickableQualifier> qualSet = new HashSet<PickableQualifier>(quals);
        return qualSet;
    }        
    
    /**
     * Select Qualifiers for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @param function_name funtion name
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String getQualifierXML(String userName, String function_name, String qualifier_type) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || null == function_name) 
            throw new InvalidInputException();
     
        StringBuffer xmlBuff = new StringBuffer();
        Iterator qIt = null;
        PickableQualifier xmlqual = null;
        String pname = userName.trim().toUpperCase();
        String fname = function_name.trim().toUpperCase();
        String qtype = "ZLEVELS_" + qualifier_type.trim().toUpperCase();

        total_qualifiers=0;
        
        if (pname.length() <= 0 || fname.length() <= 0)
            throw new InvalidInputException();

        HibernateTemplate t1 = getHibernateTemplate();
        Collection<LevelCount> lc = null;
        
        try{
            lc = t1.findByNamedQuery("GET_LEVEL_FOR_QUAL_TYPE", new String[]{qtype, qtype});
            //System.out.println(t1.toString());
            t1.initialize(lc);
        }      

        catch(DataAccessException e){
           if(e.getCause() instanceof SQLException){
               SQLException se = (SQLException)e.getCause();
               int i = se.getErrorCode();
               String msg = se.getMessage();
               int index =msg.indexOf("\n");
               if (index >0)
                   msg = msg.substring(0, index);
               if (i == InvalidInputException.FunctionCategoryInvalidLength || i == InvalidInputException.FunctionNameInvalidLength ||
                       i == InvalidInputException.NeedKerberosName || i==InvalidInputException.NeedFunctionCategory || 
                       i==InvalidInputException.InvalidFunction || i==InvalidInputException.QualifierTypeInvalidLength)
                   throw new InvalidInputException(msg, i);
               
               else if (i == PermissionException.ProxyNotAuthorized || i == PermissionException.ServerNotAuthorized)
                 throw new PermissionException(msg, i);
                else
                    throw new AuthorizationException(se.getMessage() + "\n" + "Error Code: " + se.getErrorCode() + "\n" + " Cause: " + se.getCause() );
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
        
        int val = Integer.parseInt(lc.iterator().next().getValue()) - 1;
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<PickableQualifier> quals = null;
        
        try{
            quals = t.findByNamedQuery("PICKABLE_QUALIFIER_LIST", new String[]{pname, fname});
            //System.out.println(t.toString());
            t.initialize(quals);
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
       
        xmlBuff.append("<qualifiers>");
        
        if (quals == null )
            throw new AuthorizationException("error retrieving qualifiers for user " + userName);
       
        //Set<PickableQualifier> qualSet = new HashSet<PickableQualifier>(quals);
        //System.out.println(quals.size());
        //System.out.println(qualSet.size());
        
        //qIt = qualSet.iterator();
        qIt = quals.iterator();
        
        while(qIt.hasNext()) {
            total_qualifiers++;
            //System.out.println("Total = " + total_qualifiers);
            xmlqual = (PickableQualifier)qIt.next();
            xmlBuff.append("<qualifier>");
            xmlBuff.append("<qid>");
            xmlBuff.append(xmlqual.getId().getId());
            xmlBuff.append("</qid>");
            xmlBuff.append("<expanded>");
            xmlBuff.append("true");
            xmlBuff.append("</expanded>");
            xmlBuff.append("<qcode>");
            xmlBuff.append(cleanup(xmlqual.getQcode(), false));
            xmlBuff.append("</qcode>");            
            xmlBuff.append("<qname>");
            xmlBuff.append(cleanup(xmlqual.getId().getName(), false));
            xmlBuff.append("</qname>");
            xmlBuff.append("<hasChild>");
            xmlBuff.append(cleanup(xmlqual.getId().getHasChild().toString(), false));
            xmlBuff.append("</hasChild>");            
            if (xmlqual.getId().getHasChild() && total_qualifiers < 2000) 
            {
                xmlBuff.append("<qchildren>");
                xmlBuff.append(getChildrenXML(xmlqual.getId().getId().toString(), 1, val));
                xmlBuff.append("</qchildren>");
            }
            xmlBuff.append("</qualifier>");
        }
        
        xmlBuff.append("</qualifiers>");
        //System.out.println("Final Buffer = " + xmlBuff.toString());
        return xmlBuff.toString();
    }            
    
    
     /**
     * Select Criteria Qualifiers for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @param functionName funtion name
     * @param qualifierType Qualifer Type
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String getQualifierXMLForCriteriaQuery(String userName, String functionName, String qualifierType) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName || ( ( null == functionName)  && (null == qualifierType)))
            throw new InvalidInputException();
     
        StringBuffer xmlBuff = new StringBuffer();
        Iterator qIt = null;
        Qualifier xmlqual = null;
        String pname = userName.trim().toUpperCase();
        String fname = "";
         String qtype = "";
        if (null != functionName)
        {
            fname = functionName.trim().toUpperCase();
        }
         if (null != qualifierType)
        {
            qtype = qualifierType.trim().toUpperCase();
        }
       // String qtype = "ZLEVELS_" + qualifier_type.trim().toUpperCase();

        total_qualifiers=0;
        
        if (pname.length() <= 0 || (fname.length() <= 0 && qtype.length() <= 0))
            throw new InvalidInputException();


        HibernateTemplate t = getHibernateTemplate();
        Collection<Qualifier> quals = null;
        
        try{
            if (qtype.length() > 0 )
            {   
                quals = t.findByNamedQuery("QUALIFIER_ROOT_LIST", new String[]{ qtype});
                
            }
            else
            {
                quals = t.findByNamedQuery("QUALIFIER_LIST_FOR_CRITERIA_LIST", new String[]{ fname});
            }
            //System.out.println(t.toString());
            t.initialize(quals);
     }
       
        catch(DataAccessException e){
           Exception  re = (Exception) e.getCause();
           e.printStackTrace();
           
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
       
        xmlBuff.append("<qualifiers>");
        
        if (quals == null )
            throw new AuthorizationException("error retrieving qualifiers for user " + userName);
       
        //Set<PickableQualifier> qualSet = new HashSet<PickableQualifier>(quals);
        //System.out.println(quals.size());
        //System.out.println(qualSet.size());
        
        //qIt = qualSet.iterator();
        qIt = quals.iterator();
       
        
        while(qIt.hasNext()) {
            total_qualifiers++;
            //System.out.println("Total = " + total_qualifiers);
            xmlqual = (Qualifier)qIt.next();
            xmlBuff.append("<qualifier>");
            xmlBuff.append("<qid>");
            xmlBuff.append(xmlqual.getId());
            xmlBuff.append("</qid>");
            xmlBuff.append("<expanded>");
            xmlBuff.append("true");
            xmlBuff.append("</expanded>");
            xmlBuff.append("<qcode>");
            xmlBuff.append(cleanup(xmlqual.getCode(), false));
            xmlBuff.append("</qcode>");            
            xmlBuff.append("<qname>");
            xmlBuff.append(cleanup(xmlqual.getName(), false));
            xmlBuff.append("</qname>");
            xmlBuff.append("<hasChild>");
            xmlBuff.append(cleanup(xmlqual.getHasChild().toString(), false));
            xmlBuff.append("</hasChild>");           
            // Get children only for non DEPT qualifyers
            if ( xmlqual.getHasChild() ) {
                    xmlBuff.append("<qchildren>");
                    xmlBuff.append(getChildrenXML(xmlqual.getId().toString(), 1, 1));
                    xmlBuff.append("</qchildren>");
            }
            xmlBuff.append("</qualifier>");
        }
        
        xmlBuff.append("</qualifiers>");
        //System.out.println("Final Buffer = " + xmlBuff.toString());
        return xmlBuff.toString();
    }            
    
    /**
     * Select Qualifiers for which userName is authorized. 
     *
     * @param userName user's kerberos Id
     * @param function_name funtion name
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public String getQualifierXML(String root_id, Boolean rbool, String qualifier_type) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == root_id) 
            throw new InvalidInputException();
     
        StringBuffer xmlBuff = new StringBuffer();
        Iterator qIt = null;
        QualRoot xmlqual = null;
        String root = root_id.trim().toUpperCase();
        String qtype = "ZLEVELS_" + qualifier_type.trim().toUpperCase();
        
        total_qualifiers=0;
        
        if (root.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t1 = getHibernateTemplate();
        Collection<LevelCount> lc = null;
        
        try{
            lc = t1.findByNamedQuery("GET_LEVEL_FOR_QUAL_TYPE", new String[]{qtype, qtype});
            //System.out.println(t1.toString());
            t1.initialize(lc);
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
        
        int val = Integer.parseInt(lc.iterator().next().getValue()) - 1;    
        //System.out.println("Level = " + val);
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<QualRoot> quals = null;
        try{
            quals = t.findByNamedQuery("GET_QUALIFIER_FOR_ROOT", root);
            t.initialize(quals);
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
        xmlBuff.append("<qualifiers>");
        
        if (quals == null )
            throw new AuthorizationException("error retrieving root qualifier with id " + root_id);
       
        qIt = quals.iterator();
        if (rbool.booleanValue()) {
            while(qIt.hasNext()) {
                total_qualifiers++;
                xmlqual = (QualRoot)qIt.next();
                xmlBuff.append("<qualifier>");
                xmlBuff.append("<qid>");
                xmlBuff.append(xmlqual.getId());
                xmlBuff.append("</qid>");
                xmlBuff.append("<expanded>");
                xmlBuff.append("true");
                xmlBuff.append("</expanded>");            
                xmlBuff.append("<qcode>");
                xmlBuff.append(cleanup(xmlqual.getCode(), false));
                xmlBuff.append("</qcode>");            
                xmlBuff.append("<qname>");
                xmlBuff.append(cleanup(xmlqual.getName(), false));
                xmlBuff.append("</qname>");
                xmlBuff.append("<hasChild>");
                xmlBuff.append(cleanup(xmlqual.getHasChild().toString(), false));
                xmlBuff.append("</hasChild>");            
                if (xmlqual.getHasChild()&& total_qualifiers < 500) {
                    xmlBuff.append("<qchildren>");
                    xmlBuff.append(getChildrenXML(xmlqual.getId().toString(), 1, val));
                    xmlBuff.append("</qchildren>");
                }
                xmlBuff.append("</qualifier>");
            }
        }
        else {
            while(qIt.hasNext()) {
                total_qualifiers++;
                xmlqual = (QualRoot)qIt.next();
                if (xmlqual.getHasChild()&& total_qualifiers < 500) {
                    xmlBuff.append(getChildrenXML(xmlqual.getId().toString(), 1, 1));
                }        
            }
        }
        
        xmlBuff.append("</qualifiers>");
        return xmlBuff.toString();
    }                
    
    /**
     * Select categories which username is authorized to view. 
     *
     * @param userName user's kerberos Id
     * @throws  InvalidInputException if qualifier type code is NULL or if the code is more than 4 characters long
     * @throws  ObjectNotFoundException If no Qualifier is found 
     * @throws  AuthorizationException  in case of hibernate error   
     */  
    public Collection<ViewableCategory> getViewableCategory(String userName) throws InvalidInputException, PermissionException, AuthorizationException
    {
        if (null == userName) 
            throw new InvalidInputException();
     
        Iterator vIt = null;
        ViewableCategory cat = null;
        String name = userName.trim().toUpperCase();
                
        if (name.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<ViewableCategory> cats = null;
        try{
            cats = t.findByNamedQuery("VIEWABLE_CATEGORY_LIST", name);
            //System.out.println(t.toString());
            t.initialize(cats);
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
       
        if (cats == null )
            throw new AuthorizationException("error retrieving viewable categories");

        return cats;
    }        
    
    public Collection<ViewableFunction> getViewableFunctionByCategory(String category) throws InvalidInputException, PermissionException, AuthorizationException 
    {
        if (null == category) 
            throw new InvalidInputException();
     
        Iterator vIt = null;
        ViewableFunction func = null;
        String cat  = category.trim().toUpperCase();
                
        if (cat.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        Collection<ViewableFunction> funcs = null;
        try{
            funcs = t.findByNamedQuery("ALL_FUNCTIONS_FOR_CAT", cat);
            t.initialize(funcs);
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
       
        if (funcs == null )
            throw new AuthorizationException("error retrieving viewable categories");

        return funcs;        
    }


    public class UpdateAuthProc extends StoredProcedure {
        private static final String PROC_STATEMENT = "ROLESAPI_UPDATE_AUTH1";
        
        public UpdateAuthProc(DataSource dataSource) {    
            super(dataSource, PROC_STATEMENT);
            int types = Types.VARCHAR;
            declareParameter(new SqlParameter("server_id", types));
            declareParameter(new SqlParameter("for_user", types));
            declareParameter(new SqlParameter("authorization_id", types));
            declareParameter(new SqlParameter("function_name", types));
            declareParameter(new SqlParameter("qualifier_code", types));
            declareParameter(new SqlParameter("kerberos_name", types));
            declareParameter(new SqlParameter("do_function", Types.CHAR));
            declareParameter(new SqlParameter("grant_and_view", Types.CHAR));
            declareParameter(new SqlParameter("descend", Types.CHAR));
            declareParameter(new SqlParameter("effective_date", types));
            declareParameter(new SqlParameter("expiration_date", types));
            declareParameter(new SqlOutParameter("modified_by", types));	
            declareParameter(new SqlOutParameter("modified_date", types));
            
            compile();
	}
                
        public Map execute(String server_id, String for_user, String authorization_id, String function_name, String qualifier_code, 
                           String kerberos_name, String effective_date, String expiration_date, String do_function, String grant_auth)  throws DataAccessException {
            Map inParam = new HashMap(1);
            inParam.put("server_id", server_id);
            inParam.put("for_user", for_user);
            inParam.put("authorization_id", authorization_id);
            inParam.put("function_name", function_name);
            inParam.put("qualifier_code", qualifier_code);
            inParam.put("kerberos_name", kerberos_name);
            inParam.put("do_function", do_function);
            inParam.put("grant_and_view", grant_auth);
            inParam.put("descend", "Y");
            inParam.put("effective_date", effective_date);
            inParam.put("expiration_date", expiration_date);
            return super.execute(inParam);
	}
    }       
    
    public class CreateAuthProc extends StoredProcedure {
        private static final String PROC_STATEMENT = "ROLESAPI_CREATE_AUTH";
        
        public CreateAuthProc(DataSource dataSource) {    
            super(dataSource, PROC_STATEMENT);
            int types = Types.VARCHAR;
            declareParameter(new SqlParameter("server_id", types));
            declareParameter(new SqlParameter("for_user", types));
            declareParameter(new SqlParameter("function_name", types));
            declareParameter(new SqlParameter("qualifier_code", types));
            declareParameter(new SqlParameter("kerberos_name", types));
            declareParameter(new SqlParameter("do_function", Types.CHAR));
            declareParameter(new SqlParameter("grant_and_view", Types.CHAR));
            declareParameter(new SqlParameter("descend", Types.CHAR));
            declareParameter(new SqlParameter("effective_date", types));
            declareParameter(new SqlParameter("expiration_date", types));
            declareParameter(new SqlOutParameter("modified_by", types));	
            declareParameter(new SqlOutParameter("modified_date", types));
            declareParameter(new SqlOutParameter("authorization_id", types));
            
            compile();
	}
                
        public Map execute(String server_id, String for_user, String function_name, String qualifier_code, String kerberos_name, 
                           String effective_date, String expiration_date, String do_function, String grant_auth)  throws DataAccessException {
            Map inParam = new HashMap(1);
            inParam.put("server_id", server_id);
            inParam.put("for_user", for_user);
            inParam.put("function_name", function_name);
            inParam.put("qualifier_code", qualifier_code);
            inParam.put("kerberos_name", kerberos_name);
            inParam.put("do_function", do_function);
            inParam.put("grant_and_view", grant_auth);
            inParam.put("descend", "Y");
            inParam.put("effective_date", effective_date);
            inParam.put("expiration_date", expiration_date);
            return super.execute(inParam);
	}
    }  
    

        
    
     
    public class SaveCriteriaProc extends StoredProcedure {
        private static final String PROC_STATEMENT = "ROLESAPI_UPDATE_USER_CRITERIA";
        
        public SaveCriteriaProc(DataSource dataSource) {    
            super(dataSource, PROC_STATEMENT);
            int types = Types.VARCHAR;
            declareParameter(new SqlParameter("server_id", types));
            declareParameter(new SqlParameter("selection_id", types));
            declareParameter(new SqlParameter("criteria_id", types));
            declareParameter(new SqlParameter("username", types));
            declareParameter(new SqlParameter("apply", types));
            declareParameter(new SqlParameter("value", Types.CHAR));
            
            compile();
	}
                
        public Map execute(String server_id, String selection_id, String criteria_id, String username, String apply, String value)  throws DataAccessException {
            Map inParam = new HashMap(1);
            inParam.put("server_id", server_id);
            inParam.put("selection_id", selection_id);
            inParam.put("criteria_id", criteria_id);
            inParam.put("username", username);
            inParam.put("apply", apply);
            inParam.put("value", value);
            return super.execute(inParam);
	}
    }      
    
    protected String getChildrenXML(String parent_id, int current_level, int max_level) {
        HibernateTemplate t = getHibernateTemplate();
        StringBuffer childXML = new StringBuffer();
        Collection<QualBase> quals = null;
        try{
            quals = t.findByNamedQuery("GET_QUALBASE", parent_id);
            t.initialize(quals);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        Iterator ci = quals.iterator();
        while (ci.hasNext()) {
            total_qualifiers++;
            childXML.append("<qualifier>");
            childXML.append("<qid>");
            QualBase child = (QualBase)ci.next();
            childXML.append(child.getId());
            childXML.append("</qid>");
            childXML.append("<expanded>");
            if (current_level < max_level && total_qualifiers < 500) {
                childXML.append("true");    
            }
            else {
                childXML.append("false");
            }
            childXML.append("</expanded>");            
            childXML.append("<level>");
            childXML.append(current_level);
            childXML.append("</level>");
            childXML.append("<qcode>");
            childXML.append(cleanup(child.getCode(), false));
            childXML.append("</qcode>");                 
            childXML.append("<qname>");
            childXML.append(cleanup(child.getName(), false));
            childXML.append("</qname>");
            childXML.append("<hasChild>");
            childXML.append(cleanup(child.getHasChild().toString(), false));
            childXML.append("</hasChild>");                        
            if (current_level < max_level && total_qualifiers < 500) {
                if (child.getHasChild()) {
                    childXML.append("<qchildren>");
                    childXML.append(getChildrenXML(child.getId().toString(), current_level+1, max_level));
                    childXML.append("</qchildren>");
                }                
            }
            childXML.append("</qualifier>");
        }
        return childXML.toString();
    }
 
    protected String cleanup(String str, boolean decode) {
        String saXMLEquivalent[] = {"&amp;", "&apos;", "&quot;", "&lt;", "&gt;"};
        String saSpecialChars[] = {"&", "\'", "\"", "<", ">"};
        String sFind;
        String sReplace;
        boolean bFound;
        int iPos = -1;
        int i = 0;

        while (i < saXMLEquivalent.length) {
            String newStr = "";
            if (decode) {
                //Search for XML encodeded string and convert it back to plain ASCII
                sFind = saXMLEquivalent[i];
                sReplace = saSpecialChars[i];
            } else {
                //Search for special chars in ASCII and replace with XML safe chars
                sFind = saSpecialChars[i];
                sReplace = saXMLEquivalent[i];
            }
            do {
                iPos = str.indexOf(sFind, ++iPos);
                if (iPos > -1) {
                    newStr = newStr + str.substring(0, iPos) + sReplace + str.substring(iPos+sFind.length(),str.length());
                    str = newStr;
                    newStr = "";
                    bFound = true;
                } else {
                    bFound = false;
                }
            } while ( bFound );
            i++;
        }
        return(str);
    }

   /**
    * retrieve a set of Authorizations by a person's kerberosId, optinally filtering by function_name and function_id
    *
    * @param userName user's kerberos Id
    * @param category Authorization Category code, such as "SAP"
    * @param isActive if you are only interested in authorizations that are currently active, use Boolean.TRUE, otherwise, use Boolean.FALSE
    * @param willExpand if you want to expand the qualifier to get the implicit authorization or not 
    * @param proxyUserName  the user who is executing this query
    * @param function_name a function to filter the results by
    * @param function_id a function id to filter the results by
    * @return a set of {@link Authorization} matching the specified criteria
    * @throws  InvalidInputException   If any of the parameters is NULL
    * @throws  ObjectNotFoundException If no authorizations is found matching the criteria
    * @throws  AuthorizationException  in case of hibernate error   
    */
    @SuppressWarnings("unchecked")
    public Collection<Authorization> getUserAuthorizations(String userName, String category, String function_name, String function_id, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException
    {
      
        if (userName == null || category == null || isActive == null || willExpand == null || applicationName == null || proxyUserName == null) 
            throw new InvalidInputException();
         
        String pname = userName.trim().toUpperCase();
        String categoryCode = category.trim().toUpperCase();
        String aname = applicationName.trim().toUpperCase();
        String pUser = proxyUserName.trim().toUpperCase();
        String fname = null;
        String fid = null;
        
        if (null != function_name) {
            fname = function_name.trim().toUpperCase();
            if (fname.length() <= 0) {
                fname = null;
            }
        }
        if (null != function_id) {
            fid = function_id.trim().toUpperCase();
            if (fid.length() <= 0) {
                fid = null;
            }
        }
        
        if (pname.length() <= 0 || aname.length()<=0 || pUser.length() <=0)
            throw new InvalidInputException();
        
        
        if (categoryCode.length() > 0)
        {
            while (categoryCode.length()<4)
            {
                categoryCode+=" ";
            }
        }
        String active = isActive ? "Y" :"N";
        String expand = willExpand ? "Y" :"N";
        HibernateTemplate t = getHibernateTemplate();
               
        Collection authorizations = null;
        try{
            authorizations = t.findByNamedQuery("GET_USERAUTH_SP", new String[]{aname, pUser, pname, categoryCode, expand, active, fname, fid});
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
                throw new AuthorizationException(e.getMessage());
        }
        
        if (authorizations == null )
            throw new AuthorizationException("error retrieving authorizations for user " + userName);
       
        return authorizations;
    }    
    
    /**
     * retrieves a selection list by certificate username.
     *
     * @param   username
     * @param   functionName
     * @param   qualifierCode
     * @return  {@link Category} matching the category code
     * @throws  InvalidInputException   If the category code is NULL or more than 4 characters long
     * @throws  ObjectNotFoundException If no category is found in the database matching the category code
     * @throws  AuthorizationException  in case of hibernate error   
     */
     public String 
             getAuthEditPermissions(String userName,String functionName,String qualifierCode) throws InvalidInputException, ObjectNotFoundException, AuthorizationException
     {
        if (null == userName) 
            throw new InvalidInputException();
     
        String name = userName.trim().toUpperCase();
                
        if (name.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        try{
            List resp = t.findByNamedQuery("CAN_CREATE_AUTH", new String[]{name, functionName, qualifierCode});
            //t.initialize(resp);
            
            if (null != resp && resp.size() > 0)
            {
                String s = (String) resp.get(0);
                 return s;
                
                
            }
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

                     else
                     throw new AuthorizationException(errorMessage);
           }
           else
                throw new AuthorizationException(e.getMessage());
        }
       
       return "N";
    }            



    /**
     * 
     * @param authId
     * @param proxyUserName
     * @return
     */    
     public Collection<EditableAuthorizationRaw> listEditableAuthorizationByAuthId( String authId, String proxyUserName) throws Exception
    {
             if (null == proxyUserName) 
            throw new InvalidInputException();
     
        String name = proxyUserName.trim().toUpperCase();
                
        if (name.length() <= 0)
            throw new InvalidInputException();
        
        HibernateTemplate t = getHibernateTemplate();
        try{
           Collection<EditableAuthorizationRaw> resp = t.findByNamedQuery("AUTH_DETAIL_FOR_PROXY", new String[]{ authId, proxyUserName});
            //t.initialize(resp);
            
            return resp;

        }
       
        catch(Exception e){
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
       
      
     }
}

   