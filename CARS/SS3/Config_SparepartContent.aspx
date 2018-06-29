<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Config_SparepartContent.aspx.vb" Inherits="CARS.Config_SparepartContent" MasterPageFile="~/MasterPage.Master" %>
<asp:Content runat="server" ContentPlaceHolderID="cntMainPanel" ID="Content1">


    <script type="text/javascript">

        $(document).ready(function () {
           $('#divSpCatgConfig').hide();

            var grid = $("#dgdSpCatgConfig");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Supplier Current No', 'Category', 'Description', 'InClassCode', 'DiscCode Buying', 'DiscCode Selling', 'VAT Code', 'Account Code', 'Count Stock', 'Allow Back Order', 'Allow Classification', 'Supplier', 'ID_ITEM_DISC_CODE_BUYING', 'ID_ITEM_DISC_CODE_SELL', 'Id_Item_Catg', ''],
                colModel: [
                         { name: 'SUPPLIER_NUMBER', index: 'SUPPLIER_NUMBER', width: 150, sorttype: "string" },
                         { name: 'CATEGORY', index: 'CATEGORY', width: 80, sorttype: "string" },
                         { name: 'DESCRIPTION', index: 'DESCRIPTION', width: 150, sorttype: "string" },
                         { name: 'INITIALCLASSCODE', index: 'INITIALCLASSCODE', width: 100, sorttype: "string" },
                         { name: 'ITEM_DISC_CODE_BUYING', index: 'ITEM_DISC_CODE_BUYING', width: 100, sorttype: "string" },
                         { name: 'ITEM_DISC_CODE_SELL', index: 'ITEM_DISC_CODE_SELL', width: 100, sorttype: "string" },
                         { name: 'ID_VAT_CODE', index: 'ID_VAT_CODE', width: 100, sorttype: "string" },
                         { name: 'ACCOUNT_CODE', index: 'ACCOUNT_CODE', width: 100, sorttype: "string" },
                         { name: 'CNT_STOCK', index: 'CNT_STOCK', width: 100, sorttype: "string" },
                         { name: 'ALLOW_BCKORD', index: 'ALLOW_BCKORD', width: 100, sorttype: "string" },
                         { name: 'ALLOW_CLASSIFICATION', index: 'ALLOW_CLASSIFICATION', width: 100, sorttype: "string" },
                         { name: 'SUP_Name', index: 'SUP_Name', width: 100, sorttype: "string" },
                         { name: 'ID_ITEM_DISC_CODE_BUYING', index: 'ID_ITEM_DISC_CODE_BUYING', width: 50, sorttype: "string", hidden: true },
                         { name: 'ID_ITEM_DISC_CODE_SELL', index: 'ID_ITEM_DISC_CODE_SELL', width: 50, sorttype: "string", hidden: true },
                         { name: 'ID_SPCATEGORY', index: 'ID_SPCATEGORY', width: 50, sorttype: "string",hidden:true },
                         { name: 'ID_SPCATEGORY', index: 'ID_SPCATEGORY', sortable: false, formatter: editSpCatgConfig }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Spare Part Category",
                async: false, //Very important,
                subgrid: false

            });

            var imake, iid, iwh;
            $('#<%=txtMake.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Config_SparepartContent.aspx/LoadSupplier",
                        data: "{supplier:'" + $('#<%=txtMake.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtMake.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    imake = item.SUP_Name;
                                    iid = item.SUPPLIER_NUMBER;
                                    iwh = '1';
                                    return {
                                        label: item.SUP_Name + " - " + item.SUPPLIER_NUMBER,
                                        val: item.SUP_Name,
                                        value: item.SUPPLIER_NUMBER,
                                        idsupp: item.ID_SUPPLIER_ITEM,

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
                    $('#<%=txtMake.ClientID%>').val(i.item.val);
                    $('#<%=hdnSupplierId.ClientID%>').val(i.item.idsupp);
                }
            });


            loadDiscCodes();
            loadVATCode();
            loadSpCatgConfig();

            function editSpCatgConfig(cellvalue, options, rowObject) {
                var idItemCatg = rowObject.ID_SPCATEGORY.toString();

                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editSpCatgDetails(" + "'" + idItemCatg + "'" + "); />";
                return edit;
            }
            
        });

        function editSpCatgDetails(idItemCatg) {
            $('#divSpCatgConfig').show();
            getSpCatgDetails(idItemCatg);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=hdnSpCatgId.ClientID%>').val(idItemCatg);
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function getSpCatgDetails(idItemCatg) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Config_SparepartContent.aspx/GetSpCatgDetails",
                data: "{idItemCatg: '" + idItemCatg +  "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtMake.ClientID%>').val(data.d[0].SUPPLIER_NUMBER);
                        $('#<%=txtAccntCode.ClientID%>').val(data.d[0].ACCOUNT_CODE);
                        $('#<%=txtCatg.ClientID%>').val(data.d[0].CATEGORY);
                        $('#<%=txtDesc.ClientID%>').val(data.d[0].DESCRIPTION);
                        $('#<%=txtClassCode.ClientID%>').val(data.d[0].INITIALCLASSCODE);
                     

                        if (data.d[0].ID_VAT_CODE == 0) {
                            $('#<%=ddlVatCode.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlVatCode.ClientID%>').val(data.d[0].ID_VAT_CODE);
                        }

                        if (data.d[0].ID_ITEM_DISC_CODE_BUYING == 0) {
                            $('#<%=ddlDiscBuy.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlDiscBuy.ClientID%>').val(data.d[0].ID_ITEM_DISC_CODE_BUYING);
                        }

                        if (data.d[0].ID_ITEM_DISC_CODE_SELL == 0) {
                            $('#<%=ddlDiscSell.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlDiscSell.ClientID%>').val(data.d[0].ID_ITEM_DISC_CODE_SELL);
                        }

                        if (data.d[0].FLG_ALLOW_BCKORD == true) {
                            $("#<%=cbAllowBO.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbAllowBO.ClientID%>").attr('checked', false);
                        }

                        if (data.d[0].FLG_CNT_STOCK == true) {
                            $("#<%=cbCntStock.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbCntStock.ClientID%>").attr('checked', false);
                        }

                        if (data.d[0].FLG_ALLOW_CLASSIFICATION == true) {
                            $("#<%=cbAllowClass.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbAllowClass.ClientID%>").attr('checked', false);
                        }

                    }
                }
            });
        }
       

        function loadDiscCodes() {
            $.ajax({
                type: "POST",
                url: "Config_SparepartContent.aspx/LoadDiscCodes",
                data: "{supplier:'" + $('#<%=txtMake.ClientID%>').val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlDiscBuy.ClientID%>').empty();
                    $('#<%=ddlDiscBuy.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDiscBuy.ClientID%>').append($("<option></option>").val(value.DISCOUNT).html(value.DESCRIPTION));
                    });

                    $('#<%=ddlDiscSell.ClientID%>').empty();
                    $('#<%=ddlDiscSell.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    //Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDiscSell.ClientID%>').append($("<option></option>").val(value.DISCOUNT).html(value.DESCRIPTION));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadVATCode() {
            $.ajax({
                type: "POST",
                url: "../Master/frmCfEnvFeesSettings.aspx/LoadVATCode",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlVatCode.ClientID%>').empty();
                    $('#<%=ddlVatCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlVatCode.ClientID%>').append($("<option></option>").val(value.ID_SETTINGS).html(value.DESCRIPTION));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }


        function addSpCatgConfig() {
            $('#divSpCatgConfig').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=txtMake.ClientID%>').val("");
            $('#<%=txtCatg.ClientID%>').val("");
            $('#<%=txtDesc.ClientID%>').val("");
            $('#<%=txtClassCode.ClientID%>').val("");
            $('#<%=ddlDiscBuy.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlDiscSell.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlVatCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=hdnMode.ClientID%>').val("Add");
            $('#<%=hdnSpCatgId.ClientID%>').val("0");
            $("#<%=cbAllowBO.ClientID%>").attr('checked', false);
            $("#<%=cbCntStock.ClientID%>").attr('checked', false);
            $("#<%=cbAllowClass.ClientID%>").attr('checked', false);
            $('#<%=txtAccntCode.ClientID%>').val("");

        }

        function resetSpCatgConfig() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divSpCatgConfig').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSave.ClientID%>').hide();
                $('#<%=btnReset.ClientID%>').hide();
                $('#<%=txtMake.ClientID%>').val("");
                $('#<%=txtCatg.ClientID%>').val("");
                $('#<%=txtDesc.ClientID%>').val("");
                $('#<%=txtClassCode.ClientID%>').val("");
                $('#<%=ddlDiscBuy.ClientID%>')[0].selectedIndex = 0;
                $('#<%=ddlDiscSell.ClientID%>')[0].selectedIndex = 0;
                $('#<%=ddlVatCode.ClientID%>')[0].selectedIndex = 0;
                $('#<%=hdnMode.ClientID%>').val("Add");
                $('#<%=hdnSpCatgId.ClientID%>').val("0");               
            }
        }

        function loadSpCatgConfig() {

            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Config_SparepartContent.aspx/LoadSpCatgConfig",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdSpCatgConfig").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdSpCatgConfig").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdSpCatgConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdSpCatgConfig").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function saveSpCatgConfig() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var discCodeBuy = $('#<%=ddlDiscBuy.ClientID%>').val();
            var discCodeSell = $('#<%=ddlDiscSell.ClientID%>').val();
            var idSupplier = $('#<%=hdnSupplierId.ClientID%>').val();
            var idMake = $('#<%=txtMake.ClientID%>').val();
            var catg = $('#<%=txtCatg.ClientID%>').val();
            var desc = $('#<%=txtDesc.ClientID%>').val();
            var initialClCode = $('#<%=txtClassCode.ClientID%>').val();
            var vatCode = $('#<%=ddlVatCode.ClientID%>').val();
            var accntCode = $('#<%=txtAccntCode.ClientID%>').val();
            var flgAllowBO = $("#<%=cbAllowBO.ClientID%>").is(':checked'); //[todo]
            var flgCntStock = $("#<%=cbCntStock.ClientID%>").is(':checked');
            var flgAllowClass = $("#<%=cbAllowClass.ClientID%>").is(':checked');


            var result = fnValidate();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_SparepartContent.aspx/SaveSpCatgDetails",
                    data: "{discCodeBuy: '" + discCodeBuy + "', discCodeSell:'" + discCodeSell + "', idSupplier:'" + idSupplier + "', idMake:'" + idMake + "', catg:'" + catg + "', desc:'" + desc + "', initialClCode:'" + initialClCode + "', vatCode:'" + vatCode + "', accntCode:'" + accntCode + "', flgAllowBO:'" + flgAllowBO + "', flgCntStock:'" + flgCntStock + "', flgAllowClass:'" + flgAllowClass + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divSpCatgConfig').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdSpCatgConfig").jqGrid('clearGridData');
                            loadSpCatgConfig();
                            jQuery("#dgdSpCatgConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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
            if (!(gfi_CheckEmpty($('#<%=txtMake.ClientID%>'), '0181'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtMake.ClientID%>'), '0181'))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtCatg.ClientID%>'), '70360'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtCatg.ClientID%>'), '70360'))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtDesc.ClientID%>'), '0185'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtDesc.ClientID%>'), '0185'))) {
                return false;
            }

            if ($('#<%=ddlVatCode.ClientID%>')[0].selectedIndex == 0) {
                alert(GetMultiMessage('MSGSERR2', '', '') + ' ' + GetMultiMessage('0149', '', ''));
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtAccntCode.ClientID%>'), '0398'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtAccntCode.ClientID%>'), '0398'))) {
                return false;
            }

            if ($("#<%=cbAllowClass.ClientID%>").is(':checked')) {
                if (!(gfi_CheckEmpty($('#<%=txtClassCode.ClientID%>'), '70362'))) {
                    $('#<%=txtClassCode.ClientID%>').focus();
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtClassCode.ClientID%>'), '70362'))) {
                    return false;
                }
            }

            return true;

        }


        function deleteSpCatgConfig() {
            var slno = "";
            $('#dgdSpCatgConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    slno = $('#dgdSpCatgConfig tr ')[row].cells[16].innerHTML.toString();
                }
            });

            if (slno != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    delSpCatgConfig();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function delSpCatgConfig() {
            var idItemCatg = "";
            var row;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var resultmsg = "";
            var result = "";
            $('#dgdSpCatgConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idItemCatg = $('#dgdSpCatgConfig tr ')[row].cells[16].innerHTML.toString();
                   
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Config_SparepartContent.aspx/DeleteSpCatgDetails",
                        data: "{idItemCatg: '" + idItemCatg  + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            if (data.d[0] == "DELETED") {
                                result = data.d[1];
                                resultmsg += idItemCatg + " ";
                            }
                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });
                }
            });
            jQuery("#dgdSpCatgConfig").jqGrid('clearGridData');
            loadSpCatgConfig();
            $('#<%=RTlblError.ClientID%>').removeClass();
            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
            $('#<%=RTlblError.ClientID%>').text(resultmsg + " " + result);

        }


    </script>

    


     <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblSpConfig" runat="server" Text="Spare Part Category Configuration"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnSpCatgId" runat="server" />
         <asp:HiddenField id="hdnSupplierId" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >Spare Part Category Configuration </a>
    </div> 

    <div>
        <div style="text-align:center;padding-bottom:1em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addSpCatgConfig()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="deleteSpCatgConfig()"/>
        </div>  
        <div >
            <table id="dgdSpCatgConfig" title="Spare Part Category Configuration" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:center;padding-top:1em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addSpCatgConfig()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="deleteSpCatgConfig()"/>
        </div>

        <div id="divSpCatgConfig" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Add/Edit Spare Part Category Configuration </a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblMake" runat="server" Text="Supplier Current Number"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtMake"  padding="0em" runat="server" Width="150px"></asp:TextBox>
                    </div>  
                    
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblCatg" runat="server" Text="Category"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtCatg"  padding="0em" runat="server"></asp:TextBox>
                    </div>                  
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblDesc" runat="server" Text="Description"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtDesc"  padding="0em" runat="server" Width="150px"></asp:TextBox>
                    </div>  
                    
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblClassCode" runat="server" Text="Initial Class Code"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtClassCode"  padding="0em" runat="server"></asp:TextBox>
                    </div>                  
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblDiscBuy" runat="server" Text="Discount Buying"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:DropDownList runat="server" ID="ddlDiscBuy" Width="150px"></asp:DropDownList>
                    </div>  
                    
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblDiscSell" runat="server" Text="Discount Selling"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:DropDownList runat="server" ID="ddlDiscSell" Width="150px"></asp:DropDownList>
                    </div>                  
                </div>
               <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblVatCode" runat="server" Text="VAT Code"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:DropDownList runat="server" ID="ddlVatCode" Width="150px"></asp:DropDownList>
                    </div>  
                    
                    <div class="field" style="width:160px;" >
                        <asp:Label ID="lblSupplier" runat="server" Text="Supplier" Visible="false"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtSupplier"  padding="0em" runat="server" Visible="false"></asp:TextBox>
                    </div>                  
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblAccntCode" runat="server" Text="Account Code" ></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtAccntCode"  padding="0em" runat="server" Width="150px"></asp:TextBox>
                    </div>                    
                                                         
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">                       
                        <asp:Label ID="lblAllowBO" runat="server" Text="Allow Back Order" ></asp:Label>
                    </div>
                    <div class="field" style="width:150px;">
                       <asp:CheckBox ID="cbAllowBO" runat="server" />
                    </div>
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">                       
                        <asp:Label ID="lblCntStock" runat="server" Text="Count Stock" ></asp:Label>
                    </div>
                    <div class="field" style="width:150px;">
                       <asp:CheckBox ID="cbCntStock" runat="server" />
                    </div>
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">                       
                        <asp:Label ID="lblAllowClass" runat="server" Text="Allow Classification" ></asp:Label>
                    </div>
                    <div class="field" style="width:150px;">
                       <asp:CheckBox ID="cbAllowClass" runat="server" />
                    </div>
                </div>

            </div>            

            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveSpCatgConfig()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetSpCatgConfig()" />
            </div>               
        </div>
    </div>




</asp:Content>