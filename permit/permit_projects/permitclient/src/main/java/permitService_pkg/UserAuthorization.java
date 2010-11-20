/**
 * UserAuthorization.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package permitService_pkg;

public class UserAuthorization  extends permitService_pkg.PermitAuthorization  implements java.io.Serializable {
    private java.lang.String authorizationID;

    private java.lang.String doFunction;

    private java.lang.String effectiveDate;

    private java.lang.String expirationDate;

    private java.lang.String grantAuth;

    private java.lang.String modifiedBy;

    private java.lang.String modifiedDate;

    private java.lang.String qualifierType;

    public UserAuthorization() {
    }

    public UserAuthorization(
           java.lang.String category,
           java.lang.String function,
           java.lang.String name,
           java.lang.String qualifier,
           java.lang.String qualifierCode,
           java.lang.String authorizationID,
           java.lang.String doFunction,
           java.lang.String effectiveDate,
           java.lang.String expirationDate,
           java.lang.String grantAuth,
           java.lang.String modifiedBy,
           java.lang.String modifiedDate,
           java.lang.String qualifierType) {
        super(
            category,
            function,
            name,
            qualifier,
            qualifierCode);
        this.authorizationID = authorizationID;
        this.doFunction = doFunction;
        this.effectiveDate = effectiveDate;
        this.expirationDate = expirationDate;
        this.grantAuth = grantAuth;
        this.modifiedBy = modifiedBy;
        this.modifiedDate = modifiedDate;
        this.qualifierType = qualifierType;
    }


    /**
     * Gets the authorizationID value for this UserAuthorization.
     * 
     * @return authorizationID
     */
    public java.lang.String getAuthorizationID() {
        return authorizationID;
    }


    /**
     * Sets the authorizationID value for this UserAuthorization.
     * 
     * @param authorizationID
     */
    public void setAuthorizationID(java.lang.String authorizationID) {
        this.authorizationID = authorizationID;
    }


    /**
     * Gets the doFunction value for this UserAuthorization.
     * 
     * @return doFunction
     */
    public java.lang.String getDoFunction() {
        return doFunction;
    }


    /**
     * Sets the doFunction value for this UserAuthorization.
     * 
     * @param doFunction
     */
    public void setDoFunction(java.lang.String doFunction) {
        this.doFunction = doFunction;
    }


    /**
     * Gets the effectiveDate value for this UserAuthorization.
     * 
     * @return effectiveDate
     */
    public java.lang.String getEffectiveDate() {
        return effectiveDate;
    }


    /**
     * Sets the effectiveDate value for this UserAuthorization.
     * 
     * @param effectiveDate
     */
    public void setEffectiveDate(java.lang.String effectiveDate) {
        this.effectiveDate = effectiveDate;
    }


    /**
     * Gets the expirationDate value for this UserAuthorization.
     * 
     * @return expirationDate
     */
    public java.lang.String getExpirationDate() {
        return expirationDate;
    }


    /**
     * Sets the expirationDate value for this UserAuthorization.
     * 
     * @param expirationDate
     */
    public void setExpirationDate(java.lang.String expirationDate) {
        this.expirationDate = expirationDate;
    }


    /**
     * Gets the grantAuth value for this UserAuthorization.
     * 
     * @return grantAuth
     */
    public java.lang.String getGrantAuth() {
        return grantAuth;
    }


    /**
     * Sets the grantAuth value for this UserAuthorization.
     * 
     * @param grantAuth
     */
    public void setGrantAuth(java.lang.String grantAuth) {
        this.grantAuth = grantAuth;
    }


    /**
     * Gets the modifiedBy value for this UserAuthorization.
     * 
     * @return modifiedBy
     */
    public java.lang.String getModifiedBy() {
        return modifiedBy;
    }


    /**
     * Sets the modifiedBy value for this UserAuthorization.
     * 
     * @param modifiedBy
     */
    public void setModifiedBy(java.lang.String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }


    /**
     * Gets the modifiedDate value for this UserAuthorization.
     * 
     * @return modifiedDate
     */
    public java.lang.String getModifiedDate() {
        return modifiedDate;
    }


    /**
     * Sets the modifiedDate value for this UserAuthorization.
     * 
     * @param modifiedDate
     */
    public void setModifiedDate(java.lang.String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }


    /**
     * Gets the qualifierType value for this UserAuthorization.
     * 
     * @return qualifierType
     */
    public java.lang.String getQualifierType() {
        return qualifierType;
    }


    /**
     * Sets the qualifierType value for this UserAuthorization.
     * 
     * @param qualifierType
     */
    public void setQualifierType(java.lang.String qualifierType) {
        this.qualifierType = qualifierType;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UserAuthorization)) return false;
        UserAuthorization other = (UserAuthorization) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.authorizationID==null && other.getAuthorizationID()==null) || 
             (this.authorizationID!=null &&
              this.authorizationID.equals(other.getAuthorizationID()))) &&
            ((this.doFunction==null && other.getDoFunction()==null) || 
             (this.doFunction!=null &&
              this.doFunction.equals(other.getDoFunction()))) &&
            ((this.effectiveDate==null && other.getEffectiveDate()==null) || 
             (this.effectiveDate!=null &&
              this.effectiveDate.equals(other.getEffectiveDate()))) &&
            ((this.expirationDate==null && other.getExpirationDate()==null) || 
             (this.expirationDate!=null &&
              this.expirationDate.equals(other.getExpirationDate()))) &&
            ((this.grantAuth==null && other.getGrantAuth()==null) || 
             (this.grantAuth!=null &&
              this.grantAuth.equals(other.getGrantAuth()))) &&
            ((this.modifiedBy==null && other.getModifiedBy()==null) || 
             (this.modifiedBy!=null &&
              this.modifiedBy.equals(other.getModifiedBy()))) &&
            ((this.modifiedDate==null && other.getModifiedDate()==null) || 
             (this.modifiedDate!=null &&
              this.modifiedDate.equals(other.getModifiedDate()))) &&
            ((this.qualifierType==null && other.getQualifierType()==null) || 
             (this.qualifierType!=null &&
              this.qualifierType.equals(other.getQualifierType())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getAuthorizationID() != null) {
            _hashCode += getAuthorizationID().hashCode();
        }
        if (getDoFunction() != null) {
            _hashCode += getDoFunction().hashCode();
        }
        if (getEffectiveDate() != null) {
            _hashCode += getEffectiveDate().hashCode();
        }
        if (getExpirationDate() != null) {
            _hashCode += getExpirationDate().hashCode();
        }
        if (getGrantAuth() != null) {
            _hashCode += getGrantAuth().hashCode();
        }
        if (getModifiedBy() != null) {
            _hashCode += getModifiedBy().hashCode();
        }
        if (getModifiedDate() != null) {
            _hashCode += getModifiedDate().hashCode();
        }
        if (getQualifierType() != null) {
            _hashCode += getQualifierType().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(UserAuthorization.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:permitService", "userAuthorization"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("authorizationID");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "authorizationID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("doFunction");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "doFunction"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("effectiveDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "effectiveDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("expirationDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "expirationDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grantAuth");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "grantAuth"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modifiedBy");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "modifiedBy"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modifiedDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "modifiedDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("qualifierType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:permitService", "qualifierType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
