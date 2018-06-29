<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfGeneral.aspx.vb" Inherits="CARS.frmCfGeneral" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 
     <script type="text/javascript">
         function fnValidateTime() {
             if (document.getElementById('<%=txtMinimumSplits.ClientID%>').value.length == 0)
                 return;

             Validatetime($('#<%=txtMinimumSplits.ClientID%>'));
         }

         function fnValidateZipCode() {
             if (!(gfi_CheckEmpty($('#<%=txtZipCode.ClientID%>'), '0191')))
                 return false;

             if (!(gfb_ValidateAlphabets($('#<%=txtZipCode.ClientID%>'), '0191')))
                 return false;
            
             if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193')))
                 return false;

             if (!(gfb_ValidateAlphabets($('#<%=txtCity.ClientID%>'), '0194')))
                 return false;

             return true;
             window.scrollTo(0, 0);
         }

         function fnValidateMinSpilt() {
             if (!(gfi_CheckEmpty($('#<%=txtMinimumSplits.ClientID%>'), 'MINSPLIT')))
                 return false;

             return true;
             window.scrollTo(0, 0);
         }

         function fnValidateDiscCode() {
             if (!(gfi_CheckEmpty($('#<%=txtDiscCode.ClientID%>'), '0148')))
                 return false;

             if (!(gfb_ValidateAlphabets($('#<%=txtDiscCode.ClientID%>'), '0148')))
                 return false;

             return true;
             window.scrollTo(0, 0);
         }

         function fnValidateVATCode() {
             if (!(gfi_CheckEmpty($('#<%=txtVATCode.ClientID%>'), '0149'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtVATCode.ClientID%>'), '0149')))
                 return false;

             var gmr;
             gmr = $('#<%=txtVatPercentage.ClientID%>').val();

             if (!(gfi_CheckEmpty($('#<%=txtVatPercentage.ClientID%>'), 'VATPER', ''))) {
                 return false;
             }
             if (!(fn_ValidateDecimal(document.getElementById('<%=txtVatPercentage.ClientID%>'), '<%= Session("Decimal_Seperator") %>'))) {
                 var msg = GetMultiMessage('0116', GetMultiMessage('VATPER', '', ''), '');
                 alert(msg);
                 $('#<%=txtVatPercentage.ClientID%>').focus();
                 return false;
             }

             if (gmr > 100 || gmr == '.') {
                 var msg = GetMultiMessage('0116', GetMultiMessage('VATPER', '', ''), '');
                 alert(msg);
                 return false;
             }
             if (!(gfi_ValidateNumDot($('#<%=txtVatPercentage.ClientID%>'), 'VATPER'))) {
                 return false;
             }

             if (!(gfi_ValidateNumber($('#<%=txtExtVAT.ClientID%>'), $('#<%=lblExtVATCode.ClientID%>')))) {
                 return false;
             }

             if (!(gfi_CheckEmpty($('#<%=txtExtAcc.ClientID%>'), 'ACCCODE', ''))) {
                 return false;
             }

             return true;

             window.scrollTo(0, 0);
         }

         function fnValidateReason() {
             if (!(gfi_CheckEmpty($('#<%=txtReason.ClientID%>'), '0195'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtReason.ClientID%>'), '0195')))
                 return false;

             return true;
             window.scrollTo(0, 0);
         }

         function fnValidateStatType() {
             if (!(gfi_CheckEmpty($('#<%=txtStationType.ClientID%>'), '0196')))
                 return false;

             if (!(gfb_ValidateAlphabets($('#<%=txtStationType.ClientID%>'), '0196')))
                 return false;

             return true;

             window.scrollTo(0, 0);
         }

         function fnValidateSMSGeneral() {
             if (!(gfi_CheckEmpty($('#<%=txtSMSMailServer.ClientID%>'), 'SMSMAILSRV')))
                 return false;

             if (!(gfi_ValidateNumber($('#<%=txtSMSNoChars.ClientID%>'), 'NOOFCHARS')))
                 return false;

             var ctrycode = $('#<%=txtSMSCtryCode.ClientID%>').val();
             var arrctrycode = ctrycode.split("+");

             if (ctrycode == "+") {
                 var msg = GetMultiMessage('CTRYCODE', '', '');
                 alert(msg);
                 return false;
             }
             else {
                 if (arrctrycode.length == 1) {
                     //Prefix not given
                     var fieldvalue = arrctrycode[0];
                     var valuelength = fieldvalue.length;

                     for (var ct = 0; ct <= valuelength - 1; ct++) {
                         var Onechar = fieldvalue.charAt(ct);
                         if (Onechar < "0" || Onechar > "9") {
                             var msg = GetMultiMessage('CTRYCODE', '', '');
                             alert(msg);
                             return false;
                         }
                     }
                 }
                 if (arrctrycode.length == 2) {
                     //Prefix given
                     var fieldvalue = arrctrycode[1];
                     var valuelength = fieldvalue.length;

                     for (var ct = 0; ct <= valuelength - 1; ct++) {
                         var Onechar = fieldvalue.charAt(ct);
                         if (Onechar < "0" || Onechar > "9") {
                             var msg = GetMultiMessage('CTRYCODE', '', '');
                             alert(msg);
                             return false;
                         }
                     }
                 }
                 if (arrctrycode.length > 2) {
                     //Invalid chars
                     var msg = GetMultiMessage('CTRYCODE', '', '');
                     alert(msg);
                     return false;
                 }
             }

             var startdigits = $('#<%=txtSMSStartDigits.ClientID%>').val();
             var arrdigits = startdigits.split("/");

             if (trimtext(startdigits) != "") {
                 if (startdigits == "/") {
                     var msg = GetMultiMessage('STDGTNUM', '', '');
                     alert(msg);
                     return false;
                 }
                 for (var ct = 0; ct <= arrdigits.length - 1; ct++) {
                     var Onechar = arrdigits[ct];
                     if (Onechar < 0 || Onechar > 9) {
                         var msg = GetMultiMessage('STSINGLE', '', '');
                         alert(msg);
                         return false;
                     }
                     if ((Onechar < "0" || Onechar > "9") && Onechar != "/") {
                         var msg = GetMultiMessage('STDGTNUM', '', '');
                         alert(msg);
                         return false;
                     }

                     var fieldvalue = Onechar;
                     var valuelength = fieldvalue.length;

                     for (var innerct = 0; innerct <= valuelength - 1; innerct++) {
                         var innerOnechar = fieldvalue.charAt(innerct);
                         if (innerOnechar < "0" || innerOnechar > "9") {
                             var msg = GetMultiMessage('STDGTNUM', '', '');
                             alert(msg);
                             return false;
                         }
                     }
                 }
             }

             return true;
             window.scrollTo(0, 0);
         }

         function fnValidateSMSDeptMsg() {
             if ($('#<%=ddlDept.ClientID%>')[0].selectedIndex == 0) {
                 var msg = GetMultiMessage('0007', GetMultiMessage('0049', '', ''), '');
                 alert(msg);
                 $('#<%=ddlDept.ClientID%>').focus();
                 return false;
             }
             return true;
             window.scrollTo(0, 0);
         }

         function trimtext(stringToTrim) {
             return stringToTrim.replace(/^\s+|\s+$/g, "");
         }


         $(document).ready(function () {
             $('#divZipCode').hide();
             $('#divDiscCode').hide();
             $('#divVATCode').hide();
             $('#divReason').hide();
             $('#divStationType').hide();
             $('#divDeptMess').hide();
             $("#accordion").accordion();
             var mydata, zipcodedata, disccodedata, vatcodedata, reasondata, stattypedata,deptmessdata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var gridZipCode = $("#dgdZipCode");
             var gridDiscCode = $("#dgdDiscCode");
             var gridVATCode = $("#dgdVATCode");
             var gridReason = $("#dgdReason");
             var gridStationType = $("#dgdStationType");
             var gridDeptMess = $("#dgdDeptMess");

             //ZipCode
             gridZipCode.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['ZipCode', 'Country', 'State', 'City',''],
                 colModel: [
                          { name: 'ZipCode', index: 'ZipCode', width: 160, sorttype: "string" },
                          { name: 'Country', index: 'Country', width: 160, sorttype: "string" },
                          { name: 'State', index: 'State', width: 160, sorttype: "string"},
                          { name: 'City', index: 'City', width: 160, sorttype: "string"},
                          { name: 'ZipCode', index: 'ZipCode', sortable: false, formatter: editZipCode }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerZipCode'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "ZipCode",
                 async: false, //Very important,
                 subgrid: false

             });

             //DiscCode
             gridDiscCode.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Description', 'IdConfig','IdSettings',''],
                 colModel: [
                          { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                          { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editDiscCode }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerDiscCode'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "DiscCode",
                 async: false, //Very important,
                 subgrid: false

             });

             //VATCode
             gridVATCode.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Description', 'VAT %', 'Ext VAT Code', 'Ext Accnt Code', 'IdSettings', 'IdConfig', ''],
                 colModel: [
                          { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                          { name: 'VatPerc', index: 'VatPerc', width: 160, sorttype: "string" },
                          { name: 'ExtVatCode', index: 'ExtVatCode', width: 160, sorttype: "string" },
                          { name: 'ExtAccntCode', index: 'ExtAccntCode', width: 160, sorttype: "string" },
                          { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editVATCode }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerVATCode'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "VAT Code",
                 async: false, //Very important,
                 subgrid: false

             });

             //Reason for Leave
             gridReason.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Description', 'IdSettings', 'IdConfig', ''],
                 colModel: [
                          { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                          { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editReason }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerReason'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "Reason for Leave",
                 async: false, //Very important,
                 subgrid: false

             });

             //Station Type
             gridStationType.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['StationType', 'IdStatType', ''],
                 colModel: [
                          { name: 'StationType', index: 'StationType', width: 160, sorttype: "string" },
                          { name: 'IdStype', index: 'IdStype', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdStype', index: 'IdStype', sortable: false, formatter: editStationType }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerStationType'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "StationType",
                 async: false, //Very important,
                 subgrid: false

             });

             //Department Messages
             gridDeptMess.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Department', 'Commercial Text','Detail Text','DeptId','MessId', ''],
                 colModel: [
                          { name: 'DeptName', index: 'DeptName', width: 160, sorttype: "string" },
                          { name: 'CommercialText', index: 'CommercialText', width: 160, sorttype: "string" },
                          { name: 'DetailText', index: 'DetailText', width: 160, sorttype: "string" },
                          { name: 'DeptId', index: 'DeptId', width: 160, sorttype: "string",hidden:true },
                          { name: 'MessId', index: 'MessId', width: 160, sorttype: "string", hidden: true },
                          { name: 'MessId', index: 'MessId', sortable: false, formatter: editDeptMess }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerDeptMess'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "DeptMessage",
                 async: false, //Very important,
                 subgrid: false

             });

             loadGenSettings();
             loadConfig();

         });//end of ready function


         function loadGenSettings() {

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfGeneral.aspx/LoadGenSettings",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         loadZipCode(data.d[0]);
                         loadCurrency(data.d[1]);

                         if (data.d[2][0].Description != "0" || data.d[2][0].Description != "") {
                             $('#<%=cmbTimeFormat.ClientID%>').val(data.d[2][0].Description);
                         } else {
                             $('#<%=cmbTimeFormat.ClientID%>')[0].selectedIndex = 0;
                         }

                         if (data.d[3][0].Description != "0" || data.d[3][0].Description != "") {
                             $('#<%=cmbUnitofTimings.ClientID%>').val(data.d[3][0].Description);
                         } else {
                             $('#<%=cmbUnitofTimings.ClientID%>')[0].selectedIndex = 0;
                         }

                         if (data.d[4][0].Description != "0" || data.d[4][0].Description != "") {
                             $('#<%=ddlCurrency.ClientID%> option:contains("' + data.d[4][0].Description + '")').attr('selected', 'selected');
                         } else {
                             $('#<%=ddlCurrency.ClientID%>')[0].selectedIndex = 0;
                         }

                         if (data.d[5][0].Description != "") {
                             $('#<%=txtMinimumSplits.ClientID%>').val(data.d[5][0].Description);
                         } else {
                             $('#<%=txtMinimumSplits.ClientID%>').val("");
                         }

                         if (data.d[6][0].Description == "true") {
                             $("#<%=cbSubRepairCode.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbSubRepairCode.ClientID%>").attr('checked', false);
                         }

                         if (data.d[7][0].Description ==  "true") {
                             $("#<%=cbSubDayPlan.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbSubDayPlan.ClientID%>").attr('checked', false);
                         }

                         if (data.d[8][0].Description == "true") {
                             $("#<%=cbJobCard.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbJobCard.ClientID%>").attr('checked', false);
                         }

                         if (data.d[9][0].Description == "true") {
                             $("#<%=cbEditStdTime.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbEditStdTime.ClientID%>").attr('checked', false);
                         }

                         if (data.d[10][0].Description == "true") {
                             $("#<%=cbViewGarSummary.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbViewGarSummary.ClientID%>").attr('checked', false);
                         }

                         if (data.d[11][0].Description == "true") {
                             $("#<%=cbMonday.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbMonday.ClientID%>").attr('checked', false);
                         }

                         if (data.d[12][0].Description == "true") {
                             $("#<%=cbVhReg.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbVhReg.ClientID%>").attr('checked', false);
                         }

                         if (data.d[13][0].Description == "true") {
                             $("#<%=cbUseInvPdf.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbUseInvPdf.ClientID%>").attr('checked', false);
                         }

                         if (data.d[14][0].Description == "true") {
                             $("#<%=cbUseDynCT.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbUseDynCT.ClientID%>").attr('checked', false);
                         }

                         if (data.d[15][0].Description == "true") {
                             $("#<%=cbUseDBSLnk.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbUseDBSLnk.ClientID%>").attr('checked', false);
                         }

                         if (data.d[16][0].Description == "true") {
                             $("#<%=cbUseApprove.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbUseApprove.ClientID%>").attr('checked', false);
                         }

                         if (data.d[17][0].Description == "true") {
                             $("#<%=cbUseMechGrid.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbUseMechGrid.ClientID%>").attr('checked', false);
                         }

                         if (data.d[18][0].Description == "true") {
                             $("#<%=cbSortbyLoc.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbSortbyLoc.ClientID%>").attr('checked', false);
                         }

                         if (data.d[19][0].Description == "true") {
                             $("#<%=cbStdTime.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbStdTime.ClientID%>").attr('checked', false);
                         }

                         if (data.d[20][0].Description == "true") {
                             $("#<%=cbChgTime.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbChgTime.ClientID%>").attr('checked', false);
                         }

                         if (data.d[21][0].Description == "true") {
                             $("#<%=cbMileage.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbMileage.ClientID%>").attr('checked', false);
                         }

                         if (data.d[22][0].Description == "true") {
                             $("#<%=cbSaveUdDp.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbSaveUdDp.ClientID%>").attr('checked', false);
                         }

                         if (data.d[23][0].Description == "true") {
                             $("#<%=cbDispIntNote.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbDispIntNote.ClientID%>").attr('checked', false);
                         }

                         if (data.d[24][0].Description == "true") {
                             $("#<%=cbSpBO.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbSpBO.ClientID%>").attr('checked', false);
                         }

                         if (data.d[25][0].Description == "true") {
                             $("#<%=cbWOSpares.ClientID%>").attr('checked', true);
                         } else {
                             $("#<%=cbWOSpares.ClientID%>").attr('checked', false);
                         }
                     }
                 }
             });
         }

         function loadConfig() {
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfGeneral.aspx/LoadConfig",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     loadDiscCode(data.d[0]);
                     loadVATCode(data.d[1]);
                     loadReason(data.d[2]);
                     loadStationType(data.d[5]);
                     loadSMSSettings(data.d[3]);
                     loadDeptMess(data.d[4]);
                     loadDepartment(data.d[6]);
                 }
             });
         }

         function loadCurrency(data) {
             $('#<%=ddlCurrency.ClientID%>').empty();
             $('#<%=ddlCurrency.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             $.each(data, function (key, value) {
                 $('#<%=ddlCurrency.ClientID%>').append($("<option></option>").val(value.IdParam).html(value.Description));
             });
             return true;
         }

         function loadDiscCode(data) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdDiscCode").jqGrid('clearGridData');
            for (i = 0; i < data.length; i++) {
                disccodedata = data;
                jQuery("#dgdDiscCode").jqGrid('addRowData', i + 1, disccodedata[i]);
            }
            jQuery("#dgdDiscCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdDiscCode").jqGrid("hideCol", "subgrid");
            return true;
         }

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

         function loadReason(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdReason").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 reasondata = data;
                 jQuery("#dgdReason").jqGrid('addRowData', i + 1, reasondata[i]);
             }
             jQuery("#dgdReason").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdReason").jqGrid("hideCol", "subgrid");
             return true;
         }

         function loadStationType(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdStationType").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 stattypedata = data;
                 jQuery("#dgdStationType").jqGrid('addRowData', i + 1, stattypedata[i]);
             }
             jQuery("#dgdStationType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdStationType").jqGrid("hideCol", "subgrid");
             return true;
         }

         function loadDeptMess(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdDeptMess").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 deptmessdata = data;
                 jQuery("#dgdDeptMess").jqGrid('addRowData', i + 1, deptmessdata[i]);
             }
             jQuery("#dgdDeptMess").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdDeptMess").jqGrid("hideCol", "subgrid");
             return true;
         }

         function loadDepartment(data) {
             $('#<%=ddlDept.ClientID%>').empty();
             $('#<%=ddlDept.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
             //data = data.d;
             $.each(data, function (key, value) {
                 $('#<%=ddlDept.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
             });
             return true;
         }

         function loadSMSSettings(data) {
             $('#<%=txtSMSMailServer.ClientID%>').val(data[0].SmsServer);
             $('#<%=txtSMSPrefix.ClientID%>').val(data[0].SmsPrefix);
             $('#<%=txtSMSSuffix.ClientID%>').val(data[0].SmsSuffix);
             $('#<%=txtSMSCtryCode.ClientID%>').val(data[0].SmsCtryCde);
             $('#<%=txtSMSNoChars.ClientID%>').val(data[0].SmsNoChars);
             $('#<%=txtSMSStartDigits.ClientID%>').val(data[0].SmsStDigit);
             if (data[0].SmsMailUsr == "false") {
                 $("#<%=cbSMSUseEmail.ClientID%>").attr('checked', false);
             } else {
                 $("#<%=cbSMSUseEmail.ClientID%>").attr('checked', true);
             }           
                
             return true;
         }

         function saveGenSettings() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             
             var timeFormat = $('#<%=cmbTimeFormat.ClientID%>').val();
             var unitOfTime = $('#<%=cmbUnitofTimings.ClientID%>').val();
             var currency = $('#<%=ddlCurrency.ClientID%>').val();
             var minSplits = $('#<%=txtMinimumSplits.ClientID%>').val();
             var useSubRepCode = $("#<%=cbSubRepairCode.ClientID%>").is(':checked');
             var useAutoResize = $("#<%=cbSubDayPlan.ClientID%>").is(':checked');
             var useDynClkTime = $("#<%=cbUseDynCT.ClientID%>").is(':checked');
             var useNewJobCard = $("#<%=cbJobCard.ClientID%>").is(':checked');
             var useEdtStdTime = $("#<%=cbEditStdTime.ClientID%>").is(':checked');
             var useViewGarSum = $("#<%=cbViewGarSummary.ClientID%>").is(':checked');
             var useMondStDay = $("#<%=cbMonday.ClientID%>").is(':checked');
             var useVehRegn = $("#<%=cbVhReg.ClientID%>").is(':checked');
             var useInvPdf = $("#<%=cbUseInvPdf.ClientID%>").is(':checked');
             var useDBS = $("#<%=cbUseDBSLnk.ClientID%>").is(':checked');
             var useApprIR = $("#<%=cbUseApprove.ClientID%>").is(':checked');
             var useMechGrid = $("#<%=cbUseMechGrid.ClientID%>").is(':checked');
             var useSortPL = $("#<%=cbSortbyLoc.ClientID%>").is(':checked');
             var useValStdTime = $("#<%=cbStdTime.ClientID%>").is(':checked');
             var useEdtChgTime = $("#<%=cbChgTime.ClientID%>").is(':checked');
             var useValMileage = $("#<%=cbMileage.ClientID%>").is(':checked');
             var useSavUpdDP = $("#<%=cbSaveUdDp.ClientID%>").is(':checked');
             var useIntNote = $("#<%=cbDispIntNote.ClientID%>").is(':checked');
             var useGrpSPBO = $("#<%=cbSpBO.ClientID%>").is(':checked');
             var useDispWOSpares = $("#<%=cbWOSpares.ClientID%>").is(':checked');

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveGenSettings",
                     data: "{timeFormat: '" + timeFormat + "', unitOfTime:'" + unitOfTime + "', currency:'" + currency + "', minSplits:'" + minSplits + "', useSubRepCode:'" + useSubRepCode + "', useAutoResize:'" + useAutoResize + "', useDynClkTime:'" + useDynClkTime + "', useNewJobCard:'" + useNewJobCard + "', useEdtStdTime:'" + useEdtStdTime + "', useViewGarSum:'" + useViewGarSum + "', useMondStDay:'" + useMondStDay + "', useVehRegn:'" + useVehRegn + "', useInvPdf:'" + useInvPdf + "', useDBS:'" + useDBS + "', useApprIR:'" + useApprIR + "', useMechGrid:'" + useMechGrid + "', useSortPL:'" + useSortPL + "', useValStdTime:'" + useValStdTime + "', useEdtChgTime:'" + useEdtChgTime + "', useValMileage:'" + useValMileage + "', useSavUpdDP:'" + useSavUpdDP + "', useIntNote:'" + useIntNote + "', useGrpSPBO:'" + useGrpSPBO + "', useDispWOSpares:'" + useDispWOSpares + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data != "") {
                             loadGenSettings();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnSaveGenSett.ClientID%>').show();
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


         function editZipCode(cellvalue, options, rowObject) {
             var rowId = options.rowId.toString();
             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editZipCodeDetails(" + "'" + rowId + "'" + "); />";
             return edit;
         }

         function editZipCodeDetails(rowId) {
             $('#divZipCode').show();
             $("#<%=txtZipCode.ClientID%>").attr('disabled', 'disabled');
             $('#<%=btnAddZipCodeT.ClientID%>').hide();
             $('#<%=btnDelZipCodeT.ClientID%>').hide();
             $('#<%=btnAddZipCodeB.ClientID%>').hide();
             $('#<%=btnDelZipCodeB.ClientID%>').hide();
             $('#<%=btnSaveZipCode.ClientID%>').show();
             $('#<%=btnResetZipCode.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");


             var item = '#dgdZipCode';
             var rowids = $(item).getDataIDs();
             var colModel = $(item).getGridParam().colModel;

             for (var i = 0; i < rowids.length; i++) {
                 if (rowId == rowids[i]) {
                     if ($(item).getGridParam().data[i].id == rowId) {
                         $('#<%=hdnZipCodeId.ClientID%>').val($(item).getGridParam().data[i].ZipCode);
                         $('#<%=txtZipCode.ClientID%>').val($(item).getGridParam().data[i].ZipCode);
                         $('#<%=txtCountry.ClientID%>').val($(item).getGridParam().data[i].Country);
                         $('#<%=txtState.ClientID%>').val($(item).getGridParam().data[i].State);
                         $('#<%=txtCity.ClientID%>').val($(item).getGridParam().data[i].City);
                     }
                 }
             }
         }

         function getZipCodeDetails(zipCode) {

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfGeneral.aspx/GetZipCodeDetails",
                 data: "{zipCode: '" + zipCode + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                             $('#<%=txtCountry.ClientID%>').val(data.d[0].Country);
                             $('#<%=txtState.ClientID%>').val(data.d[0].State);
                             $('#<%=txtCity.ClientID%>').val(data.d[0].City);
                     }
                 }
             });
         }

         function loadZipCode(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdZipCode").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 zipcodedata = data;
                 jQuery("#dgdZipCode").jqGrid('addRowData', i + 1, zipcodedata[i]);
             }
             jQuery("#dgdZipCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdZipCode").jqGrid("hideCol", "subgrid");
             return true;

         }

         function addZipCode() {
             $('#divZipCode').show();
             $('#<%=hdnZipCodeId.ClientID%>').val("");
             $('#<%=txtCountry.ClientID%>').val("");
             $('#<%=txtZipCode.ClientID%>').val("");
             $('#<%=txtState.ClientID%>').val("");
             $('#<%=txtCity.ClientID%>').val("");
             $('#<%=btnAddZipCodeT.ClientID%>').hide();
             $('#<%=btnDelZipCodeT.ClientID%>').hide();
             $('#<%=btnAddZipCodeB.ClientID%>').hide();
             $('#<%=btnDelZipCodeB.ClientID%>').hide();
             $('#<%=btnSaveZipCode.ClientID%>').show();
             $('#<%=btnResetZipCode.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $("#<%=txtZipCode.ClientID%>").removeAttr("disabled");
             $('#<%=txtZipCode.ClientID%>').focus();
         }

         function resetZipCode() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divZipCode').hide();
                 $('#<%=txtCountry.ClientID%>').val("");
                 $('#<%=txtZipCode.ClientID%>').val("");
                 $('#<%=txtState.ClientID%>').val("");
                 $('#<%=txtCity.ClientID%>').val("");
                 $('#<%=btnAddZipCodeT.ClientID%>').show();
                 $('#<%=btnDelZipCodeT.ClientID%>').show();
                 $('#<%=btnAddZipCodeB.ClientID%>').show();
                 $('#<%=btnDelZipCodeB.ClientID%>').show();
                 $('#<%=btnSaveZipCode.ClientID%>').hide();
                 $('#<%=btnResetZipCode.ClientID%>').hide();
                 $('#<%=hdnZipCodeId.ClientID%>').val("");
             }
         }

         function saveZipCode() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var country = $('#<%=txtCountry.ClientID%>').val();
             var zipCode = $('#<%=txtZipCode.ClientID%>').val();
             var state = $('#<%=txtState.ClientID%>').val();
             var city = $('#<%=txtCity.ClientID%>').val();
             var result = fnValidateZipCode();
             if (result == true) {

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveZipCode",
                     data: "{zipcode: '" + zipCode + "', country:'" + country + "', state:'" + state + "', city:'" + city + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         if (data.d == "0") {
                             $('#divZipCode').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddZipCodeT.ClientID%>').show();
                             $('#<%=btnAddZipCodeB.ClientID%>').show();
                             $('#<%=btnDelZipCodeT.ClientID%>').show();
                             $('#<%=btnDelZipCodeB.ClientID%>').show();
                             jQuery("#dgdZipCode").jqGrid('clearGridData');
                             loadGenSettings();
                             jQuery("#dgdZipCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

         function delZipCode() {
             var zipcode = "";
             $('#dgdZipCode input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     zipcode = $('#dgdZipCode tr ')[row].cells[1].innerHTML.toString();
                 }
             });

             if (zipcode != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteZipCode();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteZipCode() {
             var row;
             var pczipcodeId;
             var pczipcodeIdxml;
             var pczipcodeIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdZipCode input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     pczipcodeId = $('#dgdZipCode tr ')[row].cells[1].innerHTML.toString();
                     pczipcodeIdxml = '<CONFIG IDZIP= ""  ZIPCODE= "' + pczipcodeId + '"/>';
                     pczipcodeIdxmls += pczipcodeIdxml;
                 }
             });

             if (pczipcodeIdxmls != "") {
                 pczipcodeIdxmls = "<ROOT>" + pczipcodeIdxmls + "</ROOT>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteZipCode",
                     data: "{delxml: '" + pczipcodeIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             jQuery("#dgdZipCode").jqGrid('clearGridData');
                             loadGenSettings();
                             jQuery("#dgdZipCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divZipCode').hide();
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

         //Discount Code
         function editDiscCode(cellvalue, options, rowObject) {
             var discCode = rowObject.Description.toString();
             var discCodeId = rowObject.IdSettings.toString();
             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editDiscCodeDetails(" + "'" + discCode + "'" + ",'" + discCodeId + "'" + "); />";
             return edit;
         }

         function editDiscCodeDetails(discCode, discCodeId) {
             $('#divDiscCode').show();
             $('#<%=hdnDiscCodeId.ClientID%>').val(discCodeId);
             $('#<%=txtDiscCode.ClientID%>').val(discCode);
             $('#<%=btnAddDiscCodeT.ClientID%>').hide();
             $('#<%=btnDelDiscCodeT.ClientID%>').hide();
             $('#<%=btnAddDiscCodeB.ClientID%>').hide();
             $('#<%=btnDelDiscCodeB.ClientID%>').hide();
             $('#<%=btnSaveDiscCode.ClientID%>').show();
             $('#<%=btnResetDiscCode.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function addDiscCode() {
             $('#divDiscCode').show();
             $('#<%=hdnDiscCodeId.ClientID%>').val("");
             $('#<%=txtDiscCode.ClientID%>').val("");

             $('#<%=btnAddDiscCodeT.ClientID%>').hide();
             $('#<%=btnDelDiscCodeT.ClientID%>').hide();
             $('#<%=btnAddDiscCodeB.ClientID%>').hide();
             $('#<%=btnDelDiscCodeB.ClientID%>').hide();
             $('#<%=btnSaveDiscCode.ClientID%>').show();
             $('#<%=btnResetDiscCode.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=txtDiscCode.ClientID%>').focus();
         }

         function resetDiscCode() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divDiscCode').hide();
                 $('#<%=txtDiscCode.ClientID%>').val("");
                 $('#<%=btnAddDiscCodeT.ClientID%>').show();
                 $('#<%=btnDelDiscCodeT.ClientID%>').show();
                 $('#<%=btnAddDiscCodeB.ClientID%>').show();
                 $('#<%=btnDelDiscCodeB.ClientID%>').show();
                 $('#<%=btnSaveDiscCode.ClientID%>').hide();
                 $('#<%=btnResetDiscCode.ClientID%>').hide();
                 $('#<%=hdnDiscCodeId.ClientID%>').val("");
             }
         }

         function saveDiscCode() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var desc = $('#<%=txtDiscCode.ClientID%>').val();
             var idsettings = $('#<%=hdnDiscCodeId.ClientID%>').val();
             var idconfig = "DISCD";
             var result = fnValidateDiscCode();
             if (result == true) {

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + desc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             $('#divDiscCode').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddDiscCodeT.ClientID%>').show();
                             $('#<%=btnAddDiscCodeB.ClientID%>').show();
                             $('#<%=btnDelDiscCodeT.ClientID%>').show();
                             $('#<%=btnDelDiscCodeB.ClientID%>').show();
                             jQuery("#dgdDiscCode").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdDiscCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

         function delDiscCode() {
             var discCodeId = "";
             $('#dgdDiscCode input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     discCodeId = $('#dgdDiscCode tr ')[row].cells[3].innerHTML.toString();
                 }
             });

             if (discCodeId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteDiscCode();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteDiscCode() {
             var row;
             var discCodeId;
             var discCodeDesc;
             var discCodeIdxml;
             var discCodeIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdDiscCode input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     discCodeId = $('#dgdDiscCode tr ')[row].cells[3].innerHTML.toString();
                     discCodeDesc = $('#dgdDiscCode tr ')[row].cells[1].innerHTML.toString();
                     discCodeIdxml = '<delete><DISCD ID_SETTINGS= "' + discCodeId + '" ID_CONFIG= "DISCD" DESCRIPTION= "' + discCodeDesc + '"/></delete>';
                     discCodeIdxmls += discCodeIdxml;
                 }
             });

             if (discCodeIdxmls != "") {
                 discCodeIdxmls = "<root>" + discCodeIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteConfig",
                     data: "{xmlDoc: '" + discCodeIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             jQuery("#dgdDiscCode").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdDiscCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divDiscCode').hide();
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

         //VAT Code
         function editVATCode(cellvalue, options, rowObject) {
             var vatCode = rowObject.Description.toString();
             var vatCodeId = rowObject.IdSettings.toString();
             var vatPerc = rowObject.VatPerc.toString();
             var extVatCode = rowObject.ExtVatCode.toString();
             var extAccntCode = rowObject.ExtAccntCode.toString();

             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editVATCodeDetails(" + "'" + vatCode + "','" + vatCodeId + "','" + vatPerc + "','" + extVatCode + "','" + extAccntCode + "'" + "); />";
             return edit;
         }

         function editVATCodeDetails(vatCode, vatCodeId, vatPerc, extVatCode, extAccntCode) {
             $('#divVATCode').show();
             $('#<%=hdnVATCodeId.ClientID%>').val(vatCodeId);
             $('#<%=txtVATCode.ClientID%>').val(vatCode);
             $('#<%=txtVatPercentage.ClientID%>').val(vatPerc);
             $('#<%=txtExtVAT.ClientID%>').val(extVatCode);
             $('#<%=txtExtAcc.ClientID%>').val(extAccntCode);

             $('#<%=btnAddVATCodeT.ClientID%>').hide();
             $('#<%=btnDelVATCodeT.ClientID%>').hide();
             $('#<%=btnAddVATCodeB.ClientID%>').hide();
             $('#<%=btnDelVATCodeB.ClientID%>').hide();
             $('#<%=btnSaveVATCode.ClientID%>').show();
             $('#<%=btnResetVATCode.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function addVATCode() {
             $('#divVATCode').show();
             $('#<%=hdnVATCodeId.ClientID%>').val("");
             $('#<%=txtVATCode.ClientID%>').val("");
             $('#<%=txtVatPercentage.ClientID%>').val("");
             $('#<%=txtExtVAT.ClientID%>').val("");
             $('#<%=txtExtAcc.ClientID%>').val("");
             $('#<%=btnAddVATCodeT.ClientID%>').hide();
             $('#<%=btnDelVATCodeT.ClientID%>').hide();
             $('#<%=btnAddVATCodeB.ClientID%>').hide();
             $('#<%=btnDelVATCodeB.ClientID%>').hide();
             $('#<%=btnSaveVATCode.ClientID%>').show();
             $('#<%=btnResetVATCode.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=txtVATCode.ClientID%>').focus();
         }

         function resetVATCode() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divVATCode').hide();
                 $('#<%=txtVATCode.ClientID%>').val("");
                 $('#<%=btnAddVATCodeT.ClientID%>').show();
                 $('#<%=btnDelVATCodeT.ClientID%>').show();
                 $('#<%=btnAddVATCodeB.ClientID%>').show();
                 $('#<%=btnDelVATCodeB.ClientID%>').show();
                 $('#<%=btnSaveVATCode.ClientID%>').hide();
                 $('#<%=btnResetVATCode.ClientID%>').hide();
                 $('#<%=hdnVATCodeId.ClientID%>').val("");
             }
         }

         function saveVATCode() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var desc = $('#<%=txtVATCode.ClientID%>').val();
             var vatper = $('#<%=txtVatPercentage.ClientID%>').val();
             var extvatcode = $('#<%=txtExtVAT.ClientID%>').val();
             var extvataccntcode = $('#<%=txtExtAcc.ClientID%>').val();
             var idsettings = $('#<%=hdnVATCodeId.ClientID%>').val();
             var idconfig = "VAT";

             if (extvatcode == "") {
                 extvatcode = "0";
             }

             var result = fnValidateVATCode();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveVATCode",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', vatcode:'" + desc + "', vatper:'" + vatper + "', extvatcode:'" + extvatcode + "', extvataccntcode:'" + extvataccntcode + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             $('#divVATCode').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddVATCodeT.ClientID%>').show();
                             $('#<%=btnAddVATCodeB.ClientID%>').show();
                             $('#<%=btnDelVATCodeT.ClientID%>').show();
                             $('#<%=btnDelVATCodeB.ClientID%>').show();
                             jQuery("#dgdVATCode").jqGrid('clearGridData');
                             loadConfig();
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
                     vatCodeId = $('#dgdVATCode tr ')[row].cells[6].innerHTML.toString();
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
             var row;
             var vatCodeId;
             var vatCodeDesc;
             var vatCodeIdxml;
             var vatCodeIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdVATCode input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     vatCodeId = $('#dgdVATCode tr ')[row].cells[6].innerHTML.toString();
                     vatCodeDesc = $('#dgdVATCode tr ')[row].cells[1].innerHTML.toString();
                     vatCodeIdxml = '<delete><VAT ID_SETTINGS= "' + vatCodeId + '" ID_CONFIG= "VAT" DESCRIPTION= "' + vatCodeDesc + '"/></delete>';
                     vatCodeIdxmls += vatCodeIdxml;
                 }
             });

             if (vatCodeIdxmls != "") {
                 vatCodeIdxmls = "<root>" + vatCodeIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteConfig",
                     data: "{xmlDoc: '" + vatCodeIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             jQuery("#dgdVATCode").jqGrid('clearGridData');
                             loadConfig();
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

         //Reasons for Leave

         function editReason(cellvalue, options, rowObject) {
             var desc = rowObject.Description.toString();
             var idsettings = rowObject.IdSettings.toString();
             var idconfig = rowObject.IdConfig.toString();


             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editReasonDetails(" + "'" + desc + "','" + idsettings + "','" + idconfig +  "'" + "); />";
             return edit;
         }

         function editReasonDetails(desc, idsettings, idconfig) {
             $('#divReason').show();
             $('#<%=hdnReasonId.ClientID%>').val(idsettings);
             $('#<%=txtReason.ClientID%>').val(desc);

             $('#<%=btnAddReasonT.ClientID%>').hide();
             $('#<%=btnDelReasonT.ClientID%>').hide();
             $('#<%=btnAddReasonB.ClientID%>').hide();
             $('#<%=btnDelReasonB.ClientID%>').hide();
             $('#<%=btnSaveReason.ClientID%>').show();
             $('#<%=btnResetReason.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function addReason() {
             $('#divReason').show();
             $('#<%=hdnReasonId.ClientID%>').val("");
             $('#<%=txtReason.ClientID%>').val("");
        
             $('#<%=btnAddReasonT.ClientID%>').hide();
             $('#<%=btnDelReasonT.ClientID%>').hide();
             $('#<%=btnAddReasonB.ClientID%>').hide();
             $('#<%=btnDelReasonB.ClientID%>').hide();
             $('#<%=btnSaveReason.ClientID%>').show();
             $('#<%=btnResetReason.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=txtReason.ClientID%>').focus();
         }

         function resetReason() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divReason').hide();
                 $('#<%=txtReason.ClientID%>').val("");
                 $('#<%=btnAddReasonT.ClientID%>').show();
                 $('#<%=btnDelReasonT.ClientID%>').show();
                 $('#<%=btnAddReasonB.ClientID%>').show();
                 $('#<%=btnDelReasonB.ClientID%>').show();
                 $('#<%=btnSaveReason.ClientID%>').hide();
                 $('#<%=btnResetReason.ClientID%>').hide();
                 $('#<%=hdnReasonId.ClientID%>').val("");
             }
         }

         function saveReason() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var desc = $('#<%=txtReason.ClientID%>').val();
             var idsettings = $('#<%=hdnReasonId.ClientID%>').val();
             var idconfig = "LEAVE_RESN";
             var result = fnValidateReason();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + desc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             $('#divReason').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddReasonT.ClientID%>').show();
                             $('#<%=btnAddReasonB.ClientID%>').show();
                             $('#<%=btnDelReasonT.ClientID%>').show();
                             $('#<%=btnDelReasonB.ClientID%>').show();
                             jQuery("#dgdReason").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdReason").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

         function delReason() {
             var reasonId = "";
             $('#dgdReason input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     reasonId = $('#dgdReason tr ')[row].cells[2].innerHTML.toString();
                 }
             });

             if (reasonId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteReason();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteReason() {
             var row;
             var reasonId;
             var reasonDesc;
             var reasonIdxml;
             var reasonIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdReason input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     reasonId = $('#dgdReason tr ')[row].cells[2].innerHTML.toString();
                     reasonDesc = $('#dgdReason tr ')[row].cells[1].innerHTML.toString();
                     reasonIdxml = '<delete><TR-COUT ID_SETTINGS= "' + reasonId + '" ID_CONFIG= "LEAVE_RESN"  DESCRIPTION= "' + reasonDesc + '"/></delete>';
                     reasonIdxmls += reasonIdxml;
                 }
             });

             if (reasonIdxmls != "") {
                 reasonIdxmls = "<root>" + reasonIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteConfig",
                     data: "{xmlDoc: '" + reasonIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {   
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             jQuery("#dgdReason").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdReason").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divReason').hide();
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

         //Station Type

         function editStationType(cellvalue, options, rowObject) {
             var statType = rowObject.StationType.toString();
             var statTypeId = rowObject.IdStype.toString();

             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editStationTypeDetails(" + "'" + statTypeId + "','" + statType + "'" + "); />";
             return edit;
         }

         function editStationTypeDetails(statTypeId, statType) {
             $('#divStationType').show();
             $('#<%=hdnStationTypeId.ClientID%>').val(statTypeId);
             $('#<%=txtStationType.ClientID%>').val(statType);
             $('#<%=btnAddStationTypeT.ClientID%>').hide();
             $('#<%=btnDelStationTypeT.ClientID%>').hide();
             $('#<%=btnAddStationTypeB.ClientID%>').hide();
             $('#<%=btnDelStationTypeB.ClientID%>').hide();
             $('#<%=btnSaveStationType.ClientID%>').show();
             $('#<%=btnResetStationType.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function addStationType() {
             $('#divStationType').show();
             $('#<%=hdnStationTypeId.ClientID%>').val("");
             $('#<%=txtStationType.ClientID%>').val("");
             $('#<%=btnAddStationTypeT.ClientID%>').hide();
             $('#<%=btnDelStationTypeT.ClientID%>').hide();
             $('#<%=btnAddStationTypeB.ClientID%>').hide();
             $('#<%=btnDelStationTypeB.ClientID%>').hide();
             $('#<%=btnSaveStationType.ClientID%>').show();
             $('#<%=btnResetStationType.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=txtStationType.ClientID%>').focus();
         }

         function resetStationType() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divStationType').hide();
                 $('#<%=txtStationType.ClientID%>').val("");
                 $('#<%=btnAddStationTypeT.ClientID%>').show();
                 $('#<%=btnDelStationTypeT.ClientID%>').show();
                 $('#<%=btnAddStationTypeB.ClientID%>').show();
                 $('#<%=btnDelStationTypeB.ClientID%>').show();
                 $('#<%=btnSaveStationType.ClientID%>').hide();
                 $('#<%=btnResetStationType.ClientID%>').hide();
                 $('#<%=hdnStationTypeId.ClientID%>').val("");
             }
         }

         function saveStationType() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var desc = $('#<%=txtStationType.ClientID%>').val();
             var stattypeId = $('#<%=hdnStationTypeId.ClientID%>').val();
             var result = fnValidateStatType();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveStationType",
                     data: "{desc: '" + desc + "', stattypeId:'" + stattypeId + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             $('#divStationType').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddStationTypeT.ClientID%>').show();
                             $('#<%=btnAddStationTypeB.ClientID%>').show();
                             $('#<%=btnDelStationTypeT.ClientID%>').show();
                             $('#<%=btnDelStationTypeB.ClientID%>').show();
                             jQuery("#dgdStationType").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdStationType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

         function delStationType() {
             var statTypeId = "";
             $('#dgdStationType input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     statTypeId = $('#dgdStationType tr ')[row].cells[2].innerHTML.toString();
                 }
             });

             if (statTypeId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteStationType();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteStationType() {
             var row;
             var statTypeId;
             var statTypeDesc;
             var statTypeIdxml;
             var statTypeIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdStationType input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     statTypeId = $('#dgdStationType tr ')[row].cells[2].innerHTML.toString();
                     statTypeDesc = $('#dgdStationType tr ')[row].cells[1].innerHTML.toString();
                     statTypeIdxml = '<delete><ST-TYPE ID_STYPE= "' + statTypeId + '" TYPE_STATION= "' + statTypeDesc + '"/></delete>';
                     statTypeIdxmls += statTypeIdxml;
                 }
             });

             if (statTypeIdxmls != "") {
                 statTypeIdxmls = "<root>" + statTypeIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteStationType",
                     data: "{xmlDoc: '" + statTypeIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d[0] == "DEL") {
                             $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");

                             jQuery("#dgdStationType").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdStationType").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divStationType').hide();
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
         
         //SMS SETTINGS
         function saveSMSSettings() {
             var smsServer = $('#<%=txtSMSMailServer.ClientID%>').val();
             var smsPrefix = $('#<%=txtSMSPrefix.ClientID%>').val();
             var smsSuffix = $('#<%=txtSMSSuffix.ClientID%>').val();
             var smsCtryCode = $('#<%=txtSMSCtryCode.ClientID%>').val();
             var smsNoChars = $("#<%=txtSMSNoChars.ClientID%>").val();
             var smsStDigit = $("#<%=txtSMSStartDigits.ClientID%>").val();
             var smsMailUsr = $("#<%=cbSMSUseEmail.ClientID%>").is(':checked').toString();

             var result = fnValidateSMSGeneral();
             if (result == true) {

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveSMSSettings",
                     data: "{smsServer: '" + smsServer + "', smsPrefix:'" + smsPrefix + "', smsSuffix:'" + smsSuffix + "', smsCtryCode:'" + smsCtryCode + "', smsNoChars:'" + smsNoChars + "', smsStDigit:'" + smsStDigit + "', smsMailUsr:'" + smsMailUsr + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data != "") {
                             loadConfig();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnSaveSMS.ClientID%>').show();
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

         //Department Messages
         function editDeptMess(cellvalue, options, rowObject) {
             var deptId = rowObject.DeptId.toString();
             var messId = rowObject.MessId.toString();

             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editDeptMessDetails(" + "'" + deptId + "','" + messId + "'" + "); />";
             return edit;
         }

         function editDeptMessDetails(deptId, messId) {
             $('#divDeptMess').show();
             $('#<%=hdnDeptMessId.ClientID%>').val(messId);
             $('#<%=ddlDept.ClientID%>').val(deptId);
             getDeptMessDetails(messId);
             $('#<%=btnAddDeptMessT.ClientID%>').hide();
             $('#<%=btnDelDeptMessT.ClientID%>').hide();
             $('#<%=btnAddDeptMessB.ClientID%>').hide();
             $('#<%=btnDelDeptMessB.ClientID%>').hide();
             $('#<%=btnSaveDeptMess.ClientID%>').show();
             $('#<%=btnResetDeptMess.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");
         }

         function addDeptMess() {
             $('#divDeptMess').show();
             $('#<%=hdnDeptMessId.ClientID%>').val("");
             $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 0;
             $('#<%=btnAddDeptMessT.ClientID%>').hide();
             $('#<%=btnDelDeptMessT.ClientID%>').hide();
             $('#<%=btnAddDeptMessB.ClientID%>').hide();
             $('#<%=btnDelDeptMessB.ClientID%>').hide();
             $('#<%=btnSaveDeptMess.ClientID%>').show();
             $('#<%=btnResetDeptMess.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=ddlDept.ClientID%>').focus();
         }

         function resetDeptMess() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divDeptMess').hide();
                 $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 0;
                 $('#<%=btnAddDeptMessT.ClientID%>').show();
                 $('#<%=btnDelDeptMessT.ClientID%>').show();
                 $('#<%=btnAddDeptMessB.ClientID%>').show();
                 $('#<%=btnDelDeptMessB.ClientID%>').show();
                 $('#<%=btnSaveDeptMess.ClientID%>').hide();
                 $('#<%=btnResetDeptMess.ClientID%>').hide();
                 $('#<%=hdnDeptMessId.ClientID%>').val("");
             }
         }

         function getDeptMessDetails(messId) {

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfGeneral.aspx/GetDeptMessDetails",
                 data: "{messId: '" + messId + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         $('#<%=txtEditCommercialText.ClientID%>').val(data.d[0].CommercialText);
                         $('#<%=txtEditDetails.ClientID%>').val(data.d[0].DetailText);
                     }
                 }
             });
         }

         function saveDeptMess() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var commtext = $('#<%=txtEditCommercialText.ClientID%>').val();
             var detailtext = $('#<%=txtEditDetails.ClientID%>').val();
             var deptid = $('#<%=ddlDept.ClientID%>').val();
             var messid = $('#<%=hdnDeptMessId.ClientID%>').val();
             var result = fnValidateSMSDeptMsg();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/SaveDeptMessages",
                     data: "{messageid: '" + messid + "', deptid:'" + deptid + "', commtext:'" + commtext + "', detailtext:'" + detailtext + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         if (data.d == "INSERTED" || data.d == "UPDATED") {
                             $('#divDeptMess').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddDeptMessT.ClientID%>').show();
                             $('#<%=btnAddDeptMessB.ClientID%>').show();
                             $('#<%=btnDelDeptMessT.ClientID%>').show();
                             $('#<%=btnDelDeptMessB.ClientID%>').show();
                             jQuery("#dgdDeptMess").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdDeptMess").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         } else if (data.d == "AEXISTS") {
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblErr");
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

         function delDeptMess() {
             var deptMessId = "";
             $('#dgdDeptMess input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     deptMessId = $('#dgdDeptMess tr ')[row].cells[5].innerHTML.toString();
                 }
             });

             if (deptMessId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteDeptMess();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteDeptMess() {
             var row;
             var deptMessId;
             var deptMessDesc;
             var deptMessIdxml;
             var deptMessIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdDeptMess input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     deptMessId = $('#dgdDeptMess tr ')[row].cells[5].innerHTML.toString();
                     deptMessIdxml = '<DELETE><DELETE ID_MESSAGES= "' + deptMessId + '"/></DELETE>';
                     deptMessIdxmls += deptMessIdxml;
                 }
             });

             if (deptMessIdxmls != "") {
                 deptMessIdxmls = "<ROOT>" + deptMessIdxmls + "</ROOT>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfGeneral.aspx/DeleteDeptMessage",
                     data: "{xmldata: '" + deptMessIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d == "DELETED") {
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0362', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");

                             jQuery("#dgdDeptMess").jqGrid('clearGridData');
                             loadConfig();
                             jQuery("#dgdDeptMess").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divDeptMess').hide();
                         }
                         else if (data.d == "ERROR") {
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
            <asp:Label ID="lblHead" runat="server" Text="General Settings Configuration" ></asp:Label>
            <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
            <asp:HiddenField id="hdnPageSize" runat="server" />  
            <asp:HiddenField id="hdnEditCap" runat="server" />
            <asp:HiddenField id="hdnMode" runat="server" /> 
            <asp:HiddenField id="hdnSelect" runat="server" />  
            <asp:HiddenField id="hdnZipCodeId" runat="server" />
            <asp:HiddenField id="hdnDiscCodeId" runat="server" />
            <asp:HiddenField id="hdnVATCodeId" runat="server" />  
            <asp:HiddenField id="hdnReasonId" runat="server" />  
            <asp:HiddenField id="hdnStationTypeId" runat="server" />
            <asp:HiddenField id="hdnDeptMessId" runat="server" />
        </div>  
        <div id="accordion" style="height:100%">

            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a2" runat="server" >General Settings</a>
            </div>
            <div class="ui form" style="width: 100%;">
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblTimeFormat" runat="server" Text="Time Format"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:DropDownList ID="cmbTimeFormat" runat="server" Width="156px" CssClass="drpdwm"></asp:DropDownList>
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblUnitofTimings" runat="server" Text="Unit of Timings"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:DropDownList ID="cmbUnitofTimings" runat="server" Width="156px" CssClass="drpdwm"></asp:DropDownList>
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblCurrency" runat="server" Text="Currency"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:DropDownList ID="ddlCurrency" runat="server" Width="156px" CssClass="drpdwm">
                            <asp:ListItem Text="NOR" Value="1"></asp:ListItem>
                            <asp:ListItem Text="INR" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblMinimumSplits" runat="server" Text="Minimum Splitting Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtMinimumSplits" runat="server" CssClass="inp" MaxLength="10" Width="110px" onchange="fnValidateTime();"></asp:TextBox>
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblSubRepairCode" runat="server" Text="Use Sub-Repair code"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSubRepairCode" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lbldayPlanCode" runat="server" Text="Auto-Resize Planned Job"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSubDayPlan" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblUseDynCT" runat="server" Text="Use Dynamic Clock Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbUseDynCT" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblJobCard" runat="server" Text="Use new layout for Job Card"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbJobCard" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblEditStdTime" runat="server" Text="Editing Std Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbEditStdTime" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblViewGarSummary" runat="server" Text="View Garage Summary"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbViewGarSummary" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblMonday" runat="server" Text="Monday As StartDay"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbMonday" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblVhReg" runat="server" Text="Use Veh.Registration on Dayplan"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbVhReg" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblUseInvPdf" runat="server" Text="Use Inv Pdf"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbUseInvPdf" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblUseDBSLnk" runat="server" Text="Use DBS File Upload"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbUseDBSLnk" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblUseApprove" runat="server" Text="Use Approve in IR"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbUseApprove" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblUseMechGrid" runat="server" Text="Use MechGrid"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbUseMechGrid" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblSortByLoc" runat="server" Text="Sort Picking List by Location"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSortbyLoc" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblStdTime" runat="server" Text="Validate Std Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbStdTime" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblChgTime" runat="server" Text="Edit Chg Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbChgTime" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblMileage" runat="server" Text="Validate Mileage"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbMileage" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblSaveUdDp" runat="server" Text="Save/Update DayPlan"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSaveUdDp" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblDispIntNote" runat="server" Text="Internal Note"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbDispIntNote" runat="server" />
                    </div>                        
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblSpBO" runat="server" Text="Group Spare Parts in BO"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSpBO" runat="server" />
                    </div>      
                     <div class="field" style="width:180px">
                        <asp:Label ID="lblDispWOSpares" runat="server" Text="Display WO Spares"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbWOSpares" runat="server" />
                    </div>                        
                </div>
                <div style="text-align:center">
                    <input id="btnSaveGenSett" class="ui button" runat="server"  value="Save" type="button" onclick="saveGenSettings()" />
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a1" runat="server" >ZipCode</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddZipCodeT" runat="server" type="button" value="Add" class="ui button"  onclick="addZipCode()"/>
                    <input id="btnDelZipCodeT" runat="server" type="button" value="Delete" class="ui button" onclick="delZipCode()"/>
                </div>  
                <div >
                    <table id="dgdZipCode" title="ZipCode" ></table>
                    <div id="pagerZipCode"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddZipCodeB" runat="server" type="button" value="Add" class="ui button" onclick="addZipCode()"/>
                    <input id="btnDelZipCodeB" runat="server" type="button" value="Delete" class="ui button" onclick="delZipCode()"/>
                </div>
                <div id="divZipCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a3" runat="server" >ZipCode</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblZipCode" runat="server" Text="Zipcode"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtZipCode"  padding="0em" runat="server" MaxLength="10"></asp:TextBox>
                            </div>     
                                <div class="field" style="width:180px">
                                <asp:Label ID="lblCountry" runat="server" Text="Country"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtCountry"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                            </div>                              
                        </div>
                    </div>             
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblState" runat="server" Text="State"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtState"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                            </div>     
                                <div class="field" style="width:180px">
                                <asp:Label ID="lblCity" runat="server" Text="City"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtCity"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                            </div>                              
                        </div>
                    </div>
                    <div style="text-align:center">
                        <input id="btnSaveZipCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveZipCode()"/>
                        <input id="btnResetZipCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetZipCode()" />
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a4" runat="server" >Discount Code</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddDiscCodeT" runat="server" type="button" value="Add" class="ui button"  onclick="addDiscCode()"/>
                    <input id="btnDelDiscCodeT" runat="server" type="button" value="Delete" class="ui button" onclick="delDiscCode()"/>
                </div>  
                <div >
                    <table id="dgdDiscCode" title="DiscCode" ></table>
                    <div id="pagerDiscCode"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddDiscCodeB" runat="server" type="button" value="Add" class="ui button" onclick="addDiscCode()"/>
                    <input id="btnDelDiscCodeB" runat="server" type="button" value="Delete" class="ui button" onclick="delDiscCode()"/>
                </div>
                <div id="divDiscCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a5" runat="server" >DiscCode</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblDiscCode" runat="server" Text="Discount Code"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtDiscCode"  padding="0em" runat="server" MaxLength="10"></asp:TextBox>
                            </div>     
                        </div>
                    </div>             
                    <div style="text-align:center">
                        <input id="btnSaveDiscCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveDiscCode()"/>
                        <input id="btnResetDiscCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetDiscCode()" />
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a6" runat="server" >VAT Code</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddVATCodeT" runat="server" type="button" value="Add" class="ui button"  onclick="addVATCode()"/>
                    <input id="btnDelVATCodeT" runat="server" type="button" value="Delete" class="ui button" onclick="delVATCode()"/>
                </div>  
                <div >
                    <table id="dgdVATCode" title="VATCode" ></table>
                    <div id="pagerVATCode"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddVATCodeB" runat="server" type="button" value="Add" class="ui button" onclick="addVATCode()"/>
                    <input id="btnDelVATCodeB" runat="server" type="button" value="Delete" class="ui button" onclick="delVATCode()"/>
                </div>
                <div id="divVATCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a7" runat="server" >VAT Code</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblVATCode" runat="server" Text="VAT Code"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtVATCode"  padding="0em" runat="server" MaxLength="3"></asp:TextBox>
                            </div>    
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblVatPercentage" runat="server" Text="VAT Percentage"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtVatPercentage"  padding="0em" runat="server" MaxLength="6"></asp:TextBox>
                            </div>     
                        </div>
                         <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblExtVATCode" runat="server" Text="External VAT Code"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtExtVAT"  padding="0em" runat="server" MaxLength="1"></asp:TextBox>
                            </div>  
                             <div class="field" style="width:180px">
                                <asp:Label ID="lblExtAccCode" runat="server" Text="Account Code"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtExtAcc"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                            </div>     
                        </div>
                    </div> 
            
                    <div style="text-align:center">
                        <input id="btnSaveVATCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveVATCode()"/>
                        <input id="btnResetVATCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetVATCode()" />
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a8" runat="server" >Reason for Leave</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddReasonT" runat="server" type="button" value="Add" class="ui button"  onclick="addReason()"/>
                    <input id="btnDelReasonT" runat="server" type="button" value="Delete" class="ui button" onclick="delReason()"/>
                </div>  
                <div >
                    <table id="dgdReason" title="Reason" ></table>
                    <div id="pagerReason"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddReasonB" runat="server" type="button" value="Add" class="ui button" onclick="addReason()"/>
                    <input id="btnDelReasonB" runat="server" type="button" value="Delete" class="ui button" onclick="delReason()"/>
                </div>
                <div id="divReason" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a9" runat="server" >Reason for Leave</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblReason" runat="server" Text="Reason for Leave"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtReason"  padding="0em" runat="server" MaxLength="15"></asp:TextBox>
                            </div>    
                        </div>
                    </div> 
            
                    <div style="text-align:center">
                        <input id="btnSaveReason" class="ui button" runat="server"  value="Save" type="button" onclick="saveReason()"/>
                        <input id="btnResetReason" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetReason()" />
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a10" runat="server" >Station Type</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddStationTypeT" runat="server" type="button" value="Add" class="ui button"  onclick="addStationType()"/>
                    <input id="btnDelStationTypeT" runat="server" type="button" value="Delete" class="ui button" onclick="delStationType()"/>
                </div>  
                <div >
                    <table id="dgdStationType" title="StationType" ></table>
                    <div id="pagerStationType"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddStationTypeB" runat="server" type="button" value="Add" class="ui button" onclick="addStationType()"/>
                    <input id="btnDelStationTypeB" runat="server" type="button" value="Delete" class="ui button" onclick="delStationType()"/>
                </div>
                <div id="divStationType" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a11" runat="server" >Station Type</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblStationType" runat="server" Text="StationType"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtStationType"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                            </div>    
                        </div>
                    </div> 
            
                    <div style="text-align:center">
                        <input id="btnSaveStationType" class="ui button" runat="server"  value="Save" type="button" onclick="saveStationType()"/>
                        <input id="btnResetStationType" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetStationType()" />
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a12" runat="server" >SMS Settings</a>
            </div>
            <div>
                <div id="divSMSSettings" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a13" runat="server" >General Configuration - SMS</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                       <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSMailServer" runat="server" Text="SMS Mail Server"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSMailServer"  padding="0em" runat="server"></asp:TextBox>
                            </div>  
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSPrefix" runat="server" Text="SMS Prefix"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSPrefix"  padding="0em" runat="server"></asp:TextBox>
                            </div>
                       </div>
                       <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSSuffix" runat="server" Text="SMS Suffix"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSSuffix"  padding="0em" runat="server"></asp:TextBox>
                            </div>  
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSCtryCode" runat="server" Text="Country Code"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSCtryCode"  padding="0em" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSNoChars" runat="server" Text="No of Characters in SMS Number"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSNoChars"  padding="0em" runat="server"></asp:TextBox>
                            </div>  
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSStartDigits" runat="server" Text="Start Digit(s) [Eg: 4/9]"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:TextBox ID="txtSMSStartDigits"  padding="0em" runat="server"></asp:TextBox>
                            </div>
                        </div>
                         <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSMSUseEMail" runat="server" Text="Use E-Mail address on user"></asp:Label>
                            </div>
                            <div class="field" style="width:180px">
                                <asp:CheckBox ID="cbSMSUseEmail" runat="server"/>
                            </div>  
                        </div>
                    </div> 
            
                    <div style="text-align:center">
                        <input id="btnSaveSMS" class="ui button" runat="server"  value="Save" type="button" onclick="saveSMSSettings()"/>
                    </div>               
                </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                  <a class="item" id="a14" runat="server" >Department Messages</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddDeptMessT" runat="server" type="button" value="Add" class="ui button"  onclick="addDeptMess()"/>
                    <input id="btnDelDeptMessT" runat="server" type="button" value="Delete" class="ui button" onclick="delDeptMess()"/>
                </div>  
                <div >
                    <table id="dgdDeptMess" title="StationType" ></table>
                    <div id="pagerDeptMess"></div>
                </div>         
                <div style="text-align:left;padding-left:23em">
                    <input id="btnAddDeptMessB" runat="server" type="button" value="Add" class="ui button" onclick="addDeptMess()"/>
                    <input id="btnDelDeptMessB" runat="server" type="button" value="Delete" class="ui button" onclick="delDeptMess()"/>
                </div>
                <div id="divDeptMess" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a15" runat="server" >Department Message</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblDept" runat="server" Text="Department"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:DropDownList ID="ddlDept" runat="server" Width="156px" CssClass="drpdwm" ></asp:DropDownList>
                            </div>    
                        </div>
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblEditCommercialText" runat="server" Text="Commercial Text"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                                <asp:TextBox ID="txtEditCommercialText" runat="server" Width="300px" Height="50px" TextMode="MultiLine" Columns="50" ></asp:TextBox>
                            </div>    
                        </div>
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblEditDetails" runat="server" Text="Details"></asp:Label>
                            </div>
                            <div class="field" style="width:100px">
                               <asp:TextBox ID="txtEditDetails" runat="server"  Width="300px" Height="50px"  TextMode="MultiLine" Columns="50" ></asp:TextBox>
                            </div>    
                        </div>
                    </div> 
            
                    <div style="text-align:center">
                        <input id="btnSaveDeptMess" class="ui button" runat="server"  value="Save" type="button" onclick="saveDeptMess()"/>
                        <input id="btnResetDeptMess" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetDeptMess()" />
                    </div>               
                </div>
            </div>


            
        </div> <%--end of accordion  --%>

</asp:Content>

