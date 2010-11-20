/*
 * Criteria.java
 *
 * Created on September 25, 2007, 3:38 PM
 *
 * To change this template, choose Tools | Template Manager
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


package edu.mit.isda.permitservice.dataobjects;
import java.util.*;

/**
 *
 * @author Administrator
 */
public class Criteria {
    private Long id;
    private String selectionName;
    private String screenId;
    private String screenName;
    private String criteriaId;
    private String criteriaName;
    private String apply;
    private String nextScreen;
    private String value;
    private String noChange;
    private String sqlFragment;
    private String sequence;
    private String widget;
    
    /** Creates a new instance of Criteria */
    public Criteria() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSelectionName() {
        return selectionName;
    }

    public void setSelectionName(String selectionName) {
        this.selectionName = selectionName;
    }

    public String getScreenId() {
        return screenId;
    }

    public void setScreenId(String screenId) {
        this.screenId = screenId;
    }

    public String getScreenName() {
        return screenName;
    }

    public void setScreenName(String screenName) {
        this.screenName = screenName;
    }

    public String getCriteriaId() {
        return criteriaId;
    }

    public void setCriteriaId(String criteriaId) {
        this.criteriaId = criteriaId;
    }

    public String getCriteriaName() {
        return criteriaName;
    }

    public void setCriteriaName(String criteriaName) {
        this.criteriaName = criteriaName;
    }

    public String getApply() {
        return apply;
    }

    public void setApply(String apply) {
        this.apply = apply;
    }

    public String getNextScreen() {
        return nextScreen;
    }

    public void setNextScreen(String nextScreen) {
        this.nextScreen = nextScreen;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getNoChange() {
        return noChange;
    }

    public void setNoChange(String noChange) {
        this.noChange = noChange;
    }

    public String getSequence() {
        return sequence;
    }

    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public String getSqlFragment() {
        return sqlFragment;
    }

    public void setSqlFragment(String sqlFragment) {
        this.sqlFragment = sqlFragment;
    }

    public String getWidget() {
        return widget;
    }

    public void setWidget(String widget) {
        this.widget = widget;
    }
    
    
    public String toString() {
        String s = "Selection Name = " + selectionName;
        s += "\nId = " + id;
        s +=  "\n Screen Id = " + screenId;
        s += "\n Screen Name = " + screenName;
        s += "\n Criteria Id = " + criteriaId;
        s += "\n Criteria Name = " + criteriaName;
        s += "\n Apply = " + apply;
        s += "\n Next Screen = " + nextScreen;
        s += "\n Value = " + value;
        s += "\n No Change = " + noChange;
        s += "\n SQL Fragment = " + sqlFragment;
        s += "\n Sequence = " + sequence;
        s += "\n Widget = " + widget;
        return s;
    }
}