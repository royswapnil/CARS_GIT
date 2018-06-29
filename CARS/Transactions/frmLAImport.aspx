<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLAImport.aspx.vb" Inherits="CARS.frmLAImport" MasterPageFile="~/MasterPage.Master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblHeader" runat="server" Text="Import"></asp:Label>
        <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
          <asp:Label ID="RTlblError" runat="server" CssClass="lblErr"></asp:Label>
    </div>
    <div id="divImport" class="ui form">
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:40px">
          <div class="field" style="padding:0.55em;height:40px">
             <asp:RadioButtonList ID="rdLstImport" runat="server" RepeatDirection="Horizontal" Width="500px" Height="30px">
                     <asp:ListItem Text="Customer Balance" Selected="True" Value="Customer Balance"  />
                      <asp:ListItem Text="Customer Information"  Value="Customer Information"  />
              </asp:RadioButtonList>  
          </div>
        </div>
        <div style="padding:0.5em"></div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:40px">
          <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblAccSys" runat="server" Text="Account System" Width="180px"></asp:Label>
            </div>
           <div class="field" style="padding:0.55em;height:40px">
              <select id="ddlAccSys" runat="server" class="dropdowns" style="width:180px" >
                            <option value="0">Velg..</option>
                            <option value="1">CSV</option>
   
           </select>
          </div>
        </div>
    </div>
   <div class="ui secondary vertical menu" style="width: 100%; background-color: #cce2ff">
   <a class="active item" runat="server" id="aType" style="background-color: transparent">Select File</a>
 </div>
    <div id="divImportFile" class="ui form">
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:40px;width:475px">
          <div class="field" style="padding:0.55em;height:40px">
              <asp:Label ID="lblOpen" runat="server" Text="Open" Width="180px"></asp:Label>
            </div>
           <div class="field" style="padding:0.55em;height:40px">
              <asp:FileUpload ID="FlUpload" runat="server" />
          </div>
        </div>
    </div>
     <div class="ui raised segment signup inactive" style="text-align:center;height:50px;padding-bottom:3em">
  <%--        <input id="BtnErrlog" runat="server" class="ui button"  value="ErrorLog" type="button" style="background-color: #E0E0E0" />
         <input id="BtnImp" runat="server" class="ui button"  value="Import" type="button" style="background-color: #E0E0E0" />--%>
         <asp:Button ID="BtnImpt" runat="server" class="ui button" Text="Import" style="background-color: #E0E0E0" />
     </div>
</asp:Content>