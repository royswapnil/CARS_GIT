<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLACodeList.aspx.vb" Inherits="CARS.frmLACodeList" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
<style type="text/css">
         .ui-dialog .ui-dialog-titlebar-close span {
            display: block;
            margin-bottom: 0px;
            padding: 0px;
            margin-left: -9px;
            margin-top: -9px;
        }

        .ui-dialog .ui-dialog-titlebar button.ui-button:focus,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-focus,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-active,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-hover {
            outline: none;
        }
        .ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus {
            border: 1px solid #999999;
            font-weight: normal;
            color: #212121;
            background-color: white;
        }
       .ui-state-default, .ui-widget-header .ui-state-default{
            background:none;
            border:none;
        }
    </style>

    <script type="text/javascript">

        $(document).ready(function () {

            $('#divSrchLACodes').hide();

            var grid = $("#dgdLACodeList");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            FillAccCode();
           
            function FillAccCode() {
                $.ajax({
                    type: "POST",
                    url: "frmLAMatrix.aspx/LoadAccCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0].length > 0) {
                            $('#<%=ddlDeptAccntCode.ClientID%>').empty();
                            $('#<%=ddlDeptAccntCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                            var Result = data.d[0];
                            $.each(Result, function (key, value) {
                                $('#<%=ddlDeptAccntCode.ClientID%>').append($("<option></option>").val(value.Id_DeptId).html(value.Id_DeptAcCode));
                                $('#<%=ddlDeptAccntCode.ClientID%>')[0].selectedIndex = 1;
                            });
                        }
                        if (data.d[1].length > 0) {
                            $('#<%=ddlCustGrpAccntCode.ClientID%>').empty();
                            $('#<%=ddlCustGrpAccntCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                            var Result = data.d[1];
                            $.each(Result, function (key, value) {
                                $('#<%=ddlCustGrpAccntCode.ClientID%>').append($("<option></option>").val(value.Id_CUSTOMER).html(value.Id_CustGrpAcCode));
                            });
                        }
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //LaCodeList 
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['DeptAccCode', 'GrpAccCode', 'VatCode', 'Type', 'AccountCode','SellingGL','CostGL', 'Descripton', 'Id_Matrix', ''],
                colModel: [
                         { name: 'Id_DeptAcCode', index: 'Id_DeptAcCode', width: 100, sorttype: "string" },
                         { name: 'Id_CustGrpAcCode', index: 'Id_CustGrpAcCode', width: 100, sorttype: "string" },
                         { name: 'Id_VatCode', index: 'Id_VatCode', width: 90, sorttype: "string" },
                         { name: 'Id_SaleCode_Type', index: 'Id_SaleCode_Type', width: 90, sorttype: "string" },
                         { name: 'AccountCode', index: 'AccountCode', width: 100, sorttype: "string" },
                         { name: 'SellingGL', index: 'SellingGL', width: 90, sorttype: "string" },
                         { name: 'CostGL', index: 'CostGL', width: 90, sorttype: "string" },
                         { name: 'Id_Description', index: 'Id_Description', width: 300, sorttype: "string" },
                         { name: 'Id_Matrix', index: 'Id_Matrix', width: 40, sorttype: "string",hidden:true },
                         { name: 'LAIdMatrix', index: 'LAIdMatrix', sortable: false, formatter: editLACode }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "LACodeList",
                async: false, //Very important,
                subGrid: true,
                subGridOptions: {
                    "plusicon": "ui-icon-triangle-1-e",
                    "minusicon": "ui-icon-triangle-1-s",
                    "openicon": "ui-icon-arrowreturn-1-e",
                    "reloadOnExpand": false,
                    "selectOnExpand": true
                },
                subGridRowExpanded: function (subgrid_id, row_id) {
                    var subgrid_table_id, pager_id; subgrid_table_id = subgrid_id + "_t";
                    pager_id = "p_" + subgrid_table_id;
                    $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table>");
                    $("#" + subgrid_table_id).jqGrid({
                        datatype: "local",
                        colNames: ['AccType', 'GL', 'Cr/Dr', 'GLAccNo', 'GLDepAccNo', 'GLDimension', 'Description', 'Id_Slno', 'LA_SlNo'],
                        colModel: [
                                    { name: "Acc_Type", index: "Acc_Type", width: 150, key: true },
                                    { name: "Gen_Ledger", index: "Gen_Ledger", width: 50 },
                                    { name: "Gl_Crdb", index: "Gl_Crdb", width: 100, align: "right" },
                                    { name: "Gl_Accno", index: "Gl_Accno", width: 70, align: "right" },
                                    { name: "Gl_DeptAccno", index: "Gl_DeptAccno", width: 80, align: "right" },
                                    { name: "Gl_Dimension", index: "Gl_Dimension", width: 120, align: "right" },
                                    { name: "LA_Description", index: "LA_Description", width: 100, align: "right" },
                                    { name: "Id_Slno", index: "Id_Slno", width: 50, align: "right",hidden:true },
                                    { name: "LA_SlNo", index: "LA_SlNo", width: 50, align: "right",hidden:true }
                        ],
                        rowNum: 20,
                        pager: pager_id,
                        sortname: 'num',
                        sortorder: "asc", height: '100%'
                    });
                    //   $("#" + subgrid_table_id).jqGrid('navGrid', "#" + pager_id, { edit: false, add: false, del: false });
                    var mysubdata;//= [];

                    var rowdata = jQuery("#dgdLACodeList").jqGrid('getRowData', row_id);

                    var la_slno = rowdata.Id_Matrix ;//"V2253776";

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmLACodeList.aspx/FetchLAAccTypes",
                        data: "{la_slno: '" + la_slno + "'}",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            mysubdata = Result.d;
                            if (Result.d.length > 0) {
                                for (i = 0; i < Result.d.length; i++) {                                    
                                    $("#" + subgrid_table_id).jqGrid('addRowData', i + 1, mysubdata[i]);
                                }
                                $("#" + subgrid_table_id).jqGrid("hideCol", "subgrid");
                            }
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
                }
            });           
            loadLACodeList();
        });//end of ready

        function editLACode(cellvalue, options, rowObject) {
            var idLA = rowObject.LAIdMatrix.toString();
            var mode = document.getElementById('<%=hdnEditCap.ClientID%>').value;

            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editLA(" + "'" + idLA + "'" + "); />";
            return edit;
        }

        function editLA(idLA) {
            $('#<%=RTlblError.ClientID%>').text('');
            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            laMatrixInfo("../Transactions/frmLAMatrix.aspx?mode=" + hdEdit + "&laMatrixId=" + idLA + "&pageName=LACodeList");
        }        

        //To open the customer/vehicle page as modal popup
        function laMatrixInfo(page) {
            var $dialog = $('<div id="testdialog"></div>')
                           .html('<iframe id="testifr" style="border: 0px;" src="' + page + '" width="1000px" height="800px"></iframe>')
                           .dialog({
                               autoOpen: false,
                               modal: true,
                               height: 800,
                               width: 1000,
                               title: ""
                           });
            $dialog.dialog('open');
        }

        function loadLACodeList() {
            $('#divSrchLACodes').show();
            var laDeptCode = $('#<%=ddlDeptAccntCode.ClientID%> option:selected')[0].text;
            var laCustGrpCode = $('#<%=ddlCustGrpAccntCode.ClientID%> option:selected')[0].text;

            if ($('#<%=ddlCustGrpAccntCode.ClientID%>').val() == "0") {
                laCustGrpCode = "";
            }
            if ($('#<%=ddlDeptAccntCode.ClientID%>').val() == "0") {
                laDeptCode = "";
            }
            
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmLACodeList.aspx/FetchLACodeList",
                data: "{laDeptCode: '" + laDeptCode + "', laCustGrpCode:'" + laCustGrpCode + "'}",
                dataType: "json",
                async: false,
                success: function (Result) {
                    jQuery("#dgdLACodeList").jqGrid('clearGridData');
                    if (Result.d.length > 0) {
                        mydata = Result.d;                        
                        for (i = 0; i < Result.d.length; i++) {                            
                            jQuery("#dgdLACodeList").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdLACodeList").setGridParam({ rowNum: 100 }).trigger("reloadGrid");
                        //$("#dgdCreateInv").jqGrid("showCol", "subgrid");
                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }


        function delLACode() {
            var laId = "";
            $('#dgdLACodeList input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    laId = $('#dgdLACodeList tr ')[row].cells[8].innerHTML.toString();
                }
            });

            if (laId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteLACode();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }


        function deleteLACode() {
            var row;
            var laCodeId;
            var laCodeIdxml;
            var laCodeIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdLACodeList input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    laCodeId = $('#dgdLACodeList tr ')[row].cells[8].innerHTML.toString();
                    laCodeIdxml = '<DELETE ID_MATRIX= "' + laCodeId + '"/>';
                    laCodeIdxmls += laCodeIdxml;
                }
            });

            if (laCodeIdxmls != "") {
                laCodeIdxmls = "<root>" + laCodeIdxmls + "</root>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmLACodeList.aspx/DeleteLACodeList",
                    data: "{strXML: '" + laCodeIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdLACodeList").jqGrid('clearGridData');
                        loadLACodeList();
                        jQuery("#dgdLACodeList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0] == "SUCCESS") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d[0] == "ERROR") {
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

        function addLACode() {
            var hdEdit = "Add";
            idLA = "0";
            laMatrixInfo("../Transactions/frmLAMatrix.aspx?mode=" + hdEdit + "&laMatrixId=" + idLA + "&pageName=LACodeList");
        }

                     


    </script>
    
    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblViewACM" runat="server" Text="View Account Code Matrix"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdAccntCode" runat="server" />        
    </div>

    <div class="ui raised segment signup inactive">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
            <a class="item" id="a2" runat="server" >View Account Code Matrix</a>
        </div>
        <div>
            <div class="ui form" style="padding-left:2em;">
                <div class="four fields">
                    <div class="field" style="width:260px;">
                        <asp:Label ID="lblDeptAccntCode" runat="server" Text="Department Account Code"></asp:Label>
                    </div>
                    <div class="field">
                        <asp:DropDownList ID="ddlDeptAccntCode" runat="server" Width="150px"></asp:DropDownList>                    
                    </div>
                </div>
                <div class="four fields">
                    <div class="field" style="width:260px;">
                        <asp:Label ID="lblCustGrpAccntCode" runat="server" Text="Customer Group Account Code"></asp:Label>
                    </div>
                    <div class="field">
                        <asp:DropDownList ID="ddlCustGrpAccntCode" runat="server"  Width="150px"></asp:DropDownList>                      
                    </div>
                </div>
            </div>
            <div style="text-align:left;padding-bottom:4em;padding-left:15em;padding-top:2em">
                <input id="btnSearch" runat="server" type="button" value="Search" class="ui button"  onclick="loadLACodeList()"/>
            </div>
        </div>
        <div id="divSrchLACodes">
            <div class="field" style="text-align:center;padding-bottom:1em;">
                <input id="btnAddLACodeT" runat="server" type="button" value="Add" class="ui button"  onclick="addLACode()"/>
                <input id="btnDelLACodeT" runat="server" type="button" value="Delete" class="ui button"  onclick="delLACode()"/>
            </div>
            <div>       
                <table id="dgdLACodeList" title="LACodeList" ></table>
                <div id="pager"></div>
            </div>
            <div class="field" style="text-align:center;padding-top:1em;">
                <input id="btnAddLACodeB" runat="server" type="button" value="Add" class="ui button"  onclick="addLACode()"/>
                <input id="btnDelLACodeB" runat="server" type="button" value="Delete" class="ui button"  onclick="delLACode()"/>
            </div>            
        </div>
    </div>
</asp:Content>