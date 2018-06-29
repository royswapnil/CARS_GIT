<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmWOPaydetails.aspx.vb" Inherits="CARS.frmWOPaydetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
        <%@ Register Src="../UserCtrl/ucWOMenutabs.ascx" TagName="ucWOMenutabs" TagPrefix="uc3" %>
    <script>
        $(document).ready(function () {
            var invoiceListXML;
            var invoiceListXMLs = "";
            var idWONO = '<%= Session("WONO")%>';
            var idWOPrefix = '<%= Session("WOPR")%>';
            var decSeparator = '<%=Session("Decimal_Seperator")%>';
            var thSeparator = '<%=Session("Thousand_Seperator")%>';
            var grid = $("#dgInvoiceItems");
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var Invoicedata;

                grid.jqGrid({
                    datatype: "local",
                    data: Invoicedata,
                    colNames: ['Job No', 'Debtor Code', 'Debtor Name', 'Spare Part Amount', 'Labour Amount', 'GM Amount', 'Disc Amount', 'Own Risk Amount', 'Net Amount', 'Vat Amount', 'Total Amount', 'FlgBatch', 'DET_SEQ', 'Job Status', 'Status', 'PayType'],
                    colModel: [
                             { name: 'Job_No', index: 'Job_No', width: 40, sortable: false, formatter: viewJobDet },
                             { name: 'Id_Debitor', index: 'Id_Debitor', width: 80, sorttype: "string" },
                             { name: 'Debitor_Name', index: 'Debitor_Name', width: 200, sorttype: "string" },
                             { name: 'Tot_Spare_Amt', index: 'Tot_Spare_Amt', width: 160, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Tot_Lab_Amt', index: 'Tot_Lab_Amt', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Tot_GM_Amt', index: 'Tot_GM_Amt', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'ToT_Disc_Amt', index: 'ToT_Disc_Amt', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Own_Risk_Amt', index: 'Own_Risk_Amt', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Tot_Net_Amount', index: 'Tot_Net_Amount', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Tot_Vat_Amt', index: 'Tot_Vat_Amt', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'Tot_Amount', index: 'Tot_Amount', width: 80, formatter: 'number', formatoptions: { decimalSeparator: decSeparator, thousandsSeparator: " ", decimalPlaces: 2 }, },
                             { name: 'FlgBatch', index: 'FlgBatch', hidden: true },
                             { name: 'IdWODetSeq', index: 'IdWODetSeq', hidden: true },
                             { name: 'Job_Status', index: 'Job_Status', width: 100, sorttype: "string" },
                             { name: 'Status', index: 'Status', hidden: true },
                             { name: 'PayType', index: 'PayType', hidden: true },
                            
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerdgInvoiceItems'),
                    rowNum: 5,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    async: false, //Very important,
                    subGrid: false,
                    footerrow: true,
                    userDataOnFooter: true,
                    gridComplete: function () {
                        var Tot_Lab_Amt = $(this).jqGrid('getCol', 'Tot_Lab_Amt', false, 'sum');
                        var ToT_Disc_Amt = $(this).jqGrid('getCol', 'ToT_Disc_Amt', false, 'sum');
                        var Tot_Spare_Amt = $(this).jqGrid('getCol', 'Tot_Spare_Amt', false, 'sum');
                        var Tot_Vat_Amt = $(this).jqGrid('getCol', 'Tot_Vat_Amt', false, 'sum');
                        var Tot_Net_Amount = $(this).jqGrid('getCol', 'Tot_Net_Amount', false, 'sum');
                        var Tot_Amount = $(this).jqGrid('getCol', 'Tot_Amount', false, 'sum');
                        var Tot_GM_Amt = $(this).jqGrid('getCol', 'Tot_GM_Amt', false, 'sum');
                        var Own_Risk_Amt = $(this).jqGrid('getCol', 'Own_Risk_Amt', false, 'sum');
                        $(this).jqGrid('footerData', 'set', { Tot_Lab_Amt: Tot_Lab_Amt});
                        $(this).jqGrid('footerData', 'set', { Tot_Spare_Amt: Tot_Spare_Amt });
                        $(this).jqGrid('footerData', 'set', { ToT_Disc_Amt: ToT_Disc_Amt });
                        $(this).jqGrid('footerData', 'set', { Tot_Vat_Amt: Tot_Vat_Amt });
                        $(this).jqGrid('footerData', 'set', { Tot_Net_Amount: Tot_Net_Amount});
                        $(this).jqGrid('footerData', 'set', { Tot_Amount: Tot_Amount });
                        $(this).jqGrid('footerData', 'set', { Tot_GM_Amt: Tot_GM_Amt });
                        $(this).jqGrid('footerData', 'set', { Own_Risk_Amt: Own_Risk_Amt });
                    }
                   
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOPaydetails.aspx/Fetch_PaymentDetails",
                    data: "{'idWONO':'" + idWONO + "',idWOPrefix:'" + idWOPrefix + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            Invoicedata = data;
                            jQuery("#dgInvoiceItems").jqGrid('addRowData', i + 1, Invoicedata.d[i]);

                        }
                    }
                });

                jQuery("#dgInvoiceItems").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
                $("#dgInvoiceItems").jqGrid("hideCol", "subGrid");
                var myGrid = $("#dgInvoiceItems");
                $("#cb_" + myGrid[0].id).attr("disabled", "disabled");
                disableCheckBox();
                function disableCheckBox() {
                    var rowData = $('#dgInvoiceItems').jqGrid('getGridParam', 'data');
                    for (var i = 0; i < rowData.length; i++) {
                        var status = rowData[i].Status;
                        if ((status == "DEL") || (status == "INV"))
                        {
                            $('#' + rowData[i].id + ' > td:not(.jqgrid-rownum)').attr('disabled', 'disabled');
                        }
                        if ((status == "INV") || (status == "RINV")) {
                            $('#<%=btnAddJob.ClientID%>').attr('disabled', 'disabled')
                        }
                    }
                }

                $('#<%=btnRINV.ClientID%>').on('click', function () {
                    RINVRecs();
                });

            $('#<%=btnRwrk.ClientID%>').on('click', function () {
                RWRKRecs();
            });
            $('#<%=btnAddJob.ClientID%>').on('click', function () {
                window.location.href = 'frmWOJobDetails.aspx?TabId=3&Mode=Add';
            });
            
            $("#dgInvoiceItems").find('input[type=checkbox]').each(function () {
             
                $(this).change(function () {
                    var row;
                    var idWoNo;
                    var idWoPr;
                    var idJob;
                    var idWodetSeq;
                    var idJobDeb;
                    var flgBatch;
                    if ($(this).is(':checked')) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        idJob = $('#dgInvoiceItems tr ')[row].cells[1].innerText.toString();
                        idWodetSeq = $('#dgInvoiceItems tr ')[row].cells[13].innerText.toString();
                        idJobDeb = $('#dgInvoiceItems tr ')[row].cells[2].innerText.toString();
                        flgBatch = $('#dgInvoiceItems tr ')[row].cells[12].innerText.toString();
                        idWoNo = '<%= Session("WONO")%>';
                        idWoPr = '<%= Session("WOPR")%>';
                        invoiceListXML = '<INV_GENERATE ID_WO_PREFIX ="' + idWoPr.toString() + '" ID_WO_NO = "' + idWoNo.toString() + '" ID_WODET_SEQ ="' + idWodetSeq.toString() + '" ID_JOB_DEB="' + idJobDeb + '" FLG_BATCH="' + flgBatch + '" />';
                        invoiceListXMLs += invoiceListXML;
                    }
                        if (invoiceListXMLs != "") {
                            invoiceListXMLs =  invoiceListXMLs ;
                            var userId = '<%= Session("UserID")%>';
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                url: "frmWOPaydetails.aspx/InvBasis",
                                data: "{'invoiceListXMLs':'" + invoiceListXMLs + "'}",
                                dataType: "json",
                                success: function (data) {

                                },
                                error: function (result) {
                                    alert("Error");
                                }
                            });
                        }
                   
                    return true;
                });
            });
          
            <%--jQuery(".jqgrow td input", "#dgInvoiceItems").click(function () {
                debugger;
                var row;
                var idWoNo;
                var idWoPr;
                var idJob;
                var idWodetSeq;
                var idJobDeb;
                var flgBatch;
                var invoiceListXML;
                var invoiceListXMLs = "";
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idJob = $('#dgInvoiceItems tr ')[row].cells[1].innerText.toString();
                    idWodetSeq = $('#dgInvoiceItems tr ')[row].cells[13].innerText.toString();
                    idJobDeb = $('#dgInvoiceItems tr ')[row].cells[2].innerText.toString();
                    flgBatch = $('#dgInvoiceItems tr ')[row].cells[12].innerText.toString();
                    idWoNo = '<%= Session("WONO")%>';
                    idWoPr = '<%= Session("WOPR")%>';
                    invoiceListXML = '<INV_GENERATE ID_WO_PREFIX ="' + idWoPr.toString() + '" ID_WO_NO = "' + idWoNo.toString() + '" ID_WODET_SEQ ="' + idWodetSeq.toString() + '" ID_JOB_DEB="' + idJobDeb + '" FLG_BATCH="' + flgBatch + '" />';
                    invoiceListXMLs += invoiceListXML;
                    if (invoiceListXMLs != "") {
                        invoiceListXMLs = "<ROOT>" + invoiceListXMLs + "</ROOT>";
                        var userId = '<%= Session("UserID")%>';
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmWOPaydetails.aspx/InvBasis",
                            data: "{'invoiceListXMLs':'" + invoiceListXMLs + "'}",
                            dataType: "json",
                            success: function (data) {

                            },
                            error: function (result) {
                                alert("Error");
                            }
                        });
                    }
                }
            });--%>
            
            
        }); //End of ready function
        function reloadGrid(idWONO, idWOPrefix) {
            var grid = $("#dgInvoiceItems");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var debtordata;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmWOPaydetails.aspx/Fetch_PaymentDetails",
                data: "{'idWONO':'" + idWONO + "',idWOPrefix:'" + idWOPrefix + "'}",
                //data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    jQuery("#dgInvoiceItems").jqGrid('clearGridData');
                    for (i = 0; i < data.d.length; i++) {
                        Invoicedata = data;
                        jQuery("#dgInvoiceItems").jqGrid('addRowData', i + 1, Invoicedata.d[i]);
                    }
                }
            });
            jQuery("#dgInvoiceItems").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgInvoiceItems").jqGrid("hideCol", "subGrid");
        }
       
        function RINVRecs()
        {
            var row;
            var idWoNo;
            var idWoPr;
            var idJob;
            var jobStatus;
            var debitorIdxml;
            var debitorIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgInvoiceItems input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idJob = $('#dgInvoiceItems tr ')[row].cells[1].innerText.toString();
                    jobStatus = $('#dgInvoiceItems tr ')[row].cells[15].innerText.toString();
                    idWoNo = '<%= Session("WONO")%>';
                    idWoPr = '<%= Session("WOPR")%>';
                    debitorIdxml = '<JOBNO WOORDNO ="' + idWoNo.toString() + '" WOJOBNO = "' + idJob.toString() + '" WOPREFIX ="' + idWoPr.toString() + '" > </JOBNO>';
                    debitorIdxmls += debitorIdxml;
                                         
                }
            });
            if (debitorIdxmls != "") {
                debitorIdxmls = "<ROOT>" + debitorIdxmls + "</ROOT>";
                var userId = '<%= Session("UserID")%>';
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOPaydetails.aspx/SetReadyToInv",
                    data: "{'debitorIdxmls':'" + debitorIdxmls + "',userId:'" + userId + "'}",
                    dataType: "json",
                    success: function (data) {
                        reloadGrid(idWoNo, idWoPr);
                        var status = $('#dgInvoiceItems tr ')[row].cells[15].innerText.toString();
                        if (status == "RINV")
                        {
                            $('#<%=lblErr.ClientID%>').text('Job(s) set to ‘Ready to Invoice’. Please use same button again to reset status.');
                            $('#<%=btnAddJob.ClientID%>').attr('disabled', 'disabled');
                        }
                        else
                        {
                            $('#<%=lblErr.ClientID%>').text('');
                            $('#<%=btnAddJob.ClientID%>').removeAttr("disabled");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }
        function RWRKRecs() {
            var row;
            var idWoNo;
            var idWoPr;
            var idJob;
            var jobStatus;
            var debitorIdxml;
            var debitorIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgInvoiceItems input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idJob = $('#dgInvoiceItems tr ')[row].cells[1].innerText.toString();
                    jobStatus = '<%= Session("STATUS")%>';
                    idWoNo = '<%= Session("WONO")%>';
                    idWoPr = '<%= Session("WOPR")%>';
                    debitorIdxml = '<JOBNO WOORDNO ="' + idWoNo.toString() + '" WOJOBNO = "' + idJob.toString() + '" WOPREFIX ="' + idWoPr.toString() + '" > </JOBNO>';
                    debitorIdxmls += debitorIdxml;

                }
            });
            if (debitorIdxmls != "") {
                debitorIdxmls = "<ROOT>" + debitorIdxmls + "</ROOT>";
                var userId = '<%= Session("UserID")%>';
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOPaydetails.aspx/SetReadyToWrk",
                    data: "{'debitorIdxmls':'" + debitorIdxmls + "',userId:'" + userId + "'}",
                    dataType: "json",
                    success: function (data) {
                        reloadGrid(idWoNo, idWoPr);
                      },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }
        function viewJobDet(cellvalue, options, rowObject) {
            var idWONO = '<%= Session("WONO")%>';
            var idWOPrefix = '<%= Session("WOPR")%>';
            var id_job = rowObject.Job_No.toString();
            var status = rowObject.Status.toString();
            var selectedId = options.rowId;
            var strOptions = cellvalue;
            var hdView = document.getElementById('<%=hdnViewCap.ClientID%>').value;
            $(document.getElementById('<%=hdnVAMode.ClientID%>')).val("Edit");
            var mode = $("#<%=hdnVAMode.ClientID%>").val();
            if (status == "DEL")
            {
                var edit = id_job;
            }
            else
            {
            var edit = "<a href='#' style='text-decoration:underline' type='button'  title='" + id_job + "' onclick=redirectJobDet(" + "'" + id_job + "','" + idWONO + "'" + ",'" + idWOPrefix + "'" + ",'" + mode + "'" + ")>" + id_job + "</a>";
            }
            return edit;
        }
        function redirectJobDet(id_job, WoNo, WoPr, VAmode) {
            window.location.href = 'frmWOJobDetails.aspx?epjid=' + id_job + '&Wonumber=' + WoNo + '&WOPrefix=' + WoPr + '&VAMode=' + VAmode + '&Mode=View' + '&TabId=3'
        }
        

    </script>
<div class="header1 two fields" >
        <asp:Label ID="lblHead" runat="server" Text="Payment Summary" ></asp:Label>
        <asp:Label ID="lblErr" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
        <asp:HiddenField ID="CustLength" runat="server" />
        <asp:HiddenField ID="InvLength" runat="server" />
        <asp:HiddenField ID="OrderLength" runat="server" />
        <asp:HiddenField ID="OrderPrefix" runat="server" />
        <asp:HiddenField ID="OrderNumber" runat="server" />
        <asp:HiddenField ID="hdnViewCap" runat="server" Value="View" />
        <asp:HiddenField ID="hdnVAMode" runat="server" />
    </div>
    <div>
        <uc3:ucWOMenutabs ID="UcWOMenutabs1" runat="server" />
    </div>
     <div class="lbl">
       <table id="dgInvoiceItems" title="Payment Summary"></table>
       <div id="pagerdgInvoiceItems"></div>
     </div>
           <div id="divPayTerms" style="text-align:center">
                    <input id="btnAddJob" runat="server" class="ui button"  value="Add Job" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnRwrk" runat="server" class="ui button" value="Ready For Work" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnRINV" runat="server" class="ui button"  value="Ready To Invoice" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnJobCard" runat="server" class="ui button" value="Print Job Card" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnInvBasis" runat="server" class="ui button"  value="Invoice Basis" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnINVMain" runat="server" class="ui button" value="Invoice" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnPickingList" runat="server" class="ui button"  value="Picking List" type="button" style="background-color: #E0E0E0"  />
                    <input id="btnEmailInv" runat="server" class="ui button" value="E-Mail Invoice" type="button" style="background-color: #E0E0E0" visible="false"  />
           </div>  
</asp:Content>

