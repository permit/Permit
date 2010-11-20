/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
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

package edu.mit.isda.permitservice;

import javax.sql.DataSource;

import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * @author vkonda
 * 
 * This is a base class for JUNIT testing for Spring/Hibernate DAO and service
 * layers. It loads all the spring configuration files from their classpath.
 * It also creates data source necessary for EntityManager to test persistence layer.
 * 
 * By running testThisFixtureSetUp, you can verify if the spring configuration and auto-wiring
 * is configured properly. 
 * 
 */
public class SpringTransactionalFixtureTest extends
        AbstractTransactionalDataSourceSpringContextTests {
    
    public SpringTransactionalFixtureTest() {
        super();
        setAutowireMode(AUTOWIRE_BY_NAME);
        setDependencyCheck(false);
    }
    
    public void setDataSource(DataSource ds){
        super.setDataSource(ds);
    }
    
    public void setTxManager(PlatformTransactionManager tx){
        super.setTransactionManager(tx);
    }

    protected String[] getConfigLocations() {
        return new String[] {
                "classpath:permitApplicationContext-test.xml",
                "classpath:generalSelectionApplicationContext-test.xml"
                };
    }

    /**
     *
     * We need this method so that Test Cases which have no tests defined donot fail.
     *
     * This method is an excellent check for correct spring/hibernate verification
     * If any spring bean or hibernate mapping is not set correctly, this
     * test will fail.
     * Use this test if you want to check spring environment without having to
     * run all unit tests
     *  
     * @throws Exception
     */        
    public void testThisFixtureSetUp() throws Exception {
        assertTrue(true);
    }
}
