<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Config_DeptWarehouseConn.aspx.vb" Inherits="CARS.Config_DeptWarehouseConn" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
        <script type="text/javascript">
            var arr = new Array();
     $(document).ready(function () {
         loadConfigDeptWarehouseGrid();
         LoadDepartment();
         $('#divConnWHDetails').hide();

     });//end of ready


     function loadConfigDeptWarehouseGrid() {
         var grid = $("#dgdDeptWarehouse");
         var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
         var mydata;
         grid.jqGrid({
             datatype: "local",
             data: mydata,
             colNames: ['Department Code', 'Department Name', 'connected warehouses',''],
             colModel: [
                      { name: 'DepartmentId', index: 'DepartmentId', width: 160, sorttype: "string" },
                      { name: 'DepartmentName', index: 'DepartmentName', width: 190, sorttype: "string" },
                      { name: 'ConnWarehouses', index: 'ConnWarehouses', width: 250, sorttype: "string" },
                      { name: 'DepartmentId', index: 'DepartmentId', width: 60, sorttype: "string", formatter: editConDeptWh },
             ],
             multiselect: true,
             pager: jQuery('#pagerDeptWarehouse'),
             rowNum: pageSize,//can fetch from webconfig
             rowList: 5,
             sortorder: 'asc',
             viewrecords: true,
             height: "50%",
             autoWidth: true,
             shrinkToFit: true,
             caption: "",
             async: false, //Very important,
             subgrid: false

         });

         $.ajax({
             type: "POST",
             contentType: "application/json; charset=utf-8",
             url: "Config_DeptWarehouseConn.aspx/LoadGridDetails",
             data: '{}',
             dataType: "json",
             async: false,//Very important
             success: function (data) {
                 for (i = 0; i < data.d.length; i++) {
                     mydata = data;
                     jQuery("#dgdDeptWarehouse").jqGrid('addRowData', i + 1, mydata.d[i]);
                 }
             }
         });

         // jQuery("#dgdImportList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         $("#dgdDeptWarehouse").jqGrid("hideCol", "subgrid");
     }

            function editConDeptWh(cellvalue, options, rowObject) {
                var deptId = rowObject.DepartmentId.toString();
                var strOptions = cellvalue;
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");

                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edtDepartment(" + "'" + deptId + "'" + "); />";
                return edit;
            }

            function edtDepartment(deptId) {
                $('#divConnWHDetails').show();
                $("#dvCheckBoxListControl").empty();
                $('#<%=hdnDeptId.ClientID%>').val(deptId);
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_DeptWarehouseConn.aspx/EditConnDeptWarehouse",
                    data: "{deptId: '" + deptId + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        if (data.d.length > 0) {
                            $('#<%=hdnDefaultWh.ClientID%>').val(data.d[0][0].IsDefault);
                            $('#<%=hdnWhName.ClientID%>').val(data.d[0][0].WareHouseValue);
                            if (data.d[0][0].DepartmentId == "") {
                                $('#<%=ddlDepartment.ClientID%>')[0].selectedIndex = 0;
                            }
                            else {
                                $('#<%=ddlDepartment.ClientID%>').val(data.d[0][0].DepartmentId);
                            }
                            for (var i = 1; i < data.d[1].length; i++) {
                                arr.push(data.d[1][i].WareHouseValue);
                            }
                            BindChkboxList();
                        }

                    }
                });
            }


     function BindChkboxList() {
         $.ajax({
             type: "POST",
             url: "Config_DeptWarehouseConn.aspx/LoadChkboxList",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: AjaxSucceeded,
             error: AjaxFailed
         });
     }

            function AjaxSucceeded(result) {
                BindCheckBoxList(result);
            }
            function AjaxFailed(result) {
                alert('Failed to load checkbox list');
            }
            function BindCheckBoxList(result) {
                var whNames = new Array();
                var whIds = new Array();
                for (var i = 0; i < result.d.length; i++) {
                    whNames.push(result.d[i].WareHouseValue);
                    whIds.push(result.d[i].WareHouseId);
                }
                CreateCheckBoxList(whNames, whIds);
            }
            function CreateCheckBoxList(checkboxlistItems, whIds) {
                var whName = $('#<%=hdnWhName.ClientID%>').val();
                var table = $('<table></table>');
                var row = $('<tr></tr>');
                var counter = 0;
                // $(checkboxlistItems).each(function () {

                if (arr.length != checkboxlistItems.length) {
                    for (var i = 0; i < (checkboxlistItems.length) ; i++) {
                        var warehouseId = whIds[i];
                        if (arr[i] == checkboxlistItems[i])
                        {
                             row.append(($('<td style="padding:2px;width:120px"></td>').append($('<input>').attr({
                                 type: 'checkbox', name: 'chklistitem', checked: 'checked', value: warehouseId, id: i
                             })).append(
                            $('<label>').attr({
                                for: 'chklistitem' + counter++
                            }).text(checkboxlistItems[i]))));
                        }
                        else {
                            row.append(($('<td style="padding:2px;width:120px"></td>').append($('<input>').attr({
                                type: 'checkbox', name: 'chklistitem',  value: warehouseId, id: i
                            })).append(
                             $('<label>').attr({
                             for: 'chklistitem' + counter++
                             }).text(checkboxlistItems[i]))));
                        }
                        

                        if (checkboxlistItems[i] == whName) {
                            row.append(($('<td style="padding:2px"></td>').append($('<input>').attr({
                                type: 'radio', name: 'rdpbtnWarehouse', checked: 'checked', value: this.Value, id: i
                            })).append(
                              $('<label>').attr({
                                  for: 'City' + counter++
                              }).text('Default'))));
                        }
                        else {
                            row.append(($('<td style="padding:2px"></td>').append($('<input>').attr({
                                type: 'radio', name: 'rdpbtnWarehouse', value: this.Value, id: i
                            })).append(
                             $('<label>').attr({
                                 for: 'City' + counter++
                             }).text('Default'))));
                        }

                        table.append(row);
                        row = $('<tr></tr>');
                    }
                }

                $('#dvCheckBoxListControl').append(table);
               


            }

            function LoadDepartment() {
                $.ajax({
                    type: "POST",
                    url: "Config_DeptWarehouseConn.aspx/LoadDepartment",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=ddlDepartment.ClientID%>').append($("<option></option>").val(value.DepartmentId).html(value.DepartmentName));
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function save_ConnDeptWarehouse() {
                var strDeptWh = "";
                $('#dvCheckBoxListControl input:checkbox[name=chklistitem]').attr("checked", function () {
                    if (this.checked) {
                        whId = this.value;
                        var chkid = this.id; //0
                        rbid = $('#dvCheckBoxListControl input:radio:checked ')[0].id;
                        if (chkid == rbid) {
                            strDeptWh = strDeptWh + whId +'|'+ 'True~'

                        } else {
                            strDeptWh = strDeptWh + whId + '|' + 'False~'
                        }

                    }

                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_DeptWarehouseConn.aspx/SaveDeptWarehouse",
                    data: "{DepartmentId: '" + $('#<%=ddlDepartment.ClientID%>').val() + "',WarehouseValue: '" + strDeptWh + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                           $('#<%=RTlblError.ClientID%>').text(data.d);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                           jQuery("#dgdDeptWarehouse").jqGrid('clearGridData');
                            loadConfigDeptWarehouseGrid();
                            $('#divConnWHDetails').hide();
                 

                       
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });

            }

            function resetDeptWHDet() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divConnWHDetails').hide();
                    $(document.getElementById('<%=hdnMode.ClientID%>')).val("")
                }

            }

    </script>
    <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Connected Warehouses"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" /> 
        <asp:HiddenField id="hdnDeptId" runat="server" /> 
        <asp:HiddenField id="hdnWhName" runat="server" /> 
        <asp:HiddenField id="hdnDefaultWh" runat="server" /> 
</div>
     <div id="divCfWHDetails" class="ui raised segment signup inactive">
          <div>
             <table id="dgdDeptWarehouse"></table>
              <div id="pagerDeptWarehouse"></div>
         </div>
        <div id="divConnWHDetails" class="ui raised segment signup inactive">
          <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
               <a id="A3" runat="server" class="active item">Edit Department Warehouse Connection  </a>  
         </div> 
         <div style="padding:0.5em"></div>
          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lbldept" runat="server" Text="Department" Width="180px"></asp:Label>
              <asp:DropDownList ID="ddlDepartment" runat="server" Width="160px"></asp:DropDownList>                
         </div>
    </div>
          <div style="padding:0.5em"></div>
          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblDeptHeader" runat="server" Text="Select connected warehouse from the list below:" Width="300px" ></asp:Label>
         </div>
         </div>
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A1" runat="server" class="active item">Warehouses </a>  
         </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;">
          <div id="dvCheckBoxListControl"></div>
            <div id="dvradioButtonListControl"></div>
         </div>
    <div style="padding:0.5em"></div>
         <div style="text-align:center">
                <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" onclick="save_ConnDeptWarehouse()"   />
                 <input id="btnCancel" runat="server" class="ui button" value="Cancel" type="button" onclick="resetDeptWHDet()" />
            </div>
        </div>
    </div>
</asp:Content>