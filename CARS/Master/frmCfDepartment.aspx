<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfDepartment.aspx.vb" Inherits="CARS.frmCfDepartment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
                $('#divDeptDetails').hide();
                $('#divUserDetails').hide();

                $('#btnAdd').click(function () {
                    $('#divDeptDetails').show();
                });

                $('#btnReset').click(function () {
                    $('#divDeptDetails').hide();
                    $('#divUserDetails').hide();
                });


                FillSubsidiary();
                FillDiscountCode();
                loadMake();
                loadCategory();
                loadRPCategory();
                loadTemplateCode();
            

                $('#<%=drpMakeCode.ClientID%>').change(function (e) {
                    loadCategory();
                });

                $('#<%=drpRPMake.ClientID%>').change(function (e) {
                    loadRPCategory();
                });
               

            $('#<%=txtDepartmentID.ClientID%>').change(function (e) {
                var deptID = $('#<%=txtDepartmentID.ClientID%>').val();
                edt(deptID);
            });

            $('#<%=txtFromTime.ClientID%>').change(function (e) {
                fnValidateFromTime();
            });
            $('#<%=txtToTime.ClientID%>').change(function (e) {
                fnValidateEndTime();
            });


                var grid = $("#dgdDeptDetails");
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var mydata;

                grid.jqGrid({
                    datatype: "local",
                    data: mydata,
                    colNames: ['DeptId', 'DeptName', 'DeptManager', 'Location', 'Address1', 'Address2', 'Phone', 'Mobile', 'FlgWareHouse', 'SubsideryId', 'DiscountCode', ''],
                    colModel: [
                             { name: 'DeptId', index: 'DeptId', width: 60, sorttype: "string" },
                             { name: 'DeptName', index: 'DeptName', width: 90, sorttype: "string" },
                             { name: 'DeptManager', index: 'DeptManager', width: 120, sorttype: "string" },
                             { name: 'Location', index: 'Location', width: 90, sorttype: "string" },
                             { name: 'Address1', index: 'Address1', width: 90, sorttype: "string" },
                             { name: 'Address2', index: 'Address2', width: 90, sorttype: "string" },
                             { name: 'Phone', index: 'Phone', width: 90, sorttype: "string" },
                             { name: 'Mobile', index: 'Mobile', width: 90, sorttype: "string" },
                             { name: 'FlgWareHouse', index: 'FlgWareHouse', width: 90, sorttype: "string" },
                             { name: 'SubsideryId', index: 'SubsideryId', width: 90, sorttype: "string" },
                             { name: 'DiscountCode', index: 'DiscountCode', width: 90, sorttype: "string" },
                             { name: 'DepartmentID', index: 'DepartmentID', sortable: false, formatter: displayButtons }
                    ],
                    multiselect: true,
                    pager: jQuery('#pager1'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Department Details",
                    async: false, //Very important,
                    subgrid: false

                });
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCFDepartment.aspx/FetchAllDepartments",
                    data: '{}',
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data;
                            jQuery("#dgdDeptDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                        }
                    }
                });

                jQuery("#dgdDeptDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                getGridHeaders();
                $("#dgdDeptDetails").jqGrid("hideCol", "subgrid");


                $('#<%=txtZipCode.ClientID%>').autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmCFDepartment.aspx/GetZipCodes",
                            data: "{'zipCode':'" + $('#<%=txtZipCode.ClientID%>').val() + "'}",
                            dataType: "json",
                            success: function (data) {
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.split('-')[0] + "-" + item.split('-')[3],
                                        val: item.split('-')[0],
                                        value: item.split('-')[0],
                                        country: item.split('-')[1],
                                        state: item.split('-')[2],
                                        city: item.split('-')[3],
                                    }
                                }))
                            },
                            error: function (xhr, status, error) {
                                alert("Error" + error);
                                var err = eval("(" + xhr.responseText + ")");
                                alert('Error Response ' + err.Message);
                            }
                        });
                    },
                    select: function (e, i) {
                        $("#<%=txtZipCode.ClientID%>").val(i.item.val);
                        $("#<%=txtCountry.ClientID%>").val(i.item.country);
                        $("#<%=txtState.ClientID%>").val(i.item.state);
                        $("#<%=txtCity.ClientID%>").val(i.item.city);
                    },
                });

            if ($('#<%=chkLunchWithdraw.ClientID%>').checked == false)
            {
                $('#<%=txtFromTime.ClientID%>').Enabled = false;
                $('#<%=txtToTime.ClientID%>').Enabled = false;
            }

          

         });
         function displayButtons(cellvalue, options, rowObject) {
             var deptID = rowObject.DeptId.toString();
             // var strOptions = cellvalue;
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             $('#txtDepartmentID').Enabled = false;
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");

             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edt(" + "'" + deptID + "'" + "); />";
             return edit;
         }

         function edt(deptID) {
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCFDepartment.aspx/FetchDepartment",
                 data: "{deptID: '" + deptID + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length != 0)
                     {
                         $('#<%=drpRPCategory.ClientID%>').empty();
                         $('#<%=drpCategory.ClientID%>').empty();
                         $('#<%=txtDepartmentID.ClientID%>').val(data.d[0].DeptId);
                         $('#<%=txtDepartmentName.ClientID%>').val(data.d[0].DeptName);
                         $('#<%=txtDepartmentManager.ClientID%>').val(data.d[0].DeptManager);
                         $('#<%=txtAddress1.ClientID%>').val(data.d[0].Address1);
                         $('#<%=txtAddress2.ClientID%>').val(data.d[0].Address2);
                         $('#<%=txtTelephoneNo.ClientID%>').val(data.d[0].Phone);
                         $('#<%=txtMobile.ClientID%>').val(data.d[0].Mobile);
                         $('#<%=txtLocation.ClientID%>').val(data.d[0].Location);
                         $('#<%=txtDepAcccode.ClientID%>').val(data.d[0].DeptAccountCode);
                         $('#<%=txtToTime.ClientID%>').val(data.d[0].ToTime);
                         $('#<%=txtFromTime.ClientID%>').val(data.d[0].FromTime);

                         if (data.d[0].TempCode == 0)
                         {
                             $('#<%=drpTempCode.ClientID%>')[0].selectedIndex = 0;
                         }
                         else
                         {
                            $('#<%=drpTempCode.ClientID%>').val(data.d[0].TempCode);
                         }                 

                         if (data.d[0].SubsideryId == 0)
                         {
                             $('#<%=drpSubsidiary.ClientID%>')[0].selectedIndex = 0;
                         }
                         else
                         {
                             $('#<%=drpSubsidiary.ClientID%>').val(data.d[0].SubsideryId);
                         }

                         if (data.d[0].DiscountCode == 0)
                         {
                             $('#<%=drpDiscCode.ClientID%>')[0].selectedIndex = 0;
                         }
                         else
                         {
                            $('#<%=drpDiscCode.ClientID%>').val(data.d[0].DiscountCode);
                         }                        

                         $('#<%=txtOwnRiskAcCode.ClientID%>').val(data.d[0].OwnRiskAcctCode);
                         $('#<%=RTlblCreatedByName.ClientID%>').text(data.d[0].CreatedBy);
                         $('#<%=RTlblCreatedDateValue.ClientID%>').text(data.d[0].DateCreated);
                         $('#<%=RTlbllstchgName.ClientID%>').text(data.d[0].ModifiedBy);
                         $('#<%=RTlbllstchdatevalue.ClientID%>').text(data.d[0].DateModified);
                         $('#<%=txtZipCode.ClientID%>').val(data.d[0].ZipCode);
                         $('#<%=txtCity.ClientID%>').val(data.d[0].City);
                         $('#<%=txtCountry.ClientID%>').val(data.d[0].Country);
                         $('#<%=txtState.ClientID%>').val(data.d[0].State);
                     
                         if ((data.d[0].FlgAccValReq) == false)
                         {
                             var Value = "0";
                             var radio = $("[id*=rdbLstAccount] input[value=" + Value + "]");
                             radio.attr("checked", "checked");
                         }
                         else
                         {
                             var Value = "1";
                             var radio = $("[id*=rdbLstAccount] input[value=" + Value + "]");
                             radio.attr("checked", "checked");
                         }
                         if ((data.d[0].FlgExportSupplier) == false) {

                             var Value = "0";
                             var radio = $("[id*=rdbLstExportSupplier] input[value=" + Value + "]");
                             radio.attr("checked", "checked");
                         }
                         else
                         {
                             var Value = "1";
                             var radio = $("[id*=rdbLstExportSupplier] input[value=" + Value + "]");
                             radio.attr("checked", "checked");
                         }
                         if ((data.d[0].FlgLunchWithdraw) == false) {
                             $("#<%=chkLunchWithdraw.ClientID%>").attr('checked', false); 
                             $('#<%=txtFromTime.ClientID%>').val('');
                             $('#<%=txtToTime.ClientID%>').val('');
                             $('#<%=txtFromTime.ClientID%>').attr("disabled", "disabled");
                             $('#<%=txtToTime.ClientID%>').attr("disabled", "disabled");
                         }
                         else
                         {
                             $("#<%=chkLunchWithdraw.ClientID%>").attr('checked', true); 
                             $('#<%=txtFromTime.ClientID%>').removeAttr("disabled");
                             $('#<%=txtToTime.ClientID%>').removeAttr("disabled");
                         }
                         if ((data.d[0].FlgIntCustExp) == false) {
                             $("#<%=chkUseIntCustRuleExprt.ClientID%>").attr('checked', false);
                         }
                         else {
                             $("#<%=chkUseIntCustRuleExprt.ClientID%>").attr('checked', true);
                         }                                       
                         if ((data.d[0].FlgWareHouse) == false) {
                             $("#<%=chkWarehouse.ClientID%>").attr('checked', false);
                         }
                         else {
                             $("#<%=chkWarehouse.ClientID%>").attr('checked', true);
                         }
                         if (data.d[0].IdMake == 0) {
                             $('#<%=drpMakeCode.ClientID%>')[0].selectedIndex = 0;
                         }
                         else {
                             $('#<%=drpMakeCode.ClientID%>').val(data.d[0].IdMake);
                         }
                         if (data.d[0].RPIdMake == 0) {
                             $('#<%=drpRPMake.ClientID%>')[0].selectedIndex = 0;
                         }
                         else {
                             $('#<%=drpRPMake.ClientID%>').val(data.d[0].RPIdMake);
                         }
                         loadCategory();
                         loadRPCategory();
                         $('#<%=txtDepartmentID.ClientID%>').attr("disabled", "disabled");
                         $('#divDeptDetails').show();
                         $('#divUserDetails').show();
                         $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");
                         
                         if (data.d[0].IdItemCatg == 0) {
                             $('#<%=drpCategory.ClientID%>')[0].selectedIndex = 0;
                         }
                         else {
                             $('#<%=drpCategory.ClientID%>').val(data.d[0].IdItemCatg);
                         }
                         if (data.d[0].RPIdItemCatg == 0) {
                             $('#<%=drpRPCategory.ClientID%>')[0].selectedIndex = 0;
                         }
                         else {
                             $('#<%=drpRPCategory.ClientID%>').val(data.d[0].RPIdItemCatg);
                         }
                         $('#<%=txtDepartmentName.ClientID%>').focus();
                     }
                     else
                     {
                         $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                         $('#divUserDetails').hide();
                         $('#<%=txtDepartmentID.ClientID%>').removeAttr("disabled");
                     }                     
                 }

             });
         }

        function getGridHeaders() {
            $("#dgdDeptDetails").setCaption($('#<%=lblDeptHeader.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "DeptId", $('#<%=lblDepartmentID.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "DeptName", $('#<%=lblDepartmentName.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "DeptManager", $('#<%=lblDepartmentManager.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "Location", $('#<%=lblLocation.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "Address1", $('#<%=lblAddrLine1.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "Address2", $('#<%=lblAddrLine2.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "Phone", $('#<%=lblTele.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "Mobile", $('#<%=lblMobileNo.ClientID%>')[0].innerText);
            $('#dgdDeptDetails').jqGrid("setLabel", "FlgWareHouse", $('#<%=hdnIsWH.ClientID%>')[0].value);
            $('#dgdDeptDetails').jqGrid("setLabel", "SubsideryId", $('#<%=hdnSub.ClientID%>')[0].value);
            $('#dgdDeptDetails').jqGrid("setLabel", "DiscountCode", $('#<%=lblDiscountCode.ClientID%>')[0].innerText);
        }
         function loadMake() {
             $.ajax({
                 type: "POST",
                 url: "frmCFDepartment.aspx/MakeDropdown",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async:false,
                 success: function (Result) {
                     Result = Result.d;
                     $.each(Result, function (key, value) {
                         $('#<%=drpMakeCode.ClientID%>').append($("<option></option>").val(value.IdMake).html(value.IdMakeName));
                         $('#<%=drpRPMake.ClientID%>').append($("<option></option>").val(value.IdMake).html(value.IdMakeName));
                     });
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function loadCategory() {
                 $.ajax({
                     type: "POST",
                     url: "frmCFDepartment.aspx/FetchCategory",
                     //data: '{}',
                     data: "{makeF: '" + $('#<%=drpMakeCode.ClientID%>').val() + "', makeT: '" + $('#<%=drpMakeCode.ClientID%>').val() + "', filter: 'N'}",
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     async:false,
                     success: function (Result) {
                         Result = Result.d;
                         $('#<%=drpCategory.ClientID%>').empty();
                         $('#<%=drpCategory.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");
                         $.each(Result, function (key, value) {
                             $('#<%=drpCategory.ClientID%>').append($("<option></option>").val(value.IdItemCatg).html(value.ItemCatg));
                         });
                     },
                     failure: function () {
                         alert("Failed!");
                     }
             });
         }
         function loadRPCategory() {
             $.ajax({
                 type: "POST",
                 url: "frmCFDepartment.aspx/FetchRPCategory",
                 //data: '{}',
                 data: "{makeF: '" + $('#<%=drpRPMake.ClientID%>').val() + "', makeT: '" + $('#<%=drpRPMake.ClientID%>').val() + "', filter: 'N'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     $('#<%=drpRPCategory.ClientID%>').empty();
                     $('#<%=drpRPCategory.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");
                     Result = Result.d;
                     $.each(Result, function (key, value) {
                         $('#<%=drpRPCategory.ClientID%>').append($("<option></option>").val(value.IdItemCatg).html(value.ItemCatg));
                     });
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function loadTemplateCode() {
             $.ajax({
                 type: "POST",
                 url: "frmCFDepartment.aspx/FetchTemplateCode",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     Result = Result.d;
                     $.each(Result, function (key, value) {
                         $('#<%=drpTempCode.ClientID%>').append($("<option></option>").val(value.IdTempCode).html(value.TempCode));
                     });
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }

         function FillDiscountCode() {
             $.ajax({
                 type: "POST",
                 url: "frmCFDepartment.aspx/FetchDiscCode",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (Result) {
                     Result = Result.d;
                     $.each(Result, function (key, value) {
                         $('#<%=drpDiscCode.ClientID%>').append($("<option></option>").val(value.DiscountCode).html(value.DiscountCode));
                     });
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }

        function FillSubsidiary() {
            $.ajax({
                type: "POST",
                url: "frmCFDepartment.aspx/LoadSubsidiary",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=drpSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsideryId).html(value.SubsidiaryName));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function saveDept() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var result = fnClientValidate();
            if (result == true) {
                var tempCode = '';
                var category = '';
                var make = '';
                var rpMake = '';
                var rpCategory = '';
                var discCode = '';

                if ($('#<%=drpTempCode.ClientID%>')[0].selectedIndex != 0) {
                    tempCode = $('#<%=drpTempCode.ClientID%>').val();
                }
                if ($('#<%=drpCategory.ClientID%>')[0].selectedIndex != 0) {
                    category = $('#<%=drpCategory.ClientID%>').val();
                }
                if ($('#<%=drpMakeCode.ClientID%>')[0].selectedIndex != 0) {
                    make = $('#<%=drpMakeCode.ClientID%>').val();
                }
                if ($('#<%=drpRPMake.ClientID%>')[0].selectedIndex != 0) {
                    rpMake = $('#<%=drpRPMake.ClientID%>').val();
                }
                if ($('#<%=drpRPCategory.ClientID%>')[0].selectedIndex != 0) {
                    rpCategory = $('#<%=drpRPCategory.ClientID%>').val();
                }
                if ($('#<%=drpDiscCode.ClientID%>')[0].selectedIndex != 0) {
                    discCode = $('#<%=drpDiscCode.ClientID%>').val();
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCFDepartment.aspx/SaveDepartment",
                    data: "{deptId: '" + $('#<%=txtDepartmentID.ClientID%>').val() + "', deptName:'" + $('#<%=txtDepartmentName.ClientID%>').val() + "', deptMgr:'" + $('#<%=txtDepartmentManager.ClientID%>').val() + "', subId:'" + $('#<%=drpSubsidiary.ClientID%>').val() + "', deptAddrL1:'" + $('#<%=txtAddress1.ClientID%>').val() + "', deptAddrL2:'" + $('#<%=txtAddress2.ClientID%>').val() + "', deptTele:'" + $('#<%=txtTelephoneNo.ClientID%>').val() + "', deptMobile:'" + $('#<%=txtMobile.ClientID%>').val() + "', deptLoc:'" + $('#<%=txtLocation.ClientID%>').val() + "', deptAcctCode:'" + $('#<%=txtDepAcccode.ClientID%>').val() + "', deptDsicCode:'" + discCode + "', deptFlgWh:'" + $('#<%=chkWarehouse.ClientID%>').is(':checked') + "', deptIdMake:'" + make + "', deptItemCat:'" + category + "', deptRPIdMake:'" + rpMake + "', deptRPItemCat:'" + rpCategory + "', deptFlgAccVal:'" + $('#<%=rdbLstAccount.ClientID%>').find(":checked").val() + "', deptFlgExpSupp:'" + $('#<%=rdbLstExportSupplier.ClientID%>').find(":checked").val() + "', deptZipCode:'" + $('#<%=txtZipCode.ClientID%>').val() + "', deptZipCOuntry:'" + $('#<%=txtCountry.ClientID%>').val() +
                        "',deptZipState: '" + $('#<%=txtState.ClientID%>').val() + "',deptZipCity: '" + $('#<%=txtCity.ClientID%>').val() + "',deptOwnRiskAcctCode: '" + $('#<%=txtOwnRiskAcCode.ClientID%>').val() + "',deptFlgLnWithdraw: '" + $('#<%=chkLunchWithdraw.ClientID%>').is(':checked') + "',deptFromTime: '" + $('#<%=txtFromTime.ClientID%>').val() + "' ,deptTotime: '" + $('#<%=txtToTime.ClientID%>').val() + "',deptTempCode: '" + tempCode + "',deptFlgIntCustExp: '" + $('#<%=chkUseIntCustRuleExprt.ClientID%>').is(':checked') + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d == "0" || data.d == 'INSFLGN') {
                            jQuery("#dgdDeptDetails").jqGrid('clearGridData');
                            loadDeptDetails();
                            jQuery("#dgdDeptDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divDeptDetails').hide();
                            $('#divUserDetails').hide();
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d == "Present" || data.d == 'INSFLGN') {
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

        function loadDeptDetails() {
            jQuery("#dgdDeptDetails").jqGrid('clearGridData');
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCFDepartment.aspx/FetchAllDepartments",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdDeptDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });
            jQuery("#dgdDeptDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        }

        function delDepartment() {
            var deptId = "";
            $('#dgdDeptDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    deptId = $('#dgdDeptDetails tr ')[row].cells[2].innerHTML.toString();
                }
            });

            if (deptId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delDept();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }
        
        function delDept() {
            var row;
            var deptId;
            var deptName;
            var deptIdxml;
            var deptIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdDeptDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    deptId = $('#dgdDeptDetails tr ')[row].cells[2].innerHTML.toString();
                    deptName = $('#dgdDeptDetails tr ')[row].cells[3].innerHTML.toString();
                    deptIdxml = "<Master><DeptId>" + deptId + "</DeptId>" + "<Deptname>" + deptName + "</Deptname></Master>";
                    deptIdxmls += deptIdxml;
                }
            });

            if (deptIdxmls != "") {
                deptIdxmls = "<ROOT>" + deptIdxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCFDepartment.aspx/DeleteDepartment",
                    data: "{deptIdxmls: '" + deptIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdDeptDetails").jqGrid('clearGridData');
                        loadDeptDetails();
                        jQuery("#dgdDeptDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divDeptDetails').hide();
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
        function addDeptDetails() {
            $('#<%=txtDepartmentID.ClientID%>').removeAttr("disabled");
            $('#<%=txtAddress1.ClientID%>').val("");
            $('#<%=txtAddress2.ClientID%>').val("");
            $('#<%=txtCity.ClientID%>').val("");
            $('#<%=txtCountry.ClientID%>').val("");
            $('#<%=txtDepAcccode.ClientID%>').val("");
            $('#<%=txtDepartmentID.ClientID%>').val("");
            $('#<%=txtDepartmentManager.ClientID%>').val("");
            $('#<%=txtDepartmentName.ClientID%>').val("");
            $('#<%=txtFromTime.ClientID%>').val("");
            $('#<%=txtLocation.ClientID%>').val("");
            $('#<%=txtMobile.ClientID%>').val("");
            $('#<%=txtOwnRiskAcCode.ClientID%>').val("");
            $('#<%=txtState.ClientID%>').val("");
            $('#<%=txtTelephoneNo.ClientID%>').val("");
            $('#<%=txtToTime.ClientID%>').val("");
            $('#<%=txtZipCode.ClientID%>').val("");
            $('#<%=txtState.ClientID%>').val("");
            $('#<%=drpCategory.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpDiscCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpMakeCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpRPMake.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpSubsidiary.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpTempCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=drpRPCategory.ClientID%>')[0].selectedIndex = 0;
            $('#divDeptDetails').show();
            $('#divUserDetails').hide();
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add")
            $("#<%=txtDepartmentID.ClientID%>")[0].readOnly = false;
            var check = $('#<%=chkLunchWithdraw.ClientID%>').is(":checked");
            if (check == false) {
                $('#<%=txtFromTime.ClientID%>').attr("disabled", "disabled");
                $('#<%=txtToTime.ClientID%>').attr("disabled", "disabled");
            }
            $("#<%=rdbLstExportSupplier.ClientID%>").attr("disabled", "disabled");
            $('#<%=txtDepartmentID.ClientID%>').focus();
        }

        function resetDeptDet() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divDeptDetails').hide();
                $('#divUserDetails').hide();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("")
            }
           
        }
        
        
        function fnClientValidate() {
            var d = $(document.getElementById('<%=hdnLang.ClientID%>')).val();
            //document.getElementById('RTlblError').innerHTML = "";
            if (!(gfi_CheckEmpty($('#<%=txtDepartmentID.ClientID%>'), '0126'))) {
                return false;
            }

            if (!(gfi_ValidateNumber($('#<%=txtDepartmentID.ClientID%>'), '0126'))) {
                $('#<%=txtDepartmentID.ClientID%>').val("");
                $('#<%=txtDepartmentID.ClientID%>').focus();
                return false;
            }

            if ($('#<%=txtDepartmentID.ClientID%>').val() < 1) {
                var msg = GetMultiMessage('880516', GetMultiMessage('0126', '', ''), '');
                alert(msg);
                $('#<%=txtDepartmentID.ClientID%>').focus();
                return false
            }

            if ((!(gfi_CheckEmpty($('#<%=txtDepartmentName.ClientID%>'), '0127'))) || (!(gfb_ValidateAlphabets($('#<%=txtDepartmentName.ClientID%>'), '0127')))) {
                return false;
            }


            if (!(gfb_ValidateAlphabets($('#<%=txtDepartmentManager.ClientID%>'), '0128'))) {
                return false;
            }
            if ($('#<%=drpSubsidiary.ClientID%>')[0].selectedIndex == "0") {
                var msg = GetMultiMessage('0007', GetMultiMessage('0122', '', ''), '');
                alert(msg);
                $('#<%=drpSubsidiary.ClientID%>').focus();
                return false;
            }

            if ($('#<%=drpMakeCode.ClientID%>')[0].selectedIndex > 0 && $('#<%=drpCategory.ClientID%>')[0].selectedIndex == 0) {
                var msg = GetMultiMessage('ErrMakeCat', '', '');
                alert(msg);
                $('#<%=drpMakeCode.ClientID%>').focus();
                return false;
            }
            if ($('#<%=drpRPMake.ClientID%>')[0].selectedIndex > 0 && $('#<%=drpRPCategory.ClientID%>')[0].selectedIndex == 0) {
                var msg = GetMultiMessage('ErrMakeCat', '', '');
                alert(msg);
                $('#<%=drpRPMake.ClientID%>').focus();
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtLocation.ClientID%>'), '0043'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtAddress1.ClientID%>'), '0115'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtAddress2.ClientID%>'), '0115'))) {
                return false;
            }

            if (!(gfi_ValidatePhoneNumber($('#<%=txtTelephoneNo.ClientID%>'), '0117', '-'))) {
                return false;
            }

            if (!(gfi_ValidatePhoneNumber($('#<%=txtMobile.ClientID%>'), '0041', '-'))) {
                return false;
            }

            var UzipCode = $('#<%=txtZipCode.ClientID%>').val();
            if (UzipCode != "") {
                if (!(gfb_ValidateAlphabets($('#<%=txtCity.ClientID%>'), '0194'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtCountry.ClientID%>'), '0192'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193'))) {
                    return false;
                }
            }
          

            if ($('#<%=chkLunchWithdraw.ClientID%>')[0].checked) {
                if ($('#<%=txtFromTime.ClientID%>').val() == '') {
                    alert(GetMultiMessage('FTIME', '', ''));
                    $('#<%=txtFromTime.ClientID%>').focus();
                    return false;
                }
                else if ($('#<%=txtToTime.ClientID%>').val() == '') {
                    alert(GetMultiMessage('TTIME', '', ''))
                    $('#<%=txtFromTime.ClientID%>').focus()
                    return false;
                }
                else (($('#<%=txtFromTime.ClientID%>').val() != '') && ($('#<%=txtToTime.ClientID%>').value != ''))
                {
                    if ($('#<%=txtFromTime.ClientID%>').val() > $('#<%=txtToTime.ClientID%>').val()) {
                        alert(GetMultiMessage('0317', '', ''));
                        return false;
                    }
                }
            }

            return true;
        }
        function fnValidateFromTime() {
            if ($('#<%=txtFromTime.ClientID%>').val() != '') {
                Validatetime($('#<%=txtFromTime.ClientID%>'));
            }
        }

        function fnValidateEndTime() {
            if ($('#<%=txtToTime.ClientID%>').val() != '') {
                Validatetime($('#<%=txtToTime.ClientID%>'));
            }
        }
             
               
     </script>
    <script type="text/javascript">
        $(document).on('click', '#<%=chkLunchWithdraw.ClientID%>', function () {
            $('#<%=chkLunchWithdraw.ClientID%>').attr("checked", function () {
            if (this.checked == true)
             {
                $('#<%=txtFromTime.ClientID%>').removeAttr("disabled"); 
                $('#<%=txtToTime.ClientID%>').removeAttr("disabled"); 
            }
            else
            {
                $('#<%=txtFromTime.ClientID%>').attr("disabled", "disabled");
                $('#<%=txtToTime.ClientID%>').attr("disabled", "disabled");
            }
            });
        });

        $(document).on('click', '#<%=chkWarehouse.ClientID%>', function () {
            $('#<%=chkWarehouse.ClientID%>').attr("checked", function () {
                if (this.checked == true) {
                    $('#<%=rdbLstExportSupplier.ClientID%>').removeAttr("disabled");
                }
                else {
                    $('#<%=rdbLstExportSupplier.ClientID%>').attr("disabled", "disabled");
                }
            });
        });


        </script>
            
        <div class="header1" style="padding-top:0.5em">
            <asp:Label ID="lblDeptHeader" runat="server" Text="Department Details"></asp:Label>
             <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
            <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
            <asp:HiddenField ID="hdnMode" runat="server" />
            <asp:HiddenField ID="hdnPageSize" runat="server" />
            <asp:HiddenField ID="hdnIsWH" runat="server" Value="Is Warehouse" />
             <asp:HiddenField ID="hdnSub" runat="server" Value="Subsidiary" />
            <asp:HiddenField ID="hdnSelect" runat="server" Value="Select" />
             <asp:HiddenField ID="hdnCulture" Value="<%$ appSettings:cultureName %>" runat="server"/>
             <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
            <asp:HiddenField ID="hdnLang" Value="<%$ appSettings:Language %>" runat="server"/>
        </div>
        <div style="text-align:center">
                <input id="btnAddT" runat="server" type="button" value="Add" class="ui button" onclick="addDeptDetails()"/>
                <input id="btnDeleteT" runat="server" type="button" value="Delete" class="ui button" onclick ="delDepartment()" />
                <input id="btnPrintT" runat="server" type="button" value="Print" class="ui button" />

        </div>
     <div>
            <div class="field">
            </div>

            <div>
                <table id="dgdDeptDetails" title="Department Details"></table>
                <div id="pager1" ></div>
            </div>
         <div style="text-align:center">
                <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addDeptDetails()"/>
                <input id="btnDeleteB" runat="server" type="button" value="Delete" class="ui button" onclick ="delDepartment()" />
                <input id="btnPrintB" runat="server" type="button" value="Print" class="ui button" />

        </div>
            <div id="divDeptDetails" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Department Details</a>  
            </div>
            <br />
       
            <div class="ui form" style="width:100%">
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label id="lblDepartmentID" runat="server" Text="Department ID"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtDepartmentID" runat="server" ></asp:TextBox>
                    </div>
                     <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label id="lblDepartmentName" runat="server" Text="Department Name"></asp:Label><span class="mand">*</span>
                    </div>
                     <div class="field" style="width:250px">
                        <asp:TextBox ID="txtDepartmentName"  runat="server"></asp:TextBox>
                    </div>
                                     
                </div>
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblDepartmentManager" runat="server" Text="Department Manager"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtDepartmentManager"  runat="server" ></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblSubsidiaryID" runat="server" Text="Subsidiary ID"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                       <asp:DropDownList ID="drpSubsidiary" runat="server" CssClass="drpdwm" Width="244px"></asp:DropDownList>
                   </div>
                                     
                </div>
                 <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label id="lblLocation" runat="server" Text="Location"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtLocation" runat="server" ></asp:TextBox>
                    </div>
                     <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblTele" runat="server" Text="Telephone No"></asp:Label>
                    </div>
                     <div class="field" style="width:250px">
                        <asp:TextBox ID="txtTelephoneNo"  runat="server"></asp:TextBox>
                    </div>                                     
                </div>
                 <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblMobileNo" runat="server" Text="Mobile No."></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtMobile" runat="server" ></asp:TextBox>
                    </div>
                     <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblIsWareHouse" runat="server" Text="Is it Ware house?"></asp:Label>
                    </div>
                     <div class="field" style="width:250px">
                        <asp:CheckBox ID="chkWarehouse" runat="server" />
                    </div>                                     
                </div>
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblValAccount" runat="server" Text="Accounting Validation Required?"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:RadioButtonList ID="rdbLstAccount" class="optionlist" Width="100px"  runat="server"  RepeatDirection="Horizontal">
                                 <asp:ListItem Value="1" Selected="True" Text="Yes"/>
                                  <asp:ListItem Value="0" Text="No" />
                        </asp:RadioButtonList>
                    </div>
                     <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblExportSupplier" runat="server" Text="Automatic Export to Supplier"></asp:Label>
                    </div>
                     <div class="field" style="width:250px">
                         <asp:RadioButtonList ID="rdbLstExportSupplier" class="optionlist" Width="100px" runat="server"  RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1"  Text="Yes"/>
                                <asp:ListItem Value="0" Text="No"/>
                          </asp:RadioButtonList>
                    </div>                                     
                </div>
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblUseIntCustRuleExprt" runat="server" Text="Use Internal Customer Rules for Export"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                       <asp:CheckBox ID="chkUseIntCustRuleExprt" runat="server" />
                    </div>
             </div>
                  <div class="four fields">
                     <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblLunchWithdraw" runat="server" Text="Withdraw Lunch?"></asp:Label>
                    </div>
                     <div class="field" style="width:250px">
                        <asp:CheckBox ID="chkLunchWithdraw" runat="server" />
                    </div>
                     <div class="field" style="padding-left:1em;width:100px">
                        <asp:Label ID="lblFromTime" runat="server" Text="From Time"></asp:Label>
                    </div>
                       <div class="field" style="width:150px">
                        <asp:TextBox ID="txtFromTime" runat="server" ></asp:TextBox>
                    </div>
                    <div class="field" style="padding-left:1em;width:100px">
                        <asp:Label ID="lblTotime" runat="server" Text="To Time"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtToTime" runat="server" ></asp:TextBox>
                    </div>                                     
               </div>
                 <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblTempCode" runat="server" Text="Template Code"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                       <asp:DropDownList ID="drpTempCode" runat="server" CssClass="drpdwm" Width="244px"></asp:DropDownList>
                    </div>
                </div>
                 
            </div>
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" runat="server" id="aAddrComm">Address For Communication</a>
            </div>
         <div class="ui form" style="width:100%">
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblAddrLine1" runat="server" Text="Address Line 1"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtAddress1"  runat="server" ></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblAddrLine2" runat="server" Text="Address Line 2"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:TextBox ID="txtAddress2"  runat="server"></asp:TextBox>
                   </div>
                                     
                </div>
              <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblZipCode" runat="server" Text="Zip Code"></asp:Label><span class="mand"></span>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtZipCode"  runat="server" ></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblCity" runat="server" Text="City"></asp:Label><span class="mand"></span>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:TextBox ID="txtCity"  runat="server"></asp:TextBox>
                   </div>                                     
                </div>
              <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblCountry" runat="server" Text="Country"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtCountry"  runat="server" ></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lblState" runat="server" Text="State"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:TextBox ID="txtState"  runat="server"></asp:TextBox>
                   </div>
                                     
                </div>
              <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                    <asp:Label ID="lblDeptAccCode" runat="server" Text="Department Account Code"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtDepAcccode"  runat="server" ></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                    <asp:Label ID="lblDiscountCode" runat="server" Text="Discount Code"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:DropDownList ID="drpDiscCode" runat="server" CssClass="drpdwm">
                                                            </asp:DropDownList>
                   </div>
                                     
                </div>
             <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                    <asp:Label ID="lblOwnRiskAcCode" runat="server" Text="Own Risk Account Code"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:TextBox ID="txtOwnRiskAcCode"  runat="server" ></asp:TextBox>
                    </div>
                                                     
                </div>
            </div>
        <br />
          <div class="ui page grid" style="padding-left:0%;padding-right:0%">
              <div class="two column row">
            <div class="column" style="padding-left:0em;width:40%">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" runat="server" id="aOwnRisk">For Own Risk Vat</a>
            </div>
                 <div class="ui form" style="width:100%">
                    <div class="four fields">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblMake" runat="server" Text="Make Code"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="drpMakeCode" runat="server" CssClass="drpdwm">
                        </asp:DropDownList>
                   </div>
                 </div>
                     <div class="four fields">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblItemCatg" runat="server" Text="Item Category"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="drpCategory" runat="server" CssClass="drpdwm">
                        </asp:DropDownList>
                   </div>
                 </div>
                 </div>
            </div>
            <div class="column" style="width:60%">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" runat="server" id="aRpGm">For Repair Package Garage Material</a>
            </div>
                  <div class="ui form" style="width:100%">
                    <div class="four fields">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblRPMake" runat="server" Text="Make Code"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="drpRPMake" runat="server" CssClass="drpdwm">
                        </asp:DropDownList>
                   </div>
                 </div>
                       <div class="four fields">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblRPCategory" runat="server" Text="Item Category"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="drpRPCategory" runat="server" CssClass="drpdwm">
                        </asp:DropDownList>
                   </div>
                 </div>
                 </div>
            </div>
        </div>
           </div>
         <div style="text-align:center">
                    <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" onclick="saveDept()"  />
                    <input id="btnReset" runat="server" class="ui button" value="Reset" type="button" style="background-color: #E0E0E0"  onclick="resetDeptDet()"/>
                </div> 
            </div>

         <div id="divUserDetails" class="ui form" style="width:100%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #ffffff">
            </div>
        
            <div class="four fields">
                   <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblCreatedBy" runat="server" Text="Created By:"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:Label ID="RTlblCreatedByName" runat="server" Text=""></asp:Label>
                   </div>
                   <div class="field" style="padding-left:1em;width:200px">
                         <asp:Label ID="lblCreatedDate" runat="server" Text="on"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:Label ID="RTlblCreatedDateValue" runat="server" Text=""></asp:Label>
                   </div>                                     
            </div>

            <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lbllschgBy" runat="server" Text="Last Changed By:"></asp:Label>
                    </div>
                    <div class="field" style="width:250px">
                        <asp:Label ID="RTlbllstchgName" runat="server" Text=""></asp:Label>
                    </div>
                   <div class="field" style="padding-left:1em;width:200px">
                        <asp:Label ID="lbllstchdate" runat="server" Text="on"></asp:Label>
                   </div>
                   <div class="field" style="width:250px">
                        <asp:Label ID="RTlbllstchdatevalue" runat="server" Text=""></asp:Label>
                   </div>                                     
           </div>        
         </div>
    </div>

</asp:Content>

    




