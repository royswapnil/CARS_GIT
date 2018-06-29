<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="InvoicePrintConfigSettings.aspx.vb" Inherits="CARS.InvoicePrintConfigSettings" MasterPageFile="~/SS3/Reports/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
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
            if (document.getElementById('<%=ddlInvoiceType.ClientID%>').options[document.getElementById('<%=ddlInvoiceType.ClientID%>').selectedIndex].value > "0") {
                if (document.getElementById('<%=ddlInvoiceName.ClientID%>').options[document.getElementById('<%=ddlInvoiceName.ClientID%>').selectedIndex].value == "0") {

                    alert(GetMultiMessage('MSG017', '', ''));

                    return false;
                }
            }
            



        }
      
       
    </script>

    <div class="header1" style="padding-top:0.5em">
    <asp:Label ID="lblInvConfigSett" runat="server" Text="Invoice Print Settings"></asp:Label>
        <asp:Label ID="chkk" runat="server" Width="80px"></asp:Label>
    <asp:Label id="lblError" runat="server" Text=""></asp:Label> 
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
    <asp:HiddenField id="hdnMode" runat="server" />  
</div>
<div id="divInvConfigSett" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Reports</a>  
            </div>
          <div class="eight fields tblEdt">
                  <div class="field lbl" style="padding:0.55em;height:40px">
                        <asp:Label id="lblSubsidiary" runat="server" Text="Subsidiary" Width="110px" ></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpSubsidiary" runat="server" CssClass="drpdwm" Width="150px" AutoPostBack="true">
                        </asp:DropDownList> 
                 
                        <asp:Label id="Label1" runat="server"  Width="100px" ></asp:Label> 
                        <asp:Label id="lblDepartment" runat="server" Text="Department" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="drpDepartment" runat="server" Width="150px" CssClass="drpdwm">
                        </asp:DropDownList> 
            
                        <asp:Label id="Label2" runat="server"  Width="100px" ></asp:Label>
                        <asp:Label id="lblInvoiceType" runat="server" Text="Invoice Type" Width="110px"></asp:Label><span class="mand">*</span>  
                        <asp:DropDownList id="ddlInvoiceType" runat="server" Width="150px" CssClass="drpdwm" AutoPostBack="true">
                        </asp:DropDownList> 
               </div> 
         </div>
     <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
                  <div class="field lbl" style="padding:0.55em;height:40px">
                       <asp:Label id="lblInvoice" runat="server" Text="Caption on Invoice" Width="112px"></asp:Label> 
                       <asp:TextBox id="txtInvoiceCaption" runat="server" Width="150px"  ReadOnly="True"></asp:TextBox> 
                       <asp:Label id="Label3" runat="server"  Width="100px" ></asp:Label> 
                       <asp:Label id="lblInvoiceName" runat="server" Text="Get Details on invoice from" Width="112px"></asp:Label> 
                       <asp:DropDownList id="ddlInvoiceName" runat="server" Width="150px" ToolTipID="lblInvoiceName" CssClass="drpdwm">
                       </asp:DropDownList> 
                  </div>
    </div>
    <div style="padding:1mm"></div>
    <div class="eight fields tblEdt">
        <div class="field lbl" style="padding:0.55em;height:30px">
            <asp:CheckBox id="chkLogo" runat="server" Text="Logo" Width="484px"></asp:CheckBox>
        </div>
    </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
        <div class="field lbl" style="padding:0.55em;height:40px">
            <asp:Label id="lblLocationofLogo" runat="server" Text="Location of Logo Image" Width="180px"></asp:Label> 
            <asp:FileUpload id="fileBrowseLogo" class="inp" runat="server"></asp:FileUpload>
            <asp:LinkButton id="lnkViewLogo"  runat="server" onclick="lnkViewLogo_Click"  Text="View Logo"  Width="140px" Visible="false"></asp:LinkButton>
            <asp:Label id="lblLogoAlignment" runat="server" Text="Alignment"  Width="140px"></asp:Label>
            <asp:DropDownList id="ddlLogoAlignment" runat="server" Width="105px"></asp:DropDownList>
            <asp:Label id="Label4" runat="server"  Width="100px" ></asp:Label> 
             <asp:CheckBox id="chkHeaderResize" runat="server" Text="Resize" TextAlign="left" Width="140px"></asp:CheckBox> 
        </div>
    </div>
     <div style="padding:1mm"></div>
     <div class="eight fields tblEdt">
        <div class="field lbl" style="padding:0.55em;height:30px">
            <asp:CheckBox id="chkFooter" runat="server" Text="Footer" Width="484px"></asp:CheckBox>
        </div>
    </div>
    <div class="eight fields tblEdt" style="border-bottom-width: 0px;">
        <div class="field lbl" style="padding:0.55em;height:40px">
            <asp:Label id="lblLocationofFooter" runat="server" Text="Location of Footer Image" Width="180px"></asp:Label> 
            <asp:FileUpload id="fileBrowseFooter" class="inp" runat="server"></asp:FileUpload>
            <asp:LinkButton id="lnkViewFooter"  runat="server" onclick="lnkViewFooter_Click"  Text="View Logo"  Width="140px" Visible="false"></asp:LinkButton>
            <asp:Label id="lblFooterAlignment" runat="server" Text="Alignment"  Width="140px"></asp:Label>
            <asp:DropDownList id="ddlFooterAlignment" runat="server" Width="105px"></asp:DropDownList>
            <asp:Label id="Label5" runat="server"  Width="100px" ></asp:Label> 
             <asp:CheckBox id="chkFooterResize" runat="server" Text="Resize" TextAlign="left" Width="140px"></asp:CheckBox> 
        </div>
    </div>
     <div style="padding:1mm"></div>
        <div style="text-align:center">
                <asp:Button id="btnSave" runat="server" Text="Save" CssClass="sordersbuttons1" OnClientClick="return CheckFileExtension();" > 
            </asp:Button>
        </div>
</div>

</asp:Content>

