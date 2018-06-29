<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Config_UnitofMeasurementContent.aspx.vb" Inherits="CARS.Config_UnitofMeasurementContent" MasterPageFile="~/MasterPage.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="cntMainPanel" ID="Content1">

    <script type="text/javascript">

        $(document).ready(function () {
            $('#divUOMConfig').hide();


            var grid = $("#dgdUOMConfig");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Unit Of Measurement', 'Description', 'IdUOM', ''],
                colModel: [
                         { name: 'Unit_Desc', index: 'Unit_Desc', width: 200, sorttype: "string" },
                         { name: 'Description', index: 'Description', width: 150, sorttype: "string" },
                         { name: 'Id_UOM', index: 'Id_UOM', width: 150, sorttype: "string",hidden:true },
                         { name: 'Id_UOM', index: 'Id_UOM', sortable: false, formatter: editUOMConfig }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "UOM",
                async: false, //Very important,
                subgrid: false

            });


            loadUOMConfig();

            function editUOMConfig(cellvalue, options, rowObject) {
                var uom = rowObject.Unit_Desc.toString();
                var desc = rowObject.Description.toString();

                $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
                var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
                var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editUOMDetails(" + "'" + uom + "','" + desc + "'" + "); />";
                return edit;
            }



        });//end of ready

        function editUOMDetails(uom,desc) {
            $('#divUOMConfig').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $("#<%=txtUOM.ClientID%>").val(uom);
            $("#<%=txtDesc.ClientID%>").val(desc);
            $("#<%=txtUOM.ClientID%>").attr('disabled', 'disabled');
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function addUOMConfig() {
            $('#divUOMConfig').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=txtUOM.ClientID%>').val("");
            $('#<%=txtDesc.ClientID%>').val("");
            $('#<%=hdnMode.ClientID%>').val("Add");
            $("#<%=txtUOM.ClientID%>").removeAttr("disabled");
        }

        function resetUOMConfig() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divUOMConfig').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSave.ClientID%>').hide();
                $('#<%=btnReset.ClientID%>').hide();
                $('#<%=txtUOM.ClientID%>').val("");
                $('#<%=txtDesc.ClientID%>').val("");
                $('#<%=hdnMode.ClientID%>').val("Add");
                $('#<%=hdnIdUOM.ClientID%>').val("0");
            }
        }

        function saveUOMConfig() {

            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var uom = $('#<%=txtUOM.ClientID%>').val();
            var desc = $('#<%=txtDesc.ClientID%>').val();

            var result = fnValidate();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Config_UnitofMeasurementContent.aspx/SaveUOMConfig",
                    data: "{uom: '" + uom + "', desc:'" + desc + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divUOMConfig').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdUOMConfig").jqGrid('clearGridData');
                            loadUOMConfig();
                            jQuery("#dgdUOMConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

        function loadUOMConfig() {

            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Config_UnitofMeasurementContent.aspx/LoadUOMConfig",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdUOMConfig").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdUOMConfig").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdUOMConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdUOMConfig").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function delUOMConfig() {
            var slno = "";
            $('#dgdUOMConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    slno = $('#dgdUOMConfig tr ')[row].cells[4].innerHTML.toString();
                }
            });

            if (slno != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteUOMConfig();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteUOMConfig() {
            var idUOM = "";
            var description = "";
            var row;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var resultmsg = "";
            var result = "";
            $('#dgdUOMConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idUOM = $('#dgdUOMConfig tr ')[row].cells[4].innerHTML.toString();
                    description = $('#dgdUOMConfig tr ')[row].cells[3].innerHTML.toString();
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Config_UnitofMeasurementContent.aspx/DeleteUOMDetails",
                        data: "{idUOM: '" + idUOM + "'}",
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
            jQuery("#dgdUOMConfig").jqGrid('clearGridData');
            loadUOMConfig();
            $('#<%=RTlblError.ClientID%>').removeClass();
            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
            $('#<%=RTlblError.ClientID%>').text(resultmsg + " " + result);

        }

        function fnValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtUOM.ClientID%>'), '70357'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtUOM.ClientID%>'), '70357'))) {
                return false;
            }

            if (CheckLength($('#<%=txtUOM.ClientID%>'), 10, '70357')) {
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


    </script>

    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblUOMConfig" runat="server" Text="Unit Of Measurement Configuration"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdUOM" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server">Unit Of Measurement Configuration</a>
    </div>
    <div>
        <div style="text-align:left;padding-bottom:1em;padding-left:15em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addUOMConfig()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="delUOMConfig()"/>
        </div>  
        <div >
            <table id="dgdUOMConfig" title="Unit Of Measurement Configuration" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:left;padding-top:1em;padding-left:15em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addUOMConfig()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="delUOMConfig()"/>
        </div>

        <div id="divUOMConfig" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Add/Edit Unit Of Measurement Configuration</a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblUOM" runat="server" Text="Unit of Measurement"></asp:Label>
                    </div>
                    <div class="field" style="width:300px">
                        <asp:TextBox ID="txtUOM"  padding="0em" runat="server" Width="150px"></asp:TextBox>
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
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveUOMConfig()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetUOMConfig()" />
            </div>               
        </div>
    </div>




</asp:Content>