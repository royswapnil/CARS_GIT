<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmJobReports.aspx.vb" Inherits="CARS.frmJobReports" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <link href="../Content/themes/base/theme.css" rel="stylesheet" />
    <style>
        .ui-jqgrid-disablePointerEvents {
            pointer-events: none;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ctl00_cntMainPanel_rblReportList_0')[0].focus();
            if (window.parent.document.getElementById('ctl00_cntMainPanel_ddlStatus').value == "INV") {
                $('#ctl00_cntMainPanel_rblReportList_4')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_0')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_1')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_2')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_3')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_5')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_6')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_7')[0].disabled = true;
                $('#ctl00_cntMainPanel_rblReportList_8')[0].disabled = true;
            }
            $('#<%=btnView.ClientID%>').on('click', function () {
                var crOrder = $('#<%=rblReportList.ClientID%>').find(":checked").val();
                if (crOrder == 6) {
                    window.parent.Invoicebasis();
                    
                }
                else if (crOrder == 5) {
                    window.parent.Invoice();
                    window.parent.$('#ctl00_cntMainPanel_btnPrint')[0].focus();
                    window.parent.$("#jobgrid").addClass('ui-jqgrid-disablePointerEvents');
                    window.parent.$('.ui-dialog-content:visible').dialog('close');

                }
                else if (crOrder == 1) {
                    window.parent.PickingList();
                }
                else if (crOrder == 2) {
                    window.parent.OrderList();
                }
                else if (crOrder == 3) {
                    window.parent.DeliveryNote();
                }
                else if (crOrder == 4) {
                    window.parent.jobCard();
                }
                else if (crOrder == 9) {
                    window.parent.Invoice();
                    window.parent.$('#ctl00_cntMainPanel_btnPrint')[0].focus();
                    window.parent.$("#jobgrid").addClass('ui-jqgrid-disablePointerEvents');
                    window.parent.GenerateXML();
                    window.parent.$('.ui-dialog-content:visible').dialog('close');
                }
            });
            $('#<%=btnCancel.ClientID%>').on('click', function () {
                window.parent.$('.ui-dialog-content:visible').dialog('close');
            });
        });
    </script>
    <div id="divCfInvDetails" class="ui form">
           <div class="ten fields" style="border-color:grey;border-style: solid;border-width: 1px;">
              <div class="field" style="padding:0.55em;">
                <asp:Label ID="lblPrint" runat="server" Text="Select Report" Width="100px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;border-color:grey;border-style: solid;border-width: 1px;width:300px">
                <asp:RadioButtonList ID="rblReportList" runat="server" RepeatDirection="Vertical">
                 <asp:ListItem Text="PickingList" Selected="true" Value="1"  />
                 <asp:ListItem Text="OrderList" Value="2" />
                 <asp:ListItem Text="DeliverNote" Value="3" />
                 <asp:ListItem Text="JobCard" Value="4" />
                 <asp:ListItem Text="Invoice/CreditNote" Value="5" />
                 <asp:ListItem Text="Invoice Basis" Value="6" />
                 <asp:ListItem Text="Proposal" Value="7" />
                 <asp:ListItem Text="EmailInvoice" Value="8" />
                 <asp:ListItem Text="EHF" Value="9" />
                </asp:RadioButtonList>  
               </div>
        </div>
        </div>
         <div style="padding:0.5em"></div>
         <div class="ten fields">
             <div style="text-align:center">
             <input id="btnView" runat="server" class="ui button" value="View" type="button"/>
             <input id="btnCancel" runat="server" class="ui button" value="Cancel" type="button"/>
         </div>
         </div>

</asp:Content>