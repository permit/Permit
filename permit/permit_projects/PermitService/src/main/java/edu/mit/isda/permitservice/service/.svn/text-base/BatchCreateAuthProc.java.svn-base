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

import java.sql.Types;
import java.util.HashMap;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.StoredProcedure;

/**
 *
 * @author vkonda
 */
    public class BatchCreateAuthProc extends StoredProcedure {
        private static final String PROC_STATEMENT = "ROLESAPI_BATCH_CREATE_AUTH";
       
        public BatchCreateAuthProc(DataSource dataSource) { 
            
            super(dataSource, PROC_STATEMENT);
            int types = Types.VARCHAR;
            declareParameter(new SqlParameter("server_id", types));
            declareParameter(new SqlParameter("for_user", types));
            declareParameter(new SqlParameter("kerberos_name", types));
            declareParameter(new SqlParameter("authorization_id", types));
            declareParameter(new SqlOutParameter("modified_by", types));	
            declareParameter(new SqlOutParameter("modified_date", types));
            declareParameter(new SqlOutParameter("authorization_id", types));
            
            compile();
	}
                
        public Map execute(String server_id, String for_user, String kerberos_name, String authorization_id)  throws DataAccessException {
            Map inParam = new HashMap(1);
            inParam.put("server_id", server_id);
            inParam.put("for_user", for_user);
            inParam.put("kerberos_name", kerberos_name);
            inParam.put("authorization_id", authorization_id);
            return super.execute(inParam);
	}
    }  