/*
 * GeneralSelectionManager.java
 * Created on September 21, 2007, 1:08 AM
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
public interface GeneralSelectionManager {
    public static  final int BEGINWITH = 0;
    public static  final int CONTAINS = 1;
    public static  final int EXACT = 2;
    
    public Collection<Criteria> getCriteriaSet(String selectionID, String userName) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
    public Collection<Authorization> listAuthorizationsByCriteria(String[] criteria) throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;
    public Collection<PersonRaw> listPersonRaw(String name, String search, String sort, String filter1, String filter2, String filter3) throws InvalidInputException, ObjectNotFoundException, PermissionException, AuthorizationException;
    public Collection<SelectionList> getSelectionList(String userName) throws InvalidInputException, ObjectNotFoundException, AuthorizationException;
   
}
