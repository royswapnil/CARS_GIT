<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Config_DiscountCodeContent.aspx.vb" Inherits="CARS.Config_DiscountCodeContent" MasterPageFile="~/MasterPage.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="cntMainPanel" ID="Content1">

        <script type="text/javascript">

            $(document).ready(function () {
                $('#divDiscCodeConfig').hide();

                var grid = $("#dgdDiscCodeConfig");
                var mydata;
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                grid.jqGrid({
                    datatype: "local",
                    data: mydata,
                    colNames: ['Supplier Current No', 'Discount Code', 'Description', 'Id_DiscountCode', ''],
                    colModel: [
                             { name: 'SUPPLIER_NUMBER', index: 'SUPPLIER_NUMBER', width: 150, sorttype: "string" },
                             { name: 'DESCRIPTION', index: 'DESCRIPTION', width: 150, sorttype: "string" },
                             { name: 'ITEM_DISC_CODE_BUYING', index: 'ITEM_DISC_CODE_BUYING', width: 150, sorttype: "string" },
                             { name: 'ID_ITEM_DISC_CODE_BUYING', index: 'ID_ITEM_DISC_CODE_BUYING', width: 50, sorttype: "string", hidden: true },
                             { name: 'ID_ITEM_DISC_CODE_BUYING', index: 'ID_ITEM_DISC_CODE_BUYING', sortable: false, formatter: editDiscCodeConfig }
                    ],
                    multiselect: true,
                    pager: jQuery('#pager'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5,
                    sortorder: 'asc',
                    viewrecords: true,
                    height: "50%",
                    caption: "Discount Code",
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

                loadDiscCodeConfig();

                function editDiscCodeConfig(cellvalue, options, rowObject) {
                    var idDiscCode = rowObject.ID_ITEM_DISC_CODE_BUYING.toString();

                    $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                    var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                    var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editDiscCodeDetails(" + "'" + idDiscCode + "'" + "); />";
                    return edit;
                }

            }); // end of ready

            function editDiscCodeDetails(idDiscCode) {
                $('#divDiscCodeConfig').show();
                getDiscCodeDetails(idDiscCode);
                $('#<%=btnAddT.ClientID%>').hide();
                $('#<%=btnDelT.ClientID%>').hide();
                $('#<%=btnAddB.ClientID%>').hide();
                $('#<%=btnDelB.ClientID%>').hide();
                $('#<%=btnSave.ClientID%>').show();
                $('#<%=btnReset.ClientID%>').show();
                $('#<%=hdnIdDiscCode.ClientID%>').val(idDiscCode);
                $("#<%=txtMake.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtDiscCode.ClientID%>").attr('disabled', 'disabled');
                $('#<%=hdnMode.ClientID%>').val("Edit");
            }

            function getDiscCodeDetails(idDiscCode) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_DiscountCodeContent.aspx/GetDiscCodeDetails",
                    data: "{idDiscCode: '" + idDiscCode + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        if (data.d.length > 0) {
                            $('#<%=txtMake.ClientID%>').val(data.d[0].SUPPLIER_NUMBER);
                            $('#<%=txtDesc.ClientID%>').val(data.d[0].ITEM_DISC_CODE_BUYING);
                            $('#<%=txtDiscCode.ClientID%>').val(data.d[0].DESCRIPTION);
                        }
                    }
                });
            }

            function addDiscCodeConfig() {
                $('#divDiscCodeConfig').show();
                $('#<%=btnAddT.ClientID%>').hide();
                $('#<%=btnDelT.ClientID%>').hide();
                $('#<%=btnAddB.ClientID%>').hide();
                $('#<%=btnDelB.ClientID%>').hide();
                $('#<%=btnSave.ClientID%>').show();
                $('#<%=btnReset.ClientID%>').show();
                $('#<%=txtMake.ClientID%>').val("");
                $('#<%=txtDiscCode.ClientID%>').val("");
                $('#<%=txtDesc.ClientID%>').val("");
                $('#<%=hdnMode.ClientID%>').val("Add");
                $('#<%=hdnIdDiscCode.ClientID%>').val("0");   
                $("#<%=txtMake.ClientID%>").removeAttr("disabled");
                $("#<%=txtDiscCode.ClientID%>").removeAttr("disabled");
            }

            function resetDiscCodeConfig() {
                var msg = GetMultiMessage('0161', '', '');
                var r = confirm(msg);
                if (r == true) {
                    $('#divDiscCodeConfig').hide();
                    $('#<%=btnAddT.ClientID%>').show();
                    $('#<%=btnDelT.ClientID%>').show();
                    $('#<%=btnAddB.ClientID%>').show();
                    $('#<%=btnDelB.ClientID%>').show();
                    $('#<%=btnSave.ClientID%>').hide();
                    $('#<%=btnReset.ClientID%>').hide();
                    $('#<%=txtMake.ClientID%>').val("");
                    $('#<%=txtDiscCode.ClientID%>').val("");
                    $('#<%=txtDesc.ClientID%>').val("");
                    $('#<%=hdnMode.ClientID%>').val("Add");
                    $('#<%=hdnIdDiscCode.ClientID%>').val("0");
                }
            }

            function loadDiscCodeConfig() {

                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_DiscountCodeContent.aspx/LoadDiscCodeConfig",
                    data: "{}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        if (data.d.length > 0) {
                            jQuery("#dgdDiscCodeConfig").jqGrid('clearGridData');
                            for (i = 0; i < data.d.length; i++) {
                                mydata = data.d;
                                jQuery("#dgdDiscCodeConfig").jqGrid('addRowData', i + 1, mydata[i]);
                            }
                            jQuery("#dgdDiscCodeConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $("#dgdDiscCodeConfig").jqGrid("hideCol", "subgrid");
                        }
                    }
                });
            }

            function saveDiscCodeConfig() {
                var mode = $('#<%=hdnMode.ClientID%>').val();
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var suppCurrentNo = $('#<%=txtMake.ClientID%>').val();
                var discCode = $('#<%=txtDiscCode.ClientID%>').val();
                var desc = $('#<%=txtDesc.ClientID%>').val();
               
                var result = fnValidate();
                if (result == true) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Config_DiscountCodeContent.aspx/SaveDiscCodeDetails",
                        data: "{suppCurrentNo: '" + suppCurrentNo + "', discCode:'" + discCode + "', desc:'" + desc + "', mode:'" + mode + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                                $('#divDiscCodeConfig').hide();
                                $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                $('#<%=btnAddT.ClientID%>').show();
                                $('#<%=btnAddB.ClientID%>').show();
                                $('#<%=btnDelT.ClientID%>').show();
                                $('#<%=btnDelB.ClientID%>').show();
                                jQuery("#dgdDiscCodeConfig").jqGrid('clearGridData');
                                loadDiscCodeConfig();
                                jQuery("#dgdDiscCodeConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

                if (!(gfi_CheckEmpty($('#<%=txtDiscCode.ClientID%>'), '70358'))) {
                    return false;
                }

                if (CheckLength($('#<%=txtDiscCode.ClientID%>'), 5, '70358')) {
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtDiscCode.ClientID%>'), '70358'))) {
                    return false;
                }

                if (!(gfi_CheckEmpty($('#<%=txtDesc.ClientID%>'), '0185'))) {
                    return false;
                }

                if (!(gfb_ValidateAlphabets($('#<%=txtDesc.ClientID%>'), '0185'))) {
                    return false;
                }
                     
                if (CheckLength($('#<%=txtDesc.ClientID%>'), 50, '0185')) {
                    return false;
                }

                return true;

            }

            function CheckLength(strCName, len, sErrCode) {
                var strCValue;
                var strClen;
                strCValue = strCName[0].value;
                strClen = strCValue.length;
                if (strClen > len) {
                    var msg;
                    msg = GetMultiMessage('MSG108', '', '') + GetMultiMessage(sErrCode, '', '') + GetMultiMessage('MSGSERR13', '', '') + len;
                    alert(msg);
                    return true;
                }
                else {
                    return false;
                }
            }

            function deleteDiscCodeConfig() {
                var slno = "";
                $('#dgdDiscCodeConfig input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        slno = $('#dgdDiscCodeConfig tr ')[row].cells[5].innerHTML.toString();
                    }
                });

                if (slno != "") {
                    var msg = GetMultiMessage('0016', '', '');
                    var r = confirm(msg);
                    if (r == true) {
                        delDiscCodeConfig();
                    }
                }
                else {
                    var msg = GetMultiMessage('SelectRecord', '', '');
                    alert(msg);
                }
            }

            function delDiscCodeConfig() {
                var idDiscCode = "";
                var description = "";
                var row;
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var resultmsg = "";
                var result = "";
                $('#dgdDiscCodeConfig input:checkbox').attr("checked", function () {
                    if (this.checked) {
                        row = $(this).closest('td').parent()[0].sectionRowIndex;
                        idDiscCode = $('#dgdDiscCodeConfig tr ')[row].cells[5].innerHTML.toString();
                        description = $('#dgdDiscCodeConfig tr ')[row].cells[3].innerHTML.toString();
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "Config_DiscountCodeContent.aspx/DeleteDiscCodeDetails",
                            data: "{idDiscCode: '" + idDiscCode + "'}",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d[0] == "DELETED") {
                                    result = data.d[1];
                                    resultmsg += description + " ";
                                }
                            },
                            error: function (result) {
                                alert("Error");
                            }
                        });
                    }
                });
                jQuery("#dgdDiscCodeConfig").jqGrid('clearGridData');
                loadDiscCodeConfig();
                $('#<%=RTlblError.ClientID%>').removeClass();
                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                $('#<%=RTlblError.ClientID%>').text(resultmsg + " " + result);

            }

        </script>

    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblSpConfig" runat="server" Text="Discount Code Configuration"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdDiscCode" runat="server" />
         <asp:HiddenField id="hdnSupplierId" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >Discount Code Configuration </a>
    </div> 
    <div>
        <div style="text-align:left;padding-bottom:1em;padding-left:15em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addDiscCodeConfig()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="deleteDiscCodeConfig()"/>
        </div>  
        <div >
            <table id="dgdDiscCodeConfig" title="Discount Code Configuration" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:left;padding-top:1em;padding-left:15em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addDiscCodeConfig()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="deleteDiscCodeConfig()"/>
        </div>

        <div id="divDiscCodeConfig" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Add/Edit Discount Code Configuration </a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblMake" runat="server" Text="Supplier Current Number"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtMake"  padding="0em" runat="server" Width="150px"></asp:TextBox>
                    </div>                    
                                 
                </div>
                 <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblDiscCode" runat="server" Text="Discount Code"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtDiscCode"  padding="0em" runat="server"></asp:TextBox>
                    </div>    
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblDesc" runat="server" Text="Description"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtDesc"  padding="0em" runat="server" Width="150px"></asp:TextBox>
                    </div>                                   
                </div>
            </div> 
            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveDiscCodeConfig()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetDiscCodeConfig()" />
            </div>               
        </div>
    </div>



</asp:Content>



