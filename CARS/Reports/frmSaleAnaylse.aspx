<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmSaleAnaylse.aspx.vb" Inherits="CARS.frmSaleAnaylse" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">
         function fnFrmMech() {
             if ($('#<%=ddlTMech.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlTMech.ClientID%>')[0].selectedIndex = $('#<%=ddlFMech.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }
         function fnToMech() {
             if ($('#<%=ddlFMech.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlFMech.ClientID%>')[0].selectedIndex = $('#<%=ddlTMech.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnFrmWorkCode() {
             if ($('#<%=ddlTworkcode.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlTworkcode.ClientID%>')[0].selectedIndex = $('#<%=ddlfworkcode.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnToWorkCode() {
             if ($('#<%=ddlfworkcode.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=ddlfworkcode.ClientID%>')[0].selectedIndex = $('#<%=ddlTworkcode.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }
         $(document).ready(function () {             

             $('#idMechcode').hide();
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

             $('#<%=chkmech.ClientID%>').change(function () {
                 if ($(this).is(":checked")) {
                     $('#idMechcode').show();
                 }
                 else
                 {
                     $('#idMechcode').hide();
                 }
             });
             $('#<%=btnPrint.ClientID%>').on('click', function () {
                 printReport();
             });

             $('#<%=ddlFMech.ClientID%>').change(function (e) {
                 fnFrmMech();
             });

             $('#<%=ddlTMech.ClientID%>').change(function (e) {
                 fnToMech();
             });

             $('#<%=ddlfworkcode.ClientID%>').change(function (e) {
                 fnFrmWorkCode();
             });

             $('#<%=ddlTworkcode.ClientID%>').change(function (e) {
                 fnToWorkCode();
             });
           
         });//end of ready

         function fnValidate() {
             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG111', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptTo.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex == "0")
                 if ($('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex != "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG112', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptFrom.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=ddlfworkcode.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=ddlTworkcode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG118', '', ''), '')
                     alert(msg);
                     $('#<%=ddlTworkcode.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=ddlfworkcode.ClientID%>')[0].selectedIndex == "0")
                 if ($('#<%=ddlTworkcode.ClientID%>')[0].selectedIndex != "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG117', '', ''), '')
                     alert(msg);
                     $('#<%=ddlfworkcode.ClientID%>').focus();
                     return false;
                 }


             val = $('#<%=ddlFMech.ClientID%>').val();
             if (val != undefined) {
                 if ($('#<%=ddlFMech.ClientID%>')[0].selectedIndex != "0")
                     if ($('#<%=ddlTMech.ClientID%>')[0].selectedIndex == "0") {
                         var msg = GetMultiMessage('0007', GetMultiMessage('MSG116', '', ''), '')
                         alert(msg);
                         $('#<%=ddlTMech.ClientID%>').focus();
                         return false;
                     }

                 if ($('#<%=ddlFMech.ClientID%>')[0].selectedIndex == "0")
                     if ($('#<%=ddlTMech.ClientID%>')[0].selectedIndex != "0") {
                         var msg = GetMultiMessage('0007', GetMultiMessage('MSG115', '', ''), '')
                         alert(msg);
                         $('#<%=ddlFMech.ClientID%>').focus();
                         return true;
                     }
             }

             return true;
         }


         function printReport() {
             var validate = fnValidate();
             if (validate == true) {
                 var deptFrom = $('#<%=ddlDeptFrom.ClientID%>').val();
                 var deptTo = $('#<%=ddlDeptTo.ClientID%>').val();
                 var fromDate = $('#<%=txtInvDtFrom.ClientID%>').val();
                 var toDate = $('#<%=txtInvDtTo.ClientID%>').val();
                 var fromWorkCode = $('#<%=ddlfworkcode.ClientID%>').val();
                 var toWorkCode = $('#<%=ddlTworkcode.ClientID%>').val();
                 var flgmech = $("#<%=chkmech.ClientID%>").is(':checked');
                 var fromMech = "";
                 var toMech = "";
                 if (flgmech == "True") {
                     fromMech = $('#<%=ddlFMech.ClientID%>').val();
                     toMech = $('#<%=ddlTMech.ClientID%>').val();

                 }

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmSaleAnaylse.aspx/LoadReport",
                     data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','fromWorkCode':'" + fromWorkCode + "','toWorkCode':'" + toWorkCode + "','flgmech':'" + flgmech + "','fromMech':'" + fromMech + "','toMech':'" + toMech + "'}",
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
         <asp:Label ID="lblHeader" runat="server" Text="Sales Analyse per Work code"></asp:Label>
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
                <asp:Label ID="lblfworkcode" runat="server" Text="From Work code" Width="180px"></asp:Label>
               </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="ddlfworkcode" class="dropdowns"></asp:DropDownList>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lbltworkcode" runat="server" Text="To Work code" Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="ddlTworkcode" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>
    <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
         <div class="field" style="padding:0.55em;height:40px">
             <asp:CheckBox ID="chkmech" Text="View Mechanics" runat="server" Width="200px" /> 
         </div>
     </div>
    <div id="idMechcode" class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblFmechcode" runat="server" Text="From Mechanic code" Width="180px"></asp:Label>
               </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="ddlFMech" class="dropdowns"></asp:DropDownList>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblTmechcode" runat="server" Text="To Mechanic code" Width="180px" ></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="ddlTMech" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>
     <div style="padding:0.5em"></div>
         <div class="six fields">
              <div style="text-align:center;padding-right:15em">
                  <input id="btnPrint" runat="server" class="ui button"  value="Print" type="button"  /> 
                  <input id="btnReset" runat="server" class="ui button"  value="Reset" type="button" /> 
            </div>
        </div>
    </div>
</asp:Content>