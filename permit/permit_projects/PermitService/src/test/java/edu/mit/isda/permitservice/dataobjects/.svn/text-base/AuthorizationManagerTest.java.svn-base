/*
 * AuthorizationManagerTest.java
 * JUnit based test
 *
 * Created on July 5, 2006, 1:06 PM
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

import edu.mit.isda.permitservice.dataobjects.PickableFunction;
import edu.mit.isda.permitservice.dataobjects.AuthorizationExt;
import edu.mit.isda.permitservice.dataobjects.PermissionException;
import edu.mit.isda.permitservice.dataobjects.InvalidInputException;
import edu.mit.isda.permitservice.dataobjects.PickableCategory;
import edu.mit.isda.permitservice.dataobjects.ViewableCategory;
import edu.mit.isda.permitservice.dataobjects.Person;
import edu.mit.isda.permitservice.dataobjects.Category;
import edu.mit.isda.permitservice.dataobjects.Qualifier;
import edu.mit.isda.permitservice.dataobjects.ViewableFunction;
import edu.mit.isda.permitservice.dataobjects.AuthorizationRaw;
import edu.mit.isda.permitservice.dataobjects.Authorization;
import edu.mit.isda.permitservice.dataobjects.Function;
import edu.mit.isda.permitservice.dataobjects.QualifierType;
import edu.mit.isda.permitservice.SpringTransactionalFixtureTest;
import edu.mit.isda.permitservice.service.*;

import junit.framework.*;
import java.util.*;
import java.util.logging.Logger;
import java.lang.Boolean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 *
 * @author dongq.admin
 */
public class AuthorizationManagerTest extends SpringTransactionalFixtureTest {
    
   // private AuthorizationManager instance;
    public AuthorizationManagerTest() {
        
        super();
    }
    
//        public AuthorizationManagerTest(String testName) {
//        
//        super(testName);
//    }
//        
    public void testMethod()
    {
        
    }
 
   // public static Test suite() {
        //TestSuite suite = new TestSuite(AuthorizationManagerTest.class);
   //     TestSuite suite = new TestSuite();
        
        //suite.addTest(new AuthorizationManagerTest("testGetAuthorizations"));
        //suite.addTest(new AuthorizationManagerTest("testGetAuthorizationsRaw"));
        //suite.addTest(new AuthorizationManagerTest("testGetAuthorizationsRawExt"));
        //suite.addTest(new AuthorizationManagerTest("testIsUserAuthImplied1"));
        //suite.addTest(new AuthorizationManagerTest("testListFunctionCategories"));
        //suite.addTest(new AuthorizationManagerTest("testListPickableFunctionsByCategory"));
        //suite.addTest(new AuthorizationManagerTest("testListPickableQualifiers"));
        //suite.addTest(new AuthorizationManagerTest("testGetViewableCategory"));
        //suite.addTest(new AuthorizationManagerTest("testGetViewableFunction"));
        //suite.addTest(new AuthorizationManagerTest("testDeleteAuthorization"));
        //suite.addTest(new AuthorizationManagerTest("testCreateAuthorization"));
        //suite.addTest(new AuthorizationManagerTest("testBatchCreate"));
        //suite.addTest(new AuthorizationManagerTest("testBatchReplace"));
        //suite.addTest(new AuthorizationManagerTest("testBatchUpdate"));
        //suite.addTest(new AuthorizationManagerTest("testSaveCriteria"));
        //suite.addTest(new AuthorizationManagerTest("testGetUserAuthorizations"));
        //suite.addTest(new AuthorizationManagerTest("testUpdateAuthorization"));
       // suite.addTest(new edu.mit.isda.permitservice.dataobjects.AuthorizationManagerTest("testListAuthByPersonExtend1"));
        
     //   return suite;
 //   }

   
    
     public void testGetUserAuthorizations() {
       System.out.println("getUserAuthorizations");
       
       try{
          
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Collection<Authorization> auth = instance.getUserAuthorizations("COHEND", "SAP", "", "529", Boolean.FALSE, Boolean.FALSE, "dongq", "dongq");
            
            
            Iterator<Authorization> i = auth.iterator();
             
            int count = auth.size();
            System.out.println("has " +  count + " authorizations");
            count = 1;
            while(i.hasNext())
            {
                Authorization a = i.next();
                System.out.println(a.toString());
                Category c = a.getCategory();
                System.out.println(c.toString());
                Function f = a.getFunction();
                System.out.println(f.toString());
                Qualifier q = a.getQualifier();
                System.out.println(q.toString());
                Person p = a.getPerson();
                System.out.println(p.toString());
                System.out.println("Do Function: " + a.getDoFunction());
                System.out.println("Modified Date: " + a.getModifiedDate());
                System.out.println("Modified By: " + a.getModifiedBy());                
                System.out.println("Effective Date: " + a.getEffectiveDate());
                System.out.println("Expiration Date: " + a.getExpirationDate());
                System.out.println("*******************************");
                
            }
       
       }
       catch (Exception e){
            System.out.println(e.getMessage());
        }
      
    }    
     public void testListAuthByPersonExtend1()
   {
           System.out.println("listAuthByPersonExtend1");
       
        try
        {
            AuthorizationManager instance = AuthorizationFactory.getManager();

            Collection<AuthorizationExt> auths = instance.listAuthByPersonExtend1("PBH", "MATB",  Boolean.TRUE, Boolean.TRUE,"ROLES", "PBH", "B","ADMINISTRATOR MATH BLOG","", "MBLG","MBLG_CI", "", "","","","");
            
    
        }
        catch (InvalidInputException e)
        {
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
        catch(PermissionException e)
        {
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }  
   }
     
     public void testGetAuthorizations() {
       System.out.println("getAuthorizations");
       
       try{
          
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Set<Authorization> auth = instance.listAuthorizationsByPerson("SUSANEG", "", Boolean.FALSE, Boolean.FALSE, "dongq", "dongq");
            
            
            Iterator<Authorization> i = auth.iterator();
             
            int count = auth.size();
            System.out.println("has " +  count + " authorizations");
            count = 1;
            while(i.hasNext())
            {
                Authorization a = i.next();
                System.out.println(a.toString());
                Category c = a.getCategory();
                System.out.println(c.toString());
                Function f = a.getFunction();
                System.out.println(f.toString());
                Qualifier q = a.getQualifier();
                System.out.println(q.toString());
                Person p = a.getPerson();
                System.out.println(p.toString());
                System.out.println("Do Function: " + a.getDoFunction());
                System.out.println("Modified Date: " + a.getModifiedDate());
                System.out.println("Modified By: " + a.getModifiedBy());                
                System.out.println("Effective Date: " + a.getEffectiveDate());
                System.out.println("Expiration Date: " + a.getExpirationDate());
                System.out.println("*******************************");
                
            }
       
       }
       catch (Exception e){
            System.out.println(e.getMessage());
        }
      
    }

     public void testGetAuthorizationsRawExt() {
       System.out.println("getAuthorizationsRawExt");
       
       try{
          
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Collection<AuthorizationExt> auth = instance.listAuthByPersonExtend1("COHEND", "", Boolean.FALSE, Boolean.FALSE, "dongq", "dongq", "R", 
                                                                                    null, null, null, null, null, null, null, null, null);
            
            Iterator<AuthorizationExt> i = auth.iterator();
             
            int count = auth.size();
            System.out.println("has " +  count + " authorizations");
            count = 1;
            while(i.hasNext())
            {
                AuthorizationExt a = i.next();
                System.out.println(a.toString());
                System.out.println("Do Function: " + a.getDoFunction());
                System.out.println("Modified Date: " + a.getModifiedDate());
                System.out.println("Modified By: " + a.getModifiedBy());                
                System.out.println("Effective Date: " + a.getEffectiveDate());
                System.out.println("Expiration Date: " + a.getExpirationDate());
                System.out.println("*******************************");
            }
       }
       catch (Exception e){
            System.out.println(e.getMessage());
        }
    }    
     
     public void testGetAuthorizationsRaw() {
       System.out.println("getAuthorizationsRaw");
       
       try{
          
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Collection<AuthorizationRaw> auth = instance.listAuthorizationsByPersonRaw("SUSANEG", "", Boolean.FALSE, Boolean.FALSE, "dongq", "dongq");
            
            
            Iterator<AuthorizationRaw> i = auth.iterator();
             
            int count = auth.size();
            System.out.println("has " +  count + " authorizations");
            count = 1;
            while(i.hasNext())
            {
                AuthorizationRaw a = i.next();
                System.out.println(a.toString());
                System.out.println("Do Function: " + a.getDoFunction());
                System.out.println("Modified Date: " + a.getModifiedDate());
                System.out.println("Modified By: " + a.getModifiedBy());                
                System.out.println("Effective Date: " + a.getEffectiveDate());
                System.out.println("Expiration Date: " + a.getExpirationDate());
                System.out.println("*******************************");
            }
       }
       catch (Exception e){
            System.out.println(e.getMessage());
        }
    }         
     
    public void testIsUserAuthImplied1() {
        System.out.println("testIsUserAuthImplied1");
       
        try
        {
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Boolean b = instance.isUserAuthExtend1("PBH", "sap",  "can use sap", "NULL","DONGQ", "DONGQ", "B");
            
            if (b)
                System.out.println("repa is primary authorizer");
            else
                System.out.println("repa is not primary authorizer");
        }
        catch (InvalidInputException e)
        {
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
        catch(PermissionException e)
        {
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }     
     
 public void testIsUserAuthorized() {
       System.out.println("IsUserAuthorized");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
            Boolean b = instance.isUserAuthorized("PBH", "sap",  "can use sap", "NULL","DONGQ", "DONGQ");
            
            if (b)
                System.out.println("repa is primary authorizer");
            else
                System.out.println("repa is not primary authorizer");
            
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
       
      
    }
 
 public void testIsUserAuthorized2() {
       System.out.println("IsUserAuthorized");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Boolean b = instance.isUserAuthorized("pbh", new Integer(532),  new Long(416008), "DONGQ", "REPA");
            
            if (b)
                System.out.println("pbh can report by co/pc");
            else
                System.out.println("pbh can not report by co/pc");
   
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
       
     
    }
 
   public void testBatchCreate() {
       System.out.println("batchCreate");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            String b = instance.batchCreate("COHEND", "ROLEWWW9", "FACELLI", "54936,54975");
            
            System.out.println("Result = " + b);
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }
   
   public void testBatchReplace() {
       System.out.println("batchReplace");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            String b = instance.batchReplace("COHEND", "ROLEWWW9", "FACELLI", "63126,54910");
            
            System.out.println("Result = " + b);
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }   
   
   public void testBatchUpdate() {
       System.out.println("batchUpdate");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            String b = instance.batchUpdate("COHEND", "ROLEWWW9", "54936,54975", "06232008", "02282016");
            
            System.out.println("Result = " + b);
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }   
   
   public void testSaveCriteria() {
       System.out.println("saveCriteria");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            String b = instance.saveCriteria("COHEND", "ROLEWWW9", "130", "205,210,215,220,222,223", "COHEND,SAP ,REPORT BY CO/PC,null,Y,Y", "Y,N,N,N,N,N");
            
            System.out.println("Result = " + b);
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }      
  
  public void testCreateAuthorization() {
       System.out.println("createAuthorization");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            String b = instance.createAuthorization("COHEND", "ROLEWWW9", "GREENSDFSDF", "1", "COHEND", "06172007", "", "Y", "G");
            
            if (b.contains("true"))
                System.out.println("pbh can report by co/pc");
            else
                System.out.println("pbh can not report by co/pc");
            
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }

  public void testUpdateAuthorization() {
       System.out.println("updateAuthorization");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Boolean b = instance.updateAuthorization("COHEND", "ROLEWWW9", "54043", "CREATE FUNCTIONS", "CATTEST", "COHEND", "05282007", "05242008", "Y", "G");
            
            if (b)
                System.out.println("pbh can report by co/pc");
            else
                System.out.println("pbh can not report by co/pc");
            
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }
  
  public void testDeleteAuthorization() {
       System.out.println("deleteAuthorization");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Boolean b = instance.deleteAuthorization("COHEND", "ROLEWWW9", "54199");
            
            if (b)
                System.out.println("pbh can report by co/pc");
            else
                System.out.println("pbh can not report by co/pc");
            
           
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }
  
 public void testGetChildrenByQualifier() {
          try{
            System.out.println("get children by qualifier");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Qualifier> s = instance.listChildrenByQualifier(new Long(400372));
            int count = s.size();
            System.out.println("has " +  count + " child qualifiers");
            Iterator<Qualifier> i = s.iterator();
            while(i.hasNext())
            {
                Qualifier f1 = i.next();
                System.out.println(f1.toString());
            }
        
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
    }
 
 public void testGetCategories() 
    {
        System.out.println("getCategories");
        try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Category> result = instance.listCategories();
            Iterator<Category> i = result.iterator();
            while(i.hasNext())
            {
                Category c = i.next();
                System.out.println(c.toString());
                System.out.println("************************************************");
            }
       
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
     
    public void testListQualifierTypes() 
    {
        try{
            System.out.println("getQualifierTypes");
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<QualifierType> result = instance.listQualifierTypes();
            Iterator<QualifierType> i = result.iterator();
            while(i.hasNext())
            {
                QualifierType qt = i.next();
                System.out.println(qt.toString());
                System.out.println("************************************************");
            }
       
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
    
    public void testGetQualifierType() {
        try{
            System.out.println("getQualifiertype");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            QualifierType result = instance.getQualifierType("cost");
        
            System.out.println(result.toString());
            
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
      
    }
         
  public void testGetFunctionsByCategory() {
        try{
            System.out.println("getCategory");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Function> functions = instance.listFunctionsByCategory("sap");
                     
            Iterator<Function> i = functions.iterator();
             
            int count = functions.size();
            System.out.println("has " +  count + " functions");
            count = 1;
            while(i.hasNext())
            {
                Function f = i.next();
                System.out.println(f.toString());
            }
           
            
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
      
    }
  
  public void testGetParentsByQualifier() {
          try{
            System.out.println("get children by qualifier");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Qualifier> s = instance.listParentsByQualifier(new Long(721525));
            int count = s.size();
            System.out.println("has " +  count + " parent qualifiers");
            Iterator<Qualifier> i = s.iterator();
            while(i.hasNext())
            {
                Qualifier f1 = i.next();
                System.out.println(f1.toString());
            }
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
    }
  
  public void testGetRootQualifierByType()
    {
        try{
            System.out.println("testGetRootQualifierByType");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
   
            Qualifier q=instance.getRootQualifierByType("cost");
           
           
            
           if (q != null)
                System.out.println(q.toString());
               
        }
            
        catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
   
  
  public void testListQualifiersByName() {
          try{
            System.out.println("get qualifier by name");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Qualifier> s = instance.listQualifiersByName("is&t shared ", AuthorizationManager.BEGINWITH);
            int count = s.size();
            System.out.println("match " +  count + "  qualifiers");
            Iterator<Qualifier> i = s.iterator();
            while(i.hasNext())
            {
                Qualifier f1 = i.next();
                System.out.println(f1.toString());
                System.out.println("*****************************");
            }
        
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
    }
  
  
  public void testListQualifiersByCode() {
          try{
            System.out.println("get qualifier by code");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Qualifier> s = instance.listQualifiersByCode("242805", AuthorizationManager.CONTAINS);
            int count = s.size();
            System.out.println("match " +  count + "  qualifiers");
            Iterator<Qualifier> i = s.iterator();
            while(i.hasNext())
            {
                Qualifier f1 = i.next();
                System.out.println(f1.toString());
                System.out.println("*****************************");
            }
        
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
  }
  
  public void testListFunctionsByName() {
          try{
            System.out.println("get function by name");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Function> s = instance.listFunctionsByName("function", AuthorizationManager.CONTAINS);
            int count = s.size();
            System.out.println("match " +  count + "  function");
            Iterator<Function> i = s.iterator();
            while(i.hasNext())
            {
                Function f1 = i.next();
                System.out.println(f1.toString());
                System.out.println("*****************************");
            }
        
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
    }
    
  public void testListFunctionsByDesc() {
          try{
            System.out.println("get function by description");
       
            AuthorizationManager instance = AuthorizationFactory.getManager();
       
            Set<Function> s = instance.listFunctionsByDescription("approve", AuthorizationManager.CONTAINS);
            int count = s.size();
            System.out.println("match " +  count + "  function");
            Iterator<Function> i = s.iterator();
            while(i.hasNext())
            {
                Function f1 = i.next();
                System.out.println(f1.toString());
                System.out.println("*****************************");
            }
          }
          catch (Exception e){
            System.out.println(e.getMessage());
        } 
    }
  
  public void testListFunctionCategories() {
       System.out.println("listFunctionCategories");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Collection<PickableCategory> c = instance.listFunctionCategories("PBH");
            
            System.out.println("Result = " + c.toString());
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }  
  
  public void testListPickableFunctionsByCategory() {
       System.out.println("listPickableFunctionsByCategory");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Collection<PickableFunction> f = instance.listPickableFunctionsByCategory("COHEND", "SAP");
            
            System.out.println("Result = " + f.toString());
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }    
  
  public void testListPickableQualifiers() {
       System.out.println("listPickableQualifiers");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            //Set<PickableQualifier> f = instance.listPickableQualifiers("COHEND", "GREEN");
            //String f = instance.getQualifierXML("COHEND", "HIRE EMPLOYEES");
            Boolean bool =  new Boolean("true");
            String f = instance.getQualifierXML("870029", bool, "COST");
            
            //System.out.println("Result = " + f.toString());
            System.out.println("Result = " + f);
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }   
  
  public void testGetViewableCategory() {
       System.out.println("getViewableCategory");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Collection<ViewableCategory> f = instance.getViewableCategory("COHEND");
            
            //System.out.println("Result = " + f.toString());
            System.out.println("Result = " + f.toString());
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }     
  
  public void testGetViewableFunction() {
       System.out.println("getViewableFunction");
       
       try{
            AuthorizationManager instance = AuthorizationFactory.getManager();
           
            Collection<ViewableFunction> f = instance.getViewableFunctionByCategory("SAP");
            
            System.out.println("Result = " + f.toString());
       }
       catch (InvalidInputException e){
            System.out.println("invalid Input");
            System.out.println(e.getMessage());
        }
       catch(PermissionException e){
            System.out.println("invalid permission");
            System.out.println(e.getMessage());
        }
       catch (Exception e)
       {
           System.out.println(e.getMessage());
       }
  }    
}
