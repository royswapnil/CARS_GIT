<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfCustomer.aspx.vb" Inherits="CARS.frmCfCustomer" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
<script type="text/javascript">
    function ValidateCustID() {
        window.scrollTo(0, 0);
        if ((document.getElementById('<%=txtStartNo.ClientID%>').value != "") || (document.getElementById('<%=txtEndNo.ClientID%>').value != "")) {

            if (!(gfi_ValidateNumber($('#<%=txtStartNo.ClientID%>'), '0198')))
                return false;
            if (!(gfi_ValidateNumber($('#<%=txtEndNo.ClientID%>'), '0199')))
                return false;
            else if (parseInt($('#<%=txtStartNo.ClientID%>').val()) > parseInt($('#<%=txtEndNo.ClientID%>').val())) {
                var msg = GetMultiMessage('0225', '', '');
                alert(msg);
                $('#<%=txtEndNo.ClientID%>').focus();
                return false;
            }
        }
        if ((document.getElementById('<%=txtStartNo.ClientID%>').value == "") && (document.getElementById('<%=txtEndNo.ClientID%>').value == "")) {
            var msg = GetMultiMessage('MSG070', '', '');
            alert(msg);
            $('#<%=txtStartNo.ClientID%>').focus();
            return false;
        }
        return true;
    }

    function ClientValidateRegion() {
        if (!(gfi_CheckEmpty($('#<%=txtRegion.ClientID%>'), '0200')))
            return false;

        if (!(gfb_ValidateAlphabets($('#<%=txtRegion.ClientID%>'), '0200')))
            return false;
        if (!(ValidateNumbers($('#<%=txtRegion.ClientID%>')[0])))
            return false;
        window.scrollTo(0, 0);
        return true;
    }

    function ClientValidateWarning() {
        if (!(gfi_CheckEmpty($('#<%=txtWarning.ClientID%>'), '0201')))
            return false;
        if (!(gfb_ValidateAlphabets($('#<%=txtWarning.ClientID%>'), '0201')))
            return false;
        window.scrollTo(0, 0);
        return true;
    }

    function ClientValidatePayment() {
        if (!(gfi_CheckEmpty($('#<%=txtPayCode.ClientID%>'), '0202')))
            return false;
        if (!(gfi_CheckEmpty($('#<%=txtPayTerms.ClientID%>'), '0203')))
            return false;
        if (!(gfi_ValidateNumber($('#<%=txtPayTerms.ClientID%>'), '0203')))
            return false;
        if (!(gfb_ValidateAlphabets($('#<%=txtPayCode.ClientID%>'), '0202')))
            return false;
        if (!(gfb_ValidateAlphabets($('#<%=txtText.ClientID%>'), '0204')))
            return false;


        var specialchar = "@#$%&*()!^<>";
        paycodelength = document.getElementById('<%=txtPayCode.ClientID%>').value.length;
        FieldLength = document.getElementById('<%=txtText.ClientID%>').value.length;

        for (var i = 0; i < paycodelength; i++) {
            if (specialchar.indexOf(document.getElementById('<%=txtPayCode.ClientID%>').value.charAt(i)) != -1) {
                var msg = GetMultiMessage('0004', GetMultiMessage('0202', '', ''), '');
                alert(msg);
                $('#<%=txtPayCode.ClientID%>').focus();
                return false;
            }
        }

        for (var i = 0; i < FieldLength; i++) {
            if (specialchar.indexOf(document.getElementById('<%=txtText.ClientID%>').value.charAt(i)) != -1) {
                var msg = GetMultiMessage('0004', GetMultiMessage('0204', '', ''), '');
                alert(msg);
                $('#<%=txtText.ClientID%>').focus();
                return false;
            }
        }
        window.scrollTo(0, 0);
        return true;
    }

    function ClientValidateGroup() {
        if (!(gfi_CheckEmpty($('#<%=txtCustGrp.ClientID%>'), '0205')))
            return false;

        if (!(gfb_ValidateAlphabets($('#<%=txtCustGrp.ClientID%>'), '0205')))
            return false;

        if ($('#<%=drpCustPrCode.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0215', '', ''), '');
            alert(msg);
            return false;
        }

        if ($('#<%=drpPaymentType.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0150', '', ''), '');
            alert(msg);
            $('#<%=drpPaymentType.ClientID%>').focus();
            return false;
        }

        if ($('#<%=drpPayTerms.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0220', '', ''), '');
            alert(msg);
            $('#<%=drpPayTerms.ClientID%>').focus();
            return false;
        }
        if ($('#<%=drpVat.ClientID%>').selectedIndex <= "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0149', '', ''), '');
            alert(msg);

            return false;
        }
        if ($('#<%=drpDisc.ClientID%>').selectedIndex <= "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0148', '', ''), '');
            alert(msg);
            return false;
        }
        if (!(gfi_CheckEmpty($('#<%=txtcustacc.ClientID%>'), '0398')))
            return false;

        window.scrollTo(0, 0);
        return true;
    }


    function ClientValidateGM() {
        if ($('#<%=drpDepartment.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0049', '', ''), '');
            alert(msg);
            $('#<%=drpDepartment.ClientID%>').focus();
            return false;
        }

        if ($('#<%=drpCustomerGroup.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0205', '', ''), '');
            alert(msg);
            $('#<%=drpCustomerGroup.ClientID%>').focus();
            return false;
        }

        if ($('#<%=drpvatGM.ClientID%>')[0].selectedIndex == "0") {
            var msg = GetMultiMessage('0007', GetMultiMessage('0768', '', ''), '');
            alert(msg);
            $('#<%=drpvatGM.ClientID%>')[0].focus();
            return false;
        }

        if (!(gfi_CheckEmpty($('#<%=txtGMPricePercent.ClientID%>'), '0207')))
            return false;

        if (!(fn_ValidateDecimal($('#<%=txtGMPricePercent.ClientID%>')[0], '<%= Session("Decimal_Seperator") %>'))) {
            var msg = GetMultiMessage('0228', GetMultiMessage('0228', '', ''), '');
            alert(msg);
            $('#<%=txtGMPricePercent.ClientID%>').focus();
            return false;
        }

        if ((document.getElementById('<%=txtGMPricePercent.ClientID%>').value == '.') || (document.getElementById('<%=txtGMPricePercent.ClientID%>').value > 100)) {
            var msg = GetMultiMessage('0228', GetMultiMessage('0228', '', ''), '');
            alert(msg);
            return false;
        }

        if (!(gfi_CheckEmpty($('#<%=txtGMDescription.ClientID%>'), '0208')))
            return false;
        if (!(gfb_ValidateAlphabets($('#<%=txtGMDescription.ClientID%>'), '0208')))
            return false;

        if (!(gfi_CheckEmpty($('#<%=txtAccountCode.ClientID%>'), '0788')))
            return false;

        window.scrollTo(0, 0);
        return true;
    }

    $(document).ready(function () {
        $('#EditRegion').hide();
        $('#EditPayTerms').hide();
        $('#EditGrpGrid').hide();
        $('#EditWarning').hide();
        $('#EditGMPrice').hide();
        $('#EditCustRepPrice').hide();

       

        var mydata;
        var grid = $("#dgdRegion");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var Regiondata;

        grid.jqGrid({
            datatype: "local",
            data: Regiondata,
            colNames: ['Id_Settings', 'Region', ''],
            colModel: [
                     { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                     { name: 'Region', index: 'Region', width: 310, sorttype: "string" },
                     { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editRegion }

            ],
            multiselect: true,
            pager: jQuery('#pagerRegion'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });

        var PTdata;
        var payTgrid = $("#dgdPaymentTerms");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var paytermsdata;

        payTgrid.jqGrid({
            datatype: "local",
            data: paytermsdata,
            colNames: ['Id_Settings', 'PAY_CODE', 'PAY_TERMS', 'FREEMONTH', 'PAY_DESC', ''],
            colModel: [
                      { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                     { name: 'Pay_Type', index: 'Pay_Type', width: 60, sorttype: "string" },
                     { name: 'Id_Pay_Term', index: 'Id_Pay_Term', width: 150, sorttype: "string" },
                     { name: 'Flg_Freemonth', index: 'Flg_Freemonth', formatter: displayCheckbox },
                     { name: 'Pay_Description', index: 'Pay_Description', width: 150, sorttype: "string" },
                     { name: 'Pay_Type', index: 'Pay_Type', sortable: false, formatter: editPayTerms }

            ],
            multiselect: true,
            pager: jQuery('#pagerPaymentTerms'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });


        var Grdata;
        var Grpgrid = $("#dgdGroup");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var grpdata;

        Grpgrid.jqGrid({
            datatype: "local",
            data: grpdata,
            colNames: ['Id_Settings', 'CUST_GROUP', 'PRICE_CODE', 'Cust_AccCode', 'PAY_TYPE', 'PAY_TERM', 'VAT_CODE','DISC_CODE','DESCRIPTION','PAY_CURR',''],
            colModel: [
                      { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                     { name: 'Id_Cust_Group', index: 'Id_Cust_Group', width: 60, sorttype: "string" },
                     { name: 'Cust_Pc', index: 'Cust_Pc', width: 60, sorttype: "string" },
                     { name: 'Cust_AccCode', index: 'Cust_AccCode', width: 60, sorttype: "string" },
                     { name: 'Pay_Type', index: 'Pay_Type', width: 60, sorttype: "string" },
                     { name: 'Id_Pay_Term', index: 'Id_Pay_Term', width: 70, sorttype: "string" },
                      { name: 'Vat_Code', index: 'Vat_Code', width: 60, sorttype: "string" },
                      { name: 'Discount_Code', index: 'Discount_Code', width: 50, sorttype: "string" },
                       { name: 'Cust_GrpDesc', index: 'Cust_GrpDesc', width: 150, sorttype: "string" },
                       { name: 'Currency', index: 'Currency', width: 50, sorttype: "string" },
                     { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editGroup }

            ],
            multiselect: true,
            pager: jQuery('#pagerGroup'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });


        var warndata;
        var Wrngrid = $("#dgdWarning");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var Wrndata;

        Wrngrid.jqGrid({
            datatype: "local",
            data: Wrndata,
            colNames: ['Id_Settings', 'Description', ''],
            colModel: [
                      { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                     { name: 'Warn_Text', index: 'Warn_Text', width: 310, sorttype: "string" },
                     { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editWarn }

            ],
            multiselect: true,
            pager: jQuery('#pagerWarning'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });


        var GMPricedata;
        var GMgrid = $("#dgdGarageMaterialPrice");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var GMdata;

        GMgrid.jqGrid({
            datatype: "local",
            data: GMdata,
            colNames: ['Id_Settings', 'Department', 'IdDept', 'CustGroup', 'Id_Cust_Group_Seq', 'GM Price %', 'Description', 'VAT Code for GM', 'Account Code', ''],
            colModel: [
                      { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                     { name: 'DeptName', index: 'DeptName', width: 90, sorttype: "string" },
                     { name: 'IdDept', index: 'IdDept', hidden: true },
                     { name: 'Id_Cust_Group', index: 'Id_Cust_Group', width: 60, sorttype: "string" },
                      { name: 'Id_Cust_Group_Seq', index: 'Id_Cust_Group_Seq', hidden: true },
                     { name: 'Garg_Price_Per', index: 'Garg_Price_Per', width: 90, sorttype: "string" },
                     { name: 'Description', index: 'Description', width: 90, sorttype: "string" },
                     { name: 'Vat_Description', index: 'Vat_Description', width: 90, sorttype: "string" },
                     { name: 'GP_AccCode', index: 'GP_AccCode', width: 90, sorttype: "string" },
                     { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editGMPrice }

            ],
            multiselect: true,
            pager: jQuery('#pagerGarageMaterialPrice'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });


        var CRPdata;
        var RPgrid = $("#dgdCustRepPrice");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var RPdata;

        RPgrid.jqGrid({
            datatype: "local",
            data: RPdata,
            colNames: ['Id_Map_Seq', 'Repair Package', 'Id_Customer', 'CustomerName', 'HP/FP', 'Price', ''],
            colModel: [
                      { name: 'Id_Map_Seq', index: 'Id_Map_Seq', hidden: true },
                     { name: 'Id_Rp_Code', index: 'Id_Rp_Code', width: 90, sorttype: "string" },
                     { name: 'Id_Customer', index: 'Id_Customer', hidden: true },
                     { name: 'Cust_Name', index: 'Cust_Name', width: 160, sorttype: "string" },
                     { name: 'Flg_Price', index: 'Flg_Price', width: 90, sorttype: "string" },
                     { name: 'Price', index: 'Price', width: 90, sorttype: "string" },
                     { name: 'Id_Map_Seq', index: 'Id_Map_Seq', sortable: false, formatter: editCustRP }

            ],
            multiselect: true,
            pager: jQuery('#pagerCustRepPrice'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false
        });


        FetchCustConfig();
        //ADD
        $('#<%=btnRegionAdd1.ClientID%>').on('click', function () {
            $('#EditRegion').show();
            $('#<%=txtRegion.ClientID%>').focus();
            $('#<%=txtRegion.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });
        $('#<%=btnRegionAdd2.ClientID%>').on('click', function () {
            $('#EditRegion').show();
            $('#<%=txtRegion.ClientID%>').focus();
            $('#<%=txtRegion.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnCancelRegion.ClientID%>').on('click', function () {
            $('#EditRegion').hide();
            $('#<%=txtRegion.ClientID%>').val("");
           
        });



        $('#<%=btnPaymentAdd1.ClientID%>').on('click', function () {
            $('#EditPayTerms').show();
            $('#<%=txtPayCode.ClientID%>').focus();
            $('#<%=txtPayCode.ClientID%>').val("");
            $('#<%=txtPayTerms.ClientID%>').val("");
            $('#<%=txtText.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });
        $('#<%=btnPaymentAdd2.ClientID%>').on('click', function () {
            $('#EditPayTerms').show();
            $('#<%=txtPayCode.ClientID%>').focus();
            $('#<%=txtPayCode.ClientID%>').val("");
            $('#<%=txtPayTerms.ClientID%>').val("");
            $('#<%=txtText.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnCancelPayment.ClientID%>').on('click', function () {
            $('#EditPayTerms').hide();
            $('#<%=txtPayCode.ClientID%>').val("");
            $('#<%=txtPayTerms.ClientID%>').val("");
            $('#<%=txtText.ClientID%>').val("");
        });
        $('#<%=btnGroupAdd1.ClientID%>').on('click', function () {
            $('#EditGrpGrid').show();
            $('#<%=txtCustGrp.ClientID%>').focus();
            $('#<%=txtCustGrp.ClientID%>').val("");
            $('#<%=txtcustacc.ClientID%>').val("");
            $('#<%=txtDescription.ClientID%>').val("");
            $('#<%=drpcurrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustPrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpDisc.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPaymentType.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPayTerms.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpVat.ClientID%>')[0].selectedIndex = 0;
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });
        $('#<%=btnGroupAdd2.ClientID%>').on('click', function () {
            $('#EditGrpGrid').show();
            $('#<%=txtCustGrp.ClientID%>').focus();
            $('#<%=txtCustGrp.ClientID%>').val("");
            $('#<%=txtcustacc.ClientID%>').val("");
            $('#<%=txtDescription.ClientID%>').val("");
            $('#<%=drpcurrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustPrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpDisc.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPaymentType.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPayTerms.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpVat.ClientID%>')[0].selectedIndex = 0;
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnCancelGrp.ClientID%>').on('click', function () {
            $('#EditGrpGrid').hide();
            $('#<%=txtCustGrp.ClientID%>').val("");
            $('#<%=txtcustacc.ClientID%>').val("");
            $('#<%=txtDescription.ClientID%>').val("");
            $('#<%=drpcurrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustPrCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpDisc.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPaymentType.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpPayTerms.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpVat.ClientID%>')[0].selectedIndex = 0;
        });



        $('#<%=btnWarningAdd1.ClientID%>').on('click', function () {
            $('#EditWarning').show();
            $('#<%=txtWarning.ClientID%>').focus();
            $('#<%=txtWarning.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });
        $('#<%=btnWarningAdd2.ClientID%>').on('click', function () {
            $('#EditWarning').show();
            $('#<%=txtWarning.ClientID%>').focus();
            $('#<%=txtWarning.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });


        $('#<%=btnCancelWarning.ClientID%>').on('click', function () {
            $('#EditWarning').hide();
            $('#<%=txtWarning.ClientID%>').val("");
           
        });

        $('#<%=btnPriceAdd1.ClientID%>').on('click', function () {
            $('#EditGMPrice').show();
            $('#<%=drpDepartment.ClientID%>').focus();
            $('#<%=drpDepartment.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustomerGroup.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpvatGM.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtGMPricePercent.ClientID%>').val("");
            $('#<%=txtGMDescription.ClientID%>').val("");
            $('#<%=txtAccountCode.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });
        $('#<%=btnPriceAdd2.ClientID%>').on('click', function () {
            $('#EditGMPrice').show();
            $('#<%=drpDepartment.ClientID%>').focus();
            $('#<%=drpDepartment.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustomerGroup.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpvatGM.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtGMPricePercent.ClientID%>').val("");
            $('#<%=txtGMDescription.ClientID%>').val("");
            $('#<%=txtAccountCode.ClientID%>').val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnPriceCancel.ClientID%>').on('click', function () {
            $('#EditGMPrice').hide();
            $('#<%=drpDepartment.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpCustomerGroup.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpvatGM.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtGMPricePercent.ClientID%>').val("");
            $('#<%=txtGMDescription.ClientID%>').val("");
            $('#<%=txtAccountCode.ClientID%>').val("");

        });

        $('#<%=btnCRAdd.ClientID%>').on('click', function () {
            $('#EditCustRepPrice').show();
            $('#<%=drpRepPackage.ClientID%>').focus();
            $('#<%=drpRepPackage.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtCustId.ClientID%>').val("");
            $('#<%=txtHPFP.ClientID%>').val("");
            $('#<%=rbFP.ClientID%>').attr('checked', false);
            $('#<%=rbHP.ClientID%>').attr('checked', true);
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnCRAdd2.ClientID%>').on('click', function () {
            $('#EditCustRepPrice').show();
            $('#<%=drpRepPackage.ClientID%>').focus();
            $('#<%=drpRepPackage.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtCustId.ClientID%>').val("");
            $('#<%=txtHPFP.ClientID%>').val("");
            $('#<%=rbFP.ClientID%>').attr('checked', false);
            $('#<%=rbHP.ClientID%>').attr('checked', true);
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
        });

        $('#<%=btnCRCancel.ClientID%>').on('click', function () {
            $('#EditCustRepPrice').hide();
            $('#<%=drpRepPackage.ClientID%>').focus();
            $('#<%=drpRepPackage.ClientID%>')[0].selectedIndex = 0;
            $('#<%=txtCustId.ClientID%>').val("");
            $('#<%=txtHPFP.ClientID%>').val("");

        });

        //SAVE
        $('#<%=btnSaveRegion.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updRegionConfig();

            }
            else {
                saveRegionConfig();
            }
        });

        $('#<%=btnSavePayment.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updPTConfig();

            }
            else {
                savePTConfig();
            }
        });
        $('#<%=btnSaveGrp.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updCustGrpConfig();

            }
            else {
                saveCustGrpConfig();
            }
        });
        $('#<%=btnSaveWarning.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updWarnConfig();

            }
            else {
                saveWarnConfig();
            }
        });
        $('#<%=btnPriceSave.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updGMPrice();

            }
            else {
                saveGMPrice();
            }
        });
        $('#<%=btnCRSave.ClientID%>').on('click', function () {
            if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                updCustRPkg();

            }
            else {
                saveCustRPkg();
            }
        });
        $('#<%=btnCustSave.ClientID%>').on('click', function () {
            console.log("BUTTON SAVED");
            SaveID();
            
        });

        $('#<%=rbFP.ClientID%>').click(function () {
            $('#<%=rbFP.ClientID%>').attr('checked', true);
            $('#<%=rbHP.ClientID%>').attr('checked', false);
        });
        $('#<%=rbHP.ClientID%>').click(function () {
            $('#<%=rbFP.ClientID%>').attr('checked', false);
            $('#<%=rbHP.ClientID%>').attr('checked', true);
        });
        
    });//end of ready

    function displayCheckbox(cellvalue, options, rowObject) {
        var valchk = rowObject.Flg_Freemonth;
        if (valchk == true) {
            var chk = '<input type="checkbox" value="' + cellvalue + '" disabled="disabled" checked="checked">';
        }
        else {
            var chk = '<input type="checkbox" value="' + cellvalue + '" disabled="disabled">';
        }
        return chk;
    }

    function FetchCustConfig() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/Fetch_Config",
            data: {},
            dataType: "json",
            async: false,//Very important
            success: function (Result) {
                BindRegionGrid(Result.d[0]);
                BindPayTerms(Result.d[1]);
                BindGroup(Result.d[2]);
                LoadPriceCode(Result.d[3]);
                LoadPayTerms(Result.d[4]);
                LoadDiscCode(Result.d[5]);
                LoadVatCode(Result.d[6]);
                LoadPayType(Result.d[7]);
                LoadCurrCode();
                BindWarnGrid(Result.d[8]);
                BindGMPriceGrid(Result.d[9]);
                LoadDepart(Result.d[10]);
                LoadCustGroup(Result.d[11]);
                LoadVatGM(Result.d[12]);
                BindCustRPkg(Result.d[13]);
                LoadRPkgDrpDwn();
                Bindlbl(Result.d[14]);
                BindCustlbl(Result.d[15]);
               
            }
        });
    }
    function Bindlbl(Result)
    {
        if (Result.length !=0)
        {
            $('#<%=RTlblStartingSeries.ClientID%>').text(Result[0].Cust_Start);
            $('#<%=RTlblEndingSeries.ClientID%>').text(Result[0].Cust_End);
        }
    }
    function BindCustlbl(Result) {
        if (Result.length != 0) {
            $('#<%=RTlblCustomerID.ClientID%>').text(Result[0].Id_Customer);
        }
    }
    function BindRegionGrid(result) {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdRegion").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            mydata = result;
            jQuery("#dgdRegion").jqGrid('addRowData', i + 1, mydata[i]);
        }
        jQuery("#dgdRegion").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdRegion").jqGrid("hideCol", "subgrid");
    }
    function BindPayTerms(result) {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdPaymentTerms").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            PTdata = result;
            jQuery("#dgdPaymentTerms").jqGrid('addRowData', i + 1, PTdata[i]);
        }
        jQuery("#dgdPaymentTerms").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdPaymentTerms").jqGrid("hideCol", "subgrid");
    }
    function BindGroup(result) {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdGroup").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            Grdata = result;
            jQuery("#dgdGroup").jqGrid('addRowData', i + 1, Grdata[i]);
        }
        jQuery("#dgdGroup").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdGroup").jqGrid("hideCol", "subgrid");
    }
    function BindWarnGrid(result) {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdWarning").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            warndata = result;
            jQuery("#dgdWarning").jqGrid('addRowData', i + 1, warndata[i]);
        }
        jQuery("#dgdWarning").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdWarning").jqGrid("hideCol", "subgrid");
    }
    function BindGMPriceGrid(result) {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdGarageMaterialPrice").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            GMPricedata = result;
            jQuery("#dgdGarageMaterialPrice").jqGrid('addRowData', i + 1, GMPricedata[i]);
        }
        jQuery("#dgdGarageMaterialPrice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdGarageMaterialPrice").jqGrid("hideCol", "subgrid");
    }
    function BindCustRPkg(result)
    {
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        jQuery("#dgdCustRepPrice").jqGrid('clearGridData');
        for (i = 0; i < result.length; i++) {
            CRPdata = result;
            jQuery("#dgdCustRepPrice").jqGrid('addRowData', i + 1, CRPdata[i]);
        }
        jQuery("#dgdCustRepPrice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdCustRepPrice").jqGrid("hideCol", "subgrid");
    }
    function editRegion(cellvalue, options, rowObject) {
        var idRegion = rowObject.Id_Settings;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=RegionDet(" + "'" + idRegion + "'" + "); />";
        return edit;
    }
    function editPayTerms(cellvalue, options, rowObject) {
        var payCode = rowObject.Pay_Type;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=PayDet(" + "'" + payCode + "'" + "); />";
        return edit;
    }
    function editGroup(cellvalue, options, rowObject) {
        var idSett = rowObject.Id_Settings;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=CustGrpDet(" + "'" + idSett + "'" + "); />";
        return edit;
    }
    function editWarn(cellvalue, options, rowObject) {
        var idSett = rowObject.Id_Settings;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=WarningDet(" + "'" + idSett + "'" + "); />";
        return edit;
    }
    function editGMPrice(cellvalue, options, rowObject) {
        var idSett = rowObject.Id_Settings;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=GMPriceDet(" + "'" + idSett + "'" + "); />";
        return edit;
    }
    function editCustRP(cellvalue, options, rowObject)
    {
        var idMapseq = rowObject.Id_Map_Seq;
        var strOptions = cellvalue;
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        $('#<%=hdnMode.ClientID%>').val("Edit");
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=CustRPDet(" + "'" + idMapseq + "'" + "); />";
        return edit;
    }
    function RegionDet(idRegion) {
        $('#EditRegion').show();
        $('#<%=txtRegion.ClientID%>').focus();
        var rowData = $('#dgdRegion').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Id_Settings == idRegion) {
                $("#<%=txtRegion.ClientID%>").val(rowData[i].Region);
                $('#<%=hdnRegion.ClientID%>').val(rowData[i].Id_Settings);
              }
        }
    }
    function PayDet(payCode) {
        $('#EditPayTerms').show();
        $('#<%=txtPayCode.ClientID%>').focus();
        var rowData = $('#dgdPaymentTerms').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Pay_Type == payCode) {
                $("#<%=txtPayCode.ClientID%>").val(rowData[i].Pay_Type);
                $("#<%=txtPayTerms.ClientID%>").val(rowData[i].Id_Pay_Term);
                $("#<%=txtText.ClientID%>").val(rowData[i].Pay_Description);
                $('#<%=hdnPayTerms.ClientID%>').val(rowData[i].Id_Settings);
                if ((rowData[i].Flg_Freemonth) == false) {
                    $("#<%=chkFreeMonth.ClientID%>").attr('checked', false);
                }
                else {
                    $("#<%=chkFreeMonth.ClientID%>").attr('checked', true);
                    
                }
            }
        }
    }
    function CustGrpDet(IdSetting) {
        $('#EditGrpGrid').show();
        $('#<%=txtCustGrp.ClientID%>').focus();
        var rowData = $('#dgdGroup').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Id_Settings == IdSetting) {
                $("#<%=txtCustGrp.ClientID%>").val(rowData[i].Id_Cust_Group);
                $("#<%=txtcustacc.ClientID%>").val(rowData[i].Cust_AccCode);
                $("#<%=txtDescription.ClientID%>").val(rowData[i].Cust_GrpDesc);
                if (rowData[i].Vat_Code != "") {
                    $('#<%=drpVat.ClientID%> option:contains("' + rowData[i].Vat_Code + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpVat.ClientID%>')[0].selectedIndex = 0;
                }

                if (rowData[i].Cust_Pc != "") {
                    $('#<%=drpCustPrCode.ClientID%> option:contains("' + rowData[i].Cust_Pc + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpCustPrCode.ClientID%>')[0].selectedIndex = 0;
                }


                if (rowData[i].Discount_Code != "") {
                    $('#<%=drpDisc.ClientID%> option:contains("' + rowData[i].Discount_Code + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpDisc.ClientID%>')[0].selectedIndex = 0;
                }
                
                if (rowData[i].Pay_Type != "") {
                    $('#<%=drpPaymentType.ClientID%> option:contains("' + rowData[i].Pay_Type + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpPaymentType.ClientID%>')[0].selectedIndex = 0;
                }

                if (rowData[i].Id_Pay_Term != "") {
                    $('#<%=drpPayTerms.ClientID%> option:contains("' + rowData[i].Id_Pay_Term + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpPayTerms.ClientID%>')[0].selectedIndex = 0;
                }

                if (rowData[i].Currency != "") {
                    $("#<%=drpcurrCode.ClientID%>").val(rowData[i].Currency);
                }
                else {
                    $('#<%=drpcurrCode.ClientID%>')[0].selectedIndex = 0;
                }
                $('#<%=hdnCustGrp.ClientID%>').val(rowData[i].Id_Settings);
                if ((rowData[i].UseIntCustomer) == "0") {
                    $("#<%=chkIntCust.ClientID%>").attr('checked', false);
                }
                else {
                    $("#<%=chkIntCust.ClientID%>").attr('checked', true);
                }
            }
        }
    }
    function WarningDet(idSett) {
        $('#EditWarning').show();
        $('#<%=txtWarning.ClientID%>').focus();
        var rowData = $('#dgdWarning').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Id_Settings == idSett) {
                $("#<%=txtWarning.ClientID%>").val(rowData[i].Warn_Text);
                $('#<%=hdnWarn.ClientID%>').val(rowData[i].Id_Settings);
            }
        }
    }
    function GMPriceDet(idSett) {
        $('#EditGMPrice').show();
        $('#<%=drpDepartment.ClientID%>').focus();
        var rowData = $('#dgdGarageMaterialPrice').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Id_Settings == idSett) {
                $('#<%=hdnGMPrice.ClientID%>').val(rowData[i].Id_Settings);
                if (rowData[i].Vat_Description != "") {
                    $('#<%=drpvatGM.ClientID%> option:contains("' + rowData[i].Vat_Description + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpvatGM.ClientID%>')[0].selectedIndex = 0;
                }

                if (rowData[i].Id_Cust_Group != "") {
                    $('#<%=drpCustomerGroup.ClientID%> option:contains("' + rowData[i].Id_Cust_Group + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpCustomerGroup.ClientID%>')[0].selectedIndex = 0;
                }


                if (rowData[i].DeptName != "") {
                    $('#<%=drpDepartment.ClientID%> option:contains("' + rowData[i].DeptName + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpDepartment.ClientID%>')[0].selectedIndex = 0;
                }
                $('#<%=txtGMPricePercent.ClientID%>').val(rowData[i].Garg_Price_Per);
                $('#<%=txtGMDescription.ClientID%>').val(rowData[i].Description);
                $('#<%=txtAccountCode.ClientID%>').val(rowData[i].GP_AccCode);
            }
        }
    }

    function CustRPDet(idSett)
    {
        $('#EditCustRepPrice').show();
        $('#<%=drpRepPackage.ClientID%>').focus();
        var rowData = $('#dgdCustRepPrice').jqGrid('getGridParam', 'data');
        for (var i = 0; i < rowData.length; i++) {
            if (rowData[i].Id_Map_Seq == idSett) {
                if (rowData[i].Id_Rp_Code != "") {
                    $('#<%=drpRepPackage.ClientID%> option:contains("' + rowData[i].Id_Rp_Code + '")').attr('selected', 'selected');
                }
                else {
                    $('#<%=drpRepPackage.ClientID%>')[0].selectedIndex = 0;
                }
                $('#<%=txtCustId.ClientID%>').val(rowData[i].Id_Customer);
                $('#<%=txtHPFP.ClientID%>').val(rowData[i].Price);
                if ((rowData[i].Flg_Price) == "FP") {

                    $('#<%=rbFP.ClientID%>').attr('checked', true);
                    $('#<%=rbHP.ClientID%>').attr('checked', false);
                }
                else {
                    $('#<%=rbFP.ClientID%>').attr('checked', false);
                    $('#<%=rbHP.ClientID%>').attr('checked', true);
                }
                $('#<%=hdnMapSeq.ClientID%>').val(rowData[i].Id_Map_Seq);
               
            }

        }
    }

    function SaveID()
    {
        
        var startNo = $('#<%=txtStartNo.ClientID%>').val();
        var endNo = $('#<%=txtEndNo.ClientID%>').val();
        var bool = ValidateCustID()
        if (bool == true)
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfCustomer.aspx/SaveID",
                    data: "{startNo:'" + startNo + "',endNo:'" + endNo + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        data = data.d[0];
                        if (data.ErrMsg != "") {
                            $('#<%=RTlblError.ClientID%>').text(data.ErrMsg);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(data.SuccMsg);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        FetchCustConfig();
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
        }
    }
    function saveRegionConfig()
    {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        
            var strXMLSettingsVehMakeUpdate = "<ROOT></ROOT>";
            var strXMLSettingsModelupdate = "<ROOT></ROOT>";
            var idSett = "";
            var region = $("#<%=txtRegion.ClientID%>").val();
        var bool = ClientValidateRegion()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SaveRegionConfig",
                data: "{IdSett:'" + idSett + "',desc:'" + region + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditRegion').hide();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }
        
    }
    function savePTConfig() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
   
        var idSett = "";
        var payCode = $("#<%=txtPayCode.ClientID%>").val();
        var payTerms = $("#<%=txtPayTerms.ClientID%>").val();
        var payDesc = $("#<%=txtText.ClientID%>").val();
        var flg_freemonth = $('#<%=chkFreeMonth.ClientID%>').is(':checked');
        var bool = ClientValidatePayment()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SavePayConfig",
                data: "{IdSett:'" + idSett + "',payCode:'" + payCode + "', payTerms:'" + payTerms + "', payDesc:'" + payDesc + "', freemonth:'" + flg_freemonth + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditPayTerms').hide();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });

        }
    }
    function saveCustGrpConfig() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        var idSett = "";
        var idCustGrp = $("#<%=txtCustGrp.ClientID%>").val();
        var idPrCode = $("#<%=drpCustPrCode.ClientID%>").val();
        var payTypeDesc = $('#<%=drpPaymentType.ClientID%> :selected')[0].innerText
        var payTerms = $("#<%=drpPayTerms.ClientID%>").val();
        var vatCode = $("#<%=drpVat.ClientID%>").val();
        var discCode = $("#<%=drpDisc.ClientID%>").val();
        var custAccCode = $("#<%=txtcustacc.ClientID%>").val();
        var desc = $("#<%=txtDescription.ClientID%>").val();
        var Curr = $("#<%=drpcurrCode.ClientID%>").val();
        var useIntCust = $('#<%=chkIntCust.ClientID%>').is(':checked');
        var bool = ClientValidateGroup()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SaveCustGrpConfig",
                data: "{IdSett:'" + idSett + "',idCustGrp:'" + idCustGrp + "', idPrCode:'" + idPrCode + "', payTypeDesc:'" + payTypeDesc + "', payTerms:'" + payTerms + "' , vatCode:'" + vatCode + "', discCode:'" + discCode + "', custAccCode:'" + custAccCode + "', desc:'" + desc + "', useIntCust:'" + useIntCust + "' , curr:'" + Curr + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditGrpGrid').hide();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }

    }

    function saveWarnConfig()
    {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
          
        var idSett = "";
        var warnText = $("#<%=txtWarning.ClientID%>").val();
        var bool = ClientValidateWarning()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SaveWarningConfig",
                data: "{IdSett:'" + idSett + "',warnText:'" + warnText + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditWarning').hide();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }
        
    }

    function saveGMPrice() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        var idSett = "";
        var idDept = $("#<%=drpDepartment.ClientID%>").val();
        var idCustGrpSeq = $("#<%=drpCustomerGroup.ClientID%>").val();
        var GMPercent = $("#<%=txtGMPricePercent.ClientID%>").val();
        var GMDesc = $("#<%=txtGMDescription.ClientID%>").val();
        var vatCode = $("#<%=drpvatGM.ClientID%>").val();
        var accCode = $("#<%=txtAccountCode.ClientID%>").val();
       
        var bool = ClientValidateGM()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SaveGMPrice",
                data: "{IdSett:'" + idSett + "',idDept:'" + idDept + "', idCustGrpSeq:'" + idCustGrpSeq + "', GMPercent:'" + GMPercent + "', GMDesc:'" + GMDesc + "' , vatCode:'" + vatCode + "', accCode:'" + accCode + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditGMPrice').hide();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });

        }
    }

    function saveCustRPkg() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        var idSett = "";
        var idRP = $("#<%=drpRepPackage.ClientID%>").val();
        var idCust = $("#<%=txtCustId.ClientID%>").val();
        var HPFP = $("#<%=txtHPFP.ClientID%>").val();
        var flgPr = $("#<%=rbFP.ClientID%>")[0].defaultChecked;
        if (flgPr == "false")
        {
            flgPr = "0";
        }
        else
        {
            flgPr = "1";
        }


        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveCustRP",
            data: "{IdSett:'" + idSett + "',idRP:'" + idRP + "', idCust:'" + idCust + "', FlgPrice:'" + flgPr + "', Price:'" + HPFP + "' , mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d;
                if (data == "INS") {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#EditCustRepPrice').hide();
                }
                else if (data == "AEXISTS")
                {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
                FetchCustConfig();
            },
            error: function (result) {
                alert("Error");
            }
        });


    }

    function updCustRPkg() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        var idSett = $("#<%=hdnMapSeq.ClientID%>").val();
        var idRP = $("#<%=drpRepPackage.ClientID%>").val();
        var idCust = $("#<%=txtCustId.ClientID%>").val();
        var HPFP = $("#<%=txtHPFP.ClientID%>").val();
        var flgPr = $("#<%=rbFP.ClientID%>")[0].defaultChecked;
        if (flgPr == "false") {
            flgPr = "0";
        }
        else {
            flgPr = "1";
        }

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveCustRP",
            data: "{IdSett:'" + idSett + "',idRP:'" + idRP + "', idCust:'" + idCust + "', FlgPrice:'" + flgPr + "', Price:'" + HPFP + "' , mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d;
                if (data == "UPD") {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#EditCustRepPrice').hide();
                }
                else  {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
                FetchCustConfig();
            },
            error: function (result) {
                alert("Error");
            }
        });


    }

    function updGMPrice() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        var idSett = $("#<%=hdnGMPrice.ClientID%>").val();
        var idDept = $("#<%=drpDepartment.ClientID%>").val();
        var idCustGrpSeq = $("#<%=drpCustomerGroup.ClientID%>").val();
        var GMPercent = $("#<%=txtGMPricePercent.ClientID%>").val();
        var GMDesc = $("#<%=txtGMDescription.ClientID%>").val();
        var vatCode = $("#<%=drpvatGM.ClientID%>").val();
        var accCode = $("#<%=txtAccountCode.ClientID%>").val();


        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveGMPrice",
            data: "{IdSett:'" + idSett + "',idDept:'" + idDept + "', idCustGrpSeq:'" + idCustGrpSeq + "', GMPercent:'" + GMPercent + "', GMDesc:'" + GMDesc + "' , vatCode:'" + vatCode + "', accCode:'" + accCode + "', mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d[0];
                if (data.RetVal_Saved != "") {
                    $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#EditGMPrice').hide();
                }
                else {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
                FetchCustConfig();
            },
            error: function (result) {
                alert("Error");
            }
        });


    }

    function updPTConfig() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var payCode = $("#<%=txtPayCode.ClientID%>").val();
        var payTerms = $("#<%=txtPayTerms.ClientID%>").val();
        var payDesc = $("#<%=txtText.ClientID%>").val();
        var idSett = $('#<%=hdnPayTerms.ClientID%>').val();
        var flg_freemonth = $('#<%=chkFreeMonth.ClientID%>').is(':checked');
        var bool = ClientValidatePayment()
        if (bool == true) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/SavePayConfig",
                data: "{IdSett:'" + idSett + "',payCode:'" + payCode + "', payTerms:'" + payTerms + "', payDesc:'" + payDesc + "', freemonth:'" + flg_freemonth + "', mode:'" + mode + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    data = data.d[0];
                    if (data.RetVal_Saved != "") {
                        $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditPayTerms').hide();

                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                    FetchCustConfig();
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }
    }
    function updRegionConfig() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var region = $("#<%=txtRegion.ClientID%>").val();
        var idSett = $('#<%=hdnRegion.ClientID%>').val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveRegionConfig",
            data: "{IdSett:'" + idSett + "',desc:'" + region + "', mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d[0];
                $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                $('#<%=RTlblError.ClientID%>').removeClass();
                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                $('#EditRegion').hide();
                FetchCustConfig();

            },
            error: function (result) {
                alert("Error");
            }
        });
    }

    function updCustGrpConfig() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var idSett = $('#<%=hdnCustGrp.ClientID%>').val();
        var idCustGrp = $("#<%=txtCustGrp.ClientID%>").val();
        var idPrCode = $("#<%=drpCustPrCode.ClientID%>").val();
        var payTypeDesc = $('#<%=drpPaymentType.ClientID%> :selected')[0].innerText
        var payTerms = $("#<%=drpPayTerms.ClientID%>").val();
        var vatCode = $("#<%=drpVat.ClientID%>").val();
        var discCode = $("#<%=drpDisc.ClientID%>").val();
        var custAccCode = $("#<%=txtcustacc.ClientID%>").val();
        var desc = $("#<%=txtDescription.ClientID%>").val();
        var Curr = $("#<%=drpcurrCode.ClientID%>").val();
        var useIntCust = $('#<%=chkIntCust.ClientID%>').is(':checked');

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveCustGrpConfig",
            data: "{IdSett:'" + idSett + "',idCustGrp:'" + idCustGrp + "', idPrCode:'" + idPrCode + "', payTypeDesc:'" + payTypeDesc + "', payTerms:'" + payTerms + "' , vatCode:'" + vatCode + "', discCode:'" + discCode + "', custAccCode:'" + custAccCode + "', desc:'" + desc + "', useIntCust:'" + useIntCust + "' , curr:'" + Curr + "', mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d[0];
                if (data.RetVal_Saved != "") {
                    $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#EditGrpGrid').hide();
                }
                else {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
                FetchCustConfig();
            },
            error: function (result) {
                alert("Error");
            }
        });
    }

    function updWarnConfig()
    {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
          
        var idSett = $('#<%=hdnWarn.ClientID%>').val();
        var warnText = $("#<%=txtWarning.ClientID%>").val();

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCfCustomer.aspx/SaveWarningConfig",
            data: "{IdSett:'" + idSett + "',warnText:'" + warnText + "', mode:'" + mode + "'}",
            dataType: "json",
            async: false,
            success: function (data) {
                data = data.d[0];
                if (data.RetVal_Saved != "0") {
                    $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    $('#EditWarning').hide();
                }
                else if (data.RetVal_NotSaved != "")
                {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
                FetchCustConfig();
            },
            error: function (result) {
                alert("Error");
            }
        });
       
        
    }

    function deleteReg() {
        var idReg = "";
        $('#dgdRegion input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idReg = $('#dgdRegion tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idReg != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delRegionConfig();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delRegionConfig() {
        var row;
        var idReg;
        var region;
        var regionIdxml;
        var regionIdxmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdRegion input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idReg = $('#dgdRegion tr ')[row].cells[1].innerHTML.toString();
                region = $('#dgdRegion tr ')[row].cells[2].innerHTML.toString();
                regionIdxml = '<delete><REG ID_SETTINGS= "' + idReg + '" ID_CONFIG= " REG" DESCRIPTION= "' + region + '"/></delete>';
                regionIdxmls += regionIdxml;
            }
        });

        if (regionIdxmls != "") {
            regionIdxmls = "<root>" + regionIdxmls + "</root>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeleteRegionConfig",
                data: "{regionIdxml: '" + regionIdxmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdRegion").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdRegion").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    // $('#divRepairPkgCatg').hide();
                    $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                    if (data.d[0] == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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

    function deletePayConfig() {
        var idPTseq = "";
        $('#dgdPaymentTerms input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idPTseq = $('#dgdPaymentTerms tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idPTseq != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delPayConfig();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delPayConfig() {
        var row;
        var idPTseq;
        var payCode;
        var PTIdxml;
        var PTIdxmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdPaymentTerms input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idPTseq = $('#dgdPaymentTerms tr ')[row].cells[1].innerHTML.toString();
                payCode = $('#dgdPaymentTerms tr ')[row].cells[2].innerHTML.toString();
                PTIdxml = '<DELETE><PAY_TERM ID_PT_SEQ= "' + idPTseq + '"  PAY_CODE= "' + payCode + '"/></DELETE>';
                PTIdxmls += PTIdxml;
            }
        });

        if (PTIdxmls != "") {
            PTIdxmls = "<ROOT>" + PTIdxmls + "</ROOT>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeletePTConfig",
                data: "{payTermXml: '" + PTIdxmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdPaymentTerms").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdPaymentTerms").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    // $('#divRepairPkgCatg').hide();
                    $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                    if (data.d[0] == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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


    function deleteWarn() {
        var idSett = "";
        $('#dgdWarning input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idSett = $('#dgdWarning tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idSett != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delWarnConfig();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delWarnConfig() {
        var row;
        var idSett;
        var warnText;
        var warnIdxml;
        var warnIdxmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdWarning input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idSett = $('#dgdWarning tr ')[row].cells[1].innerHTML.toString();
                warnText = $('#dgdWarning tr ')[row].cells[2].innerHTML.toString();
                warnIdxml = '<delete><CU-WARN ID_SETTINGS= "' + idSett + '" ID_CONFIG= "CU-WARN" DESCRIPTION= "' + warnText + '"/></delete>';
                warnIdxmls += warnIdxml;
            }
        });

        if (warnIdxmls != "") {
            warnIdxmls = "<root>" + warnIdxmls + "</root>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeleteWarnConfig",
                data: "{warnIdxml: '" + warnIdxmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdRegion").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdRegion").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    // $('#divRepairPkgCatg').hide();
                    $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                    if (data.d[0] == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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

    function deleteCustGrp() {
        var idCustGrpSeq = "";
        $('#dgdGroup input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idCustGrpSeq = $('#dgdGroup tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idCustGrpSeq != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delCustGrpConfig();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delCustGrpConfig() {
        var row;
        var idCustGrpSeq;
        var cusg_desc;
        var custGIdxml;
        var custGIdxmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdGroup input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idCustGrpSeq = $('#dgdGroup tr ')[row].cells[1].innerHTML.toString();
                cusg_desc = $('#dgdGroup tr ')[row].cells[2].innerHTML.toString();
                custGIdxml = '<DELETE><CU-GRP ID_CUST_GRP_SEQ= "' + idCustGrpSeq + '" CUSG_DESCRIPTION= "' + cusg_desc + '"/></DELETE>';
                custGIdxmls += custGIdxml;
            }
        });

        if (custGIdxmls != "") {
            custGIdxmls = "<ROOT>" + custGIdxmls + "</ROOT>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeleteCusGConfig",
                data: "{custGIdxml: '" + custGIdxmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdGroup").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdGroup").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    // $('#divRepairPkgCatg').hide();
                    $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                    if (data.d[0] == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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



    function deleteGMPrice() {
        var idGMPriceSeq = "";
        $('#dgdGarageMaterialPrice input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idGMPriceSeq = $('#dgdGarageMaterialPrice tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idGMPriceSeq != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delGMPrice();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delGMPrice() {
        var row;
        var idGMPriceSeq;
        var idCustGrpSeq;
        var garPricePer;
        var description;
        var idDept;
        var gmPricexml;
        var gmPricexmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdGarageMaterialPrice input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idGMPriceSeq = $('#dgdGarageMaterialPrice tr ')[row].cells[1].innerHTML.toString();
                idDept = $('#dgdGarageMaterialPrice tr ')[row].cells[3].innerHTML.toString();
                idCustGrpSeq = $('#dgdGarageMaterialPrice tr ')[row].cells[5].innerHTML.toString();
                garPricePer = $('#dgdGarageMaterialPrice tr ')[row].cells[6].innerHTML.toString();
                description = $('#dgdGarageMaterialPrice tr ')[row].cells[7].innerHTML.toString();
                gmPricexml = '<DELETE><CU-GM  GM_PRICE_SEQ= "' + idGMPriceSeq + '" ID_DEPT= "' + idDept + '" ID_CUST_GRP_SEQ = "' + idCustGrpSeq + '" GARAGE_PRICE_PER= "' + garPricePer + '" GP_DESCRIPTION= "' + description + '"/></DELETE>';
                gmPricexmls += gmPricexml;
            }
        });

        if (gmPricexmls != "") {
            gmPricexmls = "<ROOT>" + gmPricexmls + "</ROOT>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeleteGMPrice",
                data: "{GMPricexml: '" + gmPricexmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdGarageMaterialPrice").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdGarageMaterialPrice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                    if (data.d[0] == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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

    function deleteRP() {
        var idMapSeq = "";
        $('#dgdCustRepPrice input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idMapSeq = $('#dgdCustRepPrice tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idMapSeq != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delCustRP();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delCustRP() {
        var row;
        var idMapSeq;
        var custRPxml;
        var custRPxmls = "";
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

        $('#dgdCustRepPrice input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idMapSeq = $('#dgdCustRepPrice tr ')[row].cells[1].innerHTML.toString();
                custRPxml = '<CRPrice><ID_CR>' + idMapSeq + ' </ID_CR></CRPrice>';
                custRPxmls += custRPxml;
            }
        });

        if (custRPxmls != "") {
            custRPxmls = "<ROOT>" + custRPxmls + "</ROOT>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfCustomer.aspx/DeleteCustRP",
                data: "{custRPIdxml: '" + custRPxmls + "'}",
                dataType: "json",
                success: function (data) {
                    jQuery("#dgdCustRepPrice").jqGrid('clearGridData');
                    FetchCustConfig();
                    jQuery("#dgdCustRepPrice").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    $('#<%=RTlblError.ClientID%>').text(data.d);
                    if (data.d == "DEL") {
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    }
                    else {
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

    //DropDown
    function LoadPriceCode(result) {
        $('#<%=drpCustPrCode.ClientID%>').empty();
        $('#<%=drpCustPrCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpCustPrCode.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.PriceCodeDesc));
        });
    }
    function LoadPayTerms(result)
    {
        $('#<%=drpPayTerms.ClientID%>').empty();
        $('#<%=drpPayTerms.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpPayTerms.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Pay_Description));
        });
    }
    function LoadDiscCode(result) {
        $('#<%=drpDisc.ClientID%>').empty();
        $('#<%=drpDisc.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpDisc.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Discount_Description));
        });
    }
    function LoadVatCode(result) {
        $('#<%=drpVat.ClientID%>').empty();
        $('#<%=drpVat.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpVat.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Vat_Description));
        });
    }
    function LoadPayType(result) {
        $('#<%=drpPaymentType.ClientID%>').empty();
        $('#<%=drpPaymentType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpPaymentType.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Pay_Description));
        });
    }
    function LoadCurrCode() {
        $.ajax({
            type: "POST",
            url: "frmCfCustomer.aspx/LoadCurrency",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (Result) {
                $('#<%=drpcurrCode.ClientID%>').empty();
                $('#<%=drpcurrCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                Result = Result.d;
                $.each(Result, function (key, value) {
                    $('#<%=drpcurrCode.ClientID%>').append($("<option></option>").val(value.Currency).html(value.Currency));

                });

            },
            failure: function () {
                alert("Failed!");
            }
        });

    }
    

    function LoadRPkgDrpDwn() {
        $.ajax({
            type: "POST",
            url: "frmCfCustomer.aspx/LoadRpkg",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (Result) {
                $('#<%=drpRepPackage.ClientID%>').empty();
                $('#<%=drpRepPackage.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                Result = Result.d;
                $.each(Result, function (key, value) {
                    $('#<%=drpRepPackage.ClientID%>').append($("<option></option>").val(value.Id_Rp).html(value.Id_Rp_Code));

                });

            },
            failure: function () {
                alert("Failed!");
            }
        });

    }
    function LoadDepart(result) {
        $('#<%=drpDepartment.ClientID%>').empty();
        $('#<%=drpDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpDepartment.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.DeptName));
        });
    }

    function LoadCustGroup(result)
    {
        $('#<%=drpCustomerGroup.ClientID%>').empty();
        $('#<%=drpCustomerGroup.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpCustomerGroup.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Cust_GrpDesc));
        });
    }
    function LoadVatGM(result)
    {
        $('#<%=drpvatGM.ClientID%>').empty();
        $('#<%=drpvatGM.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
        var Result = result;
        $.each(Result, function (key, value) {
            $('#<%=drpvatGM.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
        });
    }
</script>

<div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblRoleHeader" runat="server" Text="Roles"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" />  
    <asp:HiddenField id="hdnRegion" runat="server" />  
     <asp:HiddenField id="hdnPayTerms" runat="server" />  
     <asp:HiddenField id="hdnCustGrp" runat="server" /> 
    <asp:HiddenField id="hdnWarn" runat="server" /> 
    <asp:HiddenField id="hdnGMPrice" runat="server" /> 
    <asp:HiddenField id="hdnMapSeq" runat="server" /> 
       

</div>
 <div id="divRoleDetails" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Customer ID</a>  
            </div>
      <div class="six fields">
                    <div class="field" style="padding-left:0.55em;width:800px;height:50px">
                         <asp:Label id="lblStartSeries" runat="server" Text="Cur. Start No." Width="100px"></asp:Label>
                         <asp:Label id="RTlblStartingSeries" runat="server"  Width="100px"></asp:Label>
                          <asp:Label id="lblEndSeries" runat="server" Text="Cur. End No." Width="100px"></asp:Label>
                         <asp:Label id="RTlblEndingSeries" runat="server"  Width="100px"></asp:Label>
                         <asp:Label id="lblCustID" runat="server" Text="Cur. Customer ID" Width="150px"></asp:Label>
                         <asp:Label id="RTlblCustomerID" runat="server" Text="16252" Width="100px"></asp:Label>
                    </div>
              </div>
          <div class="six fields">
              <div class="field" style="padding-left:0.55em;width:800px;height:50px">
                         <asp:Label id="lblStartNo" runat="server" Text="New Start No." Width="100px"></asp:Label>
                         <asp:TextBox ID="txtStartNo" runat="server" CssClass="inp" Width="100px" MaxLength="10" ></asp:TextBox>
                         <asp:Label id="lblEndNo" runat="server" Text="New End No." Width="100px"></asp:Label>
                          <asp:TextBox ID="txtEndNo" runat="server" CssClass="inp" Width="100px" MaxLength="10"></asp:TextBox>
                    </div>
          </div>
          <div style="text-align:center">
                <input id="btnCustSave" runat="server" type="button" value="Save" class="ui button" />
        </div>
      <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A1" runat="server" class="active item">Region</a>  
      </div>
      <div style="text-align:center">
                <input id="btnRegionAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnRegionDelete1" runat="server" type="button" value="Delete" class="ui button" onclick="deleteReg()" />
        </div>
        <div id ="RegionGrid" style="text-align:center">
                        <table id="dgdRegion"></table>
                        <div id="pagerRegion" ></div>
        </div>
        <div id="EditRegion">
             <div class="six fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblRegion" runat="server" Text="Region" Width="100px" ></asp:Label><span class="mand">*</span>
               <asp:TextBox ID="txtRegion" runat="server" Width="100px" MaxLength="20" CssClass="inp"></asp:TextBox>
            </div>
            </div>
            <div style="text-align:center">
                <input id="btnSaveRegion" runat="server" type="button" value="Save" class="ui button" />
                 <input id="btnCancelRegion" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
        </div>
      <div style="padding:0.5mm"></div>
     <div style="text-align:center">
                <input id="btnRegionAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnRegionDelete2" runat="server" type="button" value="Delete" class="ui button" onclick="deleteReg()" />
        </div>
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A2" runat="server" class="active item">Payment Terms</a>  
      </div>
      <div style="text-align:center">
                <input id="btnPaymentAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnPaymentDelete1" runat="server" type="button" value="Delete" class="ui button" onclick="deletePayConfig()" />
        </div>
      <div id ="PayTermsGrid" style="text-align:center">
                        <table id="dgdPaymentTerms"></table>
                        <div id="pagerPaymentTerms" ></div>
        </div>
      <div id="EditPayTerms">
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblPayCode" runat="server" Text="Pay Code" Width="100px" ></asp:Label><span class="mand">*</span>
               <asp:TextBox ID="txtPayCode" runat="server" Width="100px" MaxLength="3" CssClass="inp"></asp:TextBox>
            </div>
            </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblPayTerm" runat="server" Text="Payment Terms" Width="100px" ></asp:Label><span class="mand">*</span>
               <asp:TextBox ID="txtPayTerms" runat="server" Width="100px" MaxLength="4" CssClass="inp"></asp:TextBox>
            </div>
            </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblText" runat="server" Text="Text" Width="100px" ></asp:Label><span class="mand">*</span>
               <asp:TextBox ID="txtText" runat="server" Width="100px" MaxLength="4" CssClass="inp"></asp:TextBox>
            </div>
            </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblFreeMonth" runat="server" Text="Free Month" Width="100px" ></asp:Label><span class="mand">*</span>
                <asp:CheckBox ID="chkFreeMonth" runat="server" />
            </div>
              <div style="text-align:center">
                <input id="btnSavePayment" runat="server" type="button" value="Save" class="ui button" />
                 <input id="btnCancelPayment" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
            </div>
      </div>
     <div style="padding:0.5mm"></div>
     <div style="text-align:center">
                <input id="btnPaymentAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnPaymentDelete2" runat="server" type="button" value="Delete" class="ui button" onclick="deletePayConfig()" />
        </div>

      <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A6" runat="server" class="active item">Customer Group</a>  
      </div>
     <div style="text-align:center">
                <input id="btnGroupAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnGroupDelete1" runat="server" type="button" value="Delete" class="ui button" onclick="deleteCustGrp()" />
      </div>
     <div id ="GroupGrid" style="text-align:center">
                        <table id="dgdGroup"></table>
                        <div id="pagerGroup" ></div>
      </div>
      <div id="EditGrpGrid">
          <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblCustGrp" runat="server" Text="Customer Group" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtCustGrp" runat="server" CssClass="inp" MaxLength="50" Width="150px" ></asp:TextBox>
                 <asp:Label ID="lblCustPrCode" runat="server" Text="Price Code" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpCustPrCode" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
          <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblPaymentType" runat="server" Text="Payment Type" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpPaymentType" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
                 <asp:Label ID="lblPayTerms" runat="server" Text="Payment Terms" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpPayTerms" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
           <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblVAT" runat="server" Text="VAT Code" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpVat" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
                 <asp:Label ID="lblDiscount" runat="server" Text="Discount Code" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpDisc" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
            </div>
               </div>
               <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblCustAcc" runat="server" Text="Account Code" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtcustacc" runat="server" CssClass="inp" MaxLength="50" Width="150px" ></asp:TextBox>
                 <asp:Label ID="lblDescription" runat="server" Text="Description" Width="100px" ></asp:Label>
                 <asp:TextBox ID="txtDescription" runat="server" CssClass="inp" MaxLength="50" Width="150px" ></asp:TextBox>
            </div>
        </div>
                <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblCurrency" runat="server" Text="Currency" Width="100px" ></asp:Label>
                 <asp:DropDownList ID="drpcurrCode" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
                 <asp:Label ID="lblIntCust" runat="server" Text="Internal Customer" Width="100px" ></asp:Label>
                 <asp:CheckBox ID="chkIntCust" runat="server" />
            </div>
        </div>
           <div style="text-align:center">
                <input id="btnSaveGrp" runat="server" type="button" value="Save" class="ui button" />
                 <input id="btnCancelGrp" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
      
</div>
      <div style="padding:0.5mm"></div>
       <div style="text-align:center">
                <input id="btnGroupAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnGroupDelete2" runat="server" type="button" value="Delete" class="ui button"  onclick="deleteCustGrp()" />
      </div>
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A3" runat="server" class="active item">Warning Text</a>  
      </div>
     <div style="text-align:center">
                <input id="btnWarningAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnWarningDelete1" runat="server" type="button" value="Delete" class="ui button" onclick="deleteWarn()" />
        </div>
      <div id ="WarningGrid" style="text-align:center">
                        <table id="dgdWarning"></table>
                        <div id="pagerWarning" ></div>
        </div>
     <div id="EditWarning">
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblWarning" runat="server" Text="Warning Text" Width="100px" ></asp:Label><span class="mand">*</span>
                <asp:TextBox ID="txtWarning" runat="server" Width="120px" MaxLength="70" CssClass="inp"></asp:TextBox>
            </div>
        </div>
         <div style="text-align:center">
                <input id="btnSaveWarning" runat="server" type="button" value="Save" class="ui button" />
                 <input id="btnCancelWarning" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
    </div>
      <div style="padding:0.5mm"></div>
     <div style="text-align:center">
                <input id="btnWarningAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnWarningDelete2" runat="server" type="button" value="Delete" class="ui button" onclick="deleteWarn()" />
      </div>
      <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A4" runat="server" class="active item">Garage Material Price</a>  
      </div>
     <div style="text-align:center">
                <input id="btnPriceAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnPriceDel1" runat="server" type="button" value="Delete" class="ui button" onclick ="deleteGMPrice()" />
      </div>
     <div id ="GarageMaterialPriceGrid" style="text-align:center">
                        <table id="dgdGarageMaterialPrice"></table>
                        <div id="pagerGarageMaterialPrice" ></div>
        </div>
      <div id="EditGMPrice">
           <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblDept" runat="server" Text="Department" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpDepartment" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
                 <asp:Label ID="lblCustGroup" runat="server" Text="Customer Group" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpCustomerGroup" runat="server" Width="120px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
          <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblGMPricePercent" runat="server" Text="GM Price Percentage" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtGMPricePercent" runat="server" CssClass="inp" MaxLength="5" Width="150px" ></asp:TextBox>
                 <asp:Label ID="lblGMDescription" runat="server" Text="Description" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtGMDescription" runat="server" CssClass="inp" MaxLength="50" Width="150px" ></asp:TextBox>
            </div>
        </div>
          <div class="four fields lbl">
             <div class="field" style="padding:0.55em;width:600px">
                <asp:Label ID="lblVat1" runat="server" Text="VAT Code for GM" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:DropDownList ID="drpvatGM" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
                 <asp:Label ID="lblAccountCode" runat="server" Text="Account Code" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtAccountCode" runat="server" CssClass="inp" MaxLength="50" Width="150px" ></asp:TextBox>
            </div>
        </div>
          <div style="text-align:center">
                <input id="btnPriceSave" runat="server" type="button" value="Save" class="ui button" />
                 <input id="btnPriceCancel" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
       </div>
      <div style="padding:1.5mm"></div>
     <div style="text-align:center">
                <input id="btnPriceAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnPriceDel2" runat="server" type="button" value="Delete" class="ui button" onclick ="deleteGMPrice()" />
      </div>

      <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A5" runat="server" class="active item">Customer Repair Package Price</a>  
      </div>
     <div style="text-align:center">
                <input id="btnCRAdd" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnCRDelete" runat="server" type="button" value="Delete" class="ui button" onclick="deleteRP()" />
      </div>
     <div id ="CustRepPriceGrid" style="text-align:center">
           <table id="dgdCustRepPrice"></table>
           <div id="pagerCustRepPrice" ></div>
      </div>
      <div id="EditCustRepPrice">
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblRepPkgName" runat="server" Text="Repair Package Name" Width="100px" ></asp:Label><span class="mand">*</span>
                <asp:DropDownList ID="drpRepPackage" runat="server" Width="150px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblCustomerId" runat="server" Text="Customer Id" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtCustId" runat="server" CssClass="inp" MaxLength="10" Width="150px" ></asp:TextBox>
            </div>
        </div>
           <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblHPFPPrice" runat="server" Text="HP/FP Price" Width="100px" ></asp:Label><span class="mand">*</span>
                 <asp:TextBox ID="txtHPFP" runat="server" CssClass="inp" MaxLength="9" Width="150px" ></asp:TextBox>
            </div>
        </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                 <asp:RadioButton ID="rbHP" runat="server" Text="Hourly Price" style="padding-right:20px;"   />
                 <asp:RadioButton ID="rbFP" runat="server" Text="Fixed Price" style="padding-right:20px;"   />
            </div>
        </div>
           <div style="text-align:center">
                <input id="btnCRSave" runat="server" type="button" value="Save" class="ui button"  />
                 <input id="btnCRCancel" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
      </div>
     <div style="padding:0.5mm"></div>
     <div style="text-align:center">
                <input id="btnCRAdd2" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnCRDelete2" runat="server" type="button" value="Delete" class="ui button" onclick="deleteRP()" />
      </div>
</div>
</asp:Content>