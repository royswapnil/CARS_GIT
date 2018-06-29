<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmOrderImportExportScheduler.aspx.vb" Inherits="CARS.frmOrderImportExportScheduler" MasterPageFile="~/MasterPage.Master"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">
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

         function fnClientOrdImpValidate() {
             if (!(gfi_CheckEmpty($('#<%=txtOrdImpFileLocation.ClientID%>'), 'FU032'))) {
                 $('#<%= txtOrdImpFileLocation.ClientID%>').focus();
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtOrdImpFileName.ClientID%>'), 'FN001'))) {
                 $('#<%= txtOrdImpFileName.ClientID%>').focus();
                 return false;
             }
             if (!(CheckExtension(document.getElementById("<%= txtOrdImpFileName.ClientID%>")))) {
                 alert(GetMultiMessage('FN002', '', ''));
                 $('#<%= txtOrdImpFileName.ClientID%>').focus();
                 return false;
             }


             if ((document.getElementById("<%= rbtnOrdImpDaily.ClientID %>").checked == false) && (document.getElementById("<%= rbtnOrdImpWeekly.ClientID %>").checked == false) && (document.getElementById("<%= rbtnOrdImpMonthly.ClientID %>").checked == false)) {
                 alert(GetMultiMessage('FU034', '', ''));
                 return false;
             }
             

             if (document.getElementById("<%= rbtnOrdImpDaily.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtOrdImpDailyEvery.ClientID%>'), '0532'))) {
                     $('#<%= txtOrdImpDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if ($('#<%= txtOrdImpDailyEvery.ClientID%>').value == "0") {
                     msg = GetMultiMessage('1779', '', '');
                     alert(msg);
                     $('#<%= txtOrdImpDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if (!(gfi_ValidateNumber($('#<%= txtOrdImpDailyEvery.ClientID%>'), '0532'))) {
                     $('#<%= txtOrdImpDailyEvery.ClientID %>').focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpOrdImp_Everyhour.ClientID%>").selectedIndex == 0 && document.getElementById("<%= txtOrdImpDailyEvery.ClientID%>").value > 24) {
                     msg = GetMultiMessage('1775', '', '');
                     alert(msg);
                     document.getElementById("<%= drpOrdImp_Everyhour.ClientID%>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpOrdImp_Everyhour.ClientID%>").selectedIndex == 1 && document.getElementById("<%= txtOrdImpDailyEvery.ClientID%>").value > 60) {
                     msg = GetMultiMessage('1776', '', '');
                     alert(msg);
                     document.getElementById("<%= drpOrdImp_Everyhour.ClientID%>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtOrdImpDailyStTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdImpDailyStTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdImpDailyStTime.ClientID %>").value))) {
                     document.getElementById("<%= txtOrdImpDailyStTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdImpDailyStTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtOrdImpDailyEndTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdImpDailyEndTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdImpDailyEndTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdImpDailyEndTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdImpDailyEndTime.ClientID%>").focus();
                     return false;
                 }
             }
             if (document.getElementById("<%= rbtnOrdImpWeekly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= rbtnOrdImpWeekly.ClientID%>'), '0532'))) {
                     document.getElementById("<%= rbtnOrdImpWeekly.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdImpWeeklyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdImpWeeklyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdImpWeeklyTime.ClientID%>").focus();
                     return false;
                 }
             }
             if (document.getElementById("<%= rbtnOrdImpMonthly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtOrdImpMonthlyTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdImpMonthlyTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdImpMonthlyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdImpMonthlyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdImpMonthlyTime.ClientID %>").focus();
                     return false;
                 }
             }

             return true;
         }

         function fnClientOrderExpValidate(){
             if ((document.getElementById("<%= rbtnOrdExpDaily.ClientID%>").checked == false) && (document.getElementById("<%= rbtnOrdExpWeekly.ClientID%>").checked == false) && (document.getElementById("<%= rbtnOrdExpMonthly.ClientID %>").checked == false)) {
                 alert(GetMultiMessage('FU034', '', ''));
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtOrdExpFileLocation.ClientID%>'), 'FU032'))) {
                 document.getElementById("<%= txtOrdExpFileLocation.ClientID%>").focus();
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%= txtOrdExpFileName.ClientID%>'), 'FN001'))) {
                 document.getElementById("<%= txtOrdExpFileName.ClientID %>").focus();
                 return false;
             }
             if (!(CheckExtension(document.getElementById("<%= txtOrdExpFileName.ClientID%>"))))  {
                 alert(GetMultiMessage('FN002', '', ''))
                 document.getElementById("<%= txtOrdExpFileName.ClientID%>").focus();
                 return false;
             }


             if (document.getElementById("<%= rbtnOrdExpDaily.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtOrdExpDailyEvery.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").value == "0") {
                     msg = GetMultiMessage('1779', '', '')
                     alert(msg)
                     document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").focus();
                     return false
                 }

                 if (!(gfi_ValidateNumber($('#<%= txtOrdExpDailyEvery.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").focus();
                     return false;
                 }

                 if (document.getElementById("<%= drpOrdExp_Everyhour.ClientID%>").selectedIndex == 0 && document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").value > 24) {
                     msg = GetMultiMessage('1775', '', '')
                     alert(msg)
                     document.getElementById("<%= drpOrdExp_Everyhour.ClientID%>").focus();
                     return false
                 }

                 if (document.getElementById("<%= drpOrdExp_Everyhour.ClientID%>").selectedIndex == 1 && document.getElementById("<%= txtOrdExpDailyEvery.ClientID%>").value > 60) {
                     msg = GetMultiMessage('1776', '', '')
                     alert(msg);
                     document.getElementById("<%= drpOrdExp_Everyhour.ClientID%>").focus();
                     return false
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtOrdExpDailyStTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdExpDailyStTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdExpDailyStTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdExpDailyStTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdExpDailyStTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(gfi_CheckEmpty($('#<%= txtOrdExpDailyEndTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdExpDailyEndTime.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdExpDailyEndTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdExpDailyEndTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdExpDailyEndTime.ClientID%>").focus();
                     return false;
                 }
             }

             if (document.getElementById("<%= rbtnOrdExpWeekly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= rbtnOrdExpWeekly.ClientID%>'), '0532'))) {
                     document.getElementById("<%= rbtnOrdExpWeekly.ClientID%>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdExpWeeklyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdExpWeeklyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdExpWeeklyTime.ClientID%>").focus();
                     return false;
                 }
             }

             if (document.getElementById("<%= rbtnOrdExpMonthly.ClientID%>").checked == true) {
                 if (!(gfi_CheckEmpty($('#<%= txtOrdExpMonthlyTime.ClientID%>'), '0532'))) {
                     document.getElementById("<%= txtOrdExpMonthlyTime.ClientID %>").focus();
                     return false;
                 }

                 if (!(IsValidTime(document.getElementById("<%= txtOrdExpMonthlyTime.ClientID%>").value))) {
                     document.getElementById("<%= txtOrdExpMonthlyTime.ClientID%>").value = "";
                     document.getElementById("<%= txtOrdExpMonthlyTime.ClientID %>").focus();
                     return false;
                 }
             }
             return true;
         }

         $(document).ready(function () {
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             loadOrderImpExpScheduler();

             $(document).on('click', '#<%=rbtnOrdImpDaily.ClientID%>', function () {
                 fnOrdImpChangeMode();
             });

             $(document).on('click', '#<%=rbtnOrdImpWeekly.ClientID%>', function () {
                 fnOrdImpChangeMode();
             });

             $(document).on('click', '#<%=rbtnOrdImpMonthly.ClientID%>', function () {
                 fnOrdImpChangeMode();
             });

             $(document).on('click', '#<%=rbtnOrdExpDaily.ClientID%>', function () {
                 fnOrdExpChangeMode();
             });

             $(document).on('click', '#<%=rbtnOrdExpWeekly.ClientID%>', function () {
                 fnOrdExpChangeMode();
             });

             $(document).on('click', '#<%=rbtnOrdExpMonthly.ClientID%>', function () {
                 fnOrdExpChangeMode();
             });

             function fnOrdImpChangeMode() {
                 if (document.getElementById('<%=rbtnOrdImpDaily.ClientID%>').checked == true) {
                     enableOrdImpDisableDaily(false)
                     enableOrdImpDisableWeek(true)
                     enableOrdImpDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnOrdImpWeekly.ClientID%>').checked == true) {
                     enableOrdImpDisableDaily(true)
                     enableOrdImpDisableWeek(false)
                     enableOrdImpDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnOrdImpMonthly.ClientID%>').checked == true) {
                     enableOrdImpDisableDaily(true)
                     enableOrdImpDisableWeek(true)
                     enableOrdImpDisableMonth(false)
                 }
             }

             function fnOrdExpChangeMode() {
                 if (document.getElementById('<%=rbtnOrdExpDaily.ClientID%>').checked == true) {
                     enableOrdExpDisableDaily(false)
                     enableOrdExpDisableWeek(true)
                     enableOrdExpDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnOrdExpWeekly.ClientID%>').checked == true) {
                     enableOrdExpDisableDaily(true)
                     enableOrdExpDisableWeek(false)
                     enableOrdExpDisableMonth(true)
                 }
                 if (document.getElementById('<%=rbtnOrdExpMonthly.ClientID%>').checked == true) {
                     enableOrdExpDisableDaily(true)
                     enableOrdExpDisableWeek(true)
                     enableOrdExpDisableMonth(false)
                 }
             }

             $('#<%=txtOrdImpDailyStTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdImpDailyStTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpDailyStTime.ClientID%>'));
                 }
             });

             $('#<%=txtOrdImpDailyEndTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdImpDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpDailyEndTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdImpDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpDailyEndTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdImpDailyEndTime.ClientID%>').val()))) {
                         $('#<%=txtOrdImpDailyEndTime.ClientID%>').val("");
                         $('#<%=txtOrdImpDailyEndTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtOrdImpWeeklyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdImpWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpWeeklyTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdImpWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpWeeklyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdImpWeeklyTime.ClientID%>').val()))) {
                         $('#<%=txtOrdImpWeeklyTime.ClientID%>').val("");
                         $('#<%=txtOrdImpWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtOrdImpMonthlyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdImpMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpMonthlyTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdImpMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdImpMonthlyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdImpMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtOrdImpMonthlyTime.ClientID%>').val("");
                         $('#<%=txtOrdImpMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             //OrdExpomer
             $('#<%=txtOrdExpDailyStTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdExpDailyStTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpDailyStTime.ClientID%>'));
                 }
             });

             $('#<%=txtOrdExpDailyEndTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdExpDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpDailyEndTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdExpDailyEndTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpDailyEndTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdExpDailyEndTime.ClientID%>').val()))) {
                         $('#<%=txtOrdExpDailyEndTime.ClientID%>').val("");
                         $('#<%=txtOrdExpDailyEndTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtOrdExpWeeklyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdExpWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpWeeklyTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdExpWeeklyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpWeeklyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdExpWeeklyTime.ClientID%>').val()))) {
                         $('#<%=txtOrdExpWeeklyTime.ClientID%>').val("");
                         $('#<%=txtOrdExpWeeklyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });

             $('#<%=txtOrdExpMonthlyTime.ClientID%>').change(function (e) {
                 if ($('#<%=txtOrdExpMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpMonthlyTime.ClientID%>'));
                 }

                 if ($('#<%=txtOrdExpMonthlyTime.ClientID%>').val() != '') {
                     Validatetime($('#<%=txtOrdExpMonthlyTime.ClientID%>'));
                     if (!(IsValidTime($('#<%=txtOrdExpMonthlyTime.ClientID%>').val()))) {
                         $('#<%=txtOrdExpMonthlyTime.ClientID%>').val("");
                         $('#<%=txtOrdExpMonthlyTime.ClientID%>').focus();
                         return false;
                     }
                 }
             });


         });//end of ready


         function loadOrderImpExpScheduler() {

             var mydata;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmOrderImportExportScheduler.aspx/LoadImpExpScheduler",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         if (data.d[0].length > 0) {
                             $('#<%=txtOrdImpFileLocation.ClientID%>').val(data.d[0][0].Import_FileLocation);
                             $('#<%=txtOrdImpFileName.ClientID%>').val(data.d[0][0].Import_FileName);
                             $('#<%=txtOrdExpFileLocation.ClientID%>').val(data.d[1][0].Export_FileLocation);
                             $('#<%=txtOrdExpFileName.ClientID%>').val(data.d[1][0].Export_FileName);

                             if (data.d[0][0].Import_Sch_Basis == "D") {
                                 enableOrdImpDisableDaily(false);
                                 enableOrdImpDisableWeek(true);
                                 enableOrdImpDisableMonth(true);
                                 $('#<%=rbtnOrdImpDaily.ClientID%>').attr('checked', true);
                                 $('#<%=txtOrdImpDailyEvery.ClientID%>').val(data.d[0][0].Import_Sch_Daily_Interval_mins);
                                 $('#<%=txtOrdImpDailyStTime.ClientID%>').val(data.d[0][0].Import_Sch_Daily_STime);
                                 $('#<%=txtOrdImpDailyEndTime.ClientID%>').val(data.d[0][0].Import_Sch_Daily_ETime);
                                 $('#<%=drpOrdExp_Everyhour.ClientID%> option:contains("' + data.d[0][0].Import_Sch_TimeFormat + '")').attr('selected', 'selected');
                             } else if (data.d[0][0].Import_Sch_Basis == "M") {
                                 enableOrdImpDisableDaily(true);
                                 enableOrdImpDisableWeek(true);
                                 enableOrdImpDisableMonth(false);
                                 $('#<%=rbtnOrdImpMonthly.ClientID%>').attr('checked', true);
                                 $('#<%=txtOrdImpMonthlyTime.ClientID%>').val(data.d[0][0].Import_Sch_Month_Time);
                                 $('#<%=ddlOrdImpMonthly.ClientID%>')[0].selectedIndex = data.d[0][0].Import_Sch_Month_Day;

                             } else if (data.d[0][0].Import_Sch_Basis == "W") {
                                 enableOrdImpDisableDaily(true);
                                 enableOrdImpDisableWeek(false);
                                 enableOrdImpDisableMonth(true);
                                 $('#<%=rbtnOrdImpWeekly.ClientID%>').attr('checked', true);
                                 $('#<%=ddlOrdImpWeeklyEvery.ClientID%>')[0].selectedIndex = data.d[0][0].Import_Sch_Week_Day;
                                 $('#<%=txtOrdImpWeeklyTime.ClientID%>').val(data.d[0][0].Import_Sch_Week_Time);
                             }

                             if (data.d[1][0].Export_Sch_Basis == "D") {
                                 enableOrdExpDisableDaily(false);
                                 enableOrdExpDisableWeek(true);
                                 enableOrdExpDisableMonth(true);
                                 $('#<%=rbtnOrdExpDaily.ClientID%>').attr('checked', true);
                                 $('#<%=txtOrdExpDailyEvery.ClientID%>').val(data.d[1][0].Export_Sch_Daily_Interval_mins);
                                 $('#<%=txtOrdExpDailyStTime.ClientID%>').val(data.d[1][0].Export_Sch_Daily_STime);
                                 $('#<%=txtOrdExpDailyEndTime.ClientID%>').val(data.d[1][0].Export_Sch_Daily_ETime);
                                 $('#<%=drpOrdExp_Everyhour.ClientID%> option:contains("' + data.d[1][0].Export_Sch_TimeFormat + '")').attr('selected', 'selected');
                             } else if (data.d[1][0].Export_Sch_Basis == "M") {
                                 enableOrdExpDisableDaily(true);
                                 enableOrdExpDisableWeek(true);
                                 enableOrdExpDisableMonth(false);
                                 $('#<%=rbtnOrdExpMonthly.ClientID%>').attr('checked', true);
                                 $('#<%=txtOrdExpMonthlyTime.ClientID%>').val(data.d[1][0].Export_Sch_Month_Time);
                                 $('#<%=ddlOrdExpMonthly.ClientID%>')[0].selectedIndex = data.d[1][0].Export_Sch_Month_Day;

                             } else if (data.d[1][0].Export_Sch_Basis == "W") {
                                 enableOrdExpDisableDaily(true);
                                 enableOrdExpDisableWeek(false);
                                 enableOrdExpDisableMonth(true);
                                 $('#<%=rbtnOrdExpWeekly.ClientID%>').attr('checked', true);
                                 $('#<%=ddlOrdExpWeeklyEvery.ClientID%>')[0].selectedIndex = data.d[1][0].Export_Sch_Week_Day;
                                 $('#<%=txtOrdExpWeeklyTime.ClientID%>').val(data.d[1][0].Export_Sch_Week_Time);
                             }
                         }

                         loadOrdImpImportType(data.d[2]);
                         

                         if (data.d[0].length > 0) {
                             if (data.d[0][0].Import_Template == "") {
                                 $('#<%=ddlOrdImpImporType.ClientID%>')[0].selectedIndex = 0;
                             } else {
                                 $('#<%=ddlOrdImpImporType.ClientID%>').val(data.d[0][0].Import_Template);
                             }
                         } else {
                             $('#<%=ddlOrdImpImporType.ClientID%>').val(data.d[0][0].Import_Template);
                         }

                     }
                 }
             });
         }

         function loadOrdImpImportType(data) {
             $('#<%=ddlOrdImpImporType.ClientID%>').empty();
             $('#<%=ddlOrdImpImporType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlOrdImpImporType.ClientID%>').append($("<option></option>").val(value.Template_Id).html(value.Template_Name));
             });
             return true;
         }
         
         function enableOrdImpDisableDaily(VisibleType) {
             document.getElementById('<%=txtOrdImpDailyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=drpOrdExp_Everyhour.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdImpDailyStTime.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdImpDailyEndTime.ClientID%>').disabled = VisibleType;
         }

         function enableOrdImpDisableWeek(VisibleType) {
             document.getElementById('<%=ddlOrdImpWeeklyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdImpWeeklyTime.ClientID%>').disabled = VisibleType;
         }

         function enableOrdImpDisableMonth(VisibleType) {
             document.getElementById('<%=ddlOrdImpMonthly.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdImpMonthlyTime.ClientID%>').disabled = VisibleType;
         }

         function enableOrdExpDisableDaily(VisibleType) {
             document.getElementById('<%=txtOrdExpDailyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=drpOrdExp_Everyhour.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdExpDailyStTime.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdExpDailyEndTime.ClientID%>').disabled = VisibleType;
         }

         function enableOrdExpDisableWeek(VisibleType) {
             document.getElementById('<%=ddlOrdExpWeeklyEvery.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdExpWeeklyTime.ClientID%>').disabled = VisibleType;
         }

         function enableOrdExpDisableMonth(VisibleType) {
             document.getElementById('<%=ddlOrdExpMonthly.ClientID%>').disabled = VisibleType;
             document.getElementById('<%=txtOrdExpMonthlyTime.ClientID%>').disabled = VisibleType;
         }


         function saveOrderImportScheduler() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnClientOrdImpValidate()
             if (result == true) {
             var impFileName = $('#<%=txtOrdImpFileName.ClientID%>').val();
             var impFileLocation = $('#<%=txtOrdImpFileLocation.ClientID%>').val();
             var impImportType = $('#<%=ddlOrdImpImporType.ClientID%>').val();
                 var schImpBasis, schImpDailyTimeFormat, schImpDailyIntMins, schImpDailyStTime, schImpDailyEndTime, schImpWeekDay, schImpWeekTime, schImpMonthDay, schImpMonthTime;

                 impFileLocation = impFileLocation.replace(/\\/g, "/");

                 if ($("#<%=rbtnOrdImpDaily.ClientID%>").is(':checked')) {
                     schImpBasis = "D";
                     schImpDailyTimeFormat = $("#<%=drpOrdImp_Everyhour.ClientID%>").val();
                     schImpDailyIntMins = $("#<%=txtOrdImpDailyEvery.ClientID%>").val();
                     schImpDailyStTime = $("#<%=txtOrdImpDailyStTime.ClientID%>").val();
                     schImpDailyEndTime = $("#<%=txtOrdImpDailyEndTime.ClientID%>").val();
                     schImpWeekDay = "0";
                     schImpWeekTime = "";
                     schImpMonthDay = "0";
                     schImpMonthTime = "";

                 } else if ($("#<%=rbtnOrdImpWeekly.ClientID%>").is(':checked')) {
                     schImpBasis = "W";
                     schImpWeekDay = $('#<%=ddlOrdImpWeeklyEvery.ClientID%>')[0].selectedIndex;
                     schImpWeekTime = $("#<%=txtOrdImpWeeklyTime.ClientID%>").val();
                     schImpDailyTimeFormat = "";
                     schImpDailyIntMins = "0";
                     schImpDailyStTime = "";
                     schImpDailyEndTime = "";
                     schImpMonthDay = "1";
                     schImpMonthTime = "";
                 } else if ($("#<%=rbtnOrdImpMonthly.ClientID%>").is(':checked')) {
                     schImpBasis = "M";
                     schImpMonthDay = $("#<%=ddlOrdImpMonthly.ClientID%>").val();
                     schImpMonthTime = $("#<%=txtOrdImpMonthlyTime.ClientID%>").val();
                     schImpWeekDay = "0";
                     schImpWeekTime = "";
                     schImpDailyTimeFormat = "";
                     schImpDailyIntMins = "0";
                     schImpDailyStTime = "";
                     schImpDailyEndTime = "";
                 }

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmOrderImportExportScheduler.aspx/SaveOrdImportScheduler",
                     data: "{impFileLocation:'" + impFileLocation + "', impFileName:'" + impFileName + "', impImportType:'" + impImportType + "', schImpBasis:'" + schImpBasis +
                         "', schImpDailyTimeFormat:'" + schImpDailyTimeFormat + "', schImpDailyIntMins:'" + schImpDailyIntMins + "', schImpDailyStTime:'" + schImpDailyStTime + "', schImpDailyEndTime:'" + schImpDailyEndTime +
                         "', schImpWeekDay:'" + schImpWeekDay + "', schImpWeekTime:'" + schImpWeekTime + "', schImpMonthDay:'" + schImpMonthDay + "', schImpMonthTime:'" + schImpMonthTime + 
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
                                 loadOrderImpExpScheduler();
                             }
                             else if (data.d[0] == "Invalid") {
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

         function saveOrderExportScheduler() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnClientOrderExpValidate();
             if (result == true) {
             var expFileName = $('#<%=txtOrdExpFileName.ClientID%>').val();
             var expFileLocation = $('#<%=txtOrdExpFileLocation.ClientID%>').val();
             var schExpBasis, schExpDailyTimeFormat, schExpDailyIntMins, schExpDailyStTime, schExpDailyEndTime, schExpWeekDay, schExpWeekTime, schExpMonthDay, schExpMonthTime;

             expFileLocation = expFileLocation.replace(/\\/g, "/");

             if ($("#<%=rbtnOrdExpDaily.ClientID%>").is(':checked')) {
                 schExpBasis = "D";
                 schExpDailyTimeFormat = $("#<%=drpOrdExp_Everyhour.ClientID%>").val();
                 schExpDailyIntMins = $("#<%=txtOrdExpDailyEvery.ClientID%>").val();
                 schExpDailyStTime = $("#<%=txtOrdExpDailyStTime.ClientID%>").val();
                 schExpDailyEndTime = $("#<%=txtOrdExpDailyEndTime.ClientID%>").val();
                 schExpWeekDay = "0";
                 schExpWeekTime = "";
                 schExpMonthDay = "0";
                 schExpMonthTime = "";

             } else if ($("#<%=rbtnOrdExpWeekly.ClientID%>").is(':checked')) {
                 schExpBasis = "W";
                 schExpWeekDay = $('#<%=ddlOrdExpWeeklyEvery.ClientID%>')[0].selectedIndex;
                 schExpWeekTime = $("#<%=txtOrdExpWeeklyTime.ClientID%>").val();
                 schExpDailyTimeFormat = "";
                 schExpDailyIntMins = "0";
                 schExpDailyStTime = "";
                 schExpDailyEndTime = "";
                 schExpMonthDay = "1";
                 schExpMonthTime = "";
             } else if ($("#<%=rbtnOrdExpMonthly.ClientID%>").is(':checked')) {
                 schExpBasis = "M";
                 schExpMonthDay = $("#<%=ddlOrdExpMonthly.ClientID%>").val();
                 schExpMonthTime = $("#<%=txtOrdExpMonthlyTime.ClientID%>").val();
                 schExpWeekDay = "0";
                 schExpWeekTime = "";
                 schExpDailyTimeFormat = "";
                 schExpDailyIntMins = "0";
                 schExpDailyStTime = "";
                 schExpDailyEndTime = "";
             }

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmOrderImportExportScheduler.aspx/SaveOrdExportScheduler",
                 data: "{expFileLocation:'" + expFileLocation + "', expFileName:'" + expFileName + "', schExpBasis:'" + schExpBasis +
                     "', schExpDailyTimeFormat:'" + schExpDailyTimeFormat + "', schExpDailyIntMins:'" + schExpDailyIntMins + "', schExpDailyStTime:'" + schExpDailyStTime + "', schExpDailyEndTime:'" + schExpDailyEndTime +
                     "', schExpWeekDay:'" + schExpWeekDay + "', schExpWeekTime:'" + schExpWeekTime + "', schExpMonthDay:'" + schExpMonthDay + "', schExpMonthTime:'" + schExpMonthTime +
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
                             loadOrderImpExpScheduler();
                         }
                         else if (data.d[0] == "Invalid") {
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

         function resetOrderExportScheduler() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 loadOrderImpExpScheduler();
             }
         }

         function resetOrderImportScheduler() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 loadOrderImpExpScheduler();
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
                <a id="A1" runat="server" class="active item">Order Import Scheduler </a>  
            </div>
            <div class="four fields" style="padding-bottom:0.5em;">
                <div style="width:300px">
                    <asp:Label ID="lblOrdImpFileLocation" runat="server" Text="File Location" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtOrdImpFileLocation" runat="server"  Width="160px"></asp:TextBox>
                </div>
                <div style="width:300px">
                    <asp:Label ID="lblOrdImpFileName" runat="server" Text="File Name" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtOrdImpFileName" runat="server"  Width="153px"></asp:TextBox>
                </div>
                <div style="width:300px">
                     <asp:Label ID="lblOrdImpImportType" runat="server" Text="Import Type" Width="100px" ></asp:Label>
                     <asp:DropDownList ID="ddlOrdImpImporType" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>
<%--                <div style="width:300px">
                    <asp:Label ID="lblOrdImpArchiveDays" runat="server" Text="Archive Days" Width="100px"></asp:Label>
                     <asp:TextBox ID="txtOrdImpArchiveDays" runat="server"  Width="100px"></asp:TextBox>
                </div>--%>
            </div>
         </div>

         <div class="ui form" style="padding-left:1em;">
            <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
                <a id="A8" runat="server" class="active item">Schedule</a>  
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdImpDaily" GroupName="grpSchedule" runat="server" Text="Daily" Width="60px"  />
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpEvery" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdImpDailyEvery" runat="server" Width="80px" ></asp:TextBox>
                </div>
                <div class="field" style="width:150px">
                    <asp:DropDownList ID="drpOrdImp_Everyhour" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdImpDailyStTime" runat="server" Width="80px" ></asp:TextBox>
                </div>  
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdImpDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
                </div>                         
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdImpWeekly" GroupName="grpSchedule" runat="server" Text="Weekly" Width="63px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlOrdImpWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpTime" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdImpWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
           <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdImpMonthly" GroupName="grpSchedule" runat="server" Text="Monthly" Width="68px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlOrdImpMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdImpTime2" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdImpMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
            <div style="text-align:center">
                <input id="btnSaveOrdImp" class="ui button" runat="server"  value="Save" type="button" onclick="saveOrderImportScheduler()"/>
                <input id="btnResetOrdImp" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetOrderImportScheduler()" />
            </div>
        </div>
        <div class="ui form">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A2" runat="server" class="active item">Order Export Scheduler </a>  
            </div>
            <div class="four fields" style="padding-bottom:0.5em;">
                <div style="width:300px">
                    <asp:Label ID="lblOrdExpLocation" runat="server" Text="File Location" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtOrdExpFileLocation" runat="server"  Width="160px"></asp:TextBox>
                </div>
                <div style="width:300px">
                    <asp:Label ID="lblOrdExpName" runat="server" Text="File Name" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtOrdExpFileName" runat="server"  Width="153px"></asp:TextBox>
                </div>
                <%--<div style="width:300px">
                     <asp:Label ID="lblOrdExpImportType" runat="server" Text="Import Type" Width="100px" ></asp:Label>
                     <asp:DropDownList ID="ddlOrdExpImportType" runat="server" Width="120px" style="display:inline"></asp:DropDownList>
                </div>--%>
                
            </div>
         </div>
         <div class="ui form" style="padding-left:1em;">
            <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
                <a id="A3" runat="server" class="active item">Schedule</a>  
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdExpDaily" GroupName="grpOrdExpSchedule" runat="server" Text="Daily" Width="60px"  />
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpEvery" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdExpDailyEvery" runat="server" Width="80px" ></asp:TextBox>
                </div>
                <div class="field" style="width:150px">
                    <asp:DropDownList ID="drpOrdExp_Everyhour" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdExpDailyStTime" runat="server" Width="80px" ></asp:TextBox>
                </div>  
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdExpDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
                </div>                         
            </div>
            <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdExpWeekly" GroupName="grpOrdExpSchedule" runat="server" Text="Weekly" Width="63px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlOrdExpWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpTime" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdExpWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
           <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnOrdExpMonthly" GroupName="grpOrdExpSchedule" runat="server" Text="Monthly" Width="68px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlOrdExpMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblOrdExpTime2" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtOrdExpMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
           </div>
        </div>
        <div style="text-align:center">
            <input id="btnSaveOrdExp" class="ui button" runat="server"  value="Save" type="button" onclick="saveOrderExportScheduler()"/>
            <input id="btnResetOrdExp" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetOrderExportScheduler()" />
        </div>
     </div>

</asp:Content>