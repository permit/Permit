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

package edu.mit.isda.permitservice.service;

import java.util.Map;
import javax.sql.DataSource;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 *
 * @author vkonda
 */
public class BatchActionDaoImpl extends HibernateDaoSupport implements BatchActionDao 
{
    private DataSource dataSource;

    public DataSource getDataSource() {
        return dataSource;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    
    /**
     * 
     * @param server_id
     * @param kerberos_name
     * @param authorization_id
     * @return
     */
    public Map batchDelete(String server_id, String kerberos_name, String authorization_id)
    {
        DeleteAuthProc proc = new DeleteAuthProc(dataSource);
        return proc.execute(server_id, kerberos_name, authorization_id);
    }
    /**
     * 
     * @param server_id
     * @param for_user
     * @param kerberos_name
     * @param authorization_id
     * @return
     */
    public Map batchCreate(String server_id, String for_user, String kerberos_name, String authorization_id)
    {
         BatchCreateAuthProc proc = new BatchCreateAuthProc(dataSource);
         return proc.execute( server_id,  for_user,  kerberos_name,  authorization_id);
       
    }
    
    /**
     * 
     * @param server_id
     * @param for_user
     * @param authorization_id
     * @param effective_date
     * @param expiration_date
     * @return
     */
    public Map batchUpdate(String server_id, String for_user, String authorization_id, String effective_date, String expiration_date)
    {
          BatchUpdateAuthProc proc = new BatchUpdateAuthProc(dataSource);
         return proc.execute( server_id,  for_user,  authorization_id,  effective_date,  expiration_date);
       
    }
    /**
     * 
     * @param server_id
     * @param for_user - User who is requesting the replace operation
     * @param kerberos_name - Target User 
     * @param authorization_id
     * @return
     */
    public Boolean batchReplace(String server_id, String for_user, String kerberos_name, String authorization_id)
    {
         BatchCreateAuthProc proc = new BatchCreateAuthProc(dataSource);
         Map m = proc.execute( server_id,  for_user,kerberos_name, authorization_id);
       
         DeleteAuthProc dproc = new DeleteAuthProc(dataSource);
         m =  dproc.execute(server_id, for_user, authorization_id);        
         
          return Boolean.TRUE;
    }

}
