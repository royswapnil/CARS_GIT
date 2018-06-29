<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLogin.aspx.vb" Inherits="CARS.frmLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CARS Login</title>
    <meta http-equiv="Page-Enter" content="Alpha(opacity=100)" />
    <script src="Scripts/jquery-2.1.4.min.js"></script>
    <link href="CSS/Msg.css" rel="stylesheet" type="text/css" />
    <link href="~/semantic/semantic.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtUserName').focus();
        });
    </script>
</head>
<body>
    <form id="frmLogin" class="ui form" runat="server" defaultbutton="LnkLogin">
        <div class="loginForm">
            <h4 class="ui dividing header">
                <asp:Literal ID="lblLogintosys" runat="server" Text="Login to the system"></asp:Literal></h4>
            <div class="field brand">
                <img src="Images/cars.png" width="200" height="117" alt="Cars Software AS" />
                <asp:Label ID="lblLanguage" CssClass="sr-only" runat="server" Text="Language"></asp:Label>
            </div>
            <div class="field">
                <asp:Label ID="RTLblErr" runat="server" CssClass="lblErr" Visible="False"></asp:Label>
            </div>
            <div class="field">
                <label>
                    <asp:Literal ID="lbluser" runat="server" Text="User Name"></asp:Literal><span class="mand">*</span></label>
                <div class="ui icon input">
                    <asp:TextBox ID="txtUserName" runat="server" MaxLength="20" > </asp:TextBox>
                    <i class="user icon"></i>
                </div>
            </div>
            <div class="field">
                <label>
                    <asp:Literal ID="lblpass" runat="server" Text="Password"></asp:Literal><span class="mand">*</span></label>
                <div class="ui icon input">
                    <asp:TextBox ID="txtPassword" runat="server" MaxLength="20" TextMode="Password"> </asp:TextBox>
                    <i class="lock icon"></i>
                </div>
            </div>
            <div class="grouped fields">
                <div class="field">
                    <div class="ui radio checkbox">
                        <asp:RadioButton ID="RbhireView" runat="server" Text="Hierarchical View" GroupName="Rbg" CssClass="sr-only" />
                    </div>
                    <div class="ui radio checkbox">
                        <asp:RadioButton ID="RbroleView" runat="server" Text="Role Based View" GroupName="Rbg" CssClass="sr-only" />
                    </div>
                </div>
            </div>
            <div class="field">
                <asp:LinkButton ID="LnkLogin" runat="server" CssClass="ui btn" Text="Login in my ABS"></asp:LinkButton>
            </div>
        </div>
        <div class="ui bottom attached warning message">
            <asp:Label ID="LblInfo" runat="server" Text="The 21st Century ERP-System for Garage Planning&nbsp;and Material Management!"></asp:Label>
            <asp:Label ID="LblInfopart" runat="server" Text="Market leading software and consulting ,company for Vehicle workshops, with Comprehensive and well-proven solutions for Garage Planning and Material Management."></asp:Label>
            <%-- <asp:Label ID="LblInfopartname" runat="server" Text=""></asp:Label>--%>
        </div>
        <div class="sr-only">
            <asp:Label ID="lblPageTitle" runat="server" Text="Garage Planning and Administration System"></asp:Label>
            <asp:Label Font-Size="X-Small" ID="lblLoginInfo" Font-Bold="True" runat="Server" Text="Welcome " Font-Italic="True" ForeColor="white"></asp:Label>
            <asp:Label Font-Size="Small" ID="RTLblUser" Font-Bold="True" runat="Server" ></asp:Label>
        </div>
        <div class="static-footer">
            <asp:Label ID="lblfooter" runat="server" Text="©MSG 2007 - www.modernsoftwaregroup.com - Tel +4732218340 - Fax +4732218341 "></asp:Label>
            <asp:HiddenField ID="lblHidTitle" runat="server" Value="Login Page" />
            <asp:Label ID="lblTitle" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblEdit" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblSelect" Text="--Select--" runat="server" Visible="False"></asp:Label>
        </div>
    </form>
</body>
</html>
