<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfLA.aspx.vb" Inherits="CARS.frmCfLA" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">

         function fnClientValidate() {
             
             if ($('#<%=cbDisplayVchrType.ClientID%>').is(':checked')) {

                 if (d$('#<%=cbDisplayVchrType.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('0102', '', ''), '');
                     alert(msg);
                     $('#<%=cbDisplayVchrType.ClientID%>').focus();
                     return false;
                 }
             }

             if ($('#<%=cbAddText.ClientID%>').is(':checked')) {

                 if ((!gfi_CheckEmpty($('#<%=txtAddText.ClientID%>'), $('#<%=lblAddText.ClientID%>')[0].innerHTML))) {
                     return false;
                 }
             }
             if ($('#<%=cbAdditionalText.ClientID%>').is(':checked')) {

                 if ((!gfi_CheckEmpty($('#<%=txtAdditionalText.ClientID%>'), $('#<%=lblAdditionalText.ClientID%>')[0].innerHTML))) {
                     return false;
                 }
             }
             if ($('#<%=cbCustomerText.ClientID%>').is(':checked')) {

                 if ((!gfi_CheckEmpty($('#<%=txtCustomerText.ClientID%>'), $('#<%=lblCustomerText.ClientID%>')[0].innerHTML))) {
                     return false;
                 }
             }

             if ($('#<%=cbSeqNos.ClientID%>').is(':checked')) {

                 if (!(gfi_ValidateNumber($('#<%=txtTransactionNo.ClientID%>'), $('#<%=lblTransactionNo.ClientID%>')[0].innerHTML))) {

                     return false;
                 }
                 if (!(gfi_CheckEmpty($('#<%=txtTransactionNo.ClientID%>'), $('#<%=lblTransactionNo.ClientID%>')[0].innerHTML))) {
                     return false;
                 }
             }

             if ($('#<%=cbCustseqNo.ClientID%>').is(':checked')) {
                 if (!(gfi_ValidateNumber($('#<%=txtSeqNo.ClientID%>'), $('#<%=lblSeqNo.ClientID%>')[0].innerHTML))) {

                     return false;
                 }
                 if (!(gfi_CheckEmpty($('#<%=txtSeqNo.ClientID%>'), $('#<%=lblSeqNo.ClientID%>')[0].innerHTML))) {
                     return false;
                 }
             }

             if (!(gfi_CheckEmpty($('#<%=txtPrefix.ClientID%>'), '0456'))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtPrefix_ExpCustInfo.ClientID%>'), '0456'))) {
                 return false;
             }


             if ($('#<%=rdbExportMode.ClientID%>').find(':checked').val() == "A") {
                 if ($('#<%=rbtnDaily.ClientID%>').is(':checked')) {
                     if (!(gfi_CheckEmpty($('#<%=txtDailyEvery.ClientID%>'), '0532'))) {
                         return false;
                     }

                     if ($('#<%=txtDailyEvery.ClientID%>').val() == "0") {
                         msg = GetMultiMessage('1779', '', '')
                         alert(msg)
                         $('#<%=txtDailyEvery.ClientID%>').focus();
                         return false
                     }

                     if (!(gfi_ValidateNumber($('#<%=txtDailyEvery.ClientID%>'), '0532'))) {
                         return false;
                     }

                     if ($('#<%=drpdailyHM.ClientID%>')[0].selectedIndex == 0 && $('#<%=txtDailyEvery.ClientID%>').val() > 24) {
                         msg = GetMultiMessage('1775', '', '')
                         alert(msg)
                         $('#<%=txtDailyEvery.ClientID%>').focus();
                         return false
                     }

                     if ($('#<%=drpdailyHM.ClientID%>')[0].selectedIndex == 1 && $('#<%=txtDailyEvery.ClientID%>').val() > 60) {
                         msg = GetMultiMessage('1776', '', '')
                         alert(msg)
                         $('#<%=txtDailyEvery.ClientID%>').focus();
                         return false
                     }

                     if ($('#<%=rdbExportMode.ClientID%>').find(':checked').val() == "A") {
                        if (!(gfi_CheckEmpty($('#<%=txtDailyStTime.ClientID%>'), '0532'))) {
                            return false;
                        }

                        Validatetime($('#<%=txtDailyStTime.ClientID%>'));
                        if (!(IsValidTime($('#<%=txtDailyStTime.ClientID%>').val()))) {
                            $('#<%=txtDailyStTime.ClientID%>').val("");
                            $('#<%=txtDailyStTime.ClientID%>').focus();
                            return false;
                        }                         
                     }                     

                     if ($('#<%=rdbExportMode.ClientID%>').find(':checked').val() == "A") {
                         if (!(gfi_CheckEmpty($('#<%=txtDailyEndTime.ClientID%>'), '0532'))) {
                             return false;
                         }

                         Validatetime($('#<%=txtDailyEndTime.ClientID%>'));
                         if (!(IsValidTime($('#<%=txtDailyEndTime.ClientID%>').val()))) {
                             $('#<%=txtDailyEndTime.ClientID%>').val("");
                             $('#<%=txtDailyEndTime.ClientID%>').focus();
                             return false;
                         }
                     }
                 }
             }             

             if ($('#<%=rdbExportMode.ClientID%>').find(':checked').val() == "A") {
                if ($('#<%=rbtnWeekly.ClientID%>').is(':checked')) {                 
                    if (!(gfi_CheckEmpty($('#<%=txtWeeklyTime.ClientID%>'), '0532'))) {
                         return false;
                     }

                    if (!(IsValidTime($('#<%=txtWeeklyTime.ClientID%>').val()))) {
                        $('#<%=txtWeeklyTime.ClientID%>').val("");
                        $('#<%=txtWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             }

             if ($('#<%=rdbExportMode.ClientID%>').find(':checked').val() == "A") {
                 if ($('#<%=rbtnMonthly.ClientID%>').is(':checked')) {
                     if (!(gfi_CheckEmpty($('#<%=txtMonthlyTime.ClientID%>'), '0532'))) {
                         return false;
                     }

                     if (!(IsValidTime($('#<%=txtMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtMonthlyTime.ClientID%>').val("");
                         $('#<%=txtMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             }

             var intArr = new Array();
             intArr[0] = $('#<%=ddlCustID.ClientID%>')[0].selectedIndex;
             intArr[1] = $('#<%=ddlOrderNo.ClientID%>')[0].selectedIndex;
             intArr[2] = $('#<%=ddlRegNo.ClientID%>')[0].selectedIndex;
             intArr[3] = $('#<%=ddlVinNo.ClientID%>')[0].selectedIndex;
             intArr[4] = $('#<%=ddlCustName.ClientID%>')[0].selectedIndex;

             for (i = 0; i < intArr.length; i++) {
                 if (intArr[i] > 0) {
                     for (j = 0; j < intArr.length; j++) {
                         if (i != j) {
                             if (intArr[j] == intArr[i]) {
                                 alert(GetMultiMessage('ORD', '', ''));
                                 $('#<%=ddlCustID.ClientID%>').focus();
                                 return false;
                             }
                         }
                     }
                 }
             }

             if (!(gfi_ValidateNumber($('#<%=txtVinNumLen.ClientID%>'), $('#<%=lblVinNo.ClientID%>')[0].innerHTML))) {
                 return false;
             }

             if (!gfi_ValidateAlphaNumeric(document.getElementById("<%=txtFixText.ClientID %>"), '')) {
                 $('#<%=txtFixText.ClientID%>').focus();
                 return false;
             }

             if ($('#<%=cbExpValid.ClientID%>').is(':checked')) {
                 if (!(gfi_CheckEmpty($('#<%=txtErrInvName.ClientID%>'), 'ERRINVNAME'))) {
                     return false;
                 }
             }
             if (document.getElementById("<%=txtErrInvName.ClientID %>").value != "") {
                 var name = document.getElementById("<%=txtErrInvName.ClientID %>").value
                 var regexp = '^[a-zA-Z0-9_]+$';
                 if (!name.match(regexp)) {
                     var msg = GetMultiMessage('ALPHANUMERIC', '', '')
                     alert(msg);
                     document.getElementById("<%=txtErrInvName.ClientID %>").focus();
                     return false;
                 }
             }
             return true;
         }


         $(document).ready(function () {
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             loadCustInfoSettings();
             loadConfiguration();
             
             function loadCustInfoSettings() {

                 var mydata;
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfLA.aspx/LoadCustInfoSett",
                     data: "{}",
                     dataType: "json",
                     async: false,//Very important
                     success: function (data) {
                         data = data.d;
                         $('#<%=ddlCustID.ClientID%>').empty();
                         $.each(data, function (key, value) {
                             $('#<%=ddlCustID.ClientID%>').append($("<option></option>").val(value.Cust_Desc).html(value.Cust_Series));
                         });

                         $('#<%=ddlOrderNo.ClientID%>').empty();
                         $.each(data, function (key, value) {
                             $('#<%=ddlOrderNo.ClientID%>').append($("<option></option>").val(value.Cust_Desc).html(value.Cust_Series));
                         });

                         $('#<%=ddlRegNo.ClientID%>').empty();
                         $.each(data, function (key, value) {
                             $('#<%=ddlRegNo.ClientID%>').append($("<option></option>").val(value.Cust_Desc).html(value.Cust_Series));
                         });

                         $('#<%=ddlVinNo.ClientID%>').empty();
                         $.each(data, function (key, value) {
                             $('#<%=ddlVinNo.ClientID%>').append($("<option></option>").val(value.Cust_Desc).html(value.Cust_Series));
                         });

                         $('#<%=ddlCustName.ClientID%>').empty();
                         $.each(data, function (key, value) {
                             $('#<%=ddlCustName.ClientID%>').append($("<option></option>").val(value.Cust_Desc).html(value.Cust_Series));
                         });

                     }
                 });
             }             

             $(document).on('click', '#<%=rbtnDaily.ClientID%>', function () {
                 fnChangeMode();
             });
             $(document).on('click', '#<%=rbtnWeekly.ClientID%>', function () {
                 fnChangeMode();
             });
             $(document).on('click', '#<%=rbtnMonthly.ClientID%>', function () {
                 fnChangeMode();
             });

             $(document).on('click', '#<%=cbSeqNos.ClientID%>', function () {
                 if ($('#<%=cbSeqNos.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtTransactionNo.ClientID%>').disabled = false;
                     document.getElementById('<%=txtTransactionNo.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtTransactionNo.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbCustseqNo.ClientID%>', function () {
                 if ($('#<%=cbCustseqNo.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtSeqNo.ClientID%>').disabled = false;
                     document.getElementById('<%=txtSeqNo.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtSeqNo.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbAddText.ClientID%>', function () {
                 if ($('#<%=cbAddText.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtAddText.ClientID%>').disabled = false;
                     document.getElementById('<%=txtAddText.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtAddText.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbAdditionalText.ClientID%>', function () {
                 if ($('#<%=cbAdditionalText.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtAdditionalText.ClientID%>').disabled = false;
                     document.getElementById('<%=txtAdditionalText.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtAdditionalText.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbCustomerText.ClientID%>', function () {
                 if ($('#<%=cbCustomerText.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtCustomerText.ClientID%>').disabled = false;
                     document.getElementById('<%=txtCustomerText.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtCustomerText.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbDisplayVchrType.ClientID%>', function () {
                 if ($('#<%=cbDisplayVchrType.ClientID%>').is(':checked')) {
                     document.getElementById('<%=drpDisplayVchrType.ClientID%>').disabled = false;
                     document.getElementById('<%=drpDisplayVchrType.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=drpDisplayVchrType.ClientID%>').disabled = true;
                 }
             });

             $(document).on('click', '#<%=cbExpValid.ClientID%>', function () {
                 if ($('#<%=cbExpValid.ClientID%>').is(':checked')) {
                     document.getElementById('<%=txtErrInvName.ClientID%>').disabled = false;
                     document.getElementById('<%=txtErrInvName.ClientID%>').focus();
                 } else {
                     document.getElementById('<%=txtErrInvName.ClientID%>').disabled = true;
                 }
             });

             
             function fnChangeMode() {
                 if (document.getElementById('<%=rbtnDaily.ClientID%>').checked == true) {
                     enableDisableDaily(false)
                     enableDisableWeek(true)
                     enableDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnWeekly.ClientID%>').checked == true) {
                     enableDisableDaily(true)
                     enableDisableWeek(false)
                     enableDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnMonthly.ClientID%>').checked == true) {
                     enableDisableDaily(true)
                     enableDisableWeek(true)
                     enableDisableMonth(false)
                 }
             }

             $('#<%=txtDailyStTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtDailyStTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtDailyStTime.ClientID%>'));
                 }
             });

             $('#<%=txtDailyEndTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtDailyEndTime.ClientID%>'));
                 }

                 if ($('#<%=txtDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtDailyEndTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtDailyEndTime.ClientID%>').val()))) {
                         $('#<%=txtDailyEndTime.ClientID%>').val("");
                         $('#<%=txtDailyEndTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtWeeklyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtWeeklyTime.ClientID%>'));
                 }

                 if ($('#<%=txtWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtWeeklyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtWeeklyTime.ClientID%>').val()))) {
                         $('#<%=txtWeeklyTime.ClientID%>').val("");
                         $('#<%=txtWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtMonthlyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtMonthlyTime.ClientID%>'));
                 }

                 if ($('#<%=txtMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtMonthlyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtMonthlyTime.ClientID%>').val("");
                         $('#<%=txtMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

            
         });  //end of ready

         function loadConfiguration() {

             var mydata;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfLA.aspx/LoadConfiguration",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         $('#<%=txtInvoiceJournal.ClientID%>').val(data.d[0][0].Path_Export_InvJournal);
                         $('#<%=txtInvJournalCustInfo.ClientID%>').val(data.d[0][0].Path_Export_CustInfo);
                         $('#<%=txtCustomerInfo.ClientID%>').val(data.d[0][0].Path_Import_CustInfo);
                         $('#<%=txtCustomerBalance.ClientID%>').val(data.d[0][0].Path_Import_CustBal);
                         $('#<%=txtPrefix.ClientID%>').val(data.d[0][0].PrefixFileName_Export_InvJournal);
                         if (data.d[0][0].SuffixFileName_Export_InvJournal == "") {
                             $('#<%=ddlSuffix.ClientID%>')[0][0].selectedIndex = 0;
                         } else {
                             $('#<%=ddlSuffix.ClientID%> option:contains("' + data.d[0][0].SuffixFileName_Export_InvJournal + '")').attr('selected', 'selected');
                         }

                         $('#<%=txtPrefix_ExpCustInfo.ClientID%>').val(data.d[0][0].PrefixFileName_Export_CustInfo);
                         if (data.d[0][0].SuffixFileName_Export_CustInfo == "") {
                             $('#<%=ddlSuffixCustInfo.ClientID%>')[0].selectedIndex = 0;
                         } else {
                             $('#<%=ddlSuffixCustInfo.ClientID%> option:contains("' + data.d[0][0].SuffixFileName_Export_CustInfo + '")').attr('selected', 'selected');
                         }

                         $('#<%=txtTransactionNo.ClientID%>').val(data.d[0][0].Exp_InvJournal_Series);
                         $('#<%=txtSeqNo.ClientID%>').val(data.d[0][0].Exp_Cust_Series);

                         if (data.d[0][0].Flg_Export_UseInvoiceNum == "False") {
                             $("#<%=cbUseInvNoForSort.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbUseInvNoForSort.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseCreditnote == "False") {
                             $("#<%=cbUseCreditNote.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbUseCreditNote.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseBlankSp == "False") {
                             $("#<%=cbUseBlankSp.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbUseBlankSp.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseCombLines == "False") {
                             $("#<%=cbCombinelines.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbCombinelines.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseAddDate == "False") {
                             $("#<%=cbAddDate.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbAddDate.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseSplit == "False") {
                             $("#<%=cbSplitSubsidiary.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbSplitSubsidiary.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_RemCost == "False") {
                             $("#<%=cbRemCost.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbRemCost.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_UseAddText == "False") {
                             $("#<%=cbAddText.ClientID%>").attr('checked', false);
                             document.getElementById('<%=txtAddText.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbAddText.ClientID%>").attr('checked', true);
                             document.getElementById('<%=txtAddText.ClientID%>').disabled = false;
                         }

                         if (data.d[0][0].Flg_Export_UseAdditionalText == "False") {
                             $("#<%=cbAdditionalText.ClientID%>").attr('checked', false);
                             document.getElementById('<%=txtAdditionalText.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbAdditionalText.ClientID%>").attr('checked', true);
                             document.getElementById('<%=txtAdditionalText.ClientID%>').disabled = false;
                         }

                         $('#<%=txtAddText.ClientID%>').val(data.d[0][0].Export_AddText);
                         $('#<%=txtAdditionalText.ClientID%>').val(data.d[0][0].Export_AdditionalText);
                         $('#<%=txtCustomerText.ClientID%>').val(data.d[0][0].Export_CustomerText);

                         if (data.d[0][0].Flg_Export_UseCustomerText == "False") {
                             $("#<%=cbCustomerText.ClientID%>").attr('checked', false);
                             document.getElementById('<%=txtCustomerText.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbCustomerText.ClientID%>").attr('checked', true);
                             document.getElementById('<%=txtCustomerText.ClientID%>').disabled = false;
                         }

                         if (data.d[0][0].Flg_Export_VocherType == "False") {
                             $("#<%=cbDisplayVchrType.ClientID%>").attr('checked', false);
                             document.getElementById('<%=drpDisplayVchrType.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbDisplayVchrType.ClientID%>").attr('checked', true);
                             document.getElementById('<%=drpDisplayVchrType.ClientID%>').disabled = false;
                         }

                         if (data.d[0][0].Export_VocherType == "") {
                             $('#<%=drpDisplayVchrType.ClientID%>')[0].selectedIndex = 0;
                         } else {
                             $('#<%=drpDisplayVchrType.ClientID%> option:contains("' + data.d[0][0].Export_VocherType + '")').attr('selected', 'selected');
                         }

                         if (data.d[0][0].Flg_Display_AllInvNum == "False") {
                             $("#<%=cbDisplayInvNum.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbDisplayInvNum.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_Valid == "False") {
                             $("#<%=cbExpValid.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbExpValid.ClientID%>").attr('checked', true);
                         }

                         $('#<%=txtFPAccCode.ClientID%>').val(data.d[0][0].FP_Acc_Code);
                         $('#<%=txtErrInvName.ClientID%>').val(data.d[0][0].ErrInvoicesName);

                         if (data.d[0][0].Flg_Use_Bill_Addr_Exp == "False") {
                             $("#<%=cbUseBillAddr.ClientID%>").attr('checked', false);
                         } else {
                             $("#<%=cbUseBillAddr.ClientID%>").attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_InvJournal_SeqNos == "False") {
                             $("#<%=cbSeqNos.ClientID%>").attr('checked', false);
                             document.getElementById('<%=txtTransactionNo.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbSeqNos.ClientID%>").attr('checked', true);
                             document.getElementById('<%=txtTransactionNo.ClientID%>').disabled = false;
                         }

                         if (data.d[0][0].Flg_Export_Cust_SeqNos == "False") {
                             $("#<%=cbCustseqNo.ClientID%>").attr('checked', false);
                             document.getElementById('<%=txtSeqNo.ClientID%>').disabled = true;
                         } else {
                             $("#<%=cbCustseqNo.ClientID%>").attr('checked', true);
                             document.getElementById('<%=txtSeqNo.ClientID%>').disabled = false;
                         }

                         $('#<%=txtErrAccCode.ClientID%>').val(data.d[0][0].Error_Acc_Code);

                         if (data.d[0][0].Sch_Basis == "D") {
                             enableDisableDaily(false);
                             enableDisableWeek(true);
                             enableDisableMonth(true);

                             $('#<%=rbtnDaily.ClientID%>').attr('checked', true);
                             $('#<%=txtDailyEvery.ClientID%>').val(data.d[0][0].Sch_Daily_Interval_mins);
                             $('#<%=txtDailyStTime.ClientID%>').val(data.d[0][0].Sch_Daily_STime);
                             $('#<%=txtDailyEndTime.ClientID%>').val(data.d[0][0].Sch_Daily_ETime);
                             $('#<%=drpdailyHM.ClientID%> option:contains("' + data.d[0][0].Sch_TimeFormat + '")').attr('selected', 'selected');
                         } else if (data.d[0][0].Sch_Basis == "M") {
                             enableDisableDaily(true);
                             enableDisableWeek(true);
                             enableDisableMonth(false);
                             $('#<%=rbtnMonthly.ClientID%>').attr('checked', true);
                             $('#<%=txtMonthlyTime.ClientID%>').val(data.d[0][0].Sch_Month_Time);
                             //$('#<%=ddlMonthly.ClientID%>').val(data.d[0][0].Sch_Month_Day);
                             $('#<%=ddlMonthly.ClientID%>')[0].selectedIndex = data.d[0][0].Sch_Month_Day;

                         } else if (data.d[0][0].Sch_Basis == "W") {
                             enableDisableDaily(true);
                             enableDisableWeek(false);
                             enableDisableMonth(true);
                             $('#<%=rbtnWeekly.ClientID%>').attr('checked', true);
                             // $('#<%=ddlWeeklyEvery.ClientID%>').val(data.d[0][0].Sch_Week_Day);
                             $('#<%=ddlWeeklyEvery.ClientID%>')[0].selectedIndex = data.d[0][0].Sch_Week_Day;
                             $('#<%=txtWeeklyTime.ClientID%>').val(data.d[0][0].Sch_Week_Time);
                         }

                         if (data.d[0][0].Flg_Grouping == "C") {
                             $('#<%=rdbGrouping.ClientID%> :radio[value="C"]').attr('checked', true);
                         }
                         else {
                             $('#<%=rdbGrouping.ClientID%> :radio[value="I"]').attr('checked', true);
                         }

                         if (data.d[0][0].Flg_ExportMode == "M") {
                             $('#<%=rdbExportMode.ClientID%> :radio[value="M"]').attr('checked', true);
                         }
                         else {
                             $('#<%=rdbExportMode.ClientID%> :radio[value="A"]').attr('checked', true);
                         }

                         if (data.d[0][0].Flg_Export_AllowMulMonths == "True") {
                             $('#<%=rdbInvExp.ClientID%> :radio[value="M"]').attr('checked', true);
                         }
                         else if (data.d[0][0].Flg_Export_EachInvoice == "True") {
                             $('#<%=rdbInvExp.ClientID%> :radio[value="E"]').attr('checked', true);
                         }

                         $('#<%=ddlCustID.ClientID%>').val(data.d[0][0].Customer_ID);
                         $('#<%=ddlOrderNo.ClientID%>').val(data.d[0][0].Cust_Ord_No);
                         $('#<%=ddlRegNo.ClientID%>').val(data.d[0][0].Cust_Reg_No);
                         $('#<%=ddlVinNo.ClientID%>').val(data.d[0][0].Cust_Vin_No);
                         $('#<%=ddlCustName.ClientID%>').val(data.d[0][0].Customer_Name);
                         $('#<%=txtVinNumLen.ClientID%>').val(data.d[0][0].Cust_Vin_No_Len);
                         $('#<%=txtFixText.ClientID%>').val(data.d[0][0].Cust_Fixed_Text);

                         loadExpTypeForInvJrnl(data.d[1]);
                         loadExpTypeForCustInfo(data.d[2]);

                         if (data.d[0][0].Invoice_Journal_Temp == "") {
                             $('#<%=ddlExpTypeName.ClientID%>')[0].selectedIndex = 0;
                         } else {
                             $('#<%=ddlExpTypeName.ClientID%>').val(data.d[0][0].Invoice_Journal_Temp);
                         }

                         if (data.d[0][0].CustInfo_Temp == "") {
                             $('#<%=ddlCustTemplate.ClientID%>')[0].selectedIndex = 0;
                         } else {
                             $('#<%=ddlCustTemplate.ClientID%>').val(data.d[0][0].CustInfo_Temp);
                         }

                     }
                 }
             });
         }

         function enableDisableDaily(VisibleType) {
             //  $('#<%=txtMonthlyTime.ClientID%>').attr('disabled', 'disabled');
             document.getElementById('<%=txtDailyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=drpdailyHM.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtDailyStTime.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtDailyEndTime.ClientID%>').disabled = VisibleType;
         }

         function enableDisableWeek(VisibleType) {
             document.getElementById('<%=ddlWeeklyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtWeeklyTime.ClientID%>').disabled = VisibleType;
         }

         function enableDisableMonth(VisibleType) {
             document.getElementById('<%=ddlMonthly.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtMonthlyTime.ClientID%>').disabled = VisibleType;
         }

         function loadExpTypeForInvJrnl(data) {
             $('#<%=ddlExpTypeName.ClientID%>').empty();
             $('#<%=ddlExpTypeName.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlExpTypeName.ClientID%>').append($("<option></option>").val(value.Template_Id).html(value.Template_Name));
             });
             return true;
         }

         function loadExpTypeForCustInfo(data) {
             $('#<%=ddlCustTemplate.ClientID%>').empty();
             $('#<%=ddlCustTemplate.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlCustTemplate.ClientID%>').append($("<option></option>").val(value.Template_Id).html(value.Template_Name));
             });
             return true;
         }

         function saveConfig() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnClientValidate();
             if (result == true) {
             var flgGrouping = $('#<%=rdbGrouping.ClientID%>').find(':checked').val();
             var flgExpMode = $('#<%=rdbExportMode.ClientID%>').find(':checked').val();
             var flgExpAllowMulMonths, flgExpEachInvoice;

             if ($('#<%=rdbInvExp.ClientID%>').find(':checked').val() == "M") {
                 flgExpAllowMulMonths = "1";
                 flgExpEachInvoice = "0";
             } else if ($('#<%=rdbInvExp.ClientID%>').find(':checked').val() == "E") {
                 flgExpAllowMulMonths = "0";
                 flgExpEachInvoice = "1";
             }
             var expInvjournalPath = $('#<%=txtInvoiceJournal.ClientID%>').val();
             expInvjournalPath = expInvjournalPath.replace(/\\/g, "/");

             var expCustInfoPath =  $('#<%=txtInvJournalCustInfo.ClientID%>').val();
             expCustInfoPath = expCustInfoPath.replace(/\\/g, "/");
             var impCustInfoPath = $('#<%=txtCustomerInfo.ClientID%>').val(); 
             impCustInfoPath = impCustInfoPath.replace(/\\/g, "/");
             var impCustBalancePath = $('#<%=txtCustomerBalance.ClientID%>').val();
             impCustBalancePath = impCustBalancePath.replace(/\\/g, "/");
             var expInvJrnlSeqNo = $("#<%=cbSeqNos.ClientID%>").is(':checked');
             var expCustSeqNo = $("#<%=cbCustseqNo.ClientID%>").is(':checked');
             var customerId = $("#<%=ddlCustID.ClientID%>").val();
             var custOrderNo = $("#<%=ddlOrderNo.ClientID%>").val();
             var custRegNo = $("#<%=ddlRegNo.ClientID%>").val();
             var custVINNo = $("#<%=ddlVinNo.ClientID%>").val();
             var custVINNoLen = $("#<%=txtVinNumLen.ClientID%>").val();
             var custName = $("#<%=ddlCustName.ClientID%>").val();
             var custFixedText = $("#<%=txtFixText.ClientID%>").val();
             var invJrnlTemp = $("#<%=ddlExpTypeName.ClientID%>").val();
             var custInfoTemp = $("#<%=ddlCustTemplate.ClientID%>").val();
             var useInvNoSort = $("#<%=cbUseInvNoForSort.ClientID%>").is(':checked');
             var useCRExp = $("#<%=cbUseCreditNote.ClientID%>").is(':checked');
             var useBLSpaces = $("#<%=cbUseBlankSp.ClientID%>").is(':checked');
             var useCombLines = $("#<%=cbCombinelines.ClientID%>").is(':checked');
             var useSplit = $("#<%=cbSplitSubsidiary.ClientID%>").is(':checked');
             var addDate = $("#<%=cbAddDate.ClientID%>").is(':checked');
             var remCostStckfromInv = $("#<%=cbRemCost.ClientID%>").is(':checked');
             var flgAddText = $("#<%=cbAddText.ClientID%>").is(':checked');
             var flgAdditionalText = $("#<%=cbAdditionalText.ClientID%>").is(':checked');
             var addText = $("#<%=txtAddText.ClientID%>").val();
             var additionalText = $("#<%=txtAdditionalText.ClientID%>").val();
             var flgCustText = $("#<%=cbCustomerText.ClientID%>").is(':checked');
             var custText = $("#<%=txtCustomerText.ClientID%>").val();
             var flgVoucherType = $("#<%=cbDisplayVchrType.ClientID%>").is(':checked');
             var voucherType;
             if ($('#<%=drpDisplayVchrType.ClientID%>')[0].selectedIndex >  0) {
                 voucherType = $("#<%=drpDisplayVchrType.ClientID%>").val();
             } else {
                 voucherType = "";
             }

             var flgDisplayAllInvNum = $("#<%=cbDisplayInvNum.ClientID%>").is(':checked');
             var fixedPriceAccntCode = $("#<%=txtFPAccCode.ClientID%>").val();
             var flgExpValid = $("#<%=cbExpValid.ClientID%>").is(':checked');
             var errorInvoicesName = $("#<%=txtErrInvName.ClientID%>").val();
             var suffixFileNameExpInvJrnl = $("#<%=ddlSuffix.ClientID%>").val();
             var prefixFileNameExpInvJrnl = $("#<%=txtPrefix.ClientID%>").val();
             var prefixFileNameExpCustInfo = $("#<%=txtPrefix_ExpCustInfo.ClientID%>").val();
             var suffixFileNameExpCustInfo = $("#<%=ddlSuffixCustInfo.ClientID%>").val();
             var schBasis,schDailyTimeFormat,schDailyIntMins,schDailyStTime,schDailyEndTime,schWeekDay,schWeekTime,schMonthDay,schMonthTime ;
             if ($("#<%=rbtnDaily.ClientID%>").is(':checked')) {
                 schBasis = "D";
                 schDailyTimeFormat = $("#<%=drpdailyHM.ClientID%>").val();
                 schDailyIntMins = $("#<%=txtDailyEvery.ClientID%>").val();
                 schDailyStTime = $("#<%=txtDailyStTime.ClientID%>").val();
                 schDailyEndTime = $("#<%=txtDailyEndTime.ClientID%>").val();
                 schWeekDay = "0";
                 schWeekTime = "";
                 schMonthDay = "0";
                 schMonthTime = "";

             } else if ($("#<%=rbtnWeekly.ClientID%>").is(':checked')) {
                 schBasis = "W";
                 schWeekDay = $('#<%=ddlWeeklyEvery.ClientID%>')[0].selectedIndex;
                 schWeekTime = $("#<%=txtWeeklyTime.ClientID%>").val();
                 schDailyTimeFormat = "";
                 schDailyIntMins = "0";
                 schDailyStTime = "";
                 schDailyEndTime = "";
                 schMonthDay = "1";
                 schMonthTime = "";
             } else if ($("#<%=rbtnMonthly.ClientID%>").is(':checked')) {
                 schBasis = "M";
                 schMonthDay = $("#<%=ddlMonthly.ClientID%>").val();
                 schMonthTime = $("#<%=txtMonthlyTime.ClientID%>").val();
                 schWeekDay = "0";
                 schWeekTime = "";
                 schDailyTimeFormat = "";
                 schDailyIntMins = "0";
                 schDailyStTime = "";
                 schDailyEndTime = "";
             }
             
             <%--schWeekDay = $('#<%=ddlWeeklyEvery.ClientID%>')[0].selectedIndex;
             schWeekTime = $("#<%=txtWeeklyTime.ClientID%>").val();
             schMonthDay = $("#<%=ddlMonthly.ClientID%>").val();
             schMonthTime = $("#<%=txtMonthlyTime.ClientID%>").val();--%>

             var flgUseBillAddrExp = $("#<%=cbUseBillAddr.ClientID%>").is(':checked');
             var errAccntCode = $("#<%=txtErrAccCode.ClientID%>").val();
             var expInvJournalSeries = $("#<%=txtTransactionNo.ClientID%>").val();
             var expCustSeries = $("#<%=txtSeqNo.ClientID%>").val();


             if (expInvJrnlSeqNo) {
                 expInvJournalSeries = $("#<%=txtTransactionNo.ClientID%>").val();
             } else {
                 expInvJournalSeries = "";
             }

             if (expCustSeqNo) {
                 expCustSeries = $("#<%=txtSeqNo.ClientID%>").val();
             } else {
                 expCustSeries = "";
             }

             if (flgAddText) {
                 addText = $("#<%=txtAddText.ClientID%>").val();
             } else {
                 addText = "";
             }

             if (flgAdditionalText) {
                 additionalText = $("#<%=txtAdditionalText.ClientID%>").val();
             } else {
                 additionalText = "";
             }

             if (flgCustText) {
                 custText = $("#<%=txtCustomerText.ClientID%>").val();
             } else {
                 custText = "";
             }

             if (flgExpValid) {
                 errorInvoicesName = $("#<%=txtErrInvName.ClientID%>").val();
             } else {
                 errorInvoicesName = "";
             }


                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfLA.aspx/SaveConfiguration",
                     data: "{flgGrouping:'" + flgGrouping + "', flgExpMode:'" + flgExpMode + "', flgExpAllowMulMonths:'" + flgExpAllowMulMonths + "', flgExpEachInvoice:'" + flgExpEachInvoice +
                         "', expInvjournalPath:'" + expInvjournalPath + "', expCustInfoPath:'" + expCustInfoPath + "', impCustInfoPath:'" + impCustInfoPath + "', impCustBalancePath:'" + impCustBalancePath + "', expInvJrnlSeqNo:'" + expInvJrnlSeqNo + "', expCustSeqNo:'" + expCustSeqNo +
                         "', customerId:'" + customerId + "', custOrderNo:'" + custOrderNo + "', custRegNo:'" + custRegNo + "', custVINNo:'" + custVINNo + "', custVINNoLen:'" + custVINNoLen + "', custName:'" + custName +
                         "', custFixedText:'" + custFixedText + "', invJrnlTemp:'" + invJrnlTemp + "', custInfoTemp:'" + custInfoTemp + "', useInvNoSort:'" + useInvNoSort + "', useCRExp:'" + useCRExp + "', useBLSpaces:'" + useBLSpaces +
                         "', useCombLines:'" + useCombLines + "', useSplit:'" + useSplit + "', addDate:'" + addDate + "', remCostStckfromInv:'" + remCostStckfromInv + "', flgAddText:'" + flgAddText + "', flgAdditionalText:'" + flgAdditionalText +
                         "', addText:'" + addText + "', additionalText:'" + additionalText + "', flgCustText:'" + flgCustText + "', custText:'" + custText + "', flgVoucherType:'" + flgVoucherType + "', voucherType:'" + voucherType +
                         "', flgDisplayAllInvNum:'" + flgDisplayAllInvNum + "', fixedPriceAccntCode:'" + fixedPriceAccntCode + "', flgExpValid:'" + flgExpValid + "', errorInvoicesName:'" + errorInvoicesName + "', suffixFileNameExpInvJrnl:'" + suffixFileNameExpInvJrnl + "', prefixFileNameExpInvJrnl:'" + prefixFileNameExpInvJrnl +
                         "', prefixFileNameExpCustInfo:'" + prefixFileNameExpCustInfo + "', suffixFileNameExpCustInfo:'" + suffixFileNameExpCustInfo + "', schBasis:'" + schBasis + "', schDailyTimeFormat:'" + schDailyTimeFormat + "', schDailyIntMins:'" + schDailyIntMins + "', schDailyStTime:'" + schDailyStTime +
                         "', schDailyEndTime:'" + schDailyEndTime + "', schWeekDay:'" + schWeekDay + "', schWeekTime:'" + schWeekTime + "', schMonthDay:'" + schMonthDay + "', schMonthTime:'" + schMonthTime + "', flgUseBillAddrExp:'" + flgUseBillAddrExp + "', errAccntCode:'" + errAccntCode + "', expInvJournalSeries:'" + expInvJournalSeries + "', expCustSeries:'" + expCustSeries +
                         "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         //data = data.d[0];
                         if (data.d.length > 0) {
                             if (data.d[0] = "0") {
                                 $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                 $('#<%=RTlblError.ClientID%>').removeClass();
                                 $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                 loadConfiguration();
                             }
                             else {
                                 $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                                 $('#<%=RTlblError.ClientID%>').removeClass();
                                 $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                             }

                         }

                         
                     },
                     error: function (result) {
                         alert("Error");
                     }
                 });
             }
         }




</script>

<div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Link to Accounting-Config"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" />  
 </div>
 <div id="divLADetails" class="ui raised segment signup inactive">
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
        <a id="header" runat="server" class="active item">Link to Accounting - Config</a>  
     </div>
     <div class="ui horizontal segments">
        <div class="ui segment">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A1" runat="server" class="active item">Grouping</a>  
            </div>
            <div>
                <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ID="rdbGrouping"   >
                    <asp:ListItem Text="Combined" style="padding-right:1em;" Value="C"></asp:ListItem>
                    <asp:ListItem Text="Individual" Value="I"></asp:ListItem>
                </asp:RadioButtonList>

            </div>
        </div>
        <div class="ui segment">
             <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A2" runat="server" class="active item">Export Mode</a>  
            </div>
            <div>
                <asp:RadioButtonList runat="server" RepeatDirection="Horizontal"  ID="rdbExportMode" >
                    <asp:ListItem Text="Manual" style="padding-right:1em;" Value="M"></asp:ListItem>
                    <asp:ListItem Text="Auto"  Value="A"></asp:ListItem>
                </asp:RadioButtonList>
            </div>
        </div>
        <div class="ui segment">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A3" runat="server" class="active item">Invoice Export</a>  
            </div>
            <div>
                <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ID="rdbInvExp">
                    <asp:ListItem Text="Allow Multiple Invoice" style="padding-right:1em;" Value="M"></asp:ListItem>
                    <asp:ListItem Text="Allow after each Invoice Created" Value="E"></asp:ListItem>
                </asp:RadioButtonList>
            </div>
        </div>
      </div>
      <div class="ui horizontal segments">
         <div class="ui segment">
            <div class="ui form">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a id="A4" runat="server" class="active item">Default Path Settings For Export</a>  
                </div>
                <div class="four fields" style="padding-bottom:0.5em;">
                    <asp:Label ID="lblInvoiceJournal" runat="server" Text="Invoice Journal" Width="254px"></asp:Label>
                    <asp:TextBox ID="txtInvoiceJournal" runat="server"  Width="243px"></asp:TextBox>
                </div>
                <div>
                    <asp:Label ID="lblInvJournalCustInfo" runat="server" Text="Customer Information" Width="252px"></asp:Label>
                    <asp:TextBox ID="txtInvJournalCustInfo" runat="server" Width="243px" ></asp:TextBox>
                </div>    
            </div>
        </div>
        <div class="ui segment">
            <div class="ui form">
                 <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a id="A5" runat="server" class="active item">Default Path Settings For Import</a>  
                 </div>
                 <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblCustomerInfo" runat="server" Text="Customer Information" Width="242px"></asp:Label>
                    <asp:TextBox ID="txtCustomerInfo" runat="server" Width="243px"></asp:TextBox>
                 </div>
                 <div>
                    <asp:Label ID="lblCustomerBalance" runat="server" Text="Customer Balance" Width="243px"></asp:Label>
                    <asp:TextBox ID="txtCustomerBalance" runat="server" Width="243px"></asp:TextBox>
                 </div>
            </div>
        </div>
      </div>  

      <div class="ui horizontal segments">
         <div class="ui segment">
            <div class="ui form">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a id="A6" runat="server" class="active item">Export File Name For Invoice Journal </a>  
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblPrefix" runat="server" Text="Prefix" Width="252px"></asp:Label>
                    <asp:TextBox ID="txtPrefix" runat="server" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblSuffix" runat="server" Text="Suffix" Width="250px"></asp:Label>
                    <asp:DropDownList ID="ddlSuffix" runat="server" Width="120px" style="display:inline">
                         <asp:ListItem Text="CSV" Value="CSV"></asp:ListItem>
                        <asp:ListItem Text="TXT" Value="TXT"></asp:ListItem>
                        <asp:ListItem Text="XML" Value="XML"></asp:ListItem>
                    </asp:DropDownList>
                </div>                
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblSeqNos" runat="server" Text="Sequence Nos" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbSeqNos" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblTransactionNo" runat="server" Text="Trans No" Width="250px"></asp:Label>
                    <asp:TextBox ID="txtTransactionNo" runat="server" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblExpTypeName" runat="server" Text="Export Type Name " Width="250px"></asp:Label>
                    <asp:DropDownList ID="ddlExpTypeName" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblUseInvNoForSort" runat="server" Text="Use Invoice Number For Sorting Export " Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbUseInvNoForSort" runat="server" />
                </div>    
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblUseCreditNote" runat="server" Text="Auto Export CreditNotes " Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbUseCreditNote" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblUseBlankSp" runat="server" Text="Use Blank Spaces" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbUseBlankSp" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblCombinelines" runat="server" Text="Use Combine All Lines For Same Acc Code " Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbCombinelines" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblSplitSubsidiary" runat="server" Text="Spliting Based On Subsidiary" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbSplitSubsidiary" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblRemCost" runat="server" Text="Remove Cost/Stock From Invoice" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbRemCost" runat="server" />
                </div>
                 <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblDispalyVchrType" runat="server" Text="Display Vochur Type" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbDisplayVchrType" runat="server" />
                    <asp:DropDownList ID="drpDisplayVchrType" runat="server" Width="155px" style="display:inline">
                        <asp:ListItem Text="ALL Lines" Value="ALL"></asp:ListItem>
                        <asp:ListItem Text="GL Lines" Value="GL"></asp:ListItem>
                        <asp:ListItem Text="AR Lines" Value="AR"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblDisplayInvNumbers" runat="server" Text="Display Invoice Numbers On All Lines" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbDisplayInvNum" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblAddDate" runat="server" Text="Add Date" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbAddDate" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblAddText" runat="server" Text="Add text for date" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbAddText" runat="server" />
                    <asp:TextBox ID="txtAddText" runat="server" MaxLength="100" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblAdditionalText" runat="server" Text="Add Additional Text" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbAdditionalText" runat="server" />
                    <asp:TextBox ID="txtAdditionalText" runat="server" MaxLength="100" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblCustomerText" runat="server" Text="Add Additional Text For Customer" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbCustomerText" runat="server" />
                    <asp:TextBox ID="txtCustomerText" runat="server" MaxLength="100" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblErrorAccountCode" runat="server" Text="Error Account Code" Width="250px"></asp:Label>
                    <asp:TextBox ID="txtErrAccCode" runat="server" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblFixedPriceAccCode" runat="server" Text="Fixed Price Acc.Code" Width="250px"></asp:Label>
                    <asp:TextBox ID="txtFPAccCode" runat="server" Width="243px"></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblExportValidation" runat="server" Text="Export Validation" Width="250px"></asp:Label>
                    <asp:CheckBox ID="cbExpValid" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblErrInvName" runat="server" Text="Error Invoices Name" Width="250px"></asp:Label>
                    <asp:TextBox ID="txtErrInvName" runat="server" Width="243px"></asp:TextBox>
                </div>
            </div>
        </div>
          <div class="ui segment">
            <div class="ui form">
                 <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a id="A7" runat="server" class="active item">Export File Name For Customer Information</a>  
                 </div>
                 <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblPrefix2" runat="server" Text="Prefix" Width="242px"></asp:Label>
                    <asp:TextBox ID="txtPrefix_ExpCustInfo" runat="server" Width="243px"></asp:TextBox>
                 </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblSuffix2" runat="server" Text="Suffix" Width="242px"></asp:Label>
                    <asp:DropDownList ID="ddlSuffixCustInfo" runat="server" Width="120px" style="display:inline">
                        <asp:ListItem Text="CSV" Value="CSV"></asp:ListItem>
                        <asp:ListItem Text="TXT" Value="TXT"></asp:ListItem>
                        <asp:ListItem Text="XML" Value="XML"></asp:ListItem>
                    </asp:DropDownList>
                </div>                
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblCustSeqNo" runat="server" Text="Sequence Nos" Width="242px"></asp:Label>
                    <asp:CheckBox ID="cbCustseqNo" runat="server" />
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblSeqNo" runat="server" Text="Seq No" Width="242px"></asp:Label>
                    <asp:TextBox ID="txtSeqNo" runat="server" Width="243px"  MaxLength="4" ></asp:TextBox>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lblCustExpTypeName" runat="server" Text="Export Type Name " Width="242px"></asp:Label>
                    <asp:DropDownList ID="ddlCustTemplate" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>
                <div style="padding-bottom:0.5em;">
                    <asp:Label ID="lbluseBillAddrExp" runat="server" Text="Use Billing Address for Export " Width="242px"></asp:Label>
                    <asp:CheckBox ID="cbUseBillAddr" runat="server" />
                </div>
            </div>
        </div>
      </div>   

      <div class="ui form">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A8" runat="server" class="active item">Schedule</a>  
        </div>
        <div class="four fields">
            <div class="field" style="width:100px">
                <asp:RadioButton ID="rbtnDaily" GroupName="grpSchedule" runat="server" Text="Daily" Width="60px"  />
            </div>
            <div class="field" style="width:70px">
                <asp:Label ID="lblEvery" runat="server" Text="Every" Width="60px"></asp:Label>
            </div>    
            <div class="field" style="width:100px">
                <asp:TextBox ID="txtDailyEvery" runat="server" Width="80px" ></asp:TextBox>
            </div>
            <div class="field" style="width:150px">
                <asp:DropDownList ID="drpdailyHM" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
            </div> 
            <div class="field" style="width:70px">
                <asp:Label ID="lblStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
            </div>    
            <div class="field" style="width:100px">
                <asp:TextBox ID="txtDailyStTime" runat="server" Width="80px" ></asp:TextBox>
            </div>  
            <div class="field" style="width:70px">
                <asp:Label ID="lblEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
            </div>    
            <div class="field" style="width:100px">
                <asp:TextBox ID="txtDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
            </div>                         
        </div>
        <div class="four fields">
            <div class="field" style="width:100px">
                <asp:RadioButton ID="rbtnWeekly" GroupName="grpSchedule" runat="server" Text="Weekly" Width="63px"/>
            </div>
            <div class="field" style="width:70px">
                <asp:Label ID="lblEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
            </div>    
            <div class="field" style="width:250px">
                <asp:DropDownList ID="ddlWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
            </div> 
            <div class="field" style="width:70px">
                <asp:Label ID="lblTime" runat="server" Text="Time" Width="80px"></asp:Label>
            </div>    
            <div class="field" style="width:100px">
                <asp:TextBox ID="txtWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
            </div>
       </div>
       <div class="four fields">
            <div class="field" style="width:100px">
                <asp:RadioButton ID="rbtnMonthly" GroupName="grpSchedule" runat="server" Text="Monthly" Width="68px"/>
            </div>
            <div class="field" style="width:70px">
                <asp:Label ID="lblEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
            </div>    
            <div class="field" style="width:250px">
                <asp:DropDownList ID="ddlMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
            </div> 
            <div class="field" style="width:70px">
                <asp:Label ID="lblTime2" runat="server" Text="Time" Width="80px"></asp:Label>
            </div>    
            <div class="field" style="width:100px">
                <asp:TextBox ID="txtMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
            </div>
       </div>
      </div>
      <div class="ui form">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a id="A9" runat="server" class="active item">Customer Information Settings</a>  
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:Label ID="lblOrder" runat="server" Text="Order" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblDetails" runat="server" Text="Details" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblLength" runat="server" Text="Length" />
             </div>
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:DropDownList ID="ddlCustID" runat="server" Width="79px" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblCustID" runat="server" Text="Customer ID"></asp:Label>
             </div>
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:DropDownList ID="ddlOrderNo" runat="server" Width="79px" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblOrderNo" runat="server" Text="Order Number"></asp:Label>
             </div>
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:DropDownList ID="ddlRegNo" runat="server" Width="79px" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblRegNo" runat="server" Text="Registration Number"></asp:Label>
             </div>
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:DropDownList ID="ddlVinNo" runat="server" Width="79px" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblVinNo" runat="server" Text="VIN Number"></asp:Label>
             </div>
            <div class="field" style="width:150px">
                <asp:TextBox ID="txtVinNumLen" runat="server" Width="50px" MaxLength="2" ></asp:TextBox>
             </div>
        </div>
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:DropDownList ID="ddlCustName" runat="server" Width="79px" />
             </div>
             <div class="field" style="width:150px">
                <asp:Label ID="lblCustName" runat="server" Text="Customer Name"></asp:Label>
             </div>
        </div>    
        <div class="four fields">
             <div class="field" style="width:150px">
                <asp:Label ID="lblFixedText" runat="server" Text="Fixed Text"></asp:Label>
             </div>
             <div class="field" style="width:150px">
                <asp:TextBox ID="txtFixText" runat="server" Width="50px" MaxLength="8" ></asp:TextBox>
             </div>
        </div>
      </div>
      <div style="text-align:center">
        <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveConfig()"/>
        <%--<input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="reset()" />--%>
      </div>
</div>
</asp:Content>
