<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfRoles.aspx.vb" Inherits="CARS.frmCfRoles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#divEdit').hide();
            $('#divGrids').hide();
            $('#<%=btnAddT.ClientID%>').show();
            $('#<%=btnDeleteT.ClientID%>').show();
            
            loadSubsidiary();
            var subsideryId = '<%= Session("UserSubsidiary")%>';
            var departmentId = '<%= Session("UserDept")%>';

            if( subsideryId != '')
            {
                $('#<%=drpSubsidiary.ClientID%>').val(subsideryId);
                loadDepartment(subsideryId);
            }

            if (departmentId != '')
            {
                $('#<%=drpDepartment.ClientID%>').val(departmentId);
            }

            if (subsideryId == '' && departmentId == '')
            {
                $('#<%=drpDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                $('#<%=drpDepartment.ClientID%>')[0].selectedIndex = 0;
                $('#<%=drpRole.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                $('#<%=drpRole.ClientID%>')[0].selectedIndex = 0;
                loadRoles(0, 0)
            }
            else
            {
                loadRoles(subsideryId, departmentId);

            }
           
            var subId = $('#<%=drpSubsidiary.ClientID%>').val();
            loadStartScreen();

            $('#<%=drpDepartment.ClientID%>').change(function (e) {
                $('#<%=RTlblError.ClientID%>').text('');
                var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                var deptId = $('#<%=drpDepartment.ClientID%>').val();
                $('#<%=drpRole.ClientID%>').empty();
                jQuery("#dgdCtlPermissions").jqGrid('clearGridData');
                jQuery("#dgdPermissions").jqGrid('clearGridData');
                $("#divChkBoxListControl").empty();
                $('#divGrids').hide();
                loadRoles(subId, deptId);
                loadRolesGrid(subId, deptId);
                $('#divEdit').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDeleteT.ClientID%>').show();
            });

            $('#<%=drpSubsidiary.ClientID%>').change(function (e) {
                $('#<%=RTlblError.ClientID%>').text('');
                var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                $('#<%=drpDepartment.ClientID%>').empty();
                jQuery("#dgdCtlPermissions").jqGrid('clearGridData');
                jQuery("#dgdPermissions").jqGrid('clearGridData');
                $("#divChkBoxListControl").empty();
                $('#divGrids').hide();
                loadDepartment(subId);
                loadRoles(subId, 0);
                loadRolesGrid(subId, 0);
                $('#divEdit').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDeleteT.ClientID%>').show();

            });


        var grid = $("#dgdRoles");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;;
        var mydata;

        grid.jqGrid({
            datatype: "local",
            data: mydata,
            colNames: ['Id_Role', 'IdScreen', 'Nm_Role', 'Flg_Sysadmin', 'Flg_Subsidadmin', 'Flg_Deptadmin', ''],
            colModel: [
                     { name: 'Id_Role', index: 'Id_Role', width: 60, sorttype: "string",hidden:true },
                     { name: 'IdScreen', index: 'IdScreen', width: 60, sorttype: "string", hidden: true },
                     { name: 'Nm_Role', index: 'Nm_Role', width: 160, sorttype: "string" },
                     { name: 'Flg_Sysadmin', index: 'Flg_Sysadmin', formatter: displayCheckbox },
                     { name: 'Flg_Subsidadmin', index: 'Flg_Subsidadmin', formatter: displayCheckbox },
                     { name: 'Flg_Deptadmin', index: 'Flg_Deptadmin', formatter: displayCheckbox },
                     { name: 'Id_Role', index: 'Id_Role', sortable: false, formatter: displayButtons }
            ],
            multiselect: true,
            pager: jQuery('#pager1'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            autoencode: true,
            height: "50%",
            async: false, //Very important,
            subGrid: false

        });
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "frmCFRoles.aspx/Fetch_Role",
            data: "{subId: '" + $('#<%=drpSubsidiary.ClientID%>').val() + "', deptId:'" + $('#<%=drpDepartment.ClientID%>').val() + "'}",
            dataType: "json",
            async: false,//Very important
            success: function (data) {
                for (i = 0; i < data.d.length; i++) {
                    mydata = data;
                    jQuery("#dgdRoles").jqGrid('addRowData', i + 1, mydata.d[i]);
                }
            }
        });

            jQuery("#dgdRoles").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            getRolesGridHeaders();
            $("#dgdRoles").jqGrid("hideCol", "subGrid");

       

            $('#<%=drpRole.ClientID%>').change(function (e) {
            $('#<%=RTlblError.ClientID%>').text('');
            $('#divGrids').show();
            jQuery("#dgdCtlPermissions").jqGrid('clearGridData');
            jQuery("#dgdPermissions").jqGrid('clearGridData');
            loadPermissions();
            loadCtlPermissions();
            CheckBoxList();
        });

           
           
           

            $('#<%=ChkallList.ClientID%>').click(function (event) {  //on click
                if (this.checked) { // check select status
                    $('#divChkBoxListControl input:checkbox[name=chklistitem]').each(function ()
                    {
                        this.checked = true;
                    });

                    
                } else {
                    $('#divChkBoxListControl input:checkbox[name=chklistitem]').each(function () {
                        this.checked = false;
                    });
                }
            });

          

        });
       
        function addChkboxItem() {
          
            var scrId;
            var scrName;
            var scrIdxml;
            var scrIdxmls = "";
          
            $('#divChkBoxListControl input:checkbox[name=chklistitem]').attr("checked", function () {
                    if (this.checked && this.disabled == false) {
                        scrId = this.id;  
                        scrName = this.value; 
                    $(this).attr("disabled", true);
                    scrIdxml = "<Master><ScrId>" + scrId + "</ScrId>" + "<ScrName>" + scrName + "</ScrName></Master>";
                    scrIdxmls += scrIdxml;                   
                }
                
                });
                if (scrIdxmls != "") {
                    scrIdxmls = "<Root>" + scrIdxmls + "</Root>";
                    hdnXML = scrIdxmls;
                }
            else
                {
                    hdnXML = scrIdxmls;
                }
        }

        function removeChkboxItem() {
            var scrId;
            var scrName;
            $('#divChkBoxListControl input:checkbox[name=chklistitem]').attr("checked", function () {
                if (this.checked && this.disabled == true) {
                    scrId = this.id;  
                    scrName = this.value;
                    $(this).attr("disabled", false);
                    $(this).attr('checked', false);
                }

            });
           
        }

        function displayButtons(cellvalue, options, rowObject) {
            var roleId = rowObject.Id_Role.toString();
            var screenId = rowObject.IdScreen.toString();
            var flgSysAdmin = rowObject.Flg_Sysadmin.toString();
            var flgSubAdmin = rowObject.Flg_Subsidadmin.toString();
            var flgDeptAdmin = rowObject.Flg_Deptadmin.toString();
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edtRole(" + "'" + roleId + "'" + "," + flgSysAdmin + "," + flgSubAdmin + "," + flgDeptAdmin + "," + "'" + screenId + "'" + "); />";
            return edit;
        }

       
        function edtRole(roleId, flgSysAdmin, flgSubAdmin, flgDeptAdmin, screenId) {
            $('#divEdit').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDeleteT.ClientID%>').hide();
            var rowData = $('#dgdRoles').jqGrid('getGridParam', 'data');
            for (var i = 0; i < rowData.length; i++) {
                var row = rowData[i];
                if (row.Id_Role == roleId)
                {
                    var roleName = row.Nm_Role;
                    $('#<%=txtRole.ClientID%>').val(roleName);
                }
            }
            $('#<%=drpStartScreen.ClientID%>').val(screenId);
            $(document.getElementById('<%=hdnRoleId.ClientID%>')).val(roleId);
                     
            if (flgSysAdmin == false)
            {
                $("#<%=rbaddadmin.ClientID%>").attr('checked', false); 
                $("#<%=rbaddadmin.ClientID%>").attr('disabled', 'disabled');
            }
            else
            {
                $("#<%=rbaddadmin.ClientID%>").attr('checked', true); 
                $("#<%=rbaddadmin.ClientID%>").removeAttr("disabled");
            }

            if (flgSubAdmin == false)
            {
                $("#<%=rbaddsubadmin.ClientID%>").attr('checked', false); 
                $("#<%=rbaddsubadmin.ClientID%>").attr('disabled', 'disabled');
            }
            else
            {
                $("#<%=rbaddsubadmin.ClientID%>").attr('checked', true); 
                $("#<%=rbaddsubadmin.ClientID%>").removeAttr("disabled");
            }
            if (flgDeptAdmin == false)
            {
                $("#<%=rbadddepadmin.ClientID%>").attr('checked', false); 
                $("#<%=rbadddepadmin.ClientID%>").attr('disabled', 'disabled');
            }
            else
            {
                $("#<%=rbadddepadmin.ClientID%>").attr('checked', true); 
                $("#<%=rbadddepadmin.ClientID%>").removeAttr("disabled");
            }
        }

        function displayCheckbox(cellvalue, options, rowObject) {
            var valchk = cellvalue;
            if (valchk == true) {
                var chk = '<input type="checkbox" value="' + cellvalue + '" disabled="disabled" checked="checked">';
            }
            else {
                var chk = '<input type="checkbox" value="' + cellvalue + '" disabled="disabled">';
            }
            return chk;
        }


        function loadRolesGrid(subsId,deptId) {
            var grid = $("#dgdRoles");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;;
            var mydata;
            jQuery("#dgdRoles").jqGrid('clearGridData');
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Id_Role', 'IdScreen', 'Nm_Role', 'Flg_Sysadmin', 'Flg_Subsidadmin', 'Flg_Deptadmin', ''],
                colModel: [
                         { name: 'Id_Role', index: 'Id_Role', width: 60, sorttype: "string", hidden: true },
                         { name: 'IdScreen', index: 'IdScreen', width: 60, sorttype: "string", hidden: true },
                         { name: 'Nm_Role', index: 'Nm_Role', width: 60, sorttype: "string" },
                         { name: 'Flg_Sysadmin', index: 'Flg_Sysadmin', formatter: displayCheckbox },
                         { name: 'Flg_Subsidadmin', index: 'Flg_Subsidadmin', formatter: displayCheckbox },
                         { name: 'Flg_Deptadmin', index: 'Flg_Deptadmin', formatter: displayCheckbox },
                         { name: 'Id_Role', index: 'Id_Role', sortable: false, formatter: displayButtons }
                ],
                multiselect: true,
                pager: jQuery('#pager1'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                async: false, //Very important,
                subgrid: false

            });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCFRoles.aspx/Fetch_Role",
                data: "{subId: '" + subsId + "', deptId:'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdRoles").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdRoles").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdRoles").jqGrid("hideCol", "subgrid");

        }


        function loadPermissions() {
            var gridPer = $("#dgdPermissions");
            var pagePerSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;;
            var mydataPer;
           
            gridPer.jqGrid({
                datatype: "local",
                data: mydataPer,
                colNames: ['IdScreen', 'ScrnName', 'Flg_Acc_Read', 'Flg_Acc_Write', 'Flg_Acc_Create', 'Flg_Acc_Print', 'Flg_Acc_Delete'],
                colModel: [
                          { name: 'IdScreen', index: 'IdScreen', width: 260, sorttype: "string", hidden: true },
                         { name: 'ScrnName', index: 'ScrnName', width: 260, sorttype: "string" },
                         { name: 'Flg_Acc_Read', index: 'Flg_Acc_Read', formatter: displayPermCheckbox },
                         { name: 'Flg_Acc_Write', index: 'Flg_Acc_Write', formatter: displayPermCheckbox },
                         { name: 'Flg_Acc_Create', index: 'Flg_Acc_Create', formatter: displayPermCheckbox },
                         { name: 'Flg_Acc_Print', index: 'Flg_Acc_Print', formatter: displayPermCheckbox },
                         { name: 'Flg_Acc_Delete', index: 'Flg_Acc_Delete', formatter: displayPermCheckbox }

                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pagePerSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                async: false, //Very important,
                subgrid: false
         

            });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCFRoles.aspx/RoleChange",
                data: "{roleId: '" + $('#<%=drpRole.ClientID%>').val() + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                   for (var i = 0; i < data.d.length; i++) {
                        mydataPer = data;
                        jQuery("#dgdPermissions").jqGrid('addRowData', i + 1, mydataPer.d[i]);
                       
                    }
                },
                error: function (result) {
                    alert("Error");
                }
            });
            jQuery("#dgdPermissions").setGridParam({ rowNum: pagePerSize }).trigger("reloadGrid");
            $("#dgdPermissions").jqGrid('hideCol', 'cb');
            getPermissionGridHeaders();
            $("#dgdPermissions").jqGrid("hideCol", "subgrid");
        }

        function displayPermCheckbox(cellvalue, options, rowObject) {
            var valchk = cellvalue;
            var scrId = rowObject.IdScreen;
            if (valchk == true) {
                var chk = '<input id="' + options.rowId + options.colModel.name + '" type="checkbox"  checked="checked"  onclick=MakeCellEditable(' + '"' + options.rowId + '"' + ',' + '"' + options.colModel.name + '"' + ',' + 'false' + ') >';
            }
            else {
                var chk = '<input type="checkbox"  onclick=MakeCellEditable(' + '"' + options.rowId + '"' + ',' + '"' + options.colModel.name + '"' + ',' + 'true' + ') >';
            }
            return chk;
        }

        function loadCtlPermissions() {
            var grid = $("#dgdCtlPermissions");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;;
            var mydata;

            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['IdConUtil', 'CtrlName', 'Flg_Acc'],
                colModel: [
                         { name: 'IdConUtil', index: 'IdConUtil', width: 260, sorttype: "string", hidden: true },
                         { name: 'CtrlName', index: 'CtrlName', width: 260, sorttype: "string" },
                         { name: 'Flg_Acc', index: 'Flg_Acc', formatter: displayCtlPermissionsCheckbox }
                ],
                multiselect: true,
                pager: jQuery('#pager2'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                async: false, //Very important,
                subgrid: false

            });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCFRoles.aspx/ControlDet",
                data: "{roleId: '" + $('#<%=drpRole.ClientID%>').val() + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    jQuery("#dgdCtlPermissions").jqGrid('clearGridData');
                    for (var i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdCtlPermissions").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                },
                error: function (result) {
                    alert("Error");
                }
            });
            jQuery("#dgdCtlPermissions").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdCtlPermissions").jqGrid('hideCol', 'cb');
            getctrlPermissionGridHeaders();
            $("#dgdCtlPermissions").jqGrid("hideCol", "subgrid");
        }

        function displayCtlPermissionsCheckbox(cellvalue, options, rowObject) {
            var valchk = cellvalue;
            if (valchk == true) {
                var chk = '<input id="' + options.rowId + options.colModel.name + '" type="checkbox" value="' + cellvalue + '" checked="checked"  onclick=MakeGridCellEditable(' + '"' + options.rowId + '"' + ',' + '"' + options.colModel.name + '"' + ',' + 'false' + ') >';
            }
            else {
                var chk = '<input id="' + options.rowId + options.colModel.name + '" type="checkbox" value="' + cellvalue + '" onclick=MakeGridCellEditable(' + '"' + options.rowId + '"' + ',' + '"' + options.colModel.name + '"' + ',' + 'true' + ') >';
            }
            return chk;
        }

        function MakeGridCellEditable(rowId, colName,val) {
            var item = '#dgdCtlPermissions';
            var rowids = $(item).getDataIDs();
            var colModel = $(item).getGridParam().colModel;

            var value = val;//$(this).jqGrid('getCell', rowId, colName);

            for (var i = 0; i < rowids.length; i++) {
                if (rowId == rowids[i]) {
                    for (var j = 0; j < colModel.length; j++) {
                        if (colModel[j].name == colName) {
                            // Put cell in editmode.
                            // If the edit (third param) is set to false the cell is just selected and not edited.
                            // If set to true the cell is selected and edited.
                            $(item).editCell(i, j, true);

                            // Let the grid know that the cell has been changed without having to push enter button or click another cell.
                            $(item).saveCell(i, j);
                            //var success = jQuery("#dgdPermissions").jqGrid('setRowData', 1, dataToAdd[0]);
                            $("#dgdCtlPermissions").jqGrid('setCell', rowId, colName, value);

                        }
                    }
                }
            }
        }


        function MakeCellEditable(rowId, colName,val) {
            var item = '#dgdPermissions';
            var rowids = $(item).getDataIDs();
            var colModel = $(item).getGridParam().colModel;

            var value = val;//$(this).jqGrid('getCell', rowId, colName);

            for (var i = 0; i < rowids.length; i++) {
                if (rowId == rowids[i]) {
                    for (var j = 0; j < colModel.length; j++) {
                        if (colModel[j].name == colName) {
                            // Put cell in editmode.
                            // If the edit (third param) is set to false the cell is just selected and not edited.
                            // If set to true the cell is selected and edited.
                            $(item).editCell(i, j, true);

                            // Let the grid know that the cell has been changed without having to push enter button or click another cell.
                            $(item).saveCell(i, j);
                            //var success = jQuery("#dgdPermissions").jqGrid('setRowData', 1, dataToAdd[0]);
                            $("#dgdPermissions").jqGrid('setCell', rowId, colName, value);

                        }
                    }
                }
            }
        }
        
        function CheckBoxList() {
            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/GetCheckBoxDetails",
                contentType: "application/json; charset=utf-8",
                data: "{roleId: '" + $('#<%=drpRole.ClientID%>').val() + "'}",
                dataType: "json",
                success: AjaxSucceeded,
                error: AjaxFailed
            });
        }

        function AjaxSucceeded(result) {
            if (result.d.length != 0)
            {
                $("#chkboxheader").show();
            }
            else
            {
                $("#chkboxheader").hide();
            }
           $("#divChkBoxListControl").empty();
            BindCheckBoxList(result);
        }
        function AjaxFailed(result) {
            alert('Failed to load checkbox list');
        }
        function BindCheckBoxList(result) {
            var scrNames = new Array();
            var scrIds = new Array();
            for (var i = 0; i < result.d.length; i++) {
                scrNames.push(result.d[i].ScrnName);
                scrIds.push(result.d[i].IdScreen);
            }            
            CreateCheckBoxList(scrNames, scrIds);
        }
             
        function CreateCheckBoxList(scrNames, scrIds) {
            var table = $('<table class="chkgrid"></table>');
            var row = $('<tr></tr>');
            var i = 0;
            for (var i = 0; i < (scrNames.length) ; i+=4) {
                for (var j = i; (j < i + 4 && j<scrNames.length); j++) {
                    
                        row.append(
                            $('<td style="padding:2px"></td>').append($('<input>').attr({
                                type: 'checkbox', name: 'chklistitem', value: scrNames[j], id: scrIds[j]
                            }))
                            .append(
                            $('<label>').attr({
                                for: 'chklistitem' + j
                            }).text(scrNames[j]))
                         );
                    
                }
                table.append(row);
                row = $('<tr></tr>');
            };

            $('#divChkBoxListControl').append(table);
        }

        function loadSubsidiary() {
            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/LoadSubsidiary",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                   
                    $('#<%=drpSubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=drpSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsidiaryID).html(value.SubsidiaryName));
                        
                    });
                   
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadDepartment(subId) {
            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/LoadDepartment",
                data: "{subId: '" + subId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=drpDepartment.ClientID%>').empty(); 
                    $('#<%=drpDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                   
                    $.each(Result, function (key, value) {
                        $('#<%=drpDepartment.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                     
                    });
                   
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadRoles(subId, deptId) {
            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/Fetch_Role",
                data: "{subId: '" + subId + "', deptId:'" + deptId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    debugger;
                    $('#<%=drpRole.ClientID%>').empty();
                    $('#<%=drpRole.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=drpRole.ClientID%>').append($("<option></option>").val(value.Id_Role).html(value.Nm_Role));
                      
                    });
                  
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadStartScreen() {
            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/LoadScreens",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=drpStartScreen.ClientID%>').append($("<option></option>").val(value.IdScreen).html(value.ScrnName));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function addRoleDetails() {
            $('#divEdit').show();
            $('#<%=txtRole.ClientID%>').focus();
            $('#<%=txtRole.ClientID%>').val("");
            $(document.getElementById('<%=hdnRoleId.ClientID%>')).val("");
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("");
            $('#<%=drpStartScreen.ClientID%>')[0].selectedIndex = 0;
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDeleteT.ClientID%>').hide();
          
            var subID = $('#<%=drpSubsidiary.ClientID%>').val();
            var deptID = $('#<%=drpDepartment.ClientID%>').val();
            $("#<%=rbaddadmin.ClientID%>").removeAttr("disabled");
            $("#<%=rbaddsubadmin.ClientID%>").removeAttr("disabled");
            $("#<%=rbadddepadmin.ClientID%>").removeAttr("disabled");
            $("#<%=rbaddadmin.ClientID%>").attr('checked', false);
            $("#<%=rbaddsubadmin.ClientID%>").attr('checked', false);
            $("#<%=rbadddepadmin.ClientID%>").attr('checked', false);
            if (subID =="0" && deptID =="0")
            {
                $("#<%=rbaddadmin.ClientID%>").attr('checked', true);
                $("#<%=rbaddadmin.ClientID%>").removeAttr("disabled");
                $("#<%=rbaddsubadmin.ClientID%>").attr('disabled', 'disabled');
                $("#<%=rbadddepadmin.ClientID%>").attr('disabled', 'disabled');
            }
            else if (subID !="0" && deptID =="0")
            {
                $("#<%=rbaddsubadmin.ClientID%>").attr('checked', true);
                $("#<%=rbaddsubadmin.ClientID%>").removeAttr("disabled");
                $("#<%=rbaddadmin.ClientID%>").attr('disabled', 'disabled');
                $("#<%=rbadddepadmin.ClientID%>").attr('disabled', 'disabled');
            }
            else
                {
                $("#<%=rbadddepadmin.ClientID%>").attr('checked', true);
                $("#<%=rbadddepadmin.ClientID%>").removeAttr("disabled");
                $("#<%=rbaddadmin.ClientID%>").attr('disabled', 'disabled');
                $("#<%=rbaddsubadmin.ClientID%>").attr('disabled', 'disabled');
                }
        }

        function SaveRole() {
            var result = fnClientValidate();
            if (result == true) {
                var roleId = document.getElementById('<%=hdnRoleId.ClientID%>').value;
                $.ajax({
                    type: "POST",
                    url: "frmCFRoles.aspx/SaveRoleDetails",
                    data: "{roleId: '" + roleId + "',roleNm: '" + $('#<%=txtRole.ClientID%>').val() + "', subId:'" + $('#<%=drpSubsidiary.ClientID%>').val() + "', deptId:'" + $('#<%=drpDepartment.ClientID%>').val() + "', startScrRoleId:'" + $('#<%=drpStartScreen.ClientID%>').val() + "', flgSysAdmin:'" + $('#<%=rbaddadmin.ClientID%>')[0].checked + "', flgSubAdmin:'" + $('#<%=rbaddsubadmin.ClientID%>')[0].checked + "', flgDeptAdmin:'" + $('#<%=rbadddepadmin.ClientID%>')[0].checked + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                       if (Result.d == "NOSCREEN") {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('NOSCREENPERMISSION', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (Result.d == "EXITS") {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (Result.d == "OK") {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }

                        $('#divEdit').hide();
                        $('#<%=btnAddT.ClientID%>').show();
                        $('#<%=btnDeleteT.ClientID%>').show();
                        loadRolesGrid($('#<%=drpSubsidiary.ClientID%>').val(), $('#<%=drpDepartment.ClientID%>').val());

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }
        }
        function AddScRole() {
            addChkboxItem();
            var xml = hdnXML;
            if(xml != "")
            {
                jQuery("#dgdPermissions").jqGrid('clearGridData');
            }
            var roleId = $('#<%=drpRole.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            if (hdnXML != "")
            {
                $.ajax({
                                type: "POST",
                                url: "frmCFRoles.aspx/AddScRoleDetails",
                                data: "{scrXml: '" + xml + "',roleId:'" + roleId + "'}",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: false,
                                success: function (data) {
                                    for (var i = 0; i < data.d.length; i++) {
                                        mydataPer = data;
                                        jQuery("#dgdPermissions").jqGrid('addRowData', i + 1, mydataPer.d[i]);
                                    }
                                },
                                failure: function () {
                                    alert("Failed!");
                                }
                            });
                jQuery("#dgdPermissions").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            }            
        }
       
        function FinalSaveRole() {
            var StrIntXML="";
            var StrIntXMLs = "";
            var roleId = $('#<%=drpRole.ClientID%>').val();
            var rowData = $('#dgdPermissions').jqGrid('getGridParam', 'data');
            var rowDatas = $('#dgdCtlPermissions').jqGrid('getGridParam', 'data');
            for (var i = 0; i < rowData.length; i++) {
                var row = rowData[i];
                var scrId = row.IdScreen;
                var accred = row.Flg_Acc_Read;
                var accadd = row.Flg_Acc_Create;
                var accewr = row.Flg_Acc_Write;
                var accprint = row.Flg_Acc_Print;
                var accdel = row.Flg_Acc_Delete;
                var conId = "-1";
                if(accred == true)
                {
                    StrIntXML = "<ROLE><IDR>" + roleId + "</IDR>" + "<S>" + scrId + "</S>" + "<T>" + conId + "</T>" + "<R>" + accred + "</R>" + "<W>" + accewr + "</W>" + "<C>" + accadd + "</C>" + "<P>" + accprint + "</P>" + "<D>" + accdel + "</D></ROLE>";
                    StrIntXMLs += StrIntXML;
                }
            };
                     
            for (var i = 0; i < rowDatas.length; i++) {
                var rows = rowDatas[i];
                var scrId = "-1";
                var accred = false;
                var accadd = false;
                var accewr = rows.Flg_Acc;
                var accprint = false;
                var accdel = false;
                var conId = rows.IdConUtil
              
                    StrIntXML = "<ROLE><IDR>" + roleId + "</IDR>" + "<S>" + scrId + "</S>" + "<T>" + conId + "</T>" + "<R>" + accred + "</R>" + "<W>" + accewr + "</W>" + "<C>" + accadd + "</C>" + "<P>" + accprint + "</P>" + "<D>" + accdel + "</D></ROLE>";
                    StrIntXMLs += StrIntXML;
             };
            if (StrIntXMLs != "") {
                StrIntXMLs = "<ROOT>" + StrIntXMLs + "</ROOT>";
                hdnSaveXml = StrIntXMLs;
            }

            $.ajax({
                type: "POST",
                url: "frmCFRoles.aspx/FinalSaveRole",
                data: "{roleXml: '" + hdnSaveXml + "', roleId:'" + roleId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                    $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function CanceScrlRole() {
            removeChkboxItem();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdPermissions").jqGrid('clearGridData');
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCFRoles.aspx/RoleChange",
                data: "{roleId: '" + $('#<%=drpRole.ClientID%>').val() + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    for (var i = 0; i < data.d.length; i++) {
                        mydataPer = data;
                        jQuery("#dgdPermissions").jqGrid('addRowData', i + 1, mydataPer.d[i]);
                    }
                },
                error: function (result) {
                    alert("Error");
                }
            });
            jQuery("#dgdPermissions").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdPermissions").jqGrid("hideCol", "subgrid");
    
        }
        function ResetAll()
        {
            location.reload();
        }
        function delRoles() {
            var roleId = "";
            $('#dgdRoles input:checkbox[class=cbox]').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    roleId = $('#dgdRoles tr ')[row].cells[1].innerHTML.toString();
                }
            });

            if (roleId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delRl();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function delRl() {
            var row;
            var roleId;
            var roleName;
            var roleIdxml;
            var roleIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdRoles input:checkbox[class=cbox]').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    roleId = $('#dgdRoles tr ')[row].cells[1].innerHTML.toString();
                    roleName = $('#dgdRoles tr ')[row].cells[3].innerHTML.toString();
                    roleIdxml = "<ROLE><ID_ROLE>" + roleId + "</ID_ROLE>" + "<NM_ROLE>" + roleName + "</NM_ROLE></ROLE>";
                    roleIdxmls += roleIdxml;
                }
            });

            if (roleIdxmls != "") {
                roleIdxmls = "<ROOT>" + roleIdxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCFRoles.aspx/DeleteRole",
                    data: "{roleIdxmls: '" + roleIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdRoles").jqGrid('clearGridData');
                        jQuery("#dgdRoles").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divEdit').hide();
                        $('#divGrids').hide();
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0] == "DEL")
                        {
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d[0] == "NDEL")
                        {
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                       
                        loadRolesGrid($('#<%=drpSubsidiary.ClientID%>').val(), $('#<%=drpDepartment.ClientID%>').val());
                        var subId = $('#<%=drpSubsidiary.ClientID%>').val();
                        var deptId = $('#<%=drpDepartment.ClientID%>').val();
                        loadRoles(subId, deptId);
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

        function CancelRole() {
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("");
            $('#divEdit').hide();
            $('#<%=btnAddT.ClientID%>').show();
            $('#<%=btnDeleteT.ClientID%>').show();
            
        }

        function getRolesGridHeaders() {
            $('#dgdRoles').jqGrid("setLabel", "Nm_Role", $('#<%=lblRole.ClientID%>')[0].innerText);
            $('#dgdRoles').jqGrid("setLabel", "Flg_Sysadmin", $('#<%=hdnFlgAdmin.ClientID%>')[0].value);
            $('#dgdRoles').jqGrid("setLabel", "Flg_Subsidadmin", $('#<%=hdnFlgSubAdmin.ClientID%>')[0].value);
            $('#dgdRoles').jqGrid("setLabel", "Flg_Deptadmin", $('#<%=hdnFlgDeptAdmin.ClientID%>')[0].value);
            
        }

        function getPermissionGridHeaders() {
            $('#dgdPermissions').jqGrid("setLabel", "ScrnName", $('#<%=hdnScrnName.ClientID%>')[0].value);
            $('#dgdPermissions').jqGrid("setLabel", "Flg_Acc_Read", $('#<%=hdnView.ClientID%>')[0].value);
            $('#dgdPermissions').jqGrid("setLabel", "Flg_Acc_Write", $('#<%=btnAddT.ClientID%>')[0].value);
            $('#dgdPermissions').jqGrid("setLabel", "Flg_Acc_Create", $('#<%=hdnEditCap.ClientID%>')[0].value);
            $('#dgdPermissions').jqGrid("setLabel", "Flg_Acc_Print", $('#<%=hdnPrint.ClientID%>')[0].value);
            $('#dgdPermissions').jqGrid("setLabel", "Flg_Acc_Delete", $('#<%=btnDeleteT.ClientID%>')[0].value);

        }
        function getctrlPermissionGridHeaders() {
            $('#dgdCtlPermissions').jqGrid("setLabel", "CtrlName", $('#<%=hdnCtrlName.ClientID%>')[0].value);
            $('#dgdCtlPermissions').jqGrid("setLabel", "Flg_Acc", $('#<%=hdnHasAcc.ClientID%>')[0].value);
         

        }
        function fnClientValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtRole.ClientID%>'), '0130', ''))) {
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtRole.ClientID%>'), '0130'))) {
                return false;
            }
            return true;
        }

    </script>
 
   
     <style>
        .chkgrid
        {
            font-family:Verdana,Arial,sans-serif;
            font-size:9px;
        }
         .ui.form .field > label {
             display:inline;
         }
    </style>
 <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblRoleHeader" runat="server" Text="Roles"></asp:Label>
     <asp:HiddenField ID="hdnMode" runat="server" />
     <asp:HiddenField ID="hdnRoleId" runat="server" />
      <asp:HiddenField ID="hdnXML" runat="server" />
     <asp:HiddenField ID="hdnSaveXml" runat="server" />
     <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnPageSize" runat="server" />
     <asp:HiddenField ID="hdnFlgAdmin" runat="server" Value="Admin" />
     <asp:HiddenField ID="hdnFlgSubAdmin" runat="server" Value="Subsidiary Admin" />
     <asp:HiddenField ID="hdnFlgDeptAdmin" runat="server" Value=" Department Admin" />
     <asp:HiddenField ID="hdnScrnName" runat="server" Value="ScreenName" />
     <asp:HiddenField ID="hdnView" runat="server" Value="View" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField ID="hdnPrint" runat="server" Value="Print" />
     <asp:HiddenField ID="hdnCtrlName" runat="server" Value="Control Name" />
     <asp:HiddenField ID="hdnHasAcc" runat="server" Value="Has Access" />
     <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
 </div>
    <div id="divRoleDetails" class="ui raised segment signup inactive">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="header" runat="server" class="active item">Roles</a>  
            </div>
            <div class="ui form" style="width:100%">
                <div class="two fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label id="lblSubsId" runat="server" Text="Subsidiary ID"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:250px">
                         <asp:DropDownList ID="drpSubsidiary" runat="server" CssClass="drpdwm" Width="244px"></asp:DropDownList>
                    </div>
                </div>
                <div class="two fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label id="lblDeptId" runat="server" Text="Department ID"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:250px">
                         <asp:DropDownList ID="drpDepartment" runat="server" CssClass="drpdwm" Width="244px"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div>
                <table id="dgdRoles"></table>
                <div id="pager1" ></div>
            </div>
        <div style="text-align:center">
                <input id="btnAddT" runat="server" type="button" value="Add" class="ui button" onclick="addRoleDetails()"/>
                <input id="btnDeleteT" runat="server" type="button" value="Delete" class="ui button" onclick ="delRoles()" />
        </div>
         <div class="ui form" style="width:100%">

         <div id="divEdit">
         <div id="divEdit1" class="six fields">
             <div class="field" style="padding:15px">
                  <asp:Label id="lblRole" runat="server" Text="Role"></asp:Label><span class="mand">*</span>
              </div>
             <div class="field" style="padding:15px">
                  <asp:TextBox ID="txtRole" runat="server" CssClass="inp" MaxLength="20" Width="174px"></asp:TextBox>
             </div>
              <div class="field" style="padding:15px">
                  <asp:Label id="lblStartScreen" runat="server" Text="Start Screen"></asp:Label>
              </div>
              <div class="field" style="width:400px;padding:15px">
                   <asp:DropDownList ID="drpStartScreen" runat="server" CssClass="drpdwm"></asp:DropDownList>
               </div>
             </div>
             <div id="divEdit2" class="Six fields">
                <div class="field" style="width:100px;">
                      <asp:RadioButton ID="rbaddadmin" runat="server" Text="Admin" style="padding-right:20px;"   />
                 </div>
                <div class="field" style="width:157px">
                      <asp:RadioButton ID="rbaddsubadmin" runat="server" Text="Subsidiary Admin"/>
                  </div>
                   <div class="field" style="width:230px">
                      <asp:RadioButton ID="rbadddepadmin" runat="server" Text="Department Admin"/>
              </div>
             </div>
             <div id="divEdit3" class="Six fields">
                 <input id="btnRolesAdd" runat="server" type="button" value="Save" class="ui button" onclick="SaveRole()" />
                 <input id="btnRolesAddCancel" runat="server" type="button" value="Cancel" class="ui button" onclick="CancelRole()" />
                 
             </div>
         
</div>
      </div>
     
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="aAccessRt" runat="server" class="active item">Access Rights</a>  
            </div>
        <div class="ui form" style="width:100%">
                <div class="two fields">
                    <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label id="lblRoles" runat="server" Text="Roles"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:250px">
                         <asp:DropDownList ID="drpRole" runat="server" CssClass="drpdwm" Width="244px"></asp:DropDownList>
                    </div>
                </div>
          </div>
           <div id="divGrids">
           <div>
                <table id="dgdPermissions"></table>
                <div id="pager" ></div>
            </div>
        <div id="chkboxheader"  style="font-family:Verdana,Arial,sans-serif;font-size:11px;font-weight:bold">
             <asp:CheckBox ID="ChkallList" runat="server" Text="All Screens" Width="140px" />
        </div>
        <div id="divChkBoxListControl">
         </div>
             <div style="text-align:center">
                <input id="btnAddScRole" runat="server" type="button" value="Add" class="ui button" onclick="AddScRole()" />
                <input id="btnCanscrRole" runat="server" type="button" value="Cancel" class="ui button" onclick ="CanceScrlRole()" />
          </div>
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a id="aCtrlRt" runat="server" class="active item">Control Rights</a>  
            </div>
            <div>
                <table id="dgdCtlPermissions"></table>
                <div id="pager2" ></div>
            </div>
        <div style="text-align:center">
                <input id="btnSave" runat="server" type="button" value="Save" class="ui button" onclick="FinalSaveRole()" />
                <input id="btnReset" runat="server" type="button" value="Reset" class="ui button" onclick="ResetAll()" />
          </div>
        </div>
    </div>
</asp:Content>