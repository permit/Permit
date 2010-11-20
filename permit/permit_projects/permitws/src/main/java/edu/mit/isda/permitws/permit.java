/***********************************************************************
$Rev:: 396                       $:  Revision of last commit
$Author:: dtanner                $:  Author of last commit
$Date:: 2007-03-19 13:14:17 -040#$:  Date of last commit
***********************************************************************/
/*
 * permit.java
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

import java.util.*;
import org.apache.commons.logging.Log;
import org.apache.axis.components.logger.LogFactory;
import edu.mit.isda.permitservice.service.*;
import edu.mit.isda.permitservice.dataobjects.*;
import edu.mit.isda.wsLibrary.security.AuthenticateRemoteClient;
import edu.mit.isda.wsLibrary.utils.utils;
import java.text.SimpleDateFormat;
import java.net.URLEncoder;

public class permit {

    private static Log log = LogFactory.getLog("permit.class");
    private static final String EMPTY_RESULT_MESSAGE  = "No authorizations found with above selected criteria";
    private static final String EMPTY_PERSONLIST_MESSAGE  = "No matches found for Kerberos name or last name";

    /**
     * Checks if a user identified by userName has the autjorization specified by triple (function_category, function_name and qualifier_code)
     * @param userName - User Kerbeors name
     * @param function_category - Category
     * @param function_name - Function Name
     * @param qualifier_code - Qualifier Code
     * @param proxyUserName Identified if the user inquiring has the authority to access the record
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public boolean isUserAuthorized(String userName, String function_category, String function_name, String qualifier_code,
                                    String proxyUserName) throws permitException
    {
        Boolean isAuthorized;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            userName = u.validateUser(userName);
            if (userName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (userName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (userName == null)
            {
                userName = "";
            }
            if (function_category == null)
            {
                function_category = "";
            }
            if (function_name == null)
            {
                function_name = "";
            }
            if (qualifier_code == null)
            {
                qualifier_code = "";
            }
            if (proxyUserName == null)
                proxyUserName = ApplicationID;

            if  (proxyUserName.length() == 0)
                proxyUserName = ApplicationID;

            AuthorizationManager instance = AuthorizationFactory.getManager();
            isAuthorized = instance.isUserAuthorized(userName.trim(), function_category.trim(), function_name.trim(),
                                                     qualifier_code.trim(), ApplicationID.trim(), proxyUserName.trim());
         }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        return(isAuthorized.booleanValue());
    }

    /**
     *
     * @param UserName
     * @param function_category
     * @param function_name
     * @param qualifier_code
     * @param proxyUserName
     * @param realOrImplied
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public boolean isUserAuthorizedExt(String UserName, String function_category, String function_name, String qualifier_code,
                                    String proxyUserName, String realOrImplied) throws permitException
    {
        Boolean isAuthorized;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (UserName == null)
            {
                UserName = "";
            }
            if (function_category == null)
            {
                function_category = "";
            }
            if (function_name == null)
            {
                function_name = "";
            }
            if (qualifier_code == null)
            {
                qualifier_code = "";
            }
            if (null == realOrImplied) {
                realOrImplied = "";
            }

            if (proxyUserName == null)
                proxyUserName = ApplicationID;

            if  (proxyUserName.length() == 0)
                proxyUserName = ApplicationID;

            AuthorizationManager instance = AuthorizationFactory.getManager();
            isAuthorized = instance.isUserAuthExtend1(UserName.trim(), function_category.trim(), function_name.trim(),
                                                     qualifier_code.trim(), ApplicationID.trim(), proxyUserName.trim(), realOrImplied.trim());
         }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        return(isAuthorized.booleanValue());
    }

    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public permitAuthorization[] listAuthorizationsByPerson(String UserName, String category, boolean isActive, boolean willExpand, String proxyUserName) throws permitException
    {
        ArrayList rolesAuthz = new ArrayList();
        Set auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }

            if (UserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }
            if  (UserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthorizationsByPerson(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand),
                                                       ApplicationID.trim(), proxyUserName.trim());
            iter = auth.iterator();
            while(iter.hasNext())
            {
                Authorization a = (Authorization)iter.next();
                permitAuthorization rolesAuth = new permitAuthorization();
                Category c = a.getCategory();
                rolesAuth.setCategory(c.getCategory().trim());
                Function f = a.getFunction();
                rolesAuth.setFunction(f.getName().trim());
                Qualifier q = a.getQualifier();
                rolesAuth.setQualifier(q.getName().trim());
                if (q.getCode() != null)
                    rolesAuth.setQualifierCode(q.getCode().trim());
                else
                    rolesAuth.setQualifierCode("null");
                Person p = a.getPerson();
                rolesAuth.setName(p.getKerberosName().trim());
                rolesAuthz.add(rolesAuth);
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        permitAuthorization[] array = (permitAuthorization[])rolesAuthz.toArray(new permitAuthorization[rolesAuthz.size()]);

        return(array);
    }

    /**
     *
     *
     * @param userName
     * @param function_name
     * @param qualifier_code
     * @param kerberos_name
     * @param effective_date
     * @param expiration_date
     * @param do_function
     * @param grant_auth
     * @return
     * @throws java.lang.Exception
     */
    public String createAuthorization(String userName, String function_name, String qualifier_code, String kerberos_name,
        String effective_date, String expiration_date, String do_function, String grant_auth) throws Exception
    {
        String resp = null;
        String ApplicationID = "";
        String Message = "";
        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        ApplicationID = AuthenticateClient.authenticateClient("permitws");
        //System.out.println("userName = " + userName + " Function = " + function_name + " Kerberos Name = " + kerberos_name + " Qualifier Code = " +
        //                    qualifier_code + " Effective Date = " + effective_date + " Expiration Date = " + expiration_date + " User Name = " + userName);

        if (userName == null) {
            Message = "Invalid certificate";
            throw new Exception(Message);
        }
        if  (userName.length() == 0) {
            Message  = "No certificate user detected";
            throw new Exception(Message);
        }

        //try {
            AuthorizationManager instance = AuthorizationFactory.getManager();
            resp = instance.createAuthorization(userName, ApplicationID, function_name, qualifier_code, kerberos_name, effective_date, expiration_date, do_function, grant_auth);
        //}
        //catch (DataAccessException e) {
        //    throw e;
        //}
        //finally {
            return resp;
        //}
    }

    /**
     * Update authorization
     * @param userName
     * @param auth_id
     * @param function_name
     * @param qualifier_code
     * @param kerberos_name
     * @param effective_date
     * @param expiration_date
     * @param do_function
     * @param grant_auth
     * @return
     * @throws java.lang.Exception
     */
    public boolean updateAuthorization(String userName, String auth_id, String function_name, String qualifier_code, String kerberos_name,
        String effective_date, String expiration_date, String do_function, String grant_auth) throws Exception
    {
        Boolean bool = Boolean.FALSE;
        String ApplicationID = "";
        String Message = "";
        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        ApplicationID = AuthenticateClient.authenticateClient("permitws");
        //System.out.println("userName = " + userName + "Authorization ID = " + auth_id + " Function = " + function_name +
        //                    " Kerberos Name = " + kerberos_name + " Effective Date = " + effective_date + " Expiration Date = " + expiration_date);

        if (userName == null) {
            Message = "Invalid certificate";
            throw new Exception(Message);
        }
        if  (userName.length() == 0) {
            Message  = "No certificate user detected";
            throw new Exception(Message);
        }
        //try {
            AuthorizationManager instance = AuthorizationFactory.getManager();
            bool = instance.updateAuthorization(userName, ApplicationID, auth_id, function_name, qualifier_code, kerberos_name, effective_date, expiration_date, do_function, grant_auth);
        //}
        //catch (Exception e) {
        //    e.printStackTrace();
        //}
        //finally {
            return bool.booleanValue();
        //}
    }

    /**
     * Deletes an authorization specified by user name and authorization id
     * @param userName
     * @param auth_id
     * @return
     * @throws java.lang.Exception
     */
    public boolean deleteAuthorization(String userName, String auth_id) throws Exception
    {
        Boolean bool = Boolean.FALSE;
        String ApplicationID = "";
        String Message = "";
        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        ApplicationID = AuthenticateClient.authenticateClient("permitws");
        //System.out.println("userName = " + userName + "Authorization ID = " + auth_id);

        if (userName == null) {
            Message = "Invalid certificate";
            throw new Exception(Message);
        }
        if  (userName.length() == 0) {
            Message  = "No certificate user detected";
            throw new Exception(Message);
        }
        // try {
            AuthorizationManager instance = AuthorizationFactory.getManager();
            bool = instance.deleteAuthorization(userName, ApplicationID, auth_id);
        //}
        //catch (Exception e) {
        //    e.printStackTrace();
        //}
        //finally {
            return bool.booleanValue();
        //}
    }

    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public permitAuthorizationExt[] listAuthorizationsByPersonExt(String UserName, String category, boolean isActive, boolean willExpand, String proxyUserName) throws permitException
    {
        ArrayList rolesAuthz = new ArrayList();
        Set auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthorizationsByPerson(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand),
                                                       ApplicationID.trim(), proxyUserName.trim());
            iter = auth.iterator();
            while(iter.hasNext())
            {
                Authorization a = (Authorization)iter.next();
                permitAuthorizationExt rolesAuth = new permitAuthorizationExt();
                Category c = a.getCategory();
                rolesAuth.setCategory(c.getCategory().trim());
                Function f = a.getFunction();
                rolesAuth.setFunction(f.getName().trim());
                rolesAuth.setQualifierType(f.getFqt().getType().trim());
                Qualifier q = a.getQualifier();
                rolesAuth.setQualifier(q.getName().trim());
                if (q.getCode() != null)
                    rolesAuth.setQualifierCode(q.getCode().trim());
                else
                    rolesAuth.setQualifierCode("null");
                Person p = a.getPerson();
                rolesAuth.setName(p.getKerberosName().trim());
                AuthorizationPK apk = a.getAuthorizationPK();
                Long aid = apk.getAuthorizationId();
                rolesAuth.setAuthorizationID(aid.toString());
                Date effdate = a.getEffectiveDate();
                Date expdate = a.getExpirationDate();
                Date moddate = a.getModifiedDate();
                SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
                rolesAuth.setEffectiveDate(formatter.format(effdate));
                if (null == expdate) {
                    rolesAuth.setExpirationDate("");
                }
                else {
                    rolesAuth.setExpirationDate(formatter.format(expdate));
                }
                rolesAuth.setDoFunction(a.getDoFunction().toString());
                rolesAuth.setGrantAuth(a.getGrantAuthorization());
                rolesAuth.setModifiedBy(a.getModifiedBy());
                rolesAuth.setModifiedDate(formatter.format(moddate));
                rolesAuthz.add(rolesAuth);
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        permitAuthorizationExt[] array = (permitAuthorizationExt[])rolesAuthz.toArray(new permitAuthorizationExt[rolesAuthz.size()]);

        return(array);
    }

    @SuppressWarnings("unchecked")


    public StringBuffer createAuthorizationXML (StringBuffer xml, String category,String functionName,String functionDesc,
                String qualifierType, String qualifierName, String qualifierCode, String kerberosName, String firstName, String lastName,
                Long authId, Date effDate, Date expDate, Boolean isActive, Character doFunction, String grantAuthorization,
                String modifiedBy, Date modifiedDate, String  proxyUserName, boolean isEditable) throws Exception
    {
                xml.append("\r\n{\"category\":\"" + category.trim() + "\",");
                xml.append("\"functionName\":\"" + functionName.trim() + "\",");
                if (functionDesc != null)
                {
                    xml.append("\"functionDesc\":\"" + functionDesc.trim() + "\",");
                }
                else
                {
                    xml.append("\"functionDesc\":\"\",");
                }
                xml.append("\"qualifierType\":\"" + qualifierType.trim() + "\",");
                String qName = qualifierName.trim().replaceAll("[\"]","'");
                xml.append("\"qualifierName\":\"" + qName + "\",");
                if (qualifierCode != null)
                    xml.append("\"qualifierCode\":\"" + qualifierCode.trim() + "\",");
                else
                    xml.append("\"qualifierCode\":\"null\",");
                xml.append("\"kerberosName\":\"" + kerberosName.trim() + "\",");
                xml.append("\"firstName\":\"" + firstName.trim() + "\",");
                xml.append("\"lastName\":\"" + lastName.trim() + "\",");
                xml.append("\"authorizationID\":\"" + authId.toString() + "\",");

                SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
                xml.append("\"effectiveDate\":\"" + formatter.format(effDate) + "\",");
                if (null == expDate)
                {
                    xml.append("\"expirationDate\":\"\",");
                }
                else
                {
                    xml.append("\"expirationDate\":\"" + formatter.format(expDate) + "\",");
                }
                if (null != isActive )
                {
                   xml.append("\"active\":\"" + isActive.toString() + "\",");
                }

                xml.append("\"doFunction\":\"" + doFunction.toString() + "\",");
                xml.append("\"grantAuthorization\":\"" + grantAuthorization + "\",");
                xml.append("\"modifiedBy\":\"" + modifiedBy + "\",");
                xml.append("\"modifiedDate\":\"" + formatter.format(modifiedDate) + "\",");
                xml.append("\"proxyUser\":\"" + proxyUserName + "\",");
                xml.append("\"isEditable\":\"" + new Boolean(isEditable).toString() + "\"},");


            return(xml);
    }


    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listAuthorizationsByPersonXML (String UserName, String category, boolean isActive, boolean willExpand, String proxyUserName) throws permitException
    {
        Set auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"authorizations\": [");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthorizationsByPerson(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand),
                                                       ApplicationID.trim(), proxyUserName.trim());
            iter = auth.iterator();

            while(iter.hasNext())
            {
                Authorization a = (Authorization)iter.next();
                Category c = a.getCategory();
                Function f = a.getFunction();
                Qualifier q = a.getQualifier();
                Person p = a.getPerson();
                AuthorizationPK apk = a.getAuthorizationPK();
                Long aid = apk.getAuthorizationId();

                xml = createAuthorizationXML ( xml, c.getCategory(),f.getName(),f.getDescription(), f.getFqt().getType(), q.getName(), q.getCode(),p.getKerberosName(),p.getFirstName(),p.getLastName(),
                aid, a.getEffectiveDate(), a.getExpirationDate(),null, a.getDoFunction(), a.getGrantAuthorization(), a.getModifiedBy(), a.getModifiedDate(),proxyUserName, false);

            }
            int lastCharIndex = xml.length();
            xml.deleteCharAt(lastCharIndex - 1);
            xml.append("\r\n]}");
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param authId
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listEditableAuthorizationByAuthId ( String authId, String proxyUserName) throws permitException
    {
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"authorizations\": [");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();

        try
        {


            ApplicationID = AuthenticateClient.authenticateClient("permitws");


            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listEditableAuthorizationByAuthId( authId, proxyUserName.trim().toUpperCase());

            if (null == auth) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }
            else if (auth.isEmpty()) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }

            else {
                iter = auth.iterator();

                while(iter.hasNext())
                {
                    EditableAuthorizationRaw a = (EditableAuthorizationRaw)iter.next();


                    AuthorizationPK apk = a.getAuthorizationPK();
                    Long aid = apk.getAuthorizationId();

                xml = createAuthorizationXML ( xml, a.getCategory(),a.getFunction(),a.getFunctionDesc(), a.getQualifierType(),
                        a.getQualifierName(), a.getQualifierCode(),a.getPerson(),a.getFirstName(),a.getLastName(), aid, a.getEffectiveDate(),
                        a.getExpirationDate(), a.getIsActiveNow(), a.getDoFunction(), a.getGrantAuthorization(), a.getModifiedBy(),
                        a.getModifiedDate(), a.getRequestingUser(), a.isEditable());


                }
                int lastCharIndex = xml.length();
                xml.deleteCharAt(lastCharIndex - 1);
                xml.append("\r\n]}");
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
         try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listAuthorizationsByPersonRawXML (String UserName, String category, boolean isActive, boolean willExpand, String proxyUserName) throws permitException
    {
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"authorizations\": [");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthorizationsByPersonRaw(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand),
                                                       ApplicationID.trim(), proxyUserName.trim());

            if (null == auth) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }
            else if (auth.isEmpty()) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }

            else {
                iter = auth.iterator();

                while(iter.hasNext())
                {
                    AuthorizationRaw a = (AuthorizationRaw)iter.next();


                    AuthorizationPK apk = a.getAuthorizationPK();
                    Long aid = apk.getAuthorizationId();

                xml = createAuthorizationXML ( xml, a.getCategory(),a.getFunction(),a.getFunctionDesc(), a.getQualifierType(),
                        a.getQualifierName(), a.getQualifierCode(),a.getPerson(),a.getFirstName(),a.getLastName(), aid, a.getEffectiveDate(),
                        a.getExpirationDate(), a.getIsActiveNow(), a.getDoFunction(), a.getGrantAuthorization(), a.getModifiedBy(),
                        a.getModifiedDate(),proxyUserName,false);


                }
                int lastCharIndex = xml.length();
                xml.deleteCharAt(lastCharIndex - 1);
                xml.append("\r\n]}");
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @param realOrImplied
     * @param function_name
     * @param function_id
     * @param function_qualifier_type
     * @param qualifier_code
     * @param qualifier_id
     * @param base_qual_code
     * @param base_qual_id
     * @param parent_qual_code
     * @param parent_qual_id
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listAuthByPersonExtend1XML(String UserName, String category, Boolean isActive, Boolean willExpand, String proxyUserName, String realOrImplied,
                                          String function_name, String function_id, String function_qualifier_type, String qualifier_code, String qualifier_id, String base_qual_code,
                                          String base_qual_id, String parent_qual_code, String parent_qual_id)  throws permitException
    {
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"authorizations\": [");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthByPersonExtend1(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand), ApplicationID.trim(),
                                                    proxyUserName.trim(), realOrImplied, function_name, function_id, function_qualifier_type, qualifier_code, qualifier_id,
                                                    base_qual_code, base_qual_id, parent_qual_code, parent_qual_id);

            if (null == auth) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }
            else if (auth.isEmpty()) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }

            else {
                iter = auth.iterator();

                while(iter.hasNext())
                {
                    AuthorizationExt a = (AuthorizationExt)iter.next();

                    AuthorizationPK apk = a.getAuthorizationPK();
                    Long aid = apk.getAuthorizationId();

                    xml = createAuthorizationXML ( xml, a.getCategory(),a.getFunction(),/*a.getFunctionDesc()*/ "", a.getQualifierType(),
                        a.getQualifierName(), a.getQualifierCode(),a.getPerson(),/*a.getFirstName(),a.getLastName()*/"","", aid, a.getEffectiveDate(),
                        a.getExpirationDate(), a.getIsActiveNow(),a.getDoFunction(), a.getGrantAuthorization(), a.getModifiedBy(),
                        a.getModifiedDate(),proxyUserName,false);
                }
                int lastCharIndex = xml.length();
                xml.deleteCharAt(lastCharIndex - 1);
                xml.append("\r\n]}");
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
   }

    /**
     *
     * @param UserName
     * @param category
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @param realOrImplied
     * @param function_name
     * @param function_id
     * @param function_qualifier_type
     * @param qualifier_code
     * @param qualifier_id
     * @param base_qual_code
     * @param base_qual_id
     * @param parent_qual_code
     * @param parent_qual_id
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public permitAuthorizationExt[] listAuthByPersonExtend1(String UserName, String category, Boolean isActive, Boolean willExpand, String proxyUserName, String realOrImplied,
                                          String function_name, String function_id, String function_qualifier_type, String qualifier_code, String qualifier_id, String base_qual_code,
                                          String base_qual_id, String parent_qual_code, String parent_qual_id)  throws permitException
    {
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.listAuthByPersonExtend1(UserName.trim(), category.trim(), Boolean.valueOf(isActive), Boolean.valueOf(willExpand), ApplicationID.trim(),
                                                    proxyUserName.trim(), realOrImplied, function_name, function_id, function_qualifier_type, qualifier_code, qualifier_id,
                                                    base_qual_code, base_qual_id, parent_qual_code, parent_qual_id);

            ArrayList rolesAuthz = new ArrayList();
            iter = auth.iterator();
            while(iter.hasNext())
            {
                AuthorizationExt a = (AuthorizationExt)iter.next();
                AuthorizationPK apk = a.getAuthorizationPK();
                Long aid = apk.getAuthorizationId();
                permitAuthorizationExt rolesAuth = new permitAuthorizationExt();
                rolesAuth.setCategory(a.getCategory());
                rolesAuth.setFunction(a.getFunction());
                rolesAuth.setQualifierType(a.getQualifierType());
                rolesAuth.setQualifier(a.getQualifierName());
                if (a.getQualifierCode() != null)
                    rolesAuth.setQualifierCode(a.getQualifierCode().trim());
                else
                    rolesAuth.setQualifierCode("null");
                 rolesAuth.setName(a.getPerson());
                rolesAuth.setAuthorizationID(aid.toString());
                Date effdate = a.getEffectiveDate();
                Date expdate = a.getExpirationDate();
                Date moddate = a.getModifiedDate();
                SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
                rolesAuth.setEffectiveDate(formatter.format(effdate));
                if (null == expdate) {
                    rolesAuth.setExpirationDate("");
                }
                else {
                    rolesAuth.setExpirationDate(formatter.format(expdate));
                }
                rolesAuth.setDoFunction(a.getDoFunction().toString());
                rolesAuth.setGrantAuth(a.getGrantAuthorization());
                rolesAuth.setModifiedBy(a.getModifiedBy());
                rolesAuth.setModifiedDate(formatter.format(moddate));
                rolesAuth.setIsActiveNow(a.getIsActiveNow());

                 rolesAuthz.add(rolesAuth);
            }

            permitAuthorizationExt[] array = (permitAuthorizationExt[])rolesAuthz.toArray(new permitAuthorizationExt[rolesAuthz.size()]);
            return array;
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }


   }

    /**
     *
     * @param proxyUserName
     * @param crit_list
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listAuthorizationsByCriteria (String proxyUserName, String crit_list) throws permitException
    {
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"authorizations\": [");
        String[] criteria = new String[43];

        AuthenticateRemoteClient authenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            ApplicationID = authenticateClient.authenticateClient("permitws");

            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            String[] crit_split = crit_list.split("\\|\\|");

            criteria[0] = ApplicationID;
            criteria[1] = proxyUserName;
            int critNum =  crit_split.length/2;
            criteria[2] = Integer.toString(critNum);
            int j = 0;

            for (int i = 0; i < crit_split.length; i++) {
                j = i+3;
                criteria[j] = crit_split[i];
            }

            //System.out.println("Criteria List = ");
            for (int i = 0; i < criteria.length; i ++) {
                if (null == criteria[i]) {
                    criteria[i] = "";
                }
                //System.out.println(i + ": " + criteria[i]);
            }

            GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
            auth = instance.listAuthorizationsByCriteria(criteria);

            if (null == auth) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }
            else if (auth.isEmpty()) {
                xml = new StringBuffer(EMPTY_RESULT_MESSAGE);
            }

            else {
                iter = auth.iterator();

                while(iter.hasNext())
                {
                    AuthorizationRaw a = (AuthorizationRaw)iter.next();

                    AuthorizationPK apk = a.getAuthorizationPK();
                    Long aid = apk.getAuthorizationId();

                    xml = createAuthorizationXML ( xml, a.getCategory(),a.getFunction(),a.getFunctionDesc(), a.getQualifierType(),
                        a.getQualifierName(), a.getQualifierCode(),a.getPerson(),a.getFirstName(),a.getLastName(), aid, a.getEffectiveDate(),
                        a.getExpirationDate(), a.getIsActiveNow(),a.getDoFunction(), a.getGrantAuthorization(), a.getModifiedBy(),
                        a.getModifiedDate(),proxyUserName,false);

                }
                int lastCharIndex = xml.length();
                xml.deleteCharAt(lastCharIndex - 1);
                xml.append("\r\n]}");
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            //throw new permitException(Message);
            return e.getMessage();
        }

         try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param userName
     * @param functionName
     * @param qualifierCode
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String checkAuthEditPermissions (String proxyUserName, String functionName, String qualifierCode) throws permitException
    {
        String Message;

        String editAllowed = "";
        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            proxyUserName = u.validateUser(proxyUserName);
            if (proxyUserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (proxyUserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            String applicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
             editAllowed = instance.getAuthEditPermissions(proxyUserName,functionName,qualifierCode);


        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        return(editAllowed);

    }

    /**
     *
     * @param UserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public permitPickableCategory[] listFunctionCategories(String UserName) throws permitException
    {
        ArrayList rolesCatz = new ArrayList();
        Collection cat = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            cat = instance.listFunctionCategories(UserName);
            iter = cat.iterator();

            while(iter.hasNext())
            {
                PickableCategory c = (PickableCategory)iter.next();
                permitPickableCategory rolesCat = new permitPickableCategory();
                rolesCat.setCategory(c.getCategory().trim());
                rolesCat.setDescription(c.getDescription().trim());
                rolesCatz.add(rolesCat);
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        permitPickableCategory[] array = (permitPickableCategory[])rolesCatz.toArray(new permitPickableCategory[rolesCatz.size()]);
        return(array);
    }

    /**
     * Lists Pickable functions for the user and category
     * @param UserName
     * @param category
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public permitPickableFunction[] listPickableFunctionsByCategory(String UserName, String category) throws permitException
    {
        ArrayList rolesFuncz = new ArrayList();
        Collection func = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if (category == null)
            {
                Message = "invalid category";
                throw new Exception(Message);
            }
            if (category.length() == 0)
            {
                Message = "category not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            func = instance.listPickableFunctionsByCategory(UserName, category);
            iter = func.iterator();

            while(iter.hasNext())
            {
                PickableFunction c = (PickableFunction)iter.next();
                permitPickableFunction rolesFunc = new permitPickableFunction();
                if (null != c.getCategory())
                    rolesFunc.setCategory(c.getCategory().trim());
                if (null != c.getDescription())
                    rolesFunc.setDescription(c.getDescription().trim());
                if (null != c.getName())
                    rolesFunc.setName(c.getName().trim());
                rolesFunc.setId(c.getId());
                if (null != c.getFqt())
                    rolesFunc.setFqt(c.getFqt().trim());
                if (null != c.getKname())
                    rolesFunc.setKname(c.getKname().trim());
                rolesFuncz.add(rolesFunc);
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        permitPickableFunction[] array = (permitPickableFunction[])rolesFuncz.toArray(new permitPickableFunction[rolesFuncz.size()]);
        return(array);
    }

    /**
     * Gets list of Qualifier Types for user, category and function name
     * @param UserName
     * @param category
     * @param function_name
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String getQualifierTypeForFunction(String UserName, String category, String function_name) throws permitException
    {
        String fqt;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if (category == null)
            {
                Message = "invalid category";
                throw new Exception(Message);
            }
            if (category.length() == 0)
            {
                Message = "category not specified";
                throw new Exception(Message);
            }
            if (function_name == null)
            {
                Message = "invalid function_name";
                throw new Exception(Message);
            }
            if (function_name.length() == 0)
            {
                Message = "function_name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            fqt = instance.getQualifierTypeforFunction(UserName, category, function_name);
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        return fqt;
    }


     @SuppressWarnings("unchecked")
    public String getFunctionDesc(String userName, String category, String function_name) throws permitException
    {
        String fqt;
        String Message;
        String applicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            userName = u.validateUser(userName);
            if (userName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (userName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if (category == null)
            {
                Message = "invalid category";
                throw new Exception(Message);
            }
            if (category.length() == 0)
            {
                Message = "category not specified";
                throw new Exception(Message);
            }
            if (function_name == null)
            {
                Message = "invalid function_name";
                throw new Exception(Message);
            }
            if (function_name.length() == 0)
            {
                Message = "function_name not specified";
                throw new Exception(Message);
            }

            applicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            fqt = instance.getFunctionDesc(userName, category, function_name);
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        return fqt;
    }

     /**
      *
      * @param UserName
      * @param function
      * @param qualifier_type
      * @return
      * @throws edu.mit.isda.permitws.permitException
      */
    @SuppressWarnings("unchecked")
    public String getQualifierXML(String UserName, String function, String qualifier_type) throws permitException
    {
        String Message = "";
        String ApplicationID = "";
        String xmlString = null;

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if (function == null)
            {
                Message = "invalid function";
                throw new Exception(Message);
            }
            if (function.length() == 0)
            {
                Message = "function not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            //System.out.println("Parameters are " + ApplicationID + ", " + function);
            xmlString = instance.getQualifierXML(UserName, function, qualifier_type);
            //System.out.println("String  = " + xmlString);

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            xmlString = Message;
            throw new permitException(e);
        }
         return xmlString.toString();
//          try
//        {
//            return(URLEncoder.encode(xmlString.toString(),"UTF-8"));
//        }
//        catch(Exception e)
//        {
//            throw new permitException(e.getLocalizedMessage());
//        }
    }

   /**
      *
      * @param userName
      * @param function
      * @param qualifier_type
      * @return
      * @throws edu.mit.isda.permitws.permitException
      */
    @SuppressWarnings("unchecked")
    public String getQualifierXMLForCriteriaQuery(String userName, String functionName, String qualifierType) throws permitException
    {
        String Message = "";
        String ApplicationID = "";
        String xmlString = null;

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            userName = u.validateUser(userName);
            if (userName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (userName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if ( (functionName == null || functionName.trim().length() == 0) &&   (qualifierType == null || qualifierType.trim().length() == 0))
            {
                Message = "You need to specify Qualifer Type or function name";
                throw new Exception(Message);
            }


            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();

            xmlString = instance.getQualifierXMLForCriteriaQuery(userName, functionName,qualifierType);

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
            e.printStackTrace();

            xmlString = Message;
            throw new permitException(e);
        }
         return xmlString.toString();
//          try
//        {
//            return(URLEncoder.encode(xmlString.toString(),"UTF-8"));
//        }
//        catch(Exception e)
//        {
//            throw new permitException(e.getLocalizedMessage());
//        }
    }

    /**
     *
     * @param root_id
     * @param root
     * @param qualifier_type
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String getQualifierRootXML(String root_id, String root, String qualifier_type) throws permitException
    {
        String Message = "";
        String ApplicationID = "";
        String xmlString = null;
        Boolean rbool = Boolean.parseBoolean(root);

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            if (root_id.length() == 0)
            {
                Message = "function not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            xmlString = instance.getQualifierXML(root_id, rbool, qualifier_type);

            //System.out.println("String  = " + xmlString);

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
            xmlString = Message;
            throw new permitException(e);
        }

        return xmlString.toString();
//          try
//        {
//            return(URLEncoder.encode(xmlString.toString(),"UTF-8"));
//        }
//        catch(Exception e)
//        {
//            throw new permitException(e.getLocalizedMessage());
//        }
    }

    /**
     *
     * @param UserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listViewableCategories(String UserName) throws permitException
    {
        StringBuffer out = new StringBuffer();
        Collection func = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            func = instance.getViewableCategory(UserName);
            iter = func.iterator();

            while(iter.hasNext())
            {
                ViewableCategory c = (ViewableCategory)iter.next();
                out.append(c.getCategory());
                out.append("||");
                out.append(c.getCatdesc());
                if (iter.hasNext()) {
                    out.append("^^");
                }
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        return(out.toString());
    }

    /**
     *
     * @param category
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listViewableFunctionsByCategory(String category) throws permitException
    {
        StringBuffer out = new StringBuffer();
        Collection func = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            if (category == null)
            {
                Message = "invalid category";
                throw new Exception(Message);
            }
            if (category.length() == 0)
            {
                Message = "category not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            AuthorizationManager instance = AuthorizationFactory.getManager();
            func = instance.getViewableFunctionByCategory(category);
            iter = func.iterator();

            while(iter.hasNext())
            {
                ViewableFunction f = (ViewableFunction)iter.next();
                out.append(f.getName());
                out.append("||");
                out.append(f.getDescription());
                out.append("||");
                out.append(f.getFqt());
                if (iter.hasNext()) {
                    out.append("^^");
                }
            }
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

        return(out.toString());
    }

    /**
     *
     * @param UserName
     * @param kerberos_name
     * @param authIDs
     * @return
     * @throws java.lang.Exception
     */
    @SuppressWarnings("unchecked")
    public String batchCreate(String UserName, String kerberos_name, String authIDs) throws Exception
    {
        StringBuffer out = new StringBuffer();
        String result = new String();
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        ApplicationID = AuthenticateClient.authenticateClient("permitws");

        AuthorizationManager instance = AuthorizationFactory.getManager();
        result = instance.batchCreate(UserName, ApplicationID, kerberos_name, authIDs);

        return result;
    }

    /**
     *
     * @param UserName
     * @param deleteIDs
     * @return
     * @throws java.lang.Exception
     */
    @SuppressWarnings("unchecked")
    public String batchDelete(String UserName, String deleteIDs) throws Exception
    {
        StringBuffer out = new StringBuffer();
        Boolean bool = Boolean.FALSE;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        ApplicationID = AuthenticateClient.authenticateClient("permitws");

        AuthorizationManager instance = AuthorizationFactory.getManager();
        return instance.batchDelete(UserName, ApplicationID, deleteIDs);

    }

    /**
     *
     * @param UserName
     * @param kerberos_name
     * @param authIDs
     * @return
     * @throws java.lang.Exception
     */
     @SuppressWarnings("unchecked")
    public String batchReplace(String UserName, String kerberos_name, String authIDs) throws Exception
    {
        StringBuffer out = new StringBuffer();
        String result = new String();
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        ApplicationID = AuthenticateClient.authenticateClient("permitws");

        AuthorizationManager instance = AuthorizationFactory.getManager();
        result = instance.batchReplace(UserName, ApplicationID, kerberos_name, authIDs);

        return result;
    }

     /**
      *
      * @param UserName
      * @param authIDs
      * @param effective_date
      * @param expiration_date
      * @return
      * @throws java.lang.Exception
      */
    @SuppressWarnings("unchecked")
    public String batchUpdate(String UserName, String authIDs, String effective_date, String expiration_date) throws Exception
    {
        StringBuffer out = new StringBuffer();
        String result = new String();
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        ApplicationID = AuthenticateClient.authenticateClient("permitws");

        AuthorizationManager instance = AuthorizationFactory.getManager();
        result = instance.batchUpdate(UserName, ApplicationID, authIDs, effective_date, expiration_date);

        return result;
    }

    /**
     *
     * @param UserName
     * @param selection_id
     * @param criteria_list
     * @param value_list
     * @param apply_list
     * @return
     * @throws java.lang.Exception
     */
    @SuppressWarnings("unchecked")
    public String saveCriteria(String UserName, String selection_id, String criteria_list, String value_list, String apply_list) throws Exception
    {
        StringBuffer out = new StringBuffer();
        String result = new String();
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        ApplicationID = AuthenticateClient.authenticateClient("permitws");

        AuthorizationManager instance = AuthorizationFactory.getManager();
        result = instance.saveCriteria(UserName, ApplicationID, selection_id, criteria_list, value_list, apply_list);

        return result;
    }

    /**
     *
     * @param UserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String getSelectionList(String UserName) throws permitException
    {
        Collection sl = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer json = new StringBuffer("\r\n{\"selectionList\": [");
        String value = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");
            GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
            sl = instance.getSelectionList(UserName);
            if (null == sl || sl.isEmpty()) {
                System.out.println(" Empty Selection Set" );
            }
            iter = sl.iterator();

            while(iter.hasNext())
            {
                SelectionList s = (SelectionList)iter.next();

                json.append("\r\n{\"id\":\""             + s.getId().toString().trim().replace("'", "&apos;")       + "\",");
                json.append("\"selectionName\":\""       + s.getSelectionName().trim().replace("'", "&apos;")       + "\",");
                json.append("\"flag\":\""                + s.getFlag().trim().replace("'", "&apos;")                + "\"},");
            }
            int lastCharIndex = json.length();
            json.deleteCharAt(lastCharIndex - 1);
            json.append("\r\n]}");
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            e.printStackTrace();
            log.error(Message);
       System.out.print("ERROR: " + e.getMessage());
            throw new permitException(e);
        }
        return(json.toString());
    }

    /**
     *
     * @param selectionID
     * @param UserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String getCriteriaSet(String selectionID, String UserName) throws permitException
    {
        Collection crits = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"criteria\": [");
        String value = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            if (selectionID == null || selectionID.equals("")) {
                Message = "selectionID not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");
            System.out.println("getCriteriaSet for selection id " + selectionID + " User Name " + UserName);
            GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
            crits = instance.getCriteriaSet(selectionID, UserName);
            if (crits.isEmpty()) {
                System.out.println("Empty Criteria set in getCriteriaSet");
            }
            iter = crits.iterator();

            while(iter.hasNext())
            {
                Criteria c = (Criteria)iter.next();
                value = c.getValue().trim().replace("'", "&apos;");
                if (value.equals("<me>")) {
                    value = UserName.toUpperCase();
                }
                xml.append("\r\n{\"id\":\""             + c.getId().toString().trim().replace("'", "&apos;")       + "\",");
                xml.append("\"selectionName\":\""       + c.getSelectionName().trim().replace("'", "&apos;")       + "\",");
                xml.append("\"screenId\":\""            + c.getScreenId().toString().trim().replace("'", "&apos;") + "\",");
                xml.append("\"screenName\":\""          + c.getScreenName().trim().replace("'", "&apos;")          + "\",");
                xml.append("\"criteriaId\":\""          + c.getCriteriaId().trim().replace("'", "&apos;")          + "\",");
                xml.append("\"criteriaName\":\""        + c.getCriteriaName().trim() .replace("'", "&apos;")       + "\",");
                xml.append("\"apply\":\""               + c.getApply().trim().replace("'", "&apos;")               + "\",");
                xml.append("\"nextScreen\":\""          + c.getNextScreen().trim().replace("'", "&apos;")          + "\",");
                xml.append("\"widget\":\""              + c.getWidget()                                            + "\",");
                xml.append("\"value\":\""               + value                                                    + "\",");
                xml.append("\"noChange\":\""            + c.getNoChange().trim().replace("'", "&apos;")            + "\",");
                xml.append("\"sequence\":\""            + c.getSequence().trim().replace("'", "&apos;")            + "\"},");
            }
            int lastCharIndex = xml.length();
            xml.deleteCharAt(lastCharIndex - 1);
            xml.append("\r\n]}");
        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
            e.printStackTrace();
            throw new permitException(e);
        }

       log.debug("Criteria Set: " + xml);
        try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param proxyUserName
     * @param name
     * @param search
     * @param sort
     * @param filter1
     * @param filter2
     * @param filter3
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listPersonRaw(String proxyUserName, String name, String search, String sort, String filter1, String filter2, String filter3) throws permitException
    {
        Collection people = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
            people = instance.listPersonRaw(name, search, sort, filter1, filter2, filter3);

            if (null == people) {
                xml = new StringBuffer(EMPTY_PERSONLIST_MESSAGE);
            }
            else if (people.isEmpty()) {
                xml = new StringBuffer(EMPTY_PERSONLIST_MESSAGE);
            }

            else {
                iter = people.iterator();

                while(iter.hasNext())
                {
                    PersonRaw p = (PersonRaw)iter.next();
                    xml.append(p.getKerberosName().trim() + "|" + p.getLastName().trim() + ", " + p.getFirstName().trim()  + " - " + p.getType() + " | " + p.getMitId()  + "\n");
                }
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }

          try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param proxyUserName
     * @param name
     * @param search
     * @param sort
     * @param filter1
     * @param filter2
     * @param filter3
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public String listPersonJSON(String proxyUserName, String name, String search, String sort, String filter1, String filter2, String filter3) throws permitException
    {
        Collection people = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";
        StringBuffer xml = new StringBuffer("\r\n{\"people\": [");

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
            people = instance.listPersonRaw(name, search, sort, filter1, filter2, filter3);

            if (null == people) {
                xml = new StringBuffer(EMPTY_PERSONLIST_MESSAGE);
            }
            else if (people.isEmpty()) {
                xml = new StringBuffer(EMPTY_PERSONLIST_MESSAGE);
            }

            else {
                iter = people.iterator();

                while(iter.hasNext())
                {
                    PersonRaw p = (PersonRaw)iter.next();
                    xml.append("\r\n{\"firstName\":\"" + p.getFirstName().trim() + "\",");
                    xml.append("\"lastName\":\"" + p.getLastName().trim() + "\",");
                    xml.append("\"email\":\"" + p.getEmailAddress().trim() + "\",");
                    xml.append("\"mitId\":\"" + p.getMitId().trim() + "\",");
                    xml.append("\"type\":\"" + p.getMitId().trim() + "\",");
                    xml.append("\"kerberosName\":\"" + p.getKerberosName().trim() + "\",");
                }
                int lastCharIndex = xml.length();
                xml.deleteCharAt(lastCharIndex - 1);
                xml.append("\r\n]}");
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
           e.printStackTrace();
            throw new permitException(e);
        }
        //System.out.println(xml.toString());
          try
        {
            return(URLEncoder.encode(xml.toString(),"UTF-8"));
        }
        catch(Exception e)
        {
            throw new permitException(e.getLocalizedMessage());
        }
    }

    /**
     *
     * @param UserName
     * @param category
     * @param function_name
     * @param function_id
     * @param isActive
     * @param willExpand
     * @param proxyUserName
     * @return
     * @throws edu.mit.isda.permitws.permitException
     */
    @SuppressWarnings("unchecked")
    public userAuthorization[] getUserAuthorizations(String UserName, String category, String function_name, String function_id, boolean isActive, boolean willExpand, String proxyUserName) throws permitException
    {
        ArrayList rolesAuthz = new ArrayList();
        Collection auth = null;
        Iterator iter;
        String Message;
        String ApplicationID = "";

        AuthenticateRemoteClient AuthenticateClient = new AuthenticateRemoteClient();
        utils u = new utils();

        try
        {
            UserName = u.validateUser(UserName);
            if (UserName == null)
            {
                Message = "invalid user name";
                throw new Exception(Message);
            }
            if (UserName.length() == 0)
            {
                Message = "user name not specified";
                throw new Exception(Message);
            }

            ApplicationID = AuthenticateClient.authenticateClient("permitws");

            if (category == null)
            {
                category = "";
            }
            if (proxyUserName == null) {
                Message = "Invalid certificate";
                throw new Exception(Message);
            }

            if  (proxyUserName.length() == 0) {
                Message  = "No certificate user detected";
                throw new Exception(Message);
            }

            AuthorizationManager instance = AuthorizationFactory.getManager();
            auth = instance.getUserAuthorizations(UserName.trim(), category.trim(), function_name, function_id, Boolean.valueOf(isActive), Boolean.valueOf(willExpand),
                                                       ApplicationID.trim(), proxyUserName.trim());
            iter = auth.iterator();
            while(iter.hasNext())
            {
                Authorization a = (Authorization)iter.next();
                userAuthorization rolesAuth = new userAuthorization();
                Category c = a.getCategory();
                rolesAuth.setCategory(c.getCategory().trim());
                Function f = a.getFunction();
                rolesAuth.setFunction(f.getName().trim());
                rolesAuth.setQualifierType(f.getFqt().getType().trim());
                Qualifier q = a.getQualifier();
                rolesAuth.setQualifier(q.getName().trim());
                if (q.getCode() != null)
                    rolesAuth.setQualifierCode(q.getCode().trim());
                else
                    rolesAuth.setQualifierCode("null");
                Person p = a.getPerson();
                rolesAuth.setName(p.getKerberosName().trim());
                AuthorizationPK apk = a.getAuthorizationPK();
                Long aid = apk.getAuthorizationId();
                rolesAuth.setAuthorizationID(aid.toString());
                Date effdate = a.getEffectiveDate();
                Date expdate = a.getExpirationDate();
                Date moddate = a.getModifiedDate();
                SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
                rolesAuth.setEffectiveDate(formatter.format(effdate));
                if (null == expdate) {
                    rolesAuth.setExpirationDate("");
                }
                else {
                    rolesAuth.setExpirationDate(formatter.format(expdate));
                }
                rolesAuth.setDoFunction(a.getDoFunction().toString());
                rolesAuth.setGrantAuth(a.getGrantAuthorization());
                rolesAuth.setModifiedBy(a.getModifiedBy());
                rolesAuth.setModifiedDate(formatter.format(moddate));
                rolesAuthz.add(rolesAuth);
            }

        }
        catch (Exception e)
        {
            Message = "permitws Web Service: " + e.getMessage();
            log.error(Message);
                       e.printStackTrace();

            throw new permitException(e);
        }

        userAuthorization[] array = (userAuthorization[])rolesAuthz.toArray(new userAuthorization[rolesAuthz.size()]);

        return(array);
    }

}