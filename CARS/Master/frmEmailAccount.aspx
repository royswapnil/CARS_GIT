<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmEmailAccount.aspx.vb" Inherits="CARS.frmEmailAccount" MasterPageFile="~/MasterPage.Master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">

         $(document).ready(function () {
             $('#divEmailAccountConfig').hide();

             var grid = $("#dgdEmailAccountConfig");
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             //Email EmailAccountConfig
             grid.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Subsidiary', 'Name', 'E-Mail', 'SMTP', 'Port', 'Username', 'Password', 'Id_Subsidiary', 'Id_Email_Accnt',''],
                 colModel: [
                          { name: 'Subsidiary', index: 'Subsidiary', width: 150, sorttype: "string" },
                          { name: 'Setting_Name', index: 'Setting_Name', width: 200, sorttype: "string" },
                          { name: 'Email', index: 'Email', width: 200, sorttype: "string" },
                          { name: 'Smtp', index: 'Smtp', width: 150, sorttype: "string" },
                          { name: 'Port', index: 'Port', width: 45, sorttype: "string" },
                          { name: 'Username', index: 'Username', width: 250, sorttype: "string" },
                          { name: 'Password', index: 'Password', width: 350, sorttype: "string", hidden: true },
                          { name: 'Id_Subsidiary', index: 'Id_Subsidiary', width: 350, sorttype: "string", hidden: true },
                          { name: 'Id_Email_Accnt', index: 'Id_Email_Accnt', width: 350, sorttype: "string", hidden: true },
                          { name: 'Id_Email_Accnt', index: 'Id_Email_Accnt', sortable: false, formatter: editEmailAcctConfig }
                 ],
                 multiselect: true,
                 pager: jQuery('#pager'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "E-Mail Account",
                 async: false, //Very important,
                 subgrid: false

             });

             loadSubsidiary();
             loadEmailAccountConfig();

         });

         function addEmailAccountConfig() {
             $('#divEmailAccountConfig').show();
             $('#<%=btnAddT.ClientID%>').hide();
             $('#<%=btnDelT.ClientID%>').hide();
             $('#<%=btnAddB.ClientID%>').hide();
             $('#<%=btnDelB.ClientID%>').hide();
             $('#<%=btnSave.ClientID%>').show();
             $('#<%=btnReset.ClientID%>').show();
             $('#<%=txtSettingName.ClientID%>').val("");
             $('#<%=txtEmail.ClientID%>').val("");
             $('#<%=txtSMTP.ClientID%>').val("");
             $('#<%=txtPort.ClientID%>').val("");
             $('#<%=txtUsername.ClientID%>').val("");
             $('#<%=txtPassword.ClientID%>').val("");
             $('#<%=hdnMode.ClientID%>').val("Add");
             $('#<%=hdnIdEmailAcct.ClientID%>').val("0");
         }

         function resetEmailAccountConfig() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divEmailAccountConfig').hide();
                 $('#<%=btnAddT.ClientID%>').show();
                 $('#<%=btnDelT.ClientID%>').show();
                 $('#<%=btnAddB.ClientID%>').show();
                 $('#<%=btnDelB.ClientID%>').show();
                 $('#<%=btnSave.ClientID%>').hide();
                 $('#<%=btnReset.ClientID%>').hide();
                 $('#<%=txtSettingName.ClientID%>').val("");
                 $('#<%=txtEmail.ClientID%>').val("");
                 $('#<%=txtSMTP.ClientID%>').val("");
                 $('#<%=txtPort.ClientID%>').val("");
                 $('#<%=txtUsername.ClientID%>').val("");
                 $('#<%=txtPassword.ClientID%>').val("");
                 $('#<%=hdnMode.ClientID%>').val("");
                 $('#<%=hdnIdEmailAcct.ClientID%>').val("0");
             }
         }

         function editEmailAcctConfig(cellvalue, options, rowObject) {
             var idEmailAcct = rowObject.Id_Email_Accnt.toString();
             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editEmailAccountConfig(" + "'" + idEmailAcct + "'" + "); />";
             return edit;
         }

         function editEmailAccountConfig(idEmailAcct) {
             $('#divEmailAccountConfig').show();
             getEmailAccountConfig(idEmailAcct);
             $('#<%=btnAddT.ClientID%>').hide();
             $('#<%=btnDelT.ClientID%>').hide();
             $('#<%=btnAddB.ClientID%>').hide();
             $('#<%=btnDelB.ClientID%>').hide();
             $('#<%=btnSave.ClientID%>').show();
             $('#<%=btnReset.ClientID%>').show();
             $('#<%=hdnIdEmailAcct.ClientID%>').val(idEmailAcct);
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function getEmailAccountConfig(idEmailAcct) {
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmEmailAccount.aspx/GetEmailAccountConfig",
                 data: "{idEmailAcct: '" + idEmailAcct + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         $('#<%=txtSettingName.ClientID%>').val(data.d[0].Setting_Name);
                         $('#<%=txtEmail.ClientID%>').val(data.d[0].Email);
                         $('#<%=txtSMTP.ClientID%>').val(data.d[0].Smtp);
                         $('#<%=txtPort.ClientID%>').val(data.d[0].Port);
                         $('#<%=txtUsername.ClientID%>').val(data.d[0].Username);
                         $('#<%=txtPassword.ClientID%>').val(data.d[0].Password);
                     }
                 }
             });
         }

         function loadEmailAccountConfig() {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmEmailAccount.aspx/LoadEmailAccountConfig",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         jQuery("#dgdEmailAccountConfig").jqGrid('clearGridData');
                         for (i = 0; i < data.d.length; i++) {
                             mydata = data.d;
                             jQuery("#dgdEmailAccountConfig").jqGrid('addRowData', i + 1, mydata[i]);
                         }
                         jQuery("#dgdEmailAccountConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $("#dgdEmailAccountConfig").jqGrid("hideCol", "subgrid");
                     }
                 }
             });
         }

         function loadSubsidiary() {
             $.ajax({
                 type: "POST",
                 url: "frmEmailAccount.aspx/LoadSubsidiary",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     Result = Result.d;
                     $.each(Result, function (key, value) {
                         $('#<%=ddlSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                     });
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }

         function saveEmailAccountConfig() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var idEmailAccnt = $('#<%=hdnIdEmailAcct.ClientID%>').val();
             var idSubsidiary = $('#<%=ddlSubsidiary.ClientID%>').val();
             var settingName = $('#<%=txtSettingName.ClientID%>').val();
             var email = $('#<%=txtEmail.ClientID%>').val();
             var smtp = $('#<%=txtSMTP.ClientID%>').val();
             var port = $('#<%=txtPort.ClientID%>').val();
             var cryptation = "";
             var username = $('#<%=txtUsername.ClientID%>').val();
             var password = $('#<%=txtPassword.ClientID%>').val();

             var result = fnValidateEmailAccount();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmEmailAccount.aspx/SaveConfigEmailAccount",
                     data: "{idEmailAccnt: '" + idEmailAccnt + "', idSubsidiary:'" + idSubsidiary + "', settingName:'" + settingName + "', email:'" + email + "', smtp:'" + smtp + "', port:'" + port + "', cryptation:'" + cryptation + "', username:'" + username + "', password:'" + password + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         if (data.d[0] == "SUCCESS" || data.d[0] == "UPDATED") {
                             $('#divEmailAccountConfig').hide();
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddT.ClientID%>').show();
                             $('#<%=btnAddB.ClientID%>').show();
                             $('#<%=btnDelT.ClientID%>').show();
                             $('#<%=btnDelB.ClientID%>').show();
                             jQuery("#dgdEmailAccountConfig").jqGrid('clearGridData');
                             loadEmailAccountConfig();
                             jQuery("#dgdEmailAccountConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         }
                         else {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                         }
                     },
                     error: function (result) {
                         alert("Error");
                     }
                 });
             }
         }

         function fnValidateEmailAccount() {

             if (!(gfi_CheckEmpty($('#<%=txtSettingName.ClientID%>'), '0210'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtEmail.ClientID%>'), '0210'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtSMTP.ClientID%>'), '0210'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtPort.ClientID%>'), '0210'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtUsername.ClientID%>'), '0210'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtPassword.ClientID%>'), '0210'))) {
                 return false;
             }

             <%--if (!(gfb_ValidateNumbers($('#<%=txtPort.ClientID%>'), 'PORT'))) {
                 return false;
             }--%>

             if (!(gfi_ValidateNumber($('#<%=txtPort.ClientID%>'), '0071'))) {
                 $('#<%=txtPort.ClientID%>').val("");
                 $('#<%=txtPort.ClientID%>').focus();
                 return false;
             }

             if (!(gfi_ValidateEmail($('#<%=txtEmail.ClientID%>')))) {
                 $('#<%=txtEmail.ClientID%>').focus();
                 return false;
             }

             return true;
         }

         function delEmailAccountConfig() {
             var emailAccountId = "";
             $('#dgdEmailAccountConfig input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     emailAccountId = $('#dgdEmailAccountConfig tr ')[row].cells[10].innerHTML.toString();
                 }
             });

             if (emailAccountId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteEmailAccountConfig();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteEmailAccountConfig() {
             var row;
             var emailAccountId;
             var emailAccountIdxml;
             var emailAccountIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdEmailAccountConfig input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     emailAccountId = $('#dgdEmailAccountConfig tr ')[row].cells[10].innerHTML.toString();
                     emailAccountIdxml = '<Delete id_email_acct= "' + emailAccountId + '" />';
                     emailAccountIdxmls += emailAccountIdxml;
                 }
             });

             if (emailAccountIdxmls != "") {
                 emailAccountIdxmls = "<ROOT><Delete>" + emailAccountIdxmls + "</Delete></ROOT>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmEmailAccount.aspx/DeleteEmailAccount",
                     data: "{emailAccountIdxmls: '" + emailAccountIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         jQuery("#dgdEmailAccountConfig").jqGrid('clearGridData');
                         loadEmailAccountConfig();
                         jQuery("#dgdEmailAccountConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $('#divEmailAccountConfig').hide();
                         $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         }
                         else if (data.d[0] == "NDEL") {
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                         }
                     },
                     error: function (result) {
                         alert("Error");
                     }
                 });
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

     </script>

    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblEmailAccntConfig" runat="server" Text="E-Mail Account Configuration"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdEmailAcct" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >E-Mail Account Config</a>
    </div> 

    <div>
        <div style="text-align:center;padding-bottom:1em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addEmailAccountConfig()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="delEmailAccountConfig(this)"/>
        </div>  
        <div >
            <table id="dgdEmailAccountConfig" title="Email Account Configuration" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:center;padding-top:1em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addEmailAccountConfig()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="delEmailAccountConfig()"/>
        </div>

        <div id="divEmailAccountConfig" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >E-Mail Account Details</a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblSubsidiary" runat="server" Text="Subsidiary"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:DropDownList ID="ddlSubsidiary" runat="server" Width="120px"></asp:DropDownList> 
                    </div>                    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblSettingName" runat="server" Text="Setting Name"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtSettingName"  padding="0em" runat="server"></asp:TextBox>
                    </div>                    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblEmail" runat="server" Text="E-Mail"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtEmail"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblSMTP" runat="server" Text="SMTP"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtSMTP"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblPort" runat="server" Text="Port"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtPort"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblUsername" runat="server" Text="Username"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtUsername"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblPassword" runat="server" Text="Password"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtPassword"  padding="0em" runat="server" TextMode="Password"></asp:TextBox>
                    </div>          
                </div>
            </div>            

            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveEmailAccountConfig()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetEmailAccountConfig()" />
            </div>               
        </div>
    </div>


</asp:Content>