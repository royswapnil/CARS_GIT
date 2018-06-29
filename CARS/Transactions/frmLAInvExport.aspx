<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLAInvExport.aspx.vb" Inherits="CARS.frmLAInvExport" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
        <script type="text/javascript">

            $(document).ready(function () {
                $('#divInvExp').hide();
                loadInvExported();

                var grid = $("#dgdInvExp");
                var mydata;
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                //Invoice 
                grid.jqGrid({
                    datatype: "local",
                    data: mydata,
                    colNames: ['Inv Number', 'Date', 'Customer Name', 'Total', 'Error?','Id_Tran'],
                    colModel: [
                             { name: 'InvNo', index: 'InvNo', width: 200, sorttype: "string" },
                             { name: 'InvDate', index: 'InvDate', width: 100, sorttype: "string" },
                             { name: 'CustName', index: 'CustName', width: 250, sorttype: "string" },
                             { name: 'Total', index: 'Total', width: 150, sorttype: "string" },
                             { name: 'Err', index: 'Err', width: 150, sorttype: "string" },
                             { name: 'Id_Tran', index: 'Id_Tran', width: 150, sorttype: "string",hidden:true }                          
                    ],
                    multiselect: false,
                    pager: jQuery('#pager'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Invoices Exported",
                    async: false, //Very important,
                    subGrid: true,
                    subGridOptions: {
                        "plusicon": "ui-icon-triangle-1-e",
                        "minusicon": "ui-icon-triangle-1-s",
                        "openicon": "ui-icon-arrowreturn-1-e",
                        "reloadOnExpand": false,
                        "selectOnExpand": true
                    },
                    subGridRowExpanded: function (subgrid_id, row_id) {
                        var subgrid_table_id, pager_id; subgrid_table_id = subgrid_id + "_t";
                        pager_id = "p_" + subgrid_table_id;
                        $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table>");
                        $("#" + subgrid_table_id).jqGrid({
                            datatype: "local",
                            colNames: ['AccType', 'GL acc', 'GL Dept', 'Dimension', 'VatCode', 'GL Debit Amount', 'GL Credit Amount', 'Posting Date', 'InvNo'],
                            colModel: [
                                        { name: "Acc_Type", index: "Acc_Type", width: 100, align: "right" },
                                        { name: "Gl_Accno", index: "Gl_Accno", width: 100, align: "right" },
                                        { name: "Gl_DeptAccno", index: "Gl_DeptAccno", width: 100, align: "right" },
                                        { name: "Gl_Dimension", index: "Gl_Dimension", width: 100, align: "right" },
                                        { name: "Id_VatCode", index: "Id_VatCode", width: 100, align: "right" },
                                        { name: "Db_Gl_Amount", index: "Db_Gl_Amount", width: 100, align: "right" },
                                        { name: "Cr_Gl_Amount", index: "Cr_Gl_Amount", width: 100, align: "right" },
                                        { name: "Dt_Created", index: "Dt_Created", width: 100, align: "right" },
                                        { name: "InvNo", index: "InvNo", width: 100, align: "right" }
                            ],
                            rowNum: 20,
                            pager: pager_id,
                            sortname: 'num',
                            sortorder: "asc", height: '100%'
                        });
                        //   $("#" + subgrid_table_id).jqGrid('navGrid', "#" + pager_id, { edit: false, add: false, del: false });
                        var mysubdata;//= [];

                        var rowdata = jQuery("#dgdInvExp").jqGrid('getRowData', row_id);
                        var invNo = rowdata.InvNo;

                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmLAInvExport.aspx/FetchInvDetails",
                            data: "{invNo: '" + invNo + "'}",
                            dataType: "json",
                            async: false,
                            success: function (Result) {
                                mysubdata = Result.d;
                                if (Result.d.length > 0) {
                                    for (i = 0; i < Result.d.length; i++) {                                    
                                        $("#" + subgrid_table_id).jqGrid('addRowData', i + 1, mysubdata[i]);
                                    }
                                    $("#" + subgrid_table_id).jqGrid("hideCol", "subgrid");
                                }
                            },
                            failure: function () {
                                alert("Failed!");
                            }
                        });
                    }
                });


                jQuery("#dgdInvExp").click(function (e) {
                    var el = e.target;
                    if (el.nodeName !== "TD") {
                        el = $(el, this.rows).closest("td");
                    }
                    var iCol = $(el).index();
                    var nCol = $(el).siblings().length;
                    var row = $(el, this.rows).closest("tr.jqgrow");
                    if (row.length > 0) {
                        var rowId = row[0].id;
                        var invNo = row[0].cells['1'].title;

                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmLAInvExport.aspx/LoadInvXML",
                            data: "{invNo: '" + invNo + "'}",
                            dataType: "json",
                            async: false,//Very important
                            success: function (Result) {
                                window.open("../Reports/frmShowReports.aspx?ReportHeader='Invoice' &InvoiceType=INVOICE &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                            }
                        });
                    }

                });


            });//end of ready

            

            function loadInvExported() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmLAInvExport.aspx/LoadLATransactions",
                    data: "{}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        $('#<%=ddlTransactions.ClientID%>').empty();
                        $('#<%=ddlTransactions.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=ddlTransactions.ClientID%>').append($("<option></option>").val(value.Id_Tran).html(value.TransactionNo));                            
                        });
                    }
                });
            }

            function loadInvoiceDetails() {
                $('#divInvExp').show();
                var transId = $('#<%=ddlTransactions.ClientID%>').val();

                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmLAInvExport.aspx/FetchInvExported",
                    data: "{transId: '" + transId +  "'}",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        if (Result.d.length > 0) {
                            mydata = Result.d;
                            jQuery("#dgdInvExp").jqGrid('clearGridData');
                            for (i = 0; i < Result.d.length; i++) {
                                jQuery("#dgdInvExp").jqGrid('addRowData', i + 1, mydata[i]);
                            }
                            jQuery("#dgdInvExp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            //$("#dgdInvExp").jqGrid("showCol", "subgrid");
                        }
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }


        </script>







    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblInvExp" runat="server" Text="Invoices Exported"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />
    </div>

    <div class="ui raised segment signup inactive">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
            <a class="item" id="a2" runat="server" >Invoices Exported</a>
        </div>
        <div>
            <div class="ui form" style="padding-left:2em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblTransId" runat="server" Text="Transaction Id"></asp:Label>
                    </div>
                    <div class="field">
                         <asp:DropDownList ID="ddlTransactions" runat="server"></asp:DropDownList>               
                    </div>
                </div>
            </div>
            <div style="text-align:left;padding-bottom:4em;padding-left:15em;padding-top:2em">
                <input id="btnSearch" runat="server" type="button" value="Search" class="ui button"  onclick="loadInvoiceDetails()"/>
            </div>
        </div>
        <div id="divInvExp">
            <div>
                <table id="dgdInvExp" title="Invoices Exported" ></table>
                <div id="pager"></div>
            </div>         
        </div>

    </div>


</asp:Content>