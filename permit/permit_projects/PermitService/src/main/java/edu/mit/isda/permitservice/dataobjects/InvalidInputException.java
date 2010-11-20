/*
 * InvalidInputException.java
 * Created on July 20, 2006, 4:55 PM
 * Author: Qing Dong
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

/**
 * exception raised when the user inputs for queries are not valid
 * @author  Qing Dong
 * @version 1.0
 * @since 1.0
 */
public class InvalidInputException extends Exception {
    private int code;

    
    /** Creates a new instance of InvalidInputException 
     */
    public InvalidInputException() {
        super("input parameter can not be null");
        code = NullInput;
    }
    public InvalidInputException(String msg, int c)
    {
        super(msg);
        code = c;
        
    }

    public int getErrorCode()
    {
        return code;
    }
    public static int NullInput = 1;

    public static int InvalidFunction = 20001;

    public static int InvalidQualifier = 20002;
    
    public static int NeedFunctionCategory = 20007;
    
    public static int FunctionCategoryInvalidLength = 20008;
    
    public static int FunctionNameInvalidLength = 20009;
    
    public static int NeedKerberosName = 20010;
    
    public static int QualifierTypeInvalidLength = 20011;
    
    public static int InvalidQualifierType = 20012;
    
    public static int QualifierNameInvalidLength = 20013;
    
    public static int QualifierCodeInvalidLength = 20014;
    
    public static int FunctionDescInvalidLength = 20015;
    
    
    public static int LastNameInvalidLength = 20031;
    
    public static int FirstNameInvalidLength = 20032;
    
    public static int FirstLastNameEmpty = 20033;
    
}
