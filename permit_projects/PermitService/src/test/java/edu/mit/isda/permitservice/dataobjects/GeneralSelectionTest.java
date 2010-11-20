/*
 * GeneralSelectionTest.java
 * JUnit based test
 *
 * Created on October 11, 2007, 5:09 PM
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

import junit.framework.*;
import edu.mit.isda.permitservice.service.GeneralSelectionManager;
import edu.mit.isda.permitservice.service.GeneralSelectionFactory;
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

/**
 *
 * @author Administrator
 */
public class GeneralSelectionTest extends TestCase {
    
    public GeneralSelectionTest(String testName) {
        super(testName);
    }

    protected void setUp() throws Exception {
        
    }

    protected void tearDown() throws Exception {
    }

    public void testMethod()
    {
        
    }
//    public static Test suite() {
//        //TestSuite suite = new TestSuite(AuthorizationManagerTest.class);
//        TestSuite suite = new TestSuite();
//        
//        //suite.addTest(new GeneralSelectionTest("testGetCriteriaSet"));
//        //suite.addTest(new GeneralSelectionTest("testGetSelectionList"));
//        suite.addTest(new GeneralSelectionTest("testListAuthorizationsByCriteria"));
//        //suite.addTest(new GeneralSelectionTest("testListPersonRaw"));
//        
//        return suite;
//    }
//
//
//    /**
//     * Test of getCriteriaSet method, of class edu.mit.isda.permitservice.dataobjects.GeneralSelection.
//     */
//    public void testGetCriteriaSet() throws Exception {
//        System.out.println("getCriteriaSet");
//        
//        String selectionID = "130";
//        String userName = "COHEND";
//        GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
//        
//        Collection<Criteria> result = instance.getCriteriaSet(selectionID, userName);
//        System.out.println(result.size());
//        System.out.println("\n\nRESULTS:" + result.toString());
//    }
//    
//    /**
//     * Test of listAuthorizationsByCriteria method, of class edu.mit.isda.permitservice.dataobjects.GeneralSelection.
//     */
//    public void testListAuthorizationsByCriteria() throws Exception {
//           
//        System.out.println("listAuthorizationsByCriteria");
//        
//        //String selectionID = "130";
//        //String userName = "REPA";
//        GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
//        //String applicationName = "REPA";
//        //String proxyUserName = "REPA";
//        //String criteriaNumber = "1";
//        String crit_list = "205||COHEND";
//        String[] criteria = new String[43];
//        
//            String[] crit_split = crit_list.split("\\|\\|");
//            
//            criteria[0] = "rolewww9";
//            criteria[1] = "REPA";
//            int critNum =  crit_split.length/2;
//            criteria[2] = "1";
//            int j = 0;
//            
//            for (int i = 0; i < crit_split.length; i++) {
//                j = i+3;
//                criteria[j] = crit_split[i];
//            }
//
//      
//        Collection<Authorization> result = instance.listAuthorizationsByCriteria(criteria) ;
//        //System.out.println(result.size());
//        System.out.println(result.toString());
//    }    
//    
//    public void testListPersonRaw() throws Exception {
//        System.out.println("testListPersonRaw");
//        
//        GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
//        Collection<PersonRaw> results = instance.listPersonRaw("COHEN%", "both", "type", "E", "S", "O");
//        
//        Iterator iter = results.iterator();
//        
//        while(iter.hasNext()) {
//            PersonRaw result = (PersonRaw)iter.next();
//            //System.out.println(result.size());
//            System.out.println(result.toString());
//        }
//    }
//    
//    public void testGetSelectionList() throws Exception {
//        System.out.println("testGetSelectionList");
//        
//        GeneralSelectionManager instance = GeneralSelectionFactory.getManager();
//        Collection<SelectionList> results = instance.getSelectionList("COHEND");
//        
//        Iterator iter = results.iterator();
//        
//        while(iter.hasNext()) {
//            SelectionList result = (SelectionList)iter.next();
//            System.out.println(result.toString());
//        }
//    }    
    
}
