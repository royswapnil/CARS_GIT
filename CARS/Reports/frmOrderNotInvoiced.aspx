<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmOrderNotInvoiced.aspx.vb" Inherits="CARS.frmOrderNotInvoiced" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">

         function fnFrmDept() {
             if ($('#<%=ddlDepartmentT.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlDepartmentT.ClientID%>')[0].selectedIndex = $('#<%=ddlDepartmentF.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnToDept() {
             if ($('#<%=ddlDepartmentF.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlDepartmentF.ClientID%>')[0].selectedIndex = $('#<%=ddlDepartmentT.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnFromStatus() {
             if ($('#<%=cmbStatusTo.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbStatusTo.ClientID%>')[0].selectedIndex = $('#<%=cmbStatusFrom.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnToStatus() {
             if ($('#<%=cmbStatusFrom.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbStatusFrom.ClientID%>')[0].selectedIndex = $('#<%=cmbStatusTo.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }


         $(document).ready(function () {

             var dateFormat = "";
             if ($('#<%=hdnDateFormat.ClientID%>').val() == "dd.MM.yyyy") {
                 dateFormat = "dd.mm.yy"
             }
             else {
                 dateFormat = "dd/mm/yy"
             }

             $(function () {
                 $('.ui.dropdown').dropdown();
             });

             $.datepicker.setDefaults($.datepicker.regional["no"]);
             $('#<%=txtDateFrom.ClientID%>').datepicker({
                 showButtonPanel: true,
                 changeMonth: true,
                 changeYear: true,
                 yearRange: "-50:+1",
                 dateFormat: dateFormat
             });

             $.datepicker.setDefaults($.datepicker.regional["no"]);
             $('#<%=txtDateTo.ClientID%>').datepicker({
                 showButtonPanel: true,
                 changeMonth: true,
                 changeYear: true,
                 yearRange: "-50:+1",
                 dateFormat: dateFormat
             });

             $('#<%=txtDateFrom.ClientID%>').keyup(function () {
                 if ($(this).val().length == 2 || $(this).val().length == 5) {
                     $(this).val($(this).val() + $('#<%=hdnDateFormatLang.ClientID%>').val());
                 }
             });

             $('#<%=txtDateTo.ClientID%>').keyup(function () {
                 if ($(this).val().length == 2 || $(this).val().length == 5) {
                     $(this).val($(this).val() + $('#<%=hdnDateFormatLang.ClientID%>').val());
                 }
             });


             $('#<%=btnPrint.ClientID%>').on('click', function () {
                 printReport();
             });

         }); // end of ready

         function printReport() {
             var deptFrom = $("#<%=ddlDepartmentF.ClientID%> option:selected").text();
             var deptTo = $("#<%=ddlDepartmentT.ClientID%> option:selected").text();
             var fromDate = $('#<%=txtDateFrom.ClientID%>').val();
             var toDate = $('#<%=txtDateTo.ClientID%>').val();            
             var statusFrom = $('#<%=cmbStatusFrom.ClientID%>').val();
             var statusTo = $('#<%=cmbStatusTo.ClientID%>').val();

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmOrderNotInvoiced.aspx/LoadReport",
                 data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','statusFrom':'" + statusFrom + "','statusTo':'" + statusTo + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (Result) {
                     if (Result.d.length > 0) {
                         var strValue = Result.d;
                         if (strValue != "") {
                             var Url = strValue;//"../Reports/frmShowReports.aspx?ReportHeader=YF8c/MYCthcdMZ0D0ra6EQ==&InvoiceType=YF8c/MYCthcdMZ0D0ra6EQ==&Rpt=GPwu6EpyNgg8JACPpv3cVA==&scrid=" + WoPr + WoNo + "&JobCardSett=1"
                             window.open(Url, 'Reports', "menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");
                         }
                     }
                 }
             });
         }


     </script>

    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblHeader" runat="server" Text="Order Not Invoiced"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server" />
         <asp:HiddenField ID="hdnDateFormatLang" Value="<%$ appSettings:DateFormatLang %>" runat="server" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
    </div>
    <div id="divInvConfigSett" class="ui form">
       
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <div class="field" style="padding:0.55em;height:40px">
                <asp:Label id="lblDepartmentF" runat="server" Text="Fra avdeling" Width="90px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">  
                <asp:DropDownList id="ddlDepartmentF" runat="server" Width="150px" CssClass="dropdowns"></asp:DropDownList> 
            </div>
            <div class="field" style="padding:0.55em;height:40px">     
                <asp:Label id="lblDepartmentT" runat="server" Text="Til avdeling" Width="90px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                <asp:DropDownList id="ddlDepartmentT" runat="server" Width="150px" CssClass="dropdowns"></asp:DropDownList>
            </div>
         </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px"> 
             <div class="field" style="padding:0.55em;height:40px" >               
                 <asp:Label id="lblDateFrom" runat="server" Text="Dato opprettet fra" Width="110px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:TextBox ID="txtDateFrom" runat="server" Width="150px" MaxLength="25" Columns="50" ></asp:TextBox>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:Label id="lblDateTo" runat="server" Text="Dato opprettet til" Width="110px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:TextBox ID="txtDateTo" runat="server" Width="150px" MaxLength="25" Columns="50"></asp:TextBox>
            </div> 
        </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <div class="field" style="padding:0.55em;height:40px">               
                 <asp:Label id="lblStatusFrom" runat="server" Text="Fra status" Width="110px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px" >
                 <asp:DropDownList id="cmbStatusFrom" runat="server" Width="150px" CssClass="dropdowns"></asp:DropDownList> 
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:Label id="lblStatusTo" runat="server" Text="Til status" Width="110px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList id="cmbStatusTo" runat="server" Width="150px" CssClass="dropdowns"></asp:DropDownList> 
            </div> 
        </div>
         <div style="padding:0.5em"></div>
        <div class="inline fields" style="padding-left:30em;">
            <input runat="server" type="button" value="Print"  class="ui button"  id="btnPrint" />
            <input runat="server" type="button" value="Cancel" class="ui button"  id="btnCancel" />
        </div>



    </div>

</asp:Content>