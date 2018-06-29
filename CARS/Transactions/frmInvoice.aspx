<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmInvoice.aspx.vb" Inherits="CARS.frmInvoice" MasterPageFile="~/MasterPage.Master" %>

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
            $('#divSrchInvoice').hide();

            var grid = $("#dgdCreateInv");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            //Invoice 
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Order No. Series', 'Order No.', 'Order Date', 'No. of Jobs', 'Debtor', 'Regn No.', 'Total Amt.', 'Batch? ', 'Order Type','Deb_Id'],
                colModel: [
                         { name: 'Id_WO_Prefix', index: 'Id_WO_Prefix', width: 50, sorttype: "string" },
                         { name: 'Id_WO_NO', index: 'Id_WO_NO', width: 100, sorttype: "string" },
                         { name: 'Dt_Order', index: 'Dt_Order', width: 150, sorttype: "string" },
                         { name: 'No_Of_Jobs', index: 'No_Of_Jobs', width: 50, sorttype: "string" },
                         { name: 'Deb_Name', index: 'Deb_Name', width: 250, sorttype: "string" },
                         { name: 'WO_Veh_Reg_No', index: 'WO_Veh_Reg_No', width: 100, sorttype: "string" },
                         { name: 'WO_Amount', index: 'WO_Amount', width: 100, sorttype: "string" },
                         { name: 'Flg_Cust_Batchinv', index: 'Flg_Cust_Batchinv', width: 50, sorttype: "string" },
                         { name: 'WO_Type', index: 'WO_Type', width: 50, sorttype: "string" },
                         { name: 'Deb_Id', index: 'Deb_Id', sortable: false }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Invoice",
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
                        colNames: ['Job No', 'Description', 'Repair Package', 'Repair Code', 'Amount','Id_WO_Prefix','Id_WO_NO','Id_WoDet_Seq'],
                        colModel: [
                                    { name: "Id_Job", index: "Id_Job", width: 100, key: true },
                                    { name: "WO_Job_Text", index: "WO_Job_Text", width: 250 },
                                    { name: "Rpg_Code_WO", index: "Rpg_Code_WO", width: 200, align: "right" },
                                    { name: "Rep_Code_WO", index: "Rep_Code_WO", width: 200, align: "right" },
                                    { name: "Job_Amount_Format", index: "Job_Amount_Format", width: 100, align: "right" },
                                    { name: "Id_WO_Prefix", index: "Id_WO_Prefix", width: 100, align: "right",hidden:true },
                                    { name: "Id_WO_NO", index: "Id_WO_NO", width: 100, align: "right", hidden: true },
                                    { name: "Id_WoDet_Seq", index: "Id_WoDet_Seq", width: 100, align: "right", hidden: true }
                        ],
                        rowNum: 20,
                        pager: pager_id,
                        sortname: 'num',
                        sortorder: "asc", height: '100%',
                        onCellSelect: function (rowId, iCol, content, event) {
                            var rowdataGrd;
                            rowdataGrd = $("#" + subgrid_table_id).jqGrid('getRowData', rowId);

                            var cm = $("#" + subgrid_table_id).jqGrid('getGridParam', 'colModel');
                            if (cm[iCol].name == "Id_Job") {
                                //alert("hi");
                                var woNo = rowdataGrd.Id_WO_NO;
                                var woPr = rowdataGrd.Id_WO_Prefix;
                                var mode = 'Edit';
                                var flag = encodeURIComponent('Ser');
                                window.location.replace("../Transactions/frmWOJobDetails.aspx?Wonumber=" + woNo + "&WOPrefix=" + woPr + "&Mode=" + mode + "&TabId=" + 2 + "&Flag=" + flag + "&blWOsearch=" + true);
                            }
                        }
                    });
                 //   $("#" + subgrid_table_id).jqGrid('navGrid', "#" + pager_id, { edit: false, add: false, del: false });
                   var mysubdata;//= [];

                    var rowdata = jQuery("#dgdCreateInv").jqGrid('getRowData', row_id);
                    
                    var id_customer = "";//$('#<%=txtCustomer.ClientID%>').val();
                    var id_veh_seq = "";// $('#<%=txtVehicle.ClientID%>').val();
                    var id_wo_no = "";//$('#<%=txtOrder.ClientID%>').val();
                    var emailorders =  $('#<%=chkInclEmail.ClientID%>').is(':checked');
                    id_wo_no = rowdata.Id_WO_Prefix + rowdata.Id_WO_NO;//"V2253776";

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmInvoice.aspx/FetchChildOrdersToBeInvoiced",
                        data: "{id_customer: '" + id_customer + "', id_veh_seq:'" + id_veh_seq + "', id_wo_no:'" + id_wo_no + "', emailorders:'" + emailorders + "'}",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            var subgridData = Result.d[1];
                            if (Result.d.length > 0) {
                                for (i = 0; i < Result.d[1].length; i++) {
                                    mysubdata = Result.d[1];
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


            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtInvDate.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat
            });

            $('#<%=txtInvDate.ClientID%>').keyup(function () {
                if ($(this).val().length == 2 || $(this).val().length == 5) {
                    $(this).val($(this).val() + $('#<%=hdnDateFormatLang.ClientID%>').val());
                }
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

            //Customer autocomplete
            $('#<%=txtCustomer.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Customer_Search",
                        data: "{q:'" + $('#<%=txtCustomer.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtCustomer.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt kunderegister. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME,
                                        val: item.ID_CUSTOMER,
                                        value: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME
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
                    $("#<%=txtCustomer.ClientID%>").val(i.item.val);
                }
            });

            //Order autocomplete
            $('#<%=txtOrder.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/GetOrder",
                        data: "{'orderNo':'" + $('#<%=txtOrder.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2] + "-" + item.split('-')[3] + "-" + item.split('-')[4],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0]
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error Response ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtOrder.ClientID%>").val(i.item.val);
                }
            });

            $('#<%=btnEHFT.ClientID%>').click(function () {
                createEHFInv();
            });

            $('#<%=btnEHFB.ClientID%>').click(function () {
                createEHFInv();
            });


        });//end of ready

        function loadInvoice() {
            $('#divSrchInvoice').show();
            var id_customer = $('#<%=txtCustomer.ClientID%>').val();
            var id_veh_seq = $("#<%=hdnIdVehSeq.ClientID%>").val(); // $('#<%=txtVehicle.ClientID%>').val();
            var id_wo_no = $('#<%=txtOrder.ClientID%>').val();
            var emailorders = $('#<%=chkInclEmail.ClientID%>').is(':checked');
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;      
            
            id_customer = id_customer.split('-')[0].trim();
            id_veh_seq = id_veh_seq.trim();
            id_wo_no = id_wo_no.trim();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvoice.aspx/FetchOrdersToBeInvoiced",
                data: "{id_customer: '" + id_customer + "', id_veh_seq:'" + id_veh_seq + "', id_wo_no:'" + id_wo_no + "', emailorders:'" + emailorders + "'}",
                dataType: "json",
                async: false,
                success: function (Result) {
                    if (Result.d.length > 0) {   
                        jQuery("#dgdCreateInv").jqGrid('clearGridData');
                        for (i = 0; i < Result.d[0].length; i++) {
                            mydata = Result.d[0];
                            jQuery("#dgdCreateInv").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdCreateInv").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        //$("#dgdCreateInv").jqGrid("showCol", "subgrid");
                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function createInv() {
            dataCollection = [];
            $('#dgdCreateInv input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].id;
                    
                    var id_wo_no = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_NO.toString();
                    var id_wo_pr = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_Prefix.toString();
                    var id_job_deb = $('#dgdCreateInv')[0].p.data[row - 1].Deb_Id.toString();
                    var flgbatchinv = $('#dgdCreateInv')[0].p.data[row - 1].Flg_Cust_Batchinv.toString();
                    var invoicedate = $('#<%=txtInvDate.ClientID%>').val();                    

                    <%--var id_wo_no =$('#dgdCreateInv tr')[row].cells[3].innerHTML.toString();
                    var id_wo_pr=$('#dgdCreateInv tr')[row].cells[2].innerHTML.toString();
                    var id_job_deb = $('#dgdCreateInv tr')[row].cells[11].innerHTML.toString();
                    var flgbatchinv = $('#dgdCreateInv tr')[row].cells[9].innerHTML.toString();
                    var invoicedate = $('#<%=txtInvDate.ClientID%>').val();--%>

                    dataCollection.push({
                        ID_WO_NO: id_wo_no,
                        Id_WO_Prefix: id_wo_pr,
                        ID_JOB_DEB: id_job_deb,
                        FLG_BATCH_INV: flgbatchinv,
                        Dt_Order:invoicedate
                    });
                }
            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvoice.aspx/InvoiceProcess",
                data: "{orders: '" + JSON.stringify(dataCollection) + "'}",
                dataType: "json",
                async: false,
                success: function (Result) {
                    if (Result.d.length > 0) {
                        //check status and then
                        if (Result.d[0] == "SUCCESS") {
                            window.open("../Reports/frmShowReports.aspx?ReportHeader='Invoice' &InvoiceType=INVOICE &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        }
                        loadInvoice();

                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function createEHFInv() {
            dataCollection = [];
            $('#dgdCreateInv input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].id;

                    var id_wo_no = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_NO.toString();
                    var id_wo_pr = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_Prefix.toString();
                    var id_job_deb = $('#dgdCreateInv')[0].p.data[row - 1].Deb_Id.toString();
                    var flgbatchinv = $('#dgdCreateInv')[0].p.data[row - 1].Flg_Cust_Batchinv.toString();
                    var invoicedate = $('#<%=txtInvDate.ClientID%>').val();

                    dataCollection.push({
                        ID_WO_NO: id_wo_no,
                        Id_WO_Prefix: id_wo_pr,
                        ID_JOB_DEB: id_job_deb,
                        FLG_BATCH_INV: flgbatchinv,
                        Dt_Order: invoicedate
                    });
                }
            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvoice.aspx/InvoiceProcess",
                data: "{orders: '" + JSON.stringify(dataCollection) + "'}",
                dataType: "json",
                async: false,
                success: function (Result) {
                    if (Result.d.length > 0) {
                        //check status and then
                        if (Result.d[0] == "SUCCESS") {
                            window.open("../Reports/frmShowReports.aspx?ReportHeader='Invoice' &InvoiceType=INVOICE &Rpt=INVOICEPRINT &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        }
                        GenerateXML();
                        loadInvoice();

                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }



        function GenerateXML() {
            $('#dgdCreateInv input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].id;

                    var id_wo_no = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_NO.toString();
                    var id_wo_pr = $('#dgdCreateInv')[0].p.data[row - 1].Id_WO_Prefix.toString();
                    var id_job_deb = $('#dgdCreateInv')[0].p.data[row - 1].Deb_Id.toString();
                    var flgbatchinv = $('#dgdCreateInv')[0].p.data[row - 1].Flg_Cust_Batchinv.toString();
                    var invoicedate = $('#<%=txtInvDate.ClientID%>').val();


                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOJobDetails.aspx/EHF",
                        data: "{'idWoNo':'" + id_wo_no + "',idWoPr:'" + id_wo_pr + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d == "True") {
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=RTlblError.ClientID%>').text('EHF File Created Successfully.');
                            }
                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });

                  
                }
            });

        }


    </script>
    <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server" />
    <asp:HiddenField ID="hdnDateFormatLang" Value="<%$ appSettings:DateFormatLang %>" runat="server" />
    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblInvoice" runat="server" Text="Invoice"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdInvoice" runat="server" />
        <asp:HiddenField id="hdnIdVehSeq" runat="server" />
        
    </div>
    <div class="ui raised segment signup inactive">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
            <a class="item" id="a2" runat="server" >Invoicing</a>
        </div>
        <div>
            <div class="ui form" style="padding-left:2em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblCustomer" runat="server" Text="Customer"></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="txtCustomer" runat="server" CssClass="inp" Width="200px" MaxLength="50" ></asp:TextBox>                       
                    </div>
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblVehicle" runat="server" Text="Vehicle"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtVehicle"  padding="0em" CssClass="inp" Width="200px" runat="server"></asp:TextBox>
                    </div>                    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblOrder" runat="server" Text="Order"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtOrder"  padding="0em" CssClass="inp" Width="200px" runat="server"></asp:TextBox>
                    </div>                    
                </div>
                 <div class="four fields">
                      <div class="field" style="width:160px;">
                        <asp:Label ID="lblInclEmailOrd" runat="server" Text="Include Email Orders"></asp:Label>
                    </div>
                    <div class="field">
                         <asp:CheckBox ID="chkInclEmail" runat="server"  />
                     </div>
                </div>
            </div>
            <div style="text-align:left;padding-bottom:4em;padding-left:15em;padding-top:2em">
                <input id="btnSearch" runat="server" type="button" value="Search" class="ui button"  onclick="loadInvoice()"/>
            </div>
        </div>        
        <div id="divSrchInvoice">
            <div class="field" style="text-align:center;padding-bottom:1em;">
                <input id="btnCreateInvT" runat="server" type="button" value="Create" class="ui button"  onclick="createInv()"/>
                <input id="btnEHFT" runat="server" type="button" value="EHFInvoice" class="ui button" />
                <asp:TextBox ID="txtInvDate"   padding="0em"  Width="200px" runat="server"></asp:TextBox>
            </div>              
            <div>
                <table id="dgdCreateInv" title="Create Invoice" ></table>
                <div id="pager"></div>
            </div>         
            <div style="text-align:center;padding-top:1em;padding-right:15em;">
                <input id="btnCreateInvB" runat="server" type="button" value="Create" class="ui button"  onclick="createInv()"/>
                <input id="btnEHFB" runat="server" type="button" value="EHFInvoice" class="ui button" />

            </div>            
        </div>
    </div>


</asp:Content>