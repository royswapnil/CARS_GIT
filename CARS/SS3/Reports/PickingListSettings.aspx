<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PickingListSettings.aspx.vb" Inherits="CARS.PickingListSettings" MasterPageFile="~/SS3/Reports/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript">
         function fnunload()
         {         
             return true;     
         }
         function CheckAllColumns(chk,flag)
         {
            
             if(flag == 1)
             {
                 if(document.getElementById('<%= chkDislayDepartmentInfo.ClientID%>') .checked == true)
                 {
                     EnableDept(true);
                 }
                 else
                 {
                     DisableDept(false);
                 }
        }
        else if(flag == 2)
        {
            if (document.getElementById('<%= chkCustomerInfo.ClientID%>').checked == true) {
                EnableCustomerInfo(true);
            }
            else {
                DisableCustomerInfo(false);
            }
        }
        else if(flag == 3)
        {
            if (document.getElementById('<%= chkVehicleInfo.ClientID%>').checked == true) {
                EnableVehicleInfo(true);
            }
            else {
                DisableVehicleInfo(false);
            }
        }
            
         }
         function EnableDept(VisibleType) {
             document.getElementById('<%= chkCompanyName.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyAddress.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyPhoneNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyEmail.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkOther.ClientID%>').checked = VisibleType;
         }
         function DisableDept(VisibleType) {
             document.getElementById('<%= chkCompanyName.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyAddress.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyPhoneNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCompanyEmail.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkOther.ClientID%>').checked = VisibleType;
         }
         function EnableCustomerInfo(VisibleType) {
             document.getElementById('<%= chkCustomerID.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCustomerName.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkAddressLine1.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkAddressLine2.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkZipCode.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkStateCity.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCountry.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkPhoneNoOff.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkPhoneNoRes.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkMobile.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkShowDeliveryAddress.ClientID%>').checked = VisibleType;
         }
         function DisableCustomerInfo(VisibleType) {
             document.getElementById('<%= chkCustomerID.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCustomerName.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkAddressLine1.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkAddressLine2.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkZipCode.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkStateCity.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkCountry.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkPhoneNoOff.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkPhoneNoRes.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkMobile.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkShowDeliveryAddress.ClientID%>').checked = VisibleType;
         }
         function EnableVehicleInfo(VisibleType) {
             document.getElementById('<%= chkInternalNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkRegistrationNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkVIN.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkMileage.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkModel.ClientID%>').checked = VisibleType;
         }
         function DisableVehicleInfo(VisibleType) {
             document.getElementById('<%= chkInternalNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkRegistrationNo.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkVIN.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkMileage.ClientID%>').checked = VisibleType;
             document.getElementById('<%= chkModel.ClientID%>').checked = VisibleType;
         }
         function CheckParentColumn(flag) {
             if (flag == 1) {
                 if ((document.getElementById('<%= chkCompanyName.ClientID%>').checked == true) || (document.getElementById('<%= chkCompanyAddress.ClientID%>').checked == true)||(document.getElementById('<%= chkCompanyPhoneNo.ClientID%>').checked == true)
                 || (document.getElementById('<%= chkCompanyEmail.ClientID%>').checked == true) || (document.getElementById('<%= chkOther.ClientID%>').checked == true))
                 {
                     document.getElementById('<%= chkDislayDepartmentInfo.ClientID%>').checked = true;
                 }
                 else {
                     document.getElementById('<%= chkDislayDepartmentInfo.ClientID%>').checked = false;
                 }
             }

             if (flag == 2) {
                 if ((document.getElementById('<%= chkCustomerID.ClientID%>').checked == true) || (document.getElementById('<%= chkCustomerName.ClientID%>').checked == true) || (document.getElementById('<%= chkAddressLine1.ClientID%>').checked == true)
                 || (document.getElementById('<%= chkAddressLine2.ClientID%>').checked == true) || (document.getElementById('<%= chkZipCode.ClientID%>').checked == true) || (document.getElementById('<%= chkStateCity.ClientID%>').checked == true) || (document.getElementById('<%= chkCountry.ClientID%>').checked == true)
                     || (document.getElementById('<%= chkPhoneNoOff.ClientID%>').checked == true) || (document.getElementById('<%= chkPhoneNoRes.ClientID%>').checked == true) || (document.getElementById('<%= chkMobile.ClientID%>').checked == true) || (document.getElementById('<%= chkShowDeliveryAddress.ClientID%>').checked == true) ) {

                     document.getElementById('<%= chkCustomerInfo.ClientID%>').checked = true;
                 }
                 else {
                     document.getElementById('<%= chkCustomerInfo.ClientID%>').checked = false;
                 }
             }
             if (flag == 3) {
                 if ((document.getElementById('<%= chkInternalNo.ClientID%>').checked == true) || (document.getElementById('<%= chkRegistrationNo.ClientID%>').checked == true) || (document.getElementById('<%= chkVIN.ClientID%>').checked == true)
                  || (document.getElementById('<%= chkMileage.ClientID%>').checked == true) || (document.getElementById('<%= chkModel.ClientID%>').checked == true)) {
                     document.getElementById('<%= chkVehicleInfo.ClientID%>').checked = true;
                 }
                 else {
                     document.getElementById('<%= chkVehicleInfo.ClientID%>').checked = false;
                 }
             }
         }


         function CheckFileExtension() {
             var fileLogo = document.getElementById('<%= Me.fileBrowseLogo.ClientID %>');
             var fileFooter = document.getElementById('<%= Me.fileBrowseFooter.ClientID %>');
             var validExtensions = new Array();
             validExtensions[0] = 'jpg';
             validExtensions[1] = 'jpeg';
             validExtensions[2] = 'bmp';
             validExtensions[3] = 'png';
             validExtensions[4] = 'tif';
             validExtensions[5] = 'eps';

             var logoValid = false;
             var footerValid = false;
             var ext = "";
             var notValidExt = "";

             if (fileLogo.value != "undefined") {
                 var filePath = fileLogo.value
                 if (filePath.length > 1) {
                     ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();
                     for (var i = 0; i < validExtensions.length; i++) {
                         if (!logoValid) {
                             if (ext == validExtensions[i]) logoValid = true;
                         }
                     }
                 }
                 else logoValid = true;
                 if (!logoValid) notValidExt = ext;
             }


             if (footerValid.value != "undefined") {
                 var filePath = fileFooter.value
                 if (filePath.length > 1) {
                     ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();
                     for (var i = 0; i < validExtensions.length; i++) {
                         if (!footerValid) {
                             if (ext == validExtensions[i]) footerValid = true;
                         }
                     }
                 }
                 else footerValid = true;
                 if (!footerValid) {
                     if (notValidExt != "")
                         notValidExt = notValidExt + ", " + ext;
                     else notValidExt = ext;
                 }
             }

             if (footerValid == false || logoValid == false) {
                 alert(GetMultiMessage('MSG178', '', '') + ' ' + notValidExt.toUpperCase() + ' ' + GetMultiMessage('MSG179', '', ''));
                 return false;
             }
         }
    </script>
    <div class="header1" style="padding-top:0.5em">
    <asp:Label ID="lblInvConfigSett" runat="server" Text="Picking List Settings"></asp:Label>
    <asp:Label ID="chkk" runat="server" Width="80px"></asp:Label>
    <asp:Label id="RTlblError" runat="server" Text=""></asp:Label> 
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
    <asp:HiddenField id="hdnMode" runat="server" />  
</div>
   
<div id="divInvConfigSett" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item"> Picking List Settings</a>
            </div>
     <div class="eight fields tblEdt">
                  <div class="field " style="padding:0.55em;height:40px">
                        <asp:Label id="lblSubsidiary" runat="server" Text="Subsidiary" Width="110px" ></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpSubsidiary" runat="server" CssClass="drpdwm" Width="150px" AutoPostBack="true">
                        </asp:DropDownList> 
                 
                        <asp:Label id="Label1" runat="server"  Width="100px" ></asp:Label> 
                        <asp:Label id="lblDepartment" runat="server" Text="Department" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpDepartment" runat="server" Width="150px" CssClass="drpdwm">
                        </asp:DropDownList> 
            
                        <asp:Label id="Label2" runat="server"  Width="100px" ></asp:Label>
                        <asp:Label id="lblScndryOrderTyp" runat="server" Text="Secondary Order Type" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="ddlSecondaryOrderType" runat="server" Width="150px" CssClass="drpdwm" AutoPostBack="true">
                        </asp:DropDownList> 
               </div> 
     </div>
       <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
                  <div class="field " style="padding:0.55em;height:30px">
                        <asp:CheckBox ID="chkDislayDepartmentInfo" runat="server" Text="Display Department Information"
                                                    onclick="CheckAllColumns(this,1);"></asp:CheckBox>
                 
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
                                 <asp:CheckBox ID="chkCompanyName" runat="server" Text="Company Name" Width="126px"
                                                            onclick="CheckParentColumn(1);"></asp:CheckBox>
                 
                                <asp:CheckBox ID="chkCompanyAddress" runat="server" Text="Address" Width="95px" onclick="CheckParentColumn(1);">
                                                        </asp:CheckBox>
                                 <asp:CheckBox ID="chkCompanyPhoneNo" runat="server" Text="Phone no:" Width="107px"
                                                            onclick="CheckParentColumn(1);"></asp:CheckBox>
                       
                                  <asp:CheckBox ID="chkCompanyEmail" runat="server" Text="E-Mail:" Width="115px" onclick="CheckParentColumn(1);">
                                                        </asp:CheckBox>
                                  <asp:CheckBox ID="chkOther" runat="server" Text="Other" Width="115px" onclick="CheckParentColumn(1);">
                                                        </asp:CheckBox>

              </div> 
    </div>
         <div style="padding:1mm"></div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                      <asp:CheckBox ID="chkLogo" runat="server" Text="Display Logo" Width="484px"></asp:CheckBox>
                 
                   </div> 
     </div>
    <div class="eight fields tblEdt">
            <div class="field" style="padding:0.55em;height:40px">
                     <asp:Label ID="lblLocationofLogo" runat="server" Text="Location of Logo Image" Width="170px"></asp:Label>
                     <asp:FileUpload ID="fileBrowseLogo" class="inp" runat="server"></asp:FileUpload>
                     <asp:LinkButton ID="lnkLogo" OnClick="lnkLogo_Click"  runat="server" Visible="False">View Logo</asp:LinkButton>
                 <asp:Label ID="lblAlignment" runat="server" Text="Alignment"></asp:Label>
                  <asp:DropDownList ID="ddlAlignment"  runat="server" CssClass="drpdwm" Width="105px"></asp:DropDownList>
              </div> 
    </div>
         <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkFooter" runat="server" Text="Display Footer" Width="484px"></asp:CheckBox>
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field " style="padding:0.55em;height:40px">
                     <asp:Label ID="lblFooter" runat="server" Text="Location of Footer Image" Width="170px"></asp:Label>
                     <asp:FileUpload ID="fileBrowseFooter" class="inp" runat="server"></asp:FileUpload>
                     <asp:LinkButton ID="lnkFooter" OnClick="lnkFooter_Click"  runat="server" Visible="False">View Footer</asp:LinkButton>
                   <asp:Label ID="lblFooterAlignment" runat="server" Text="Alignment"></asp:Label>
                  <asp:DropDownList ID="ddlFooterAlignment"  runat="server" CssClass="drpdwm" Width="105px"></asp:DropDownList>
              </div> 
    </div>
     <div style="padding:1mm"></div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkCustomerInfo" runat="server" Text="Display Customer Information" Width="484px" onclick="CheckAllColumns(this,2);"></asp:CheckBox>
                   </div> 
     </div>
    <div class="eight fields tblEdt">
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:CheckBox ID="chkCustomerID" runat="server" Text="Customer ID" Width="126px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                    <asp:CheckBox ID="chkCustomerName" runat="server" Text="Customer Name" Width="117px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                <asp:CheckBox ID="chkAddressLine1" runat="server" Text="Address Line1" Width="107px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                 <asp:CheckBox ID="chkAddressLine2" runat="server" Text="Address Line2" Width="115px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                <asp:CheckBox ID="chkZipCode" runat="server" Text="Zip Code" Width="115px" onclick="CheckParentColumn(2);"> </asp:CheckBox>
              </div> 
         <div class="field" style="padding:0.55em;height:40px">
                 <asp:CheckBox ID="chkStateCity" runat="server" Text="State/City" Width="126px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                    <asp:CheckBox ID="chkCountry" runat="server" Text="Country" Width="117px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                <asp:CheckBox ID="chkPhoneNoOff" runat="server" Text="Phone No (Off):" Width="107px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                 <asp:CheckBox ID="chkPhoneNoRes" runat="server" Text="Phone No (Res):" Width="115px" onclick="CheckParentColumn(2);"></asp:CheckBox>
                <asp:CheckBox ID="chkMobile" runat="server" Text="Mobile" Width="115px" onclick="CheckParentColumn(2);"> </asp:CheckBox>
              </div> 
         <div class="field" style="padding:0.55em;height:30px">
              <asp:CheckBox ID="chkShowDeliveryAddress" runat="server" Text="Show Delivery Address" Width="484px" onclick="CheckParentColumn(2);"></asp:CheckBox>
         </div>
    </div>
       <div style="padding:1mm"></div>

    <div class="eight fields tblEdt">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkVehicleInfo" runat="server" Text="Display Vehicle Information" Width="484px" onclick="CheckAllColumns(this,3);"></asp:CheckBox>
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
                   <asp:CheckBox ID="chkInternalNo" runat="server" Text="Internal No" Width="126px" onclick="CheckParentColumn(3);"></asp:CheckBox>
                <asp:CheckBox ID="chkRegistrationNo" runat="server" Text="Registration No" Width="117px" onclick="CheckParentColumn(3);"></asp:CheckBox>
                 <asp:CheckBox ID="chkVIN" runat="server" Text="VIN" Width="107px" onclick="CheckParentColumn(3);"> </asp:CheckBox>
                  <asp:CheckBox ID="chkMileage" runat="server" Text="Mileage" Width="115px" onclick="CheckParentColumn(3);"></asp:CheckBox>
                  <asp:CheckBox ID="chkModel" runat="server" Text="Model" Width="115px" onclick="CheckParentColumn(3);"></asp:CheckBox>
              </div> 
    </div>
    <div style="padding:1mm"></div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkAnnotation" runat="server" Text="Annotation" Width="484px"></asp:CheckBox>
                   </div> 
     </div>
         <div style="padding:1mm"></div>

     <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                      <asp:Label ID="lblPrinterSettings" runat="server" Text="Printer Settings" Width="147px"></asp:Label>
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblDefaultPrinter" runat="server" Text="Default Printer" Width="79px"></asp:Label>
                <asp:DropDownList ID="ddlDefaultPrinter" ToolTipID="lblDefaultPrinter" runat="server" CssClass="drpdwm" Width="126px" AutoPostBack="True"></asp:DropDownList>
                <asp:Label ID="Label3" runat="server" Text="" Width="79px"></asp:Label>
                <asp:Label ID="lblLocation" runat="server" Text="Location" class="lbl"></asp:Label>
                <asp:TextBox ID="txtLocation" runat="server"  Text="" CssClass="inp" Width="108px"></asp:TextBox>
            </div> 
    </div>
     <div style="padding:0.5mm"></div>
        <div style="text-align:center">
                <asp:Button id="btnSave" runat="server" Text="Save" CssClass="sordersbuttons1" OnClientClick="return CheckFileExtension();" > 
            </asp:Button>
        </div>
</div>
          
</asp:Content>