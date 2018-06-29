<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfChangePwd.aspx.vb" MasterPageFile="~/MasterPage.Master" Inherits="CARS.frmCfChangePwd" Title="Change Password" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
      <script type="text/javascript">

        $(document).ready(function () {
            $('#<%=txtOldPassword.ClientID%>').focus();
        });

        function SavePwdDet() {
            if (!(gfi_CheckEmpty($('#<%=txtOldPassword.ClientID%>'), '0999')))
                return false;
            if (!(gfi_CheckEmpty($('#<%=txtNewPassword.ClientID%>'), '0139')))
                return false;
            if (!(gfi_CheckEmpty($('#<%=txtConfirm.ClientID%>'), '0136')))
                return false;
            if (!(gfb_ValidateAlphabets($('#<%=txtNewPassword.ClientID%>'), '0139')))
                return false;
            if (!(gfb_ValidateAlphabets($('#<%=txtConfirm.ClientID%>'), '0136')))
                return false;
            if ($('#<%=txtNewPassword.ClientID%>').val() != $('#<%=txtConfirm.ClientID%>').val() || $('#<%=txtNewPassword.ClientID%>').val().length != $('#<%=txtConfirm.ClientID%>').val().length) {
                var msg = GetMultiMessage('0137', '', '');
                alert(msg);
                $('#<%=txtConfirm.ClientID%>').val('');
                $('#<%=txtConfirm.ClientID%>').focus();
                return false;
            }
            var oldPwd = $('#<%=txtOldPassword.ClientID%>').val();
            var newPwd = $('#<%=txtNewPassword.ClientID%>').val();
            if (oldPwd == newPwd) {
                var mess = GetMultiMessage('SAME_PWD', '', '');
                alert(mess); //SAME_PWD
            }
            else {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfChangePwd.aspx/SavePassword",
                    data: "{Login: '" + $('#<%=txtLoginName.ClientID%>').val() + "', NewPassword:'" + $('#<%=txtNewPassword.ClientID%>').val() + "', OldPassword:'" + $('#<%=txtOldPassword.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d[0].Updated == "") {
                            $('#<%=RTlblError.ClientID%>').text(data.d[0].NotUpdated);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(data.d[0].Updated);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $("#btnSave").attr("disabled", "disabled");
                            $("#btnReset").attr("disabled", "disabled");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }

        function ResetPwdDet() {
            $('#<%=txtOldPassword.ClientID%>').val('');
            $('#<%=txtNewPassword.ClientID%>').val('');
            $('#<%=txtConfirm.ClientID%>').val('');
            $('#<%=RTlblError.ClientID%>').text('');
        }

    </script>

    <div class="header1" style="padding-top:0.5em">
              <asp:Label ID="lblChngPwd" runat="server" Text="Change Password"></asp:Label>
        </div>
         <div class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server">Change Password</a>
            </div>
            <div class="field">
                <asp:Label ID="RTlblError" runat="server" ></asp:Label>
            </div>
            <br />
            <div class="ui form" style="max-width: 35%">
                <div class="two fields">
                    <div class="field" style="padding-left: 0.5em;padding-top:0.5em">
                        <asp:Label id="lblLoginName" runat="server" Text="Login Name"></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="txtLoginName" runat="server" class="fieldTextbox" Width="184px"></asp:TextBox>
                    </div>

                    <div class="field" style="padding-top:0.5em">
                        <asp:Label id="lblOldPassword" runat="server" Text="Old Password"><span class="mand">*</span></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password" class="fieldTextbox" Width="184px"></asp:TextBox>
                    </div>

                    <div class="field" style="padding-top:0.5em">
                        <asp:Label id="lblNewPassword" runat="server" Text="New Password"><span class="mand">*</span></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" class="fieldTextbox" Width="184px"></asp:TextBox>
                    </div>

                    <div class="field" style="padding-top:0.5em">
                        <asp:Label id="lblConfirmPassword" runat="server" Text="Password Confirm"><span class="mand">*</span></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" class="fieldTextbox" Width="184px"></asp:TextBox>
                    </div>
                </div>
                <input id="btnSave" class="ui blue button" value="Save" onclick="SavePwdDet();"  type="button" runat="server"/>
                <input id="btnReset" class="ui button" value="Reset" type="button" style="background-color: #E0E0E0"  onclick="ResetPwdDet();" runat="server" />
            </div>
        </div>


</asp:Content>


