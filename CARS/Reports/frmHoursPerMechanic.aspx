<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmHoursPerMechanic.aspx.vb" Inherits="CARS.frmHoursPerMechanic" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">
         function fnFrmMonth() {
             if ($('#<%=cmbToMonth.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbToMonth.ClientID%>')[0].selectedIndex = $('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }
         function fnToMonth() {
             if ($('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex = $('#<%=cmbToMonth.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnFrmMech() {
             if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex = $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }
         function fnToMech() {
             if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex == "0") {
                 $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex = $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex;
                 return true;
             }
         }

         function fnValidate() {
             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG111', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptTo.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedText > $('#<%=ddlDeptTo.ClientID%>')[0].selectedText) {
                 var message = GetMultiMessage('0007', GetMultiMessage('MSG111', '', ''), '')
                 message = message + GetMultiMessage('MSG119', GetMultiMessage('MSG112', '', ''), '');
                 $('#<%=ddlDeptTo.ClientID%>').focus();
                 return false;
             }

             if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG112', '', ''), '')
                     alert(msg);
                     $('#<%=ddlDeptFrom.ClientID%>')[0].focus();
                     return false;
                 }
             if ($('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=cmbToMonth.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG114', '', ''), '')
                     alert(msg);
                     $('#<%=cmbToMonth.ClientID%>').focus();
                     return false;
                 }
             if ($('#<%=cmbToMonth.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG113', '', ''), '')
                     alert(msg);
                     $('#<%=cmbFrmMonth.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG116', '', ''), '')
                     alert(msg);
                     $('#<%=cmbToMechCode.ClientID%>').focus();
                     return false;
                 }

             if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex != "0")
                 if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('MSG115', '', ''), '')
                     alert(msg);
                     $('#<%=cmbFromMechCode.ClientID%>').focus();
                     return false;
                 }
             return true;
         }

         $(document).ready(function () {
             $('#<%=btnReset.ClientID%>').on('click', function () {
                 $('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=cmbToMonth.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=cmbYear.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex = "0";
                 $('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex = "0";
             });

             $('#<%=cmbFromMechCode.ClientID%>').change(function (e) {
                 fnFrmMech();
             });

             $('#<%=cmbToMechCode.ClientID%>').change(function (e) {
                 fnToMech();
             });

             $('#<%=cmbFrmMonth.ClientID%>').change(function (e) {
                 fnFrmMonth();
             });

             $('#<%=cmbToMonth.ClientID%>').change(function (e) {
                 fnToMonth();
             });


         });//end of ready

        function printReport() {
            var validate = fnValidate();
            if (validate == true) {
                var deptFrom = $("#<%=ddlDeptFrom.ClientID%> option:selected").text();
                var deptTo = $("#<%=ddlDeptTo.ClientID%> option:selected").text();
                var year = "";
                var fromMnth = "";
                var toMnth = "";
                var fromMecCode = ""
                var toMecCode = "" //$('#ctl00_cntMainPanel_cmbToMechCode')[0].selectedIndex
                if ($('#<%=cmbYear.ClientID%>')[0].selectedIndex != "0") {
                    year = $('#<%=cmbYear.ClientID%>').val();
                }

                if ($('#<%=cmbFrmMonth.ClientID%>')[0].selectedIndex != "0") {
                    fromMnth = $('#<%=cmbFrmMonth.ClientID%>').val();
                }

                if ($('#<%=cmbToMonth.ClientID%>')[0].selectedIndex != "0") {
                    toMnth = $('#<%=cmbToMonth.ClientID%>').val();
                }

                if ($('#<%=cmbFromMechCode.ClientID%>')[0].selectedIndex != "0") {
                    fromMecCode = $('#<%=cmbFromMechCode.ClientID%>').val();
                }

                if ($('#<%=cmbToMechCode.ClientID%>')[0].selectedIndex != "0") {
                    toMecCode = $('#<%=cmbToMechCode.ClientID%>').val();
                }

                var flgInvOrd = $('#<%=rbInvNInvOrds.ClientID%>').find(":checked").val();


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmHoursPerMechanic.aspx/LoadReport",
                    data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','year':'" + year + "','fromMnth':'" + fromMnth + "','toMnth':'" + toMnth + "','fromMecCode':'" + fromMecCode + "','toMecCode':'" + toMecCode + "','flgInvOrd':'" + flgInvOrd + "'}",
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
     <asp:Label ID="lblHeader" runat="server" Text="Timer per mekaniker"></asp:Label>
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
                <asp:Label ID="lblYear" runat="server" Text="Year" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="cmbYear" class="dropdowns"></asp:DropDownList>
              </div>
        </div>
     <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblFromMonth" runat="server" Text="From Month" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:DropDownList runat="server" ID="cmbFrmMonth" class="dropdowns"></asp:DropDownList>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblToMonth" runat="server" Text="To Month" Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="cmbToMonth" class="dropdowns"></asp:DropDownList>                 
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
                  <asp:Label ID="lblToMechCode" runat="server" Text="To Mechanic Code" Width="190px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="cmbToMechCode" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>
    <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
        <div class="field" style="padding:0.55em;height:40px">
        <asp:RadioButtonList ID="rbInvNInvOrds" runat="server" RepeatDirection="Horizontal" Width="300px" Height="30px">
         <asp:ListItem  Selected="true" Value="Inv" Text="Invoiced Orders" />
        <asp:ListItem  Value="NInv" Text="Non Invoiced Orders" />
      </asp:RadioButtonList> 
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