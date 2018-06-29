<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmAccountImportSchedular.aspx.vb" Inherits="CARS.frmAccountImportSchedular" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">

         function fnClientValidate() {
             if (!(gfi_CheckEmpty($('#<%=txtBalFileLocation.ClientID%>'), 'FU032'))) {
                 $('#<%= txtBalFileLocation.ClientID%>').focus();
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtBalFileName.ClientID%>'), 'FN001'))) {
                 $('#<%= txtBalFileName.ClientID%>').focus();
                 return false;
             }
             if (!(CheckExtension(document.getElementById("<%= txtBalFileName.ClientID%>")))) {
                 alert(GetMultiMessage('FN002', '', ''));
                 $('#<%= txtBalFileName.ClientID%>').focus();
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtBalArchiveDays.ClientID%>'), 'ARD01'))) {
                 $('#<%= txtBalArchiveDays.ClientID %>').focus();
                 return false;
             }

             if (!(gfi_ValidateNumber(( $('#<%= txtBalArchiveDays.ClientID%>')), 'EditText'))) {
                 $('#<%= txtBalArchiveDays.ClientID %>').focus();
                 return false;
             }

             if ((document.getElementById("<%= rbtnBalDaily.ClientID %>").checked == false) && (document.getElementById("<%= rbtnBalWeekly.ClientID %>").checked == false) && (document.getElementById("<%= rbtnBalMonthly.ClientID %>").checked == false)) {
                 alert(GetMultiMessage('FU034', '', ''));
                 return false;
             }
             if ((document.getElementById("<%= rbtnCustDaily.ClientID%>").checked == false) && (document.getElementById("<%= rbtnCustWeekly.ClientID%>").checked == false) && (document.getElementById("<%= rbtnCustMonthly.ClientID %>").checked == false)) {
                 alert(GetMultiMessage('FU034', '', ''));
                 return false;
             }

             if (document.getElementById("<%= rbtnBalDaily.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtBalDailyEvery.ClientID%>'), '0532'))) {
                     $('#<%= txtBalDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if ($('#<%= txtBalDailyEvery.ClientID%>').value == "0") {
                     msg = GetMultiMessage('1779', '', '');
                     alert(msg);
                     $('#<%= txtBalDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if (!(gfi_ValidateNumber($('#<%= txtBalDailyEvery.ClientID%>'), '0532'))) {
                     $('#<%= txtBalDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpBalance_Everyhour.ClientID %>").selectedIndex == 0 && document.getElementById("<%= txtBalDailyEvery.ClientID%>").value > 24) {
                     msg = GetMultiMessage('1775', '', '');
                     alert(msg);
                     document.getElementById("<%= drpBalance_Everyhour.ClientID %>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpBalance_Everyhour.ClientID %>").selectedIndex == 1 && document.getElementById("<%= txtBalDailyEvery.ClientID%>").value > 60) {
                     msg = GetMultiMessage('1776', '', '');
                     alert(msg);
                     document.getElementById("<%= drpBalance_Everyhour.ClientID %>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtBalDailyStTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtBalDailyStTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtBalDailyStTime.ClientID %>").value))) {
                     document.getElementById("<%= txtBalDailyStTime.ClientID%>").value = "";
                     document.getElementById("<%= txtBalDailyStTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtBalDailyEndTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtBalDailyEndTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtBalDailyEndTime.ClientID%>").value))) {
                     document.getElementById("<%= txtBalDailyEndTime.ClientID%>").value = "";
                     document.getElementById("<%= txtBalDailyEndTime.ClientID%>").focus();
                     return false;
                 }
             }
             if (document.getElementById("<%= rbtnBalWeekly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= rbtnBalWeekly.ClientID%>'), '0532'))) {
                     document.getElementById("<%= rbtnBalWeekly.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtBalWeeklyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtBalWeeklyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtBalWeeklyTime.ClientID%>").focus();
                     return false;
                 }
             }
             if (document.getElementById("<%= rbtnBalMonthly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtBalMonthlyTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtBalMonthlyTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtBalMonthlyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtBalMonthlyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtBalMonthlyTime.ClientID %>").focus();
                     return false;
                 }
             }

             if (!(gfi_CheckEmpty($('#<%= txtCustFileLocation.ClientID%>'), 'FU032'))) {
                 document.getElementById("<%= txtCustFileLocation.ClientID%>").focus();
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtCustFileName.ClientID%>'), 'FN001'))) {
                 document.getElementById("<%= txtCustFileName.ClientID %>").focus();
                 return false;
             }
             if (!(CheckExtension(document.getElementById("<%= txtCustFileName.ClientID%>")))) {
                 alert(GetMultiMessage('FN002', '', ''))
                 document.getElementById("<%= txtCustFileName.ClientID%>").focus();
                 return false;
             }


             if (document.getElementById("<%= rbtnCustDaily.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtCustDailyEvery.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtCustDailyEvery.ClientID%>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= txtCustDailyEvery.ClientID%>").value == "0") {
                     msg = GetMultiMessage('1779', '', '')
                     alert(msg)
                     document.getElementById("<%= txtCustDailyEvery.ClientID%>").focus();
                     return false
                 }

                 if (!(gfi_ValidateNumber($('#<%= txtCustDailyEvery.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtCustDailyEvery.ClientID%>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpCustomer_Everyhour.ClientID %>").selectedIndex == 0 && document.getElementById("<%= txtCustDailyEvery.ClientID%>").value > 24) {
                     msg = GetMultiMessage('1775', '', '')
                     alert(msg)
                     document.getElementById("<%= drpCustomer_Everyhour.ClientID %>").focus();
                     return false
                 }

                 if (document.getElementById("<%= drpCustomer_Everyhour.ClientID %>").selectedIndex == 1 && document.getElementById("<%= txtCustDailyEvery.ClientID%>").value > 60) {
                     msg = GetMultiMessage('1776', '', '')
                     alert(msg);
                     document.getElementById("<%= drpCustomer_Everyhour.ClientID %>").focus();
                     return false
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtCustDailyStTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtCustDailyStTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtCustDailyStTime.ClientID%>").value))) {
                     document.getElementById("<%= txtCustDailyStTime.ClientID%>").value = "";
                     document.getElementById("<%= txtCustDailyStTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtCustDailyEndTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtCustDailyEndTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtCustDailyEndTime.ClientID%>").value))) {
                     document.getElementById("<%= txtCustDailyEndTime.ClientID%>").value = "";
                     document.getElementById("<%= txtCustDailyEndTime.ClientID%>").focus();
                     return false;
                 }
             }

             if (document.getElementById("<%= rbtnCustWeekly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= rbtnCustWeekly.ClientID%>'), '0532'))) {
                     document.getElementById("<%= rbtnCustWeekly.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtCustWeeklyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtCustWeeklyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtCustWeeklyTime.ClientID%>").focus();
                     return false;
                 }
             }

             if (document.getElementById("<%= rbtnCustMonthly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtCustMonthlyTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtCustMonthlyTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtCustMonthlyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtCustMonthlyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtCustMonthlyTime.ClientID %>").focus();
                     return false;
                 }
             }

             return true;
         }

         //Check the File Extension
         function CheckExtension(FileLoc) {
             var valid_extensions = /(.txt|.TXT|.csv|.doc|.CSV|.DOC)$/i;
             var fileAndPath = FileLoc.value; // document.getElementById(FileLoc).value;
             if (fileAndPath != null || fileAndPath != "") {
                 if (valid_extensions.test(fileAndPath)) {
                     return true;
                 }
                 else {
                     return false;
                 }
             }
         }

         $(document).ready(function () {
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             loadAccntImportScheduler();

             $(document).on('click', '#<%=rbtnBalDaily.ClientID%>', function () {
                 fnBalChangeMode();
             });

             $(document).on('click', '#<%=rbtnBalWeekly.ClientID%>', function () {
                 fnBalChangeMode();
             });

             $(document).on('click', '#<%=rbtnBalMonthly.ClientID%>', function () {
                 fnBalChangeMode();
             });

             $(document).on('click', '#<%=rbtnCustDaily.ClientID%>', function () {
                 fnCustChangeMode();
             });

             $(document).on('click', '#<%=rbtnCustWeekly.ClientID%>', function () {
                 fnCustChangeMode();
             });

             $(document).on('click', '#<%=rbtnCustMonthly.ClientID%>', function () {
                 fnCustChangeMode();
             });

             function fnBalChangeMode() {
                 if (document.getElementById('<%=rbtnBalDaily.ClientID%>').checked == true) {
                     enableBalDisableDaily(false)
                     enableBalDisableWeek(true)
                     enableBalDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnBalWeekly.ClientID%>').checked == true) {
                     enableBalDisableDaily(true)
                     enableBalDisableWeek(false)
                     enableBalDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnBalMonthly.ClientID%>').checked == true) {
                     enableBalDisableDaily(true)
                     enableBalDisableWeek(true)
                     enableBalDisableMonth(false)
                 }
             }

             function fnCustChangeMode() {
                 if (document.getElementById('<%=rbtnCustDaily.ClientID%>').checked == true) {
                     enableCustDisableDaily(false)
                     enableCustDisableWeek(true)
                     enableCustDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnCustWeekly.ClientID%>').checked == true) {
                     enableCustDisableDaily(true)
                     enableCustDisableWeek(false)
                     enableCustDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnCustMonthly.ClientID%>').checked == true) {
                     enableCustDisableDaily(true)
                     enableCustDisableWeek(true)
                     enableCustDisableMonth(false)
                 }
             }

             $('#<%=txtBalDailyStTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtBalDailyStTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalDailyStTime.ClientID%>'));
                 }
             });

             $('#<%=txtBalDailyEndTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtBalDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalDailyEndTime.ClientID%>'));
                 }

                 if ($('#<%=txtBalDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalDailyEndTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtBalDailyEndTime.ClientID%>').val()))) {
                         $('#<%=txtBalDailyEndTime.ClientID%>').val("");
                         $('#<%=txtBalDailyEndTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtBalWeeklyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtBalWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalWeeklyTime.ClientID%>'));
                 }

                 if ($('#<%=txtBalWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalWeeklyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtBalWeeklyTime.ClientID%>').val()))) {
                         $('#<%=txtBalWeeklyTime.ClientID%>').val("");
                         $('#<%=txtBalWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtBalMonthlyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtBalMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalMonthlyTime.ClientID%>'));
                 }

                 if ($('#<%=txtBalMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtBalMonthlyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtBalMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtBalMonthlyTime.ClientID%>').val("");
                         $('#<%=txtBalMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             //Customer
             $('#<%=txtCustDailyStTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtCustDailyStTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustDailyStTime.ClientID%>'));
                 }
             });

             $('#<%=txtCustDailyEndTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtCustDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustDailyEndTime.ClientID%>'));
                 }

                 if ($('#<%=txtCustDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustDailyEndTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtCustDailyEndTime.ClientID%>').val()))) {
                         $('#<%=txtCustDailyEndTime.ClientID%>').val("");
                         $('#<%=txtCustDailyEndTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtCustWeeklyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtCustWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustWeeklyTime.ClientID%>'));
                 }

                 if ($('#<%=txtCustWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustWeeklyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtCustWeeklyTime.ClientID%>').val()))) {
                         $('#<%=txtCustWeeklyTime.ClientID%>').val("");
                         $('#<%=txtCustWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtCustMonthlyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtCustMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustMonthlyTime.ClientID%>'));
                 }

                 if ($('#<%=txtCustMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtCustMonthlyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtCustMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtCustMonthlyTime.ClientID%>').val("");
                         $('#<%=txtCustMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });


         });//end of ready

         function loadAccntImportScheduler() {

             var mydata;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmAccountImportSchedular.aspx/LoadAccntImportScheduler",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {

                         if (data.d[0].length > 0) {
                             $('#<%=txtBalFileLocation.ClientID%>').val(data.d[0][0].Balance_FileLocation);
                             $('#<%=txtBalFileName.ClientID%>').val(data.d[0][0].Balance_File_Name);
                             $('#<%=txtBalArchiveDays.ClientID%>').val(data.d[0][0].Balance_ArchiveDays);
                             $('#<%=txtCustFileLocation.ClientID%>').val(data.d[0][0].Customer_FileLocation);
                             $('#<%=txtCustFileName.ClientID%>').val(data.d[0][0].Customer_File_Name);

                             if (data.d[0][0].Balance_Sch_Basis == "D") {
                                 enableBalDisableDaily(false);
                                 enableBalDisableWeek(true);
                                 enableBalDisableMonth(true);
                                 $('#<%=rbtnBalDaily.ClientID%>').attr('checked', true);
                                 $('#<%=txtBalDailyEvery.ClientID%>').val(data.d[0][0].Balance_Sch_Daily_Interval_mins);
                                 $('#<%=txtBalDailyStTime.ClientID%>').val(data.d[0][0].Balance_Sch_Daily_STime);
                                 $('#<%=txtBalDailyEndTime.ClientID%>').val(data.d[0][0].Balance_Sch_Daily_ETime);
                                 $('#<%=drpBalance_Everyhour.ClientID%> option:contains("' + data.d[0][0].Balance_Sch_TimeFormat + '")').attr('selected', 'selected');
                             } else if (data.d[0][0].Balance_Sch_Basis == "M") {
                                 enableBalDisableDaily(true);
                                 enableBalDisableWeek(true);
                                 enableBalDisableMonth(false);
                                 $('#<%=rbtnBalMonthly.ClientID%>').attr('checked', true);
                                 $('#<%=txtBalMonthlyTime.ClientID%>').val(data.d[0][0].Balance_Sch_Month_Time);
                                 $('#<%=ddlBalMonthly.ClientID%>')[0].selectedIndex = data.d[0][0].Balance_Sch_Month_Day;

                             } else if (data.d[0][0].Balance_Sch_Basis == "W") {
                                 enableBalDisableDaily(true);
                                 enableBalDisableWeek(false);
                                 enableBalDisableMonth(true);
                                 $('#<%=rbtnBalWeekly.ClientID%>').attr('checked', true);
                                 $('#<%=ddlBalWeeklyEvery.ClientID%>')[0].selectedIndex = data.d[0][0].Balance_Sch_Week_Day;
                                 $('#<%=txtBalWeeklyTime.ClientID%>').val(data.d[0][0].Balance_Sch_Week_Time);
                             }

                             if (data.d[0][0].Customer_Sch_Basis == "D") {
                                 enableCustDisableDaily(false);
                                 enableCustDisableWeek(true);
                                 enableCustDisableMonth(true);
                                 $('#<%=rbtnCustDaily.ClientID%>').attr('checked', true);
                                 $('#<%=txtCustDailyEvery.ClientID%>').val(data.d[0][0].Customer_Sch_Daily_Interval_mins);
                                 $('#<%=txtCustDailyStTime.ClientID%>').val(data.d[0][0].Customer_Sch_Daily_STime);
                                 $('#<%=txtCustDailyEndTime.ClientID%>').val(data.d[0][0].Customer_Sch_Daily_ETime);
                                 $('#<%=drpCustomer_Everyhour.ClientID%> option:contains("' + data.d[0][0].Customer_Sch_TimeFormat + '")').attr('selected', 'selected');
                             } else if (data.d[0][0].Customer_Sch_Basis == "M") {
                                 enableCustDisableDaily(true);
                                 enableCustDisableWeek(true);
                                 enableCustDisableMonth(false);
                                 $('#<%=rbtnCustMonthly.ClientID%>').attr('checked', true);
                                 $('#<%=txtCustMonthlyTime.ClientID%>').val(data.d[0][0].Customer_Sch_Month_Time);
                                 $('#<%=ddlCustMonthly.ClientID%>')[0].selectedIndex = data.d[0][0].Customer_Sch_Month_Day;

                             } else if (data.d[0][0].Customer_Sch_Basis == "W") {
                                 enableCustDisableDaily(true);
                                 enableCustDisableWeek(false);
                                 enableCustDisableMonth(true);
                                 $('#<%=rbtnCustWeekly.ClientID%>').attr('checked', true);
                                 $('#<%=ddlCustWeeklyEvery.ClientID%>')[0].selectedIndex = data.d[0][0].Customer_Sch_Week_Day;
                                 $('#<%=txtCustWeeklyTime.ClientID%>').val(data.d[0][0].Customer_Sch_Week_Time);
                             }
                         }                                                        

                         loadBalImportType(data.d[1]);
                         loadCustImportType(data.d[2]);

                         if (data.d[0].length > 0) {
                             if (data.d[0][0].Invoice_Journal_Temp == "") {
                                 $('#<%=ddlBalImporType.ClientID%>')[0].selectedIndex = 0;
                             } else {
                                 $('#<%=ddlBalImporType.ClientID%>').val(data.d[0][0].Balance_Template);
                             }
                         } else {
                             $('#<%=ddlBalImporType.ClientID%>').val(data.d[0][0].Balance_Template);
                         }
                         
                         if (data.d[0].length > 0) {
                             if (data.d[0][0].CustInfo_Temp == "") {
                                 $('#<%=ddlCustImportType.ClientID%>')[0].selectedIndex = 0;
                             } else {
                                 $('#<%=ddlCustImportType.ClientID%>').val(data.d[0][0].Customer_Template);
                             }
                         } else {
                             $('#<%=ddlCustImportType.ClientID%>').val(data.d[0][0].Customer_Template);
                         }
                     }
                 }
             });
         }

         function loadBalImportType(data) {
             $('#<%=ddlBalImporType.ClientID%>').empty();
             $('#<%=ddlBalImporType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlBalImporType.ClientID%>').append($("<option></option>").val(value.Template_Id).html(value.Template_Name));
             });
             return true;
         }

         function loadCustImportType(data) {
             $('#<%=ddlCustImportType.ClientID%>').empty();
             $('#<%=ddlCustImportType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlCustImportType.ClientID%>').append($("<option></option>").val(value.Template_Id).html(value.Template_Name));
             });
             return true;
         }

         function enableBalDisableDaily(VisibleType) {
             document.getElementById('<%=txtBalDailyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=drpBalance_Everyhour.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtBalDailyStTime.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtBalDailyEndTime.ClientID%>').disabled = VisibleType;
         }

         function enableBalDisableWeek(VisibleType) {
             document.getElementById('<%=ddlBalWeeklyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtBalWeeklyTime.ClientID%>').disabled = VisibleType;
         }

         function enableBalDisableMonth(VisibleType) {
             document.getElementById('<%=ddlBalMonthly.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtBalMonthlyTime.ClientID%>').disabled = VisibleType;
         }

         function enableCustDisableDaily(VisibleType) {
             document.getElementById('<%=txtCustDailyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=drpCustomer_Everyhour.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtCustDailyStTime.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtCustDailyEndTime.ClientID%>').disabled = VisibleType;
         }

         function enableCustDisableWeek(VisibleType) {
             document.getElementById('<%=ddlCustWeeklyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtCustWeeklyTime.ClientID%>').disabled = VisibleType;
         }

         function enableCustDisableMonth(VisibleType) {
             document.getElementById('<%=ddlCustMonthly.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtCustMonthlyTime.ClientID%>').disabled = VisibleType;
         }

         function saveAccntImportScheduler() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnClientValidate();
             if (result == true) {
                 var balFileName = $('#<%=txtBalFileName.ClientID%>').val();
                 var balFileLocation = $('#<%=txtBalFileLocation.ClientID%>').val();
                 var balImportType = $('#<%=ddlBalImporType.ClientID%>').val();
                 var balArchiveDays = $('#<%=txtBalArchiveDays.ClientID%>').val();
                 var custFileName = $('#<%=txtCustFileName.ClientID%>').val();
                 var custFileLocation = $('#<%=txtCustFileLocation.ClientID%>').val();
                 var custImportType = $('#<%=ddlCustImportType.ClientID%>').val();
                 var schBalBasis, schBalDailyTimeFormat, schBalDailyIntMins, schBalDailyStTime, schBalDailyEndTime, schBalWeekDay, schBalWeekTime, schBalMonthDay, schBalMonthTime;

                 balFileLocation = balFileLocation.replace(/\\/g, "/");
                 custFileLocation = custFileLocation.replace(/\\/g, "/");

                 if ($("#<%=rbtnBalDaily.ClientID%>").is(':checked')) {
                     schBalBasis = "D";
                     schBalDailyTimeFormat = $("#<%=drpBalance_Everyhour.ClientID%>").val();
                     schBalDailyIntMins = $("#<%=txtBalDailyEvery.ClientID%>").val();
                     schBalDailyStTime = $("#<%=txtBalDailyStTime.ClientID%>").val();
                     schBalDailyEndTime = $("#<%=txtBalDailyEndTime.ClientID%>").val();
                     schBalWeekDay = "0";
                     schBalWeekTime = "";
                     schBalMonthDay = "0";
                     schBalMonthTime = "";

                 } else if ($("#<%=rbtnBalWeekly.ClientID%>").is(':checked')) {
                     schBalBasis = "W";
                     schBalWeekDay = $('#<%=ddlBalWeeklyEvery.ClientID%>')[0].selectedIndex;
                     schBalWeekTime = $("#<%=txtBalWeeklyTime.ClientID%>").val();
                     schBalDailyTimeFormat = "";
                     schBalDailyIntMins = "0";
                     schBalDailyStTime = "";
                     schBalDailyEndTime = "";
                     schBalMonthDay = "1";
                     schBalMonthTime = "";
                 } else if ($("#<%=rbtnBalMonthly.ClientID%>").is(':checked')) {
                     schBalBasis = "M";
                     schBalMonthDay = $("#<%=ddlBalMonthly.ClientID%>").val();
                     schBalMonthTime = $("#<%=txtBalMonthlyTime.ClientID%>").val();
                     schBalWeekDay = "0";
                     schBalWeekTime = "";
                     schBalDailyTimeFormat = "";
                     schBalDailyIntMins = "0";
                     schBalDailyStTime = "";
                     schBalDailyEndTime = "";
                 }

                 var schCustBasis, schCustDailyTimeFormat, schCustDailyIntMins, schCustDailyStTime, schCustDailyEndTime, schCustWeekDay, schCustWeekTime, schCustMonthDay, schCustMonthTime;
                 if ($("#<%=rbtnCustDaily.ClientID%>").is(':checked')) {
                     schCustBasis = "D";
                     schCustDailyTimeFormat = $("#<%=drpCustomer_Everyhour.ClientID%>").val();
                     schCustDailyIntMins = $("#<%=txtCustDailyEvery.ClientID%>").val();
                     schCustDailyStTime = $("#<%=txtCustDailyStTime.ClientID%>").val();
                     schCustDailyEndTime = $("#<%=txtCustDailyEndTime.ClientID%>").val();
                     schCustWeekDay = "0";
                     schCustWeekTime = "";
                     schCustMonthDay = "0";
                     schCustMonthTime = "";

                 } else if ($("#<%=rbtnCustWeekly.ClientID%>").is(':checked')) {
                     schCustBasis = "W";
                     schCustWeekDay = $('#<%=ddlCustWeeklyEvery.ClientID%>')[0].selectedIndex;
                     schCustWeekTime = $("#<%=txtCustWeeklyTime.ClientID%>").val();
                     schCustDailyTimeFormat = "";
                     schCustDailyIntMins = "0";
                     schCustDailyStTime = "";
                     schCustDailyEndTime = "";
                     schCustMonthDay = "1";
                     schCustMonthTime = "";
                 } else if ($("#<%=rbtnCustMonthly.ClientID%>").is(':checked')) {
                     schCustBasis = "M";
                     schCustMonthDay = $("#<%=ddlCustMonthly.ClientID%>").val();
                     schCustMonthTime = $("#<%=txtCustMonthlyTime.ClientID%>").val();
                     schCustWeekDay = "0";
                     schCustWeekTime = "";
                     schCustDailyTimeFormat = "";
                     schCustDailyIntMins = "0";
                     schCustDailyStTime = "";
                     schCustDailyEndTime = "";
                 }
                 

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmAccountImportSchedular.aspx/SaveAccntImportScheduler",
                     data: "{balFileLocation:'" + balFileLocation + "', balFileName:'" + balFileName + "', balImportType:'" + balImportType + "', balArchiveDays:'" + balArchiveDays +
                         "', schBalBasis:'" + schBalBasis + "', schBalDailyTimeFormat:'" + schBalDailyTimeFormat + "', schBalDailyIntMins:'" + schBalDailyIntMins + "', schBalDailyStTime:'" + schBalDailyStTime +
                         "', schBalDailyEndTime:'" + schBalDailyEndTime + "', schBalWeekDay:'" + schBalWeekDay + "', schBalWeekTime:'" + schBalWeekTime + "', schBalMonthDay:'" + schBalMonthDay + "', schBalMonthTime:'" + schBalMonthTime +
                         "', custFileLocation:'" + custFileLocation + "', custFileName:'" + custFileName + "', custImportType:'" + custImportType + "', schCustBasis:'" + schCustBasis + "', schCustDailyTimeFormat:'" + schCustDailyTimeFormat + "', schCustDailyIntMins:'" + schCustDailyIntMins + "', schCustDailyStTime:'" + schCustDailyStTime +
                         "', schCustDailyEndTime:'" + schCustDailyEndTime + "', schCustWeekDay:'" + schCustWeekDay + "', schCustWeekTime:'" + schCustWeekTime + "', schCustMonthDay:'" + schCustMonthDay + "', schCustMonthTime:'" + schCustMonthTime +
                         "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         //data = data.d[0];
                         if (data.d.length > 0) {
                             if (data.d[0] == "0") {
                                 $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                 $('#<%=RTlblError.ClientID%>').removeClass();
                                 $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                 loadAccntImportScheduler();
                             }
                             else if (data.d[0]=="Invalid") {
                                 $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('FLNV', '', ''));
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

         function resetScheduler() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 loadAccntImportScheduler();
             }
         }

     </script>


      <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblHeader" runat="server" Text="Account Import Scheduler"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
     </div>

     <div id="divLADetails" class="ui raised segment signup inactive">
         <div class="ui form">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A1" runat="server" class="active item">Balance</a>  
            </div>
            <div class="four fields" style="padding-bottom:0.5em;">
                <div style="width:300px">
                    <asp:Label ID="lblBalFileLocation" runat="server" Text="File Location" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtBalFileLocation" runat="server"  Width="160px"></asp:TextBox>
                </div>
                <div style="width:300px">
                    <asp:Label ID="lblBalFileName" runat="server" Text="File Name" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtBalFileName" runat="server"  Width="153px"></asp:TextBox>
                </div>
                <div style="width:300px">
                     <asp:Label ID="lblBalImportType" runat="server" Text="Import Type" Width="100px" ></asp:Label>
                     <asp:DropDownList ID="ddlBalImporType" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>
                <div style="width:300px">
                    <asp:Label ID="lblBalArchiveDays" runat="server" Text="Archive Days" Width="100px"></asp:Label>
                     <asp:TextBox ID="txtBalArchiveDays" runat="server"  Width="100px"></asp:TextBox>
                </div>
            </div>
         </div>

         <div class="ui form" style="padding-left:1em;">
            <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
                <a id="A8" runat="server" class="active item">Schedule</a>  
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnBalDaily" GroupName="grpSchedule" runat="server" Text="Daily" Width="60px"  />
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalEvery" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtBalDailyEvery" runat="server" Width="80px" ></asp:TextBox>
                </div>
                <div class="field" style="width:150px">
                    <asp:DropDownList ID="drpBalance_Everyhour" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtBalDailyStTime" runat="server" Width="80px" ></asp:TextBox>
                </div>  
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtBalDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
                </div>                         
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnBalWeekly" GroupName="grpSchedule" runat="server" Text="Weekly" Width="63px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlBalWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalTime" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtBalWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
           <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnBalMonthly" GroupName="grpSchedule" runat="server" Text="Monthly" Width="68px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlBalMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblBalTime2" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtBalMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
        </div>
        <div class="ui form">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A2" runat="server" class="active item">Customer</a>  
            </div>
            <div class="four fields" style="padding-bottom:0.5em;">
                <div style="width:300px">
                    <asp:Label ID="lblCustLocation" runat="server" Text="File Location" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtCustFileLocation" runat="server"  Width="160px"></asp:TextBox>
                </div>
                <div style="width:300px">
                    <asp:Label ID="lblCustName" runat="server" Text="File Name" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtCustFileName" runat="server"  Width="153px"></asp:TextBox>
                </div>
                <div style="width:300px">
                     <asp:Label ID="lblCustImportType" runat="server" Text="Import Type" Width="100px" ></asp:Label>
                     <asp:DropDownList ID="ddlCustImportType" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>
                
            </div>
         </div>
         <div class="ui form" style="padding-left:1em;">
            <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
                <a id="A3" runat="server" class="active item">Schedule</a>  
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnCustDaily" GroupName="grpCustSchedule" runat="server" Text="Daily" Width="60px"  />
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustEvery" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtCustDailyEvery" runat="server" Width="80px" ></asp:TextBox>
                </div>
                <div class="field" style="width:150px">
                    <asp:DropDownList ID="drpCustomer_Everyhour" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtCustDailyStTime" runat="server" Width="80px" ></asp:TextBox>
                </div>  
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtCustDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
                </div>                         
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnCustWeekly" GroupName="grpCustSchedule" runat="server" Text="Weekly" Width="63px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlCustWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustTime" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtCustWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
           <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnCustMonthly" GroupName="grpCustSchedule" runat="server" Text="Monthly" Width="68px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlCustMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblCustTime2" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtCustMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
        </div>
        <div style="text-align:center">
            <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveAccntImportScheduler()"/>
            <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetScheduler()" />
        </div>
     </div>


</asp:Content>
