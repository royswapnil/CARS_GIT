<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfRepairPackage.aspx.vb" Inherits="CARS.frmCfRepairPackage" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

        <script type="text/javascript">

            function fnRPCClientValidate() {
                if (!(gfi_CheckEmpty($('#<%=txtRPCatagory.ClientID%>'), '0166'))) {
                    return false;
                }
                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtRPCatagory.ClientID%>'), '0166'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtRPCatagory.ClientID%>'), '0166'))) {
                    return false;
                }
                return true;
                window.scrollTo(0, 0);
            }

            function fnRCClientValidate() {
                if (!(gfi_CheckEmpty($('#<%=txtRepairCode.ClientID%>'), '0167'))) {
                    return false;
                }
                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtRepairCode.ClientID%>'), '0166'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtRepairCode.ClientID%>'), '0167'))) {
                    return false;
                }
                return true;
                window.scrollTo(0, 0);
            }

            function fnSRCClientValidate() {

                if ($('#<%=ddlRepCode.ClientID%>')[0].selectedIndex == 0) {
                    var msg = GetMultiMessage('SRPCODESELECT', '', '');
                    alert(msg);
                    return false;
                }

                if (!(gfi_CheckEmpty($('#<%=txtSubRepCode.ClientID%>'), 'SRPCODE'))) {
                    return false;
                }
                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtSubRepCode.ClientID%>')))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtSubRepCode.ClientID%>'), 'SRPCODE'))) {
                    return false;
                }
                return true;
                window.scrollTo(0, 0);
            }
            
            function fnCLClientValidate() {
                if (!(gfi_CheckEmpty($('#<%=txtChkListCode.ClientID%>'), '0168'))) {
                    return false;
                }
                if (!(gfi_CheckEmpty($('#<%=txtChkListDesc.ClientID%>'), '0169'))) {
                    return false;
                }

                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtChkListCode.ClientID%>')))) {
                    return false;
                }
                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtChkListDesc.ClientID%>')))) {
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtChkListCode.ClientID%>'), '0168'))) {
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtChkListDesc.ClientID%>'), '0169'))) {
                    return false;
                }
                return true;
                window.scrollTo(0, 0);
            }

            function fnWCClientValidate() {
                if (!(gfi_CheckEmpty($('#<%=txtWorkCode.ClientID%>'), '0170'))) {
                    return false;
                }
                if (!(gfi_ValidateSingleQuote(document.getElementById('<%=txtWorkCode.ClientID%>')))) {
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtWorkCode.ClientID%>'), '0170'))) {
                    return false;
                }
                return true;
                window.scrollTo(0, 0);

            }

            $(document).ready(function () {
                $("#accordion").accordion();
                var grid = $("#dgdRepairPkgDetails");
                var gridRepairCode = $("#dgdRepairCode");
                var gridSubRepairCode = $("#dgdSubRepairCode");
                var gridCheckList = $("#dgdCheckList");
                var gridWorkCode = $("#dgdWorkCode");
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var mydata,rcdata,subrcdata,cldata,wcdata;
                var strInvPrefix = "";

                $('#divRepairPkgCatg').hide();
                $('#divRepairCode').hide();
                $('#divSubRepairCode').hide();
                $('#divRepairCodePKK').hide();
                $('#divCheckList').hide();
                $('#divWorkCode').hide();

                //Repair Package Category
                grid.jqGrid({
                    datatype: "local",
                    data: mydata,
                    colNames: ['Description', 'IdRepairPkgCatg','IdConfig', ''],
                    colModel: [
                             { name: 'RepairPkgDesc', index: 'RepairPkgDesc', width: 160, sorttype: "string" },
                             { name: 'IdRepairPkgCatg', index: 'IdRepairPkgCatg', width: 160, sorttype: "string", hidden: true },
                             { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                             { name: 'IdRepairPkgCatg', index: 'IdRepairPkgCatg', sortable: false, formatter: editRPCatg }
                    ],
                    multiselect: true,
                    pager: jQuery('#pager1'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Repair Package Category",
                    async: false, //Very important,
                    subgrid: false

                });

                //Repair Code
                gridRepairCode.jqGrid({
                    datatype: "local",
                    data: rcdata,
                    colNames: ['RepCode', 'IsDefault', 'IdRepairCode','IsDefault', ''],
                    colModel: [
                             { name: 'RP_Repcode_Desc', index: 'RP_Repcode_Desc', width: 100, sorttype: "string" },
                             { name: 'IsDefaultValue', index: 'IsDefaultValue', width: 100, sorttype: "string" },
                             { name: 'IdRepCode', index: 'IdRepCode', width: 100, sorttype: "string", hidden: true },
                             { name: 'IsDefault', index: 'IsDefault', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdRepCode', index: 'IdRepCode', sortable: false, formatter: editRC }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerRC'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Repair Code",
                    async: false, //Very important,
                    subgrid: false

                });

                //SubRepair Code
                gridSubRepairCode.jqGrid({
                    datatype: "local",
                    data: rcdata,
                    colNames: ['RepCode', 'Sub Rep Code', 'IdRepCode', 'IdSubRepCode', ''],
                    colModel: [
                             { name: 'RP_Repcode_Desc', index: 'RP_Repcode_Desc', width: 100, sorttype: "string" },
                             { name: 'Rp_SubRepCode_Desc', index: 'Rp_SubRepCode_Desc', width: 100, sorttype: "string" },
                             { name: 'IdRepCode', index: 'IdRepCode', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdSubRepCode', index: 'IdSubRepCode', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdSubRepCode', index: 'IdSubRepCode', sortable: false, formatter: editSubRC }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerSubRC'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Repair Code",
                    async: false, //Very important,
                    subgrid: false

                });

                //Check-List
                gridCheckList.jqGrid({
                    datatype: "local",
                    data: cldata,
                    colNames: ['CheckList Code', 'Description', 'IdCheckList',''],
                    colModel: [
                             { name: 'IdChkListCode', index: 'IdChkListCode', width: 100, sorttype: "string" },
                             { name: 'IdChkListDesc', index: 'IdChkListDesc', width: 100, sorttype: "string" },
                             { name: 'IdChkListCodeOld', index: 'IdChkListCodeOld', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdChkListCode', index: 'IdChkListCode', sortable: false, formatter: editCheckList }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerCL'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "CheckList Code",
                    async: false, //Very important,
                    subgrid: false

                });

                //WorkCode
                gridWorkCode.jqGrid({
                    datatype: "local",
                    data: cldata,
                    colNames: ['Work Code', 'IsDefault', 'IdSettings','WcIsDefault','ID_CONFIG', ''],
                    colModel: [
                             { name: 'WorkCodeDesc', index: 'WorkCodeDesc', width: 100, sorttype: "string" },
                             { name: 'IsDefaultValue', index: 'IsDefaultValue', width: 100, sorttype: "string" },
                             { name: 'IdWorkCode', index: 'IdWorkCode', width: 100, sorttype: "string", hidden: true },
                             { name: 'IsDefault', index: 'IsDefault', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdConfig', index: 'IdConfig', width: 100, sorttype: "string", hidden: true },
                             { name: 'IdWorkCode', index: 'IdWorkCode', sortable: false, formatter: editWorkCode }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerWC'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Work Code",
                    async: false, //Very important,
                    subgrid: false

                });


                loadRepairPkgConfiguration();

                $('#<%=lnkRepCodePkk.ClientID%>').on('click', function (e) {
                    e.preventDefault(); //To avoid post back
                    $('#divRepairCodePKK').show();
                    $('#<%=btnSaveRCPKK.ClientID%>').show();
                    $('#<%=btnResetPKK.ClientID%>').show();
                    var ispkk = e.srcElement.text;//"PKK";//
                    $('#<%=ddlRepCodePKK.ClientID%> option:contains("' + ispkk + '")').attr('selected', 'selected');
                });

            });  //end of ready funtion     

            function loadRepairPkgConfiguration() {
                var mydata;
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfRepairPackage.aspx/LoadRepPkgConfig",
                    data: "{}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        loadRepairPkgCatg(data.d[0]);                        
                        loadRepairCode(data.d[1]);
                        loadSubRepairCode(data.d[2]);
                        loadRepairCode_ddl(data.d[1]);
                        loadCheckList(data.d[3]);
                        loadWorkCode(data.d[4]);
                    }
                });
            }

            function loadRepairPkgCatg(data) {
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                jQuery("#dgdRepairPkgDetails").jqGrid('clearGridData');
                for (i = 0; i < data.length; i++) {
                    mydata = data;
                    jQuery("#dgdRepairPkgDetails").jqGrid('addRowData', i + 1, mydata[i]);
                }
                jQuery("#dgdRepairPkgDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdRepairPkgDetails").jqGrid("hideCol", "subgrid");
                return true;
            }

            function loadRepairCode(data) {
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                jQuery("#dgdRepairCode").jqGrid('clearGridData');
                for (i = 0; i < data.length; i++) {
                    rcdata = data;
                    jQuery("#dgdRepairCode").jqGrid('addRowData', i + 1, rcdata[i]);
                }
                jQuery("#dgdRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdRepairCode").jqGrid("hideCol", "subgrid");

                return true;
            }

            function loadSubRepairCode(data) {
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var srcdata;
                jQuery("#dgdSubRepairCode").jqGrid('clearGridData');
                for (i = 0; i < data.length; i++) {
                    srcdata = data;
                    jQuery("#dgdSubRepairCode").jqGrid('addRowData', i + 1, srcdata[i]);
                }
                jQuery("#dgdSubRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdSubRepairCode").jqGrid("hideCol", "subgrid");

                return true;
            }

            function loadCheckList(data) {
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var cldata;
                jQuery("#dgdCheckList").jqGrid('clearGridData');
                for (i = 0; i < data.length; i++) {
                    cldata = data;
                    jQuery("#dgdCheckList").jqGrid('addRowData', i + 1, cldata[i]);
                }
                jQuery("#dgdCheckList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdCheckList").jqGrid("hideCol", "subgrid");

                return true;
            }

            function loadRepairCode_ddl(data) {
                $('#<%=ddlRepCode.ClientID%>').empty();
                $('#<%=ddlRepCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                //data = data.d;
                $.each(data, function (key, value) {
                    $('#<%=ddlRepCode.ClientID%>').append($("<option></option>").val(value.IdRepCode).html(value.RP_Repcode_Desc));
                });

                $('#<%=ddlRepCodePKK.ClientID%>').empty();
                $('#<%=ddlRepCodePKK.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                $.each(data, function (key, value) {
                    $('#<%=ddlRepCodePKK.ClientID%>').append($("<option></option>").val(value.IdRepCode).html(value.RP_Repcode_Desc));
                    if (value.IsPKK !=""){
                        $('#<%=lnkRepCodePkk.ClientID%>').text(value.IsPKK);
                    }
                    
                });
            }

            function loadWorkCode(data) {
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var wcdata;
                jQuery("#dgdWorkCode").jqGrid('clearGridData');
                for (i = 0; i < data.length; i++) {
                    wcdata = data;
                    jQuery("#dgdWorkCode").jqGrid('addRowData', i + 1, wcdata[i]);
                }
                jQuery("#dgdWorkCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                $("#dgdWorkCode").jqGrid("hideCol", "subgrid");

                return true;
            }

            function addRepairPkgDetails() {
                $('#divRepairPkgCatg').show();
                $('#<%=txtRPCatagory.ClientID%>').val("");
                $('#<%=btnAddRPCatgT.ClientID%>').hide();
                $('#<%=btnDeleteRPCatgT.ClientID%>').hide();
                $('#<%=btnAddRPCatgB.ClientID%>').hide();
                $('#<%=btnDeleteRPCatgB.ClientID%>').hide();
                $('#<%=btnSaveRPCatg.ClientID%>').show();
                $('#<%=btnResetRPCatg.ClientID%>').show();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                $('#<%=hdnIdRepPkgCatg.ClientID%>').val("");
            }

            function delRepairPkg() {
                var repkgId = "";
                $('#dgdRepairPkgDetails input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        repkgId = $('#dgdRepairPkgDetails tr ')[row].cells[2].innerHTML.toString();
                    }
                });

                if (repkgId != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        deleteRepairPkgCatg();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function deleteRepairPkgCatg() {
                var row;
                var rpkgId;
                var rpkgDesc;
                var rpkgIdxml;
                var rpkgIdxmls = "";
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $('#dgdRepairPkgDetails input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        rpkgId = $('#dgdRepairPkgDetails tr ')[row].cells[2].innerHTML.toString();
                        rpkgDesc = $('#dgdRepairPkgDetails tr ')[row].cells[1].innerHTML.toString();
                        rpkgIdxml = '<delete><RP-CATG ID_SETTINGS= "' + rpkgId + '" ID_CONFIG= "RP-CATG" DESCRIPTION= "' + rpkgDesc + '"/></delete>';
                        rpkgIdxmls += rpkgIdxml;
                    }
                });

                if (rpkgIdxmls != "") {
                    rpkgIdxmls = "<root>" + rpkgIdxmls + "</root>";
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/DeleteRepPkgCatg",
                        data: "{repPkgxml: '" + rpkgIdxmls + "'}",
                        dataType: "json",
                        success: function (data) {
                            jQuery("#dgdRepairPkgDetails").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdRepairPkgDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divRepairPkgCatg').hide();
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

            function saveRepPkgCatg() {
                var mode = $('#<%=hdnMode.ClientID%>').val(); 
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var result = fnRPCClientValidate();
                if (result == true) {
                var rpkgDesc= $('#<%=txtRPCatagory.ClientID%>').val();
                var idconfig = "RP-CATG";
                var idsettings = $('#<%=hdnIdRepPkgCatg.ClientID%>').val(); 

                $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/SaveRepPkgCatg",
                        data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + rpkgDesc + "', mode:'" + mode + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            data = data.d[0];
                            if (data.RetVal_Saved != "") {
                                jQuery("#dgdRepairPkgDetails").jqGrid('clearGridData');
                                loadRepairPkgConfiguration();
                                jQuery("#dgdRepairPkgDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                $('#divRepairPkgCatg').hide();
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=btnAddRPCatgT.ClientID%>').show();
                                $('#<%=btnAddRPCatgB.ClientID%>').show();
                                $('#<%=btnDeleteRPCatgB.ClientID%>').show();
                                $('#<%=btnDeleteRPCatgT.ClientID%>').show();
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

            function resetRepPkgCatg() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divRepairPkgCatg').hide();
                    $('#<%=txtRPCatagory.ClientID%>').val("");
                    $('#<%=btnAddRPCatgT.ClientID%>').show();
                    $('#<%=btnDeleteRPCatgT.ClientID%>').show();
                    $('#<%=btnAddRPCatgB.ClientID%>').show();
                    $('#<%=btnDeleteRPCatgB.ClientID%>').show();
                    $('#<%=btnSaveRPCatg.ClientID%>').hide();
                    $('#<%=btnResetRPCatg.ClientID%>').hide();
                    $('#<%=hdnIdRepPkgCatg.ClientID%>').val("");
                }              
            }

            function editRPCatg(cellvalue, options, rowObject) {
                var repPkgDesc = rowObject.RepairPkgDesc.toString();
                var idRepPkgCatg = rowObject.IdRepairPkgCatg.toString();
                var idConfig = rowObject.IdConfig.toString();
               
                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editRPCatgCode(" + "'" + repPkgDesc+ "'" + ",'" + idRepPkgCatg + "','" + idConfig +  "'" + "); />";
                return edit;
            }

            function editRPCatgCode(repPkgDesc, idRepPkgCatg, idConfig) {
                $('#divRepairPkgCatg').show();
                $('#<%=hdnIdRepPkgCatg.ClientID%>').val(idRepPkgCatg);
                $('#<%=txtRPCatagory.ClientID%>').val(repPkgDesc);
                $('#<%=btnAddRPCatgT.ClientID%>').hide();
                $('#<%=btnDeleteRPCatgT.ClientID%>').hide();
                $('#<%=btnAddRPCatgB.ClientID%>').hide();
                $('#<%=btnDeleteRPCatgB.ClientID%>').hide();
                $('#<%=btnSaveRPCatg.ClientID%>').show();
                $('#<%=btnResetRPCatg.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Edit");

            }

            function addRepairCode() {
                $('#divRepairCode').show();
                $('#<%=txtRepairCode.ClientID%>').val("");
                $('#<%=btnAddRCT.ClientID%>').hide();
                $('#<%=btnDelRCT.ClientID%>').hide();
                $('#<%=btnAddRCB.ClientID%>').hide();
                $('#<%=btnDelRCB.ClientID%>').hide();
                $('#<%=btnSaveRC.ClientID%>').show();
                $('#<%=btnResetRC.ClientID%>').show();
                $("#<%=cbIsDefault.ClientID%>").attr('checked', false);
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                $('#<%=hdnIdRepCode.ClientID%>').val("");
            }

            function delRepairCode() {
                var repCodeId = "";
                $('#dgdRepairCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        repCodeId = $('#dgdRepairCode tr ')[row].cells[3].innerHTML.toString();
                    }
                });

                if (repCodeId != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        deleteRepairCodeDetails();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function deleteRepairCodeDetails() {
                var row;
                var repCodeId;
                var repCodeDesc;
                var repCodeIdxml;
                var repCodeIdxmls = "";
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $('#dgdRepairCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        repCodeId = $('#dgdRepairCode tr ')[row].cells[3].innerHTML.toString();
                        repCodeDesc = $('#dgdRepairCode tr ')[row].cells[1].innerHTML.toString();
                        repCodeIdxml = '<delete><REP_CODE ID_REP_CODE= "' + repCodeId + '" RP_REPCODE_DES= "' + repCodeDesc + '"/></delete>';
                        repCodeIdxmls += repCodeIdxml;
                    }
                });

                if (repCodeIdxmls != "") {
                    repCodeIdxmls = "<root>" + repCodeIdxmls + "</root>";
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/DeleteRepCode",
                        data: "{repCodexml: '" + repCodeIdxmls + "'}",
                        dataType: "json",
                        success: function (data) {
                            jQuery("#dgdRepairCode").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divRepairCode').hide();
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

            function saveRepCode() {
                var mode = $('#<%=hdnMode.ClientID%>').val();
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var result = fnRCClientValidate();
                if (result == true) {
                    var repCodeDesc = $('#<%=txtRepairCode.ClientID%>').val();
                    var idconfig = "ID_REP_CODE";
                    var idRepCode = $('#<%=hdnIdRepCode.ClientID%>').val();
                    var isDefault = $('#<%=cbIsDefault.ClientID%>').is(':checked');
                if (isDefault == true) {
                    isDefault = "1";
                } else { isDefault = "0"; }

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/SaveRepCode",
                        data: "{idconfig: '" + idconfig + "', idRepCode:'" + idRepCode + "', desc:'" + repCodeDesc + "', mode:'" + mode + "', isDefault:'" + isDefault + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            data = data.d[0];
                            if (data.RetVal_Saved != "" || (data.RetVal_Saved == "" && data.RetVal_NotSaved =="")) {
                                jQuery("#dgdRepairCode").jqGrid('clearGridData');
                                loadRepairPkgConfiguration();
                                jQuery("#dgdRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                $('#divRepairCode').hide();
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=btnAddRCT.ClientID%>').show();
                                $('#<%=btnAddRCB.ClientID%>').show();
                                $('#<%=btnDelRCB.ClientID%>').show();
                                $('#<%=btnDelRCT.ClientID%>').show();
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

            function resetRepCode() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divRepairCode').hide();
                    $('#<%=txtRepairCode.ClientID%>').val("");
                    $('#<%=btnAddRCT.ClientID%>').show();
                    $('#<%=btnDelRCT.ClientID%>').show();
                    $('#<%=btnAddRCB.ClientID%>').show();
                    $('#<%=btnDelRCB.ClientID%>').show();
                    $('#<%=btnSaveRC.ClientID%>').hide();
                    $('#<%=btnResetRC.ClientID%>').hide();
                    $('#<%=hdnIdRepCode.ClientID%>').val("");
                }
            }

            function editRC(cellvalue, options, rowObject) {
                var repCode = rowObject.RP_Repcode_Desc.toString();
                var idRepCode = rowObject.IdRepCode.toString();
                var isDefault = rowObject.IsDefault.toString();

                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editRepCode(" + "'" + repCode + "'" + ",'" + idRepCode + "','" + isDefault + "'" + "); />";
                return edit;
            }

            function editRepCode(repCode,idRepCode,isDefault) {
                $('#divRepairCode').show();
                $('#<%=hdnIdRepCode.ClientID%>').val(idRepCode);
                $('#<%=txtRepairCode.ClientID%>').val(repCode);
                if (isDefault == "True") {
                    $("#<%=cbIsDefault.ClientID%>").attr('checked', true);
                } else {
                    $("#<%=cbIsDefault.ClientID%>").attr('checked', false);
                }
                $('#<%=btnAddRCT.ClientID%>').hide();
                $('#<%=btnDelRCT.ClientID%>').hide();
                $('#<%=btnAddRCB.ClientID%>').hide();
                $('#<%=btnDelRCB.ClientID%>').hide();
                $('#<%=btnSaveRC.ClientID%>').show();
                $('#<%=btnResetRC.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Edit");
            }

            function editSubRC(cellvalue, options, rowObject) {
                var repCodeDesc = rowObject.RP_Repcode_Desc.toString();
                var subRepCodeDesc = rowObject.Rp_SubRepCode_Desc.toString();
                var idSubRepCode = rowObject.IdSubRepCode.toString();
                var idRepCode = rowObject.IdRepCode.toString();
                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editSubRepCode(" + "'" + repCodeDesc + "'" + ",'" + subRepCodeDesc + "','" + idSubRepCode + "','" + idRepCode + "'" + "); />";
                return edit;

            }

            function editSubRepCode(repCodeDesc, subRepCodeDesc, idSubRepCode, idRepCode) {
                $('#divSubRepairCode').show();
                $('#<%=hdnSubRepCodeId.ClientID%>').val(idSubRepCode);
                $('#<%=txtSubRepCode.ClientID%>').val(subRepCodeDesc);

                $('#<%=btnAddSubRCT.ClientID%>').hide();
                $('#<%=btnDelSubRCT.ClientID%>').hide();
                $('#<%=btnAddSubRCB.ClientID%>').hide();
                $('#<%=btnDelSubRCB.ClientID%>').hide();
                $('#<%=btnSaveSubRepCode.ClientID%>').show();
                $('#<%=btnResetSubRepCode.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Edit");

                if (idRepCode != "") {
                    $("#<%=ddlRepCode.ClientID%>").val(idRepCode);
                } else {
                    $('#<%=ddlRepCode.ClientID%>')[0].selectedIndex = 0;
                }
            }

            function addSubRepairCode(){
                $('#divSubRepairCode').show();
                $('#<%=hdnSubRepCodeId.ClientID%>').val("");
                $('#<%=txtSubRepCode.ClientID%>').val("");
                $('#<%=ddlRepCode.ClientID%>')[0].selectedIndex = 0;
                $('#<%=btnAddSubRCT.ClientID%>').hide();
                $('#<%=btnDelSubRCT.ClientID%>').hide();
                $('#<%=btnAddSubRCB.ClientID%>').hide();
                $('#<%=btnDelSubRCB.ClientID%>').hide();
                $('#<%=btnSaveSubRepCode.ClientID%>').show();
                $('#<%=btnResetSubRepCode.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Add");
            }

            function delSubRepairCode(){
                var subRepCodeId = "";
                $('#dgdSubRepairCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        subRepCodeId = $('#dgdSubRepairCode tr ')[row].cells[4].innerHTML.toString();
                    }
                });

                if (subRepCodeId != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        deleteSubRepairCodeDetails();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function deleteSubRepairCodeDetails() {
                var row;
                var subRepCodeId;
                var subRepCodeDesc;
                var subRepCodeIdxml;
                var subRepCodeIdxmls = "";
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $('#dgdSubRepairCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        subRepCodeId = $('#dgdSubRepairCode tr ')[row].cells[4].innerHTML.toString();
                        subRepCodeDesc = $('#dgdSubRepairCode tr ')[row].cells[2].innerHTML.toString();
                        subRepCodeIdxml = '<DELETESRPCODE ID_SUBREP_CODE= "' + subRepCodeId + '" RP_SUBREPCODE_DES= "' + subRepCodeDesc + '"/>';
                        subRepCodeIdxmls += subRepCodeIdxml;
                    }
                });

                if (subRepCodeIdxmls != "") {
                    subRepCodeIdxmls = "<root><delete>" + subRepCodeIdxmls + "</delete></root>";
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/DeleteSubRepCode",
                        data: "{subRepCodexml: '" + subRepCodeIdxmls + "'}",
                        dataType: "json",
                        success: function (data) {
                            jQuery("#dgdSubRepairCode").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdSubRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divSubRepairCode').hide();
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


            function saveSubRepCode() {
                var mode = $('#<%=hdnMode.ClientID%>').val();
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var result = fnSRCClientValidate();
                if (result == true) {
                var idRepCode = $("#<%=ddlRepCode.ClientID%>").val();
                var subRepCodeDesc = $('#<%=txtSubRepCode.ClientID%>').val();
                var idSubRepCode = $('#<%=hdnSubRepCodeId.ClientID%>').val();
                
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/SaveSubRepCode",
                        data: "{idSubRepCode: '" + idSubRepCode + "', idRepCode:'" + idRepCode + "', subRepCodeDesc:'" + subRepCodeDesc + "', mode:'" + mode + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            data = data.d[0];
                            if (data.RetVal_Saved != "" || (data.RetVal_Saved == "" && data.RetVal_NotSaved == "")) {
                                jQuery("#dgdSubRepairCode").jqGrid('clearGridData');
                                loadRepairPkgConfiguration();
                                jQuery("#dgdSubRepairCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                $('#divSubRepairCode').hide();
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=btnAddSubRCT.ClientID%>').show();
                                $('#<%=btnAddSubRCB.ClientID%>').show();
                                $('#<%=btnDelSubRCT.ClientID%>').show();
                                $('#<%=btnDelSubRCB.ClientID%>').show();
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

            function resetSubRepCode(){
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divSubRepairCode').hide();
                    $('#<%=txtSubRepCode.ClientID%>').val("");
                    $('#<%=btnAddSubRCB.ClientID%>').show();
                    $('#<%=btnAddSubRCT.ClientID%>').show();
                    $('#<%=btnDelSubRCB.ClientID%>').show();
                    $('#<%=btnDelSubRCT.ClientID%>').show();
                    $('#<%=btnSaveSubRepCode.ClientID%>').hide();
                    $('#<%=btnResetSubRepCode.ClientID%>').hide();
                    $('#<%=hdnSubRepCodeId.ClientID%>').val("");
                }
            }

            function resetRepCodePKK() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divRepairCodePKK').hide();
                    $('#<%=btnSaveRCPKK.ClientID%>').hide();
                    $('#<%=btnResetPKK.ClientID%>').hide();
                }
            }

            function saveRepCodePKK() {
                var idRepCode = $("#<%=ddlRepCodePKK.ClientID%>").val();
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfRepairPackage.aspx/SaveRepCodePKK",
                    data: "{idRepCode: '" + idRepCode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        data = data.d[0];
                        if (data.RetVal_Saved != "" ) {
                            loadRepairPkgConfiguration();
                            $('#divRepairCodePKK').hide();
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnSaveRCPKK.ClientID%>').hide();
                            $('#<%=btnResetPKK.ClientID%>').hide();
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

            function addCheckList() {
                $('#divCheckList').show();
                $('#<%=txtRepairCode.ClientID%>').val("");
                $('#<%=btnAddChkListT.ClientID%>').hide();
                $('#<%=btnAddChkListB.ClientID%>').hide();
                $('#<%=btnDelChkListT.ClientID%>').hide();
                $('#<%=btnDelChkListB.ClientID%>').hide();
                $('#<%=btnSaveChkList.ClientID%>').show();
                $('#<%=btnResetChkList.ClientID%>').show();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                $('#<%=hdnIdRepCode.ClientID%>').val("");
            }

            function delCheckList() {
                var idCLCode = "";
                $('#dgdCheckList input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        idCLCode = $('#dgdCheckList tr ')[row].cells[4].innerHTML.toString();
                    }
                });

                if (idCLCode != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        deleteCheckListCode();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function deleteCheckListCode() {
                var row;
                var chkListId;
                var chkListDesc;
                var chkListIdxml;
                var chkListIdxmls = "";
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $('#dgdCheckList input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        chkListId = $('#dgdCheckList tr ')[row].cells[3].innerHTML.toString();
                        chkListDesc = $('#dgdCheckList tr ')[row].cells[2].innerHTML.toString();
                        chkListIdxml = '<CHK_LST ID_CL_CODE= "' + chkListId + '" RP_CL_DES= "' + chkListDesc + '"/>';
                        chkListIdxmls += chkListIdxml;
                    }
                });

                if (chkListIdxmls != "") {
                    chkListIdxmls = "<root><delete>" + chkListIdxmls + "</delete></root>";
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/DeleteCheckList",
                        data: "{checkListxml: '" + chkListIdxmls + "'}",
                        dataType: "json",
                        success: function (data) {
                            jQuery("#dgdCheckList").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdCheckList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divCheckList').hide();
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

            function saveCheckList() {
                var mode = $('#<%=hdnMode.ClientID%>').val();
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var result = fnCLClientValidate();
                if (result == true) {
                var idConfig = "ID_CL_CODE";
                var idCLCode = $('#<%=txtChkListCode.ClientID%>').val();
                var clDesc = $('#<%=txtChkListDesc.ClientID%>').val();

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfRepairPackage.aspx/SaveCheckList",
                    data: "{idConfig: '" + idConfig + "', idCLCode:'" + idCLCode + "', clDesc:'" + clDesc + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        data = data.d[0];
                        if (data.RetVal_Saved != "" || (data.RetVal_Saved == "" && data.RetVal_NotSaved == "")) {
                            jQuery("#dgdCheckList").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdCheckList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divCheckList').hide();
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddChkListT.ClientID%>').show();
                            $('#<%=btnAddChkListB.ClientID%>').show();
                            $('#<%=btnDelChkListT.ClientID%>').show();
                            $('#<%=btnDelChkListB.ClientID%>').show();
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

            function editCheckList(cellvalue, options, rowObject) {
                var idCLCode = rowObject.IdChkListCode.toString();
                var idCLDesc = rowObject.IdChkListDesc.toString();
                var idCLOld = rowObject.IdChkListCodeOld.toString();

                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editCheckListCode(" + "'" + idCLCode + "'" + ",'" + idCLDesc + "','" + idCLOld + "'" + "); />";
                return edit;
            }

            function editCheckListCode(idCLCode, idCLDesc, idCLOld) {
                $('#divCheckList').show();
                $('#<%=txtChkListCode.ClientID%>').val(idCLCode);
                $('#<%=txtChkListCode.ClientID%>').attr("disabled","disabled");
                $('#<%=txtChkListDesc.ClientID%>').val(idCLDesc);
                $('#<%=btnAddChkListT.ClientID%>').hide();
                $('#<%=btnAddChkListB.ClientID%>').hide();
                $('#<%=btnDelChkListT.ClientID%>').hide();
                $('#<%=btnDelChkListB.ClientID%>').hide();
                $('#<%=btnSaveChkList.ClientID%>').show();
                $('#<%=btnResetChkList.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Edit");
            }

            function resetCheckList() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divCheckList').hide();
                    $('#<%=txtChkListCode.ClientID%>').val("");
                    $('#<%=txtChkListDesc.ClientID%>').val("");
                    $('#<%=btnAddChkListT.ClientID%>').show();
                    $('#<%=btnAddChkListB.ClientID%>').show();
                    $('#<%=btnDelChkListT.ClientID%>').show();
                    $('#<%=btnDelChkListB.ClientID%>').show();
                    $('#<%=btnSaveChkList.ClientID%>').hide();
                    $('#<%=btnResetChkList.ClientID%>').hide();
                    $('#<%=hdnIdRepCode.ClientID%>').val("");
                }
            }

            function editWorkCode(cellvalue, options, rowObject) {
                var workCodeDesc = rowObject.WorkCodeDesc.toString();
                var idWorkCode = rowObject.IdWorkCode.toString();
                var idConfig = rowObject.IdConfig.toString();
                var isDefault = rowObject.IsDefault.toString();
                
                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editWorkCodeDetails(" + "'" + idWorkCode + "'" + ",'" + workCodeDesc + "','" + idConfig + "','" + isDefault + "'" + "); />";
                return edit;
            }

            function editWorkCodeDetails(idWorkCode, workCodeDesc, idConfig, isDefault) {
                $('#divWorkCode').show();
                $('#<%=hdnIdWorkCode.ClientID%>').val(idWorkCode);
                $('#<%=txtWorkCode.ClientID%>').val(workCodeDesc);
                $('#<%=btnAddWorkCodeT.ClientID%>').hide();
                $('#<%=btnDelWorkCodeT.ClientID%>').hide();
                $('#<%=btnAddWorkCodeB.ClientID%>').hide();
                $('#<%=btnDelWorkCodeB.ClientID%>').hide();
                $('#<%=btnSaveWorkCode.ClientID%>').show();
                $('#<%=btnResetWorkCode.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val("Edit");

                if (isDefault == "True") {
                    $("#<%=cbWCIsDefault.ClientID%>").attr('checked', true);
                } else {
                    $("#<%=cbWCIsDefault.ClientID%>").attr('checked', false);
                }

            }

            function resetWorkCode() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divWorkCode').hide();
                    $('#<%=txtWorkCode.ClientID%>').val("");

                    $('#<%=btnAddWorkCodeT.ClientID%>').show();
                    $('#<%=btnAddWorkCodeB.ClientID%>').show();
                    $('#<%=btnDelWorkCodeT.ClientID%>').show();
                    $('#<%=btnDelWorkCodeB.ClientID%>').show();
                    $('#<%=btnSaveWorkCode.ClientID%>').hide();
                    $('#<%=btnResetWorkCode.ClientID%>').hide();
                    $('#<%=hdnIdWorkCode.ClientID%>').val("");
                }
            }

            function addWorkCode() {
                $('#divWorkCode').show();
                $('#<%=txtWorkCode.ClientID%>').val("");
                $('#<%=btnAddWorkCodeT.ClientID%>').hide();
                $('#<%=btnAddWorkCodeB.ClientID%>').hide();
                $('#<%=btnDelWorkCodeT.ClientID%>').hide();
                $('#<%=btnDelWorkCodeB.ClientID%>').hide();
                $('#<%=btnSaveWorkCode.ClientID%>').show();
                $('#<%=btnResetWorkCode.ClientID%>').show();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                $('#<%=hdnIdWorkCode.ClientID%>').val("");
            }

            function saveWorkCode() {
                var mode = $('#<%=hdnMode.ClientID%>').val();
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var result = fnWCClientValidate();
                if (result == true) {
                var workCodeDesc = $('#<%=txtWorkCode.ClientID%>').val();
                var idconfig = "RP-WC";
                var idWorkCode = $('#<%=hdnIdWorkCode.ClientID%>').val();
                var isDefault = $('#<%=cbWCIsDefault.ClientID%>').is(':checked');
                if (isDefault == true) {
                    isDefault = "1";
                } else { isDefault = "0"; }

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/SaveWorkCode",
                        data: "{idconfig: '" + idconfig + "', idWorkCode:'" + idWorkCode + "', workCodeDesc:'" + workCodeDesc + "', mode:'" + mode + "', isDefault:'" + isDefault + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            data = data.d[0];
                            if (data.RetVal_Saved != "") {
                                jQuery("#dgdWorkCode").jqGrid('clearGridData');
                                loadRepairPkgConfiguration();
                                jQuery("#dgdWorkCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                $('#divWorkCode').hide();
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=btnAddWorkCodeT.ClientID%>').show();
                                $('#<%=btnAddWorkCodeB.ClientID%>').show();
                                $('#<%=btnDelWorkCodeT.ClientID%>').show();
                                $('#<%=btnDelWorkCodeB.ClientID%>').show();
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

            function delWorkCode() {
                var workCodeId = "";
                $('#dgdWorkCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        workCodeId = $('#dgdWorkCode tr ')[row].cells[3].innerHTML.toString();
                    }
                });

                if (workCodeId != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        deleteWorkCode();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function deleteWorkCode() {
                var row;
                var workCodeId;
                var workCodeDesc;
                var workCodeIdxml;
                var workCodeIdxmls = "";
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $('#dgdWorkCode input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        workCodeId = $('#dgdWorkCode tr ')[row].cells[3].innerHTML.toString();
                        workCodeDesc = $('#dgdWorkCode tr ')[row].cells[1].innerHTML.toString();
                        workCodeIdxml = '<delete><RP-WC  ID_SETTINGS= "' + workCodeId + '" ID_CONFIG= "RP-WC" DESCRIPTION= "' + workCodeDesc + '"/></delete>';
                        workCodeIdxmls += workCodeIdxml;
                    }
                });

                if (workCodeIdxmls != "") {
                    workCodeIdxmls = "<root>" + workCodeIdxmls + "</root>";
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfRepairPackage.aspx/DeleteWorkCode",
                        data: "{workCodexml: '" + workCodeIdxmls + "'}",
                        dataType: "json",
                        success: function (data) {
                            jQuery("#dgdWorkCode").jqGrid('clearGridData');
                            loadRepairPkgConfiguration();
                            jQuery("#dgdWorkCode").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divWorkCode').hide();
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
    
             <div class="header1 two fields" style="padding-top:0.5em">
                <asp:Label ID="lblHead" runat="server" Text="Repair Package Configuration" ></asp:Label>
                <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
                <asp:HiddenField id="hdnPageSize" runat="server" />  
                <asp:HiddenField id="hdnEditCap" runat="server" />
                <asp:HiddenField id="hdnIdRepPkgCatg" runat="server" />
                <asp:HiddenField id="hdnIdRepCode" runat="server" />    
                <asp:HiddenField id="hdnMode" runat="server" /> 
                <asp:HiddenField id="hdnSubRepCodeId" runat="server" />     
                <asp:HiddenField id="hdnSelect" runat="server" />      
                <asp:HiddenField id="hdnIdWorkCode" runat="server" />       
            </div>
            <div id="accordion">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="item" id="a2" runat="server" >Repair Package Category</a>
            </div> 
            <div> 
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddRPCatgT" runat="server" type="button" value="Add" class="ui button"  onclick="addRepairPkgDetails()"/>
                    <input id="btnDeleteRPCatgT" runat="server" type="button" value="Delete" class="ui button" onclick="delRepairPkg()"/>
                </div>  
                <div >
                    <table id="dgdRepairPkgDetails" title="Repair Package Category" ></table>
                    <div id="pager1"></div>
                </div>         
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddRPCatgB" runat="server" type="button" value="Add" class="ui button" onclick="addRepairPkgDetails()"/>
                    <input id="btnDeleteRPCatgB" runat="server" type="button" value="Delete" class="ui button" onclick="delRepairPkg()"/>
                </div>
                <div id="divRepairPkgCatg" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="aheader" runat="server" >Repair Package Category</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblRPCatagoryDesc" runat="server" Text="Repair Package Category"></asp:Label><span class="mand">*</span>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtRPCatagory"  padding="0em" runat="server" MaxLength="15"></asp:TextBox>
                            </div>                            
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveRPCatg" class="ui button" runat="server"  value="Save" type="button" onclick="saveRepPkgCatg()"/>
                        <input id="btnResetRPCatg" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetRepPkgCatg()" />
                    </div>               
               </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a3" runat="server" >Repair Code</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddRCT" runat="server" type="button" value="Add" class="ui button"  onclick="addRepairCode()"/>
                    <input id="btnDelRCT" runat="server" type="button" value="Delete" class="ui button" onclick="delRepairCode()"/>
                </div>  
                <div >
                    <table id="dgdRepairCode" title="Repair Code" ></table>
                    <div id="pagerRC"></div>
                </div>         
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddRCB" runat="server" type="button" value="Add" class="ui button" onclick="addRepairCode('NEW')"/>
                    <input id="btnDelRCB" runat="server" type="button" value="Delete" class="ui button" onclick="delRepairCode()"/>
                </div>
                <div id="divRepairCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a1" runat="server" >Repair Code</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblRepCode" runat="server" Text="Repair Code"></asp:Label><span class="mand">*</span>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtRepairCode"  padding="0em" runat="server" MaxLength="10"></asp:TextBox>                                
                            </div>
                            <div class="field" style="width:200px">
                                <asp:CheckBox ID="cbIsDefault" runat="server" />
                                <asp:Label ID="lblRCIsDefault" runat="server" Text="IsDefault" />
                            </div>                            
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveRC" class="ui button" runat="server"  value="Save" type="button" onclick="saveRepCode()"/>
                        <input id="btnResetRC" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetRepCode()" />
                    </div>               
               </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a4" runat="server" >Sub Repair Code</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddSubRCT" runat="server" type="button" value="Add" class="ui button"  onclick="addSubRepairCode()"/>
                    <input id="btnDelSubRCT" runat="server" type="button" value="Delete" class="ui button" onclick="delSubRepairCode()"/>
                </div>  
                <div >
                    <table id="dgdSubRepairCode" title="Sub Repair Code"></table>
                    <div id="pagerSubRC"></div>
                </div>         
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddSubRCB" runat="server" type="button" value="Add" class="ui button" onclick="addSubRepairCode()"/>
                    <input id="btnDelSubRCB" runat="server" type="button" value="Delete" class="ui button" onclick="delSubRepairCode()"/>
                </div>
                <div id="divSubRepairCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a5" runat="server" >Repair Code</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblSRepCode" runat="server" Text="Repair Code"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:DropDownList ID="ddlRepCode" runat="server" Width="120px"></asp:DropDownList>                                
                            </div>
                            <div class="field" style="width:150px">
                                <asp:Label ID="lblSubRepCode" runat="server" Text="Sub Repair Code" />
                            </div>    
                             <div class="field" style="width:100px">
                                <asp:TextBox ID="txtSubRepCode"  padding="0em" runat="server"></asp:TextBox>
                            </div>                         
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveSubRepCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveSubRepCode()"/>
                        <input id="btnResetSubRepCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetSubRepCode()" />
                    </div>               
               </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a6" runat="server" >Repair Code for PKK</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:5em">
                    <asp:LinkButton ID="lnkRepCodePkk" runat="server" Text="test" ></asp:LinkButton>
                </div>  
                 <div id="divRepairCodePKK" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a7" runat="server" >Repair Code for PKK</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblRepCodePkk" runat="server" Text="Repair Code for PKK"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:DropDownList ID="ddlRepCodePKK" runat="server" Width="120px"></asp:DropDownList>                                
                            </div>
                    
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveRCPKK" class="ui button" runat="server"  value="Save" type="button" onclick="saveRepCodePKK()"/>
                        <input id="btnResetPKK" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetRepCodePKK()" />
                    </div>               
                 </div>
             </div>
             <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a8" runat="server" >Check List</a>
             </div>
             <div> 
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddChkListT" runat="server" type="button" value="Add" class="ui button"  onclick="addCheckList()"/>
                    <input id="btnDelChkListT" runat="server" type="button" value="Delete" class="ui button" onclick="delCheckList()"/>
                </div>  
                <div >
                    <table id="dgdCheckList" title="Check List"></table>
                    <div id="pagerCL"></div>
                </div>         
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddChkListB" runat="server" type="button" value="Add" class="ui button" onclick="addCheckList()"/>
                    <input id="btnDelChkListB" runat="server" type="button" value="Delete" class="ui button" onclick="delCheckList()"/>
                </div>
                <div id="divCheckList" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a9" runat="server" >Check List</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblChkLstCode" runat="server" Text="Check List Code"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtChkListCode" runat="Server" MaxLength="10" ></asp:TextBox>                                
                            </div>
                            <div class="field" style="width:150px">
                                <asp:Label ID="lblChkListDesc" runat="server" Text="Description" />
                            </div>    
                             <div class="field" style="width:100px">
                                <asp:TextBox ID="txtChkListDesc"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                            </div>                         
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveChkList" class="ui button" runat="server"  value="Save" type="button" onclick="saveCheckList()"/>
                        <input id="btnResetChkList" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetCheckList()" />
                    </div>               
               </div>
            </div>
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a10" runat="server" >Work Code</a>
            </div>
            <div> 
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddWorkCodeT" runat="server" type="button" value="Add" class="ui button"  onclick="addWorkCode()"/>
                    <input id="btnDelWorkCodeT" runat="server" type="button" value="Delete" class="ui button" onclick="delWorkCode()"/>
                </div>  
                <div >
                    <table id="dgdWorkCode" title="Check List"></table>
                    <div id="pagerWC"></div>
                </div>         
                <div style="text-align:left;padding-left:5em">
                    <input id="btnAddWorkCodeB" runat="server" type="button" value="Add" class="ui button" onclick="addWorkCode()"/>
                    <input id="btnDelWorkCodeB" runat="server" type="button" value="Delete" class="ui button" onclick="delWorkCode()"/>
                </div>
                <div id="divWorkCode" class="ui raised segment signup inactive">
                    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="a11" runat="server" >Work Code</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:180px">
                                <asp:Label ID="lblWorkCode" runat="server" Text="Work Code"></asp:Label>
                            </div>
                            <div class="field" style="width:200px">
                                <asp:TextBox ID="txtWorkCode" runat="Server" MaxLength="10" ></asp:TextBox>                                
                            </div>
  
                             <div class="field" style="width:100px">
                                  <asp:CheckBox ID="cbWCIsDefault" runat="server" />
                                <asp:Label ID="lblWCisDefault" runat="server" Text="IsDefault" />
                            </div>                         
                        </div>
                    </div>             

                    <div style="text-align:left">
                        <input id="btnSaveWorkCode" class="ui button" runat="server"  value="Save" type="button" onclick="saveWorkCode()"/>
                        <input id="btnResetWorkCode" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetWorkCode()" />
                    </div>               
               </div>
            </div>

        </div>        


</asp:Content>
