<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmInspLogWithOTDetails.aspx.vb" Inherits="CARS.frmInspLogWithOTDetails" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">
         function fnValidate() {
             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG111', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptTo.ClientID%>').focus();
                     return false;
                 }
             if ($('#<%=ddlDeptTo.ClientID%>').selectedIndex != "0")
                 if ($('#<%=ddlDeptFrom.ClientID%>').selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG112', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptFrom.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=cmbFromMechCode.ClientID%>').selectedIndex != "0")
                 if ($('#<%=cmbToMechCode.ClientID%>').selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG116', '', ''), '')
                     alert(msg);
                     $('#<%=cmbToMechCode.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=cmbToMechCode.ClientID%>').selectedIndex != "0")
                 if ($('#<%=cmbFromMechCode.ClientID%>').selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG115', '', ''), '')
                     alert(msg);
                     $('#<%=cmbFromMechCode.ClientID%>').focus();
                     return false;
                 }
             return true;
         }

         function fnFrmMechCode() {
             if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex == "0")
                 $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex = $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex;
             return true;
         }
         function fnToMechCode() {
             if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex == "0")
                 $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex = $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex;
             return true;
         }


         $(document).ready(function () {

             var dateFormat = "";
             if ($('#<%=hdnDateFormat.ClientID%>').val() == "dd.MM.yyyy") {
                 dateFormat = "dd.mm.yy"
             }
             else {
                 dateFormat = "dd/mm/yy"
             }

             $.datepicker.setDefaults($.datepicker.regional["no"]);
             $('#<%=txtInvDtFrom.ClientID%>').datepicker({
                 showButtonPanel: true,
                 changeMonth: true,
                 changeYear: true,
                 yearRange: "-50:+1",
                 dateFormat: dateFormat,
                 onSelect: function () {
                     $('#<%=txtInvDtTo.ClientID%>').val($('#<%=txtInvDtFrom.ClientID%>').val())
                 }
             });

             $.datepicker.setDefaults($.datepicker.regional["no"]);
             $('#<%=txtInvDtTo.ClientID%>').datepicker({
                 showButtonPanel: true,
                 changeMonth: true,
                 changeYear: true,
                 yearRange: "-50:+1",
                 dateFormat: dateFormat

             });

                $('#<%=btnReset.ClientID%>').on('click', function () {
                    $('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex = "0";
                    $('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex = "0";
                    $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex = "0";
                    $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex = "0";

                });
             $('#<%=cmbFromMechCode.ClientID%>').change(function (e) {
                 fnFrmMechCode();
             });

             $('#<%=cmbToMechCode.ClientID%>').change(function (e) {
                 fnToMechCode();
             });
         });//end of ready
         function printReport() {
             var validate = fnValidate();
             if (validate == true) {
                 var deptFrom = $("#<%=ddlDeptFrom.ClientID%> option:selected").text();
                 var deptTo = $("#<%=ddlDeptTo.ClientID%> option:selected").text();
                 var fromDate = $('#<%=txtInvDtFrom.ClientID%>').val();
                 var toDate = $('#<%=txtInvDtTo.ClientID%>').val();
                 var fromMecCode = ""
                 var toMecCode = "" //$('#ctl00_cntMainPanel_cmbToMechCode')[0].selectedIndex
                

                 if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex != "0") {
                     fromMecCode = $('#<%=cmbFromMechCode.ClientID%>').val();
                 }

                 if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex != "0") {
                     toMecCode = $('#<%=cmbToMechCode.ClientID%>').val();
                 }



                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmInspLogWithOTDetails.aspx/LoadReport",
                     data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','fromMecCode':'" + fromMecCode + "','toMecCode':'" + toMecCode + "'}",
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
         }
      </script>
     <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Fastprisanalyse rapport"></asp:Label>
     <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     <asp:HiddenField ID="hdnIdVehSeq" runat="server" />
     <asp:HiddenField ID="hdnPageSize" runat="server" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
</div>
     <div id="divCfInvDetails" class="ui form">
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lbldeptFrom" runat="server" Text="From Dept" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="ddlDeptFrom" class="dropdowns"></asp:DropDownList>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lbldeptTo" runat="server" Text="To Dept " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="ddlDeptTo" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>
          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblInvDtFrom" runat="server" Text="Inv.Date From" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtInvDtFrom" runat="server" Width="200px" CssClass="inp"></asp:TextBox>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblInvDtTo" runat="server" Text="Inv.Date To " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtInvDtTo" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
             </div>
        </div>
              <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblFromMechCode" runat="server" Text="From Mechanic Code" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="cmbFromMechCode" class="dropdowns"></asp:DropDownList>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblToMechCode" runat="server" Text="To Mechanic Code" Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="cmbToMechCode" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>
       <div style="padding:0.5em"></div>
         <div class="six fields">
              <div style="text-align:center;padding-right:15em">
                  <input id="btnPrint" runat="server" class="ui button"  value="Print" type="button" onclick="printReport()" /> 
                  <input id="btnReset" runat="server" class="ui button"  value="Reset" type="button" /> 
            </div>
        </div>
    </div>
</asp:Content>