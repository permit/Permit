/*
 * AuthorizationManager.java
 * Created on January 10, 2007, 1:08 AM
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


package edu.mit.isda.permitservice.service;
import edu.mit.isda.permitservice.dataobjects.*;
import java.util.Set;
import java.util.List;
import java.util.Collection;

/**
 *
 */
public interface AuthorizationManager {
    public static  final int BEGINWITH = 0;
    public static  final int CONTAINS = 1;
    public static  final int EXACT = 2;
    public QualifierType getQualifierType(String qualifierTypeCode) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Qualifier getRootQualifierByType(String type) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Set<Authorization> listAuthorizationsByPerson(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;   
    public Collection<AuthorizationRaw> listAuthorizationsByPersonRaw(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) 
        throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;   
    public Collection<AuthorizationExt> listAuthByPersonExtend1(String userName, String category, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName, String realOrImplied,
            String function_name, String function_id, String function_qualifier_type, String qualifier_code, String qualifier_id, String base_qual_code, 
            String base_qual_id, String parent_qual_code, String parent_qual_id) 
            throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;
    public Set<Category> listCategories() throws ObjectNotFoundException, AuthorizationException;
    public Set<Qualifier> listChildrenByQualifier(Long id) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Set<Function> listFunctionsByCategory(String categoryCode)throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Set<Function> listFunctionsByDescription(String desc, int searchCriteria) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Set<Function> listFunctionsByName(String name, int searchCriteria)throws InvalidInputException,  ObjectNotFoundException, AuthorizationException;
    
    /**
     * 
     * @param id
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Set<Qualifier> listParentsByQualifier(Long id) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    
    /**
     * 
     * @param code
     * @param searchCriteria
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Set<Qualifier> listQualifiersByCode(String code, int searchCriteria) throws InvalidInputException,  ObjectNotFoundException, AuthorizationException;
    /**
     * 
     * @param name
     * @param searchCriteria
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Set<Qualifier> listQualifiersByName(String name, int searchCriteria) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    
    /**
     * 
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Set<QualifierType> listQualifierTypes() throws ObjectNotFoundException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param function_category
     * @param function_name
     * @param qualifier_code
     * @param applicationName
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Boolean isUserAuthorized(String userName, String function_category, String function_name, String qualifier_code, 
            String applicationName, String proxyUserName) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param function_id
     * @param qualifier_id
     * @param applicationName
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Boolean isUserAuthorized(String userName, Integer function_id, Long qualifier_id, 
            String applicationName, String proxyUserName) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param function_category
     * @param function_name
     * @param qualifier_code
     * @param applicationName
     * @param proxyUserName
     * @param realOrImplied
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Boolean isUserAuthExtend1(String userName, String function_category, String function_name, String qualifier_code, 
        String applicationName, String proxyUserName, String realOrImplied) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param function_name
     * @param qualifier_code
     * @param kerberos_name
     * @param effective_date
     * @param expiration_date
     * @param do_function
     * @param grant_auth
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String createAuthorization(String userName, String appName, String function_name, String qualifier_code, String kerberos_name,
           String effective_date, String expiration_date, String do_function, String grant_auth) throws InvalidInputException, PermissionException, AuthorizationException;   
    
    /**
     * 
     * @param userName
     * @param appName
     * @param auth_id
     * @param function_name
     * @param qualifier_code
     * @param kerberos_name
     * @param effective_date
     * @param expiration_date
     * @param do_function
     * @param grant_auth
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Boolean updateAuthorization(String userName, String appName, String auth_id, String function_name, String qualifier_code, String kerberos_name,
        String effective_date, String expiration_date, String do_function, String grant_auth) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param auth_id
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Boolean deleteAuthorization(String userName, String appName, String auth_id) 
                    throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param deleteIDs
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String batchDelete(String userName, String appName, String deleteIDs) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param kerberos_name
     * @param authorization_id
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String batchCreate(String userName, String appName, String kerberos_name, String authorization_id) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param kerberos_name
     * @param authIDs
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String batchReplace(String userName, String appName, String kerberos_name, String authIDs) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param authIDs
     * @param effective_date
     * @param expiration_date
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */    
    public String batchUpdate(String userName, String appName, String authIDs, String effective_date, String expiration_date ) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param appName
     * @param selection_id
     * @param criteria_list
     * @param value_list
     * @param apply_list
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     */
    public String saveCriteria(String userName, String appName, String selection_id, String criteria_list, String value_list, String apply_list) throws InvalidInputException;
    
    /**
     * 
     * @param userName
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Collection<PickableCategory> listFunctionCategories(String userName) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param category
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Collection<PickableFunction> listPickableFunctionsByCategory(String userName, String category) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param category
     * @param function_name
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String getQualifierTypeforFunction(String userName, String category, String function_name) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @param function_name
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Set<PickableQualifier> listPickableQualifiers(String userName, String function_name) throws InvalidInputException, PermissionException, AuthorizationException;
    /**
     * 
     * @param userName
     * @param function_name
     * @param qualifier_name
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String getQualifierXML(String userName, String function_name, String qualifier_name) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param root_id
     * @param rbool
     * @param qualifier_type
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String getQualifierXML(String root_id, Boolean rbool, String qualifier_type) throws InvalidInputException, PermissionException, AuthorizationException;
    
    /**
     * 
     * @param userName
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Collection<ViewableCategory> getViewableCategory(String userName) throws InvalidInputException, PermissionException, AuthorizationException;
    /**
     * 
     * @param category
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Collection<ViewableFunction> getViewableFunctionByCategory(String category) throws InvalidInputException, PermissionException, AuthorizationException;
    /**
     * 
     * @param userName
     * @param category
     * @param function_name
     * @param function_id
     * @param isActive
     * @param willExpand
     * @param applicationName
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public Collection<Authorization> getUserAuthorizations(String userName, String category, String function_name, String function_id, Boolean isActive, Boolean willExpand, String applicationName, String proxyUserName) throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;
    /**
     * 
     * @param userName
     * @param category
     * @param function_name
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String getFunctionDesc(String userName, String category, String function_name) throws InvalidInputException, PermissionException, AuthorizationException;
   
    /**
     * 
     * @param userName
     * @param functionName
     * @param qualifierCode
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.ObjectNotFoundException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String 
             getAuthEditPermissions(String userName,String functionName,String qualifierCode) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    /**
     * 
     * @param authId
     * @param userName
     * @return
     * @throws java.lang.Exception
     */
    public Collection<EditableAuthorizationRaw> 
             listEditableAuthorizationByAuthId(String authId,String userName) throws Exception;
    /**
     * 
     * @param userName
     * @param functionName
     * @param qualiferType
     * @return
     * @throws edu.mit.isda.permitservice.dataobjects.InvalidInputException
     * @throws edu.mit.isda.permitservice.dataobjects.PermissionException
     * @throws edu.mit.isda.permitservice.dataobjects.AuthorizationException
     */
    public String getQualifierXMLForCriteriaQuery(String userName, String functionName, String qualiferType) throws InvalidInputException, PermissionException, AuthorizationException;

}
