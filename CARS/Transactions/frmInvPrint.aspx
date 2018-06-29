<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmInvPrint.aspx.vb" Inherits="CARS.frmInvPrint" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#invGrid').hide();
            $('#<%=Label1.ClientID%>').hide();
            $('#<%=btnCreditNote1.ClientID%>').hide();
            $('#<%=btnCreditNote2.ClientID%>').hide();
            $('#<%=btnCNOrder1.ClientID%>').hide();
            $('#<%=btnCNOrder2.ClientID%>').hide();
            $('#<%=btnPrintInvoice1.ClientID%>').hide();
            $('#<%=btnPrintInvoice2.ClientID%>').hide();
            $('#<%=txtRegnDate.ClientID%>').hide();
            var dateFormat ="";
            if ($('#<%=hdnDateFormat.ClientID%>').val() == "dd.MM.yyyy") {
                dateFormat = "dd.mm.yy"
            }
            else {
                dateFormat = "dd/mm/yy"
            }
            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtDateFrom.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat,
                onSelect: function () {
                    $('#<%=txtDateTo.ClientID%>').val($('#<%=txtDateFrom.ClientID%>').val())
                }
            });

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtDateTo.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat
               
            });


           $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtRegnDate.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat
            });

            <%--$('#<%=txtDateFrom.ClientID%>').keydown(function (e) {
                if (e.which == 9)
                    alert("YEYYYYYYY!!!");
            });--%>

            var cust = $('#<%=txtCustomer.ClientID%>').val();
            $('#<%=txtCustomer.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Customer_Search",
                        data: "{'q':'" + $('#<%=txtCustomer.ClientID%>').val() + "'}",
                        dataType: "json",

                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PERM_ADD1 + " - " + item.ID_CUST_PERM_ZIPCODE + " " + item.CUST_PERM_CITY,
                                    val: item.ID_CUSTOMER,
                                    value: item.ID_CUSTOMER
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtCustomer.ClientID%>").val(i.item.val);
                 
                },
            });

            var debtor = $('#<%=txtDebitor.ClientID%>').val();
            $('#<%=txtDebitor.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Customer_Search",
                        data: "{'q':'" + $('#<%=txtDebitor.ClientID%>').val() + "'}",
                        dataType: "json",

                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PERM_ADD1 + " - " + item.ID_CUST_PERM_ZIPCODE + " " + item.CUST_PERM_CITY,
                                    val: item.ID_CUSTOMER,
                                    value: item.ID_CUSTOMER
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtDebitor.ClientID%>").val(i.item.val);

                },
            });


            var ord = $('#<%=txtOrdNo.ClientID%>').val();
            $('#<%=txtOrdNo.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOSearchPopup.aspx/Order_Search",
                        data: "{'q':'" + $('#<%=txtOrdNo.ClientID%>').val() + "'}",
                        dataType: "json",

                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.ORDNO ,
                                    val: item.ORDNO,
                                    value: item.ORDNO
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtOrdNo.ClientID%>").val(i.item.val);

                },
            });


            //Vehicle autocomplete
            $('#<%=txtVehicle.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Vehicle_Search",
                        data: "{q:'" + $('#<%=txtVehicle.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt kjøretøyregister. Trykk enter for å opprette nytt kjøretøy.', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.VehRegNo + " - " + item.IntNo + " - " + item.VehVin + " - " + item.CustomerName,
                                        val: item.IntNo,
                                        value: item.VehRegNo + " - " + item.IntNo + " - " + item.VehVin,
                                        idvehseq: item.Id_Veh_Seq
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtVehicle.ClientID%>").val(i.item.val);
                    $("#<%=hdnIdVehSeq.ClientID%>").val(i.item.idvehseq);

                }
            });

            var gridInvData;
            var grid = $("#dgdInvoice");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mydata;
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['INVOICE NO', 'DT INVOICE', 'VEH REG NO', 'CUST NAME', 'INV AMT', 'FLG BATCH INV', 'CN No', 'WO TYPE WOH', 'INV PDF', 'Already_Credited'],
                colModel: [
                         { name: 'Id_Inv_No', index: 'Id_Inv_No', width: 100, sortable: false },
                         { name: 'Dt_Invoice', index: 'Dt_Invoice', width: 100, sortable: false },
                         { name: 'WO_Veh_Reg_No', index: 'WO_Veh_Reg_No', width: 100, sortable: false },
                         { name: 'CustomerName', index: 'CustomerName', width: 150, sortable: false },
                         { name: 'InvoiceAmt', index: 'InvoiceAmt', width: 100, sortable: false },
                         { name: 'Flg_Batch_Inv', index: 'Flg_Batch_Inv', width: 90, sortable: false },
                         { name: 'Credit_No', index: 'Credit_No', width: 100, sortable: false },
                         { name: 'WO_Type_Woh', index: 'WO_Type_Woh', width: 80, sortable: false },
                         { name: 'InvoicePDF', index: 'InvoicePDF', width: 110, sortable: false },
                         { name: 'Flg_Alrdy_Cr', index: 'Flg_Alrdy_Cr', width: 150, sortable: false }
                ],
                multiselect: true,
                pager: jQuery('#pagerInvoice'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "",
                async: false, //Very important,
                subgrid: true,
                subGridOptions: {
                    "plusicon": "ui-icon-triangle-1-e",
                    "minusicon": "ui-icon-triangle-1-s",
                    "openicon": "ui-icon-arrowreturn-1-e",
                    "reloadOnExpand": false,
                    "selectOnExpand": true
                },
                subGridRowExpanded: function (subgrid_id, row_id) {
                    var subgrid_table_id, pager_id;
                    //subgrid_table_id = "dgdChildInvoice";
                   subgrid_table_id = subgrid_id + "_t";
                    pager_id = "p_" + subgrid_table_id;
                    $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table>");
                    $("#" + subgrid_table_id).jqGrid({
                        datatype: "local",
                        colNames: ['Order No', 'OrderDate', 'No.of Jobs', 'Seq.No', 'TotalAmount', 'Order Prefix', 'Already_Credited'],
                        colModel: [
                                    { name: "Id_WO_NO", index: "Id_WO_NO", width: 80, key: true },
                                    { name: "Dt_Order", index: "Dt_Order", width: 150 },
                                    { name: "No_Of_Jobs", index: "No_Of_Jobs", width: 100, align: "right" },
                                    { name: "SeqNo", index: "SeqNo", width: 100, align: "right" },
                                    { name: "WO_Amount", index: "WO_Amount", width: 150, align: "right" },
                                    { name: "Id_WO_Prefix", index: "Id_WO_Prefix", width: 20, align: "right", hidden: true },
                                    { name: "Flg_Kre_Ord", index: "Flg_Kre_Ord", width: 150, align: "right" }
                        ],
                        rowNum: 20,
                        pager: pager_id,
                        sortorder: "asc",
                        height: '100%',
                        multiselect: true,
                        onCellSelect: function (rowId, iCol, content, event) {
                            var rowdataGrd;
                            rowdataGrd = $("#" + subgrid_table_id).jqGrid('getRowData', rowId);

                            var cm = $("#" + subgrid_table_id).jqGrid('getGridParam', 'colModel');
                            if (cm[iCol].name == "Id_WO_NO") {
                                var woNo = rowdataGrd.Id_WO_NO;
                                var woPr = rowdataGrd.Id_WO_Prefix;
                                var mode = 'Edit';
                                var flag = encodeURIComponent('Ser');
                                window.location.replace("../Transactions/frmWOJobDetails.aspx?Wonumber=" + woNo + "&WOPrefix=" + woPr + "&Mode=" + mode + "&TabId=" + 3  + "&Flag=" + flag + "&blWOsearch=" + true);
                            }
                        }
                    });

                    var mysubdata;//= [];

                    var rowdata = jQuery("#dgdInvoice").jqGrid('getRowData', row_id);
                    var idInvNo = rowdata.Id_Inv_No;

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmInvPrint.aspx/FetchOrderList",
                        data: "{idInvNo: '" + idInvNo + "'}",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            if (Result.d.length > 0) {
                                for (i = 0; i < Result.d.length; i++) {
                                    mysubdata = Result;
                                    $("#" + subgrid_table_id).jqGrid('addRowData', i + 1, mysubdata.d[i]);
                                }

                                 $("#" + subgrid_table_id).jqGrid("hideCol", "subgrid");
                                //jQuery("#dgdInvoice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");

                            }
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
                }
           });
                
            // loadInvoiceGrid();
            $('#<%=btnSearch.ClientID%>').click(function () {
                var bool = DateValidation();
                if (bool == true)
                {
                    $('#invGrid').show();
                   <%-- $('#<%=btnCreditNote1.ClientID%>').show();
                    $('#<%=btnCreditNote2.ClientID%>').show();
                    $('#<%=btnCNOrder1.ClientID%>').show();
                    $('#<%=btnCNOrder2.ClientID%>').show();--%>
                    $('#<%=btnPrintInvoice1.ClientID%>').hide();
                    $('#<%=btnPrintInvoice2.ClientID%>').hide();
                    $('#<%=txtRegnDate.ClientID%>').show();
                    loadInvoiceGrid();
                   
                }

            });
            $('#<%=btnCreditNote1.ClientID%>').click(function () {
                CreateCreditNote();
            });

            $('#<%=btnCreditNote2.ClientID%>').click(function () {
                CreateCreditNote();
            });


            function DateValidation() {

                var fromDate = document.getElementById('<%= txtDateFrom.ClientID %>').value;
                var toDate = document.getElementById('<%= txtDateTo.ClientID %>').value;
                var invoiceNo = document.getElementById('<%= txtInvNoFrom.ClientID %>').value;

                if ((fromDate == '' || toDate == '') && invoiceNo == '') {
                    var msg = GetMultiMessage('INVVALID', '', '');
                    alert(msg);
                    return false;
                }

                if ($('#<%=txtDateFrom.ClientID%>').val().length != 0 && $('#<%=txtDateTo.ClientID%>').val().length != 0) {
                    var fromDate = fnValidateDate($('#<%=txtDateFrom.ClientID%>').val(), document.getElementById('<%=hdnDateFormat.ClientID%>').value);
                    var toDate = fnValidateDate($('#<%=txtDateTo.ClientID%>').val(), document.getElementById('<%=hdnDateFormat.ClientID%>').value);

                    if (toDate < fromDate) {
                        alert(GetMultiMessage('DATEVAL', '', ''))
                        return false;
                    }
                }
                var fromAmount = $('#<%=txtAmountFrom.ClientID%>').val();
                fromAmount = Number(fromAmount.replace(/,/g, ''));
                var toAmount = $('#<%=txtAmountTo.ClientID%>').val();
                toAmount = Number(toAmount.replace(/,/g, ''));


                if (fromAmount > toAmount) {
                    var msg = GetMultiMessage('MSG136', '', '');
                    alert(msg);
                    return false;
                }
                else {
                    return true;
                }

                return true;
            }
           
        });//end of ready


        function CreateCreditNote()
        {
            dataCollection = [];
            var regnDate = $("#<%=txtRegnDate.ClientID%>").val();
            $('#dgdInvoice input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idPTseq = $('#dgdInvoice tr')[row].cells[1].innerHTML.toString();
                    var id_inv_no = $('#dgdInvoice tr')[row].cells[2].innerHTML.toString();
                    var flgbatchinv = $('#dgdInvoice tr')[row].cells[7].innerHTML.toString();
                    dataCollection.push({
                        ID_INV_NO: id_inv_no,
                        FLG_BATCH: flgbatchinv
                    });
                }

            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvPrint.aspx/CreateCreditNote",
                data: "{orders: '" + JSON.stringify(dataCollection) + "',regnDate:'" + regnDate + "'}",
                dataType: "json",
                async: false,
                success: function (Result) {
                    if (Result.d.length > 0) {
                        if (Result.d[0] == "SUCCESS") {
                            window.open("../Reports/frmShowReports.aspx?ReportHeader='Credit Note' &InvoiceType=CreditNote &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        }
                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });


        }

        function loadInvoiceGrid() {
            var invoiceNo = $('#<%=txtInvNoFrom.ClientID()%>').val();
            var fromDate = $('#<%=txtDateFrom.ClientID()%>').val(); //"07/04/2015";
            var toDate = $('#<%=txtDateTo.ClientID()%>').val(); //"07/04/2017";
            var fromAmount = $('#<%=txtAmountFrom.ClientID()%>').val();
            var toAmount = $('#<%=txtAmountTo.ClientID()%>').val();
            var debtor = $('#<%=txtDebitor.ClientID()%>').val();
            var customer = $('#<%=txtCustomer.ClientID()%>').val();
            var orderNo = $('#<%=txtOrdNo.ClientID()%>').val();
            var vehRegNo = $('#<%=hdnIdVehSeq.ClientID()%>').val();
            var flgBatchInv = $("#<%=chkBatchInvoice.ClientID%>").is(':checked');
            var invStatus = $('#<%=rblVehicleReportList.ClientID%>').find(":checked").val(); //"1";
            var crOrder = $('#<%=rdbCreate.ClientID%>').find(":checked").val();
            if (crOrder == 1)
            {
                $('#<%=btnCNOrder1.ClientID%>').hide();
                $('#<%=btnCNOrder2.ClientID%>').hide();
                $('#<%=btnCreditNote1.ClientID%>').show();
                $('#<%=btnCreditNote2.ClientID%>').show();
            }
            else if (crOrder == 2) {
                $('#<%=btnCreditNote1.ClientID%>').hide();
                $('#<%=btnCreditNote2.ClientID%>').hide();
                $('#<%=btnCNOrder1.ClientID%>').show();
                $('#<%=btnCNOrder2.ClientID%>').show();
            }
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvPrint.aspx/LoadInvoiceDetails",
                data: "{invoiceNo: '" + invoiceNo + "',fromDate: '" + fromDate + "',toDate: '" + toDate + "',fromAmount: '" + fromAmount + "',toAmount: '" + toAmount + "',debtor: '" + debtor + "',customer: '" + customer + "',orderNo: '" + orderNo + "',vehRegNo: '" + vehRegNo + "',flgBatchInv: '" + flgBatchInv + "',invStatus: '" + invStatus + "',crOrder:'" + crOrder +"'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdInvoice").jqGrid('clearGridData');
                        for (i = 0; i < data.d[0].length; i++) {
                            gridInvData = data.d[0];
                            jQuery("#dgdInvoice").jqGrid('addRowData', i + 1, gridInvData[i]);
                        }
                        jQuery("#dgdInvoice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    }
                   
                }
            });

            jQuery("#dgdInvoice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdInvoice").jqGrid("showCol", "subgrid");
        }

        function CreateCreditNoteOrders() {
            var woNo;
            var woPr;
            var grid = $("#dgdInvoice");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            var rowids = $('#dgdInvoice').jqGrid('getDataIDs');
            if ($('#dgdInvoice td :checked')) {
                if (($('#dgdInvoice td :checked').length) == 1) {
                    var parString = $('#dgdInvoice td :checked')[0].id;
                    if (parString.indexOf('_t') > -1) {
                                            var chldstringToSplit = $('#dgdInvoice td :checked')[0].id;
                                            var arrayOfchldStrings = chldstringToSplit.split('_');
                                            var chldid = arrayOfchldStrings[2];
                                            var rowId = arrayOfchldStrings[4];
                                            var dgd = $('#dgdInvoice_' + chldid +'_t')
                                            var rowdataGrd;
                                            rowdataGrd = jQuery(dgd).jqGrid('getRowData', rowId);
                                            //woNo = $('#dgdInvoice_' + chldid + '_t tr')[row].cells[2].innerHTML.toString();
                                            //woPr = $('#dgdInvoice_' + chldid + '_t tr')[row].cells[7].innerHTML.toString();
                                             woNo = rowdataGrd.Id_WO_NO;
                                             woPr = rowdataGrd.Id_WO_Prefix;
                                             var flg_kre_ord = rowdataGrd.Flg_Kre_Ord;
                                             if (flg_kre_ord == "True") {
                                                 $('#mceMSG').html('Creditnote already exists for the selected record,do you want to continue?')
                                                 $('#modInvoice').modal('setting', {
                                                     autofocus: false,
                                                     onShow: function () {
                                                     },
                                                     onDeny: function () {
                                                     },
                                                     onApprove: function () {
                                                         $.ajax({
                                                             type: "POST",
                                                             contentType: "application/json; charset=utf-8",
                                                             url: "frmInvPrint.aspx/CreateCreditNoteOrders",
                                                             data: "{woNo: '" + woNo + "',woPr:'" + woPr + "'}",
                                                             dataType: "json",
                                                             async: false,
                                                             success: function (Result) {
                                                                 if (Result.d.length > 0) {
                                                                     $('#<%=RTlblError.ClientID%>').text("CreditNote Orders Created successfully.");
                                                                     $('#<%=RTlblError.ClientID%>').removeClass();
                                                                     $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                                                     loadInvoiceGrid();
                                                                 }
                                                             },
                                                             failure: function () {
                                                                 alert("Failed!");
                                                             }
                                                         });

                                                     }
                                                 }).modal('show');
                                             }
                                             else {
                                                 $.ajax({
                                                     type: "POST",
                                                     contentType: "application/json; charset=utf-8",
                                                     url: "frmInvPrint.aspx/CreateCreditNoteOrders",
                                                     data: "{woNo: '" + woNo + "',woPr:'" + woPr + "'}",
                                                     dataType: "json",
                                                     async: false,
                                                     success: function (Result) {
                                                         if (Result.d.length > 0) {
                                                             $('#<%=RTlblError.ClientID%>').text("CreditNote Orders Created successfully.");
                                                             $('#<%=RTlblError.ClientID%>').removeClass();
                                                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                                             loadInvoiceGrid();
                                                         }
                                                     },
                                                     failure: function () {
                                                         alert("Failed!");
                                                     }
                                                 });
                                             }

                                         }
                    else {
                        var stringToSplit = $('#dgdInvoice td :checked')[0].id;
                        var arrayOfStrings = stringToSplit.split('_');
                        var id = arrayOfStrings[2];
                        var rowdata = jQuery("#dgdInvoice").jqGrid('getRowData', id);
                        var id_inv_no = rowdata.Id_Inv_No;
                        var flg_kre_ord = rowdata.Flg_Alrdy_Cr;
                        if (flg_kre_ord == "True")
                        {
                            $('#mceMSG').html('Creditnote already exists for the selected record,do you want to continue?')
                            $('#modInvoice').modal('setting', {
                                autofocus: false,
                                onShow: function () {
                                },
                                onDeny: function () {
                                },
                                onApprove: function () {
                                    $.ajax({
                                        type: "POST",
                                        contentType: "application/json; charset=utf-8",
                                        url: "frmInvPrint.aspx/CreateInv_CreditNoteOrders",
                                        data: "{id_inv_no: '" + id_inv_no + "'}",
                                        dataType: "json",
                                        async: false,
                                        success: function (Result) {
                                            if (Result.d.length > 0) {
                                                if (Result.d[0] == "SUCCESS") {
                                                    loadInvoiceGrid();
                                                    window.open("../Reports/frmShowReports.aspx?ReportHeader='Invoice' &InvoiceType=INVOICE &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                                                }
                                                
                                            }
                                        },
                                        failure: function () {
                                            alert("Failed!");
                                        }
                                    });

                                }
                            }).modal('show');
                        }
                        else {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                url: "frmInvPrint.aspx/CreateInv_CreditNoteOrders",
                                data: "{id_inv_no: '" + id_inv_no + "'}",
                                dataType: "json",
                                async: false,
                                success: function (Result) {
                                    if (Result.d.length > 0) {
                                        if (Result.d[0] == "SUCCESS") {
                                            loadInvoiceGrid();
                                            window.open("../Reports/frmShowReports.aspx?ReportHeader='Invoice' &InvoiceType=INVOICE &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                                        }

                                    }
                                },
                                failure: function () {
                                    alert("Failed!");
                                }
                            });
                        }
                       
                    }
                }
                else if (($('#dgdInvoice td :checked').length) > 1) {
                    alert('Please select one invoice/order at a time for creating Credit Orders.');
                    return false;
                }
                
            }

        }
   
    </script>
    <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Credit Note"></asp:Label>
     <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     <asp:HiddenField ID="hdnIdVehSeq" runat="server" />
     <asp:HiddenField ID="hdnPageSize" runat="server" />
    <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
</div>
    <div id="divCfInvDetails" class="ui form">
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblInvNoFrom" runat="server" Text="Invoice No." Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtInvNoFrom" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
             </div>
        </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblDateFrom" runat="server" Text="From Date" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtDateFrom" runat="server" Width="200px" CssClass="inp"></asp:TextBox>
              </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblDateTo" runat="server" Text="To " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtDateTo" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
             </div>
        </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblAmountFrom" runat="server" Text="From Amount" Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtAmountFrom" runat="server" Width="200px" CssClass="inp"></asp:TextBox> 
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                  <asp:Label ID="lblAmountTo" runat="server" Text="To " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtAmountTo" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
             </div>
        </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblDebitor" runat="server" Text="Debtor" Width="180px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtDebitor" runat="server" Width="200px" CssClass="inp"></asp:TextBox>
               </div>
            <div class="field" style="padding:0.55em;height:40px"> 
                  <asp:Label ID="lblCustomer" runat="server" Text="Customer " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtCustomer" runat="server" Width="200px" CssClass="inp" ></asp:TextBox>                  
             </div>
        </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblOrdNo" runat="server" Text="Order No." Width="180px"></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtOrdNo" runat="server" Width="200px" CssClass="inp"></asp:TextBox> 
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                  <asp:Label ID="lblVehicle" runat="server" Text="Vehicle " Width="180px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:TextBox ID="txtVehicle" runat="server" Width="200px" CssClass="inp"></asp:TextBox>                  
             </div>
        </div>
 
        <div class="twelve fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;">
              <div class="field" style="padding:0.55em;">
                <asp:Label ID="lblInvStatus" runat="server" Text="Invoice Status" Width="180px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:RadioButtonList ID="rblVehicleReportList" runat="server" RepeatDirection="Horizontal" Width="300px" Height="30px">
                 <asp:ListItem Text="Active" Selected="true" Value="1"  />
                 <asp:ListItem Text="Cancelled" Value="2" />
                 <asp:ListItem Text="Both" Value="3" />
                </asp:RadioButtonList>  
               </div>
           <div class="field" style="padding:1em;height:40px">
                 <asp:CheckBox ID="chkBatchInvoice" Text="Batch Invoice Only" runat="server" Width="200px" />  
            </div>
            
        </div>

            <div class="twelve fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;">
                 <div class="field" style="padding:0.55em;">
                <asp:Label ID="Label2" runat="server" Text="" Width="180px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:RadioButtonList ID="rdbCreate" runat="server" RepeatDirection="Horizontal" Width="300px" Height="30px">
                 <asp:ListItem Text="CreateCreditNote" Selected="true" Value="1"  />
                 <asp:ListItem Text="CreateCreditOrders" Value="2" />
                </asp:RadioButtonList>  
               </div>
           <div class="field" style="padding:0.55em;height:40px;text-align:center"> 
                  <input id="btnSearch" runat="server" class="ui button"  value="Search" type="button" />  
             </div>  
        </div>
       </div> 
    <div id="modInvoice" class="ui modal">
        <i class="close icon"></i>
        <div class="header">
            Confirm CreditNote Order
        </div>
        <div class="image content">
            <div class="description">
                 <p id="mceMSG"></p>
            </div>
        </div>
        <div class="actions">
             <div class="ui button ok positive">Ok</div>
            <div class="ui button cancel negative">Avbryt</div>
        </div>
    </div>      
       <div style="padding:0.5em"></div>
        <div style="padding:0.5em"></div>
        <div style="padding:0.5em"></div>
         <div class="six fields">
             <div style="text-align:center">
                <input id="btnCreditNote1" runat="server" class="ui button"  value="Credit Note" type="button"   />
                 <input id="btnCNOrder1" runat="server" class="ui button"  value="Create Credit Orders" type="button" onclick="CreateCreditNoteOrders()"   />
                 <input id="btnPrintInvoice1" runat="server" class="ui button" value="Print" type="button"  />
                 <asp:TextBox ID="txtRegnDate" runat="server" Width="200px"></asp:TextBox>  
            </div>
         </div>
         <div style="padding:0.5em"></div>
        <div id="invGrid">
             <table id="dgdInvoice"></table>
                <div id="pagerInvoice"></div>
         </div>
         <div style="padding:0.5em"></div>
            <div class="six fields">
             <div style="text-align:center;padding-right:15em">
                <input id="btnCreditNote2" runat="server" class="ui button"  value="Credit Note" type="button"   />
                <input id="btnCNOrder2" runat="server" class="ui button"  value="Create Credit Orders" type="button" onclick="CreateCreditNoteOrders()"    />
                 <input id="btnPrintInvoice2" runat="server" class="ui button" value="Print" type="button"  />
                 <asp:Label ID="Label1" runat="server" Text="Order No." Width="200px"></asp:Label>

            </div>
         </div>
    
</asp:Content>
