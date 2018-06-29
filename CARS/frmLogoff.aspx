<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLogoff.aspx.vb" Inherits="CARS.frmLogoff" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ABS 10 - Logout</title>
    <link href="CSS/Msg.css" rel="stylesheet" type="text/css" />
</head>
    <script language="javascript" type="text/javascript">
    
    function winClose(logoutmessage)
    {
        if (navigator.appName == 'Netscape') 
        {
            
            cfm = window.confirm(logoutmessage)           
            
            if(cfm == true)
            {
                window.open('','_parent','');
                window.close();
                            
            }
            else if(cfm == false)
            {                
                window.close();
                return false;
            }
        }
        else
        {
            window.close();
        }
    }
    </script>
<body onload="javascript:window.history.forward(1);">
    <form id="form1" runat="server">
     <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="4c6a9e">
	<tr>
		<td style="width: 10%;background-color:#4C6A9E;"  >
		    <asp:Image ImageUrl="~/images/heading_band_01.gif" ID="imgH1" runat="server" width="117" height="57" AlternateText="" BorderStyle="None"/></td>
		
		<td valign="middle" style="background-position:center;background-color:#4C6A9E; background-image: url('images/heading_band_03.gif'); background-repeat: no-repeat;padding-top:19px;" align="center">
                            <table border="0" cellpadding="1" cellspacing="0" >
                                <tr>
                                    <td align=center style="background-position:bottom;background-image: url('images/heading_bandline_10.gif'); background-repeat: no-repeat;" >
                                        <asp:Label ID="lblPageTitle" runat="server" Text="Garage Planning and Administration System " 
                                            Font-Bold="True" Font-Italic="True" ForeColor="White" 
                                            Font-Names="Arial" Font-Size="11px" ></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align=center>
                                    <asp:Label ID="lblLanguage" runat="server" Text="Language"  
                                            BackColor="#4C6A9E" Font-Bold="True" Font-Italic="True" ForeColor="White" 
                                            Font-Names="Verdana" Font-Size="10px"></asp:Label>
                                    </td>
                                </tr>
                            </table> 
                        </td>
		<td style="width: 10%;" align="right" ><asp:Image imageurl="~/images/heading_band_05.gif" ID="imgH3" runat="server"  AlternateText="" BorderStyle="None"  /></td>
		
	 	
        <td  align="center" valign="top"  style="width: 20%;" class="welcome_screen_Main"  >
          <asp:Label Font-Size="Small" ID="lblLoginInfo" Font-Bold="True"  runat="Server" Text="Thank You " Font-Italic="True" ForeColor="white" ></asp:Label>
          </td>
	</tr>
</table>
        <div>
                      <p>
               </p>
            <center>
                <font face="Arial" color="#333366" size="2"><b>
                    <asp:Label ID="LblMessage1" runat="server" Text="You have logged out of MSG ABS-10 Application"></asp:Label></b>
                    <p>
                        <font face="Arial" color="red" size="2">
                            <asp:Label ID="LblMessage2" runat="server" Text="For security reasons, we suggest you close this  window." Width="344px"></asp:Label></font></p>
                    <p>
                        <br>
                        <asp:Button ID="Btnlogin" runat="server" Text="Login" class="sordersbuttons"/>
                        <asp:Button ID="BtnClose" runat="server" Text="Close" class="sordersbuttons"/>
                        </p>
                </font>
            </center>
            <center>
                <p>
                    <br>
                    <asp:Label ID="RTlblError" runat="server" CssClass="lblMsg"></asp:Label>
            </center>
            <br>
            <br>
            <p class="txtSm" align="center">
                <asp:Label ID="LblCopy" runat="server" Text="©MSG 2007 - www.modernsoftwaregroup.com - Tel +4732218340 - Fax +4732218341 " Width="508px"></asp:Label>
                 <asp:HiddenField ID="lblHidTitle" runat="server" Value="Login Page" />
                </p>
        </div>
    </form>
</body>
</html>
