<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfWorkOrder.aspx.vb" Inherits="CARS.frmCfWorkOrder" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

    <script type="text/javascript">

        function fnValidateWO() {
            if ($('#<%=ddlSubsidiary.ClientID%>').val() == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0122', '', ''), '');
                alert(msg);
                $('#<%=ddlSubsidiary.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddlDepartment.ClientID%>').val() == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0049', '', ''), '');
                alert(msg);
                $('#<%=ddlDepartment.ClientID%>').focus();
                return false;
            }

            //Removed add copy fn based on client discussion
            <%--if ((!($("#<%=chkCopyConfig.ClientID%>").is(':checked')))) {
                if ($("#<%=chkAddConfig.ClientID%>").is(':checked')) {
                    if (!(gfi_CheckEmpty($('#<%=txtOrderNumber.ClientID%>'), '0140', ''))) {
                        return false;
                    }
                    if (!(gfi_CheckEmpty($('#<%=txtOrderSeries.ClientID%>'), '0141', ''))) {
                        return false;
                    }
                }
            }--%>

            if ($('#<%=txtOrderNumber.ClientID%>').val() != "" || $('#<%=txtOrderSeries.ClientID%>').val() != "" || $('#<%=txtGarageMaterialPrice.ClientID%>').val() != "") {
                if (!(gfi_CheckEmpty($('#<%=txtOrderNumber.ClientID%>'), '0140', ''))) {
                    return false;
                }
                if (!(gfi_CheckEmpty($('#<%=txtOrderSeries.ClientID%>'), '0141', ''))) {
                    return false;
                }
                if (!(gfi_CheckEmpty($('#<%=txtGarageMaterialPrice.ClientID%>'), '0143', ''))) {
                    return false;
                }
            }

            if (!(ValidateAlphabets($('#<%=txtOrderNumber.ClientID%>'), '0140'))) {
                return false;
            }

            if (!(gfi_ValidateNumber($('#<%=txtOrderSeries.ClientID%>'), '0141'))) {
                return false;
            }

            var gmr
            gmr = $('#<%=txtGarageMaterialPrice.ClientID%>').val();
            if (gmr != "") {
                if (gmr > 100 || gmr == '.') {
                    var msg = GetMultiMessage('0116', GetMultiMessage('0143', '', ''), '');
                    alert(msg);
                    return false;
                }
            }

            if (!(gfi_ValidateNumDot($('#<%=txtGarageMaterialPrice.ClientID%>'), '0143'))) {
                return false;
            }

            //Removed add copy fn based on client discussion
            <%--if ($("#<%=chkCopyConfig.ClientID%>").is(':checked')) {
                if ($('#<%=ddlCopySubsidiary.ClientID%>').val() == "0") {
                    var msg = GetMultiMessage('0007', GetMultiMessage('0144', '', ''), '');
                    alert(msg);
                    $('#<%=ddlCopySubsidiary.ClientID%>').focus();
                    return false;
                }

                if ($('#<%=ddlCopyDepartment.ClientID%>').val() == "0") {
                    var msg = GetMultiMessage('0007', GetMultiMessage('0145', '', ''), '');
                    alert(msg);
                    $('#<%=ddlCopyDepartment.ClientID%>').focus();
                    return false;
                }
                
                if ($('#<%=ddlDepartment.ClientID%> option:selected').text() == $('#<%=ddlCopyDepartment.ClientID%> option:selected').text()) {
                    var msg = GetMultiMessage('0162', '', '');
                    alert(msg);
                }
            }--%>

            return true;
        }


        function fnValidPaytype() {
            if (!(gfi_CheckEmpty($('#<%=txtPayType.ClientID%>'), '0150', ''))) {
                return false;
            }
            if (!(ValidateAlphabets($('#<%=txtPayType.ClientID%>'), '0150'))) {
                return false;
            }
            if (!(ValidateAlphabets($('#<%=txtPayTypeDesc.ClientID%>'), '0150'))) {
                return false;
            }

            window.scrollTo(0, 0);
            return true;
        }

        function fnValidVatData() {
            if ($('#<%=ddlVATCodeCustGrp.ClientID%>').val() == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0154', '', ''), '');
                alert(msg);
                return false;
            }

            if ($('#<%=ddlVATCodeOrdLine.ClientID%>').val() == 0) {
                var msg = GetMultiMessage('0007', GetMultiMessage('VATONLINE', '', ''), '');
                alert(msg);
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtAccountCode.ClientID%>'), '0788', ''))) {
                return false;
            }
            return true
        }


        $(document).ready(function () {
            //$('#divProdGrp').hide();
            $('#divPayType').hide();
            $('#divVATCode').hide();
            $("#accordion").accordion();

            var mydata,vatcodedata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            //var gridProdGrp = $("#dgdProdGrp");
            var gridPayType = $("#dgdPayType");
            var gridVATCode = $("#dgdVATCode");
            var subId = '<%= Session("UserSubsidiary")%>';
            var deptId = '<%= Session("UserDept")%>';

<%--            $('#<%=ddlCopySubsidiary.ClientID%>').attr('disabled', 'disabled');
            $('#<%=ddlCopyDepartment.ClientID%>').attr('disabled', 'disabled');--%>

            fillSubsidiary();
            fillStatus();

            //Product Group
            //gridProdGrp.jqGrid({
            //    datatype: "local",
            //    data: mydata,
            //    colNames: ['Product Group', 'Discount Code', 'VAT Code', 'Description','Id_Disc_Seq','Id_Item_Catg_Map', ''],
            //    colModel: [
            //             { name: 'Product_Group', index: 'Product_Group', width: 160, sorttype: "string" },
            //             { name: 'Disc_Code', index: 'Disc_Code', width: 160, sorttype: "string" },
            //             { name: 'VAT_Code', index: 'VAT_Code', width: 160, sorttype: "string" },
            //             { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
            //             { name: 'Id_Disc_Seq', index: 'Id_Disc_Seq', width: 160, sorttype: "string", hidden: true },
            //             { name: 'Id_Item_Catg_Map', index: 'Id_Item_Catg_Map', width: 160, sorttype: "string", hidden: true },
            //             { name: 'Id_Disc_Seq', index: 'Id_Disc_Seq', sortable: false, formatter: editProdGroup }
            //    ],
            //    multiselect: true,
            //    pager: jQuery('#pagerProdGrp'),
            //    rowNum: pageSize,//can fetch from webconfig
            //    rowList: 5,
            //    sortorder: 'asc',
            //    viewrecords: true,
            //    height: "50%",
            //    caption: "ProdGrp",
            //    async: false, //Very important,
            //    subgrid: false

            //});

            //PAYMENT TYPE
            gridPayType.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Description', 'Remarks','IdSettings', ''],
                colModel: [
                         { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                         { name: 'Remarks', index: 'Remarks', width: 160, sorttype: "string" },
                         { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string",hidden:true },
                         { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPayType }
                ],
                multiselect: true,
                pager: jQuery('#pagerPayType'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "PayType",
                async: false, //Very important,
                subgrid: false

            });

            //VAT 
            gridVATCode.jqGrid({
                datatype: "local",
                data: vatcodedata,
                colNames: ['VAT Code on Product Group', 'VAT Code on Customer Group', 'VAT Code on Vehicle', 'VAT Code on Order Line', 'Last changed On', 'Last changed By', 'Account Code', 'Status', 'Id_Vat_Seq', ''],
                colModel: [
                         { name: 'VatCodeOnItem', index: 'VatCodeOnItem', width: 200, sorttype: "string" },
                         { name: 'VatCodeOnCust', index: 'VatCodeOnCust', width: 200, sorttype: "string" },
                         { name: 'VatCodeOnVehicle', index: 'VatCodeOnVehicle', width: 200, sorttype: "string"},
                         { name: 'VatCodeOnOrderLine', index: 'VatCodeOnOrderLine', width: 200, sorttype: "string" },
                         { name: 'LastChangedOn', index: 'LastChangedOn', width: 200, sorttype: "string" },
                         { name: 'LastChangedBy', index: 'LastChangedBy', width: 200, sorttype: "string" },
                         { name: 'Vat_Acccode', index: 'Vat_Acccode', width: 200, sorttype: "string" },
                         { name: 'VatStatus', index: 'VatStatus', width: 200, sorttype: "string", hidden: true },
                         { name: 'Id_Vat_Seq', index: 'Id_Vat_Seq', width: 200, sorttype: "string", hidden: true },
                         { name: 'Id_Vat_Seq', index: 'Id_Vat_Seq', sortable: false, formatter: editVATCode }
                ],
                multiselect: true,
                pager: jQuery('#pagerVATCode'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "VATCode",
                async: false, //Very important,
                subgrid: false

            });

            loadConfigWorkOrder(subId,deptId);

            //Removed add copy fn based on client discussion
          <%-- $('#<%=chkCopyConfig.ClientID%>').click(function (event) {
                if (this.checked) {
                    $('#<%=ddlCopySubsidiary.ClientID%>').removeAttr("disabled");
                    $('#<%=ddlCopyDepartment.ClientID%>').removeAttr("disabled");
                }
                else {
                    $('#<%=ddlCopySubsidiary.ClientID%>').attr('disabled', 'disabled');
                    $('#<%=ddlCopyDepartment.ClientID%>').attr('disabled', 'disabled');
                }
            });--%>

            $('#<%=ddlSubsidiary.ClientID%>').change(function (e) {
                if ($('#<%=ddlSubsidiary.ClientID%>').val() != "0")
                {
                    fillDepartment();
                } else {
                    $('#<%=ddlDepartment.ClientID%>')[0].selectedIndex = 0;
                }                
            });

            <%--$('#<%=ddlCopySubsidiary.ClientID%>').change(function (e) {
                if ($('#<%=ddlCopySubsidiary.ClientID%>').val() != "0") {
                    fillCopyDepartment();
                } else {
                    $('#<%=ddlCopyDepartment.ClientID%>')[0].selectedIndex = 0;
                }
            });--%>

            $('#<%=ddlDepartment.ClientID%>').change(function (e) {
                if ($('#<%=ddlDepartment.ClientID%>').val() != "0") {
                    var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
                    var deptId = $('#<%=ddlDepartment.ClientID%>').val();
                    loadConfigWorkOrder(subId,deptId);
                } else {
                    $('#<%=ddlDepartment.ClientID%>')[0].selectedIndex = 0;
                }
            });

            $('#<%=chkUseDefCust.ClientID%>').click(function (event) {
                if (this.checked) {
                    $('#<%=txtCustomer.ClientID%>').removeAttr("disabled");
                }
                else {
                    $('#<%=txtCustomer.ClientID%>').val("");
                    $('#<%=txtCustomer.ClientID%>').attr('disabled', 'disabled');
                }
            });


            //Autocomplete Customer
            $('#<%=txtCustomer.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfWorkOrder.aspx/GetCustomer",
                        data: "{'custName':'" + $('#<%=txtCustomer.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0]
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
                },
            });


        });//end of ready

           function fillStatus() {
            var ordType = "ORD";
            $.ajax({
                type: "POST",
                url: "frmCfWorkOrder.aspx/LoadStatus",
                data: "{'ordType':'" + ordType + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlStatus.ClientID%>').empty();
                    $('#<%=ddlStatus.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                            if ((value.Id_Settings == "CSA") || (value.Id_Settings == "JST") || (value.Id_Settings == "RES")) {
                                $('#<%=ddlStatus.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                            }                        
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function fillSubsidiary() {
            $.ajax({
                type: "POST",
                url: "frmCfWorkOrder.aspx/LoadSubsidiary",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlSubsidiary.ClientID%>').empty();
                    $('#<%=ddlSubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                    });

                    <%--$('#<%=ddlCopySubsidiary.ClientID%>').empty();
                    $('#<%=ddlCopySubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlCopySubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                    });--%>
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function fillDepartment() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            $.ajax({
                type: "POST",
                url: "frmCfWorkOrder.aspx/LoadDepartment",
                data: "{'subId':'" + subId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlDepartment.ClientID%>').empty();
                    $('#<%=ddlDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDepartment.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        <%--function fillCopyDepartment() {
            var subId = $('#<%=ddlCopySubsidiary.ClientID%>').val();
            $.ajax({
                type: "POST",
                url: "frmCfWorkOrder.aspx/LoadDepartment",
                data: "{'subId':'" + subId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlCopyDepartment.ClientID%>').empty();
                    $('#<%=ddlCopyDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlCopyDepartment.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }--%>



        function loadConfigWorkOrder(subId, deptId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfWorkOrder.aspx/LoadConfigWorkOrder",
                data: "{'subId':'" + subId + "', deptId:'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=ddlSubsidiary.ClientID%>').val(data.d[0][0].Id_Subsidery);
                        fillDepartment();
                        $('#<%=ddlDepartment.ClientID%>').val(data.d[0][0].Id_Dept);
                        $('#<%=txtOrderNumber.ClientID%>').val(data.d[0][0].WOPr);
                        $('#<%=txtOrderSeries.ClientID%>').val(data.d[0][0].WO_Curr_Series);
                        $('#<%=txtGarageMaterialPrice.ClientID%>').val(data.d[0][0].WO_GMPrice_Perc);
                        $('#<%=RTlblOrderNumber.ClientID%>').text(data.d[0][0].WOPr);
                        $('#<%=RTlblOrderSeries.ClientID%>').text(data.d[0][0].Ord_Ser);
                        $('#<%=RTlblCurSeries.ClientID%>').text(data.d[0][0].WO_Curr_Series);
                        $('#<%=RTlblGarageMaterial.ClientID%>').text(data.d[0][0].WO_GMPrice_Perc);
                        $('#<%=txtVACode.ClientID%>').val(data.d[0][0].VA_ACC_Code);
                        
                        if (data.d[0][0].WO_Status != "") {
                            $('#<%=ddlStatus.ClientID%>').val(data.d[0][0].WO_Status);
                        } else {
                            $('#<%=ddlStatus.ClientID%>')[0].selectedIndex = 0;
                        }

                        if (data.d[0][0].WO_Charege_Base != "") {
                            $('#<%=cmbChargeBasedOn.ClientID%>').val(data.d[0][0].WO_Charege_Base);
                        } else {
                            $('#<%=cmbChargeBasedOn.ClientID%>')[0].selectedIndex = 0;
                        }

                        if (data.d[0][0].WO_VAT_CalcRisk == "False") {
                            $("#<%=chkIsVatCalculate.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkIsVatCalculate.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_Delv_Address == "False") {
                            $("#<%=chkUseDeliveryAddress.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkUseDeliveryAddress.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_Manual_Rwrk == "False") {
                            $("#<%=chkUseManualRwrk.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkUseManualRwrk.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_Vehicle_Sp == "False") {
                            $("#<%=chkUseVehicle.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkUseVehicle.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_Pc_Job == "False") {
                            $("#<%=chkUsePCJob.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkUsePCJob.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_Default_Cust == "False") {
                            $("#<%=chkUseDefCust.ClientID%>").attr('checked', false);
                            $('#<%=txtCustomer.ClientID%>').attr('disabled', 'disabled');
                            $('#<%=txtCustomer.ClientID%>').val("");
                        } else {
                            $("#<%=chkUseDefCust.ClientID%>").attr('checked', true);
                            $('#<%=txtCustomer.ClientID%>').val(data.d[0][0].IdCustomer);
                            $('#<%=txtCustomer.ClientID%>').removeAttr("disabled");
                        }
                        if (data.d[0][0].Use_Cnfrm_Dialogue == "False") {
                            $("#<%=chkCnfrmDialog.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkCnfrmDialog.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_SaveJob_Grid == "False") {
                            $("#<%=chkSaveJob.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkSaveJob.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_VA_ACC_Code == "False") {
                            $("#<%=chkVAACCCode.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkVAACCCode.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Use_All_Spare_Search == "False") {
                            $("#<%=chkAllSpareSearch.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkAllSpareSearch.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].Disp_Rinv_Pinv == "False") {
                            $("#<%=chkDispRINVPINV.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkDispRINVPINV.ClientID%>").attr('checked', true);
                        }
                        if (data.d[0][0].WO_Status == "") {
                            $("#<%=chkDefStat.ClientID%>").attr('checked', false);
                        } else {
                            $("#<%=chkDefStat.ClientID%>").attr('checked', true);
                        }

                       // loadProdGroup(data.d[1]);

                        //Removed since not used
                        //fillProductGrp(data.d[7]);
                        //fillDiscountCode(data.d[5]);
                        //fillVATCode(data.d[6]);
                        loadPayType(data.d[2]);
                        loadVATCode(data.d[3]);
                        fillVATCode(data.d[6]);
                    }
                }
            });
        }

        function saveWorkOrder() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var woPrefix = $('#<%=txtOrderNumber.ClientID%>').val();
            var woSeries = $('#<%=txtOrderSeries.ClientID%>').val();
            var ownRisk = $("#<%=chkIsVatCalculate.ClientID%>").is(':checked');
            var woGMPerc = $('#<%=txtGarageMaterialPrice.ClientID%>').val();
            var woChrgBase = $('#<%=cmbChargeBasedOn.ClientID%>').val();
            var useDelvAddr = $("#<%=chkUseDeliveryAddress.ClientID%>").is(':checked');
            var useManualRwrk = $("#<%=chkUseManualRwrk.ClientID%>").is(':checked');
            var useVeh = $("#<%=chkUseVehicle.ClientID%>").is(':checked');
            var usePCJob = $("#<%=chkUsePCJob.ClientID%>").is(':checked');
            var woStatus ;
            if ($("#<%=chkDefStat.ClientID%>").is(':checked')) {
                woStatus = $("#<%=ddlStatus.ClientID%>").val();
            } else { woStatus = "" };
            var useDefCust = $("#<%=chkUseDefCust.ClientID%>").is(':checked');
            var idCustomer = $('#<%=txtCustomer.ClientID%>').val();
            var useConfirmDialogue = $("#<%=chkCnfrmDialog.ClientID%>").is(':checked');
            var useSaveJobGrid = $("#<%=chkSaveJob.ClientID%>").is(':checked');
            var useVAAccCode = $("#<%=chkVAACCCode.ClientID%>").is(':checked');
            var vaAccntCode = $('#<%=txtVACode.ClientID%>').val();
            var useSpareSearch = $("#<%=chkAllSpareSearch.ClientID%>").is(':checked');
            var dispRinvPinv = $("#<%=chkDispRINVPINV.ClientID%>").is(':checked');

            var result= fnValidateWO();
            if (result == true) {

                //Removed add copy fn based on client discussion
                <%--if ($("#<%=chkCopyConfig.ClientID%>").is(':checked')) {
                    saveCopyWOConfig();
                } else {--%>

                    $.ajax({
                        type: "POST",
                        url: "frmCfWorkOrder.aspx/SaveWorkOrderConfig",
                        data: "{'idSub':'" + subId + "', idDept:'" + deptId + "', woPrefix:'" + woPrefix + "', woSeries:'" + woSeries + "', ownRisk:'" + ownRisk + "', woGMPerc:'" + woGMPerc + "', woChrgBase:'" + woChrgBase + "', useDelvAddr:'" + useDelvAddr + "', useManualRwrk:'" + useManualRwrk + "', useVeh:'" + useVeh + "', usePCJob:'" + usePCJob + "', woStatus:'" + woStatus + "', useDefCust:'" + useDefCust + "', idCustomer:'" + idCustomer + "', useConfirmDialogue:'" + useConfirmDialogue + "', useSaveJobGrid:'" + useSaveJobGrid + "', useVAAccCode:'" + useVAAccCode + "', vaAccntCode:'" + vaAccntCode + "', useSpareSearch:'" + useSpareSearch + "', dispRinvPinv:'" + dispRinvPinv + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            if (Result.d[0] == "UPDATE" || Result.d[0] == "INST") {
                                loadConfigWorkOrder(subId,deptId);
                                $('#<%=RTlblError.ClientID%>').text(Result.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            }
                            else {
                                $('#<%=RTlblError.ClientID%>').text(Result.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                            }
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
               // }
            }
        }

        <%--function saveCopyWOConfig() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var copySubId = $('#<%=ddlCopySubsidiary.ClientID%>').val();
            var copyDeptId = $('#<%=ddlCopyDepartment.ClientID%>').val();

            if (deptId != "0" && copyDeptId !="0"){
                if (deptId != copyDeptId) {
                    $.ajax({
                        type: "POST",
                        url: "frmCfWorkOrder.aspx/SaveWOCopy",
                        data: "{'subId':'" + subId + "', deptId:'" + deptId + "', copySubId:'" + copySubId + "', copyDeptId:'" + copyDeptId + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            if (Result.d != "") {
                                loadConfigWorkOrder(subId,deptId);
                                $('#<%=RTlblError.ClientID%>').text(Result.d);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            }
                            else {
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                            }
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
                }
            }
        }--%>


        //Removed since not used
        <%-- function fillProductGrp(data){
            $('#<%=ddlProdGrp.ClientID%>').empty();
            $('#<%=ddlProdGrp.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlProdGrp.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });
        }

        function fillDiscountCode(data) {
            $('#<%=ddlDiscCode.ClientID%>').empty();
            $('#<%=ddlDiscCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlDiscCode.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });
        }

        function fillVATCode(data) {
            $('#<%=ddlVATCode.ClientID%>').empty();
            $('#<%=ddlVATCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlVATCode.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });
        }


        function editProdGroup(cellvalue, options, rowObject) {

            var iddiscseq = rowObject.Id_Disc_Seq.toString();
            var prodgrp = rowObject.Id_Item_Catg_Map.toString();
            var disccode = rowObject.Disc_Code.toString();
            var vatcode = rowObject.VAT_Code.toString();
            var description = rowObject.Description.toString();

            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editProdGrp(" + "'" + iddiscseq + "','" + prodgrp + "','" + disccode + "','" + vatcode + "','" + description + "'" + "); />";
            return edit;
        }

        function editProdGrp(iddiscseq, prodgrp, disccode, vatcode, description) {
            $('#divProdGrp').show();
            $('#<%=hdnProdGrpId.ClientID%>').val(iddiscseq);
            $('#<%=ddlProdGrp.ClientID%>').val(prodgrp);
            $('#<%=ddlDiscCode.ClientID%> option:contains("' + disccode + '")').attr('selected', 'selected');
            $('#<%=ddlVATCode.ClientID%> option:contains("' + vatcode + '")').attr('selected', 'selected');
            $('#<%=txtDiscCodeDesc.ClientID%>').val(description);
            $('#<%=btnAddProdGrpT.ClientID%>').hide();
            $('#<%=btnDelProdGrpT.ClientID%>').hide();
            $('#<%=btnAddProdGrpB.ClientID%>').hide();
            $('#<%=btnDelProdGrpB.ClientID%>').hide();
            $('#<%=btnSaveProdGrp.ClientID%>').show();
            $('#<%=btnResetProdGrp.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function addProdGrp() {
            $('#divProdGrp').show();
            $('#<%=hdnProdGrpId.ClientID%>').val("");
            $('#<%=ddlProdGrp.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlDiscCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=btnAddProdGrpT.ClientID%>').hide();
            $('#<%=btnDelProdGrpT.ClientID%>').hide();
            $('#<%=btnAddProdGrpB.ClientID%>').hide();
            $('#<%=btnDelProdGrpB.ClientID%>').hide();
            $('#<%=btnSaveProdGrp.ClientID%>').show();
            $('#<%=btnResetProdGrp.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");

        }

        function loadProdGroup(data) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdProdGrp").jqGrid('clearGridData');
            for (i = 0; i < data.length; i++) {
                mydata = data;
                jQuery("#dgdProdGrp").jqGrid('addRowData', i + 1, mydata[i]);
            }
            jQuery("#dgdProdGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdProdGrp").jqGrid("hideCol", "subgrid");
            return true;
        }

        function resetProdGrp() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divProdGrp').hide();
                $('#<%=ddlProdGrp.ClientID%>')[0].selectedIndex = 0;
                $('#<%=ddlDiscCode.ClientID%>')[0].selectedIndex = 0;
                $('#<%=ddlVATCode.ClientID%>')[0].selectedIndex = 0;
                $('#<%=txtDiscCodeDesc.ClientID%>').val("");
                $('#<%=btnAddProdGrpT.ClientID%>').show();
                $('#<%=btnAddProdGrpB.ClientID%>').show();
                $('#<%=btnDelProdGrpT.ClientID%>').show();
                $('#<%=btnDelProdGrpB.ClientID%>').show();
                $('#<%=btnSaveProdGrp.ClientID%>').hide();
                $('#<%=btnResetProdGrp.ClientID%>').hide();
                $('#<%=hdnProdGrpId.ClientID%>').val("");
            }
        }

        function saveProdGrp() {

            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var prodGrp = $('#<%=ddlProdGrp.ClientID%>').val();
            var discCode = $('#<%=ddlDiscCode.ClientID%>').val();
            var vatCode = $('#<%=ddlVATCode.ClientID%>').val();
            var prodDesc = $('#<%=txtDiscCodeDesc.ClientID%>').val();
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var prodGrpId = $('#<%=hdnProdGrpId.ClientID%>').val();

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfWorkOrder.aspx/SaveProdGrp",
                    data: "{prodGrpId: '" + prodGrpId + "', prodGrp:'" + prodGrp + "', discCode:'" + discCode + "', vatCode:'" + vatCode + "', prodDesc:'" + prodDesc + "', subId:'" + subId + "', deptId:'" + deptId + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "SAVED" || data.d[0]=="UPDATED") {
                            $('#divProdGrp').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddProdGrpT.ClientID%>').show();
                            $('#<%=btnAddProdGrpB.ClientID%>').show();
                            $('#<%=btnDelProdGrpT.ClientID%>').show();
                            $('#<%=btnDelProdGrpB.ClientID%>').show();
                            jQuery("#dgdProdGrp").jqGrid('clearGridData');
                            loadConfigWorkOrder();
                            jQuery("#dgdProdGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
        }--%>

        //PAYMENT TYPE
        function loadVATCode(data) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdVATCode").jqGrid('clearGridData');
            for (i = 0; i < data.length; i++) {
                vatcodedata = data;
                jQuery("#dgdVATCode").jqGrid('addRowData', i + 1, vatcodedata[i]);
            }
            jQuery("#dgdVATCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdVATCode").jqGrid("hideCol", "subgrid");
            return true;
        }

        function editPayType(cellvalue, options, rowObject) {
            var idsettings = rowObject.IdSettings.toString();
            var description = rowObject.Remarks.toString();
            var paytype = rowObject.Description.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPaymentType(" + "'" + idsettings + "','" + description + "','" + paytype + "'" + "); />";
            return edit;
        }

        function editPaymentType(idsettings, description, paytype) {
            $('#<%=txtPayTypeDesc.ClientID%>').val(description);
            $('#<%=txtPayType.ClientID%>').val(paytype);
            $('#<%=hdnPayTypeId.ClientID%>').val(idsettings);
            $('#divPayType').show();
            $('#<%=btnAddPayTypeT.ClientID%>').hide();
            $('#<%=btnAddPayTypeB.ClientID%>').hide();
            $('#<%=btnDelPayTypeT.ClientID%>').hide();
            $('#<%=btnDelPayTypeB.ClientID%>').hide();
            $('#<%=btnSavePayType.ClientID%>').show();
            $('#<%=btnResetPayType.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");

        }

        function addPayType() {
            $('#divPayType').show();
            $('#<%=hdnPayTypeId.ClientID%>').val("");
            $('#<%=txtPayTypeDesc.ClientID%>').val("");
            $('#<%=txtPayType.ClientID%>').val("");
            $('#<%=btnAddPayTypeT.ClientID%>').hide();
            $('#<%=btnDelPayTypeT.ClientID%>').hide();
            $('#<%=btnAddPayTypeB.ClientID%>').hide();
            $('#<%=btnDelPayTypeB.ClientID%>').hide();
            $('#<%=btnSavePayType.ClientID%>').show();
            $('#<%=btnResetPayType.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Add");

        }

        function loadPayType(data) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdPayType").jqGrid('clearGridData');
            for (i = 0; i < data.length; i++) {
                mydata = data;
                jQuery("#dgdPayType").jqGrid('addRowData', i + 1, mydata[i]);
            }
            jQuery("#dgdPayType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdPayType").jqGrid("hideCol", "subgrid");
            return true;

        }

        function savePayType() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var payType = $('#<%=txtPayType.ClientID%>').val();
            var payTypeDesc = $('#<%=txtPayTypeDesc.ClientID%>').val();
            var payTypeId = $('#<%=hdnPayTypeId.ClientID%>').val();
            var idConfig = "PAYTYPE";
            var result = fnValidPaytype();
            if (result == true) {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfWorkOrder.aspx/SavePayType",
                    data: "{idConfig: '" + idConfig + "', payType:'" + payType + "', payTypeId:'" + payTypeId + "', payTypeDesc:'" + payTypeDesc + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "SAVED" || data.d[0] == "UPDATED") {
                            $('#divPayType').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddPayTypeT.ClientID%>').show();
                            $('#<%=btnAddPayTypeB.ClientID%>').show();
                            $('#<%=btnDelPayTypeT.ClientID%>').show();
                            $('#<%=btnDelPayTypeB.ClientID%>').show();
                            jQuery("#dgdPayType").jqGrid('clearGridData');
                            loadConfigWorkOrder(subId,deptId);
                            jQuery("#dgdPayType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");

                            if (data.d[0] == "SAVED") {
                                alert(GetMultiMessage('MSG062', '', ''));
                            }

                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }

        function resetPayType() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divPayType').hide();
                $('#<%=txtPayTypeDesc.ClientID%>').val("");
                $('#<%=txtPayType.ClientID%>').val("");
                $('#<%=btnAddPayTypeT.ClientID%>').show();
                $('#<%=btnAddPayTypeB.ClientID%>').show();
                $('#<%=btnDelPayTypeT.ClientID%>').show();
                $('#<%=btnDelPayTypeB.ClientID%>').show();
                $('#<%=btnSavePayType.ClientID%>').hide();
                $('#<%=btnResetPayType.ClientID%>').hide();
                $('#<%=hdnPayTypeId.ClientID%>').val("");
            }
        }

        function delPayType() {
            var paytype = "";
            $('#dgdPayType input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    paytype = $('#dgdPayType tr ')[row].cells[3].innerHTML.toString();
                }
            });

            if (paytype != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deletePayType();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deletePayType() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var row;
            var pcpaytypeid;
            var pcpaytypedesc;
            var pcpaytypeidxml;
            var pcpaytypeidxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdPayType input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    pcpaytypeid = $('#dgdPayType tr ')[row].cells[3].innerHTML.toString();
                    pcpaytypedesc = $('#dgdPayType tr ')[row].cells[1].innerHTML.toString();
                    pcpaytypeidxml = '<delete><PAYTYPE ID_SETTINGS= "' + pcpaytypeid + '" ID_CONFIG= "PAYTYPE" DESCRIPTION= "' + pcpaytypedesc + '"/></delete>';
                    pcpaytypeidxmls += pcpaytypeidxml;
                }
            });

            if (pcpaytypeidxmls != "") {
                pcpaytypeidxmls = "<root>" + pcpaytypeidxmls + "</root>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfWorkOrder.aspx/DeletePayType",
                    data: "{delxml: '" + pcpaytypeidxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            jQuery("#dgdPayType").jqGrid('clearGridData');
                            loadConfigWorkOrder(subId,deptId);
                            jQuery("#dgdPayType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divPayType').hide();
                        }
                        else if (data.d[0] == "NDEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        //VAT CODE
        function fillVATCode(data) {
            //Product Group
            $('#<%=ddlVATCodeProdGrp.ClientID%>').empty();
            $('#<%=ddlVATCodeProdGrp.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlVATCodeProdGrp.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });

            //Customer Group
            $('#<%=ddlVATCodeCustGrp.ClientID%>').empty();
            $('#<%=ddlVATCodeCustGrp.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlVATCodeCustGrp.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });

            //Vehicle
            $('#<%=ddlVATCodeVeh.ClientID%>').empty();
            $('#<%=ddlVATCodeVeh.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlVATCodeVeh.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });

            //Order Line
            $('#<%=ddlVATCodeOrdLine.ClientID%>').empty();
            $('#<%=ddlVATCodeOrdLine.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $.each(data, function (key, value) {
                $('#<%=ddlVATCodeOrdLine.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });
        }

        function editVATCode(cellvalue, options, rowObject) {
            var idVatSeq = rowObject.Id_Vat_Seq.toString();
            var vatcodeoncust = rowObject.VatCodeOnCust.toString();
            var vatcodeonitem = rowObject.VatCodeOnItem.toString();
            var vatcodeonveh = rowObject.VatCodeOnVehicle.toString();
            var vatcodeonordline = rowObject.VatCodeOnOrderLine.toString();
            var vatacccode = rowObject.Vat_Acccode.toString();

            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editVATCodeDetails(" + "'" + idVatSeq + "','" + vatcodeoncust + "','" + vatcodeonitem + "','" + vatcodeonveh + "','" + vatcodeonordline + "','" + vatacccode + "'" + "); />";
            return edit;
        }

        function editVATCodeDetails(idVatSeq, vatcodeoncust, vatcodeonitem, vatcodeonveh, vatcodeonordline, vatacccode) {
            $('#<%=txtAccountCode.ClientID%>').val(vatacccode);
            $('#<%=hdnVATCodeId.ClientID%>').val(idVatSeq);

            if (vatcodeonitem == "") {
                $('#<%=ddlVATCodeProdGrp.ClientID%>')[0].selectedIndex = 0;
            } else {
                $('#<%=ddlVATCodeProdGrp.ClientID%> option:contains("' + vatcodeonitem + '")').attr('selected', 'selected');
            }
            if (vatcodeoncust == "") {
                $('#<%=ddlVATCodeCustGrp.ClientID%>')[0].selectedIndex = 0;
            } else {
                $('#<%=ddlVATCodeCustGrp.ClientID%> option:contains("' + vatcodeoncust + '")').attr('selected', 'selected');
            }
            if (vatcodeonveh == "") {
                $('#<%=ddlVATCodeVeh.ClientID%>')[0].selectedIndex = 0;
            } else {
                $('#<%=ddlVATCodeVeh.ClientID%> option:contains("' + vatcodeonveh + '")').attr('selected', 'selected');
            }
            if (vatcodeonordline == "") {
                $('#<%=ddlVATCodeOrdLine.ClientID%>')[0].selectedIndex = 0;
            } else {
                $('#<%=ddlVATCodeOrdLine.ClientID%> option:contains("' + vatcodeonordline + '")').attr('selected', 'selected');
            }

            
            $('#<%=ddlVATCodeOrdLine.ClientID%> option:contains("' + vatcodeonordline + '")').attr('selected', 'selected');
            $('#divVATCode').show();
            $('#<%=btnAddVATCodeT.ClientID%>').hide();
            $('#<%=btnAddVATCodeB.ClientID%>').hide();
            $('#<%=btnDelVATCodeT.ClientID%>').hide();
            $('#<%=btnDelVATCodeB.ClientID%>').hide();
            $('#<%=btnSaveVATCode.ClientID%>').show();
            $('#<%=btnResetVATCode.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function addVATCode() {
            $('#divVATCode').show();
            $('#<%=hdnVATCodeId.ClientID%>').val("");
            $('#<%=txtAccountCode.ClientID%>').val("");
            $('#<%=ddlVATCodeProdGrp.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeCustGrp.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeVeh.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeOrdLine.ClientID%>')[0].selectedIndex = 0;
            $('#<%=btnAddVATCodeT.ClientID%>').hide();
            $('#<%=btnDelVATCodeT.ClientID%>').hide();
            $('#<%=btnAddVATCodeB.ClientID%>').hide();
            $('#<%=btnDelVATCodeB.ClientID%>').hide();
            $('#<%=btnSaveVATCode.ClientID%>').show();
            $('#<%=btnResetVATCode.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Add");
        }

        function resetVATCode() {
            $('#divVATCode').hide();
            $('#<%=hdnVATCodeId.ClientID%>').val("");
            $('#<%=txtAccountCode.ClientID%>').val("");
            $('#<%=ddlVATCodeProdGrp.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeCustGrp.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeVeh.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVATCodeOrdLine.ClientID%>')[0].selectedIndex = 0;
            $('#<%=btnAddVATCodeT.ClientID%>').show();
            $('#<%=btnDelVATCodeT.ClientID%>').show();
            $('#<%=btnAddVATCodeB.ClientID%>').show();
            $('#<%=btnDelVATCodeB.ClientID%>').show();
            $('#<%=btnSaveVATCode.ClientID%>').hide();
            $('#<%=btnResetVATCode.ClientID%>').hide();
            $('#<%=hdnMode.ClientID%>').val("");
        }

        function saveVATCode() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var vatcodeoncust = $('#<%=ddlVATCodeCustGrp.ClientID%>').val();
            var vatcodeonitem = $('#<%=ddlVATCodeProdGrp.ClientID%>').val();
            var vatcodeonveh = $('#<%=ddlVATCodeVeh.ClientID%>').val();
            var vatcodeonordline = $('#<%=ddlVATCodeOrdLine.ClientID%> option:selected').text();
            var vatacccode = $('#<%=txtAccountCode.ClientID%>').val();
            var vatCodeId = $('#<%=hdnVATCodeId.ClientID%>').val();

            var result = fnValidVatData();
            if (result == true) {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfWorkOrder.aspx/SaveVATCode",
                    data: "{vatCodeId: '" + vatCodeId + "', vatcodeoncust:'" + vatcodeoncust + "', vatcodeonitem:'" + vatcodeonitem + "', vatcodeonveh:'" + vatcodeonveh + "', vatcodeonordline:'" + vatcodeonordline + "', vatacccode:'" + vatacccode + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "SAVED" || data.d[0] == "UPDATED") {
                            $('#divVATCode').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddVATCodeT.ClientID%>').show();
                            $('#<%=btnAddVATCodeB.ClientID%>').show();
                            $('#<%=btnDelVATCodeT.ClientID%>').show();
                            $('#<%=btnDelVATCodeB.ClientID%>').show();
                            jQuery("#dgdVATCode").jqGrid('clearGridData');
                            loadConfigWorkOrder(subId,deptId);
                            jQuery("#dgdVATCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }

        function delVATCode() {
            var vatCodeId = "";
            $('#dgdVATCode input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    vatCodeId = $('#dgdVATCode tr ')[row].cells[9].innerHTML.toString();
                }
            });

            if (vatCodeId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteVATCode();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteVATCode() {
            var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
            var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var row;
            var vatCodeId;
            var vatCodeDesc;
            var vatCodeIdxml;
            var vatCodeIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdVATCode input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    vatCodeId = $('#dgdVATCode tr ')[row].cells[9].innerHTML.toString();
                    vatCodeIdxml = "<VAT><ID_VAT_SEQ>" + vatCodeId + "</ID_VAT_SEQ></VAT>";
                    vatCodeIdxmls += vatCodeIdxml;
                }
            });

            if (vatCodeIdxmls != "") {
                vatCodeIdxmls = "<ROOT>" + vatCodeIdxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfWorkOrder.aspx/DeleteVATCode",
                    data: "{delxml: '" + vatCodeIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            jQuery("#dgdVATCode").jqGrid('clearGridData');
                            loadConfigWorkOrder(subId,deptId);
                            jQuery("#dgdVATCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divVATCode').hide();
                        }
                        else if (data.d[0] == "NDEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }




    </script>


    

     <div class="header1 two fields" style="padding-top:0.5em">
            <asp:Label ID="lblHead" runat="server" Text="Work Order Configuration" ></asp:Label>
            <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
            <asp:HiddenField id="hdnPageSize" runat="server" />  
            <asp:HiddenField id="hdnEditCap" runat="server" />
            <asp:HiddenField id="hdnMode" runat="server" /> 
            <asp:HiddenField id="hdnSelect" runat="server" />  
            <%--<asp:HiddenField id="hdnProdGrpId" runat="server" />--%>
            <asp:HiddenField id="hdnPayTypeId" runat="server" />
            <asp:HiddenField id="hdnVATCodeId" runat="server" />         
     </div>  

    <div id="accordion" >
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
             <a class="item" id="a2" runat="server" >Work Order Configuration</a>
        </div>
        <div class="ui form" style="width: 100%;">
             <div class="four fields">
                <div class="field" style="width:180px">
                    <%--<asp:CheckBox ID="chkAddConfig" runat="server" Text="Add Configuration" />--%>
                </div>
                <div class="field" style="width:200px">
                    <%--<asp:CheckBox ID="chkCopyConfig" runat="server" Text="Copy Configuration"  />--%>
                </div>      
                                       
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblSubsidiary" runat="server" Text="Subsidiary"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlSubsidiary" runat="server" Width="156px" ></asp:DropDownList>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblDepartment" runat="server" Text="Department"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                    <asp:DropDownList ID="ddlDepartment" runat="server" Width="156px" ></asp:DropDownList>
                </div>                        
            </div>
            <%--<div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCopySubsidiary" runat="server" Text="Copy Subsidiary"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlCopySubsidiary" runat="server" Width="156px" ></asp:DropDownList>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCopyDepartment" runat="server" Text="Copy Department"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                    <asp:DropDownList ID="ddlCopyDepartment" runat="server" Width="156px" ></asp:DropDownList>
                </div>                        
            </div>--%>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblOrderNumber" runat="server" Text="Order Number(PREFIX)"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:TextBox ID="txtOrderNumber" runat="server" Width="100px" MaxLength="3"></asp:TextBox>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblIsVatCalculate" runat="server" Text="Is VAT calculated on Own Risk Amount?"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                    <asp:CheckBox ID="chkIsVatCalculate" runat="server" />
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblOrderSeries" runat="server" Text="Order Series"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:TextBox ID="txtOrderSeries" runat="server"  Width="100px"  MaxLength="6"></asp:TextBox>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblChargeBasedOn" runat="server" Text="Charge based on"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                   <asp:DropDownList ID="cmbChargeBasedOn" runat="server" Width="156px" ></asp:DropDownList>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblGarageMaterial" runat="server" Text="Garage Material Price"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:TextBox ID="txtGarageMaterialPrice" runat="server"  Width="100px"  MaxLength="7"></asp:TextBox>
                     <asp:Label ID="lblPerLabPrice" runat="server" Text="% of Labour Price"></asp:Label>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseDeliveryAddress" runat="server" Text="Use Delivery Address"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                   <asp:CheckBox ID="chkUseDeliveryAddress" runat="server" />
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseManualRwrk" runat="server" Text="Ready For Work"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkUseManualRwrk" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseVehicle" runat="server" Text="Use Vehicle On SparePart"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                   <asp:CheckBox ID="chkUseVehicle" runat="server" />
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUsePCJob" runat="server" Text="Use Price Code on Job"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkUsePCJob" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblDefStat" runat="server" Text="Set Default Status"></asp:Label>
                </div>
                <div class="field" style="width:10px">
                  <asp:CheckBox ID="chkDefStat" runat="server"/>
                </div> 
                <div class="field" style="width:300px">
                  <asp:DropDownList ID="ddlStatus" runat="server" Width="150px" ></asp:DropDownList>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCnfrnDialog" runat="server" Text="Use Confirm Dialogue"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkCnfrmDialog" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblSaveJob" runat="server" Text="Save Job on Grid"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                  <asp:CheckBox ID="chkSaveJob" runat="server"/>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCurWRSeries" runat="server" Text="Current Order Number(PREFIX)"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:Label ID="RTlblOrderNumber" runat="server" CssClass="lbl"></asp:Label>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCurOrdSeries" runat="server" Text="Current Order Series"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                  <asp:Label ID="RTlblOrderSeries" runat="server" CssClass="lbl"></asp:Label>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCurrGMPrice" runat="server" Text="Current Garage Material Price"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:Label ID="RTlblGarageMaterial" runat="server" CssClass="lbl"></asp:Label>
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCurSer" runat="server" Text="Current Series"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                  <asp:Label ID="RTlblCurSeries" runat="server" CssClass="lbl"></asp:Label>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseDefCust" runat="server" Text="Use Default Customer"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkUseDefCust" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblCustID" runat="server" Text="CustomerID"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                    <asp:TextBox ID="txtCustomer" runat="server" Width="140px" ></asp:TextBox>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseVAACCCode" runat="server" Text="Use VA ACC Code"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkVAACCCode" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblVAcode" runat="server" Text="VA Acc Code"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                    <asp:TextBox ID="txtVACode" runat="server" Width="140px" MaxLength="10"></asp:TextBox>
                </div>                        
            </div>
            <div class="four fields">
                <div class="field" style="width:180px">
                    <asp:Label ID="lblUseAllSpareSearch" runat="server" Text="Use All Spare Search"></asp:Label>
                </div>
                <div class="field" style="width:250px">
                    <asp:CheckBox ID="chkAllSpareSearch" runat="server" />
                </div>      
                <div class="field" style="width:180px">
                    <asp:Label ID="lblDispRINVPINV" runat="server" Text="Display RINV and PINV"></asp:Label>
                </div>
                <div class="field" style="width:300px">
                     <asp:CheckBox ID="chkDispRINVPINV" runat="server" />
                </div>                        
            </div>
            <div style="text-align:center">
                <input id="btnSaveWOC" class="ui button" runat="server"  value="Save" type="button" onclick="saveWorkOrder()" />
            </div>
       </div>
       <%--<div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a1" runat="server" >Product Group Mapping</a>
       </div>
       <div> 
            <div style="text-align:left;padding-left:23em">
                <input id="btnAddProdGrpT" runat="server" type="button" value="Add" class="ui button" onclick="addProdGrp()" />
                <input id="btnDelProdGrpT" runat="server" type="button" value="Delete" class="ui button" onclick="delProdGrp()"/>
            </div>  
            <div >
                <table id="dgdProdGrp" title="ProdGrp" ></table>
                <div id="pagerProdGrp"></div>
            </div>         
            <div style="text-align:left;padding-left:23em">
                <input id="btnAddProdGrpB" runat="server" type="button" value="Add" class="ui button" onclick="addProdGrp()"/>
                <input id="btnDelProdGrpB" runat="server" type="button" value="Delete" class="ui button" onclick="delProdGrp()"/>
            </div>
            <div id="divProdGrp" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a3" runat="server" >ProdGrp</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:200px">
                           <asp:Label ID="lblProdGrp" runat="server" Text="Product Group"></asp:Label>
                           <asp:DropDownList ID="ddlProdGrp" runat="server" Width="180px" ></asp:DropDownList>
                        </div>     
                        <div class="field" style="width:200px">
                            <asp:Label ID="lbldisccode" runat="server" Text="Discount Code"></asp:Label>
                            <asp:DropDownList ID="ddlDiscCode" runat="server" Width="180px" ></asp:DropDownList>
                        </div>   
                        <div class="field" style="width:200px">
                            <asp:Label ID="lbldiscodevatcoe" runat="server" Text="VAT Code"></asp:Label>
                            <asp:DropDownList ID="ddlVATCode" runat="server" Width="180px" ></asp:DropDownList>
                        </div>     
                        <div class="field" style="width:200px">
                            <asp:Label ID="lbldiscodedes" runat="server" Text="Description"></asp:Label>
                            <asp:TextBox ID="txtDiscCodeDesc"  padding="0em" runat="server" MaxLength="10"></asp:TextBox>
                        </div>                               
                    </div>
                </div>             
               
                <div style="text-align:center">
                    <input id="btnSaveProdGrp" class="ui button" runat="server"  value="Save" type="button" onclick="saveProdGrp()"/>
                    <input id="btnResetProdGrp" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetProdGrp()" />
                </div>               
            </div>
       </div>--%>
       <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a1" runat="server" >Payment Type</a>
       </div>
       <div> 
            <div style="text-align:left;padding-left:13em">
                <input id="btnAddPayTypeT" runat="server" type="button" value="Add" class="ui button" onclick="addPayType()" />
                <input id="btnDelPayTypeT" runat="server" type="button" value="Delete" class="ui button" onclick="delPayType()"/>
            </div>  
            <div >
                <table id="dgdPayType" title="PaymentType" ></table>
                <div id="pagerPayType"></div>
            </div>         
            <div style="text-align:left;padding-left:13em">
                <input id="btnAddPayTypeB" runat="server" type="button" value="Add" class="ui button" onclick="addPayType()"/>
                <input id="btnDelPayTypeB" runat="server" type="button" value="Delete" class="ui button" onclick="delPayType()"/>
            </div>
            <div id="divPayType" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a3" runat="server" >PayType</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:200px">
                           <asp:Label ID="lblPayType" runat="server" Text="Payment Type"></asp:Label>
                           <asp:TextBox ID="txtPayType"  padding="0em" runat="server" MaxLength="10"></asp:TextBox>
                        </div>     
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblPayTypeDesc" runat="server" Text="Payment Description"></asp:Label>
                            <asp:TextBox ID="txtPayTypeDesc"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                        </div>  
                                                     
                    </div>
                </div>             
               
                <div style="text-align:center">
                    <input id="btnSavePayType" class="ui button" runat="server"  value="Save" type="button" onclick="savePayType()"/>
                    <input id="btnResetPayType" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPayType()" />
                </div>               
            </div>
       </div>
       <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a4" runat="server" >VAT Code</a>
       </div>
       <div> 
            <div style="text-align:left;padding-left:33em">
                <input id="btnAddVATCodeT" runat="server" type="button" value="Add" class="ui button" onclick="addVATCode()" />
                <input id="btnDelVATCodeT" runat="server" type="button" value="Delete" class="ui button" onclick="delVATCode()"/>
            </div>  
            <div >
                <table id="dgdVATCode" title="VAT Code" ></table>
                <div id="pagerVATCode"></div>
            </div>         
            <div style="text-align:left;padding-left:33em">
                <input id="btnAddVATCodeB" runat="server" type="button" value="Add" class="ui button" onclick="addVATCode()"/>
                <input id="btnDelVATCodeB" runat="server" type="button" value="Delete" class="ui button" onclick="delVATCode()"/>
            </div>
            <div id="divVATCode" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a5" runat="server" >VATCode</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:220px">
                            <asp:Label ID="lblvatcodeprogrp" runat="server" Text="VAT Code on Product Group"></asp:Label>
                            <asp:DropDownList ID="ddlVATCodeProdGrp" runat="server" Width="180px" ></asp:DropDownList>
                        </div>     
                        <div class="field" style="width:220px">
                            <asp:Label ID="lblvatcustgrp" runat="server" Text="VAT Code on Customer Group"></asp:Label>
                            <asp:DropDownList ID="ddlVATCodeCustGrp" runat="server" Width="180px" ></asp:DropDownList>
                        </div>
                        <div class="field" style="width:220px">
			                <asp:Label ID="lblvatcodevech" runat="server" Text="VAT Code on Vehicle"></asp:Label>
			                <asp:DropDownList ID="ddlVATCodeVeh" runat="server" Width="180px" ></asp:DropDownList>
                        </div>
                        <div class="field" style="width:220px">
			                <asp:Label ID="lblvatordline" runat="server" Text="VAT Code on Order Line"></asp:Label>
			                <asp:DropDownList ID="ddlVATCodeOrdLine" runat="server" Width="180px" ></asp:DropDownList>
                        </div>
                        <div class="field" style="width:220px">
			                <asp:Label ID="lblAccCode" runat="server" Text="VAT Account Code"></asp:Label>
			                <asp:TextBox ID="txtAccountCode"  padding="0em" runat="server"></asp:TextBox>
                        </div>                             
                    </div>
                </div>             
               
                <div style="text-align:center">
                    <input id="btnSaveVATCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveVATCode()"/>
                    <input id="btnResetVATCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetVATCode()" />
                </div>               
            </div>
       </div> 

    </div>


</asp:Content>