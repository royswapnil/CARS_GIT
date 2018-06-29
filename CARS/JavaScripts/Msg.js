// Jav// JavaScript Functions common for all the forms.
/*
   Workfile			: Msg.js
   Created on		: 08/07/2006    
   Author			: Palani Raja.E
   Modified on      : 1/2/2007
   Modified By      : Shoba.S    
   Description		: Contains JavaScript Functions common for all the forms.
   History          :
   
   Name :   Date    :   Description
   
   Supreetha N  12-Mar-2008 - Modified the Function "GetMultiMessage" to return the string value for Mozilla 
    Shilpa S Chandrashekhar - 13-Mar-2008 - Inserted the Function "ValidateNumbers(field)" for fixing bugs 1434,1442
   Supreetha N  14-Apr-2008   Added new function "gfi_ValidateDriverEmail" to fix bug_id 38
   Supreetha N  14-Apr-2008   Modified error message for re fixing bug_id 1148   

   Name and the description of the Functions used : 
       
        Form validations
        
    1.    gfi_CheckEmpty(field,label,tags) - Function checks whether a particular field is empty or not.
    2.    gfi_CheckEmptySpace(field,message)-  Function checks whether a particular field is empty or  single space given.
    3.    gfi_ValidateNumSpace(field,label,tags) - Function verifies whether the value entered is a number or space.
    4.    gfi_ValidateAlphaSpace(field,label) - Function to checks the field that can have only alphabets and spaces.
    5.    gfi_ValidatePhoneNumber(field,label,tags) - Function verifies whether the value entered is a number or space.
    6.    gfb_ValidateAlphabets(ctrlText,label) -Function verifies whether entered text is alphabets and international characters
    7.	  gfb_ValidateNumbers(ctrlText,label)  - Function verifies whether entered text is numbers.
    8.    gfi_ValidateEmail(field)
    9.    gfi_ValidateNumDot(field)
    10.   Ltrim(text)
    11.   Rtrim(text)
    12.   trim(text)
    13.   gfi_ValidateAlphaNumeric(field,tags)
    14.   gfi_ValidateSingleQuote(field)
    15.   isitFutureDate(field,label)
    16.   slashtext(obj)
    17.   gfi_ValidateFDate(field,label)
    18.   chklen(strCName)
    19.   gfi_ValidateNumber(field,tags)
    20.   gfi_ValidateDateDiff
    21.   gf_existsTextValInCombo(combo,selVal)
    22.   gfi_ValidatePrimary(field,tags)
        
   To provide message if the user enters some data in the form and navigating to some other pages without saving data.     
        
    23.   ConfirmFun(msg)
    24.   ChkFormDataChange(thisForm) 
    25.   chk_DefVal_FromTabs(thisForm)
    26.   chk_DefVal_FromLeftMenu(thisForm,Input)
   
   
  JavaScript Error message handling
  
    27.   displayerror(num,language)
    28. GetMultiMessage(errid,p1,p2)  added by G.Narayana Rao
    29. slashtext_Jer_Nor : for the jermany and norway date validation
   */
//******************************************************************************

window.history.forward(0);


var messageClose = GetMultiMessage('TIMEOUT','','');
function fnWarning()
{
    try
    { 
        addToEvent()
        if(window.showModalDialog)
        {           
            var parentWindow = window.dialogArguments;
            if(typeof(parentWindow)!="undefined")
            {
                window.close();
                alert(messageClose);
                var pathArray = parentWindow.location.pathname.split( '/' );
                var newPathname = pathArray[1];
                var redirectpage = parentWindow.location.protocol + "//" + parentWindow.location.host + "/" + newPathname + "/frmlogin.aspx"; 
                parentWindow.location.href = redirectpage;                            
            }
            else
            {
                if(typeof(window.opener)!="undefined") 
                { 
                    var x_win = window.self; 
                    var ct = 0;
                    while(x_win!="undefined") 
                    { 
                        x_win = x_win.opener; 
                        
                        if(x_win == null)
                        {
                            //Browser refers to Parent Page
                            break;
                        }
                        else
                        {
                            //Counts the child page                
                            ct = ct + 1;
                        }
                    }
                    
                    //In Mozilla, Parent page referred by ct = 0. ct greater than 0 refers to child page
                    if(ct == 0)
                    {
                        alert(messageClose);
                        var pathArray = window.location.pathname.split( '/' );
                        var newPathname = pathArray[1];
                        var redirectpage = window.location.protocol + "//" + window.location.host + "/" + newPathname + "/frmlogin.aspx"; 
                        window.location.href = redirectpage;
                    }
                    else
                    { 
                        var win = window.self;
                        win.close();
                    } 
                }
                else
                {
                    //In IE, Parent page doesnt have window.opener object.
                    alert(messageClose);
                    var pathArray = window.location.pathname.split( '/' );
                    var newPathname = pathArray[1];
                    var redirectpage = window.location.protocol + "//" + window.location.host + "/" + newPathname + "/frmlogin.aspx"; 
                    window.location.href = redirectpage;
                }
            }
        }        
        else if(typeof(window.opener)!="undefined") 
        { 
            var x_win = window.self; 
            var ct = 0;
            while(x_win!="undefined") 
            { 
                x_win = x_win.opener; 
                
                if(x_win == null)
                {
                    //Browser refers to Parent Page
                    break;
                }
                else
                {
                    //Counts the child page                
                    ct = ct + 1;
                }
            }
            
            //In Mozilla, Parent page referred by ct = 0. ct greater than 0 refers to child page
            if(ct == 0)
            {
                alert(messageClose);
                var pathArray = window.location.pathname.split( '/' );
                var newPathname = pathArray[1];
                var redirectpage = window.location.protocol + "//" + window.location.host + "/" + newPathname + "/frmlogin.aspx"; 
                window.location.href = redirectpage; 
            }
            else
            { 
                var win = window.self;
                win.close();
            } 
        }
        else 
        { 
            //In IE, Parent page doesnt have window.opener object.
            alert(messageClose);
            var pathArray = window.location.pathname.split( '/' );
            var newPathname = pathArray[1];
            var redirectpage = window.location.protocol + "//" + window.location.host + "/" + newPathname + "/frmlogin.aspx"; 
            window.location.href = redirectpage;
        } 
    }
    catch(e)
    {
       //Do Nothing 
    }        
}

var secs;
var timerID = null;
var timerRunning = false;
var delay = 1000;

function InitializeTimer(sessioninsecs)
{
    try
    {
        //Define the session timeout in secs
        secs = sessioninsecs;
        
        //On every post back, the timer has to be stopped and restarted
        StopTheClock();
        StartTheTimer();
        
        //If Page is Pop-Up page, then need to reset the Parent page timer
        ResetParentTimer(sessioninsecs);
    }
    catch(e)
    {
        //Do Nothing
    }
}

function StopTheClock()
{
    if(timerRunning)
        clearTimeout(timerID);
    timerRunning = false;
}

function StartTheTimer()
{
    if (secs==0)
    {
        StopTheClock();
        fnWarning();
    }
    else
    {
        secs = secs - 1;
        timerRunning = true;
        timerID = self.setTimeout("StartTheTimer()", delay);     
     }
}

function ResetParentTimer(sessioninsecs)
{
    try
    {
        //If Page opened has Parent, then call the Parent page InitializeTimer to restart the timer
        if(typeof(window.opener)!="undefined") 
        { 
            var x_win = window.self; 
            while(x_win!="undefined") 
            { 
                x_win = x_win.opener; 
                
                if(x_win == null)
                {
                    //Browser refers to Parent Page
                    break;
                }
                else
                {   
                    x_win.InitializeTimer(sessioninsecs)
                }
            }
        }
    }
    catch(e)
    {
        //Do Nothing
    }
}


function gfi_CheckEmpty(strCName,mess)
{
    var strCValue;
	var len;
	strCValue=strCName[0].value;
	len=strCValue.length;
	var ctrSpace=0;
	for(var icount=0;icount<len;icount++)
	{
		if(strCValue.charAt(icount)==' ')
		{
			ctrSpace++;
		} 	
	}
	if(strCValue=="" || ctrSpace==len)
	{
	var msg=GetMultiMessage('0022',GetMultiMessage(mess,'',''),'');
    alert(msg);
    strCName.focus();
		return false;
	}
	else
	{
		return true;
	}	
}

function gfi_CheckEmptySpace(strCName,mess)
{

	var strCValue;
	var len;
	strCValue=strCName[0].value;
	len=strCValue.length;
	var ctrSpace=0;
	for(var icount=0;icount<len;icount++)
	{
		if(strCValue.charAt(icount)==' ')
		{
			ctrSpace++; 
		}
		
	}
	if(ctrSpace==len)
	{
		var msg=GetMultiMessage('0350',GetMultiMessage(mess,'',''),'');	
		
        alert(msg);
		strCName.focus();
		return false;
	}
	else
	{

		return true;
	}	
	
}

 function gfi_CheckEmptySpaceVeh(strCName,mess)
{

	var strCValue;
	var len;
	strCValue=strCName[0].value;
	len=strCValue.length;
	var ctrSpace=0;
	for(var icount=0;icount<len;icount++)
	{
		if(strCValue.charAt(icount)==' ')
		{
			ctrSpace++; 
		}
		
	}
	if(ctrSpace==len)
	{
		return false;
	}
	else
	{

		return true;
	}	
	
}



function GetKey(evt)
    {
        evt = (evt) ? evt : (window.event) ? event : null;
        if (evt)
        {
            var cCode = (evt.charCode) ? evt.charCode :
                    ((evt.keyCode) ? evt.keyCode :
                    ((evt.which) ? evt.which : 0));
            return cCode; 
        }
    }
    
               function checkKeys()
               {
               if (event.keyCode==116)
                   {
                   
                   event.keyCode=0;
                   return false;
                   }
               }  
function HelpKeys(evt)
{
   if(GetKey(evt)==116)
    {
  
     if (navigator.appName == "Microsoft Internet Explorer")
      {
     document.onkeydown=checkKeys;
      }
      else
      {
      evt.preventDefault();
      }

} 
} 


 function disableDefault(evt)
 {
    event.returnValue=false;
    return false;
 }
 
function gfi_ValidateNumSpace(field,tags) 
{
	// This function verifies whether the value entered is a number or space
	// if it is not a number it will return false
	var FieldValue;
	var FieldLength;
	var Onechar;

    trim(field);  
	FieldValue=field.value;
   	FieldLength=FieldValue.length;
 	Onechar=FieldValue.charAt(0);
	//to check each charecter lies in between the numbers and space.
	for(IntCount=0;IntCount<FieldLength; IntCount++)
	{
	   Onechar=FieldValue.charAt(IntCount);
	   if((Onechar<"0" || Onechar>"9") && Onechar != " ") 
		  {		  
		   alert(GetMultiMessage('MSGGERR1','',''));

		   // set the cursor to that field itself
            if(tags==null || tags=="")
			   { 
				 field.focus();	
			   }
			   else
			   {
			      tags+field.focus();
			   } 
		   return false;
	      }
	}        
 return true;
}

function gfi_ValidateAlphaSpace(field,strmess)
{     
	// Function to check fields that can have only alphabets and spaces
	// This won't allow you to enter special characters and numbers

	var FieldValue;         // variable to store value of the object
	var FieldLength;        // variable to store length of the value
	
	  
	FieldValue=field[0].value;			// store the value of the object to the variable
    FieldLength=FieldValue.length;  // store the length of the value to the variable
 	var iChars =" ";
 	
	
	//to check each charecter lies in between the alphabets and Space.
	for(IntCount=0;IntCount<FieldLength; IntCount++) 
		{   
	        // extract the characters one by one from the value
			//check whether the character is alphabet
			
			if (iChars.indexOf(FieldValue.charAt(IntCount)) != -1)    
			 {
			 
		       alert(GetMultiMessage('MSGGERR7','',''));
              field.focus();	
 		       return false;
			 }
		}        
  return true;
}    

function ValidateNumbers(field)
{     
        var FieldValue;         // variable to store value of the object
	    var FieldLength;        // variable to store length of the value		
	    var dig = "0123456789@#$%&*()!^<>";
	    
	    FieldValue=field.value;			// store the value of the object to the variable
        FieldLength=FieldValue.length;  // store the length of the value to the variable
	    
        for(var i=0;i<FieldLength;i++)
        {             
	        if(dig.indexOf(FieldValue.charAt(i)) != -1)  
	        {
                alert(GetMultiMessage('MSG180','',''));
                field.focus();
                return false;
            }
       }
       return true;
  }			
    
// fuction to validaate phone number - allows numbers,(,),- and spaces only.
function gfi_ValidatePhoneNumber(field,label,tags)
{
// This function verifies whether the value entered is a number or space
// if it is not a number it will return false
//	0116:- $1 is invalid
	var FieldValue;
	var FieldLength;
	var Onechar;

    LTrim(field[0]);    
	FieldValue=field[0].value;
   	FieldLength=FieldValue.length;
 	
   		for(IntCount=0;IntCount<FieldLength; IntCount++) {
	   Onechar=FieldValue.charAt(IntCount);
	    if((Onechar<"0" || Onechar>"9") && (Onechar != "+") && (Onechar != "-") && (Onechar != "(") && (Onechar != ")")&& (Onechar != "."))
	     {
		   var msg=GetMultiMessage('0116',GetMultiMessage(label,'',''),'');
		   alert(msg );
				 
	   		   // set the cursor to that field itself
				  if(tags==null || tags=="")
				   { 
					 field.focus();	
				   }
				   else
				   {
					  tags+field.focus();
				   } 
		 return false;
	   }
	}        
	
	return true;
}

function gfb_ValidateAlphabets(ctrlText,mess) 
{
if(ctrlText!=undefined)
{
       LTrim(ctrlText[0]);
       var val = ctrlText[0].value;
    
      if(val != undefined)
      { 
          var val_Length=ctrlText[0].value.length;
          
          for(i=0;i<val_Length;i++)
          { 
                var iChars = ";=&\\\'\"" ; //"&='\\""?";
               if (iChars.indexOf(val.charAt(i)) != -1)    
                {     
                  var msg=GetMultiMessage('0012',GetMultiMessage(mess,'',''),'');
                  alert(msg); 
                  ctrlText.focus();
                  return false;
                }
         }
         return true;     
     }
}
else
{
    return true;
}
     
     
}


//Date :- 24-AUG-2009; Validation for Special Characters
function ValidateAlphabets(ctrlText,mess) 
{
if(ctrlText!=undefined)
{
       LTrim(ctrlText[0]);
      var val=ctrlText[0].value;
    
      if(val != undefined)
      { 
          var val_Length=ctrlText[0].value.length;
          
          for(i=0;i<val_Length;i++)
          { 
                var iChars = "<>;=&\\\'\"" ; //"&='\\""?";
               if (iChars.indexOf(val.charAt(i)) != -1)    
                {     
                  var msg=GetMultiMessage('0012',GetMultiMessage(mess,'',''),'');
                  alert(msg); 
                  ctrlText[0].focus();
                  return false;
                }
         }
         return true;     
     }
     }
     else
     {
        return true;
     }
     
     
}


function gfb_ValidateDescriptionAlphabets(ctrlText,mess) 
{
if(ctrlText!=undefined)
{
       LTrim(ctrlText[0]);
      var val=ctrlText.value;
    
      if(val != undefined)
      { 
          var val_Length=ctrlText.value.length;
          
          for(i=0;i<val_Length;i++)
          { 
                var iChars = ";=&\\\'\"" ; //"&='\\""?";
               if (iChars.indexOf(val.charAt(i)) != -1)    
                {     
                  var msg=GetMultiMessage('0012',GetMultiMessage(mess,'',''),'');
                  alert(msg); 
                  ctrlText.focus();
                  return false;
                }
         }
         return true;     
     }
     }
     else
     {
        return true;
     }
     
     
}

function gfi_ValidateEmail(field)
{
//0116:- $1 is invalid
    //0121:-Email Address 
    field = field[0];
  trim(field);  
  	var flag=true;
  	 var msg=GetMultiMessage('0116',GetMultiMessage('0121','',''),'');
	if(field.value=="" || field == null || field.length==0)
	{
	}
	else
	{
	  
        flag = false;
		if(field.value.charAt(0) ==" " || field.value.charAt(0)=="-")
    	{
			alert(msg);
			field.focus();
			return false;
	    }
		else
        {
			if(field != "")
        	{     
				var len = field.value.length;
			    var i;
				for(i=0;i<=len;i++)
				{
					if(field.value.substring(i,i+1)==" ")
					{
						
						alert(msg);
						field.focus();
						return false;
			        }
				}
	         var a1 = field.value.indexOf("@",0);
             var a2 = field.value.indexOf(".",0);
                             	
		    	if(a2==a1+1)
				{
					
						alert(msg);
					field.focus();
					return false;
                }  
		    	if(a1==-1 || a1==0)
				{
					
						alert(msg);
					field.focus();
					return false;
                }  
                                
				if(a1==field.value.length-1)
				{
					
						alert(msg);
					field.focus();
					return false;
				}
				if(a2==-1 || a2==0)
				{
					alert(msg);
					field.focus();
					return false;
				}
				if(a2 == len-1)
				{
					
						alert(msg);
					field.focus();
					return false;
				}
				if(a1 == len-1)
				{
					alert(msg);
					field.focus();
					return false;
				}

				if ((a2 == len-2) || (a2 == len-5))
				{
					alert(msg);
					field.focus();
					return false;
				}
				var ats=0;
				for(i=0;i<=len;i++)
                {       
                	var ch = field.value.substring(i,i+1);
					if(ch=="@")
					ats++;
					if(ats > 1)
					{
						alert(msg);
						field.focus();
						return false;
					}
																		
													
	               if(ch=="!"||ch=="#"||ch=="$"||ch=="%"||ch=="^"||ch=="&"||ch=="*"|| ch=="'" ||ch=='"' ||
	 					ch=="("||ch==")"||ch=="+"||ch=="="||ch=="|" || ch== ">" ||ch=="<"||ch=="?"||ch=="/"
						||ch==":"||ch==";"||ch=="["||ch=="]"||ch=="{"||ch=="}"||ch=="\\"||ch==",")
					{
				 	    alert(msg);
						field.focus();
						return false;
					}
					
				}
				var trs=0;
				var indexLen = field.value.indexOf("@",0);
//				for(i=indexLen+1;i<=len;i++)
//                {       
//                	var ch = field.value.substring(i,i+1);
//					if(ch==".")
//					trs++;
//					if(trs > 1)
//					{
//						alert(msg);
//						field.focus();
//						return false;
//					}
//				}
			}		
		}
	}
  return true;
}

function gfi_ValidateDriverEmail(field)
{
//0116:- $1 is invalid
//0121:-Email Address 
  trim(field);  
  	var flag=true;
  	 var msg=GetMultiMessage('0116',GetMultiMessage('0121','',''),'');
	if(field.value=="" || field == null || field.length==0)
	{
	}
	else
	{
	  
        flag = false;
		if(field.value.charAt(0) ==" " || field.value.charAt(0)=="-")
    	{
			alert(msg);
			field.focus();
			return false;
	    }
		else
        {
			if(field != "")
        	{     
				var len = field.value.length;
			    var i;
				for(i=0;i<=len;i++)
				{
					if(field.value.substring(i,i+1)==" ")
					{
						alert(msg);
						field.focus();
						return false;
			        }
				}
	         var a1 = field.value.indexOf("@",0);
             var a2 = field.value.indexOf(".",0);
                             	
		    	if(a2==a1+1)
				{
					alert(msg);
					field.focus();
					return false;
                }  
		    	if(a1==-1 || a1==0)
				{
					alert(msg);
					field.focus();
					return false;
                }  
                                
				if(a1==field.value.length-1)
				{
					alert(msg);
					field.focus();
					return false;
				}
				if(a2==-1 || a2==0)
				{
					alert(msg);
					field.focus();
					return false;
				}
				if(a2 == len-1)
				{
					alert(msg);
					field.focus();
					return false;
				}
				if(a1 == len-1)
				{
					alert(msg);
					field.focus();
					return false;
				}

				if ((a2 == len-2) || (a2 == len-5))
				{
					alert(msg);
					field.focus();
					return false;
				}
				var ats=0;
				for(i=0;i<=len;i++)
                {       
                	var ch = field.value.substring(i,i+1);
					if(ch=="@")
					ats++;
					if(ats > 1)
					{
						alert(msg);
						field.focus();
						return false;
					}
																		
													
	               if(ch=="!"||ch=="#"||ch=="$"||ch=="%"||ch=="^"||ch=="&"||ch=="*"|| ch=="'" ||ch=='"' ||
	 					ch=="("||ch==")"||ch=="+"||ch=="="||ch=="|" || ch== ">" ||ch=="<"||ch=="?"||ch=="/"
						||ch==":"||ch==";"||ch=="["||ch=="]"||ch=="{"||ch=="}"||ch=="\\"||ch==",")
					{
				 	    alert(msg);
						field.focus();
						return false;
					}
					
				}				
			}		
		}
	}
  return true;
}

function gfi_ValidateNumDot(field)
{

//0162:-Decimal should contain only one decimal point
    // This function verifies whether the value entered contains numbers and dots.
    field = field[0];
          var FieldValue;
   var FieldLength;
   var Onechar;
   var dotcount=0;
        trim(field);
   FieldValue=field.value;
      FieldLength=FieldValue.length;

    Onechar=FieldValue.charAt(0);
   //to check each charecter lies in between the numbers and dots.
   for(IntCount=0;IntCount<FieldLength; IntCount++)
   {
      Onechar=FieldValue.charAt(IntCount);
      if((Onechar<"0" || Onechar>"9") && Onechar != "." && Onechar!="," && Onechar!=" ")
         {
              if(field.id == 'txtMileage')
                alert(GetMultiMessage('MSGGERR15','',''));
              else
                alert(GetMultiMessage('MSGGERR11','',''));
              field.focus();                  // set the cursor to that field itself
              return false;
         }
       if(Onechar == ".")
          {
          dotcount=dotcount+1
          }
   }
      if (dotcount>1)
     {
      var msg=GetMultiMessage('0162','','');
      alert(msg);
       field.focus();                  // set the cursor to that field itself
       return false;            
        }
   return true;
}

 function LTrim(Text1)
 {
 var i=0;  
 
 var text = Text1.value;  
 if(text !=undefined)
{
   while(text.charAt(i)==' ')
   {   
     if((i==0) && (text.length==1))
      {
       text="";
      }
     else
      {
       text=text.substring(1,text.length);       
      }               
   } 
 Text1.value=text; 
 }
 return Text1;
 } 

function RTrim(Text1)
 {
 var i=0;   
 var text=Text1.value;
  while(text.charAt(text.length-1)==' ')
   {
    if(((text.length-1)==0) && (text.length==1))
     {
      text="";
     }
    else
     {
      text=text.substring(0,text.length-1);       
     }
   }
Text1.value=text
return Text1;
 }

 
function trim(text)
 { 
  text=RTrim(LTrim(text));  
 }
 

 function gfi_ValidateAlphaNumeric(field,tags) {

	
	var FieldValue;         // variable to store value of the object
	var FieldLength;        // variable to store length of the value
	var Onechar;			// variable to store one character from the value
	
	trim(field);  
	FieldValue=field.value;			// store the value of the object to the variable
   	FieldLength=FieldValue.length;  // store the length of the value to the variable
 	Onechar=FieldValue.charAt(0);	// store the first character of the value in the variable
	 var iChars = "!@#$%^&*()+=[]\\\';,/{}|\":<>?";
	for(IntCount=0;IntCount<FieldLength; IntCount++) 
		{   
			 if (iChars.indexOf(FieldValue.charAt(IntCount)) != -1)  
			{
				 alert(GetMultiMessage('MSGGERR2','',''));
				  if(tags==null || tags=="")
				   { 
					 field.focus();	
				   }
				   else
				   {
					  tags+field.focus();
				   } 
				 return false;
			}
		}        
  return true;
}


function gfi_ValidateSingleQuote(field)
{     
	// Function to check fields that can have only alphabets and spaces
	// This won't allow you to enter special characters and numbers

	var FieldValue;         // variable to store value of the object
	var FieldLength;        // variable to store length of the value
	var Onechar;			// variable to store one character from the value

	trim(field);  
	FieldValue=field.value;			// store the value of the object to the variable
    FieldLength=FieldValue.length;  // store the length of the value to the variable
 	Onechar=FieldValue.charAt(0);	// store the first character of the value in the variable
	
	//to check each charecter lies in between the alphabets and Space.
	for(IntCount=0;IntCount<FieldLength; IntCount++) 
		{   
	       Onechar=FieldValue.charAt(IntCount);  // extract the characters one by one from the value
			//check whether the character is alphabet
			if(Onechar == "'") 
			 {
		       alert(GetMultiMessage('MSGGERR14','',''));
               field.focus();	
 		       return false;
			 }
		}        
  return true;
}     


     function isitFutureDate(field,label)
     {

            var dateString=field.value
            var now = new Date();
            var today = new Date(now.getYear(),now.getMonth(),now.getDate());
            var testdate = new Date(dateString.substring(6,10),dateString.substring(3,5),dateString.substring(0,2)-1);
                  if (now >testdate) 
                     return true;
                  else
                    {
                        alert(label + GetMultiMessage('MSG181','',''));
                      field.focus();
                      return false;
                    }  
        }
	                
function slashtext(obj,obj1,yyFormat)
{
    if(obj.value == "")
    {
        return true;
    }
    
    var date=getDateFromFormat(obj.value,yyFormat);
	if (date==0)
	{
	        var objArray = new Array();
            objArray = obj.value.split('');
            
            var tempObj = '';
            for(var ct = 0; ct <= objArray.length - 1; ct++)
            {
                if(objArray[ct] <= 9 && objArray[ct] >= 0)
                {
                    tempObj = tempObj + objArray[ct];
                }
            }
            
            if(tempObj.length == 4)
            {
                var thisyear=new Date();
                obj.value = tempObj + thisyear.getFullYear();
            }
            else if(tempObj.length == 3)
            {
                var dd1,mm1;
                dd1 = tempObj.substring(0,2);
	            mm1 = tempObj.substring(2,4); 
	            if(mm1.length==1){mm1="0" + mm1;}	            
	            tempObj = dd1 + mm1;
	            var thisyear=new Date();
                obj.value = tempObj + thisyear.getFullYear();
            }
            else if(tempObj.length == 6 || tempObj.length == 8)
            {
                obj.value = tempObj;
            }
	        obj.value = getFullDate(obj.value,obj1,yyFormat);	    
	        if(obj.value != "false")
	        {
	            if (obj1 != null)              
                {
                    if(obj1.value.length == 0)
                    obj1.value = obj.value; 
                }
	            return true; 
	        }
	        else
	        {
	            obj.value = "";
	            return false;
	        }
	}
	else
	{
	    if (obj1 != null)              
        {
            if(obj1.value.length == 0)
            obj1.value = obj.value; 
         }	    
	    return true;
	}
}


function getDateFromFormat(val,format) 
{
	val=val+"";
	format=format+"";
	var i_val=0;
	var i_format=0;
	var c="";
	var token="";
	var token2="";
	var x,y;
	var now=new Date();
	var year=now.getYear();
	var month=now.getMonth()+1;
	var date=1;
	var hh=now.getHours();
	var mm=now.getMinutes();
	var ss=now.getSeconds();
	var ampm="";
	
	while (i_format < format.length) 
	{
		// Get next token from format string
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) 
		{
			token += format.charAt(i_format++);
		}
		// Extract contents of value based on format token
		if (token=="yyyy" || token=="yy" || token=="y" || token=="Y" || token=="YY" || token=="YYYY") 
		{
			if (token=="yyyy" || token=="YYYY") 
			{ 
			    x=4;y=4; 
			}
			if (token=="yy" || token=="YY")   
			{ 
			    x=2;y=2; 
			}
			if (token=="y" || token=="Y")    
			{ 
			    x=2;y=4; 
			}
			
			year=_getInt(val,i_val,x,y);
			
			if (year==null) 
			{ 
			    return 0; 
			}
			i_val += year.length;
			if (year.length==2) 
			{
				if (year > 70) 
				{ 
				    year=1900+(year-0); 
				}
				else 
				{ 
				    year=2000+(year-0); 
				}
			}
		}		
		else if (token=="mm"||token=="m") 
		{
			month=_getInt(val,i_val,token.length,2);
			if(month==null||(month<1)||(month>12)){return 0;}
			i_val+=month.length;
		}
		else if (token=="dd"||token=="d") 
		{
			date=_getInt(val,i_val,token.length,2);
			if(date==null||(date<1)||(date>31)){return 0;}
			i_val+=date.length;
		}		
		else 
		{
			if (val.substring(i_val,i_val+token.length)!=token) {return 0;}
			else {i_val+=token.length;}
		}
	}
	// If there are any trailing characters left in the value, it doesn't match
	if (i_val != val.length) { return 0; }
	// Is date valid for month?
	if (month==2) 
	{
		// Check for leap year
		if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
			if (date > 29){ return 0; }
	}
		else { if (date > 28) { return 0; } }
		}
	if ((month==4)||(month==6)||(month==9)||(month==11)) {
		if (date > 30) { return 0; }
		}	
	var newdate=new Date(year,month-1,date);
	return newdate;
}

function _getInt(str,i,minlength,maxlength) 
{
	for (var x=maxlength; x>=minlength; x--) 
	{
		var token=str.substring(i,i+x);
		if (token.length < minlength) { return null; }
		if (_isInteger(token)) { return token; }
	}
	return null;
}

function _isInteger(val) 
{
	var digits="1234567890";
	for (var i=0; i < val.length; i++) 
	{
		if (digits.indexOf(val.charAt(i))==-1) { return false; }
	}
	return true;
}

function getFullDate(val,obj1,format)
{   
    var count = 0;   
    var monthPosition = 0;
    var dayPosition = 0;
    var yearPosition = 0;
    var specialCount = 0;
    var specialChar = "";

    for(var i = 0; i < format.length; i++)
    {
        count = count + 1;
        switch (format.charAt(i)) 
        {
            case "M" :
			monthPosition = count - 2;
			break;
			
			case "d" : 
            dayPosition = count - 2;
            break;

            case "y" : 
                yearPosition = count - 2;
                break;
                
            default :
                specialChar = format.charAt(i);
                count = count - 1;
           }
      }
      
      if(specialChar.length == 0)
      {
        monthPosition = monthPosition + 2;
        dayPosition = dayPosition + 2;
      }
        var insertStr  = val;
        var strMonth, strDate, strYear; 
      
        var dtTemp = new Date();
        
      //var myRegExp = new RegExp(specialChar,"g"); 
      insertStr = insertStr.replace(specialChar, "");
      insertStr = insertStr.replace(specialChar, "");  


      if(monthPosition == 0)
      {
             strMonth = insertStr.substring(0, 2);
                strDate = insertStr.substring(2,4);
               
      }     
      if(dayPosition == 0)
      {
       
            strMonth = insertStr.substring(2,4);
            strDate = insertStr.substring(0,2);
       
      }
      if(yearPosition == 0 && format.length == 8)
      {
         if(monthPosition == 2)
         {
             strMonth = insertStr.substring(0, 2);
            strDate = insertStr.substring(2,4);
         } 
         else
         {
           strMonth = insertStr.substring(2,4);
            strDate = insertStr.substring(0,2);
         }
      } 
      if(yearPosition == 2 && format.length == 10)
      {
         if(monthPosition == 4)
         {
            strMonth = insertStr.substring(0, 2);
            strDate = insertStr.substring(2,4);
         } 
         else
         {
            strMonth = insertStr.substring(2,4);
            strDate = insertStr.substring(0,2);
         }
      }   
      
      if(strMonth==null||(strMonth<1)||(strMonth>12) || strMonth == "" || isNaN(strMonth))
      {
            alert(GetMultiMessage('MSGGERR8','',''));
            return false;
      }
      
       if (strMonth == 0)
	   {
 	        alert(GetMultiMessage('MSG182','','')); 		    
 		    return false;
 	    } 
 	    if(strDate > 31 || strDate < 1 || strDate =="" ||isNaN(strDate)==true)
		{ 
		      alert(GetMultiMessage('MSG184','',''));		     
		      return false;
		} 
	    if ((strMonth == 1)||(strMonth == 3)||(strMonth == 5)||(strMonth == 7)||(strMonth == 8)||(strMonth == 10)||(strMonth == 12))
        {
	        if (strDate > 31)
	        { 
	            alert(GetMultiMessage('MSG184','',''));      
                return false;
	        }
        }	
        if ((strMonth == 4)||(strMonth == 6)||(strMonth == 9)||(strMonth == 11))
 		{		
 		    if (strDate > 30)
 			{
 			    alert(GetMultiMessage('MSG184','','')); 			    
 			    return false;
 			}
 	    }

insertStr = insertStr.replace(strMonth, "");

insertStr = insertStr.replace(strDate, "");
strYear = insertStr;

 var fyear = ""
 fyear = dtTemp.getFullYear() + "";
 fyear = fyear.substring(0,2);
    
if(strYear.length == 2)
{   
    strYear = fyear + strYear;    
}
if(strYear.length == 1)
{
    strYear = fyear + "0" + strYear;
}

if( (strYear < 1900 && strYear.length == 4) || isNaN(strYear)==true )
{   
    alert(GetMultiMessage('MSG183','',''));    
    return false;
}

if(strMonth == 2)
{
    if (( (strYear % 4 == 0) && (strYear % 100 !=0)) || (strYear % 400 == 0))
 	{
 	    if (strDate > 29)
 		{
 		    alert(GetMultiMessage('MSG184','',''));
 			return false;
 		}
 	}
 	else
 	{
 	    if (strDate > 28)
 		{
 		    alert(GetMultiMessage('MSG184','',''));
 			return false;
 		}
 	}
}	
strMonth = strMonth - 1;
//var tempdate = new Date(strYear,strMonth,strDate)
var tempdate = new Date(strYear,strMonth,strDate)

return fnFormatDate(tempdate,format);

    	
}


function fnFormatDate(date,format) {
	format=format+"";
	var result="";
	var i_format=0;
	var c="";
	var token="";
	var y=date.getFullYear()+"";
	var M=date.getMonth() + 1;
	var d=date.getDate();
	var E=date.getDay();
	
	var yyyy,yy,MMM,MM,dd,mm;
	// Convert real date parts into formatted versions
	var value=new Object();
	if (y.length < 4) {y=""+(y-0+1900);}
	value["y"]=""+y;
	value["yyyy"]=y;
	value["YYYY"]=y;
	value["yy"]=y.substring(2,4);
	value["YY"]=y.substring(2,4);
	value["M"]=M;	
	value["d"]=d;
	value["dd"]=LZ(d);
	value["MM"]=LZ(M);
	value["mm"]=LZ(M);
	
		
	while (i_format < format.length) {
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) {
			token += format.charAt(i_format++);
			}
		if (value[token] != null) { result=result + value[token]; }
		else { result=result + token; }
		}
	return result;
	}



function fnValidateDate(val,format)
{ 
    var date=getDateFromFormat(val,format);
	if (date==0)
	{  
        var count = 0;   
        var monthPosition = 0;
        var dayPosition = 0;
        var yearPosition = 0;
        var specialCount = 0;
        var specialChar = "";

        for(var i = 0; i < format.length; i++)
        {
            count = count + 1;
            switch (format.charAt(i)) 
            {
                case "M" :
			    monthPosition = count - 2;
			    break;
    			
			    case "d" : 
                dayPosition = count - 2;
                break;

                case "y" : 
                    yearPosition = count - 2;
                    break;
                    
                default :
                    specialChar = format.charAt(i);
                    count = count - 1;
               }
          }
          
          if(specialChar.length == 0)
          {
            monthPosition = monthPosition + 2;
            dayPosition = dayPosition + 2;
          }
            var insertStr  = val;
            var strMonth, strDate, strYear; 
          
            var dtTemp = new Date();
            
          //var myRegExp = new RegExp(specialChar,"g"); 
          insertStr = insertStr.replace(specialChar, "");
          insertStr = insertStr.replace(specialChar, "");  


          if(monthPosition == 0)
          {
               if(yearPosition == 2 && format.length == 8)
                {        
                    strMonth = insertStr.substring(0, 2);
                    strDate = insertStr.substring(4,6);
                }
                else if(yearPosition == 4 && format.length == 10)
                {
                    strMonth = insertStr.substring(0, 2);
                    strDate = insertStr.substring(6,8);
                }
                else
                {
                    strMonth = insertStr.substring(0, 2);
                    strDate = insertStr.substring(2,4);
                }       
          }     
          if(dayPosition == 0)
          {
            if(yearPosition == 2 && format.length == 8)
            {        
                strMonth = insertStr.substring(4,6);
                strDate = insertStr.substring(0,2);
            }
            else if(yearPosition == 4 && format.length == 10)
            {
                strMonth = insertStr.substring(6,8);
                strDate = insertStr.substring(0,2);
            }
            else
            {
                strMonth = insertStr.substring(2,4);
                strDate = insertStr.substring(0,2);
            }
          }
          if(yearPosition == 0 && format.length == 8)
          {
             if(monthPosition == 2)
             {
                 strMonth = insertStr.substring(0, 2);
                strDate = insertStr.substring(2,4);
             } 
             else
             {
               strMonth = insertStr.substring(2,4);
                strDate = insertStr.substring(0,2);
             }
          } 
          if(yearPosition == 2 && format.length == 10)
          {
             if(monthPosition == 4)
             {
                strMonth = insertStr.substring(0, 2);
                strDate = insertStr.substring(2,4);
             } 
             else
             {
                strMonth = insertStr.substring(2,4);
                strDate = insertStr.substring(0,2);
             }
          }   
          
          if(strMonth==null||(strMonth<1)||(strMonth>12) || strMonth == "" || isNaN(strMonth))
          {
                alert(GetMultiMessage('MSG182','',''));
                return false;
          }
          
           if (strMonth == 0)
	       {
 	            alert(GetMultiMessage('MSG182','','')); 		    
 		        return false;
 	        } 
 	        if(strDate > 31 || strDate < 1 || strDate =="" ||isNaN(strDate)==true)
		    { 
		          alert(GetMultiMessage('MSG184','',''));		     
		          return false;
		    } 
	        if ((strMonth == 1)||(strMonth == 3)||(strMonth == 5)||(strMonth == 7)||(strMonth == 8)||(strMonth == 10)||(strMonth == 12))
            {
	            if (strDate > 31)
	            { 
	                alert(GetMultiMessage('MSG184','',''));      
                    return false;
	            }
            }	
            if ((strMonth == 4)||(strMonth == 6)||(strMonth == 9)||(strMonth == 11))
 		    {		
 		        if (strDate > 30)
 			    {
 			        alert(GetMultiMessage('MSG184','','')); 			    
 			        return false;
 			    }
 	        }

    insertStr = insertStr.replace(strMonth, "");

    insertStr = insertStr.replace(strDate, "");
    strYear = insertStr;

     var fyear = ""
     fyear = dtTemp.getFullYear() + "";
     fyear = fyear.substring(0,2);
        
    if(strYear.length == 2)
    {   
        strYear = fyear + strYear;    
    }
    if(strYear.length == 1)
    {
        strYear = fyear + "0" + strYear;
    }

    if( (strYear < 1900 && strYear.length == 4) || isNaN(strYear)==true )
    {   
        alert(GetMultiMessage('MSG183','',''));    
        return false;
    }

    if(strMonth == 2)
    {
        if (( (strYear % 4 == 0) && (strYear % 100 !=0)) || (strYear % 400 == 0))
 	    {
 	        if (strDate > 29)
 		    {
 		        alert(GetMultiMessage('MSG184','',''));
 			    return false;
 		    }
 	    }
 	    else
 	    {
 	        if (strDate > 28)
 		    {
 		        alert(GetMultiMessage('MSG184','',''));
 			    return false;
 		    }
 	    }
    }	
    strMonth = strMonth - 1;
    var tempdate = new Date(strYear,strMonth,strDate)

    return tempdate;
    }
    else
    {
        return date;
    }
    	
}

function gfi_ValidateFDate(field,label)
{ 
   val = field.value;
   
   val_Length = val.length;
   

	  if(val != "")
       {
         t1 = val.split("/");
         if (t1.length == 3) 
         {
          //To Check For Dot,Space,+,e,E In Date		
				for(i=0;i<val.length;i++)
				{ 
		      		  str=val.charCodeAt(i);
					   if((str == 46)||(str == 32)||(str == 45)||(str == 43)||(str == 69))
						{	  
						 alert(GetMultiMessage('MSGGERR8','',''));
						 field.focus();
						 return false; 
					    }
				}
         
          if (t1[2].length == 2)
             {
              t1[2]= "20" + t1[2];
              }
          if(t1[1] > 31 || t1[1] < 1 || t1[1]=="" ||isNaN(t1[1])==true)
		   { 
		  
		     alert(GetMultiMessage('MSGGERR8','',''));
		     field.focus();
		     return false;
	       } 
	      //check if the Month is valid  
		  else if(t1[0] > 12 || t1[0] < 1 || t1[0]=="" || isNaN(t1[0])==true)
			 {
			 
			  
		     alert(GetMultiMessage('MSGGERR8','',''));
		     field.focus();
		     return false;
		   } 
		    
	     //check if the year is valid 
		 else if( t1[2]<1900 || t1[2] >2100 ||t1[2]=="" || isNaN(t1[2])==true || t1[2].length < 2 || t1[2].length > 4 || t1[2] == 3)
		   {
		   
		
		     alert(GetMultiMessage('MSGGERR8','',''));
		     field.focus();
		     return false;
		   }
		 else if ((t1[0] == 1)||(t1[0] == 3)||(t1[0] == 5)||(t1[0] == 7)||(t1[0] == 8)||(t1[0] == 10)||(t1[0] == 12))
          {
    	//Check for 31 days in the month
			if (t1[1] > 31)
			{ 
			  alert(GetMultiMessage('MSGGERR8','',''));
		      field.focus();
		      return false;
			}
          }
        else if ((t1[0] == 4)||(t1[0] == 6)||(t1[0] == 9)||(t1[0] == 11))
		{
	   //Check for 30 days in the month
		  if (t1[1] >30)
		  {
		     alert(GetMultiMessage('MSGGERR8','',''));
		     field.focus();
		     return false;
		  }
		}
		else if(t1[0] == 2)
		{
	   //check for leap year
		  if (( (t1[2] % 4 == 0) && (t1[2] % 100 !=0)) || (t1[2] % 400 == 0))
		  {
		     if (t1[1] > 29)
		     {
		       alert(GetMultiMessage('MSGGERR8','',''));
		      field.focus();
		      return false;
		     }
		  }
		  else
		  {
		    if (t1[1] > 28)
		     {
		       alert(GetMultiMessage('MSGGERR8','',''));
		       field.focus();
		       return false;
		     }
		  }
	    }
	    
	       d=new Date();
		// to separete time from the new date.
		   d2= new Date(eval(d.getMonth()+1) + "/" + d.getDate() + "/" + d.getYear())
		   d1=new Date(t1[0]+"/"+t1[1]+"/"+t1[2])
				
		   if(d1 < d2)
            {
              alert(GetMultiMessage('MSGGERR9','','')); 
      	      field.focus();
      	      return false;
		    }
                   
        }
        else
        {
		   alert(GetMultiMessage('MSGGERR8','',''));
		   field.focus();
		   return false;
		}
	 }
	 else 
	 {
	   return true;
	 }
	 return true;       
    }
    
     function chklen(strCName)
    {
        var strCValue;
        var len;
	    strCValue=strCName.value;
	    len=strCValue.length;
	    if (len>0) 
	        return true;
	     else
	    return false;
	 }

function gfi_ValidateDateDiff(date1,date2)
{
    var mm2,dd2,yy2;
    var mm, dd, yy;
    var intNdx, intLastNdx, bReturn;
	var yourage, months;
	
	months=0;
	yourage=0.00;
    
    //First date split 
    intNdx = date1.indexOf('/', 0);
	intLastNdx = date1.indexOf('/', (intNdx + 1));
     
    //Get Day, Month, and Year
	dd = date1.substr(0, intNdx);
	mm= date1.substr(intNdx + 1, (intLastNdx -intNdx - 1));
	yy = date1.substr(intLastNdx + 1,(date1.length - intLastNdx));
	
	//Second date split 
	intNdx = date2.indexOf('/', 0);
	intLastNdx = date2.indexOf('/', (intNdx + 1));
   
    //Get Day, Month, and Year
	dd2 = date2.substr(0, intNdx);
	mm2 = date2.substr(intNdx + 1, (intLastNdx -intNdx - 1));
	yy2 = date2.substr(intLastNdx + 1,(date2.length - intLastNdx));
	mm2=parseInt(mm2) + parseInt(1);

    if (yy2 > yy) { yourage = yy2 - yy; }
    if (mm2 < mm)  { yourage = yourage - 1; months = parseInt(12) + parseInt(mm2);}
  
    if (mm == months)
       { 
         months=parseInt(months) - parseInt(mm);
       }
    else 
       {   
         alert(GetMultiMessage('MSG154','','') + months);
         if (parseInt(months) != 0) 
         { 
			  yourage = parseInt(yourage)  + ((parseInt(months) - parseInt(mm)) / parseInt(100));          
         }         
       }
       
    agestring = yourage + " ";
    return agestring;
}

function gf_existsTextValInCombo(combo,selVal)
{
      var pComLen=combo.length;
      var flag=false;
    for(var i=0;i<pComLen;i++)
    {
         if (selVal==combo.options[i].value)
         {
              combo.options[i].selected=true;
              flag=true;      
              break;
         }
    }
    return flag;
} 


function gfi_ValidatePrimary(field,tags) {

	// This function allows only Alphabets and Numbers to be entered as the value
	var FieldValue;         // variable to store value of the object
	var FieldLength;        // variable to store length of the value
	var Onechar;			// variable to store one character from the value
	
	trim(field);  
	FieldValue=field.value;			// store the value of the object to the variable
   	FieldLength=FieldValue.length;  // store the length of the value to the variable
 	Onechar=FieldValue.charAt(0);	// store the first character of the value in the variable
	
	for(IntCount=0;IntCount<FieldLength; IntCount++) 
		{   
			Onechar=FieldValue.charAt(IntCount);  // extract the characters one by one from the value
	    	//check whether the character is alphabet,space or a number
     	    if((Onechar<"a" || Onechar>"z") && (Onechar<"A" || Onechar>"Z") && (Onechar < "0" || Onechar > "9")) // && (Onechar!= "'"))
			{
				 alert(GetMultiMessage('MSGGERR3','',''));
	   		   // set the cursor to that field itself
				  if(tags==null || tags=="")
				   { 
					 field.focus();	
				   }
				   else
				   {
					  tags+field.focus();
				   } 
				 return false;
			}
		}        
  return true;
}

var SERR = new Array(25); // For Shared Error Messages
var GERR = new Array(25); // For General Error Messages
var AERR = new Array(25); // For Application related Error Messages

function displayerror(num,language)
{
    var msg=language+num;
    msg=eval(msg);
    alert(msg);
}


function displayerrorfield(num,language,mess)
{

    var msg=language+num;
    msg=eval(msg);
    var msgfield=language+mess;
    msgfield=eval(msgfield); 
    alert(msg + msgfield);
}

//Multilingual handling for Javascript alert messages
       var xmlDoc;
	   var strErrCode;
	   var param1;
	   var param2;
	   var Multimag='';
function Popup_alert(str,p1,p2) {
        param1 = p1;
        param2 = p2;
        strErrCode = str;
        var moz = (typeof document.implementation != 'undefined') && (typeof
        document.implementation.createDocument != 'undefined');
        var ie = (typeof window.ActiveXObject != 'undefined');

        if (moz) 
        {
            xmlDoc = document.implementation.createDocument("", "", null)
            xmlDoc.onload = ProcessXML;
            xmlDoc.load("../TempFile/JScriptErr.XML");
        } 
        else if (ie) 
        {

            xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
            xmlDoc.async = false;
            while(xmlDoc.readyState != 4) {};
            xmlDoc.load("../TempFile/JScriptErr.XML");
            var xmlObj = xmlDoc.getElementsByTagName("JSError");
            for(i=0;i<xmlObj.length;i++)
            {
                var str1 = xmlObj[i].childNodes[1].firstChild.nodeValue.toString();
                var re = /((\s*\S+)*)\s*/;
	            str1 = str1.replace(re, "$1");
                //alert(str1+"-" + str);
                if(str1 == str)
                {   
                    if(xmlObj[i].childNodes[6].firstChild==null)
                    {
                        var msg = xmlObj[i].childNodes[2].firstChild.nodeValue;
                        msg = msg.replace('$1',param1);
                        msg = msg.replace('$2',param2);
                        alert(msg);
                        return;
                    }
                    else
                    {
                        var msg = xmlObj[i].childNodes[6].firstChild.nodeValue;
                        msg =msg.replace("$1",param1);
                        msg = msg.replace('$2',param2)
                        alert(msg);
                        return
                    }
                }
            }
              alert(GetMultiMessage('MSGSERR15','',''));
        }
}

function ProcessXML()
{
var xmlObj = xmlDoc.getElementsByTagName('JSError');
             var Objlen = xmlDoc.getElementsByTagName('JSError').length;
             for(i=0;i<Objlen;i++)
            {
                var ErrCode = xmlObj[i].getElementsByTagName("ERR_ID");
                var ErrDesc = xmlObj[i].getElementsByTagName("DESC_NEW");
                var ErrDescEng = xmlObj[i].getElementsByTagName("ERR_DESC");
                var str1 = ErrCode[0].firstChild.nodeValue.toString();
                var re = /((\s*\S+)*)\s*/;
	            str1 = str1.replace(re, "$1");
	        
                if(str1 == strErrCode)
                {   
               
                    if(ErrDesc[0].firstChild==null)
                    {
                        var msg = ErrDescEng[0].firstChild.nodeValue;
                        msg =msg.replace("$1",param1);
                        msg = msg.replace('$2',param2);
                     Multimag=msg;
                        return;
                    }
                    else
                    {
                         var msg =ErrDesc[0].firstChild.nodeValue;
                         msg =msg.replace("$1",param1);
                         msg = msg.replace('$2',param2);
                          Multimag=msg;
                         return;
                    }
                }
            }
}

 function chklen(strCName)
    {
        var strCValue;
        var len;
	    strCValue=strCName.value;
	    len=strCValue.length;
	    if (len>0) 
	        return true;
	     else
	    return false;
	 }
	 
     var xmlDoc;
     var strErrCode;

function Confirmation(str) {
      strErrCode = str;
      var moz = (typeof document.implementation != 'undefined') && (typeof
      document.implementation.createDocument != 'undefined');
      var ie = (typeof window.ActiveXObject != 'undefined');

      if (moz)
      {
 var myXMLHTTPRequest = new XMLHttpRequest();
myXMLHTTPRequest.open("GET", "../TempFile/JScriptErr.XML", false);
myXMLHTTPRequest.send(null);
var myXMLDocument = myXMLHTTPRequest.responseXML;
var xmlObj = myXMLDocument.getElementsByTagName('JSError');
   var Objlen = myXMLDocument.getElementsByTagName('JSError').length;
 
  for(i=0;i<Objlen;i++)
  {
              var ErrCode = xmlObj[i].getElementsByTagName("ERR_ID");
              var ErrDesc = xmlObj[i].getElementsByTagName("DESC_NEW");
              var ErrDescEng = xmlObj[i].getElementsByTagName("ERR_DESC");
              var str1 = ErrCode[0].firstChild.nodeValue.toString();
              var re = /((\s*\S+)*)\s*/;
              str1 = str1.replace(re, "$1");
                             if(str1 == strErrCode)
              {
              if(ErrDesc[0].firstChild==null)
                  {
                      var msg = ErrDescEng[0].firstChild.nodeValue;
                        var result = window.confirm(msg);
                      return result;
                  }
                  else
                  {
                       var msg =ErrDesc[0].firstChild.nodeValue;
                       var result = window.confirm(msg);
                       return result;
                  }
                                            }
      }
                                           } 





      else if (ie)
      {

          xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
          xmlDoc.async = false;
          while(xmlDoc.readyState != 4) {};
          xmlDoc.load("../TempFile/JScriptErr.XML");
          var xmlObj = xmlDoc.getElementsByTagName("JSError");
          for(i=0;i<xmlObj.length;i++)
          {
              var str1 = xmlObj[i].childNodes[1].firstChild.nodeValue.toString();
              var re = /((\s*\S+)*)\s*/;
              str1 = str1.replace(re, "$1");
              if(str1 == str)
              {                     if(xmlObj[i].childNodes[6].firstChild==null)
                  {
                      var msg = xmlObj[i].childNodes[2].firstChild.nodeValue;
                      var result = window.confirm(msg);
                      return result;
                  }
                  else
                  {
                      var msg = xmlObj[i].childNodes[6].firstChild.nodeValue;
                       var result = window.confirm(msg);
                      return result;
                  }
              }
          }
                    alert(GetMultiMessage('MSGSERR15','',''));
      }

}

 function GetMultiMessage(strErr,p1,p2)
{
    var xmlErrDoc;
    var strErrCode1;
     param1 = p1;
     param2 = p2;
     strErrCode = strErr;

     var moz = (typeof document.implementation != 'undefined') && (typeof
     document.implementation.createDocument != 'undefined');
     var ie = (typeof window.ActiveXObject != 'undefined');

                   if (ie)
     {

         xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
         xmlDoc.async = false;
         while(xmlDoc.readyState != 4) {};
         xmlDoc.load("../TempFile/JScriptErr.XML");
                 var xmlObj = xmlDoc.getElementsByTagName("JSError");
                            for(i=0;i<xmlObj.length;i++)
         {
             var str1 = xmlObj[i].childNodes[1].firstChild.nodeValue.toString();
             var re = /((\s*\S+)*)\s*/;
             str1 = str1.replace(re, "$1");
             if(str1 == strErr)
             {                      if(xmlObj[i].childNodes[6].firstChild==null)
                 {
                     var msg = xmlObj[i].childNodes[2].firstChild.nodeValue;
                     msg = msg.replace('$1',param1);
                     msg = msg.replace('$2',param2);
                     return (msg) ;
                 }
                                    else
                 {
                     var msg = xmlObj[i].childNodes[6].firstChild.nodeValue;
                     msg =msg.replace('$1',param1);
                     msg = msg.replace('$2',param2);
                     return (msg);
                 }
             }
         }//end for
         return strErr;
   }
                    else if(moz)
                    {
        var myXMLHTTPRequest = new XMLHttpRequest();
        myXMLHTTPRequest.open("GET", "../TempFile/JScriptErr.XML", false);
        myXMLHTTPRequest.send(null);
        var myXMLDocument = myXMLHTTPRequest.responseXML;
       var xmlObj = myXMLDocument.getElementsByTagName('JSError');
       var Objlen = myXMLDocument.getElementsByTagName('JSError').length;
       for(i=0;i<Objlen;i++)
       {
       var ErrCode = xmlObj[i].getElementsByTagName("ERR_ID");
             var ErrDesc = xmlObj[i].getElementsByTagName("DESC_NEW");
             var ErrDescEng = xmlObj[i].getElementsByTagName("ERR_DESC");
             var stringmsg = ErrCode[0].firstChild.nodeValue.toString();
             var re = /((\s*\S+)*)\s*/;
             stringmsg = stringmsg.replace(re, "$1");
             if(stringmsg == strErrCode)
             {
                  if(ErrDesc[0].firstChild==null)
                  {
                                      msg = ErrDescEng[0].firstChild.nodeValue;
                   msg =msg.replace('$1',param1);
                  msg = msg.replace('$2',param2);
                                  return msg;               
                  }
                  else
                  {
                                      msg = ErrDesc[0].firstChild.nodeValue;
                   msg =msg.replace('$1',param1);
                  msg = msg.replace('$2',param2);
                  return msg;
                  }
             }
        }
        return strErrCode;

   }
}
function ConfProcessXML()
{
var xmlObj = xmlDoc.getElementsByTagName('JSError');
             var Objlen = xmlDoc.getElementsByTagName('JSError').length;
             for(i=0;i<Objlen;i++)
            {
                var ErrCode = xmlObj[i].getElementsByTagName("ERR_ID");
                var ErrDesc = xmlObj[i].getElementsByTagName("DESC_NEW");
                var ErrDescEng = xmlObj[i].getElementsByTagName("ERR_DESC");
                var str1 = ErrCode[0].firstChild.nodeValue.toString();
                var re = /((\s*\S+)*)\s*/;
	            str1 = str1.replace(re, "$1");
                if(str1 == strErrCode)
                {   
                    if(ErrDesc[0].firstChild==null)
                    {
                        var msg = ErrDescEng[0].firstChild.nodeValue;
                        var result = window.confirm(msg); 
                        return result;
                    }
                    else
                    {
                         var msg =ErrDesc[0].firstChild.nodeValue;
                         var result = window.confirm(msg);
                         return result;
                    }
                }
            }
             alert(GetMultiMessage('MSGSERR15','',''));
}



// Left menu - The function to high ligh the selected left menu and navigate the requested page

function SetURL(Input)
{
	var GetAnchorParent=Input.parentNode;
	var liListItemID=GetAnchorParent.id;
	var ulUnorderList=Input.parentNode.parentNode;
	var ulUnorderListID=ulUnorderList.id;
	Input.href=Input.href+'?AnchrID='+ Input.id+'&liListItemID='+liListItemID+'&ulUnorderListID='+ulUnorderListID;
}

function ConfirmFun(msg)
{
	var x;
	
	msg=GetMultiMessage(msg,'','');
	
	x=confirm(msg);
	if (x)
		return true;
	else
		return false;
	
}

function ChkFormDataChange(thisForm) 
{
/*

0242:-Do you want to proceed with unsaved information in this page?
*/
    var result = true;
    var output = '';
    var tempmsg;
    if(thisForm!=undefined)
    {
    for (var i=0, j=thisForm.elements.length; i<j; i++) {
        myType = thisForm.elements[i].type;
        if (myType == 'file') 
        {
		  if (thisForm.elements[i].value != thisForm.elements[i].defaultValue) 
            {
                output += thisForm.elements[i].name + ' still equals "' + thisForm.elements[i].defaultValue + '"' + '\n';
                result = false;
            }
        }
        
        if (myType == 'checkbox' || myType == 'radio') 
        {
            if (thisForm.elements[i].checked !=thisForm.elements[i].defaultChecked) 
            {
                output += thisForm.elements[i].name + ' is still checked' + '\n';
                result = false ;
                tempmsg=thisForm.elements[i].name + ' is still checked';
            }
        }
        
         if (myType == 'password' || myType == 'text' || myType == 'textarea') 
        {
            if (thisForm.elements[i].value != thisForm.elements[i].defaultValue) 
            {
                output += thisForm.elements[i].name + ' still equals "' + thisForm.elements[i].defaultValue + '"' + '\n';
                result = false;
            }
        }
        if (myType == 'select-one' || myType == 'select-multiple') {
            for (var k=0, l=thisForm.elements[i].options.length; k<l; k++) {
                if (!thisForm.elements[i].options[k].selected && thisForm.elements[i].options[k].defaultSelected) {
                    output += thisForm.elements[i].name + ' option ' + k + ' is still selected' + '\n';
                    
                    result = false;
                }
            }
        }
    }
    }
    else
    {
        result= true;
    }
                if(result==false)
                {
                  var res; 
                   var msg=GetMultiMessage('0242','','');
                    res = confirm(msg); 
                    if  (res == false)   
                    { 
                   
                    result=false;
                       }
                    else 
                    {           
                       result= true;
                     }

                 }
        return result;
}

function chk_DefVal_FromTabs(thisForm)
{
	var RetVal;
	RetVal=ChkFormDataChange(thisForm);
		
    if (RetVal==false)
    {
		var tempmsg;
	    tempmsg='There are some unsaved information in this page' +'\n Click "OK" to stay in the same page'+'\n or else click "Cancel"';
	     
        if (ConfirmFun(tempmsg))
        {
             return true;
             }
        else 
        {
                
			return false;
		}
    }
    
}

function chk_DefVal_FromLeftMenu(thisForm,Input)
{
	var RetVal;
	
	RetVal=ChkFormDataChange(thisForm);
	
    if (RetVal==false)
    {
		var tempmsg;
	    tempmsg='There are some unsaved information in this page' +'\n Click "OK" to stay in the same page'+'\n or else click "Cancel"';
	     
        if (ConfirmFun(tempmsg))
             return true
        else 
			{
				SetURL(Input);
				return false;
			}
				
		
    }
}

     function UnCheck(chkA,chkD,v,formname)
    {	

	    var chk=false;
	    for (var i=0;i<document.forms[formname].length;i++)
	    {
		    e=document.forms[formname].elements[i];
		    if ( e.type.indexOf('checkbox')!= -1 && e.name.indexOf(chkD) != -1 )
			    if(document.forms[formname].elements[i].checked==false)
				    chk=true;
	    }
	    for (var i=0;i<document.forms[formname].length;i++)
	    {
		    e=document.forms[formname].elements[i];
		    if ( e.type.indexOf('checkbox')!= -1 && e.name.indexOf(chkA) != -1 )
			    if(chk)
				    document.forms[formname].elements[i].checked=false;
			    else
				    document.forms[formname].elements[i].checked=true;
	    }
    }
    
function CheckAll(chkD,v,formname)
    {
        for (var i=0;i<document.forms[formname].length;i++)
        {
	        e=document.forms[formname].elements[i];
	        if (e.type.indexOf('checkbox')!= -1 && e.name.indexOf(chkD) != -1 )
	        {
	            if(document.forms[formname].elements[i].disabled==false)
	                      document.forms[formname].elements[i].checked=v;
	        }
        }	      
    }		



 function DeleteCheck(chkD,grd,formname)
    {
        
	    var checkedProd=0;
	    for (var i=0;i<document.forms[formname].length;i++)
	    {
		    e=document.forms[formname].elements[i];
		    if ( e.type.indexOf('checkbox')!= -1 && e.name.indexOf(chkD) != -1 )
			    if(document.forms[formname].elements[i].checked)
				    checkedProd++;		 
	    }
	    if(checkedProd==0)
	    {
		    var msg=GetMultiMessage(grd,'','')
		    msg=GetMultiMessage('0123',msg,'')
		    alert(msg);
		    
		    return false;
	    }
	    else
	            
	            var msg=GetMultiMessage('0016','','')
		      if (window.confirm(msg) == false)
			    return false;	
			    
			    window.scrollTo(0,0);
    }
    
     function CopyCheck(chkD,grd,formname)
   {
        

       var checkedProd=0;
       for (var i=0;i<document.forms[formname].length;i++)
       {
           e=document.forms[formname].elements[i];
           if ( e.type.indexOf('checkbox')!= -1 && e.name.indexOf(chkD) != -1 )
               if(document.forms[formname].elements[i].checked)
                   checkedProd++;                        
       }
        if(checkedProd==0)
	    {
		     var msg=GetMultiMessage(grd,'','')
		    msg=GetMultiMessage('0124',msg,'')
		    alert(msg);
		    return false;
	    }
       if(checkedProd > 1)
       {
            var msg=GetMultiMessage(grd,'','')
		    msg=GetMultiMessage('0125',msg,'')
		    alert(msg);
           
           return false;
       } 
                       
       return true;

   }       
    
function funyear(obj)
        {        
        var yy1=obj.value;       
        if(!(gfi_ValidateNumber(obj,'Year')))
                {
                    return false;
                } 
                else
                {
        if ( yy1<1600 || yy1.length>4 || yy1>2500 || yy1.length<=1)
	                               {
            	                            
	                                      var msg=GetMultiMessage('MSG045','','');
	                                      alert(msg);	                                      
		                                  obj.value=""; 
		                                  obj.focus(); 
			                              return false;
	                               }
	            }                   
        }	
        
        
function focusJS(obj)
{
    var val=document.getElementById(obj);
    if(val!=null)
    {
        if (val.type != 'select-one')
        {
            val.focus();
            val.select();
        }
        else 
            val.focus();
   }    
           return;
}
function gfb_ValidateNumbers(ctrlText) 
 {
	var val=ctrlText.value;
	var val_Length=ctrlText.value.length;
	if(isNaN(val) || (val < 0))
    {
    
   
	msg=GetMultiMessage('0090','','')
	    alert(msg);
		ctrlText.focus();
		ctrlText.value="";
		return false;
	}
	for(i=0;i<val_Length;i++)
	{ 
		str=val.charCodeAt(i);
		if((str == 46)||(str == 101)||(str == 32)||(str == 45)||(str == 43))
		{	  
			alert(GetMultiMessage('MSGGERR1','',''));
			ctrlText.value="";
			ctrlText.focus();
			return false;
		}
	}
	return true;
}

function gfi_ValidateNumber(field,tags) 
{
	// This function verifies whether the value entered contains numbers.	
    field = field[0];
	var FieldValue;
	var FieldLength;
	var Onechar;
	
    trim(field);
	FieldValue=field.value;
   	FieldLength=FieldValue.length;
 	Onechar=FieldValue.charAt(0);
	//to check each charecter lies in between the numbers.
	for(IntCount=0;IntCount<FieldLength; IntCount++)
	{
	   Onechar=FieldValue.charAt(IntCount);
	   if(Onechar<"0" || Onechar>"9" )
	   	  {
			  var msg=GetMultiMessage(tags,'','')
			   msg=GetMultiMessage('0090',msg,'')
		        alert(msg);
			 
	   		   // set the cursor to that field itself
				  if(tags==null || tags=="")
				   { 
					 field.focus();	
				   }
				   else
				   {
					  tags+field.focus();
				   } 
		   return false;
	      }
	}        
 return true;
}

function gfi_ValidNumber(field) {
    // This function verifies whether the value entered contains numbers.	
    //field = field[0];
    var FieldValue;
    var FieldLength;
    var Onechar;

    //trim(field);
    FieldValue = field;
    FieldLength = FieldValue.length;
    Onechar = FieldValue.charAt(0);
    //to check each charecter lies in between the numbers.
    for (IntCount = 0; IntCount < FieldLength; IntCount++) {
        Onechar = FieldValue.charAt(IntCount);
        if (Onechar < "0" || Onechar > "9") {
            alert('Rab Column should be integer only.');
            return false;
        }
    }
    return true;
}





function gfi_ValidateDecimalLength(field,fldprecision,fldscale) 
{
  // This function verifies whether the value entered contains numbers and dots.
  // Written By Rajput Yogendrasinh H to fix bugs  29, 74, 617, 621
  
  /*
  0239:-Precision length is greater than allowed.
  0240:-Fraction part length is greater than allowed.
  0241:-Precision length is greater than allowed.
  
  */
  
    var regPre = "^\\d{0,"+fldprecision+"}$" // Check for Precision Length
    var regNoDot ="^\\d{0,"+fldprecision+"}\\.{0,0}$" //Check for No Dot
    var reS = "^\\d{0,"+fldprecision+"}\\(.|,){1,1}\\d{1,"+fldscale+"}$"; //
    var reFrac = "^\\d*\\(.|,){1,1}\\d{1,"+fldscale+"}$";
    var FieldValue="";
    var msg;
    FieldValue=field;

    if (fldscale==0 )
    {
         if( !FieldValue.match(regPre)) 
            {
                var msg=GetMultiMessage('0239','','');
                alert(msg);
                return false;
            }
    }
    else
    {
        if( !FieldValue.match(regPre)) 
        {
            if(FieldValue.match(regNoDot))
            {
                 var msg=GetMultiMessage('0239','','');
                 alert(msg);
                return false;
            }
        else if(!FieldValue.match(reS)) 
        {
            if(!FieldValue.match(reFrac)) 
            {
                field.value="";	
                msg=GetMultiMessage('0240','','');
                 alert(msg);
                 return false;
            } 
            else 
            {
                var msg=GetMultiMessage('0241','','');
                alert(msg);
            }
            return false;
        }
        }
        return true;
    
    }
    return true;
}


  function IsValidTime(timeStr) {    
         
           var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;

           var matchArray = timeStr.match(timePat);
           
           if (matchArray == null) {
           alert(GetMultiMessage('MSG013','',''));
           return false;
           }
           hour = matchArray[1];
           minute = matchArray[2];
           second = matchArray[4];
           ampm = matchArray[6];

           if (second=="") { second = null; }
           if (ampm=="") { ampm = null }

           if (hour < 0  || hour > 23) {
           alert(GetMultiMessage('MSG011','',''));
           return false;
           }

           if  (hour > 12 && ampm != null) {
           var msg = GetMultiMessage('MSG138','','');
            alert(msg);
           return false;
           }
           if (minute<0 || minute > 59) {
           alert(GetMultiMessage('MSG164','',''));           
           return false;
           }
           if (second != null && (second < 0 || second > 59)) {
           alert(GetMultiMessage('VALIDSEC','',''));    
           return false;
           }
           return true;
           }           

function val_Date(ctrlText,dtFormat)
{ 
	val = ctrlText.value;

	var Date=0;
	var Month=1;
	var Year=2;
	var OrigFormat,FSplit;
	var YearLength=4;
	var isMName=false;

    OrigFormat=dtFormat;

	var  Format=OrigFormat.toUpperCase();
	// Split the date by / Seperated
	var FSplit=Format.split("/");
    val_Length = val.length;
	if(val != "")
	    {
			t1 = val.split("/");
			if (t1.length == 3) 
			{
			//To Check For Dot,Space,+,e In Date		
 					for(i=0;i<val.length;i++)
 					{ 
 	      				str=val.charCodeAt(i);
 						 if((str == 46)||(str == 32)||(str == 45)||(str == 43))
	 					{	  // 0349 - Enter A Valid Date
	 					var msg=GetMultiMessage('0349','','');
                            alert(msg);
 						
 							ctrlText.focus(); 							
 							return false; 
	 				    }
 					}
 		    
			if (FSplit[0]=="DD")
			{
				Date=0;
				if ((FSplit[1]=="MM") || (FSplit[1]=="MMM"))
					{
					 Month=1;
					 Year=2;
					 
					 if (FSplit[1]=="MMM") {isMName=true;} else {isMName=false;}
					 if (FSplit[2]=="YY") {YearLength=2;}
					 else if (FSplit[2]=="YYYY") {YearLength=4;}
					 }
				if (FSplit[1]=="YY") 
					{
					Month=2;
					Year=1;
					YearLength=2
					 if (FSplit[2]=="MMM") {isMName=true;} else {isMName=false;}
					}
				if (FSplit[1]=="YYYY")
				 {
				  Month=2;
				  Year=1;
				  YearLength=4
  				 if (FSplit[2]=="MMM") {isMName=true;} else {isMName=false;}

				  }
			}
			else if ((FSplit[0]=="MM") || (FSplit[0]=="MMM"))
			{
				Month=0;
				if (FSplit[0]=="MMM") {isMName=true;} else {isMName=false;}
				if (FSplit[1]=="DD")
					 {
					  Date=1;
					  Year=2;
  	  				  if (FSplit[2]=="YY") { YearLength=2;} else {YearLength=4;}
					 }
				if (FSplit[1]=="YY") {Date=2;Year=1; YearLength=2}
				if (FSplit[1]=="YYYY") { Date=2;Year=1; YearLength=4}

			}	
			else if ((FSplit[0]=="YY") || (FSplit[0]=="YYYY"))
			{
				Year=0;
				if (FSplit[0]=="YY") { YearLength=2;} else {YearLength=4;}
				
				if (FSplit[1]=="DD")
					 { Date=1;
					   Month=2; // Month will be the third column. So check is it MM/MMM
					   if (FSplit[2]=="MM") {isMName=false;} 
					   else if (FSplit[2]=="MMM") {isMName=true;}
					 }
				if (FSplit[1]=="MM") {Date=2; Month=1;isMName=false}
				if (FSplit[1]=="MMM") { Date=2; Month=1;isMName=true}

			}	 
		 
			if (isMName) // if the Entered Value is Month Name
			{
			 
			  t1[Month]=getMonth(t1[Month]);
				 if (t1[Month]==0)
				 {
 				  alert(GetMultiMessage('MSG182','','') + ' (' + OrigFormat + ")");
 				  ctrlText.focus();
 				  return false;
 				} 
			}
			
			//check if the date is valid
			if(t1[Date] > 31 || t1[Date] < 1 || t1[Date]=="" ||isNaN(t1[Date])==true)
 			{ 
 			  alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			  ctrlText.focus();
 			  return false;
			 } 

			 //check if the Month is valid  
 			else if(t1[Month] > 12 || t1[Month] < 1 || t1[Month]=="" || isNaN(t1[Month])==true)
			  {
 			    alert(GetMultiMessage('MSG182','','') + ' (' + OrigFormat + ")");
 			   ctrlText.focus();
 			   return false;
 			 } 
			 
			 //check if the year is valid 
 			else if( (t1[Year]<1900 && YearLength==4) || t1[Year] >2078 ||t1[Year]=="" || isNaN(t1[Year])==true || t1[Year].length < YearLength || t1[Year].length > YearLength )
 			  {
 			    alert(GetMultiMessage('MSG183','','') + ' (' + OrigFormat + ")");
 			    ctrlText.focus();
 			    return false;
 			  }

 			 else if ((t1[Month] == 1)||(t1[Month] == 3)||(t1[Month] == 5)||(t1[Month] == 7)||(t1[Month] == 8)||(t1[Month] == 10)||(t1[Month] == 12))
			   {
 			//Check for 31 days in the month
 				if (t1[Date] > 31)
 				{ 
 				  alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			      ctrlText.focus();
 			      return false;
 				}
			   }
			 else if ((t1[Month] == 4)||(t1[Month] == 6)||(t1[Month] == 9)||(t1[Month] == 11))
 			{
			//Check for 30 days in the month
 			  if (t1[Date] >30)
 			  {
 			     alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			     ctrlText.focus();
 			     return false;
 			  }
 			}
 			else if(t1[Month] == 2)
 			{
			//check for leap year
 			  if (( (t1[Year] % 4 == 0) && (t1[Year] % 100 !=0)) || (t1[Year] % 400 == 0))
 			  {
 			     if (t1[Date] > 29)
 			     {
 			       alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			      ctrlText.focus();
 			      return false;
 			     }
 			  }
 			  else
 			  {
 			    if (t1[Date] > 28)
 			     {
 			       alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			       ctrlText.focus();
 			       return false;
 			     }
 			  }
			 }
	 }
		 else
		 {
 		   alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 		   ctrlText.focus();
 		   return false;
			   
 		}
		 
  }
  else
  {
    return true;
  }
  return true;       
}


// date validation
function val_Date1(ctrlText,dtFormat)
{ 
	
	val = ctrlText.value;
	
	// To Get the Format of Date
	var Date=0;
	var Month=1;
	var Year=2;
	var OrigFormat,FSplit;
	var YearLength=4;
	var isMName=false;

    OrigFormat=dtFormat;
      
	// Convert into Upper Case
	 var  Format=OrigFormat.toUpperCase();
	  
	// Split the date by / Seperated
	 var FSplit=Format.split("-");
     
	val_Length = val.length;
	if(val != "")
	    {
			t1 = val.split("-");
			if (t1.length == 3) 
			{
			//To Check For Dot,Space,+,e In Date		
 					for(i=0;i<val.length;i++)
 					{ 
 	      				str=val.charCodeAt(i);
 						 if((str == 46)||(str == 32)||(str == 45)||(str == 43))
	 					{	  
 							alert(GetMultiMessage('0349','',''));
 							ctrlText.focus();
 							return false; 
	 				    }
 					}
 		    
			if (FSplit[0]=="DD")
			{
				Date=0;
				if ((FSplit[1]=="MM") || (FSplit[1]=="MMM"))
					{
					 Month=1;
					 Year=2;
					 
					 if (FSplit[1]=="MMM") {isMName=true;} else {isMName=false;}
					 if (FSplit[2]=="YY") {YearLength=2;}
					 else if (FSplit[2]=="YYYY") {YearLength=4;}
					 }
				if (FSplit[1]=="YY") 
					{
					Month=2;
					Year=1;
					YearLength=2
					 if (FSplit[2]=="MMM") {isMName=true;} else {isMName=false;}
					}
				if (FSplit[1]=="YYYY")
				 {
				  Month=2;
				  Year=1;
				  YearLength=4
  				 if (FSplit[2]=="MMM") {isMName=true;} else {isMName=false;}

				  }
			}
			else if ((FSplit[0]=="MM") || (FSplit[0]=="MMM"))
			{
				Month=0;
				if (FSplit[0]=="MMM") {isMName=true;} else {isMName=false;}
				if (FSplit[1]=="DD")
					 {
					  Date=1;
					  Year=2;
  	  				  if (FSplit[2]=="YY") { YearLength=2;} else {YearLength=4;}
					 }
				if (FSplit[1]=="YY") {Date=2;Year=1; YearLength=2}
				if (FSplit[1]=="YYYY") { Date=2;Year=1; YearLength=4}

			}	
			else if ((FSplit[0]=="YY") || (FSplit[0]=="YYYY"))
			{
				Year=0;
				if (FSplit[0]=="YY") { YearLength=2;} else {YearLength=4;}
				
				if (FSplit[1]=="DD")
					 { Date=1;
					   Month=2; // Month will be the third column. So check is it MM/MMM
					   if (FSplit[2]=="MM") {isMName=false;} 
					   else if (FSplit[2]=="MMM") {isMName=true;}
					 }
				if (FSplit[1]=="MM") {Date=2; Month=1;isMName=false}
				if (FSplit[1]=="MMM") { Date=2; Month=1;isMName=true}

			}	 
		 
			if (isMName) // if the Entered Value is Month Name
			{
			 
			  t1[Month]=getMonth(t1[Month]);
				 if (t1[Month]==0)
				 {
 				   alert(GetMultiMessage('MSG182','','') + ' (' + OrigFormat + ")");
 				  ctrlText.focus();
 				  return false;
 				} 
			}
            
			//check if the date is valid
			if(t1[Date] > 31 || t1[Date] < 1 || t1[Date]=="" ||isNaN(t1[Date])==true)
 			{ 
 			  alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			  ctrlText.focus();
 			  return false;
			 } 

			 //check if the Month is valid  
 			else if(t1[Month] > 12 || t1[Month] < 1 || t1[Month]=="" || isNaN(t1[Month])==true)
			  {
 			    alert(GetMultiMessage('MSG182','','') + ' (' + OrigFormat + ")");
 			   ctrlText.focus();
 			   return false;
 			 } 
			 
			 //check if the year is valid 
 			else if( (t1[Year]<1900 && YearLength==4) || t1[Year] >2078 ||t1[Year]=="" || isNaN(t1[Year])==true || t1[Year].length < YearLength || t1[Year].length > YearLength )
 			  {
 			    alert(GetMultiMessage('MSG183','','') + ' (' + OrigFormat + ")");
 			    ctrlText.focus();
 			    return false;
 			  }

 			 else if ((t1[Month] == 1)||(t1[Month] == 3)||(t1[Month] == 5)||(t1[Month] == 7)||(t1[Month] == 8)||(t1[Month] == 10)||(t1[Month] == 12))
			   {
 			//Check for 31 days in the month
 				if (t1[Date] > 31)
 				{ 
 				  alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			      ctrlText.focus();
 			      return false;
 				}
			   }
			 else if ((t1[Month] == 4)||(t1[Month] == 6)||(t1[Month] == 9)||(t1[Month] == 11))
 			{
			//Check for 30 days in the month
 			  if (t1[Date] >30)
 			  {
 			     alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			     ctrlText.focus();
 			     return false;
 			  }
 			}
 			else if(t1[Month] == 2)
 			{
			//check for leap year
 			  if (( (t1[Year] % 4 == 0) && (t1[Year] % 100 !=0)) || (t1[Year] % 400 == 0))
 			  {
 			     if (t1[Date] > 29)
 			     {
 			       alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			      ctrlText.focus();
 			      return false;
 			     }
 			  }
 			  else
 			  {
 			    if (t1[Date] > 28)
 			     {
 			       alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 			       ctrlText.focus();
 			       return false;
 			     }
 			  }
			 }
	    
		             
	    
	 }
		 else
		 {
 		   alert(GetMultiMessage('MSG184','','') + ' (' + OrigFormat + ")");
 		   ctrlText.focus();
 		   return false;
			   
 		}
		 
  }
  else
  {
    return true;
  }
  return true;       
}





function showHide(obj)
   {
        var imgName = obj.id;
        if(imgName.indexOf("imgSp")>-1)
        {
            var no=  imgName.replace("imgSp","");
        }
        else
        {
            var no=  imgName.replace("tdSp","");
        }
        var pos = getPositionSplitter(obj);
        
        var pnl=document.getElementById("PnlSp"+no);
        var img = document.getElementById("imgSp"+no);
        var H = document.getElementById("hdSp"+no);
        
        if(pnl.style.display == 'none')
        {
        pnl.style.display ='';
        img.src="../Images/splitter2.JPG";
        H.value = 1;
        window.scrollTo(0,pos.y);
        }
        else
        {
        pnl.style.display ='none';
        img.src="../Images/splitter1.JPG";
        H.value = 0;
        }
   }
   
   function load_ShowHide(SpNos)
   {
        
        for(i =1;i<=SpNos;i++)
        {
           
            var H = document.getElementById("hdSp"+i);
            var pnl=document.getElementById("PnlSp"+i);
             var img = document.getElementById("imgSp"+i);
           
            if(H.value != "")
            {
            
                if(H.value == 0)
                {
                   pnl.style.display ='none';
                   img.src="../Images/splitter1.JPG";
                }
                else
                {
                   pnl.style.display ='';
                   img.src="../Images/splitter2.JPG";
                }
            }

         }
         
        
   }
   
   
   function getPositionSplitter(e){
	var left = 0;
	var top  = 0;

	while (e.offsetParent){
		left += e.offsetLeft;
		top  += e.offsetTop;
		e     = e.offsetParent;
	}

	left += e.offsetLeft;
	top  += e.offsetTop;

	return {x:left, y:top};
}



/* NUMBER AND CURRENCY FORMATES*********************************************/
/*
   Workfile			: Java.js
   Created on		: 27/07/2007
   Author			: L.Mahendran
   Modified on      : 
   Modified By      : 
   Description		: Contains JavaScript Functions common for all the forms related with Multilingual number format.

   Name and the description of the Functions used : 
   
   NumberValidate_English(field)
   NumberValidate_German(field)
   NumberValidate_Norwegian(field)
   Validatenum(field,sep,dec,re,resep)
   CommaFormattedDec(amount,dec,sep)
   CommaFormatted(amount,sep)
   counchar(fieldvalue,dec,field)
   
   */
   
function CommaFormattedDec(amount,dec,sep)
{
	var delimiter = sep ;
	    var a = amount.split(dec,2)
	var d;
	if (a.length !=2 )
	{
	    d="";
	}
	else
	{
	    d = a[1];
	}
	
	var i = parseInt(a[0]);
	
	if(isNaN(i)) 
	{ 
	   i=0;
	}
	
	
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	var n = new String(i);
	var a = [];
	while(n.length > 3)
	{
		var nn = n.substr(n.length-3);
		a.unshift(nn);
		n = n.substr(0,n.length-3);
	}
	if(n.length > 0) 
	{ 
	    a.unshift(n); 
	}
	n = a.join(delimiter);

	if(d.length < 1) 
	{ 
	    amount = n; 
	}
	else 
	{ 
	    amount = n + dec + d; 
	}
	
	amount = minus + amount;
	return amount;
	
}

//comma insertion with out decimal point
function CommaFormatted(amount,sep)
{
	var delimiter = sep ;
	var i = parseInt(amount);
	if(isNaN(i)) { return ''; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	var n = new String(i);
	var a = [];
	while(n.length > 3)
	{
		var nn = n.substr(n.length-3);
		a.unshift(nn);
		n = n.substr(0,n.length-3);
	}
	if(n.length > 0) { a.unshift(n); }
	n = a.join(delimiter);
	amount = n; 
	amount = minus + amount;
	return amount;
	
}
// end of function CommaFormatted()

// check wheter the character "dec" occurs more than once in a string "fieldvalue"
function counchar(fieldvalue,dec,field)
{
    //To check more than one occurence of decimal or seperator
    var temdec=0;
    for(IntCount=0;IntCount<fieldvalue.length;IntCount++)
    {
        var Onechar=fieldvalue.charAt(IntCount);
        if(Onechar==dec)
            {
                temdec=temdec+1;
            }
    }
    //if temp decimal or seperator is greater than one
    if (temdec > 1)
    {
        var msg = GetMultiMessage('DECPT','','');
        alert(msg);
        return false;
    }
    else
    {
    return true; 
    }

    
}
//end function counchar

// Number validation for English
function NumberValidate_English(field)
{
    // original // re = /\$|,|@|#|~|`|\%|\*|\^|\&|\(|\)|\+|\=|\[|\-|\_|\]|\[|\}|\{|\;|\:|\'|\"|\<|\>|\?|\||\\|\!|\$|\./g;
    //English
    reUS = /\$| |[a-zA-Z]|@|#|~|`|\%|\*|\^|\&|\(|\)|\+|\=|\[|\-|\_|\]|\[|\}|\{|\;|\:|\'|\"|\<|\>|\?|\||\\|\!|\$/g;
    re = reUS
    resep = /\$|,|\$/g;
    var sep = ",";
    var dec = ".";
    var Num="";
    Num=Validatenum(field,sep,dec,re,resep);
    return Num;
}      
   
// Number validation for German
function NumberValidate_German(field)
{
    // German
    reGer = /\$| |[a-zA-Z]|@|#|~|`|\%|\*|\^|\&|\(|\)|\+|\=|\[|\-|\_|\]|\[|\}|\{|\;|\:|\'|\"|\<|\>|\?|\||\\|\!|\$/g;
    re = reGer
    resep = /\$|\.|\$/g;
    var sep = ".";
    var dec = ",";
    var Num="";
    Num=Validatenum(field,sep,dec,re,resep);
    return Num;
}   

// Number validation for Norwegian
function NumberValidate_Norwegian(field)
{
    //Norwegian
    reNor = /\$|[a-zA-Z]|@|#|~|`|\%|\*|\^|\&|\(|\)|\+|\=|\[|\-|\_|\]|\[|\}|\{|\;|\:|\'|\"|\<|\>|\?|\||\\|\!|\$|\./g;
    re = reNor
    resep = /\$| |\$/g;
    var sep = " ";
    var dec = ",";
    var Num="";

    Num=Validatenum(field,sep,dec,re,resep);
    return Num;                        
}   

//Function to validate number
function Validatenum(field,sep,dec,re,resep)
{
        var re = new RegExp(re);
        var resep = new RegExp(resep);
        var m = re.exec(field);
        var vartemp="";
            if (m != null)
        {
            alert(GetMultiMessage('MSG088','',''));
            return false;
        }
        else
        {
           
            vartemp = field;
            // Replacing seperators
            vartemp = (field).replace( resep, "");

            var noalpha = /^[0-9]*$/; // to check whether there is decimal point or not 
            if (noalpha.test(vartemp))
            {
                //if there is no decimal point add temporary decimal point
                vartemp= CommaFormattedDec(vartemp,dec,sep); 
                field=vartemp;
                return field;
            }
            else //if there is decimal point then check for more than one occurence
            {
                if (counchar(vartemp,dec,field)==true) 
                {
                    vartemp= CommaFormattedDec(vartemp,dec,sep); // correcting the number format
                    field=vartemp;
                    return field;
                }
                else
                {
                    return false;
                }
            } 
        }
}

function addNum(spareParts,LabourPrice,GarageMaterialPrice,TotalJobFixedPrice)
{
  spareParts=Number(spareParts.replace(/,/g,''));
  LabourPrice=Number(LabourPrice.replace(/,/g,''));
  GarageMaterialPrice=Number(GarageMaterialPrice.replace(/,/g,''));
  TotalJobFixedPrice=Number(TotalJobFixedPrice.replace(/,/g,''));
  return (spareParts+LabourPrice+GarageMaterialPrice+TotalJobFixedPrice).toFixed(2);
 }
   
function insertChar(s)
{
   var re=/(-?\d+)(\d{3})/;
   while(re.test(s))
   {
         s=s.replace(re,'$1,$2')
    }   
  return s;
}
    
//Functions Closed addNum(x,y) and insertChar(s) by Manoj K
//ValidateCurrencyANDNumber has been removed on 03-July-2009
/*END--- NUMBER AND CURRENCY FORMATES*********************************************/

//  This function is used when "From Date" is selected automatically "To Date" is to be selected
function FromToDateSelection(obj1,obj2)
{	
     if (obj2 != null )                    
          if(obj2.value.length == 0)
             obj2.value = obj1.value;        
  
    return;
}

/*Bug ID:-2525
  Date:-27-May-2008
  Desc:- If remove from, [To date then From Date] should also removed
*/
function RemoveFromToDateSelection(obj1,obj2)
{
   if(obj2.value.length == 0)
      obj1.value = obj2.value;  
             
    if(obj1.value.length == 0)
       obj2.value = obj1.value; 
       
        
}
/*CHANGE END*/

/*END--- NUMBER AND CURRENCY FORMATES*********************************************/

//  This function is used when "To Date" is selected automatically "From Date" is to be selected, Added by lakshmi on 13 Dec 2007
function ToFromDateSelection(obj1,obj2)
{	
     if (obj1 != null)                    
          if(obj1.value.length == 0)
             obj1.value = obj2.value;   
                
    
    return; 
}
// Function to Close the Help popup screens
function fnCloseHelpPopUp(obj1,obj2)
        {
            self.close();
           if ( window.opener && !window.opener.closed )
                window.opener.document.forms[obj1].elements[obj2].focus();
             
}
/*********************************************************************
	        Modified Date : 04th June 20008
	        Bug ID        : SS2_4_2
*********************************************************************/
function Validatetime(obj)
{

 
    //Get Te Id of the textBox in which the time is eneterd 
    var textBoxid  = obj[0].id;

    //Get the text entered into a local variable
    var deliverytime = document.getElementById(textBoxid).value
   

    //Define the characters which are allowed in the textBox
    var iChars = "0123456789:.,";

    //Iterate to check for the invalid Characters
    for(var IntCount=0;IntCount<deliverytime.length; IntCount++)
    {	        
        if (iChars.indexOf(deliverytime.charAt(IntCount)) == -1)
        {
            alert(GetMultiMessage('MSG088','',''));
            return false;
        }	  
    }

    // run a check for the presence of the characters like "." or ","
    var charPeriod = deliverytime.indexOf(".");
    var charComa    = deliverytime.indexOf(",");

    //Code to change the format if "." is present
     
    if(  (charPeriod != -1) && (charComa == -1)  )
    {
       
        var splitPeriod = new Array();
        splitPeriod = deliverytime.split(".");
        if(parseInt(splitPeriod[0]) >= 999)
        {
           
            alert(GetMultiMessage('MSG185','',''));
            var textBoxId = obj[0].id;             
            document.getElementById(textBoxId).focus();
            document.getElementById(textBoxId).value="";
            return false;
        }
        else
        {
            var tempLen = splitPeriod[1].length 
            splitPeriod[1] = (splitPeriod[1]/(Math.pow(10,tempLen))) * 60 ; 
                     
               
           if(splitPeriod[0].length == 1 && parseInt(splitPeriod[1]) <= 10)		    
           {
               var textBoxId = obj[0].id;
               if (Math.round(splitPeriod[1]) >= 10)
               {
               document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
               }
               else
               {
               document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":0" + Math.round(splitPeriod[1]); 
             
              }       
           }
           		
           else if(parseInt(splitPeriod[1]) <= 10)
           {
              var textBoxId = obj[0].id;  
              if (Math.round(splitPeriod[1]) >= 10)
               {
               document.getElementById(textBoxId).value =  splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
               }
               else
               {
              document.getElementById(textBoxId).value = splitPeriod[0] + ":0" + Math.round(splitPeriod[1]);
              }
              
           }               
           else
           {
                var textBoxId = obj[0].id;
                if(splitPeriod[0].length == 1)
                {
                 document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
                
                }
                else
                {
                 document.getElementById(textBoxId).value = splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
                
                }
           } 
            
        }          
    } 
    //Code to change the format if "," is present   
    else if (  (charPeriod == -1) && (charComa != -1)  )
    {
        
        var splitPeriod = new Array();
        splitPeriod = deliverytime.split(",");     
        


        if(parseInt(splitPeriod[0]) >= 999)
        {
            alert(GetMultiMessage('MSG185','',''));
            var textBoxId = obj[0].id; 
            document.getElementById(textBoxId).focus();
            document.getElementById(textBoxId).value="";
            return false;
        }
        else
        {  
            
           var tempLen = splitPeriod[1].length 	
           splitPeriod[1] = (splitPeriod[1]/(Math.pow(10,tempLen))) * 60;               
           
           if(splitPeriod[0].length == 1 && parseInt(splitPeriod[1]) <= 10)		    
           {
               var textBoxId = obj[0].id; 
               
               var textBoxId = obj[0].id;
               if (Math.round(splitPeriod[1]) >= 10)
               {
               document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
               }
               else
               {
               document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":0" + Math.round(splitPeriod[1]); 
              
              }                    
           }
           		
           else if(parseInt(splitPeriod[1]) <= 10)
           {
               var textBoxId = obj[0].id;
               
               if (Math.round(splitPeriod[1]) >= 10)
               {
               document.getElementById(textBoxId).value =  splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
               }
               else
               {
              document.getElementById(textBoxId).value = splitPeriod[0] + ":0" + Math.round(splitPeriod[1]);
              }     
           }
             
           else
           {
                var textBoxId = obj[0].id;
                if(splitPeriod[0].length == 1)
                {
                    document.getElementById(textBoxId).value = "0" + splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
                    
                }
                else
                {
                    document.getElementById(textBoxId).value = splitPeriod[0] + ":" + Math.round(splitPeriod[1]);
                   
                }
           } 
        }		            
    } 
    else
    {
        var textBoxId = obj[0].id;
        var timeVal = document.getElementById(textBoxId).value
        if( timeVal.indexOf(":") == -1)
        {
           if(deliverytime.length == 1)		    
               {
                   var textBoxId = obj[0].id;
                   document.getElementById(textBoxId).value = "0" + deliverytime + ":00"               
               }		
           if(deliverytime.length == 2)
               {
                   var textBoxId = obj[0].id;
                   document.getElementById(textBoxId).value = deliverytime + ":00"
               }    
           if(deliverytime.length == 3)
               {
                   var textBoxId = obj[0].id;
                   document.getElementById(textBoxId).value = "0" + deliverytime.charAt(0) + ":" + deliverytime.substring(1,3);                
               }
           if(deliverytime.length == 4)
               {
                   var textBoxId = obj[0].id;
                   document.getElementById(textBoxId).value = deliverytime.substring(0,2) + ":" + deliverytime.substring(2,5);
                                                   
               }
               //Added By smita to accept 3 digits in Standard time for hh
           if(deliverytime.length == 5)
           {
               var textBoxId = obj[0].id;
               document.getElementById(textBoxId).value = deliverytime.substring(0,3) + ":" + deliverytime.substring(3,6);                                      
           }
        }               

    }    

}

 function gfs_ValidateNumbers(ctrlText,tags) 
 {
	var val=ctrlText.value;
	var val_Length=ctrlText.value.length;
	if(isNaN(val) || (val < 0))
    {
        var msg=GetMultiMessage(tags,'','')
        msg=GetMultiMessage('0090',msg,'')
        alert(msg);
        ctrlText.focus();
        return false;
	}
	for(i=0;i<val_Length;i++)
	{ 
		str=val.charCodeAt(i);
		if((str == 46)||(str == 101)||(str == 32)||(str == 45)||(str == 43))
		{	  
            var msg=GetMultiMessage(tags,'','')
            msg=GetMultiMessage('0090',msg,'')
            alert(msg);
			ctrlText.focus();
			return false;
		}
	}
	return true;
}

function fn_ValidateDecimal(ctltovalidate, dcseperator, tdseperator)
{
    var valuetovalidate = ctltovalidate.value;
        
    if(valuetovalidate.length == 1)
    {
        if(valuetovalidate == dcseperator)
        {
            //Only seperator entered
            return false;
        }
        else
        {
            //Validate for Number with thousand seperator            
            if(tdseperator == "undefined" || tdseperator == null)            
                return fn_NumberCheck(valuetovalidate);
            else
                return fn_NumberCheck(valuetovalidate, tdseperator);
        }
    }
    else if(valuetovalidate.length > 1)
    {
        //If decimal and thousand seperator are same, then need to look for the last_index_of decimal seperator
        //and get the decimal value and precise value
        var decimalValue = '';
        var preciseValue = '';
        var valuetovalidate_arr;
        var index = 0;        
        var arrlength;
        
        valuetovalidate_arr = valuetovalidate.split(dcseperator);
        arrlength = valuetovalidate_arr.length;
        
        if(arrlength > 2)
        {
            //Decimal seperator is given more than once
            return false;
        }
        
        for(index = 0; index < arrlength - 1; index++)
        {
            if(index == arrlength - 2)
            {
                preciseValue = preciseValue + valuetovalidate_arr[index];
            }
            else
            {
                preciseValue = preciseValue + valuetovalidate_arr[index] + valuetovalidate.charAt(preciseValue.length+1);
            }
        }
        
        if(preciseValue == "undefined" || preciseValue == null || preciseValue == '')
        {
            preciseValue = "0";
        }
        
        if(preciseValue < 0)
        {
            preciseValue  = (preciseValue * -1) + '';
        }        
        
        decimalValue = valuetovalidate_arr[arrlength - 1];
        
        if(tdseperator == "undefined" || tdseperator == null)
        {
            if(fn_NumberCheck(preciseValue))
            {
                if(fn_NumberCheck(decimalValue))
                {
                    //Both Precise and Decimal are in Numbers
                    return true;
                }
                else
                {
                    //Decimal Value is not Number
                    return false;
                }
            }
            else
            {
                //Precise Value is not Number
                return false;
            }
        }
        else
        {
            if(fn_NumberCheck(preciseValue, tdseperator))
            {
                if(fn_NumberCheck(decimalValue, tdseperator))
                {
                    //Both Precise and Decimal are in Numbers
                    return true;
                }
                else
                {
                    //Decimal Value is not Number
                    return false;
                }
            }
            else
            {
                //Precise Value is not Number
                return false;
            } 
        }
    }
    return true;
}


function fn_ValidateDecimalOrder(ctltovalidate, dcseperator, tdseperator)
{
    var valuetovalidate = ctltovalidate.value;
        
    if(valuetovalidate.length == 1)
    {
        if(valuetovalidate == dcseperator)
        {
            //Only seperator entered
            return false;
        }
        else
        {
            //Validate for Number with thousand seperator            
            if(tdseperator == "undefined" || tdseperator == null)            
                return fn_NumberCheck(valuetovalidate);
            else
                return fn_NumberCheck(valuetovalidate, tdseperator);
        }
    }
    else if(valuetovalidate.length > 1)
    {
        //If decimal and thousand seperator are same, then need to look for the last_index_of decimal seperator
        //and get the decimal value and precise value
        var decimalValue = '';
        var preciseValue = '';
        var valuetovalidate_arr;
        var index = 0;        
        var arrlength;
        
        valuetovalidate_arr = valuetovalidate.split(dcseperator);
        arrlength = valuetovalidate_arr.length;
        
        if(arrlength > 2)
        {
            //Decimal seperator is given more than once
            return false;
        }
        
        for(index = 0; index < arrlength - 1; index++)
        {
            if(index == arrlength - 2)
            {
                preciseValue = preciseValue + valuetovalidate_arr[index];
            }
            else
            {
                preciseValue = preciseValue + valuetovalidate_arr[index] + valuetovalidate.charAt(preciseValue.length+1);
            }
        }
        
        if(preciseValue == "undefined" || preciseValue == null || preciseValue == '')
        {
            preciseValue = "0";
        }
        
        if(preciseValue < 0)
        {
            preciseValue  = (preciseValue * -1) + '';
        }        
        
        decimalValue = valuetovalidate_arr[arrlength - 1];
        
        if(tdseperator == "undefined" || tdseperator == null)
        {
            if(fn_NumberCheck(preciseValue))
            {
                return true;
            }
            else
            {
                //Precise Value is not Number
                return false;
            }
        }
        else
        {
            if(fn_NumberCheck(preciseValue, tdseperator))
            {
                return true;
            }
            else
            {
                //Precise Value is not Number
                return false;
            } 
        }
    }
    return true;
}


function fn_NumberCheck(valuetocheck)
{
    var FieldValue;
    var FieldLength;
    var Onechar;
    FieldValue = valuetocheck;
    FieldLength = FieldValue.length;
    Onechar = FieldValue.charAt(0);
    
    if(FieldLength == 0)
    {
        return false;
    }

    //To check each charecter lies in between the numbers and thousand seperator.
    for(IntCount = 0; IntCount < FieldLength; IntCount++)
    {
        Onechar = FieldValue.charAt(IntCount);        
        if((Onechar > "9"))
        {
            return false;
        }
    }        
    return true;
}

function fn_NumberCheck(valuetocheck, tdseperator)
{
    var FieldValue;
    var FieldLength;
    var Onechar;
    FieldValue = valuetocheck;
    FieldLength = FieldValue.length;
    Onechar = FieldValue.charAt(0);
    
    if(FieldLength == 0)
    {
        return false;
    }

    //To check each charecter lies in between the numbers and thousand seperator.
    for(IntCount = 0; IntCount < FieldLength; IntCount++)
    {
        Onechar = FieldValue.charAt(IntCount);        
        if((Onechar > "9") && Onechar != tdseperator)
        {
            return false;
        }
    }        
    return true;
}

//This function is taken from Master/frmCfMechComp.aspx
//This function can be used for formatting the decimal. [Not used for now]

function fnformatDecimal(ctltovalidate, dcseperator)
{
     var valuetovalidate = ctltovalidate.value;
     
     if(dcseperator == ",")
     {
        valuetovalidate = valuetovalidate.replace(",",".");
     }
     
     return roundNumber(valuetovalidate,2);
} 

function fnreformatDecimal(valuetovalidate, dcseperator)
{
     var temp = valuetovalidate + "";
     
     if(dcseperator == ",")
     {
        temp = temp.replace(".",",");
     }
     
     return temp;
} 

function fnCompareDecimal(ctltovalidate1, ctltovalidate2, dcseperator)
{
     var valuetovalidate1 = fnformatDecimal(ctltovalidate1, dcseperator);
     var valuetovalidate2 = fnformatDecimal(ctltovalidate2, dcseperator);
     
     if(valuetovalidate1 < valuetovalidate2)
     {
        return true;
     }
     else
     {
        return false;
     }
} 

function fnBalanceDecimal(ctltovalidate1, ctltovalidate2, dcseperator)
{
    var valuetovalidate1 = fnformatDecimal(ctltovalidate1, dcseperator);
    var valuetovalidate2 = fnformatDecimal(ctltovalidate2, dcseperator);

    var balance = valuetovalidate1 - valuetovalidate2;
    return roundNumber(balance,2);
}

function roundNumber(num, dec)
{
	var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	return result;
}

function InvokePop(Url,Code,CodeVal)
{
    try
    { 
       var  RCvalue = document.getElementById(Code).value;
         // to handle in IE 7.0          
        if (window.showModalDialog)
        {  
            retVal = window.showModalDialog(Url+ "?Control1=" + Code + "&Code=" + CodeVal  ,window.self,"dialogHeight:275px;dialogWidth:340px;resizable:no;center:yes;scroll:no;");
           
            if (retVal != undefined)
            {
              document.getElementById(Code).value = retVal;
            }
            else
            {
             document.getElementById(Code).value =RCvalue;
            }
        }
        // to handle in Firefox
        else
        {     
            retVal = window.open(Url+ "?Control1="+Code + "&Code=" + CodeVal,'Show Popup Window','height=260,width=350,resizable=no,modal=yes,scroll=no;');
            retVal.focus();           
        }   
     }catch(e)
     {
        //Do Nothing
     }         
}

function GetPackage(CodeValue)
{
    try
    {
        var lb = document.getElementById("lstInfo");
        var s = "";
        RetrieveControl();
        for (var i = 0; i < lb.options.length; i++)
        {
             if (lb.options[i].selected == true)
             {
               
                   if (CodeValue =='CU')
                   {
                        s = lb.options[i].value;
                    }
                   else
                   {
                      s = lb.options[i].text;
                   }
                   
             }
        }   


        if (window.showModalDialog)
         {             
            window.returnValue = s;
            window.close();
         }
         // to handle in Firefox
         else
         {
            if ((window.opener != null) && (!window.opener.closed))
            {              
                // Access the control.       
                window.opener.document.getElementById(ctr[1]).value = s;
            }
                window.close();
         }
    }
    catch(e)
    {
        //Do Nothing
    }
}

function RetrieveControl()
{
    try
    {
        //Retrieve the query string
        queryStr = window.location.search.substring(1);
        // Seperate the control and its value
        ctrlArray = queryStr.split("&");
        ctrl1 = ctrlArray[0];
        //Retrieve the control passed via querystring
        ctr = ctrl1.split("=");
    }
    catch(e)
    {
        //Do Nothing
    }
}
//Change End


function getTopBannerImage()
{
    if(document.getElementById("tdTopImage") != null && document.getElementById("tdTopImage")!= "undefined")
    {  
        if(window.location.pathname.search("Reports") == -1)
        {
            document.getElementById("tdTopImage").style.backgroundImage =  "url('../Images/heading_band_03.gif')";       
        }    
        else
        {
            document.getElementById("tdTopImage").style.backgroundImage =  "url('../../Images/heading_band_03.gif')";
        }
    }
    if(document.getElementById("tdTopBandline") != null && document.getElementById("tdTopBandline")!= "undefined")
    {  
        if(window.location.pathname.search("Reports") == -1)
        {
            document.getElementById("tdTopBandline").style.backgroundImage =  "url('../Images/heading_bandline_10.gif')";       
        }    
        else
        {
            document.getElementById("tdTopBandline").style.backgroundImage =  "url('../../Images/heading_bandline_10.gif')";
        }
    }
}


/*

[KeyCode]
Backspace      8
Tab            9
Enter         13 
Shift         16 
Ctrl          17 
Alt           18 
Pause/Break   19 
Caps Lock     20 
Esc           27 
Page Up       33 
Page Down     34 
End           35 
Home          36 
Left Arrow    37 
Print Screen  44
Delete        46
F1            112
F2            113
F3            114
F4            115
F5            116
F6            117
F7            118
F8            119
F9            120
F10           121
F11           122
F12           123

*/
//Checking MaxLength for MultiLine TextBox,Date :- 21-May-2009
function checkLength(oObject, len)

    {

        if (oObject.value.length<len)
            return true;
        else
        {

         if ((event.keyCode>=37 && event.keyCode<=40) || (event.keyCode==8) || (event.keyCode==46) || (event.keyCode==36)|| (event.keyCode==16) || (event.keyCode==35))
            event.returnValue = true;
         else
            event.returnValue = false;
        }

    }
    


function fnConvertTextHTML(message, editor)
{    
    var text = message.value;
    var formattedString;
    formattedString = "<p>" + text + "</p>";
    formattedString = formattedString.split("\n").join("<br/>");
//    formattedString = formattedString.split(" ").join("&nbsp;");
    formattedString = formattedString.split("<span&nbsp;style=\"color:&nbsp;red\">").join("<span style=\"color:red\">");
    editor.value = formattedString;
}

    function fnErrorCode(ErrorID)
    {
        try
        {
            if (ErrorID.indexOf(",")!=-1)
            {
                var url;
                url = "ErrorCodes.aspx?ErrorCode=" + ErrorID;
                window.showModalDialog(url,window.self,"dialogHeight:400px,dialogWidth:250px,resizable:no,center:yes,scroll:no;");
                return false;
            }
            else
            {
                var msg=GetMultiMessage(ErrorID,'','')
                alert(msg);
                return false;
            }
        }
        catch(e)
        {
        }
    }
    
    function DisplayPopupToolTip(event)
    {
        if (navigator.appName == "Microsoft Internet Explorer")
            DisplayPopupToolTipForIE(event);
        else
            DisplayPopupToolTipForFF(event);
    }

    function DisplayPopupToolTipForIE(event)
    {
        var item ;
        if (!item) item = window.event;
        var lbl,toolTip;
        if(item.srcElement != null)
        {
            if (item.srcElement.type == 'checkbox')
            {
                var tt =item.srcElement.parentNode;
                lbl =tt.ShowToolTip;
                toolTip = tt.innerText;
            }
            else if(item.srcElement.type == 'radio')
            {
                var tt =item.srcElement.parentNode;
                lbl =tt.ShowToolTip;
                toolTip = tt.innerText;
             }   
             else
             {
                var obj = eval("document.getElementById('" + item.srcElement.ToolTipID + "')");
                if (obj == "[object]")
                {
                    if (obj.innerText == 'undefined')
                        toolTip="";
                    else
                        toolTip=obj.innerText; ;
                }
                else
                    toolTip=""; 
              }
            if (!lbl) lbl =item.srcElement.ShowToolTip;
            if (typeof(lbl) == 'undefined') lbl ="";
            window.status= lbl + toolTip;
        }
    }

function DisplayPopupToolTipForFF(event)
{
    var item ;
    if (!item) item = event;
    var lbl,toolTip;
    if(item.target != null)
    {
        if (item.target.type == 'checkbox' || item.target.type == 'radio')
        {   
            lbl =item.target.parentNode.textContent;
            toolTip = item.target.parentNode.getAttribute("ShowToolTip");
        }
        else if(item.target.type == 'text' || item.target.type == 'select-one' || item.target.type == 'select-multiple')
        {
            var obj = eval("document.getElementById('" + item.target.getAttribute("ToolTipID") + "')");      
            lbl=obj.innerHTML;              
            if (!toolTip) toolTip =item.target.getAttribute("ShowToolTip");
        }
        if ((typeof(lbl) == 'undefined') || (lbl == null)) lbl ="";
        if ((typeof(toolTip) == 'undefined')||(toolTip == null)) toolTip ="";
        window.status=  toolTip + lbl ;
    }
}
function DisplayToolTipForIE(event)
{
    var item ;
    if (!item) item = window.event;
    var lbl,toolTip;
    if(item.srcElement != null)
    {
        if (item.srcElement.type == 'checkbox')
        {
            var tt =item.srcElement.parentNode;
            lbl =tt.ShowToolTip;
            toolTip = tt.innerText;
        }
        else if(item.srcElement.type == 'radio')
        {
            var tt =item.srcElement.parentNode;
            lbl =tt.ShowToolTip;
            toolTip = tt.innerText;
         }   
         else
         {
            var obj = eval("document.getElementById('ctl00_cntMainpanel_" + item.srcElement.ToolTipID + "')");
            if (obj == "[object]")
            {
                if (obj.innerText == 'undefined')
                    toolTip="";
                else
                    toolTip=obj.innerText; ;
            }
            else
                toolTip=""; 
          }
        if (!lbl) lbl =item.srcElement.ShowToolTip;
        if (typeof(lbl) == 'undefined') lbl ="";
        window.status= lbl + toolTip;
    }
}

function DisplayToolTipForFF(event)
{
    var item ;
    if (!item) item = event;
    var lbl,toolTip;
    if(item.target != null)
    {
        if (item.target.type == 'checkbox' || item.target.type == 'radio')
        {   
            lbl =item.target.parentNode.textContent;
            toolTip = item.target.parentNode.getAttribute("ShowToolTip");
        }
        else if(item.target.type == 'text' || item.target.type == 'select-one' || item.target.type == 'select-multiple')
        {
            var obj = eval("document.getElementById('ctl00_cntMainPanel_" + item.target.getAttribute("ToolTipID") + "')");      
            lbl=obj.innerHTML;              
            if (!toolTip) toolTip =item.target.getAttribute("ShowToolTip");
        }
        if ((typeof(lbl) == 'undefined') || (lbl == null)) lbl ="";
        if ((typeof(toolTip) == 'undefined')||(toolTip == null)) toolTip ="";
        window.status=  toolTip + lbl ;
    }
}
function DisplayToolTip(event)
{
    if (navigator.appName == "Microsoft Internet Explorer")
        DisplayToolTipForIE(event);
    else
        DisplayToolTipForFF(event);
}


function GetDatabaseDateFormat(obj,format)
{
    if(obj.value == "")
    {
        return "";
    }
    
    var date=getDateFromFormat(obj.value,format);
	if (date!=0)
	{
	    var result = fnFormatDate(date,"MM/dd/yyyy");	    
	}
	return result;
    
}



function GetDropDownList(ddlID)
     {
        try
        {

            if(document.getElementById(ddlID).selectedIndex == "0")
                return dllValue = "";
            else
                return dllValue = document.getElementById(ddlID).options[document.getElementById(ddlID).selectedIndex].value;
        }catch(e)
        {
        
            //alert(e.message);
            return false;
        }
     }
     
     
     
 function GetCheckedRadio(name) 
     {
        try
        {
            var radioButtons = document.getElementsByName(name.replace(/_/g,"$"));        
            for (var x = 0; x < radioButtons.length; x ++) 
            {
                if (radioButtons[x].checked) 
                {
                    return radioButtons[x].value;
                    break;
                }
            }
        }
        catch(e)
        {
            //alert(e.message);
            return false;
        }
    }
    
    
    
 function GetTextBoxID(txtID)
 {
    try
    {
          if(document.getElementById(txtID).value == "")
                return txtValue = "";
            else
                return txtValue= document.getElementById(txtID).value 
    
    }
    catch(e)
    {
        //alert(e.message);
        return false;
    
    }
 
 }
     function fnCallPopUp(action,SetXML)
    {         
      
        try
        {
            var arr_check = document.getElementById('frmOpenReport').getElementsByTagName('input');
            for(ai = 0; ai < arr_check.length; ai++)
            {   
                if(document.getElementById('frmOpenReport').getElementsByTagName('input')[ai].id.indexOf('txtParentObj') >= 0)
                {
                    document.getElementById('frmOpenReport').getElementsByTagName('input')[ai].value =SetXML;
                    var windowUsrRpt = window.open("../Loading.htm","Reports","menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");                
                    document.forms['frmOpenReport'].action =action;
                    document.frmOpenReport.target = "Reports";        
                    document.frmOpenReport.submit(); 
                    windowUsrRpt.focus(); 
                    return false; 
                }
            }
        }
        catch(e)
        {
            //alert(e.message);
            return false;
        }
    }
    
    
    
function GetListBox(lstID) 
{ 
    try
    {
        var listBox = document.getElementById(lstID); 
        var elements = ""; 
        var intCount = listBox.options.length; 

        //store the elements in a hidden input that we can get server side 
        for (i = 0; i < intCount; i++) 
        { 
            if(listBox.options(i).selected)
            {
                elements += listBox.options(i).text + ','; 
             }
        } 
        return elements.substring(0,elements.length-1); 
    }
    catch(e)
    {
        //alert(e.message);
        return false;
    }
} 

function GetCheckBox(cbID)
{
    try
    {
            if(document.getElementById(cbID).checked)
                return "TRUE";
            else
                return "FALSE";
    
    }
    catch(e)
    {
        alert(e.message);
        return false;
    }
    
}

function addToEvent() 
{
	http_request = false;
	var randomnumber = Math.floor(Math.random()* 10000000)
	url = "../Master/LogLogout.aspx?rand="+ randomnumber
	if (window.XMLHttpRequest) 
	{ // Mozilla, Safari,...
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType) 
		{
			http_request.overrideMimeType('text/xml');
		}
	}
	else if (window.ActiveXObject) 
	{ // IE
		try 
		{
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e)
		{
			try 
			{
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			}	
			catch (e) 
			{
				
			}
		}
	}

	if (!http_request) 
	{
		alert('Giving up :( Cannot create an XMLHTTP instance');
		return false;
	}

	http_request.onreadystatechange = function() {};
	http_request.open('GET', url, true);
	http_request.send(null);
}

function pause(millis)
{
    var date = new Date();
    var curDate = null;
    do
    {
        curDate = new Date();
    }
    while(curDate-date < millis)
}

function copyToClipboard(elem) {
    // create hidden text element, if it doesn't already exist
    var targetId = "_hiddenCopyText_";
    var isInput = elem.tagName === "INPUT" || elem.tagName === "TEXTAREA";
    var origSelectionStart, origSelectionEnd;
    if (isInput) {
        // can just use the original source element for the selection and copy
        target = elem;
        origSelectionStart = elem.selectionStart;
        origSelectionEnd = elem.selectionEnd;
    } else {
        // must use a temporary form element for the selection and copy
        target = document.getElementById(targetId);
        if (!target) {
            var target = document.createElement("textarea");
            target.style.position = "absolute";
            target.style.left = "-9999px";
            target.style.top = "0";
            target.id = targetId;
            document.body.appendChild(target);
        }
        target.textContent = elem.textContent;
    }
    // select the content
    var currentFocus = document.activeElement;
    target.focus();
    target.setSelectionRange(0, target.value.length);

    // copy the selection
    var succeed;
    try {
        succeed = document.execCommand("copy");
    } catch (e) {
        succeed = false;
    }
    // restore original focus
    if (currentFocus && typeof currentFocus.focus === "function") {
        currentFocus.focus();
    }

    if (isInput) {
        // restore prior selection
        elem.setSelectionRange(origSelectionStart, origSelectionEnd);
    } else {
        // clear temporary content
        target.textContent = "";
    }
    return succeed;
}

function fnformatDecimalValue(ctltovalidate, dcseperator) {
    if (ctltovalidate == undefined) {
        ctltovalidate = "0";
    }
    var valuetovalidate = ctltovalidate;
    var s = valuetovalidate.toString().indexOf(",");    

    if (dcseperator == "," && s != -1) {
        valuetovalidate = valuetovalidate.replace(",", ".");
    }

    return roundNumber(valuetovalidate, 2);
}

