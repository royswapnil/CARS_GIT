<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Config_Warehouse.aspx.vb" Inherits="CARS.Config_Warehouse" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            loadConfigWarehouseGrid();
            FillSubsidiary();
        $('#divDeptDetails').hide();

        $('#<%=txtZipCode.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "../Master/frmCfUserdetail.aspx/GetZipCodes",
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


        });//end of ready


        
        function loadConfigWarehouseGrid() {
            var grid = $("#dgdWarehouse");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mydata;
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['WhId', 'Warehouse Name', 'Warehouse Manager Name', 'Location','Subsidiary Name',''],
                colModel: [
                         { name: 'WarehouseID', index: 'WarehouseID', width: 60, sorttype: "string" },
                         { name: 'WarehouseName', index: 'WarehouseName', width: 90, sorttype: "string" },
                         { name: 'WarehouseManagerName', index: 'WarehouseManagerName', width: 200, sorttype: "string" },
                         { name: 'WarehouseLocation', index: 'WarehouseLocation', width: 200, sorttype: "string" },
                         { name: 'WareHouseSubsideryName', index: 'WareHouseSubsideryName', width: 200, sortable: false },
                         { name: 'WarehouseID', index: 'WarehouseID', width: 60, sorttype: "string", formatter: editConfigWh },
                ],
                multiselect: true,
                pager: jQuery('#pagerImportList'),
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
                url: "Config_Warehouse.aspx/LoadWarehouseDetails",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdWarehouse").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            // jQuery("#dgdImportList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdWarehouse").jqGrid("hideCol", "subgrid");
        }

        function editConfigWh(cellvalue, options, rowObject) {
            var whID = rowObject.WarehouseID.toString();
            var strOptions = cellvalue;
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");

            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edtWarehouse(" + "'" + whID + "'" + "); />";
            return edit;
        }

        function edtWarehouse(whId) {
            $('#divDeptDetails').show();
             $('#<%=hdnWhId.ClientID%>').val(whId);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Config_Warehouse.aspx/EditLoadWarehouse",
                data: "{whId: '" + whId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtWHName.ClientID%>').val(data.d[0].WarehouseName);
                        $('#<%=txtWHMGRName.ClientID%>').val(data.d[0].WarehouseManagerName);
                        $('#<%=txtLoc.ClientID%>').val(data.d[0].WarehouseLocation);
                        $('#<%=txtPhoneno.ClientID%>').val(data.d[0].WarehousePhone);
                        $('#<%=txtMobileNo.ClientID%>').val(data.d[0].WarehousePhoneMobile);
                        $('#<%=txtAddrline1.ClientID%>').val(data.d[0].WarehouseAddress1);
                        $('#<%=txtAddrline2.ClientID%>').val(data.d[0].WarehouseAddress2);
                        $('#<%=txtZipcode.ClientID%>').val(data.d[0].WarehouseZipcode);
                        if (data.d[0].WareHouseSubsideryName == "") {
                            $('#<%=ddlSubsidiaryName.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                           // $('#<%=ddlSubsidiaryName.ClientID%>').val(data.d[0].SubsideryId);
                            $('#<%=ddlSubsidiaryName.ClientID%> option:contains("' + data.d[0].WareHouseSubsideryName + '")').attr('selected', 'selected');
                        }
                    }
                   
                }
            });
        }

        function FillSubsidiary() {
            $.ajax({
                type: "POST",
                url: "Config_Warehouse.aspx/LoadSubsidiary",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                     $('#<%=ddlSubsidiaryName.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlSubsidiaryName.ClientID%>').append($("<option></option>").val(value.WarehouseIDSubsidery).html(value.WareHouseSubsideryName));
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }


        function addWhDetails() {
            $('#<%=txtAddrline1.ClientID%>').val("");
            $('#<%=txtAddrline2.ClientID%>').val("");
            $('#<%=txtCity.ClientID%>').val("");
            $('#<%=txtCountry.ClientID%>').val("");
            $('#<%=txtState.ClientID%>').val("");
            $('#<%=txtLoc.ClientID%>').val("");
            $('#<%=txtMobileNo.ClientID%>').val("");
            $('#<%=txtPhoneno.ClientID%>').val("");
            $('#<%=txtWHMGRName.ClientID%>').val("");
            $('#<%=txtWHName.ClientID%>').val("");
            $('#<%=txtZipcode.ClientID%>').val("");
            $('#<%=ddlSubsidiaryName.ClientID%>')[0].selectedIndex = 0;
            $('#divDeptDetails').show();
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add")
           
        }

        function save_ConfigWarehouse() {
        var mode = $('#<%=hdnMode.ClientID%>').val();
        if (mode == "Edit")
        {
         warehouseId = $('#<%=hdnWhId.ClientID%>').val();
        }
        else 
        {
          warehouseId = "";
        }
                 $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_Warehouse.aspx/SaveWarehouse",
                    data: "{WarehouseID: '" + warehouseId + "',WarehouseName: '" + $('#<%=txtWHName.ClientID%>').val() + "', WarehouseManagerName:'" + $('#<%=txtWHMGRName.ClientID%>').val() + "', WarehouseLocation:'" + $('#<%=txtLoc.ClientID%>').val() + "', WarehousePhone:'" + $('#<%=txtPhoneno.ClientID%>').val() + "', WarehousePhoneMobile:'" + $('#<%=txtMobileNo.ClientID%>').val() + 
                        "',WarehouseZipcode: '" + $('#<%=txtZipcode.ClientID%>').val() + "',WarehouseCountry: '" + $('#<%=txtCountry.ClientID%>').val() + "',WarehouseCity: '" + $('#<%=txtCity.ClientID%>').val() + "',WarehouseState: '" + $('#<%=txtState.ClientID%>').val() + "',WarehouseAddress1: '" + $('#<%=txtAddrline1.ClientID%>').val() + "' ,WarehouseAddress2: '" + $('#<%=txtAddrline2.ClientID%>').val() + "',WarehouseIDSubsidery: '" + $('#<%=ddlSubsidiaryName.ClientID%>').val() + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                        var strResult = data.d.split(';');
                        if (strResult[0] == "True")
                        {
                           $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             jQuery("#dgdWarehouse").jqGrid('clearGridData');
                            loadConfigWarehouseGrid();
                            $('#divDeptDetails').hide();
                        }
                        
                        else  {
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

        function resetWHDet() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divDeptDetails').hide();
            }

        }


        function delWarehouse() {
            var whId = "";
            $('#dgdWarehouse input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    whId = $('#dgdWarehouse tr ')[row].cells[2].innerHTML.toString();
                }
            });

            if (whId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delWH();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }
        
        function delWH() {
            var row;
            var whId;
            var whName;
            var whIdxml;
            var whIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var resultmsg = "";
            $('#dgdWarehouse input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    whId = $('#dgdWarehouse tr ')[row].cells[2].innerHTML.toString();
                    $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_Warehouse.aspx/DeleteWarehouse",
                    data: "{whId: '" + whId + "'}",
                    dataType: "json",
                    success: function (data) {
                        var result = data.d;
                        result = whId + '' + result;
                        resultmsg += result
                         $('#<%=RTlblError.ClientID%>').text(resultmsg);
                        jQuery("#dgdWarehouse").jqGrid('clearGridData');
                        $('#divDeptDetails').hide();
                        loadConfigWarehouseGrid();
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }

        });

    }
       
    </script>
    <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Warehouse Configuration"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" /> 
        <asp:HiddenField id="hdnWhId" runat="server" /> 
</div>
     <div id="divCfWHDetails" class="ui raised segment signup inactive">
         <div class="six fields">
             <div style="text-align:center">
                <input id="btnAddTop" runat="server" class="ui button"  value="Add" type="button" onclick="addWhDetails()"  />
                 <input id="btndeleteTop" runat="server" class="ui button" value="Delete" type="button" onclick="delWarehouse()" />
            </div>
         </div>
          <div style="padding:0.5em"></div>
          <div>
             <table id="dgdWarehouse"></table>
                <div id="pagerWarehouse"></div>
         </div>
         <div style="padding:0.5em"></div>
          <div class="six fields">
             <div style="text-align:center">
                <input id="btnAddBtm" runat="server" class="ui button"  value="Add" type="button" onclick="addWhDetails()"  />
                 <input id="btnDeleteBtm" runat="server" class="ui button" value="Delete" type="button" onclick="delWarehouse()"/>
            </div>
         </div>
 <div id="divDeptDetails" class="ui raised segment signup inactive">
         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A3" runat="server" class="active item">Add/Edit Warehouse Configuration </a>  
         </div> 
          <div style="padding:0.5em"></div>

          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblWareHouseName" runat="server" Text="Warehouse Name" Width="180px"></asp:Label>
              <asp:TextBox ID="txtWHName" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblWHMGRName" runat="server" Text="Warehouse Manager Name" Width="180px" ></asp:Label>
             <asp:TextBox ID="txtWHMGRName" runat="server" Width="200px"></asp:TextBox> 
         </div>
    </div>
      <div style="padding:0.5em"></div>
          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblLoc" runat="server" Text="Location" Width="180px"></asp:Label>
              <asp:TextBox ID="txtLoc" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblSubsidiaryName" runat="server" Text="Subsidiary Name" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlSubsidiaryName" runat="server" Width="160px"></asp:DropDownList>
         </div>
    </div>
   <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A1" runat="server" class="active item">Contact Information</a>  
   </div> 
   <div style="padding:0.5em"></div>
    <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblPhone" runat="server" Text="Phone No." Width="180px"></asp:Label>
              <asp:TextBox ID="txtPhoneno" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblMobile" runat="server" Text="Mobile No." Width="180px" ></asp:Label>
             <asp:TextBox ID="txtMobileNo" runat="server" Width="200px"></asp:TextBox> 
         </div>
</div>
 <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A2" runat="server" class="active item">Address </a>  
   </div> 
   <div style="padding:0.5em"></div>
    <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblAddline1" runat="server" Text="Address Line1" Width="180px"></asp:Label>
              <asp:TextBox ID="txtAddrline1" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblAddline2" runat="server" Text="Address Line2" Width="180px" ></asp:Label>
             <asp:TextBox ID="txtAddrline2" runat="server" Width="200px"></asp:TextBox> 
         </div>
    </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblZipcode" runat="server" Text="Zip Code" Width="180px"></asp:Label>
              <asp:TextBox ID="txtZipcode" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblCity" runat="server" Text="City" Width="180px" ></asp:Label>
             <asp:TextBox ID="txtCity" runat="server" Width="200px"></asp:TextBox> 
         </div>
    </div>
        <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblCountry" runat="server" Text="Country" Width="180px"></asp:Label>
              <asp:TextBox ID="txtCountry" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblState" runat="server" Text="State" Width="180px" ></asp:Label>
             <asp:TextBox ID="txtState" runat="server" Width="200px"></asp:TextBox> 
         </div>
    </div>
        <div style="padding:0.5em"></div>
         <div style="text-align:center">
                <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" onclick="save_ConfigWarehouse()"   />
                 <input id="btnCancel" runat="server" class="ui button" value="Cancel" type="button" onclick="resetWHDet()" />
            </div>
     </div>
</div>
</asp:Content>