/**
 * PermitServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package permitService_pkg;

public class PermitServiceLocator extends org.apache.axis.client.Service implements permitService_pkg.PermitService {

    public PermitServiceLocator() {
    }


    public PermitServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public PermitServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for permit
    private java.lang.String permit_address = "https://ws-dev.mit.edu/permitws/services/permit";

    public java.lang.String getpermitAddress() {
        return permit_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String permitWSDDServiceName = "permit";

    public java.lang.String getpermitWSDDServiceName() {
        return permitWSDDServiceName;
    }

    public void setpermitWSDDServiceName(java.lang.String name) {
        permitWSDDServiceName = name;
    }

    public permitService_pkg.Permit getpermit() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(permit_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getpermit(endpoint);
    }

    public permitService_pkg.Permit getpermit(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            permitService_pkg.PermitSoapBindingStub _stub = new permitService_pkg.PermitSoapBindingStub(portAddress, this);
            _stub.setPortName(getpermitWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setpermitEndpointAddress(java.lang.String address) {
        permit_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (permitService_pkg.Permit.class.isAssignableFrom(serviceEndpointInterface)) {
                permitService_pkg.PermitSoapBindingStub _stub = new permitService_pkg.PermitSoapBindingStub(new java.net.URL(permit_address), this);
                _stub.setPortName(getpermitWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("permit".equals(inputPortName)) {
            return getpermit();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("urn:permitService", "permitService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("urn:permitService", "permit"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("permit".equals(portName)) {
            setpermitEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
