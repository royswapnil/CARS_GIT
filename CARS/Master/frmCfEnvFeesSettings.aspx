<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfEnvFeesSettings.aspx.vb" Inherits="CARS.frmCfEnvFeesSettings" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    <script type="text/javascript">

        $(document).ready(function () {

            $('#divEnvFeeSettings').hide();
            $('#divSrchEnvFeeSettings').hide();

            var grid = $("#dgdEnvFeeSettings");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            //Invoice Email Config
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['SL No', 'Warehouse', 'SparePartId', 'MinAmt', 'MaxAmt', 'AddedPer','VATCode','Name','IdMake', ''],
                colModel: [
                         { name: 'SLNO', index: 'SLNO', width: 50, sorttype: "string" },
                         { name: 'ENV_ID_WAREHOUSE', index: 'ENV_ID_WAREHOUSE', width: 50, sorttype: "string" },
                         { name: 'ID_ITEM', index: 'Id_Item', width: 250, sorttype: "string" },
                         { name: 'MIN_AMT', index: 'Min_Amt', width: 100, sorttype: "string" },
                         { name: 'MAX_AMT', index: 'Max_Amt', width: 100, sorttype: "string" },
                         { name: 'ADDED_FEE_PERC', index: 'ADDED_FEE_PERC', width: 100, sorttype: "string" },
                         { name: 'ENV_VATCODE', index: 'ENV_VATCODE', width: 100, sorttype: "string" },
                         { name: 'ENV_NAME', index: 'ENV_NAME', width: 250, sorttype: "string" },
                         { name: 'ENV_ID_MAKE', index: 'ENV_ID_MAKE', width: 100, sorttype: "string",hidden:true },
                         { name: 'SLNO', index: 'SLNO', sortable: false, formatter: editEnvFeeSettings }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Environmental Fee Settings",
                async: false, //Very important,
                subgrid: false

            });

            //  loadEnvFeeSettings();
            loadWarehouse();
            loadVATCode();

            var imake, iid, iwh;
            $('#<%=txtSparePartId.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfEnvFeesSettings.aspx/SparePart_Search",
                        data: "{q:'" + $('#<%=txtSparePartId.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtSparePartId.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    imake = item.ID_MAKE;
                                    iid = item.ID_ITEM;
                                    iwh = '1';
                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " " + item.ITEM_DESC + " " + item.LOCATION,
                                        val: item.ID_ITEM,
                                        value: item.ID_ITEM,
                                        idmake: item.ID_MAKE,
                                        idwh: item.ID_WH_ITEM,
                                        envidmake: item.ENV_ID_MAKE
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $('#<%=txtSparePartId.ClientID%>').val(i.item.val);
                    $('#<%=txtMake.ClientID%>').val(i.item.envidmake);
                    $('#<%=txtWarehouse.ClientID%>').val(i.item.idwh);
                    $('#<%=txtSparePartId.ClientID%>').focus();
                }
            });


            function editEnvFeeSettings(cellvalue, options, rowObject) {
                var lineId = rowObject.SLNO.toString();
                
                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editEnvFeeSettings(" + "'" + lineId + "'" + "); />";
                return edit;
            }            

        }); // end of ready

        function loadVATCode() {
            $.ajax({
                type: "POST",
                url: "frmCfEnvFeesSettings.aspx/LoadVATCode",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlVAT.ClientID%>').empty();
                    $('#<%=ddlVAT.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlVAT.ClientID%>').append($("<option></option>").val(value.ID_SETTINGS).html(value.DESCRIPTION));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadWarehouse() {
            $.ajax({
                type: "POST",
                url: "frmCfEnvFeesSettings.aspx/LoadWarehouse",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlWH.ClientID%>').empty();
                    $('#<%=ddlWH.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlWH.ClientID%>').append($("<option></option>").val(value.Id_Warehouse).html(value.WarehouseName));
                        $('#<%=ddlWH.ClientID%>')[0].selectedIndex = 1;
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function editEnvFeeSettings(lineId) {
            var spareId, make, warehouse;            
            var rowdata = jQuery("#dgdEnvFeeSettings").jqGrid('getRowData', lineId);
            spareId = rowdata.ID_ITEM;
            make = rowdata.ENV_ID_MAKE;
            warehouse = rowdata.ENV_ID_WAREHOUSE;

            $('#divEnvFeeSettings').show();
            getEnvFeeSettings(spareId, make, warehouse);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            //$('#<%=hdnIdEnvFeeSettings.ClientID%>').val(idTemplate);
            $('#<%=hdnMode.ClientID%>').val("Edit");
            $("#<%=txtName.ClientID%>").attr('disabled', 'disabled');
            $("#<%=txtSparePartId.ClientID%>").attr('disabled', 'disabled');
        }

        function getEnvFeeSettings(spareId, make, warehouse) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfEnvFeesSettings.aspx/GetEnvFeeSettings",
                data: "{spareId: '" + spareId + "', make:'" + make + "', warehouse:'" + warehouse + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtSparePartId.ClientID%>').val(data.d[0].ID_ITEM);
                        $('#<%=txtMinAmt.ClientID%>').val(data.d[0].MIN_AMT);
                        $('#<%=txtMaxAmt.ClientID%>').val(data.d[0].MAX_AMT);
                        $('#<%=txtAddFeeDep.ClientID%>').val(data.d[0].ADDED_FEE_PERC);
                        $('#<%=txtName.ClientID%>').val(data.d[0].ENV_NAME);
                        $('#<%=txtMake.ClientID%>').val(data.d[0].ENV_ID_MAKE);
                        $('#<%=txtWarehouse.ClientID%>').val(data.d[0].ENV_ID_WAREHOUSE);

                        if (data.d[0].ENV_VATCODE == 0) {
                            $('#<%=ddlVAT.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            //$('#<%=ddlVAT.ClientID%>').val(data.d[0].Pay_Type);
                            $('#<%=ddlVAT.ClientID%> option:contains("' + data.d[0].ENV_VATCODE + '")').attr('selected', 'selected');
                        }
                    }
                }
            });
        }

        function searchEnvFeeSettings() {
            $('#divSrchEnvFeeSettings').show();
            $('#<%=btnAddT.ClientID%>').show();
            $('#<%=btnDelT.ClientID%>').show();
            $('#<%=btnAddB.ClientID%>').show();
            $('#<%=btnDelB.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Search");
            $('#<%=hdnIdEnvFeeSettings.ClientID%>').val("");
            loadEnvFeeSettings();
        }


        function loadEnvFeeSettings() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var sparePartId = $('#<%=txtSearchSpId.ClientID%>').val();
            var name = $('#<%=txtSrchName.ClientID%>').val();
            var warehouse = $('#<%=ddlWH.ClientID%>').val();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfEnvFeesSettings.aspx/LoadEnvFeeSettings",
                data: "{sparePartId: '" + sparePartId + "', name:'" + name + "', warehouse:'" + warehouse + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdEnvFeeSettings").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdEnvFeeSettings").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdEnvFeeSettings").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdEnvFeeSettings").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }        

        function addEnvFeeSettings() {
            $('#divEnvFeeSettings').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=txtMinAmt.ClientID%>').val("");
            $('#<%=txtMaxAmt.ClientID%>').val("");
            $('#<%=txtMake.ClientID%>').val("");
            $('#<%=txtAddFeeDep.ClientID%>').val("");
            $('#<%=txtSparePartId.ClientID%>').val("");
            $('#<%=txtName.ClientID%>').val("");
            $('#<%=txtWarehouse.ClientID%>').val("");
            $('#<%=hdnMode.ClientID%>').val("Add");
            $('#<%=hdnIdEnvFeeSettings.ClientID%>').val("");
            $("#<%=txtName.ClientID%>").removeAttr("disabled");
            $("#<%=txtSparePartId.ClientID%>").removeAttr("disabled");
        }

        function resetEnvFeeSettings() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divEnvFeeSettings').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSave.ClientID%>').hide();
                $('#<%=btnReset.ClientID%>').hide();
                $('#<%=txtMinAmt.ClientID%>').val("");
                $('#<%=txtMaxAmt.ClientID%>').val("");
                $('#<%=txtMake.ClientID%>').val("");
                $('#<%=txtAddFeeDep.ClientID%>').val("");
                $('#<%=txtSparePartId.ClientID%>').val("");
                $('#<%=txtName.ClientID%>').val("");
                $('#<%=txtWarehouse.ClientID%>').val("");
                $('#<%=hdnMode.ClientID%>').val("");
                $('#<%=hdnIdEnvFeeSettings.ClientID%>').val("");
            }
        }

        function saveEnvFeeSettings() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var idItem = $('#<%=txtSparePartId.ClientID%>').val();
            var flgEnvfee = "1";
            var minAmt = $('#<%=txtMinAmt.ClientID%>').val();
            var maxAmt = $('#<%=txtMaxAmt.ClientID%>').val();
            var addedFeePerc = $('#<%=txtAddFeeDep.ClientID%>').val();
            var name = $('#<%=txtName.ClientID%>').val();
            var vatCode = $('#<%=ddlVAT.ClientID%>').val();
            var idMake = $('#<%=txtMake.ClientID%>').val();
            var idWh = $('#<%=txtWarehouse.ClientID%>').val();

            var result = fnValidate();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfEnvFeesSettings.aspx/SaveEnvFeeSettings",
                    data: "{idItem: '" + idItem + "', flgEnvfee:'" + flgEnvfee + "', minAmt:'" + minAmt + "', maxAmt:'" + maxAmt + "', addedFeePerc:'" + addedFeePerc + "', name:'" + name + "', vatCode:'" + vatCode + "', idMake:'" + idMake + "', idWh:'" + idWh + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divEnvFeeSettings').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdEnvFeeSettings").jqGrid('clearGridData');
                            loadEnvFeeSettings();
                            jQuery("#dgdEnvFeeSettings").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
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

        function fnValidate() {

            if (!(gfi_CheckEmpty($('#<%=txtSparePartId.ClientID%>'), '0210'))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtName.ClientID%>'), '0210'))) {
                return false;
            }

            if ($('#<%=ddlVAT.ClientID%>')[0].selectedIndex == 0) {
                alert(GetMultiMessage('0007', '', + ' ' + '') + 'VAT Code');
                return false;
            }

            if (!(gfi_ValidateNumDot($('#<%=txtMinAmt.ClientID%>')))) {
                return false;
            }

            if (!(gfi_ValidateNumDot($('#<%=txtMaxAmt.ClientID%>')))) {
                return false;
            }

            if (!(gfi_ValidateNumber(($('#<%= txtAddFeeDep.ClientID%>')), 'EnvironmentalFeeDeposit'))) {
                $('#<%= txtAddFeeDep.ClientID%>').focus();
                return false;
            }

            var valmin = $('#<%= txtMinAmt.ClientID%>').val();
            var valmax = $('#<%= txtMaxAmt.ClientID%>').val();
            var Language;
            Language = '<%=Session("Current_Language")%>';
            if (Language == 'NORWEGIAN') {
                valmin = valmin.replace(",", ".");
                valmax = valmax.replace(",", ".");
            }

            if (Math.max(valmin, valmax) == valmin) {
                if (valmax != '0,00' || valmax != 0.00) {
                    if (valmax != valmin) {
                        var msg = GetMultiMessage('chkMax', '', '');
                        alert(msg);
                        return false;
                    }
                }
            }

            return true;
        }
        
        function deleteEnvFeeSettings() {            
            var slno = "";
            $('#dgdEnvFeeSettings input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    slno = $('#dgdEnvFeeSettings tr ')[row].cells[2].innerHTML.toString();
                }
            });

            if (slno != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delEnvFeeSettings();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function delEnvFeeSettings() {
            var sparePartId = "";
            var sparePartMake = "";
            var sparePartWh = "";
            var row;          
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var resultmsg = "";
            var result = "";
            $('#dgdEnvFeeSettings input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    sparePartId = $('#dgdEnvFeeSettings tr ')[row].cells[4].innerHTML.toString();
                    sparePartMake = $('#dgdEnvFeeSettings tr ')[row].cells[10].innerHTML.toString();
                    sparePartWh = $('#dgdEnvFeeSettings tr ')[row].cells[3].innerHTML.toString();

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfEnvFeesSettings.aspx/DeleteEnvFeeSettings",
                        data: "{sparePartId: '" + sparePartId + "',sparePartMake: '" + sparePartMake + "',sparePartWh: '" + sparePartWh + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            if (data.d[0] == "DELETED") {
                                result = data.d[1];
                                //result = sparePartId ; 
                                resultmsg += sparePartId + " ";
                            }
                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });
                }
            });
            jQuery("#dgdEnvFeeSettings").jqGrid('clearGridData');
            $('#divEnvFeeSettings').hide();
            loadEnvFeeSettings();
            $('#<%=RTlblError.ClientID%>').text(resultmsg +" " + result);

        }      





    </script>



    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblEnvFeesSettings" runat="server" Text="Environmental Fee Settings"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdEnvFeeSettings" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >Environmental Fee Settings</a>
    </div> 

    <div>
        <div  style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="a1" runat="server">Search EFD Matrix</a>
            </div>
        </div>
         <div class="ui form" style="width: 100%;padding-left:2em;">
            <div class="four fields">
                <div class="field" style="width:160px;">
                    <asp:Label ID="lblWh" runat="server" Text="Warehouse"></asp:Label>
                </div>
                <div class="field" style="width:150px;padding-bottom:1em">
                    <asp:DropDownList ID="ddlWH" runat="server"></asp:DropDownList>
                </div>                    
            </div>
            <div class="four fields">
                <div class="field" style="width:160px;">
                    <asp:Label ID="lblSearchSpId" runat="server" Text="Spare Part ID"></asp:Label>
                </div>
                <div class="field" style="width:150px">
                    <asp:TextBox ID="txtSearchSpId"  padding="0em" runat="server"></asp:TextBox>
                </div>                    
            </div>
            <div class="four fields">
                <div class="field" style="width:160px;">
                    <asp:Label ID="lblSrchName" runat="server" Text="Name"></asp:Label>
                </div>
                <div class="field" style="width:150px">
                    <asp:TextBox ID="txtSrchName"  padding="0em" runat="server"></asp:TextBox>
                </div>                    
            </div>
        </div>

        <div style="text-align:left;padding-bottom:4em;padding-left:15em;padding-top:2em">
            <input id="btnSearch" runat="server" type="button" value="Search" class="ui button"  onclick="searchEnvFeeSettings()"/>
        </div>

    </div>

    <div id="divSrchEnvFeeSettings">
        <div style="text-align:center;padding-bottom:1em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addEnvFeeSettings()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="deleteEnvFeeSettings()"/>
        </div>  
        <div >
            <table id="dgdEnvFeeSettings" title="Environmental Fee Settings" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:center;padding-top:1em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addEnvFeeSettings()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="deleteEnvFeeSettings()"/>
        </div>

        <div id="divEnvFeeSettings" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server">Add Spare</a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblSparePartID" runat="server" Text="Spare Part ID"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtSparePartId"  padding="0em" runat="server"></asp:TextBox>
                    </div>                    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblEnvFeeDep" runat="server" Text="Environmental Fee/Deposit"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:RadioButton ID="rbEnvFeeDep" runat="server" Checked="true" />
                    </div>                    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblMinAmt" runat="server" Text="Minimum Amount"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtMinAmt"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblMaxAmt" runat="server" Text="Maximum Amount"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtMaxAmt"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblFeeDep" runat="server" Text="Added fee/deposit in %"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtAddFeeDep"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblName" runat="server" Text="Name"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtName"  padding="0em" runat="server"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblVAT" runat="server" Text="VAT Code"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:DropDownList ID="ddlVAT" runat="server"></asp:DropDownList>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblMake" runat="server" Text="Supplier Current No"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtMake"  padding="0em" runat="server" Enabled="false"></asp:TextBox>
                    </div>          
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblWarehouse" runat="server" Text="Warehouse" ></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtWarehouse"  padding="0em" runat="server" Enabled="false"></asp:TextBox>
                    </div>          
                </div>
            </div>            

            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveEnvFeeSettings()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetEnvFeeSettings()" />
            </div>               
        </div>
    </div>


</asp:Content>
