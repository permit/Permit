/**
 * Permit.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package permitService_pkg;

public interface Permit extends java.rmi.Remote {
    public boolean isUserAuthorized(java.lang.String userName, java.lang.String function_category, java.lang.String function_name, java.lang.String qualifier_code, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public permitService_pkg.PermitAuthorization[] listAuthorizationsByPerson(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public permitService_pkg.UserAuthorization[] getUserAuthorizations(java.lang.String userName, java.lang.String category, java.lang.String function_name, java.lang.String function_id, boolean isActive, boolean willExpand, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public boolean isUserAuthorizedExt(java.lang.String userName, java.lang.String function_category, java.lang.String function_name, java.lang.String qualifier_code, java.lang.String proxyUserName, java.lang.String realOrImplied) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String createAuthorization(java.lang.String userName, java.lang.String function_name, java.lang.String qualifier_code, java.lang.String kerberos_name, java.lang.String effective_date, java.lang.String expiration_date, java.lang.String do_function, java.lang.String grant_auth) throws java.rmi.RemoteException;
    public boolean updateAuthorization(java.lang.String userName, java.lang.String auth_id, java.lang.String function_name, java.lang.String qualifier_code, java.lang.String kerberos_name, java.lang.String effective_date, java.lang.String expiration_date, java.lang.String do_function, java.lang.String grant_auth) throws java.rmi.RemoteException;
    public boolean deleteAuthorization(java.lang.String userName, java.lang.String auth_id) throws java.rmi.RemoteException;
    public permitService_pkg.PermitAuthorizationExt[] listAuthorizationsByPersonExt(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listAuthorizationsByPersonXML(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listEditableAuthorizationByAuthId(java.lang.String authId, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listAuthorizationsByPersonRawXML(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listAuthByPersonExtend1XML(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName, java.lang.String realOrImplied, java.lang.String function_name, java.lang.String function_id, java.lang.String function_qualifier_type, java.lang.String qualifier_code, java.lang.String qualifier_id, java.lang.String base_qual_code, java.lang.String base_qual_id, java.lang.String parent_qual_code, java.lang.String parent_qual_id) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public permitService_pkg.PermitAuthorizationExt[] listAuthByPersonExtend1(java.lang.String userName, java.lang.String category, boolean isActive, boolean willExpand, java.lang.String proxyUserName, java.lang.String realOrImplied, java.lang.String function_name, java.lang.String function_id, java.lang.String function_qualifier_type, java.lang.String qualifier_code, java.lang.String qualifier_id, java.lang.String base_qual_code, java.lang.String base_qual_id, java.lang.String parent_qual_code, java.lang.String parent_qual_id) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listAuthorizationsByCriteria(java.lang.String proxyUserName, java.lang.String crit_list) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String checkAuthEditPermissions(java.lang.String proxyUserName, java.lang.String functionName, java.lang.String qualifierCode) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public permitService_pkg.PermitPickableCategory[] listFunctionCategories(java.lang.String userName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public permitService_pkg.PermitPickableFunction[] listPickableFunctionsByCategory(java.lang.String userName, java.lang.String category) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getQualifierTypeForFunction(java.lang.String userName, java.lang.String category, java.lang.String function_name) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getFunctionDesc(java.lang.String userName, java.lang.String category, java.lang.String function_name) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getQualifierXML(java.lang.String userName, java.lang.String function, java.lang.String qualifier_type) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getQualifierXMLForCriteriaQuery(java.lang.String userName, java.lang.String functionName, java.lang.String qualifierType) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getQualifierRootXML(java.lang.String root_id, java.lang.String root, java.lang.String qualifier_type) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listViewableCategories(java.lang.String userName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listViewableFunctionsByCategory(java.lang.String category) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String batchCreate(java.lang.String userName, java.lang.String kerberos_name, java.lang.String authIDs) throws java.rmi.RemoteException;
    public java.lang.String batchDelete(java.lang.String userName, java.lang.String deleteIDs) throws java.rmi.RemoteException;
    public java.lang.String batchReplace(java.lang.String userName, java.lang.String kerberos_name, java.lang.String authIDs) throws java.rmi.RemoteException;
    public java.lang.String batchUpdate(java.lang.String userName, java.lang.String authIDs, java.lang.String effective_date, java.lang.String expiration_date) throws java.rmi.RemoteException;
    public java.lang.String saveCriteria(java.lang.String userName, java.lang.String selection_id, java.lang.String criteria_list, java.lang.String value_list, java.lang.String apply_list) throws java.rmi.RemoteException;
    public java.lang.String getSelectionList(java.lang.String userName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String getCriteriaSet(java.lang.String selectionID, java.lang.String userName) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listPersonRaw(java.lang.String proxyUserName, java.lang.String name, java.lang.String search, java.lang.String sort, java.lang.String filter1, java.lang.String filter2, java.lang.String filter3) throws java.rmi.RemoteException, permitService_pkg.PermitException;
    public java.lang.String listPersonJSON(java.lang.String proxyUserName, java.lang.String name, java.lang.String search, java.lang.String sort, java.lang.String filter1, java.lang.String filter2, java.lang.String filter3) throws java.rmi.RemoteException, permitService_pkg.PermitException;
}
