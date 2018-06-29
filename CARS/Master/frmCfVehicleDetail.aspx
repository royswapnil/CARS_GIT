<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfVehicleDetail.aspx.vb" Inherits="CARS.frmCfVehicleDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <%@ Register Src="../UserCtrl/ucWOMenutabs.ascx" TagName="ucWOMenutabs" TagPrefix="uc3" %>
 <script type="text/javascript">
     $(document).ready(function () {
         $('#EditMake').hide();
         $('#EditMdl').hide();
         $('#EditVeh').hide();
         $('#EditLoc').hide();
        
      
         var mydata;
         var mymdldata;
         var myLocdata;
         var myVehdata;

         var grid = $("#dgdMakeCode");
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var Makedata;

         grid.jqGrid({
             datatype: "local",
             data: Makedata,
             colNames: ['Make Code', 'Description', 'Price Code', 'Discount Code', 'Vat Code', 'Id_Make_PriceCode',''],
             colModel: [
                      { name: 'Make_Code', index: 'Make_Code', width: 160, sorttype: "string" },
                      { name: 'Description', index: 'Description', width: 90, sorttype: "string" },
                      { name: 'Price_Code', index: 'Price_Code', width: 90, sorttype: "string" },
                      { name: 'Discount_Code', index: 'Discount_Code', width: 90, sorttype: "string" },
                      { name: 'Vat_Code', index: 'Vat_Code', width: 90, sorttype: "string" },
                      { name: 'ID_MAKE_PRICECODE', index: 'ID_MAKE_PRICECODE', hidden: true },
                       { name: 'Make_Code', index: 'Make_Code', sortable: false, formatter: editMake }

             ],
             multiselect: true,
             pager: jQuery('#pagerMakeCode'),
             rowNum: pageSize,//can fetch from webconfig
             rowList: 5,
             sortorder: 'asc',
             viewrecords: true,
             height: "50%",
             async: false, //Very important,
             subGrid: false
         });

         var mdlgrid = $("#dgdMdlGrp");
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var Modeldata;

         mdlgrid.jqGrid({
             datatype: "local",
             data: Modeldata,
             colNames: ['Model Group', 'Description',''],
             colModel: [
                      { name: 'Model_Group', index: 'Model_Group', width: 160, sorttype: "string" },
                      { name: 'Description', index: 'Description', width: 190, sorttype: "string" },
                      { name: 'Model_Group', index: 'Model_Group', sortable: false, formatter: editModel }
                     

             ],
             multiselect: true,
             pager: jQuery('#pagerMdlGrp'),
             rowNum: pageSize,//can fetch from webconfig
             rowList: 5,
             sortorder: 'asc',
             viewrecords: true,
             height: "50%",
             async: false, //Very important,
             subGrid: false
         });

         var locgrid = $("#dgdLoc");
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var Locationdata;

         locgrid.jqGrid({
             datatype: "local",
             data: Locationdata,
             colNames: ['Location', 'Id Settings', ''],
             colModel: [
                      { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                      { name: 'Id_Settings', index: 'Id_Settings', hidden: true },
                      { name: 'Description', index: 'Description', sortable: false, formatter: editLoc }


             ],
             multiselect: true,
             pager: jQuery('#pagerLoc'),
             rowNum: pageSize,//can fetch from webconfig
             rowList: 5,
             sortorder: 'asc',
             viewrecords: true,
             height: "50%",
             async: false, //Very important,
             subGrid: false
         });


         var vehgrid = $("#dgdVehGrp");
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var Vehdata;

         vehgrid.jqGrid({
             datatype: "local",
             data: Vehdata,
             colNames: ['Vehicle Group', 'Description', 'Price Code', 'Interval Name','Id Settings',''],
             colModel: [
                      { name: 'Id_Veh_Grp', index: 'Id_Veh_Grp', width: 160, sorttype: "string" },
                      { name: 'Veh_Description', index: 'Veh_Description', width: 90, sorttype: "string" },
                      { name: 'Id_Vg_PCode', index: 'Id_Vg_PCode', width: 90, sorttype: "string" },
                      { name: 'Vh_IntervalName', index: 'Vh_IntervalName', width: 90, sorttype: "string" },
                       { name: 'Id_Settings', index: 'Id_Settings', hidden:true },
                       { name: 'Id_Veh_Grp', index: 'Id_Veh_Grp', sortable: false, formatter: editVehicle }

             ],
             multiselect: true,
             pager: jQuery('#pagerVehGrp'),
             rowNum: pageSize,//can fetch from webconfig
             rowList: 5,
             sortorder: 'asc',
             viewrecords: true,
             height: "50%",
             async: false, //Very important,
             subGrid: false
         });
         
         FetchConfiguration();
        


         //ADD
         $('#<%=btnMakeCodeAdd1.ClientID%>').on('click', function () {
             $('#EditMake').show();
             $("#<%=txtMakeCode.ClientID%>")[0].readOnly = false; 
             $('#<%=txtMakeCode.ClientID%>').focus();
             $('#<%=txtMakeCode.ClientID%>').val("");
             $('#<%=txtMakeName.ClientID%>').val("");
             $('#<%=drpMKpcode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpMKDiscCode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpMKVatCode.ClientID%>')[0].selectedIndex = 0;
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
         });
         $('#<%=btnMdlGpDescAdd1.ClientID%>').on('click', function () {
             $('#EditMdl').show();
             $("#<%=txtMdlGpModel.ClientID%>")[0].readOnly = false; 
             $('#<%=txtMdlGpModel.ClientID%>').focus();
             $('#<%=txtMdlGpModel.ClientID%>').val("");
             $('#<%=txtMdlGpDesc.ClientID%>').val("");
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
         });
         $('#<%=btnGrpAdd1.ClientID%>').on('click', function () {
             $('#EditVeh').show();
             $("#<%=txtVehicleGrp.ClientID%>")[0].readOnly = false; 
             $('#<%=txtVehicleGrp.ClientID%>').focus();
             $('#<%=txtVehicleGrp.ClientID%>').val("");
             $('#<%=txtVGDesc.ClientID%>').val("");
             $('#<%=drpVGpcode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpVGIntName.ClientID%>')[0].selectedIndex = 0;
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
         });
         $('#<%=btnLocAdd1.ClientID%>').on('click', function () {
             $('#EditLoc').show();
             $('#<%=txtLoc.ClientID%>').focus();
             $('#<%=txtLoc.ClientID%>').val("");
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
         });

         //UPDATE
         $('#<%=btnSaveMake.ClientID%>').on('click', function () {
             if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add")
             {
                 updVehMakeConfig();

             }
             else
             {
                 saveVehMakeConfig();
             }
         });

         $('#<%=btnMdlGpDescSave.ClientID%>').on('click', function () {
             if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add")
             {
                 updVehModelConfig();

             }
             else
             {
                 saveVehModelConfig();
             }
         });
         $('#<%=btnGpSave.ClientID%>').on('click', function () {
             if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add")
             {
                 updVehGrpConfig();
             }
             else
             {
                 saveVehGrpConfig();
             }
         });
         $('#<%=btnLocSave.ClientID%>').on('click', function () {
             debugger;
             if ($(document.getElementById('<%=hdnMode.ClientID%>')).val() != "Add") {
                 updLocation();
             }
             else {
                 saveLocation();
             }
         });

         //Cancel
         $('#<%=btnCancelMake.ClientID%>').on('click', function () {
             $('#EditMake').hide();
             $('#<%=txtMakeCode.ClientID%>').val("");
             $('#<%=txtMakeName.ClientID%>').val("");
             $('#<%=drpMKpcode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpMKDiscCode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpMKVatCode.ClientID%>')[0].selectedIndex = 0;
            
         });

         $('#<%=btnMdlGpDescCancel.ClientID%>').on('click', function () {
             $('#EditMdl').hide();
             $('#<%=txtMdlGpModel.ClientID%>').val("");
             $('#<%=txtMdlGpDesc.ClientID%>').val("");
         });
         $('#<%=btnGpCancel.ClientID%>').on('click', function () {
             $('#EditVeh').hide();
             $('#<%=txtVehicleGrp.ClientID%>').val("");
             $('#<%=txtVGDesc.ClientID%>').val("");
             $('#<%=drpVGpcode.ClientID%>')[0].selectedIndex = 0;
             $('#<%=drpVGIntName.ClientID%>')[0].selectedIndex = 0;
         });

         $('#<%=btnLocCancel.ClientID%>').on('click', function () {
             $('#EditLoc').hide();
             $('#<%=txtLoc.ClientID%>').val("");
          });
         
        
     });//End Of Ready 


     function fnValidateSpCh() {

         if (!(gfi_CheckEmpty($('#<%=txtMakeCode.ClientID%>'), '0181'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtMakeCode.ClientID%>'), '0181'))) {
             return false;
         }

         if (!(gfi_CheckEmpty($('#<%=txtMakeName.ClientID%>'), '0182'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtMakeName.ClientID%>'), '0182'))) {
             return false;
         }
         if ($('#<%=drpMKVatCode.ClientID%>')[0].selectedIndex == "0") {
             var msg = GetMultiMessage('0007', GetMultiMessage('0149', '', ''), '');
             alert(msg);
             $('#<%=drpMKVatCode.ClientID%>').focus();
             return false;
         }
         return true;
     }

     function fnValidateSpChMdl() {

         if (!(gfi_CheckEmpty($('#<%=txtMdlGpModel.ClientID%>'), '0190'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtMdlGpModel.ClientID%>'), '0190'))) {
             return false;
         }

         if (!(gfi_CheckEmpty($('#<%=txtMdlGpDesc.ClientID%>'), '0183'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtMdlGpDesc.ClientID%>'), '0183'))) {
             return false;
         }
         return true;
         window.scrollTo(0, 0);
     }

     function fnValidateSpChVehGp() {

         if (!(gfi_CheckEmpty($('#<%=txtVehicleGrp.ClientID%>'), '0184'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtVehicleGrp.ClientID%>'), '0184'))) {
             return false;
         }

         if (!(ValidateAlphabets($('#<%=txtVGDesc.ClientID%>'), '0185'))) {
             return false;
         }
         return true;
         window.scrollTo(0, 0);
     }

     function fnClientValidateLocation() {

         if (!(gfi_CheckEmpty($('#<%=txtLoc.ClientID%>'), '0043'))) {
             return false;
         }
         if (!(ValidateAlphabets($('#<%=txtLoc.ClientID%>'), '0043'))) {
             return false;
         }
         return true;
         window.scrollTo(0, 0);
     }


     function FetchConfiguration() {
         $.ajax({
             type: "POST",
             contentType: "application/json; charset=utf-8",
             url: "frmCfVehicleDetail.aspx/Fetch_Config",
             data: {},
             dataType: "json",
             async: false,//Very important
             success: function (Result) {
                 BindMakeCodeGrid(Result.d[0]);
                 LoadPriceCode(Result.d[1]);
                 LoadDiscCode();
                 LoadVatCode();
                 BindModelGrpGrid(Result.d[2]);
                 BindLocGrid(Result.d[3]);
                 BindVehGrid(Result.d[4]);
                 LoadVehGrpPCode(Result.d[5]);
                 LoadVehInternalNm(Result.d[6]);
             }
         });
     }

     function BindMakeCodeGrid(result) {
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         jQuery("#dgdMakeCode").jqGrid('clearGridData');
         for (i = 0; i < result.length; i++) {
             mydata = result;
             jQuery("#dgdMakeCode").jqGrid('addRowData', i + 1, mydata[i]);
         }
         jQuery("#dgdMakeCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         $("#dgdMakeCode").jqGrid("hideCol", "subgrid");
     }
     function BindModelGrpGrid(result) {
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         jQuery("#dgdMdlGrp").jqGrid('clearGridData');
         for (i = 0; i < result.length; i++) {
             mymdldata = result;
             jQuery("#dgdMdlGrp").jqGrid('addRowData', i + 1, mymdldata[i]);
         }
         jQuery("#dgdMdlGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         $("#dgdMdlGrp").jqGrid("hideCol", "subgrid");
     }
     function BindLocGrid(result) {
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         jQuery("#dgdLoc").jqGrid('clearGridData');
         for (i = 0; i < result.length; i++) {
             myLocdata = result;
             jQuery("#dgdLoc").jqGrid('addRowData', i + 1, myLocdata[i]);
         }
         jQuery("#dgdLoc").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         $("#dgdLoc").jqGrid("hideCol", "subgrid");
     }

     function BindVehGrid(result) {
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         jQuery("#dgdVehGrp").jqGrid('clearGridData');
         for (i = 0; i < result.length; i++) {
             myVehdata = result;
             jQuery("#dgdVehGrp").jqGrid('addRowData', i + 1, myVehdata[i]);
         }
         jQuery("#dgdVehGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         $("#dgdVehGrp").jqGrid("hideCol", "subgrid");
     }

     function editMake(cellvalue, options, rowObject) {
         $("#<%=txtMakeCode.ClientID%>")[0].readOnly = true; 
         var makeCode = rowObject.Make_Code;
         var strOptions = cellvalue;
         var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
         $('#<%=hdnMode.ClientID%>').val("Edit");
         var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=MakeDet(" + "'" + makeCode + "'"+ "); />";
         return edit;
     }

     function editModel(cellvalue, options, rowObject) {
         $("#<%=txtMdlGpModel.ClientID%>")[0].readOnly = true; 
         $('#<%=hdnMode.ClientID%>').val("Edit");
         var idModel = rowObject.Model_Group;
         var strOptions = cellvalue;
         var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
         var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=ModelEdt(" + "'" + idModel + "'" + "); />";
         return edit;
     }
     function editLoc(cellvalue, options, rowObject) {
         $('#<%=hdnMode.ClientID%>').val("Edit");
         var location = rowObject.Description;
         var strOptions = cellvalue;
         var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
         var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=LocEdit(" + "'" + location + "'" + "); />";
         return edit;
     }

     function editVehicle(cellvalue, options, rowObject) {
         $("#<%=txtVehicleGrp.ClientID%>")[0].readOnly = true; 
         $('#<%=hdnMode.ClientID%>').val("Edit");
         var idVehGrp = rowObject.Id_Veh_Grp;
         var strOptions = cellvalue;
         var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
         var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=VehEdit(" + "'" + idVehGrp + "'" + "); />";
         return edit;
     }

   
     function MakeDet(makeCode) {
         $('#EditMake').show();
         $('#<%=txtMakeCode.ClientID%>').focus();
         var rowData = $('#dgdMakeCode').jqGrid('getGridParam', 'data');
         for (var i = 0; i < rowData.length; i++) {
             if (rowData[i].Make_Code == makeCode)
             {
                 $("#<%=txtMakeCode.ClientID%>").val(rowData[i].Make_Code);
                 $("#<%=txtMakeName.ClientID%>").val(rowData[i].Description);
                 //$("#<%=drpMKpcode.ClientID%>").val(rowData[i].Price_Code);
                 $('#<%=drpMKpcode.ClientID%> option:contains("' + rowData[i].Price_Code + '")').attr('selected', 'selected');
                 $("#<%=drpMKDiscCode.ClientID%>").val(rowData[i].Discount_Code);
                 $("#<%=drpMKVatCode.ClientID%>").val(rowData[i].Vat_Code);
             }
         }
     }
     function ModelEdt(IdModel) {
         $('#EditMdl').show();
         $('#<%=txtMdlGpModel.ClientID%>').focus();
         var rowData = $('#dgdMdlGrp').jqGrid('getGridParam', 'data');
         for (var i = 0; i < rowData.length; i++) {
             if (rowData[i].Model_Group == IdModel) {
                 $("#<%=txtMdlGpModel.ClientID%>").val(rowData[i].Model_Group);
                 $("#<%=txtMdlGpDesc.ClientID%>").val(rowData[i].Description);
                 
             }
         }
     }

     function LocEdit(loc) {
         $('#EditLoc').show();
         $('#<%=txtLoc.ClientID%>').focus();
         var rowData = $('#dgdLoc').jqGrid('getGridParam', 'data');
         for (var i = 0; i < rowData.length; i++) {
             if (rowData[i].Description == loc) {
                 $('#<%=hdnLocSettings.ClientID%>').val(rowData[i].Id_Settings);
                 $("#<%=txtLoc.ClientID%>").val(rowData[i].Description);

             }
         }
     }


     function VehEdit(idVehGrp) {
         $('#EditVeh').show();
         $('#<%=txtVehicleGrp.ClientID%>').focus();
         var rowData = $('#dgdVehGrp').jqGrid('getGridParam', 'data');
         for (var i = 0; i < rowData.length; i++) {
             if (rowData[i].Id_Veh_Grp == idVehGrp) {
                 $('#<%=hdnIdSettings.ClientID%>').val(rowData[i].Id_Settings);
                 $("#<%=txtVehicleGrp.ClientID%>").val(rowData[i].Id_Veh_Grp);
                 $("#<%=txtVGDesc.ClientID%>").val(rowData[i].Veh_Description);
                 //$("#<%=drpMKpcode.ClientID%>").val(rowData[i].Price_Code);
                 if (rowData[i].Id_Vg_PCode != "") {
                     $("#<%=drpVGpcode.ClientID%>").val(rowData[i].Id_Vg_PCode);
                 }
                 else {
                     $('#<%=drpVGpcode.ClientID%>')[0].selectedIndex = 0;
                 }

                 if(rowData[i].Vh_IntervalName != "")
                 {
                     $("#<%=drpVGIntName.ClientID%>").val(rowData[i].Vh_IntervalName);
                 }
                 else
                 {
                     $('#<%=drpVGIntName.ClientID%>')[0].selectedIndex = 0;
                 }
                
             }
         }
     }


     function LoadPriceCode(result) {
         $('#<%=drpMKpcode.ClientID%>').empty();
         $('#<%=drpMKpcode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
         var Result = result;
         $.each(Result, function (key, value) {
             $('#<%=drpMKpcode.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
         });
     }
     function LoadDiscCode() {
         $.ajax({
             type: "POST",
             url: "frmCfVehicleDetail.aspx/LoadDiscCode",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (Result) {
                 $('#<%=drpMKDiscCode.ClientID%>').empty();
                 $('#<%=drpMKDiscCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                 Result = Result.d;
                 $.each(Result, function (key, value) {
                     $('#<%=drpMKDiscCode.ClientID%>').append($("<option></option>").val(value.Description).html(value.Description));
                    
                 });

             },
             failure: function () {
                 alert("Failed!");
             }
         });
         
     }
     function LoadVatCode()
     {
         $.ajax({
             type: "POST",
             url: "frmCfVehicleDetail.aspx/LoadVatCode",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (Result) {
                 $('#<%=drpMKVatCode.ClientID%>').empty();
                 $('#<%=drpMKVatCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                 Result = Result.d;
                 $.each(Result, function (key, value) {
                     $('#<%=drpMKVatCode.ClientID%>').append($("<option></option>").val(value.Description).html(value.Description));

                 });

             },
             failure: function () {
                 alert("Failed!");
             }
         });
     }
     function LoadVehGrpPCode(result) {
         $('#<%=drpVGpcode.ClientID%>').empty();
         $('#<%=drpVGpcode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

         Result = result;
         $.each(Result, function (key, value) {
             $('#<%=drpVGpcode.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

         });
     }
     function LoadVehInternalNm(result) {
         $('#<%=drpVGIntName.ClientID%>').empty();
         $('#<%=drpVGIntName.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

         Result = result;
         $.each(Result, function (key, value) {
             $('#<%=drpVGIntName.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Id_Settings));

         });
     }
     function updVehMakeConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var strXMLSettingsVehMakeUpdate = "<ROOT></ROOT>";
         var strXMLSettingsModelupdate = "<ROOT></ROOT>";
         var idMake = $("#<%=txtMakeCode.ClientID%>").val();
         var idMakeName = $("#<%=txtMakeName.ClientID%>").val();
         var idMakePC = $("#<%=drpMKpcode.ClientID%>").val();
         var makeDiscCode = $("#<%=drpMKDiscCode.ClientID%>").val();
         var makeVatcode = $("#<%=drpMKVatCode.ClientID%>").val();
           
           

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/MakeConfigDetails",
                 data: "{idMake:'" + idMake + "', idMakeName:'" + idMakeName + "', idMakePCode:'" + idMakePC + "', makeDiscCode:'" + makeDiscCode + "', makeVatCode:'" + makeVatcode + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "") {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage"); 
                         $('#EditMake').hide();
                     }
                     else {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }
                     FetchConfiguration();
                 },
                 error: function (result) {
                     alert("Error");
                 }
             });
      
     }


     function saveVehMakeConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var result = fnValidateSpCh()
         if (result == true) {
             var strXMLSettingsVehMakeUpdate = "<ROOT></ROOT>";
             var strXMLSettingsModelupdate = "<ROOT></ROOT>";
             var idMake = $("#<%=txtMakeCode.ClientID%>").val();
             var idMakeName = $("#<%=txtMakeName.ClientID%>").val();
             var idMakePC = $("#<%=drpMKpcode.ClientID%>").val();
             var makeDiscCode = $("#<%=drpMKDiscCode.ClientID%>").val();
             var makeVatcode = $("#<%=drpMKVatCode.ClientID%>").val();



             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/MakeConfigDetails",
                 data: "{idMake:'" + idMake + "', idMakeName:'" + idMakeName + "', idMakePCode:'" + idMakePC + "', makeDiscCode:'" + makeDiscCode + "', makeVatCode:'" + makeVatcode + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "") {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         $('#EditMake').hide();
                     }
                     else {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }
                     FetchConfiguration();
                 },
                 error: function (result) {
                     alert("Error");
                 }
             });
         }
     }

     function updVehModelConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var strXMLSettingsVehMakeUpdate = "<ROOT></ROOT>";
         var strXMLSettingsModelupdate = "<ROOT></ROOT>";
         var idModel = $("#<%=txtMdlGpModel.ClientID%>").val();
         var idModelDesc = $("#<%=txtMdlGpDesc.ClientID%>").val();
        

         $.ajax({
             type: "POST",
             contentType: "application/json; charset=utf-8",
             url: "frmCfVehicleDetail.aspx/ModelConfigDetails",
             data: "{IdModel:'" + idModel + "', ModelDesc:'" + idModelDesc + "', mode:'" + mode + "'}",
             dataType: "json",
             async: false,
             success: function (data) {
                 data = data.d[0];
                 if (data.RetVal_Saved != "") {
                     $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                     $('#<%=RTlblError.ClientID%>').removeClass();
                     $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                     $('#EditMdl').hide();
                 }
                 else {
                     $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                     $('#<%=RTlblError.ClientID%>').removeClass();
                     $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                 }
                 FetchConfiguration();
             },
             error: function (result) {
                 alert("Error");
             }
         });

     }

     function saveVehModelConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var result = fnValidateSpChMdl()
         if (result == true) {
             var strXMLSettingsVehMakeUpdate = "<ROOT></ROOT>";
             var strXMLSettingsModelupdate = "<ROOT></ROOT>";
             var idModel = $("#<%=txtMdlGpModel.ClientID%>").val();
             var idModelDesc = $("#<%=txtMdlGpDesc.ClientID%>").val();

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/ModelConfigDetails",
                 data: "{IdModel:'" + idModel + "', ModelDesc:'" + idModelDesc + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "") {
                         $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         $('#EditMdl').hide();
                     }
                     else {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }
                     FetchConfiguration();
                 },
                 error: function (result) {
                     alert("Error");
                 }
             });
         }
     }

     function updVehGrpConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var strXMLSettingsVehGrpUpdate = "<ROOT></ROOT>";
         var idSett = $("#<%=hdnIdSettings.ClientID%>").val();
         var description = $("#<%=txtVehicleGrp.ClientID%>").val();
         var remarks = $("#<%=txtVGDesc.ClientID%>").val();
         var VGPcode = $("#<%=drpVGpcode.ClientID%>").val();
         var intvCode = $("#<%=drpVGIntName.ClientID%>").val();


         $.ajax({
             type: "POST",
             contentType: "application/json; charset=utf-8",
             url: "frmCfVehicleDetail.aspx/VehGrpConfigDet",
             data: "{IdSettings:'" + idSett + "', Desc:'" + description + "', Remarks:'" + remarks + "', VGPCode:'" + VGPcode + "', IntervalCode:'" + intvCode + "', mode:'" + mode + "'}",
             dataType: "json",
             async: false,
             success: function (data) {
                 data = data.d[0];
                 if (data.RetVal_Saved != "") {
                     $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                     $('#<%=RTlblError.ClientID%>').removeClass();
                     $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                     $('#EditVeh').hide();
                 }
                 else {
                     $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                     $('#<%=RTlblError.ClientID%>').removeClass();
                     $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                 }
                 FetchConfiguration();
             },
             error: function (result) {
                 alert("Error");
             }
         });

     }
     function saveVehGrpConfig() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var result = fnValidateSpChVehGp();
         if (result == true) {
             var strXMLSettingsVehGrpUpdate = "<ROOT></ROOT>";
             var idSett = $("#<%=hdnIdSettings.ClientID%>").val();
             var description = $("#<%=txtVehicleGrp.ClientID%>").val();
             var remarks = $("#<%=txtVGDesc.ClientID%>").val();
             var VGPcode = $("#<%=drpVGpcode.ClientID%>").val();
             var intvCode = $("#<%=drpVGIntName.ClientID%>").val();


             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/VehGrpConfigDet",
                 data: "{IdSettings:'" + idSett + "', Desc:'" + description + "', Remarks:'" + remarks + "', VGPCode:'" + VGPcode + "', IntervalCode:'" + intvCode + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "") {
                         $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         $('#EditVeh').hide();
                     }
                     else {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }
                     FetchConfiguration();
                 },
                 error: function (result) {
                     alert("Error");
                 }
             });

         }
     }

     function saveLocation() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var result = fnClientValidateLocation();
         if (result == true) {
             var idSett = "LOC"
             var locDesc = $("#<%=txtLoc.ClientID%>").val();
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/LocationConfigDet",
                 data: "{Desc:'" + locDesc + "', IdSettings:'" + idSett + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "") {
                         $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         $('#EditLoc').hide();

                     }
                     else {
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                     }
                     FetchConfiguration();
                 },
                 error: function (result) {
                     alert("Error");
                 }
             });
         }
     }
     function updLocation() {
         var mode = $('#<%=hdnMode.ClientID%>').val();
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var locDesc = $("#<%=txtLoc.ClientID%>").val();
         var idSett = $('#<%=hdnLocSettings.ClientID%>').val();
         $.ajax({
             type: "POST",
             contentType: "application/json; charset=utf-8",
             url: "frmCfVehicleDetail.aspx/LocationConfigDet",
             data: "{Desc:'" + locDesc + "', IdSettings:'" + idSett + "', mode:'" + mode + "'}",
             dataType: "json",
             async: false,
             success: function (data) {
                 data = data.d[0];
                     $('#<%=RTlblError.ClientID%>').text(data.RetVal_Saved + GetMultiMessage('MSG126', '', ''));
                     $('#<%=RTlblError.ClientID%>').removeClass();
                     $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                     $('#EditLoc').hide();
                     FetchConfiguration();
                
             },
             error: function (result) {
                 alert("Error");
             }
         });
     }

     function delMake() {
         var makeId = "";
         $('#dgdMakeCode input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 makeId = $('#dgdMakeCode tr ')[row].cells[2].innerHTML.toString();
             }
         });

         if (makeId != "") {
             var msg = GetMultiMessage('0016', '', '');
             var r = confirm(msg);
             if (r == true) {
                 delMakeConfig();
             }
         }
         else {
             var msg = GetMultiMessage('SelectRecord', '', '');
             alert(msg);
         }
     }

     function delMakeConfig() {
         var row;
         var makeId;
         var makeDesc;
         var makeIdxml;
         var makeIdxmls = "";
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

         $('#dgdMakeCode input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 makeId = $('#dgdMakeCode tr ')[row].cells[1].innerHTML.toString();
                 makeDesc = $('#dgdMakeCode tr ')[row].cells[2].innerHTML.toString();
                 makeIdxml = '<delete><ID-MAKE ID_MAKE= "' + makeId + '" ID_MAKE_NAME= "' + makeDesc + '"/></delete>';
                 makeIdxmls += makeIdxml;
             }
         });

         if (makeIdxmls != "") {
             makeIdxmls = "<root>" + makeIdxmls + "</root>";
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/DeleteMakeConfig",
                 data: "{makeIdxml: '" + makeIdxmls + "'}",
                 dataType: "json",
                 success: function (data) {
                     jQuery("#dgdMakeCode").jqGrid('clearGridData');
                     FetchConfiguration();
                     jQuery("#dgdMakeCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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


     function delModel() {
         var idMdlGrp = "";
         $('#dgdMdlGrp input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idMdlGrp = $('#dgdMdlGrp tr ')[row].cells[1].innerHTML.toString();
             }
         });

         if (idMdlGrp != "") {
             var msg = GetMultiMessage('0016', '', '');
             var r = confirm(msg);
             if (r == true) {
                 delModelConfig();
             }
         }
         else {
             var msg = GetMultiMessage('SelectRecord', '', '');
             alert(msg);
         }
     }

     function delModelConfig() {
         var row;
         var idMdlGrp;
         var mdlGrpDesc;
         var modelIdxml;
         var modelIdxmls = "";
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

         $('#dgdMdlGrp input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idMdlGrp = $('#dgdMdlGrp tr ')[row].cells[1].innerHTML.toString();
                 mdlGrpDesc = $('#dgdMdlGrp tr ')[row].cells[2].innerHTML.toString();
                 modelIdxml = '<delete><ID-GROUP ID_SETTINGS= "' + idMdlGrp + '" ID_CONFIG= " MODEL" DESCRIPTION= "' + mdlGrpDesc + '"/></delete>';
                 modelIdxmls += modelIdxml;
             }
         });

         if (modelIdxmls != "") {
             modelIdxmls = "<root>" + modelIdxmls + "</root>";
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/DeleteModelConfig",
                 data: "{modelIdxml: '" + modelIdxmls + "'}",
                 dataType: "json",
                 success: function (data) {
                     jQuery("#dgdMdlGrp").jqGrid('clearGridData');
                    FetchConfiguration();
                     jQuery("#dgdMdlGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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
     


     function delVehGrp() {
         var idvehGrp = "";
         $('#dgdVehGrp input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idvehGrp = $('#dgdVehGrp tr ')[row].cells[1].innerHTML.toString();
             }
         });

         if (idvehGrp != "") {
             var msg = GetMultiMessage('0016', '', '');
             var r = confirm(msg);
             if (r == true) {
                 delVehGrpConfig();
             }
         }
         else {
             var msg = GetMultiMessage('SelectRecord', '', '');
             alert(msg);
         }
     }

     function delVehGrpConfig() {
         var row;
         var idvehGrp;
         var vehGrpDesc;
         var idSett;
         var vehIdxml;
         var vehIdxmls = "";
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

         $('#dgdVehGrp input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idvehGrp = $('#dgdVehGrp tr ')[row].cells[1].innerHTML.toString();
                 vehGrpDesc = $('#dgdVehGrp tr ')[row].cells[2].innerText.toString();
                 idSett = $('#dgdVehGrp tr ')[row].cells[5].innerHTML.toString();
                 vehIdxml = '<delete><VEH-GROUP ID_SETTINGS= "' + idSett + '" DESCRIPTION= "' + vehGrpDesc + '"  ID_CONFIG= " VEH-GROUP" ID_VEH_GRP= "' + idvehGrp + '"/></delete>';
                 vehIdxmls += vehIdxml;
             }
         });

         if (vehIdxmls != "") {
             vehIdxmls = "<root>" + vehIdxmls + "</root>";
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/DeleteVehGroup",
                 data: "{vehIdxml: '" + vehIdxmls + "'}",
                 dataType: "json",
                 success: function (data) {
                     jQuery("#dgdVehGrp").jqGrid('clearGridData');
                     FetchConfiguration();
                     jQuery("#dgdVehGrp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

     function delLoc() {
         var idSett = "";
         $('#dgdLoc input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idSett = $('#dgdLoc tr ')[row].cells[2].innerHTML.toString();
             }
         });

         if (idSett != "") {
             var msg = GetMultiMessage('0016', '', '');
             var r = confirm(msg);
             if (r == true) {
                 delLocConfig();
             }
         }
         else {
             var msg = GetMultiMessage('SelectRecord', '', '');
             alert(msg);
         }
     }

     function delLocConfig() {
         var row;
         var idSett;
         var loc;
         var locIdxml;
         var locIdxmls = "";
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

         $('#dgdLoc input:checkbox').attr("checked", function () {
             if (this.checked) {
                 row = $(this).closest('td').parent()[0].sectionRowIndex;
                 idSett = $('#dgdLoc tr ')[row].cells[2].innerHTML.toString();
                 loc = $('#dgdLoc tr ')[row].cells[1].innerText.toString();
                 locIdxml = '<delete><LOC ID_SETTINGS= "' + idSett + '" ID_CONFIG= "LOC" DESCRIPTION= "' + loc + '"/></delete>';
                 locIdxmls += locIdxml;
             }
         });

         if (locIdxmls != "") {
             locIdxmls = "<root>" + locIdxmls + "</root>";
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfVehicleDetail.aspx/DeleteLoc",
                 data: "{locIdxml: '" + locIdxmls + "'}",
                 dataType: "json",
                 success: function (data) {
                     jQuery("#dgdLoc").jqGrid('clearGridData');
                     FetchConfiguration();
                     jQuery("#dgdLoc").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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
 </script>
    <div class="header1 two fields" >
        <asp:Label ID="lblHead" runat="server" Text="Work Order Details" ></asp:Label>
        <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
        <asp:HiddenField ID="hdnSelect" runat="server" />
        <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
        <asp:HiddenField id="hdnMode" runat="server" />  
        <asp:HiddenField id="hdnIdSettings" runat="server" />  
        <asp:HiddenField id="hdnLocSettings" runat="server" />  
        <asp:Label ID="Label1" runat="server"  CssClass="lblErr"></asp:Label>  
</div>
     <div></div>
    <div>
        <uc3:ucWOMenutabs ID="UcWOMenutabs1" runat="server" />
    </div>
<div  class="ui raised segment signup inactive">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">MakeCode</a>  
            </div>  
      <div class="ui form" style="width:100%;height:100%;overflow-y:hidden">
               
                    <div style="text-align:center" >
                         <input id="btnMakeCodeAdd1" runat="server" type="button" value="Add" class="ui button" />
                         <input id="btnMakeCodeDelete1" runat="server" type="button" value="Delete" class="ui button" onclick="delMake()" />
                    </div>
                   <div id ="makeGrid" style="text-align:center">
                        <table id="dgdMakeCode"></table>
                        <div id="pagerMakeCode" ></div>
                   </div>
        <div id="EditMake">
           <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMakeCode" runat="server" Text="Make Code"></asp:Label><span class="mand">*</span>
            </div>
            <div class="field" style="width:220px">
                 <asp:TextBox ID="txtMakeCode" runat="server" Width="90px" MaxLength="10" CssClass="inp"></asp:TextBox>
            </div>
            </div>
            <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMakeName" runat="server" Text="Description"></asp:Label><span class="mand">*</span>
            </div>
            <div class="field" style="width:220px">
                <asp:TextBox ID="txtMakeName" runat="server" Width="90px"  CssClass="inp"></asp:TextBox>
            </div>
            </div>
        <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMKpricecode" runat="server" Text="Price Code"></asp:Label>
            </div>
               
            <div class="field" style="width:220px">
                <asp:DropDownList ID="drpMKpcode" runat="server" Width="90px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
        <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMKDiscCode" runat="server" Text="Discount Code"></asp:Label>
            </div>
              
            <div class="field" style="width:220px">
                <asp:DropDownList ID="drpMKDiscCode" runat="server" Width="90px" CssClass="drpdwm"></asp:DropDownList>
            </div>
        </div>
          <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMKVatCode" runat="server" Text="Vat Code"></asp:Label><span class="mand">*</span>
            </div>
            <div class="field" style="width:220px">
                <asp:DropDownList ID="drpMKVatCode" runat="server" Width="90px" CssClass="drpdwm"></asp:DropDownList>
            </div>
         </div>
             <div style="text-align:center">
            <input id="btnSaveMake" runat="server" type="button" value="Save" class="ui button" />
            <input id="btnCancelMake" runat="server" type="button" value="Cancel" class="ui button" />
            </div>
       </div>
           <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A1" runat="server" class="active item">ModelGroup</a>  
            </div> 
           <div style="text-align:center" >
                         <input id="btnMdlGpDescAdd1" runat="server" type="button" value="Add" class="ui button" />
                         <input id="btnMdlGpDescDel1" runat="server" type="button" value="Delete" class="ui button" onclick="delModel()"/>
              </div>
            <div id ="modelGrid">
                <table id="dgdMdlGrp"></table>
                 <div id="pagerMdlGrp" ></div>
            </div>
          <div id="EditMdl">
             <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMdlGrp" runat="server" Text="Model Group"></asp:Label><span class="mand">*</span>
            </div>
            <div class="field" style="width:220px">
                 <asp:TextBox ID="txtMdlGpModel" runat="server" Width="90px"  CssClass="inp"></asp:TextBox>
            </div>
            </div>
            <div class="six fields lbl">
             <div class="field" style="padding-left:0.55em;width:150px">
                <asp:Label ID="lblMdlGpDescCancel" runat="server" Text="Description"></asp:Label><span class="mand">*</span>
            </div>
            <div class="field" style="width:220px">
                <asp:TextBox ID="txtMdlGpDesc" runat="server" Width="90px"  CssClass="inp"></asp:TextBox>
            </div>
            </div>
                <div style="text-align:center">
            <input id="btnMdlGpDescSave" runat="server" type="button" value="Save" class="ui button" />
            <input id="btnMdlGpDescCancel" runat="server" type="button" value="Cancel" class="ui button" />
            </div>
          </div>

           <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A2" runat="server" class="active item">VehicleGroup</a>  
            </div> 
           <div style="text-align:center" >
                         <input id="btnGrpAdd1" runat="server" type="button" value="Add" class="ui button" />
                         <input id="btnGrpDel1" runat="server" type="button" value="Delete" class="ui button" onclick="delVehGrp()" />
            </div>
            <div id ="VehicleGrid">
                <table id="dgdVehGrp"></table>
                 <div id="pagerVehGrp" ></div>
            </div>

          <div id="EditVeh">
                 <div class="six fields lbl">
                 <div class="field" style="padding-left:0.55em;width:150px">
                    <asp:Label ID="lblVehicleGp" runat="server" Text="Vehicle Group"></asp:Label><span class="mand">*</span>
                </div>
                <div class="field" style="width:220px">
                     <asp:TextBox ID="txtVehicleGrp" runat="server" Width="150px"  CssClass="inp"></asp:TextBox>
                </div>
                </div>
              <div class="six fields lbl">
                 <div class="field" style="padding-left:0.55em;width:150px">
                    <asp:Label ID="lblVGDesc" runat="server" Text="Description"></asp:Label>
                </div>
                <div class="field" style="width:220px">
                     <asp:TextBox ID="txtVGDesc" runat="server" Width="150px"  CssClass="inp"></asp:TextBox>
                </div>
                </div>
               <div class="six fields lbl">
                 <div class="field" style="padding-left:0.55em;width:150px">
                    <asp:Label ID="lblVGPricecode" runat="server" Text="Price Code"></asp:Label>
                </div>
                <div class="field" style="width:220px">
                      <asp:DropDownList ID="drpVGpcode" runat="server" Width="90px" CssClass="drpdwm" ></asp:DropDownList>
                </div>
                </div>
              <div class="six fields lbl">
                 <div class="field" style="padding-left:0.55em;width:150px">
                    <asp:Label ID="lblVGIntName" runat="server" Text="Interval Name"></asp:Label>
                </div>
                <div class="field" style="width:220px">
                      <asp:DropDownList ID="drpVGIntName" runat="server" Width="90px" CssClass="drpdwm" ></asp:DropDownList>
                </div>
                </div>

               <div style="text-align:center">
                <input id="btnGpSave" runat="server" type="button" value="Save" class="ui button" />
                <input id="btnGpCancel" runat="server" type="button" value="Cancel" class="ui button" />
            </div>
            </div>

          <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="A3" runat="server" class="active item">Location</a>  
            </div> 
           <div style="text-align:center" >
                 <input id="btnLocAdd1" runat="server" type="button" value="Add" class="ui button" />
                <input id="btnLocDel1" runat="server" type="button" value="Delete" class="ui button" onclick="delLoc()" />
              
            </div>
            <div id ="LocGrid">
                <table id="dgdLoc"></table>
                <div id="pagerLoc" ></div>
            </div>
             <div id="EditLoc">
                 <div class="six fields lbl">
                 <div class="field" style="padding-left:0.55em;width:150px">
                    <asp:Label ID="lblLoc" runat="server" Text="Location"></asp:Label><span class="mand">*</span>
                </div>
                <div class="field" style="width:220px">
                     <asp:TextBox ID="txtLoc" runat="server" Width="150px"  CssClass="inp"></asp:TextBox>
                </div>
                </div>
                 <div style="text-align:center" >
                  <input id="btnLocSave" runat="server" type="button" value="Save" class="ui button" />
                <input id="btnLocCancel" runat="server" type="button" value="Cancel" class="ui button" />
                </div>
            </div>

          </div>
    </div>
</asp:Content>
     


