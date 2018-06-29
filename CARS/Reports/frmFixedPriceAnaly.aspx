<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmFixedPriceAnaly.aspx.vb" Inherits="CARS.frmFixedPriceAnaly" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="server">
    <script type="text/javascript">
        function fnFrmCust() {
            if ($('#<%=ddlCustIdTo.ClientID%>')[0].selectedIndex == "0") {
                $('#<%=ddlCustIdTo.ClientID%>')[0].selectedIndex = $('#<%=ddlCustIdFrom.ClientID%>')[0].selectedIndex;
                return true;
            }
        }
        function fnToCust() {
            if ($('#<%=ddlCustIdFrom.ClientID%>')[0].selectedIndex == "0") {
                $('#<%=ddlCustIdFrom.ClientID%>')[0].selectedIndex = $('#<%=ddlCustIdTo.ClientID%>')[0].selectedIndex;
                return true;
            }
        }

        function fnChkvalidation() {

            if ($("#<%=chkDI.ClientID%>").is(':checked') == false &&
                 $("#<%=chkDP.ClientID%>").is(':checked') == false) {
                var msg = GetMultiMessage('0991', '', '');
                alert(msg);
                return false;
            }
            else if ($("#<%=chkDI.ClientID%>").is(':checked') == true &&
                $("#<%=chkDP.ClientID%>").is(':checked') == true) {
                var msg = GetMultiMessage('0992', '', '');
                alert(msg);
                return false;
            }
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
            $('#<%=ddlCustIdFrom.ClientID%>').change(function (e) {
               fnFrmCust();
            });

            $('#<%=ddlCustIdTo.ClientID%>').change(function (e) {
                fnToCust();
            });



            $('#<%=btnPrint.ClientID%>').on('click', function () {
                printReport();
            });
            $('#<%=btnReset.ClientID%>').on('click', function () {
                $('#<%=ddlDeptFrom.ClientID%>')[0].selectedIndex = "0";
                $('#<%=ddlDeptTo.ClientID%>')[0].selectedIndex = "0";
                $('#<%=txtInvDtFrom.ClientID%>').val('');
                $('#<%=txtInvDtTo.ClientID%>').val('');
                $('#<%=ddlCustIdFrom.ClientID%>')[0].selectedIndex = "0";
                $('#<%=ddlCustIdTo.ClientID%>')[0].selectedIndex = "0";
            });
        });//end of ready

        function printReport() {
            var deptFrom = $("#<%=ddlDeptFrom.ClientID%>").val();
            var deptTo = $("#<%=ddlDeptTo.ClientID%>").val();
            var fromDate = $('#<%=txtInvDtFrom.ClientID%>').val();
            var toDate = $('#<%=txtInvDtTo.ClientID%>').val();
            var custIdFrom = "";
            var custIdTo = ""
            var flgDI = ""
            var flgDP = ""

            if ($('#<%=ddlCustIdFrom.ClientID%>')[0].selectedIndex != "0") {
                custIdFrom = $("#<%=ddlCustIdFrom.ClientID%> option:selected").text();
            }

            if ($('#<%=ddlCustIdTo.ClientID%>')[0].selectedIndex != "0") {
                custIdTo = $("#<%=ddlCustIdTo.ClientID%> option:selected").text();
            }
            flgDI = $("#<%=chkDI.ClientID%>").is(':checked');
            flgDP = $("#<%=chkDP.ClientID%>").is(':checked');
            if (fnChkvalidation()) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmFixedPriceAnaly.aspx/LoadReport",
                    data: "{'deptFrom':'" + deptFrom + "','deptTo':'" + deptTo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','custIdFrom':'" + custIdFrom + "','custIdTo':'" + custIdTo + "','flgDI':'" + flgDI + "','flgDP':'" + flgDP + "'}",
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
     <asp:Label ID="lblHeader" runat="server" Text="Fixed Price Analyse"></asp:Label>
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
                <asp:Label ID="lblCustIdFrom" runat="server" Text="Cust.Id From" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="ddlCustIdFrom" class="dropdowns"></asp:DropDownList>                 
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblCustIdTo" runat="server" Text="Cust.Id To" Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList runat="server" ID="ddlCustIdTo" class="dropdowns"></asp:DropDownList>                 
             </div>
        </div>

          <div style="padding:0.5em"></div>
         <div class="twelve fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:CheckBox ID="chkDI" Text="Customer ID/Department" runat="server" Width="200px" />
              <asp:CheckBox ID="chkDP" Text="Department/Payment Type" runat="server" Width="200px" />
            </div>
        </div>
          <div style="padding:0.5em"></div>
         <div class="six fields">
              <div style="text-align:center;padding-right:15em">
                  <input id="btnPrint" runat="server" class="ui button"  value="Print" type="button" /> 
                  <input id="btnReset" runat="server" class="ui button"  value="Reset" type="button" /> 
            </div>
        </div>
    </div>
</asp:Content>


