<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DeliveryNoteSettings.aspx.vb" Inherits="CARS.DeliveryNoteSettings" MasterPageFile="~/SS3/Reports/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script  type="text/javascript">
         function fnunload()
         {         
             return true;     
         }
         function CheckAllColumns(chk,flag)
         {
            
             if(flag == 1)
             {
                 if(document.getElementById('<%= chkDislaySubsidiaryInfo.ClientID%>') .checked == true)
                 {
                     EnableSub(true);
                 }
                 else
                 {
                     DisableSub(false);
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
       }
        function EnableSub(VisibleType) {
            document.getElementById('<%= chkCompanyName.ClientID%>').checked = VisibleType;
            document.getElementById('<%= chkCompanyAddress.ClientID%>').checked = VisibleType;
            document.getElementById('<%= chkCompanyPhoneNo.ClientID%>').checked = VisibleType;
            document.getElementById('<%= chkCompanyEmail.ClientID%>').checked = VisibleType;
            document.getElementById('<%= chkOther.ClientID%>').checked = VisibleType;
        }
        function DisableSub(VisibleType) {
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
        function checkLength(oObject, len) {

            if (oObject.value.length < len)
                return true;
            else {

                if ((event.keyCode >= 37 && event.keyCode <= 40) || (event.keyCode == 8) || (event.keyCode == 46) || (event.keyCode == 36) || (event.keyCode == 16) || (event.keyCode == 35))
                    event.returnValue = true;
                else
                    event.returnValue = false;
            }

        }
    </script>
 <div class="header1" style="padding-top:0.5em">
    <asp:Label ID="lbltitle" runat="server" Text="Delivery Note Settings"></asp:Label>
    <asp:Label ID="chkk" runat="server" Width="80px"></asp:Label>
    <asp:Label id="RTlblError" runat="server" Text=""></asp:Label> 
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
    <asp:HiddenField id="hdnMode" runat="server" />  
</div>
    <div id="divDelvSett" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Delivery Note Settings</a>
            </div>
     <div class="eight fields tblEdt">
                  <div class="field " style="padding:0.55em;height:40px">
                        <asp:Label id="lblSubsidiary" runat="server" Text="Subsidiary" Width="110px" ></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpSubsidiary" runat="server"  Width="150px" AutoPostBack="true">
                        </asp:DropDownList> 
                 
                        <asp:Label id="Label1" runat="server"  Width="100px" ></asp:Label> 
                        <asp:Label id="lblDepartment" runat="server" Text="Department" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpDepartment" runat="server" Width="150px" >
                        </asp:DropDownList> 
            
                        <asp:Label id="Label2" runat="server"  Width="100px" ></asp:Label>
                        <asp:Label id="lblScndryOrderTyp" runat="server" Text="Secondary Order Type" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="ddlSecondaryOrderType" runat="server" Width="150px"  AutoPostBack="true">
                        </asp:DropDownList> 
               </div> 
     </div>
      <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
                  <div class="field " style="padding:0.55em;height:30px">
                        <asp:CheckBox ID="chkDislaySubsidiaryInfo" runat="server" Text="Display Subsidiary Information" onclick="CheckAllColumns(this,1);"></asp:CheckBox>
                 
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field " style="padding:0.55em;height:40px">
                                 <asp:CheckBox ID="chkCompanyName" runat="server" Text="Company Name" Width="126px" ></asp:CheckBox>
                 
                                <asp:CheckBox ID="chkCompanyAddress" runat="server" Text="Address" Width="95px">
                                                        </asp:CheckBox>
                                 <asp:CheckBox ID="chkCompanyPhoneNo" runat="server" Text="Phone no:" Width="107px"></asp:CheckBox>
                       
                                  <asp:CheckBox ID="chkCompanyEmail" runat="server" Text="E-Mail:" Width="115px">
                                                        </asp:CheckBox>
                                  <asp:CheckBox ID="chkOther" runat="server" Text="Other" Width="115px">
                                                        </asp:CheckBox>

              </div> 
    </div>
    <div style="padding:1mm"></div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field " style="padding:0.55em;height:30px">
                      <asp:CheckBox ID="chkLogo" runat="server" Text="Display Logo" Width="484px"></asp:CheckBox>
                 
                   </div> 
     </div>
    <div class="eight fields tblEdt">
            <div class="field" style="padding:0.55em;height:40px">
                     <asp:Label ID="lblLocationofLogo" runat="server" Text="Location of Logo Image" Width="170px"></asp:Label>
                     <asp:FileUpload ID="fileBrowseLogo" class="inp" runat="server"></asp:FileUpload>
                     <asp:LinkButton ID="lnkLogo" OnClick="lnkLogo_Click" runat="server" Visible="False">View Logo</asp:LinkButton>
                <asp:Label id="Label5" runat="server"  Width="100px" ></asp:Label>
                 <asp:Label ID="lblAlignment" runat="server" Text="Alignment"></asp:Label>
                  <asp:DropDownList ID="ddlAlignment"  runat="server"  Width="105px"></asp:DropDownList>
              </div> 
    </div>
         <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkFooter" runat="server" Text="Display Footer" Width="484px"></asp:CheckBox>
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
                     <asp:Label ID="lblFooter" runat="server" Text="Location of Footer Image" Width="170px"></asp:Label>
                     <asp:FileUpload ID="fileBrowseFooter" class="inp" runat="server"></asp:FileUpload>
                     <asp:LinkButton ID="lnkFooter" OnClick="lnkFooter_Click"  runat="server" Visible="False">View Footer</asp:LinkButton>
                <asp:Label id="Label4" runat="server"  Width="100px" ></asp:Label>
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
                 <asp:CheckBox ID="chkCustomerID" runat="server" Text="Customer ID" Width="126px" ></asp:CheckBox>
                    <asp:CheckBox ID="chkCustomerName" runat="server" Text="Customer Name" Width="117px"></asp:CheckBox>
                <asp:CheckBox ID="chkAddressLine1" runat="server" Text="Address Line1" Width="107px"></asp:CheckBox>
                 <asp:CheckBox ID="chkAddressLine2" runat="server" Text="Address Line2" Width="115px"></asp:CheckBox>
                <asp:CheckBox ID="chkZipCode" runat="server" Text="Zip Code" Width="115px"> </asp:CheckBox>
              </div> 
         <div class="field" style="padding:0.55em;height:40px">
                 <asp:CheckBox ID="chkStateCity" runat="server" Text="State/City" Width="126px"></asp:CheckBox>
                    <asp:CheckBox ID="chkCountry" runat="server" Text="Country" Width="117px"></asp:CheckBox>
                <asp:CheckBox ID="chkPhoneNoOff" runat="server" Text="Phone No (Off):" Width="107px"></asp:CheckBox>
                 <asp:CheckBox ID="chkPhoneNoRes" runat="server" Text="Phone No (Res):" Width="115px"></asp:CheckBox>
                <asp:CheckBox ID="chkMobile" runat="server" Text="Mobile" Width="115px"></asp:CheckBox>
              </div> 
         <div class="field" style="padding:0.55em;height:30px">
              <asp:CheckBox ID="chkShowDeliveryAddress" runat="server" Text="Show Delivery Address" Width="484px"></asp:CheckBox>
         </div>
    </div>
     <div style="padding:1mm"></div>
    <div class="eight fields" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:CheckBox ID="chkAnnotation" runat="server" Text="Annotation" Width="484px"></asp:CheckBox>
                   </div> 
     </div>
    <div style="padding:1mm"></div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                     <asp:Label ID="lblDeliveryNoteSettings" runat="server" Text="Delivery Note Settings" Width="146px"></asp:Label>
                   </div> 
     </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
                <asp:CheckBox ID="chkReadytoInvoice" runat="server" Text="Ready to Invoice"  Width="126px" />
                <asp:CheckBox ID="chkDiscount" runat="server" Text="Discount %"  Width="126px" />
                <asp:CheckBox ID="chkDeliveredLines" runat="server" Text="Delivered Lines"  Width="126px" />
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
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
                  <div class="field" style="padding:0.55em;height:30px">
                      <asp:CheckBox ID="chkCommercialText" runat="server" Text="Display Commercial/Warning Text" Width="484px"></asp:CheckBox>
                   </div> 
     </div>
     <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
            <div class="field" style="padding:0.55em;height:40px">
               <asp:Label ID="lblCommercialText" runat="server" Text="Commercial/Warning Description"></asp:Label>
               <asp:TextBox ID="txtCommercial" runat="server" TextMode="MultiLine" ToolTipID="lblCommercial" CssClass="inp"
                                                    Width="600px" MaxLength="500" onkeydown="javascript:checkLength(this,500);" ></asp:TextBox>
            </div> 
    </div>

     <div style="padding:0.5mm"></div>
        <div style="text-align:center">
                <asp:Button id="btnSave" runat="server" Text="Save" CssClass="sordersbuttons1" OnClientClick="return CheckFileExtension();" > 
            </asp:Button>
        </div>
     
</div>
</asp:Content>