<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWOMoreCustInfo.aspx.vb" Inherits="CARS.frmWOMoreCustInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Information</title>
 <script type="text/javascript" src="../javascripts/jquery-1.10.2.min.js"></script>
     <script type="text/javascript" src="../javascripts/jquery-ui.js"></script>
     <script type="text/javascript" src="../javascripts/jquery-ui-i18n.min.js"></script>
     <script type="text/javascript" src="../semantic/semantic.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-migrate-1.2.1.js"></script>
     <script type="text/javascript" src="../javascripts/grid.locale-no.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.min.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.src.js"></script>
    <script type="text/javascript" src="../javascripts/json2-min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../javascripts/Msg.js"></script>
     <link href= "../CSS/ui.jqgrid.css" rel="stylesheet" type="text/css"/>
     <link href= "../CSS/jquery-ui.css" rel="stylesheet" type="text/css"/>
     <link href= "../semantic/semantic.min.css" rel="stylesheet" type="text/css"/>
    <link href= "../CSS/Msg.css" rel="stylesheet" type="text/css"/>
     <script>
         $(document).ready(function () {
             function GetParameterValues() {
                 var vars = [], hash;
                 var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                 for (var i = 0; i < hashes.length; i++) {
                     hash = hashes[i].split('=');
                     vars.push(hash[0]);
                     vars[hash[0]] = hash[1];
                 }
                 return vars;
             }
             var custId = GetParameterValues()["vid"];
             $(document.getElementById('<%=hdnIdCust.ClientID%>')).val(custId);
             FillPriceCode();
             FillDiscCode();
             LoadCustDet(custId);
             $('#<%=btnClose.ClientID%>').click(function () {
                 window.close();
             });
            
         });
         function LoadCustDet(CustID) {
             var idCustomer = CustID;
             $.ajax({
                 type: "POST",
                 url: "frmWOMoreCustInfo.aspx/LoadCustDetails",
                 data: "{'IdCustomer':'" + CustID + "'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                  
                     $('#<%=txtCreditLimit.ClientID%>').val(Result.d[0].Cust_Credit_Limit);
                     $('#<%=txtContactPerson.ClientID%>').val(Result.d[0].Cust_Contactperson);
                     $('#<%=txtCustPhone.ClientID%>').val(Result.d[0].WO_Cust_Phone_Home);
                     $('#<%=txtOffPhone.ClientID%>').val(Result.d[0].WO_Cust_Phone_Off);
                     $('#<%=txtFaxNo.ClientID%>').val(Result.d[0].Cust_Fax);
                     $('#<%=txtCustEmail.ClientID%>').val(Result.d[0].Cust_Email);
                     $('#<%=txtMobileNo.ClientID%>').val(Result.d[0].WO_Cust_Phone_Mobile);
                     if (Result.d[0].Cust_Pricecode == 0) {
                         $('#<%=ddlPriceCode.ClientID%>')[0].selectedIndex = 0;
                     }
                     else {
                         $('#<%=ddlPriceCode.ClientID%> option:contains("' + Result.d[0].Cust_Pricecode + '")').attr('selected', 'selected');
                     }
                     $('#<%=txtAccNo.ClientID%>').val(Result.d[0].Cust_Account_No);
                     $('#<%=txtDtInvoiced.ClientID%>').val(Result.d[0].LastInvDate);
                     if (Result.d[0].Cust_Discount_Code == 0) {
                         $('#<%=ddlDiscode.ClientID%>')[0].selectedIndex = 0;
                     }
                     else {
                         $('#<%=ddlDiscode.ClientID%> option:contains("' + Result.d[0].Cust_Discount_Code + '")').attr('selected', 'selected');
                     }
                    

                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function FillPriceCode() {
             $.ajax({
                 type: "POST",
                 url: "frmWOMoreCustInfo.aspx/LoadlPriceCode",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     Result = Result.d;
                     $('#<%=ddlPriceCode.ClientID%>').empty();
                     $('#<%=ddlPriceCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                     $.each(Result, function (key, value) {
                         $('#<%=ddlPriceCode.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

                     });

                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function FillDiscCode() {
             $.ajax({
                 type: "POST",
                 url: "frmWOMoreCustInfo.aspx/LoadlDiscCode",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     Result = Result.d;
                     $('#<%=ddlDiscode.ClientID%>').empty();
                     $('#<%=ddlDiscode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                     $.each(Result, function (key, value) {
                         $('#<%=ddlDiscode.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

                     });

                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function UpdateCustInfo() {
             var custId = $(document.getElementById('<%=hdnIdCust.ClientID%>')).val();
             $.ajax({
                 type: "POST",
                 url: "frmWOMoreCustInfo.aspx/UpdateCustInfo",
                 data: "{custID: '" + custId + "',custContactPer: '" + $('#<%=txtContactPerson.ClientID%>').val() + "', custCreditLimit:'" + $('#<%=txtCreditLimit.ClientID%>').val() + "', custPhoneHome:'" + $('#<%=txtCustPhone.ClientID%>').val() + "', custPhoneOff:'" + $('#<%=txtOffPhone.ClientID%>').val() + "', custFax:'" + $('#<%=txtFaxNo.ClientID%>').val() + "', custPhoneMobile:'" + $('#<%=txtMobileNo.ClientID%>').val() + "', custEmail:'" + $('#<%=txtCustEmail.ClientID%>').val() + "',custPriceCode:'" + $('#<%=ddlPriceCode.ClientID%>').val() + "',custAccountNo:'" + $('#<%=txtAccNo.ClientID%>').val() + "',custDiscCode:'" + $('#<%=ddlDiscode.ClientID%>').val() + "'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     if( Result.d[0] == "True")
                     {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                     }
                     else
                     {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }


                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });

         }
     </script>
</head>
<body>
    <form id="form1" runat="server">
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
         <a class="active item" runat="server" id="aAddrComm">Customer Information</a>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnIdCust" runat="server" />
     </div>
     <div class="ui form">
             <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblContactPerson" runat="server" Text="Contact Person"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtContactPerson" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
         <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblCreditLimit" runat="server" Text="Credit Limit"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtCreditLimit" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
         <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblCustPhone" runat="server" Text="Phone 1"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtCustPhone" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
          <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblOffPhone" runat="server" Text="Phone 2"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtOffPhone" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
          <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblFaxNo" runat="server" Text="Phone 2"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtFaxNo" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
           <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblCustEmail" runat="server" Text="Email"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtCustEmail" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
          <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblMobileNo" runat="server" Text="Mobile No"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtMobileNo" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
           <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblPriceCode" runat="server" Text="Price Code"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:DropDownList ID="ddlPriceCode" runat="server" Width="200px"></asp:DropDownList>
                    </div>
             </div>
           <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblAccountNo" runat="server" Text="Account No"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtAccNo" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
           <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDtInvoiced" runat="server" Text="Date Last Invoiced"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtDtInvoiced" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
          <br />
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDisCode" runat="server" Text="Discount Code"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:DropDownList ID="ddlDiscode" runat="server" Width="200px"></asp:DropDownList>
                    </div>
             </div>
          <div id="divCustInfo" style="text-align:center">
                    <input id="btnUpdate" runat="server" class="ui button"  value="Update" type="button" onclick="UpdateCustInfo()" />
                    <input id="btnClose" runat="server" class="ui button" value="Close" type="button" style="background-color: #E0E0E0"  />
           </div>   
         </div>
     <asp:HiddenField ID="hdnSelect" runat="server" />
    </form>
</body>
</html>
