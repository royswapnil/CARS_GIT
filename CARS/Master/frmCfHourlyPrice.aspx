<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfHourlyPrice.aspx.vb" Inherits="CARS.frmCfHourlyPrice" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

         <script type="text/javascript">

             function fnCustPCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtPrCodeCust.ClientID%>'), '0172'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtPrCodeCust.ClientID%>'), '0172')) {
                     return false;
                 }
                 return true;
             }

             function fnRepPkgPCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtRPPriceCodeGrp.ClientID%>'), '0175'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtRPPriceCodeGrp.ClientID%>'), '0175')) {
                     return false;
                 }
                 return true;
             }

             function fnJobPCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtJobPriceCode.ClientID%>'), '0176'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtJobPriceCode.ClientID%>'), '0176')) {
                     return false;
                 }
                 return true;
             }

             function fnMechPCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtMechPriceCode.ClientID%>'), '0177'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtMechPriceCode.ClientID%>'), '0177')) {
                     return false;
                 }
                 return true;
             }

             function fnMakePCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtMakePC.ClientID%>'), '0173'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtMakePC.ClientID%>'), '0173')) {
                     return false;
                 }
                 return true;
             }

             function fnVehGrpPCClientValidate() {
                 if (!(gfi_CheckEmpty($('#<%=txtVehGrpPC.ClientID%>'), '0174'))) {
                     return false;
                 }
                 if (!gfb_ValidateAlphabets($('#<%=txtVehGrpPC.ClientID%>'), '0174')) {
                     return false;
                 }
                 return true;
             }

             $(document).ready(function () {
                 $("#accordion").accordion();
                 var grid = $("#dgdPrCodeCust");
                 var gridPrCodeRepPkg = $("#dgdPrCodeRepPkg");
                 var gridPrCodeJob = $("#dgdPrCodeJob");
                 var gridPrCodeMech = $("#dgdPrCodeMech");
                 var gridPrCodeMake = $("#dgdPrCodeMake");
                 var gridPrCodeVehGrp = $("#dgdPrCodeVehGrp");
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var mydata,pcrpdata,pcjobdata,pcmechdata,pcmakedata,pcvehgrpdata;

                 $('#divPrCodeCust').hide();
                 $('#divPrCodeRepPkg').hide();
                 $('#divPrCodeJob').hide();
                 $('#divPrCodeMech').hide();
                 $('#divPrCodeMake').hide();
                 $('#divPrCodeVehGrp').hide();

                 //Price Code for Customer
                 grid.jqGrid({
                     datatype: "local",
                     data: mydata,
                     colNames: ['Description', 'IdSettings', ''],
                     colModel: [
                              { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                              { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                              { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeCust }
                     ],
                     multiselect: true,
                     pager: jQuery('#pager'),
                     rowNum: pageSize,//can fetch from webconfig
                     rowList: 5,
                     sortorder: 'asc',
                     viewrecords: true,
                     height: "50%",
                     caption: "Price Code for Customer",
                     async: false, //Very important,
                     subgrid: false

                 });

                 //Price Code for Repair Package
                 gridPrCodeRepPkg.jqGrid({
                     datatype: "local",
                     data: mydata,
                     colNames: ['Description', 'IdSettings', ''],
                     colModel: [
                              { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                              { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                              { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeRepPkg }
                     ],
                     multiselect: true,
                     pager: jQuery('#pagerPrCodeRepPkg'),
                     rowNum: pageSize,//can fetch from webconfig
                     rowList: 5,
                     sortorder: 'asc',
                     viewrecords: true,
                     height: "50%",
                     caption: "Price Code for  Repair Package",
                     async: false, //Very important,
                     subgrid: false

                 });

                 //Price Code on Job
                 gridPrCodeJob.jqGrid({
                     datatype: "local",
                     data: mydata,
                     colNames: ['Description', 'IdSettings', ''],
                     colModel: [
                              { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                              { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                              { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeJob }
                     ],
                     multiselect: true,
                     pager: jQuery('#pagerPrCodeJob'),
                     rowNum: pageSize,//can fetch from webconfig
                     rowList: 5,
                     sortorder: 'asc',
                     viewrecords: true,
                     height: "50%",
                     caption: "Price Code on Job",
                     async: false, //Very important,
                     subgrid: false

                 });

                 //Price Code for Mechanic
                 gridPrCodeMech.jqGrid({
                     datatype: "local",
                     data: mydata,
                     colNames: ['Description', 'IdSettings', ''],
                     colModel: [
                              { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                              { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                              { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeMech }
                     ],
                     multiselect: true,
                     pager: jQuery('#pagerPrCodeMech'),
                     rowNum: pageSize,//can fetch from webconfig
                     rowList: 5,
                     sortorder: 'asc',
                     viewrecords: true,
                     height: "50%",
                     caption: "Price Code for Mech",
                     async: false, //Very important,
                     subgrid: false

                 });

                 //Price Code for Make
                 gridPrCodeMake.jqGrid({
                     datatype: "local",
                     data: mydata,
                     colNames: ['Description', 'IdSettings', ''],
                     colModel: [
                              { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                              { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                              { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeMake }
                     ],
                     multiselect: true,
                     pager: jQuery('#pagerPrCodeMake'),
                     rowNum: pageSize,//can fetch from webconfig
                     rowList: 5,
                     sortorder: 'asc',
                     viewrecords: true,
                     height: "50%",
                     caption: "Price Code for Make",
                     async: false, //Very important,
                     subgrid: false

                 });

                 //Price Code for Vehicle Group
                 gridPrCodeVehGrp.jqGrid({
                         datatype: "local",
                         data: mydata,
                         colNames: ['Description', 'IdSettings', ''],
                         colModel: [
                                  { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                                  { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                                  { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editPrCodeVehGrp }
                         ],
                         multiselect: true,
                         pager: jQuery('#pagerPrCodeVehGrp'),
                         rowNum: pageSize,//can fetch from webconfig
                         rowList: 5,
                         sortorder: 'asc',
                         viewrecords: true,
                         height: "50%",
                         caption: "Price Code for Vehicle Group",
                         async: false, //Very important,
                         subgrid: false

                     });

                 loadHPConfig();

             });//end of ready


             function loadHPConfig() {
                 var mydata;
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfHourlyPrice.aspx/LoadAllHPConfig",
                     data: "{}",
                     dataType: "json",
                     async: false,//Very important
                     success: function (data) {
                         loadPrCodeCust(data.d[0]);
                         loadPrCodeRepPkg(data.d[1]);
                         loadPrCodeJob(data.d[2]);
                         loadPrCodeMech(data.d[3]);
                         loadPrCodeMake(data.d[4]);
                         loadPrCodeVehGrp(data.d[5]);
                     }
                 });
             }

             function loadPrCodeCust(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeCust").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     mydata = data;
                     jQuery("#dgdPrCodeCust").jqGrid('addRowData', i + 1, mydata[i]);
                 }
                 jQuery("#dgdPrCodeCust").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeCust").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function loadPrCodeRepPkg(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeRepPkg").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     pcrpdata = data;
                     jQuery("#dgdPrCodeRepPkg").jqGrid('addRowData', i + 1, pcrpdata[i]);
                 }
                 jQuery("#dgdPrCodeRepPkg").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeRepPkg").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function loadPrCodeJob(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeJob").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     pcjobdata = data;
                     jQuery("#dgdPrCodeJob").jqGrid('addRowData', i + 1, pcjobdata[i]);
                 }
                 jQuery("#dgdPrCodeJob").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeJob").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function loadPrCodeMech(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeMech").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     pcmechdata = data;
                     jQuery("#dgdPrCodeMech").jqGrid('addRowData', i + 1, pcmechdata[i]);
                 }
                 jQuery("#dgdPrCodeMech").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeMech").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function loadPrCodeMake(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeMake").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     pcmakedata = data;
                     jQuery("#dgdPrCodeMake").jqGrid('addRowData', i + 1, pcmakedata[i]);
                 }
                 jQuery("#dgdPrCodeMake").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeMake").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function loadPrCodeVehGrp(data) {
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 jQuery("#dgdPrCodeVehGrp").jqGrid('clearGridData');
                 for (i = 0; i < data.length; i++) {
                     pcvehgrpdata = data;
                     jQuery("#dgdPrCodeVehGrp").jqGrid('addRowData', i + 1, pcvehgrpdata[i]);
                 }
                 jQuery("#dgdPrCodeVehGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                 $("#dgdPrCodeVehGrp").jqGrid("hideCol", "subgrid");
                 return true;
             }

             function addPrCodeCust() {
                 $('#divPrCodeCust').show();
                 $('#<%=txtPrCodeCust.ClientID%>').val("");
                 $('#<%=btnAddPrCodeCustT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeCustT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeCustT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeCustB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeCust.ClientID%>').show();
                 $('#<%=btnResetPrCodeCust.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeCust.ClientID%>').val("");
             }             

             function editPrCodeCust(cellvalue, options, rowObject) {
                 var pcDesc = rowObject.Description.toString();
                 var idprCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeCust(" + "'" + pcDesc + "'" + ",'" + idprCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeCust(pcDesc, idprCode) {
                 $('#divPrCodeCust').show();
                 $('#<%=hdnIdPrCodeCust.ClientID%>').val(idprCode);
                 $('#<%=txtPrCodeCust.ClientID%>').val(pcDesc);
                 $('#<%=btnAddPrCodeCustT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeCustT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeCustB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeCustB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeCust.ClientID%>').show();
                 $('#<%=btnResetPrCodeCust.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeCust() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnCustPCClientValidate();
                 if (result == true) {
                     var prCodeCustDesc = $('#<%=txtPrCodeCust.ClientID%>').val();
                     var idconfig = "HP-CU-PC";
                     var idsettings = $('#<%=hdnIdPrCodeCust.ClientID%>').val();

                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                         data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + prCodeCustDesc + "', mode:'" + mode + "'}",
                         dataType: "json",
                         async: false,
                         success: function (data) {
                             data = data.d[0];
                             if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                                 jQuery("#dgdPrCodeCust").jqGrid('clearGridData');
                                 loadHPConfig();
                                 jQuery("#dgdPrCodeCust").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                 $('#divPrCodeCust').hide();
                                 $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                 $('#<%=RTlblError.ClientID%>').removeClass();
                                 $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                 $('#<%=btnAddPrCodeCustT.ClientID%>').show();
                                 $('#<%=btnAddPrCodeCustB.ClientID%>').show();
                                 $('#<%=btnDelPrCodeCustT.ClientID%>').show();
                                 $('#<%=btnDelPrCodeCustB.ClientID%>').show();
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

             function delPrCodeCust() {
                 var repkgId = "";
                 $('#dgdPrCodeCust input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         repkgId = $('#dgdPrCodeCust tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (repkgId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeCust();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeCust() {
                 var row;
                 var pcCustId;
                 var pcCustDesc;
                 var pcCustIdxml;
                 var pcCustIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeCust input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcCustId = $('#dgdPrCodeCust tr ')[row].cells[2].innerHTML.toString();
                         pcCustDesc = $('#dgdPrCodeCust tr ')[row].cells[1].innerHTML.toString();
                         pcCustIdxml = '<delete><HP-CU-PC ID_SETTINGS= "' + pcCustId + '" ID_CONFIG= "HP-CU-PC" DESCRIPTION= "' + pcCustDesc + '"/></delete>';
                         pcCustIdxmls += pcCustIdxml;
                     }
                 });

                 if (pcCustIdxmls != "") {
                     pcCustIdxmls = "<root>" + pcCustIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcCustIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeCust").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeCust").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeCust').hide();
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

             function resetPrCodeCust() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeCust').hide();
                     $('#<%=txtPrCodeCust.ClientID%>').val("");
                     $('#<%=btnAddPrCodeCustT.ClientID%>').show();
                     $('#<%=btnDelPrCodeCustT.ClientID%>').show();
                     $('#<%=btnAddPrCodeCustB.ClientID%>').show();
                     $('#<%=btnDelPrCodeCustB.ClientID%>').show();
                     $('#<%=btnSavePrCodeCust.ClientID%>').hide();
                     $('#<%=btnResetPrCodeCust.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeCust.ClientID%>').val("");
                 }
             }

             //Price Code Repair Package

             function addPrCodeRepPkg() {
                 $('#divPrCodeRepPkg').show();
                 $('#<%=txtRPPriceCodeGrp.ClientID%>').val("");
                 $('#<%=btnAddPrCodeRepPkgT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeRepPkgT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeRepPkgT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeRepPkgB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeRepPkg.ClientID%>').show();
                 $('#<%=btnResetPrCodeRepPkg.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeRepPkg.ClientID%>').val("");
             }

             function editPrCodeRepPkg(cellvalue, options, rowObject) {
                 var pcRPDesc = rowObject.Description.toString();
                 var idRepPkgPrCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeRepPkg(" + "'" + pcRPDesc + "'" + ",'" + idRepPkgPrCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeRepPkg(pcRPDesc, idRepPkgPrCode) {
                 $('#divPrCodeRepPkg').show();
                 $('#<%=hdnIdPrCodeRepPkg.ClientID%>').val(idRepPkgPrCode);
                 $('#<%=txtRPPriceCodeGrp.ClientID%>').val(pcRPDesc);
                 $('#<%=btnAddPrCodeRepPkgT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeRepPkgT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeRepPkgB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeRepPkgB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeRepPkg.ClientID%>').show();
                 $('#<%=btnResetPrCodeRepPkg.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeRepPkg() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnRepPkgPCClientValidate();
                 if (result == true) {
                     var prCodeRPDesc = $('#<%=txtRPPriceCodeGrp.ClientID%>').val();
                 var idconfig = "HP-RP-PC";
                     var idsettings = $('#<%=hdnIdPrCodeRepPkg.ClientID%>').val();

                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                         data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + prCodeRPDesc + "', mode:'" + mode + "'}",
                         dataType: "json",
                         async: false,
                         success: function (data) {
                             data = data.d[0];
                             if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                                 jQuery("#dgdPrCodeRepPkg").jqGrid('clearGridData');
                                 loadHPConfig();
                                 jQuery("#dgdPrCodeRepPkg").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                 $('#divPrCodeRepPkg').hide();
                                 $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                 $('#<%=RTlblError.ClientID%>').removeClass();
                                 $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                 $('#<%=btnAddPrCodeRepPkgT.ClientID%>').show();
                                 $('#<%=btnAddPrCodeRepPkgB.ClientID%>').show();
                                 $('#<%=btnDelPrCodeRepPkgT.ClientID%>').show();
                                 $('#<%=btnDelPrCodeRepPkgB.ClientID%>').show();
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

             function delPrCodeRepPkg() {
                 var repkgId = "";
                 $('#dgdPrCodeRepPkg input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         repkgId = $('#dgdPrCodeRepPkg tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (repkgId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeRepPkg();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeRepPkg() {
                 var row;
                 var pcRPId;
                 var pcRPDesc;
                 var pcRPIdxml;
                 var pcRPIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeRepPkg input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcRPId = $('#dgdPrCodeRepPkg tr ')[row].cells[2].innerHTML.toString();
                         pcRPDesc = $('#dgdPrCodeRepPkg tr ')[row].cells[1].innerHTML.toString();
                         pcRPIdxml = '<delete><HP-RP-PC ID_SETTINGS= "' + pcRPId + '" ID_CONFIG= "HP-RP-PC" DESCRIPTION= "' + pcRPDesc + '"/></delete>';
                         pcRPIdxmls += pcRPIdxml;
                     }
                 });

                 if (pcRPIdxmls != "") {
                     pcRPIdxmls = "<root>" + pcRPIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcRPIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeRepPkg").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeRepPkg").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeRepPkg').hide();
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

             function resetPrCodeRepPkg() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeRepPkg').hide();
                     $('#<%=txtRPPriceCodeGrp.ClientID%>').val("");
                     $('#<%=btnAddPrCodeRepPkgT.ClientID%>').show();
                     $('#<%=btnDelPrCodeRepPkgT.ClientID%>').show();
                     $('#<%=btnAddPrCodeRepPkgB.ClientID%>').show();
                     $('#<%=btnDelPrCodeRepPkgB.ClientID%>').show();
                     $('#<%=btnSavePrCodeRepPkg.ClientID%>').hide();
                     $('#<%=btnResetPrCodeRepPkg.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeRepPkg.ClientID%>').val("");
                 }
             }             

             //Price Code on Job

             function addPrCodeJob() {
                 $('#divPrCodeJob').show();
                 $('#<%=txtJobPriceCode.ClientID%>').val("");
                 $('#<%=btnAddPrCodeJobT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeJobT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeJobT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeJobB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeJob.ClientID%>').show();
                 $('#<%=btnResetPrCodeJob.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeJob.ClientID%>').val("");
             }

             function editPrCodeJob(cellvalue, options, rowObject) {
                 var desc = rowObject.Description.toString();
                 var idJobPrCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeJob(" + "'" + desc + "'" + ",'" + idJobPrCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeJob(desc, idJobPrCode) {
                 $('#divPrCodeJob').show();
                 $('#<%=hdnIdPrCodeJob.ClientID%>').val(idJobPrCode);
                 $('#<%=txtJobPriceCode.ClientID%>').val(desc);
                 $('#<%=btnAddPrCodeJobT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeJobT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeJobB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeJobB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeJob.ClientID%>').show();
                 $('#<%=btnResetPrCodeJob.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeJob() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnJobPCClientValidate();
                 if (result == true) {
                 var prCodeRPDesc = $('#<%=txtJobPriceCode.ClientID%>').val();
                 var idconfig = "HP-JOB-PC";
                 var idsettings = $('#<%=hdnIdPrCodeJob.ClientID%>').val();

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + prCodeRPDesc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             jQuery("#dgdPrCodeJob").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeJob").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeJob').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddPrCodeJobT.ClientID%>').show();
                             $('#<%=btnAddPrCodeJobB.ClientID%>').show();
                             $('#<%=btnDelPrCodeJobT.ClientID%>').show();
                             $('#<%=btnDelPrCodeJobB.ClientID%>').show();
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

             function delPrCodeJob() {
                 var prCodeJobId = "";
                 $('#dgdPrCodeJob input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         prCodeJobId = $('#dgdPrCodeJob tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (prCodeJobId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeJob();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeJob() {
                 var row;
                 var pcJobId;
                 var pcJobDesc;
                 var pcJobIdxml;
                 var pcJobIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeJob input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcJobId = $('#dgdPrCodeJob tr ')[row].cells[2].innerHTML.toString();
                         pcJobDesc = $('#dgdPrCodeJob tr ')[row].cells[1].innerHTML.toString();
                         pcJobIdxml = '<delete><HP-JOB-PC ID_SETTINGS= "' + pcJobId + '" ID_CONFIG= "HP-JOB-PC" DESCRIPTION= "' + pcJobDesc + '"/></delete>';
                         pcJobIdxmls += pcJobIdxml;
                     }
                 });

                 if (pcJobIdxmls != "") {
                     pcJobIdxmls = "<root>" + pcJobIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcJobIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeJob").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeJob").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeJob').hide();
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

             function resetPrCodeJob() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeJob').hide();
                     $('#<%=txtJobPriceCode.ClientID%>').val("");
                     $('#<%=btnAddPrCodeJobT.ClientID%>').show();
                     $('#<%=btnDelPrCodeJobT.ClientID%>').show();
                     $('#<%=btnAddPrCodeJobB.ClientID%>').show();
                     $('#<%=btnDelPrCodeJobB.ClientID%>').show();
                     $('#<%=btnSavePrCodeJob.ClientID%>').hide();
                     $('#<%=btnResetPrCodeJob.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeJob.ClientID%>').val("");
                 }
             }

             //Price Code for Mechanic

             function addPrCodeMech() {
                 $('#divPrCodeMech').show();
                 $('#<%=txtMechPriceCode.ClientID%>').val("");
                 $('#<%=btnAddPrCodeMechT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMechT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeMechT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMechB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeMech.ClientID%>').show();
                 $('#<%=btnResetPrCodeMech.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeMech.ClientID%>').val("");
             }

             function editPrCodeMech(cellvalue, options, rowObject) {
                 var desc = rowObject.Description.toString();
                 var idMechPrCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeMech(" + "'" + desc + "'" + ",'" + idMechPrCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeMech(desc, idMechPrCode) {
                 $('#divPrCodeMech').show();
                 $('#<%=hdnIdPrCodeMech.ClientID%>').val(idMechPrCode);
                 $('#<%=txtMechPriceCode.ClientID%>').val(desc);
                 $('#<%=btnAddPrCodeMechT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMechT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeMechB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMechB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeMech.ClientID%>').show();
                 $('#<%=btnResetPrCodeMech.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeMech() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnMechPCClientValidate();
                 if (result == true) {
                 var prCodeMechDesc = $('#<%=txtMechPriceCode.ClientID%>').val();
                 var idconfig = "HP-MEC-PC";
                 var idsettings = $('#<%=hdnIdPrCodeMech.ClientID%>').val();

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + prCodeMechDesc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             jQuery("#dgdPrCodeMech").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeMech").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeMech').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddPrCodeMechT.ClientID%>').show();
                             $('#<%=btnAddPrCodeMechB.ClientID%>').show();
                             $('#<%=btnDelPrCodeMechT.ClientID%>').show();
                             $('#<%=btnDelPrCodeMechB.ClientID%>').show();
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

             function delPrCodeMech() {
                 var pcMechId = "";
                 $('#dgdPrCodeMech input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcMechId = $('#dgdPrCodeMech tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (pcMechId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeMech();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeMech() {
                 var row;
                 var pcMechId;
                 var pcMechDesc;
                 var pcMechIdxml;
                 var pcMechIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeMech input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcMechId = $('#dgdPrCodeMech tr ')[row].cells[2].innerHTML.toString();
                         pcMechDesc = $('#dgdPrCodeMech tr ')[row].cells[1].innerHTML.toString();
                         pcMechIdxml = '<delete><HP-MEC-PC ID_SETTINGS= "' + pcMechId + '" ID_CONFIG= "HP-MEC-PC" DESCRIPTION= "' + pcMechDesc + '"/></delete>';
                         pcMechIdxmls += pcMechIdxml;
                     }
                 });

                 if (pcMechIdxmls != "") {
                     pcMechIdxmls = "<root>" + pcMechIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcMechIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeMech").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeMech").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeMech').hide();
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

             function resetPrCodeMech() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeMech').hide();
                     $('#<%=txtMechPriceCode.ClientID%>').val("");
                     $('#<%=btnAddPrCodeMechT.ClientID%>').show();
                     $('#<%=btnDelPrCodeMechT.ClientID%>').show();
                     $('#<%=btnAddPrCodeMechB.ClientID%>').show();
                     $('#<%=btnDelPrCodeMechB.ClientID%>').show();
                     $('#<%=btnSavePrCodeMech.ClientID%>').hide();
                     $('#<%=btnResetPrCodeMech.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeMech.ClientID%>').val("");
                 }
             }

             //Price Code for Make

             function addPrCodeMake() {
                 $('#divPrCodeMake').show();
                 $('#<%=txtMakePC.ClientID%>').val("");
                 $('#<%=btnAddPrCodeMakeT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMakeT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeMakeT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMakeB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeMake.ClientID%>').show();
                 $('#<%=btnResetPrCodeMake.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeMake.ClientID%>').val("");
             }

             function editPrCodeMake(cellvalue, options, rowObject) {
                 var desc = rowObject.Description.toString();
                 var idMakePrCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeMake(" + "'" + desc + "'" + ",'" + idMakePrCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeMake(desc, idMakePrCode) {
                 $('#divPrCodeMake').show();
                 $('#<%=hdnIdPrCodeMake.ClientID%>').val(idMakePrCode);
                 $('#<%=txtMakePC.ClientID%>').val(desc);
                 $('#<%=btnAddPrCodeMakeT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMakeT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeMakeB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeMakeB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeMake.ClientID%>').show();
                 $('#<%=btnResetPrCodeMake.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeMake() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnMakePCClientValidate();
                 if (result == true) {
                 var desc = $('#<%=txtMakePC.ClientID%>').val();
                 var idconfig = "HP-MAKE-PC";
                 var idsettings = $('#<%=hdnIdPrCodeMake.ClientID%>').val();

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + desc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             jQuery("#dgdPrCodeMake").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeMake").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeMake').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddPrCodeMakeT.ClientID%>').show();
                             $('#<%=btnAddPrCodeMakeB.ClientID%>').show();
                             $('#<%=btnDelPrCodeMakeT.ClientID%>').show();
                             $('#<%=btnDelPrCodeMakeB.ClientID%>').show();
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

             function delPrCodeMake() {
                 var pcMakeId = "";
                 $('#dgdPrCodeMake input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcMakeId = $('#dgdPrCodeMake tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (pcMakeId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeMake();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeMake() {
                 var row;
                 var pcMakeId;
                 var pcMakeDesc;
                 var pcMakeIdxml;
                 var pcMakeIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeMake input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcMakeId = $('#dgdPrCodeMake tr ')[row].cells[2].innerHTML.toString();
                         pcMakeDesc = $('#dgdPrCodeMake tr ')[row].cells[1].innerHTML.toString();
                         pcMakeIdxml = '<delete><HP-MAKE-PC ID_SETTINGS= "' + pcMakeId + '" ID_CONFIG= "HP-MAKE-PC" DESCRIPTION= "' + pcMakeDesc + '"/></delete>';
                         pcMakeIdxmls += pcMakeIdxml;
                     }
                 });

                 if (pcMakeIdxmls != "") {
                     pcMakeIdxmls = "<root>" + pcMakeIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcMakeIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeMake").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeMake").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeMake').hide();
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

             function resetPrCodeMake() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeMake').hide();
                     $('#<%=txtMakePC.ClientID%>').val("");
                     $('#<%=btnAddPrCodeMakeT.ClientID%>').show();
                     $('#<%=btnDelPrCodeMakeT.ClientID%>').show();
                     $('#<%=btnAddPrCodeMakeB.ClientID%>').show();
                     $('#<%=btnDelPrCodeMakeB.ClientID%>').show();
                     $('#<%=btnSavePrCodeMake.ClientID%>').hide();
                     $('#<%=btnResetPrCodeMake.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeMake.ClientID%>').val("");
                 }
             }

             //Price Code for Vehicle Group

             function addPrCodeVehGrp() {
                 $('#divPrCodeVehGrp').show();
                 $('#<%=txtRPPriceCodeGrp.ClientID%>').val("");
                 $('#<%=btnAddPrCodeVehGrpT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeVehGrpT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeVehGrpT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeVehGrpB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeVehGrp.ClientID%>').show();
                 $('#<%=btnResetPrCodeVehGrp.ClientID%>').show();
                 $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                 $('#<%=hdnIdPrCodeVehGrp.ClientID%>').val("");
             }

             function editPrCodeVehGrp(cellvalue, options, rowObject) {
                 var pcRPDesc = rowObject.Description.toString();
                 var idVehGrpPrCode = rowObject.IdSettings.toString();

                 $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                 var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                 var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editPriceCodeVehGrp(" + "'" + pcRPDesc + "'" + ",'" + idVehGrpPrCode + "'" + "); />";
                 return edit;
             }

             function editPriceCodeVehGrp(pcRPDesc, idVehGrpPrCode) {
                 $('#divPrCodeVehGrp').show();
                 $('#<%=hdnIdPrCodeVehGrp.ClientID%>').val(idVehGrpPrCode);
                 $('#<%=txtRPPriceCodeGrp.ClientID%>').val(pcRPDesc);
                 $('#<%=btnAddPrCodeVehGrpT.ClientID%>').hide();
                 $('#<%=btnDelPrCodeVehGrpT.ClientID%>').hide();
                 $('#<%=btnAddPrCodeVehGrpB.ClientID%>').hide();
                 $('#<%=btnDelPrCodeVehGrpB.ClientID%>').hide();
                 $('#<%=btnSavePrCodeVehGrp.ClientID%>').show();
                 $('#<%=btnResetPrCodeVehGrp.ClientID%>').show();
                 $('#<%=hdnMode.ClientID%>').val("Edit");
             }

             function savePrCodeVehGrp() {
                 var mode = $('#<%=hdnMode.ClientID%>').val();
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                 var result = fnVehGrpPCClientValidate();
                 if (result == true) {
                 var desc = $('#<%=txtVehGrpPC.ClientID%>').val();
                 var idconfig = "HP-VHG-PC";
                 var idsettings = $('#<%=hdnIdPrCodeVehGrp.ClientID%>').val();

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfHourlyPrice.aspx/SaveHPConfig",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + desc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             jQuery("#dgdPrCodeVehGrp").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeVehGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeVehGrp').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddPrCodeVehGrpT.ClientID%>').show();
                             $('#<%=btnAddPrCodeVehGrpB.ClientID%>').show();
                             $('#<%=btnDelPrCodeVehGrpT.ClientID%>').show();
                             $('#<%=btnDelPrCodeVehGrpB.ClientID%>').show();
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

             function delPrCodeVehGrp() {
                 var vehgrpId = "";
                 $('#dgdPrCodeVehGrp input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         vehgrpId = $('#dgdPrCodeVehGrp tr ')[row].cells[2].innerHTML.toString();
                     }
                 });

                 if (vehgrpId != "") {
                     var msg = GetMultiMessage('0016', '', '');
                     var r = confirm(msg);
                     if (r == true) {
                         deletePrCodeVehGrp();
                     }
                 }
                 else {
                     var msg = GetMultiMessage('SelectRecord', '', '');
                     alert(msg);
                 }
             }

             function deletePrCodeVehGrp() {
                 var row;
                 var pcVehGrpId;
                 var pcVehGrpDesc;
                 var pcVehGrpIdxml;
                 var pcVehGrpIdxmls = "";
                 var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                 $('#dgdPrCodeVehGrp input:checkbox').attr("checked", function () {
                     if (this.checked) {
                         row = $(this).closest('td').parent()[0].sectionRowIndex;
                         pcVehGrpId = $('#dgdPrCodeVehGrp tr ')[row].cells[2].innerHTML.toString();
                         pcVehGrpDesc = $('#dgdPrCodeVehGrp tr ')[row].cells[1].innerHTML.toString();
                         pcVehGrpIdxml = '<delete><HP-VHG-PC ID_SETTINGS= "' + pcVehGrpId + '" ID_CONFIG= "HP-VHG-PC" DESCRIPTION= "' + pcVehGrpDesc + '"/></delete>';
                         pcVehGrpIdxmls += pcVehGrpIdxml;
                     }
                 });

                 if (pcVehGrpIdxmls != "") {
                     pcVehGrpIdxmls = "<root>" + pcVehGrpIdxmls + "</root>";
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfHourlyPrice.aspx/DeleteHPConfig",
                         data: "{delxml: '" + pcVehGrpIdxmls + "'}",
                         dataType: "json",
                         success: function (data) {
                             jQuery("#dgdPrCodeVehGrp").jqGrid('clearGridData');
                             loadHPConfig();
                             jQuery("#dgdPrCodeVehGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divPrCodeVehGrp').hide();
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

             function resetPrCodeVehGrp() {
                 var msg = GetMultiMessage('0161', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     $('#divPrCodeVehGrp').hide();
                     $('#<%=txtVehGrpPC.ClientID%>').val("");
                     $('#<%=btnAddPrCodeVehGrpT.ClientID%>').show();
                     $('#<%=btnDelPrCodeVehGrpT.ClientID%>').show();
                     $('#<%=btnAddPrCodeVehGrpB.ClientID%>').show();
                     $('#<%=btnDelPrCodeVehGrpB.ClientID%>').show();
                     $('#<%=btnSavePrCodeVehGrp.ClientID%>').hide();
                     $('#<%=btnResetPrCodeVehGrp.ClientID%>').hide();
                     $('#<%=hdnIdPrCodeVehGrp.ClientID%>').val("");
                 }
             }

         </script>


            <div class="header1 two fields" style="padding-top:0.5em">
                <asp:Label ID="lblHead" runat="server" Text="Hourly Price Configuration" ></asp:Label>
                <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
                <asp:HiddenField id="hdnPageSize" runat="server" />  
                <asp:HiddenField id="hdnEditCap" runat="server" />
                <asp:HiddenField id="hdnMode" runat="server" /> 
                <asp:HiddenField id="hdnSelect" runat="server" />    
                <asp:HiddenField id="hdnIdPrCodeCust" runat="server" />
                <asp:HiddenField id="hdnIdPrCodeRepPkg" runat="server" />
                <asp:HiddenField id="hdnIdPrCodeJob" runat="server" />
                <asp:HiddenField id="hdnIdPrCodeMech" runat="server" />
                <asp:HiddenField id="hdnIdPrCodeMake" runat="server" />
                <asp:HiddenField id="hdnIdPrCodeVehGrp" runat="server" />
            </div>
            <div id="accordion">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a2" runat="server" >Price Code for Customer</a>
                </div> 
                <div > 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeCustT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeCust()"/>
                        <input id="btnDelPrCodeCustT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeCust()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeCust" title="Price Code for Customer" ></table>
                        <div id="pager"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeCustB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeCust()"/>
                        <input id="btnDelPrCodeCustB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeCust()"/>
                    </div>
                    <div id="divPrCodeCust">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="aheader" runat="server" >Price Code for Customer</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblPrCodeCust" runat="server" Text="Price Code for Customer"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtPrCodeCust"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>                            
                            </div>
                        </div>             

                        <div style="text-align:left">
                            <input id="btnSavePrCodeCust" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeCust()"/>
                            <input id="btnResetPrCodeCust" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeCust()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a1" runat="server" >Price Code for Repair Package</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeRepPkgT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeRepPkg()"/>
                        <input id="btnDelPrCodeRepPkgT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeRepPkg()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeRepPkg" title="Price Code for Repair Package" ></table>
                        <div id="pagerPrCodeRepPkg"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeRepPkgB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeRepPkg()"/>
                        <input id="btnDelPrCodeRepPkgB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeRepPkg()"/>
                    </div>
                    <div id="divPrCodeRepPkg" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a3" runat="server" >Price Code for Repair Package</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblRPPriceCodeGrp" runat="server" Text="Price Code Group for Repair Package"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtRPPriceCodeGrp"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                            </div>
                        </div>             

                        <div style="text-align:left">
                            <input id="btnSavePrCodeRepPkg" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeRepPkg()"/>
                            <input id="btnResetPrCodeRepPkg" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeRepPkg()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a4" runat="server" >Price Code on Job</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeJobT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeJob()"/>
                        <input id="btnDelPrCodeJobT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeJob()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeJob" title="Price Code on Job" ></table>
                        <div id="pagerPrCodeJob"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeJobB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeJob()"/>
                        <input id="btnDelPrCodeJobB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeJob()"/>
                    </div>
                    <div id="divPrCodeJob" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a5" runat="server" >Price Code on Job</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblPCJob" runat="server" Text="Price Code on Job"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtJobPriceCode"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                            </div>
                        </div>
                        <div style="text-align:left">
                            <input id="btnSavePrCodeJob" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeJob()"/>
                            <input id="btnResetPrCodeJob" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeJob()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a6" runat="server" >Price Code for Mechanic</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeMechT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeMech()"/>
                        <input id="btnDelPrCodeMechT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeMech()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeMech" title="Price Code for Mechanic" ></table>
                        <div id="pagerPrCodeMech"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeMechB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeMech()"/>
                        <input id="btnDelPrCodeMechB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeMech()"/>
                    </div>
                    <div id="divPrCodeMech" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a7" runat="server" >Price Code for Mechanic</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblMechPriceCode" runat="server" Text="Price Code for Mechanic"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtMechPriceCode"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                            </div>
                        </div>
                        <div style="text-align:left">
                            <input id="btnSavePrCodeMech" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeMech()"/>
                            <input id="btnResetPrCodeMech" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeMech()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a8" runat="server" >Price Code for Make</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeMakeT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeMake()"/>
                        <input id="btnDelPrCodeMakeT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeMake()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeMake" title="Price Code for Make" ></table>
                        <div id="pagerPrCodeMake"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeMakeB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeMake()"/>
                        <input id="btnDelPrCodeMakeB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeMake()"/>
                    </div>
                    <div id="divPrCodeMake" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a9" runat="server" >Price Code for Make</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblMakePC" runat="server" Text="Price Code for Make"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtMakePC"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                            </div>
                        </div>
                        <div style="text-align:left">
                            <input id="btnSavePrCodeMake" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeMake()"/>
                            <input id="btnResetPrCodeMake" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeMake()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a10" runat="server" >Price Code for Vehicle Group</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeVehGrpT" runat="server" type="button" value="Add" class="ui button"  onclick="addPrCodeVehGrp()"/>
                        <input id="btnDelPrCodeVehGrpT" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeVehGrp()"/>
                    </div>  
                    <div >
                        <table id="dgdPrCodeVehGrp" title="Price Code for Vehicle Group" ></table>
                        <div id="pagerPrCodeVehGrp"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddPrCodeVehGrpB" runat="server" type="button" value="Add" class="ui button" onclick="addPrCodeVehGrp()"/>
                        <input id="btnDelPrCodeVehGrpB" runat="server" type="button" value="Delete" class="ui button" onclick="delPrCodeVehGrp()"/>
                    </div>
                    <div id="divPrCodeVehGrp" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a11" runat="server" >Price Code for Vehicle Group</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblVehGrpPC" runat="server" Text="Price Code for Vehicle Group"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtVehGrpPC"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                            </div>
                        </div>
                        <div style="text-align:left">
                            <input id="btnSavePrCodeVehGrp" class="ui button" runat="server"  value="Save" type="button" onclick="savePrCodeVehGrp()"/>
                            <input id="btnResetPrCodeVehGrp" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetPrCodeVehGrp()" />
                        </div>               
                   </div>
                </div>

                
            </div><%-- accordion --%>

</asp:Content>