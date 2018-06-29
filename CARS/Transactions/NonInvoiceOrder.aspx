<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NonInvoiceOrder.aspx.vb" Inherits="CARS.NonInvoiceOrder"  %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Non Invoiced Orders</title>
    <script type="text/javascript" src="../javascripts/jquery-1.10.2.min.js"></script>
     <script type="text/javascript" src="../javascripts/jquery-ui.js"></script>
     <script type="text/javascript" src="../javascripts/jquery-ui-i18n.min.js"></script>
     <script type="text/javascript" src="../semantic/semantic.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-migrate-1.2.1.js"></script>
     <script type="text/javascript" src="../javascripts/grid.locale-no.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.min.js"></script>
     <script type="text/javascript" src="../javascripts/jquery.jqGrid.src.js"></script>
    <script type="text/javascript" src="../javascripts/json2-min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../javascripts/Msg.js"></script>
     <link href= "../CSS/ui.jqgrid.css" rel="stylesheet" type="text/css"/>
     <link href= "../CSS/jquery-ui.css" rel="stylesheet" type="text/css"/>
     <link href= "../semantic/semantic.min.css" rel="stylesheet" type="text/css"/>
    <link href= "../CSS/Msg.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        $(document).ready(function () {
            var userId = '<%= Session("UserID")%>';
            var custId = <%= Session("IdCustomer")%>;
         

                var grid = $("#dgdNonInvoicedDetails");
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var nonInvoicedOrdData;

                grid.jqGrid({
                    datatype: "local",
                    data: nonInvoicedOrdData,
                    colNames: ['OrderNo', 'Id_WO_NO', 'ID_WO_PREFIX', 'REGNO', 'JOBS'],
                    colModel: [
                             { name: 'OrderNo', index: 'OrderNo', width: 160, sorttype: "string" },
                             { name: 'Id_WO_NO', index: 'Id_WO_NO', width: 60, sorttype: "string" },
                             { name: 'ID_WO_PREFIX', index: 'ID_WO_PREFIX', width: 60, sorttype: "string" },
                             { name: 'WO_Veh_Reg_NO', index: 'WO_Veh_Reg_NO', width: 60, sorttype: "string" },
                             { name: 'Jobs', index: 'Jobs', width: 60, sorttype: "string" }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerNonInvoicedDetails'),
                    rowNum: 5,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    async: false, //Very important,
                    subGrid: false
                });
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "NonInvoiceOrder.aspx/LoadNonInvoiceOrderDet",
                    data: "{'idCust':'" + custId + "',idUser:'" + userId + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            nonInvoicedOrdData = data;
                            jQuery("#dgdNonInvoicedDetails").jqGrid('addRowData', i + 1, nonInvoicedOrdData.d[i]);
                        }
                    }
                });
                jQuery("#dgdNonInvoicedDetails").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
                $("#dgdNonInvoicedDetails").jqGrid("hideCol", "subGrid");
            });
    
   </script>
    </head>
    <body>
        <form id="form1" runat="server">
              <asp:HiddenField ID="hdnPageSize" runat="server"  Value="5"/>
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
         <asp:Label ID="lblOrderNotInvoiced" runat="server" Text="Order Not Invoiced"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     </div>
    <div>
         <table id="dgdNonInvoicedDetails" title="Spare Parts"></table>
          <div id="pagerNonInvoicedDetails"></div>
        </div>
    <div id="divInvDet" style="text-align:center">
        <input id="btnCancel" runat="server" class="ui button"  value="Cancel" type="button" onclick="window.close();" />
    </div>
</form>
</body>
    </html>