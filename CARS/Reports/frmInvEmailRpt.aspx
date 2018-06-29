<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmInvEmailRpt.aspx.vb" Inherits="CARS.frmInvEmailRpt" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ContentPlaceHolderID="cntMainPanel" runat="Server">

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
            $('#<%=txtFrom.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat,
                onSelect: function () {
                    $('#<%=txtTo.ClientID%>').val($('#<%=txtFrom.ClientID%>').val())
                }
            });

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtTo.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat

            });

            $('#<%=btnPrint.ClientID%>').on('click', function () {
                printReport();
            });

        }); // end of ready

        function printReport() {
            var fromDate = $('#<%=txtFrom.ClientID%>').val();
            var toDate = $('#<%=txtTo.ClientID%>').val();
                        
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvEmailRpt.aspx/LoadReport",
                data: "{'fromDate':'" + fromDate + "','toDate':'" + toDate + "'}",
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
        <asp:Label ID="lblHeader" runat="server" Text="Invoice Email Report"></asp:Label>
        <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
    </div>
    <div id="divCfInvDetails" class="ui form">
       <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblFrom" runat="server" Text="From" Width="180px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtFrom" runat="server" Width="200px" CssClass="inp"></asp:TextBox>
            </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                    <asp:Label ID="lblTo" runat="server" Text="To " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtTo" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
                </div>
        </div>
        <div class="six fields">
            <div style="text-align:center;padding-left:25em">
                <input id="btnPrint" runat="server" class="ui button"  value="Print" type="button" /> 
                <input id="btnReset" runat="server" class="ui button"  value="Reset" type="button" /> 
            </div>
        </div>
    </div>
</asp:Content>
