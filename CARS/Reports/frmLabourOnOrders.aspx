<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLabourOnOrders.aspx.vb" Inherits="CARS.frmLabourOnOrders" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
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

            $('#<%=btnPrint.ClientID%>').on('click', function () {
                printReport();
            });
        });//end of ready

        function printReport() {
            var deptFrom = $("#<%=ddlDeptFrom.ClientID%> option:selected").text();
            var deptTo = $("#<%=ddlDeptTo.ClientID%> option:selected").text();
            var fromDate = $('#<%=txtInvDtFrom.ClientID%>').val();
            var toDate = $('#<%=txtInvDtTo.ClientID%>').val();
            var flgclkTime = $('#<%=rbClockedTime.ClientID%>').find(":checked").val();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmLabourOnOrders.aspx/LoadReport",
                data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','flgclkTime':'" + flgclkTime + "'}",
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
     <asp:Label ID="lblHeader" runat="server" Text="Labour On Orders"></asp:Label>
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
        <asp:RadioButtonList ID="rbClockedTime" runat="server" RepeatDirection="Horizontal" Width="300px" Height="30px">
         <asp:ListItem Text="Std Time" Value="1" Selected="true"  />
        <asp:ListItem Text="Clocked Time" Value="2" />
        <asp:ListItem Text="Charged Time" Value="3" />
      </asp:RadioButtonList> 
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
