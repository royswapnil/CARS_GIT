<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfInvoice.aspx.vb" Inherits="CARS.frmCfInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        var seperator = '<%= Session("Decimal_Seperator") %>';

        function fnClientValidate() {
            if ($('#<%=drpSubsidiary.ClientID%>')[0].selectedIndex == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0122', '', ''), '');
                alert(msg);
                $('#<%=drpSubsidiary.ClientID%>').focus();
                return false;
            }
            if ($('#<%=drpDepartment.ClientID%>')[0].selectedIndex == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0049', '', ''), '');
                alert(msg);
                $('#<%=drpDepartment.ClientID%>').focus();
                return false;
            }

            if (!(gfi_ValidateNumber($('#<%=txtValueTime.ClientID%>'), '0229'))) {
                return false;
            }
            if ($('#<%=txtValueTime.ClientID%>').val() > 59) {
                var msg = GetMultiMessage('0007', GetMultiMessage('0060', '', ''), '');
                alert(msg);
                $('#<%=txtValueTime.ClientID%>').val() = "";
                $('#<%=txtValueTime.ClientID%>').focus();
                return false;
            }


            if (!(gfi_ValidateNumber($('#<%=txtRoundPrice.ClientID%>'), '0230'))) {
                return false;
            }

            if ($('#<%=txtRoundPrice.ClientID%>').val().replace(",", ".") > 100) {
                var msg = GetMultiMessage('0007', GetMultiMessage('0061', '', ''), '');
                alert(msg);
                $('#<%=txtRoundPrice.ClientID%>').val() = "";
                $('#<%=txtRoundPrice.ClientID%>').focus();
                return false;
            }

            if (!(gfi_ValidateNumDot($('#<%=txtRoundTime.ClientID%>'), '0229'))) {
                return false;
            }

            trtVal = $('#<%=txtRoundTime.ClientID%>').val();
            if (trtVal.replace(",", ".") > 100) {
                var msg = GetMultiMessage('1771', '', '');
                alert(msg);
                $('#<%=txtRoundTime.ClientID%>').val() = "";
                $('#<%=txtRoundTime.ClientID%>').focus();
                return false;
            }

            if ($('#<%= rdbLstFlrRnd.ClientID%> input:radio')[2].checked) {
                if ($('#<%=txtRoundTime.ClientID%>').val() == "") {
                    var msg = GetMultiMessage('1772', '', '');
                    alert(msg)
                    $('#<%=txtRoundTime.ClientID%>').focus();
                    return false
                }
            }

            trtVal = $('#<%=txtValuePrice.ClientID%>').val();
            if (trtVal.replace(",", ".") > 100) {
                var msg = GetMultiMessage('1773', '', '');
                alert(msg);
                $('#<%=txtValuePrice.ClientID%>').val() = "";
                $('#<%=txtValuePrice.ClientID%>').focus();
                return false;
            }

            if (!(gfi_ValidateNumDot($('#<%=txtValuePrice.ClientID%>')))) {
                return false;
            }

            if ($('#<%= rdbLstRnd.ClientID%> input:radio')[2].checked) {
                if ($('#<%=txtValuePrice.ClientID%>').val() == "") {
                    var msg = GetMultiMessage('1774', '', '');
                    alert(msg)
                    $('#<%=txtValuePrice.ClientID%>').focus();
                    return false
                }
            }

            if (!($('#<%=txtKIDCustNumLen.ClientID%>').is(':disabled')) && !(gfi_CheckEmpty($('#<%=txtKIDCustNumLen.ClientID%>'), '0232'))) {
                return false;
            }

            if (!($('#<%=txtKIDCustNumLen.ClientID%>').is(':disabled')) && $('#<%=txtKIDCustNumLen.ClientID%>').val() == "0") {
                var msg = GetMultiMessage('MSG122', '', '');
                alert(msg)
                $('#<%=txtKIDCustNumLen.ClientID%>').focus()
                return false;
            }

            if (!($('#<%=txtKIDCustNumLen.ClientID%>').is(':disabled')) && !(gfb_ValidateNumbers($('#<%=txtKIDCustNumLen.ClientID%>')[0], '0232'))) {
                if (!($('#<%=txtKIDCustNumLen.ClientID%>') > 0)) {
                    return false;
                }
            }

            if (!($('#<%=txtKIDInvNumLen.ClientID%>').is(':disabled')) && !(gfi_CheckEmpty($('#<%=txtKIDInvNumLen.ClientID%>'), '0233'))) {
                return false;
            }

            if (!($('#<%=txtKIDInvNumLen.ClientID%>').is(':disabled')) && ($('#<%=txtKIDInvNumLen.ClientID%>').val()) == "0") {
                var msg = GetMultiMessage('MSG123', '', '');
                alert(msg)
                $('#<%=txtKIDInvNumLen.ClientID%>').focus()
                return false;
            }

            if (!($('#<%=txtKIDInvNumLen.ClientID%>').is(':disabled')) && !(gfb_ValidateNumbers($('#<%=txtKIDInvNumLen.ClientID%>')[0], '0233'))) {
                if (!($('#<%=txtKIDInvNumLen.ClientID%>')[0] > 0)) {
                    return false;
                }
            }

            if (!($('#<%=txtKIDWONumLen.ClientID%>').is(':disabled')) && !(gfi_CheckEmpty($('#<%=txtKIDWONumLen.ClientID%>'), '0234'))) {
                return false;
            }

            if (!($('#<%=txtKIDWONumLen.ClientID%>').is(':disabled')) && ($('#<%=txtKIDWONumLen.ClientID%>').val()) == "0") {
                var msg = GetMultiMessage('MSG124', '', '');
                alert(msg);
                $('#<%=txtKIDWONumLen.ClientID%>').focus()
                return false;
            }

            if (!($('#<%=txtKIDWONumLen.ClientID%>').is(':disabled')) && !(gfb_ValidateNumbers($('#<%=txtKIDWONumLen.ClientID%>')[0], '0234'))) {
                if (!($('#<%=txtKIDWONumLen.ClientID%>')[0] > 0)) {
                    return false;
                }
            }

            if (!($('#<%=txtKIDFixNumLen.ClientID%>').is(':disabled')) && !(gfi_CheckEmpty($('#<%=txtKIDFixNumLen.ClientID%>'), '0235'))) {
                return false;
            }

            if (!($('#<%=txtKIDFixNumLen.ClientID%>').is(':disabled')) && !(gfb_ValidateNumbers($('#<%=txtKIDFixNumLen.ClientID%>')[0], '0235'))) {
                if (!($('#<%=txtKIDFixNumLen.ClientID%>')[0] > 0)) {
                    return false;
                }
            }

            vartxtKIDFixNumText = $('#<%=txtKIDFixNumText.ClientID%>').val()
            $('#<%=txtKIDFixNumLen.ClientID%>').val(vartxtKIDFixNumText.length);

            if ((vartxtKIDFixNumText != "")
                    && !($('#<%=txtKIDFixNumText.ClientID%>').is(':disabled')) && !(gfb_ValidateNumbers($('#<%=txtKIDFixNumText.ClientID%>')[0], '0236'))) {
                if (!($('#<%=txtKIDFixNumText.ClientID%>')[0] > 0)) {
                    return false;
                }
            }
            if (parseFloat($('#<%=txtKIDCustNumLen.ClientID%>').val())
                        + parseFloat($('#<%=txtKIDInvNumLen.ClientID%>').val())
                        + parseFloat($('#<%=txtKIDWONumLen.ClientID%>').val())
                        + parseFloat($('#<%=txtKIDFixNumLen.ClientID%>').val())
                    > 24) {
                var msg = GetMultiMessage('0062', '', '');
                alert(msg);
                $('#<%=txtKIDFixNumText.ClientID%>').focus();
                return false;
            }

            if (!(fn_ValidateDecimal($('#<%=txtInvFeeAmt.ClientID%>')[0], seperator))) { 
                var msg = GetMultiMessage('0116', GetMultiMessage('INVFEE', '', ''), '');
                alert(msg);
                $('#<%=txtInvFeeAmt.ClientID%>').focus();
                return false;
            }


            if ($('#<%=chkInvFee.ClientID%>').is(':checked')) {
                if ($('#<%=txtInvFeeAmt.ClientID%>').val() == "") {
                    var msg = GetMultiMessage('INVFEEAMT', '', '');
                    alert(msg);
                    $('#<%=txtInvFeeAmt.ClientID%>').focus();
                    return false;
                }
                else if ($('#<%=txtInvFeeAccCode.ClientID%>').val() == "") {
                    var msg = GetMultiMessage('INVFEEACCNTCODE', '', '');
                    alert(msg);
                    $('#<%=txtInvFeeAccCode.ClientID%>').focus();
                    return false;
                }

            }


            window.scrollTo(0, 0);
            return true;
        }
        $(document).ready(function () {
            debugger;
            $('#<%=txtPayType.ClientID%>').hide();
            if ($('#<%=hdnCntPT.ClientID%>').val() == 0)
            {
                $('#EditInvSeries').hide();
            }
            var subId = '<%= Session("UserSubsidiary")%>';
            var deptId = '<%= Session("UserDept")%>';
            LoadSubsidiary();
            loadDept($('#<%=drpSubsidiary.ClientID%>').val());
            loadInvoiceSettings();
            LoadInvNoSeries();
            loadGrid();

            
            function LoadSubsidiary() {
                $.ajax({
                    type: "POST",
                    url: "frmCfInvoice.aspx/LoadSubsidiary",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpSubsidiary.ClientID%>').empty();
                        $('#<%=drpCopySubsidiary.ClientID%>').empty();
                        $('#<%=drpCopySubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        $('#<%=drpSubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                            if (($('#<%=chkCopyConf.ClientID%>').is(':checked')) == false) {
                                $('#<%=drpCopySubsidiary.ClientID%>').attr("disabled", "disabled");
                            }
                            $('#<%=drpCopySubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }
            function loadDept(subId) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfInvoice.aspx/LoadDepartment",
                    data: "{'subId':'" + subId + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        $('#<%=drpDepartment.ClientID%>').empty();
                        $('#<%=drpCopyDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        $('#<%=drpDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpDepartment.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));

                            if (($('#<%=chkCopyConf.ClientID%>').is(':checked')) == false) {
                                $('#<%=drpCopyDepartment.ClientID%>').attr("disabled", "disabled");
                            }
                           
                        });
                    }
                });
            }
            if (subId != "")
            {
                $('#<%=drpSubsidiary.ClientID%>').val(subId);

            }

            if (deptId != "")
            {
                loadDept($('#<%=drpSubsidiary.ClientID%>').val());
                $('#<%=drpDepartment.ClientID%>').val(deptId);

            }
            function loadDeptCopy(subId) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfInvoice.aspx/LoadDepartment",
                    data: "{'subId':'" + subId + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        $('#<%=drpCopyDepartment.ClientID%>').empty();
                       
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpCopyDepartment.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                        });
                    }
                });
            }
            function LoadInvNoSeries() {
                var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                var deptId = $('#<%=drpDepartment.ClientID%>').val();
                $.ajax({
                    type: "POST",
                    url: "frmCfInvoice.aspx/LoadInvNoSeries",
                    data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpInvNoSeries.ClientID%>').append($("<option></option>").val(value.InvNoSeries).html(value.Inv_Prefix));
                            $('#<%=drpCreNoSeries.ClientID%>').append($("<option></option>").val(value.CreNoSeries).html(value.Cre_Prefix));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function LoadPayType() {
                var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                var deptId = $('#<%=drpDepartment.ClientID%>').val();
                $.ajax({
                    type: "POST",
                    url: "frmCfInvoice.aspx/LoadInvNoSeries",
                    data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpInvNoSeries.ClientID%>').append($("<option></option>").val(value.InvNoSeries).html(value.Inv_Prefix));
                            $('#<%=drpCreNoSeries.ClientID%>').append($("<option></option>").val(value.CreNoSeries).html(value.Cre_Prefix));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            if ($('#<%=hdnCntPT.ClientID%>').val() != 0) {
                $('#<%=hdnMode.ClientID%>').val("Add");
                $('#<%=RTlblError.ClientID%>').text("New Pay config is present, please save it.");
                $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                var payId = $('#<%=drpPayType.ClientID%>').val();
                var invNoSer = $('#<%=drpInvNoSeries.ClientID%>').val();
                var creNoSer = $('#<%=drpCreNoSeries.ClientID%>').val();
                var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
                $('#<%=hdnXml.ClientID%>').val(strGridDet);
                $('#<%=btnupdate.ClientID%>').hide();
                $('#<%=btnSavePayment.ClientID%>').show();
            }


           

            $('#<%=drpSubsidiary.ClientID%>').change(function (e) {
                var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                loadDept(subId);
            });
            $('#<%=drpDepartment.ClientID%>').change(function (e) {
                
                loadInvoiceSettings();
                jQuery("#dgdInvNumberSeries").jqGrid('clearGridData');
                loadGrid();
            });

           <%-- $('#<%=drpCopyDepartment.ClientID%>').change(function (e) {
                loadInvoiceSettingsCopy();
                jQuery("#dgdInvNumberSeries").jqGrid('clearGridData');
                loadGridCopy();
            });--%>

            $('#<%=drpCopySubsidiary.ClientID%>').change(function (e) {
                var subId = $('#<%=drpCopySubsidiary.ClientID%>').val();
                loadDeptCopy(subId);
            });
            
            $('#<%=drpCreNoSeries.ClientID%>').change(function (e) {
                if ($('#<%=hdnMode.ClientID%>').val() == "Edit")
                {
                var payId = $('#<%=hdnPayId.ClientID%>').val();
                var invNoSer = $('#<%=drpInvNoSeries.ClientID%>').val();
                var creNoSer = $('#<%=drpCreNoSeries.ClientID%>').val();
                var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
                $('#<%=hdnXml.ClientID%>').val(strGridDet);
                }
                else {
                    var payId = $('#<%=drpPayType.ClientID%>').val();
                    var invNoSer = $('#<%=drpInvNoSeries.ClientID%>').val();
                    var creNoSer = $('#<%=drpCreNoSeries.ClientID%>').val();
                    var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                    strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
                    $('#<%=hdnXml.ClientID%>').val(strGridDet);
                }
            });
            $('#<%=drpInvNoSeries.ClientID%>').change(function (e) {
                if ($('#<%=hdnMode.ClientID%>').val() == "Edit") {
                    var payId = $('#<%=hdnPayId.ClientID%>').val();
                    var invNoSer = $('#<%=drpInvNoSeries.ClientID%>').val();
                    var creNoSer = $('#<%=drpCreNoSeries.ClientID%>').val();
                    var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                    strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
                    $('#<%=hdnXml.ClientID%>').val(strGridDet);
                }
                else {
                    var payId = $('#<%=drpPayType.ClientID%>').val();
                    var invNoSer = $('#<%=drpInvNoSeries.ClientID%>').val();
                    var creNoSer = $('#<%=drpCreNoSeries.ClientID%>').val();
                    var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                    strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
                    $('#<%=hdnXml.ClientID%>').val(strGridDet);
                }
            });

            $('#<%=drpKIDCustNumOrd.ClientID%>').change(function (e) {
                if ($('#<%=drpKIDCustNumOrd.ClientID%>').find('option:selected').text() == "X")
                {
                    //$('#<%=drpCopySubsidiary.ClientID%>').removeAttr("disabled");
                    $('#<%=txtKIDCustNumLen.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDCustNumLen.ClientID%>').val("0");
                }
                else
                {
                    $('#<%=txtKIDCustNumLen.ClientID%>').removeAttr("disabled");
                }
            });

            $('#<%=drpKIDInvNumOrd.ClientID%>').change(function (e) {

                if ($('#<%=drpKIDInvNumOrd.ClientID%>').find('option:selected').text() == "X")
                {
                    //$('#<%=drpCopySubsidiary.ClientID%>').removeAttr("disabled");
                    $('#<%=txtKIDInvNumLen.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDInvNumLen.ClientID%>').val("0");
                }
                else
                {
                    $('#<%=txtKIDInvNumLen.ClientID%>').removeAttr("disabled");
                }
            });
            $('#<%=drpKIDWONumOrd.ClientID%>').change(function (e) {
                if ($('#<%=drpKIDWONumOrd.ClientID%>').find('option:selected').text() == "X")
                {
                    $('#<%=txtKIDWONumLen.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDWONumLen.ClientID%>').val("0");
                }
                else
                {
                    $('#<%=txtKIDWONumLen.ClientID%>').removeAttr("disabled");
                }
            });

            $('#<%=drpKIDFixNumOrd.ClientID%>').change(function (e) {
                if ($('#<%=drpKIDFixNumOrd.ClientID%>').find('option:selected').text() == "X") {
                    $('#<%=txtKIDFixNumText.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDFixNumText.ClientID%>').val("");
                }
                else {
                    $('#<%=txtKIDFixNumText.ClientID%>').removeAttr("disabled");
                }
            });

            $(function () {
                $('[id*=rdbLstFlrRnd] input').unbind().click(function (e) {
                    var val = $('[id*=rdbLstFlrRnd]').find('input:checked').val();
                    if (val =="Rnd")
                    {
                        
                        $('#<%=txtRoundTime.ClientID%>').removeAttr("disabled");
                    }
                    else
                    {
                        $('#<%=txtRoundTime.ClientID%>').attr("disabled", "disabled");
                    }
                });
            });

            $(function () {
                $('[id*=rdbLstRnd] input').unbind().click(function (e) {
                    var val = $('[id*=rdbLstRnd]').find('input:checked').val();
                    if (val == "Rnd") {
                        $('#<%=txtValuePrice.ClientID%>').removeAttr("disabled");

                    }
                    else {
                        $('#<%=txtValuePrice.ClientID%>').attr("disabled", "disabled");
                    }
                });
            });

            $('#<%=txtKIDFixNumText.ClientID%>').change(function (e) {
                var FxdLen = $('#<%=txtKIDFixNumText.ClientID%>').val().length;
                $('#<%=txtKIDFixNumLen.ClientID%>').val(FxdLen);
            });


        });
        function UpdateConfig(mode) {
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpDepartment.ClientID%>').val();
            var invTimeRndUnit = $('#<%=rdbLstTimeRnd.ClientID%>').find(":checked").val();
            var invTimRnd = $('#<%=txtValueTime.ClientID%>').val();
            var invTimeRndFn = $('#<%=rdbLstFlrRnd.ClientID%>').find(":checked").val();
            var invTimeRndPer = $('#<%=txtRoundTime.ClientID%>').val();
            var invPrRndFn = $('#<%=rdbLstRnd.ClientID%>').find(":checked").val();
            var invPrRndVal = $('#<%=txtValuePrice.ClientID%>').val();
            var invRndDec = $('#<%=txtRoundPrice.ClientID%>').val();
            var kidFxdNum = $('#<%=txtKIDFixNumText.ClientID%>').val();
            var kidCustNod = $('#<%=txtKIDCustNumLen.ClientID%>').val();
            var kidInvNod = $('#<%=txtKIDInvNumLen.ClientID%>').val();
            var kidWoNod = $('#<%=txtKIDWONumLen.ClientID%>').val();
            var kidFxdNod = $('#<%=txtKIDFixNumLen.ClientID%>').val();
            var kidCustOrd = $('#<%=drpKIDCustNumOrd.ClientID%>').val();
            var kidInvOrd = $('#<%=drpKIDInvNumOrd.ClientID%>').val();
            var kidWoOrd = $('#<%=drpKIDWONumOrd.ClientID%>').val();
            var kidFxdOrd = $('#<%=drpKIDFixNumOrd.ClientID%>').val();
            var flgKidMod10 = $('#<%=rdbLstModulus.ClientID%>').find(":checked").val();
            var xmlVal = $('#<%=hdnXml.ClientID%>').val();
            var extVatCode = $('#<%=txtExtVATCode.ClientID%>').val();
            var accCode = $('#<%=txtAccountCode.ClientID%>').val();
            var flgInvFees = $('#<%=chkInvFee.ClientID%>').is(':checked');
            var invFeesAmt = $('#<%=txtInvFeeAmt.ClientID%>').val();
            var invFeesAccCode = $('#<%=txtInvFeeAccCode.ClientID%>').val();
            var mode = mode;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/Update_Config",
                data: "{'subId':'" + subId + "',deptId:'" + deptId + "',invTimeRndUnit:'" + invTimeRndUnit + "',invTimRnd:'" + invTimRnd + "',invTimeRndFn:'" + invTimeRndFn +
                    "',invTimeRndPer: '" + invTimeRndPer + "',invPrRndFn: '" + invPrRndFn + "',invPrRndVal: '" + invPrRndVal + "',invRndDec: '" + invRndDec + "',kidFxdNum: '" + kidFxdNum +
                    "',kidCustNod: '" + kidCustNod + "',kidInvNod: '" + kidInvNod + "',kidWoNod: '" + kidWoNod + "',kidFxdNod: '" + kidFxdNod + "',kidCustOrd: '" + kidCustOrd + "',kidInvOrd: '" + kidInvOrd + "',kidWoOrd: '" + kidWoOrd + "',kidFxdOrd: '" + kidFxdOrd + "',flgKidMod10: '" + flgKidMod10 +
                    "',xmlVal: '" + xmlVal + "',extVatCode: '" + extVatCode + "',accCode: '" + accCode + "',flgInvFees: '" + flgInvFees + "',invFeesAmt: '" + invFeesAmt + "',invFeesAccCode: '" + invFeesAccCode + "',mode: '" + mode + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    data = data.d
                    if (data != "") {
                        $('#<%=RTlblError.ClientID%>').text(data);
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    }

                }
            });



        }
            $(document).on('click', '#<%=chkCopyConf.ClientID%>', function () {
                $('#<%=chkCopyConf.ClientID%>').attr("checked", function () {
                    if (this.checked == true) {
                        $('#<%=drpCopySubsidiary.ClientID%>').removeAttr("disabled");
                        $('#<%=drpCopyDepartment.ClientID%>').removeAttr("disabled");
                    }
                    else
                    {
                        $('#<%=drpCopySubsidiary.ClientID%>').attr("disabled", "disabled");
                        $('#<%=drpCopyDepartment.ClientID%>').attr("disabled", "disabled");
                    }
                
                });
            });

        $(document).on('click', '#<%=chkInvFee.ClientID%>', function () {
            $('#<%=chkInvFee.ClientID%>').attr("checked", function () {
                if (this.checked == true) {
                    $('#<%=txtInvFeeAmt.ClientID%>').removeAttr("disabled");
                    $('#<%=txtInvFeeAccCode.ClientID%>').removeAttr("disabled");
                }
                else
                {
                    $('#<%=txtInvFeeAmt.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtInvFeeAccCode.ClientID%>').attr("disabled", "disabled");
                }
                
            });

        });

        

       <%-- $('#<%=drpCopyDepartment.ClientID%>').change(function (e) {
                    $('#<%=chkCopyConf.ClientID%>').attr("checked", function () {
                        if (this.checked == true) {
                            loadInvoiceSettingsCopy();
                            jQuery("#dgdInvNumberSeries").jqGrid('clearGridData');
                            loadGridCopy();
                        }
                    });
                });--%>

        function editSeries(cellvalue, options, rowObject) {
            var payId = rowObject.Id_Settings.toString();
            var invNoSer = rowObject.InvNoSeries.toString();
            var creNoSer = rowObject.CreNoSeries.toString();
            var idNumSer = rowObject.IdNumSeries.toString();
            var payType = rowObject.Description.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editInvSeries(" + "'" + invNoSer + "','" + creNoSer + "'" + ",'" + idNumSer + "'" + ",'" + payType + "'" + ",'" + payId + "'" + "); />";
            return edit;
        }
        function editInvSeries(invNoSer, creNoSer, idNumSer,desc,payId)
        {
            $('#<%=drpPayType.ClientID%>').hide();
            $('#<%=txtPayType.ClientID%>').show();
            $('#<%=btnupdate.ClientID%>').show();
            $('#<%=btnSavePayment.ClientID%>').hide();
            $('#EditInvSeries').show();

            $('#<%=hdnMode.ClientID%>').val("Edit");
            $('#<%=drpInvNoSeries.ClientID%>').val(invNoSer);
            $('#<%=drpCreNoSeries.ClientID%>').val(creNoSer);
            $('#<%=txtPayType.ClientID%>').val(desc);
            var strGridDet = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
            strGridDet = '<ROOT>' + strGridDet + '</ROOT>'
            $('#<%=hdnXml.ClientID%>').val(strGridDet);
            $('#<%=hdnPayId.ClientID%>').val(payId);
        }

        function loadGrid() {
            var grid = $("#dgdInvNumberSeries");
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpDepartment.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mydata;
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['IdNumSeries', 'Id_Settings', 'Payment Type', 'Invoice Number Series', 'Invoice No', 'CreditNote Number Series', 'Credit No', ''],
                colModel: [
                         { name: 'IdNumSeries', index: 'IdNumSeries', width: 60, sorttype: "string", hidden: true },
                         { name: 'Id_Settings', index: 'Id_Settings', width: 60, sorttype: "string", hidden: true },
                         { name: 'Description', index: 'Description', width: 190, sorttype: "string" },
                         { name: 'Inv_Prefix', index: 'Inv_Prefix', width: 160, sorttype: "string" },
                         { name: 'InvNoSeries', index: 'InvNoSeries', width: 160, sorttype: "string", hidden: true },
                         { name: 'Cre_Prefix', index: 'Cre_Prefix', width: 160, sorttype: "string" },
                         { name: 'CreNoSeries', index: 'CreNoSeries', width: 160, sorttype: "string", hidden: true },
                         { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editSeries }
                ],
                multiselect: true,
                pager: jQuery('#pager1'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Invoice Number Series",
                async: false, //Very important,
                subgrid: false

            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/LoadInvNumSeriesGrd",
                data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdInvNumberSeries").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdInvNumberSeries").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdInvNumberSeries").jqGrid("hideCol", "subgrid");
        }


        function loadGridCopy() {
            var grid = $("#dgdInvNumberSeries");
            var subId = $('#<%=drpCopySubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpCopyDepartment.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mydata;
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['IdNumSeries', 'Id_Settings', 'Payment Type', 'Invoice Number Series', 'Invoice No', 'CreditNote Number Series', 'Credit No', ''],
                colModel: [
                         { name: 'IdNumSeries', index: 'IdNumSeries', width: 60, sorttype: "string", hidden: true },
                         { name: 'Id_Settings', index: 'Id_Settings', width: 60, sorttype: "string", hidden: true },
                         { name: 'Description', index: 'Description', width: 190, sorttype: "string" },
                         { name: 'Inv_Prefix', index: 'Inv_Prefix', width: 160, sorttype: "string" },
                         { name: 'InvNoSeries', index: 'InvNoSeries', width: 160, sorttype: "string", hidden: true },
                         { name: 'Cre_Prefix', index: 'Cre_Prefix', width: 160, sorttype: "string" },
                         { name: 'CreNoSeries', index: 'CreNoSeries', width: 160, sorttype: "string", hidden: true },
                         { name: 'Id_Settings', index: 'Id_Settings', sortable: false, formatter: editSeries }
                ],
                multiselect: true,
                pager: jQuery('#pager1'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Invoice Number Series",
                async: false, //Very important,
                subgrid: false

            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/LoadInvNumSeriesGrd",
                data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdInvNumberSeries").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdInvNumberSeries").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdInvNumberSeries").jqGrid("hideCol", "subgrid");
        }
        function loadInvoiceSettings() {
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpDepartment.ClientID%>').val();
            if (deptId != "0") {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfInvoice.aspx/LoadInvSett",
                    data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                      
                        var valrdbLstTimeRnd;
                        var valrdbLstFlrRnd;
                        var valrdbLstRnd;
                        Result = Result.d[0];
                        $('#<%=txtValueTime.ClientID%>').val(Result.InvTimeRnd);
                        $('#<%=txtRoundTime.ClientID%>').val(Result.InvTimeRndPer);
                        $('#<%=txtRoundTime.ClientID%>').attr("disabled", "disabled");
                        $('#<%=txtRoundPrice.ClientID%>').val(Result.InvRndDec);
                        $('#<%=txtValuePrice.ClientID%>').val(Result.InvPrRndValPer);
                        $('#<%=txtValuePrice.ClientID%>').attr("disabled", "disabled");
                        $('#<%=txtExtVATCode.ClientID%>').val(Result.ExtVatCode);
                        $('#<%=txtAccountCode.ClientID%>').val(Result.AccountCode);
                        valrdbLstTimeRnd = Result.InvTimeRndUnit;
                        if (valrdbLstTimeRnd == "HR") {
                            var Value = "HR";
                            var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else if (valrdbLstTimeRnd == "Min") {
                            var Value = "Min";
                            var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else {
                            var Value = "Sec";
                            var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        valrdbLstFlrRnd = Result.InvTimeRndFn;
                        if (valrdbLstFlrRnd == "Flr") {
                            var Value = "Flr";
                            var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else if (valrdbLstFlrRnd == "Clg") {
                            var Value = "Clg";
                            var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else {
                            var Value = "Rnd";
                            var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        valrdbLstRnd = Result.InvPriceRndFn;
                        if (valrdbLstFlrRnd == "Flr") {
                            var Value = "Flr";
                            var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else if (valrdbLstFlrRnd == "Clg") {
                            var Value = "Clg";
                            var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else {
                            var Value = "Rnd";
                            var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }

                        if ($('#<%= rdbLstFlrRnd.ClientID%> input:radio')[2].checked == true) {

                            $('#<%=txtRoundTime.ClientID%>').removeAttr("disabled");
                        }
                        else {
                            $('#<%=txtRoundTime.ClientID%>').attr("disabled", "disabled");
                        }

                        if ($('#<%= rdbLstRnd.ClientID%> input:radio')[2].checked == true) {
                            $('#<%=txtValuePrice.ClientID%>').removeAttr("disabled");
                            //txtValuePrice
                        }
                        else {
                            $('#<%=txtValuePrice.ClientID%>').attr("disabled", "disabled");
                        }

                        $('#<%=drpKIDCustNumOrd.ClientID%>').val(Result.KidCustOrd);
                        $('#<%=drpKIDInvNumOrd.ClientID%>').val(Result.KidInvOrd);
                        $('#<%=drpKIDWONumOrd.ClientID%>').val(Result.KidWoOrd);
                        $('#<%=drpKIDFixNumOrd.ClientID%>').val(Result.KidFixedOrd);
                        $('#<%=txtKIDCustNumLen.ClientID%>').val(Result.KidCustNod);
                        $('#<%=txtKIDInvNumLen.ClientID%>').val(Result.KidInvNod);
                        $('#<%=txtKIDWONumLen.ClientID%>').val(Result.KidWoNod);
                        $('#<%=txtKIDFixNumText.ClientID%>').val(Result.KidFixedNumber);
                        $('#<%=txtKIDFixNumLen.ClientID%>').val(Result.KidFixedNumber.length);
                        if ($('#<%=drpKIDCustNumOrd.ClientID%>').find('option:selected').text() == "X") {
                            $('#<%=txtKIDCustNumLen.ClientID%>').attr("disabled", "disabled");
                        }
                        if ($('#<%=drpKIDInvNumOrd.ClientID%>').find('option:selected').text() == "X") {
                            $('#<%=txtKIDInvNumLen.ClientID%>').attr("disabled", "disabled");
                        }
                        if ($('#<%=drpKIDWONumOrd.ClientID%>').find('option:selected').text() == "X") {
                            $('#<%=txtKIDWONumLen.ClientID%>').attr("disabled", "disabled");
                        }
                        if ($('#<%=drpKIDFixNumOrd.ClientID%>').find('option:selected').text() == "X") {
                            $('#<%=txtKIDFixNumText.ClientID%>').attr("disabled", "disabled");
                        }
                        $('#<%=txtKIDFixNumLen.ClientID%>').attr("disabled", "disabled");
                        if (Result.FlgKidMod10 == true) {
                            var Value = "1";
                            var radio = $("[id*=rdbLstModulus] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        else {
                            var Value = "0";
                            var radio = $("[id*=rdbLstModulus] input[value=" + Value + "]");
                            radio.attr("checked", "checked");
                        }
                        if (Result.FlgInvFees == true) {
                            $("#<%=chkInvFee.ClientID%>").attr('checked', true);
                            $('#<%=txtInvFeeAmt.ClientID%>').removeAttr("disabled");
                            $('#<%=txtInvFeeAccCode.ClientID%>').removeAttr("disabled");
                            $('#<%=txtInvFeeAmt.ClientID%>').val(Result.InvFeesAmt);
                            $('#<%=txtInvFeeAccCode.ClientID%>').val(Result.InvFeesAccCode);
                        }
                        else {
                            $("#<%=chkInvFee.ClientID%>").attr('checked', false);
                            $('#<%=txtInvFeeAmt.ClientID%>').val('');
                            $('#<%=txtInvFeeAccCode.ClientID%>').val('');
                            $('#<%=txtInvFeeAmt.ClientID%>').attr("disabled", "disabled");
                            $('#<%=txtInvFeeAccCode.ClientID%>').attr("disabled", "disabled");
                        }

                        //assign invoiceFees
                    }
                });
            }
        }
        function loadInvoiceSettingsCopy() {
            var subId = $('#<%=drpCopySubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpCopyDepartment.ClientID%>').val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/LoadInvSett",
                data: "{'subId':'" + subId + "','deptId':'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    var valrdbLstTimeRnd;
                    var valrdbLstFlrRnd;
                    var valrdbLstRnd;
                    Result = Result.d[0];
                    $('#<%=txtValueTime.ClientID%>').val(Result.InvTimeRnd);
                    $('#<%=txtRoundTime.ClientID%>').val(Result.InvTimeRndPer);
                    $('#<%=txtRoundTime.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtRoundPrice.ClientID%>').val(Result.InvRndDec);
                    $('#<%=txtValuePrice.ClientID%>').val(Result.InvPrRndValPer);
                    $('#<%=txtValuePrice.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtExtVATCode.ClientID%>').val(Result.ExtVatCode);
                    $('#<%=txtAccountCode.ClientID%>').val(Result.AccountCode);
                    valrdbLstTimeRnd = Result.InvTimeRndUnit;
                    if (valrdbLstTimeRnd == "HR") {
                        var Value = "HR";
                        var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else if (valrdbLstTimeRnd == "Min") {
                        var Value = "Min";
                        var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else {
                        var Value = "Sec";
                        var radio = $("[id*=rdbLstTimeRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    valrdbLstFlrRnd = Result.InvTimeRndFn;
                    if (valrdbLstFlrRnd == "Flr") {
                        var Value = "Flr";
                        var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else if (valrdbLstFlrRnd == "Clg") {
                        var Value = "Clg";
                        var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else {
                        var Value = "Rnd";
                        var radio = $("[id*=rdbLstFlrRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    valrdbLstRnd = Result.InvPriceRndFn;
                    if (valrdbLstFlrRnd == "Flr") {
                        var Value = "Flr";
                        var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else if (valrdbLstFlrRnd == "Clg") {
                        var Value = "Clg";
                        var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else {
                        var Value = "Rnd";
                        var radio = $("[id*=rdbLstRnd] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    $('#<%=drpKIDCustNumOrd.ClientID%>').val(Result.KidCustOrd);
                    $('#<%=drpKIDInvNumOrd.ClientID%>').val(Result.KidInvOrd);
                    $('#<%=drpKIDWONumOrd.ClientID%>').val(Result.KidWoOrd);
                    $('#<%=drpKIDFixNumOrd.ClientID%>').val(Result.KidFixedOrd);
                    $('#<%=txtKIDCustNumLen.ClientID%>').val(Result.KidCustNod);
                    $('#<%=txtKIDInvNumLen.ClientID%>').val(Result.KidInvNod);
                    $('#<%=txtKIDWONumLen.ClientID%>').val(Result.KidWoNod);
                    $('#<%=txtKIDWONumLen.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDFixNumText.ClientID%>').val(Result.KidFixedNumber);
                    $('#<%=txtKIDFixNumText.ClientID%>').attr("disabled", "disabled");
                    $('#<%=txtKIDFixNumLen.ClientID%>').val(Result.KidFixedNumber.length);
                    if (Result.FlgKidMod10 == true) {
                        var Value = "1";
                        var radio = $("[id*=rdbLstModulus] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    else {
                        var Value = "0";
                        var radio = $("[id*=rdbLstModulus] input[value=" + Value + "]");
                        radio.attr("checked", "checked");
                    }
                    if (Result.FlgInvFees == true) {
                        $("#<%=chkInvFee.ClientID%>").attr('checked', true);
                        $('#<%=txtInvFeeAmt.ClientID%>').removeAttr("disabled");
                        $('#<%=txtInvFeeAccCode.ClientID%>').removeAttr("disabled");
                        $('#<%=txtInvFeeAmt.ClientID%>').val(Result.InvFeesAmt);
                        $('#<%=txtInvFeeAccCode.ClientID%>').val(Result.InvFeesAccCode);
                    }
                    else {
                        $("#<%=chkInvFee.ClientID%>").attr('checked', false);
                        $('#<%=txtInvFeeAmt.ClientID%>').val('');
                        $('#<%=txtInvFeeAccCode.ClientID%>').val('');
                        $('#<%=txtInvFeeAmt.ClientID%>').attr("disabled", "disabled");
                        $('#<%=txtInvFeeAccCode.ClientID%>').attr("disabled", "disabled");
                    }

                    //assign invoiceFees
                }
            });
        }
        function savePayType()
        {
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpDepartment.ClientID%>').val();
            var xml = $('#<%=hdnXml.ClientID%>').val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/SavePayType",
                data: "{'subId':'" + subId + "',deptId:'" + deptId + "',xml:'" + xml + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    data = data.d;
                    if (data == "SUCCESS") {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditInvSeries').hide();
                        jQuery("#dgdInvNumberSeries").jqGrid('clearGridData');
                        loadGrid();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }

                }
            });
        }
        function updPayType() {
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptId = $('#<%=drpDepartment.ClientID%>').val();
            var xml = $('#<%=hdnXml.ClientID%>').val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvoice.aspx/UpdatePayType",
                data: "{'subId':'" + subId + "',deptId:'" + deptId + "',xml:'" + xml + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    data = data.d;
                    if (data == "UPD") {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        $('#EditInvSeries').hide();
                        jQuery("#dgdInvNumberSeries").jqGrid('clearGridData');
                        loadGrid();
                    }
                    else
                    {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                }
            });
        }

        function resetInvSett()
        {
            loadInvoiceSettings();
        }
        function saveInvSett()
        {
            var validate = fnClientValidate();
            if (validate ==true)
            {
                var bool = KidSequenceValidate();
                if (bool == true) {
                    var StrIntXML = "";
                    var StrIntXMLs = "";
                    var rowData = $('#dgdInvNumberSeries').jqGrid('getGridParam', 'data');
                    for (var i = 0; i < rowData.length; i++) {
                        var payId = rowData[i].Id_Settings;
                        var invNoSer = rowData[i].InvNoSeries;
                        var creNoSer = rowData[i].CreNoSeries;
                        var idNumSer = rowData[i].IdNumSeries;
                        StrIntXML = '<INV ID_SETTINGS= "' + payId + '" INV_INVNOSERIES= "' + invNoSer + '" INV_CRENOSEREIES= "' + creNoSer + '"/>'
                        StrIntXMLs += StrIntXML;
                    }
                    StrIntXMLs = "<ROOT>" + StrIntXMLs + "</ROOT>";
                    $('#<%=hdnXml.ClientID%>').val(StrIntXMLs);
                    var chkAddNew = $('#<%=chkAddNew.ClientID%>').is(':checked');
                    var chkCopyConfig = $('#<%=chkCopyConf.ClientID%>').is(':checked');
                    if ((chkAddNew == false) && (chkCopyConfig == false)) {
                        var mode = "Edit";
                        UpdateConfig(mode);
                    }
                    else if ((chkAddNew == false) && (chkCopyConfig == true)) {
                        var mode = "Edit";
                        UpdateConfig(mode);
                    }
                    else if ((chkAddNew == true) && (chkCopyConfig == false)) {
                        var mode = "Add";
                        UpdateConfig(mode);
                    }

                    if (chkCopyConfig == true) {
                        if (($('#<%=drpCopyDepartment.ClientID%>').val() != $('#<%=drpDepartment.ClientID%>').val()) || ($('#<%=drpCopySubsidiary.ClientID%>').val() != $('#<%=drpSubsidiary.ClientID%>').val())) {
                            var mode = "Add";
                            UpdateConfig(mode);
                        }
                    }
                }
                else
                {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('Incorrect Kid Order Sequence Number'));
                    $('#<%=RTlblError.ClientID%>').removeClass();
                    $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                }
            }
            //UpdateConfig();
        }
        function KidSequenceValidate()
        {
            var blnIsValid = true;
            var intSeqMax = 0;
            intSeqMax = KIDSeqenceGetMax($('#<%=drpKIDCustNumOrd.ClientID%>'), intSeqMax);
            intSeqMax = KIDSeqenceGetMax($('#<%=drpKIDInvNumOrd.ClientID%>'), intSeqMax);
            intSeqMax = KIDSeqenceGetMax($('#<%=drpKIDWONumOrd.ClientID%>'), intSeqMax);
            intSeqMax = KIDSeqenceGetMax($('#<%=drpKIDFixNumOrd.ClientID%>'), intSeqMax);
            for (var i = 0; i < intSeqMax; i++) {
                blnIsValid = KIDSeqenceSearch(i)
            }
            return blnIsValid;
        }
        function KIDSeqenceGetMax(drp,seq)
        {
            var text = drp.find('option:selected').text();
            if (text != "")
            {
                if ((text > seq) && (text <= 4))
                {
                    seq = text;
                }
                else
                {
                    seq = 0;
                }
            }
            return seq;
        }
        function KIDSeqenceSearch(seq)
        {
            var occurence = 0;
            if (seq == 0)
            {
                return true;
            }
            else
            {
                if ($('#<%=drpKIDCustNumOrd.ClientID%>').find('option:selected').text() == seq)
                {
                    occurence = occurence + 1;
                }
                if ($('#<%=drpKIDInvNumOrd.ClientID%>').find('option:selected').text() == seq) {
                    occurence = occurence + 1;
                }
                if ($('#<%=drpKIDWONumOrd.ClientID%>').find('option:selected').text() == seq) {
                    occurence = occurence + 1;
                }
                if ($('#<%=drpKIDFixNumOrd.ClientID%>').find('option:selected').text == seq) {
                    occurence = occurence + 1;
                }
                if (occurence == 1)
                {
                    return true
                }
                else
                {
                    return false;
                }
            }
        }
     </script>

  <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblRoleHeader" runat="server" Text="Invoice Settings"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" /> 
     <asp:HiddenField id="hdnXml" runat="server" /> 
     <asp:HiddenField id="hdnCntPT" runat="server" /> 
      <asp:HiddenField id="hdnPayId" runat="server" /> 
  

</div>
     <div id="divCfInvDetails" class="ui raised segment signup inactive">
           <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                 <div class="field" style="padding:0.55em;height:40px">
                <asp:CheckBox ID="chkAddNew" runat="server" />
            <asp:Label ID="lblAddNew" runat="server" Text="Add New" Width="300px" ></asp:Label>
                <asp:CheckBox ID="chkCopyConf" runat="server" />
            <asp:Label ID="lblCopy" runat="server" Text="Copy Configuration" Width="300px"></asp:Label>
            </div>
         </div>

         <div style="padding:0.5em"></div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblCopySubsidiary" runat="server" Text="Copy Subsidiary" Width="300px"></asp:Label>
              <asp:DropDownList ID="drpCopySubsidiary" runat="server" Width="160px"></asp:DropDownList>                   
            <asp:Label ID="lblCopyDepartment" runat="server" Text="Copy Department" Width="300px"></asp:Label>
             <asp:DropDownList ID="drpCopyDepartment" runat="server" Width="160px"></asp:DropDownList>
         </div>
       </div>
          <div style="padding:0.5em"></div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblSubsidiary" runat="server" Text="Subsidiary" Width="300px"></asp:Label>
              <asp:DropDownList ID="drpSubsidiary" runat="server" Width="160px"></asp:DropDownList>                   
             <asp:Label ID="lblDepartment" runat="server" Text="Department" Width="300px" ></asp:Label>
             <asp:DropDownList ID="drpDepartment" runat="server" Width="160px"></asp:DropDownList>
         </div>
        </div>
         <div style="padding:0.5em"></div>
         <div>
             <table id="dgdInvNumberSeries" title="User Details"></table>
                <div id="pager1"></div>
         </div>
         <div id="EditInvSeries">
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblPayType" runat="server" Text="Payment Type" Width="100px" ></asp:Label>
                <asp:DropDownList ID="drpPayType" runat="server" Width="160px"></asp:DropDownList>
                 <asp:TextBox ID="txtPayType" runat="server" Width="160px"></asp:TextBox> 

             </div>
            </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblInvSeries" runat="server" Text="InvNoSeries" Width="100px" ></asp:Label>
               <asp:DropDownList ID="drpInvNoSeries" runat="server" Width="160px"></asp:DropDownList> 
            </div>
            </div>
          <div class="two fields lbl">
             <div class="field" style="padding:0.55em;width:300px">
                <asp:Label ID="lblCreSeries" runat="server" Text="CreNoseries" Width="100px" ></asp:Label>
               <asp:DropDownList ID="drpCreNoSeries" runat="server" Width="160px"></asp:DropDownList> 
            </div>
            </div>
          <div class="two fields lbl">
              <div style="text-align:center">
                <input id="btnSavePayment" runat="server" type="button" value="Save" class="ui button" onclick="savePayType()" />
                <input id="btnupdate" runat="server" type="button" value="Update" class="ui button" onclick="updPayType()" />
                 <input id="btnCancelPayment" runat="server" type="button" value="Cancel" class="ui button" />
        </div>
            </div>
      </div>
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Rounding Rules For Time</a>  
         </div>

         
     <div class="ui page grid" style="padding-left:0%;padding-right:0%;margin-top:10px">
         <div class="two column row">
            <div class="column" style="padding-left:0em;width:40%">
             <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
            <asp:RadioButtonList ID="rdbLstTimeRnd"  Width="300px" Height ="25px"  runat="server"  RepeatDirection="Horizontal">
                                        <asp:ListItem Value="HR">Hours</asp:ListItem>
                                        <asp:ListItem Value="Min">Minutes</asp:ListItem>
                                        <asp:ListItem Value="Sec">Seconds</asp:ListItem>
               </asp:RadioButtonList>
                </div>
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                     <div class="field">
                     <asp:Label ID="lblrndtime" runat="server" Text="Rounding Time" Width="300px"></asp:Label>
                    <asp:TextBox ID="txtValueTime" runat="server"></asp:TextBox>
                  </div>
               </div>
            </div>
            <div class="column" style="width:50%">
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                    <asp:RadioButtonList ID="rdbLstFlrRnd"   Width="300px" Height ="25px"  runat="server"  RepeatDirection="Horizontal">
                                        <asp:ListItem Value="Flr">Floor</asp:ListItem>
                                        <asp:ListItem Value="Clg">Ceiling</asp:ListItem>
                                         <asp:ListItem Value="Rnd">Round</asp:ListItem>
                  </asp:RadioButtonList>
            </div>
           
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                     <div class="field">
                     <asp:Label ID="LblRndtimeper" runat="server" Text="Rounding Time %" Width="300px"></asp:Label>
                    <asp:TextBox ID="txtRoundTime" runat="server"></asp:TextBox>
                  </div>
               </div>
            </div>
        </div>
     </div>
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A1" runat="server" class="active item">Rounding Rules For Price</a>  
         </div>                         
        <div class="ui page grid" style="padding-left:0%;padding-right:0%;margin-top:10px">
         <div class="two column row">
            <div class="column" style="padding-left:0em;width:40%">
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                       <asp:Label ID="Lblrndprice" runat="server"  Text="Rounding Price" Width="300px"></asp:Label>
                        <asp:TextBox ID="txtRoundPrice" runat="server" ></asp:TextBox>
                  </div>
                 <div style="padding:0.5em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                     <asp:Label ID="lblrndpriceper" runat="server"  Text="Rounding Price %"  Width="300px"></asp:Label>
                     <asp:TextBox ID="txtValuePrice" runat="server" MaxLength="6" ></asp:TextBox>
                </div>
             </div>
             <div class="column" style="width:50%">
                  <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                       <asp:RadioButtonList ID="rdbLstRnd" runat="server"  RepeatDirection="Horizontal" Width="300px" Height ="25px">
                                                <asp:ListItem Value="Flr">Floor</asp:ListItem>
                                                <asp:ListItem Value="Clg">Ceiling</asp:ListItem>
                                                <asp:ListItem Value="Rnd">Round</asp:ListItem>
                                            </asp:RadioButtonList>
                  </div>
                  <div style="padding:0.5em"></div>
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                      <asp:Label ID="lblVATCode" runat="server"  Text="External VAT Code" Width="124px"></asp:Label>:
                      <asp:TextBox ID="txtExtVATCode" runat="server"  MaxLength="1" Width="25px"></asp:TextBox>
                      <asp:Label ID="lblExtAccCode" runat="server" Text="Account Code" Width="104px"></asp:Label>:
                      <asp:TextBox ID="txtAccountCode" runat="server"  MaxLength="20" Width="120px"></asp:TextBox>
                </div>
             </div>
           </div>
          </div> 
          <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A2" runat="server" class="active item">KID Settings</a>  
         </div> 
         <div class="ui page grid" style="padding-left:0%;padding-right:0%;margin-top:10px">
         <div class="three column row">
            <div class="column" style="padding-left:0em;width:30%">
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                      <asp:Label ID="lblOrder" runat="server" Text="Order" />
                 </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                    <asp:DropDownList ID="drpKIDCustNumOrd" runat="server" Width="79px"  CssClass="drpdwm"/><span class="mand">*</span>
                </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                    <asp:DropDownList ID="drpKIDInvNumOrd" runat="server" Width="79px"  CssClass="drpdwm"/><span class="mand">*</span>
                </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                    <asp:DropDownList ID="drpKIDWONumOrd" runat="server" Width="79px"  CssClass="drpdwm"/><span class="mand">*</span>
                </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                    <asp:DropDownList ID="drpKIDFixNumOrd" runat="server" Width="79px"  CssClass="drpdwm"/><span class="mand">*</span>
                </div>
                 <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                      <asp:RadioButtonList ID="rdbLstModulus" runat="server"  RepeatDirection="Horizontal" Width="300px" Height="25px">
                        <asp:ListItem Value="1">10's Modulus</asp:ListItem>
                        <asp:ListItem Value="0">11's Modulus</asp:ListItem>
                      </asp:RadioButtonList>
                </div>
            </div>
            <div class="column" style="padding-left:0em;width:30%">
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                  <asp:Label ID="lblDetails" runat="server" Text="Details" />
                </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                   <asp:Label ID="lblKIDCustNum" runat="server" Text="Customer Number"></asp:Label>
                </div>
                <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                   <asp:Label ID="lblKIDInvNum" runat="server" Text="Invoice Number"></asp:Label>
                </div>
                 <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                   <asp:Label ID="lblKIDWONum" runat="server" Text="Work Order Number"></asp:Label>
                </div>
                 <div style="padding:0.2em"></div>
                <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                   <asp:Label ID="lblKIDFixNum" runat="server" Text="Fixed Number"></asp:Label>
                    <asp:TextBox ID="txtKIDFixNumText"  runat="server" Width="50px" CssClass="inp" MaxLength="24"></asp:TextBox><span class="mand">*</span>
                </div>
            </div>
         <div class="column" style="padding-left:0em;width:30%">
             <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                <asp:Label ID="lblLength" runat="server" Text="Length" />
            </div>
              <div style="padding:0.2em"></div>
              <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                <asp:TextBox ID="txtKIDCustNumLen" runat="server" Width="30px" CssClass="inp" MaxLength="2"></asp:TextBox><span class="mand">*</span>
            </div>
              <div style="padding:0.2em"></div>
             <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                <asp:TextBox ID="txtKIDInvNumLen" runat="server" Width="30px" CssClass="inp" MaxLength="2"></asp:TextBox><span class="mand">*</span>
            </div>
              <div style="padding:0.2em"></div>
              <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                <asp:TextBox ID="txtKIDWONumLen" runat="server" Width="30px" CssClass="inp" MaxLength="2"></asp:TextBox><span class="mand">*</span>
            </div>
              <div style="padding:0.2em"></div>
              <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
                 <asp:TextBox ID="txtKIDFixNumLen" runat="server" Width="30px" CssClass="inp" MaxLength="2"></asp:TextBox><span class="mand">*</span>
            </div>
         </div>
         
         </div> 
         </div> 
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A3" runat="server" class="active item">Invoice Fees Settings</a>  
         </div> 
         <div class="ui page grid" style="padding-left:0%;padding-right:0%;margin-top:10px">
         <div class="three column row">
            <div class="column" style="padding-left:0em;width:30%">
                <asp:CheckBox ID="chkInvFee" runat="server" Width="24px" />
               <asp:Label ID="lblInvFee" runat="server" Text="Invoice Fee"></asp:Label>
            </div>
             <div class="column" style="padding-left:0em;width:30%">
                  <asp:Label ID="lblInvFeeAmt" runat="server" Text="Invoice Fee Amount" />
                <asp:TextBox ID="txtInvFeeAmt" CssClass="inp" runat="server"  MaxLength="10"/>
                 
            </div>
             <div class="column" style="padding-left:0em;width:30%">
                  <asp:Label ID="lblInvFeeAccCode" runat="server" Text="Invoice Fee Account Code" />
                 <asp:TextBox ID="txtInvFeeAccCode" CssClass="inp" runat="server" MaxLength="10"/>
            </div>
            </div>
        </div>
          <div style="text-align:center">
                    <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" onclick="saveInvSett()"  />
                    <input id="btnReset" runat="server" class="ui button" value="Reset" type="button" style="background-color: #E0E0E0"  onclick="resetInvSett()"/>
           </div> 
   </div>

</asp:Content>