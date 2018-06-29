<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CustomerImport.aspx.vb" Inherits="CARS.CustomerImport" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
<script type="text/javascript">
    function DoValidate() {

        if ($('#<%=txtExportTypeName.ClientID%>').val() == "") {
            var msg = GetMultiMessage('0022', GetMultiMessage('CONFIGEXPORTTYPE', '', ''), '');
            alert(msg);
            $('#<%=txtExportTypeName.ClientID%>').focus();
            return false;
        }
        if (($('#<%=rbFixed.ClientID%>').is(':checked')) != true && ($('#<%=rbDelimiter.ClientID%>').is(':checked')) != true) {
            var msg = GetMultiMessage('0007', GetMultiMessage('FU022', '', ''), '');
            alert(msg);
            return false;
        }
        if (($('#<%=rbDelimiter.ClientID%>').is(':checked')) == true) {
            if ($('#<%=ddlSpDelimiter.ClientID%>')[0].selectedIndex == 0 && ($('#<%=txtOtherDelimiter.ClientID%>').val() == "" || $('#<%=txtOtherDelimiter.ClientID%>').val() == null)) {
                var msg = GetMultiMessage('0007', GetMultiMessage('FU023', '', ''), '');
                alert(msg);
                return false;
            }
            else if ($('#<%=ddlSpDelimiter.ClientID%>').val() == 'Others') {
                if ($('#<%=txtOtherDelimiter.ClientID%>').val() == "") {
                    var msg = GetMultiMessage('0022', GetMultiMessage('FU023', '', ''), '');
                    alert(msg);
                    $('#<%=txtOtherDelimiter.ClientID%>').focus();
                    return false;
                }
            }
        }
        return true;
    }



    $(document).ready(function () {
        $('#<%=ddlSpDelimiter.ClientID%>').attr("disabled", "disabled");
        $('#<%=txtOtherDelimiter.ClientID%>').attr("disabled", "disabled");
        $('#divControls').hide();
        $('#divExpGrid').hide();
        loadImportListGrid();


        $('#<%=btnAdd1.ClientID%>').click(function () {
            jQuery("#dgdImportConfiguration").jqGrid('clearGridData');
            $('#divControls').show();
            $('#divExpGrid').show();
            $('#<%=txtExportTypeName.ClientID%>').val("");
            $('#<%=txtDesc.ClientID%>').val("");
            $('#<%=rbFixed.ClientID%>').attr('checked', false);
            $('#<%=rbDelimiter.ClientID%>').attr('checked', false);
            $('#<%=txtOtherDelimiter.ClientID%>').val("");
            $('#<%=ddlSpDelimiter.ClientID%>').val("Tab");
            var fileType = "IMPORT";
            var fullPath = window.location.href;
            var fileName = fullPath.replace(/^.*[\\\/]/, '');
            $(document.getElementById('<%=hdnTemplateId.ClientID%>')).val("0");
            $('#<%=ddlSpDelimiter.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            jQuery("#dgdImportConfiguration").jqGrid('clearGridData');
            loadImportConfigGrid(fileType, fileName, 0);
            var colPos = 2;
            var myGrid = $('#dgdImportConfiguration');
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
            myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos].name);
            myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);



        });

        $('#<%=btnAdd2.ClientID%>').click(function () {
            $('#divControls').show();
            $('#divExpGrid').show();
            $('#<%=txtExportTypeName.ClientID%>').val("");
            $('#<%=txtDesc.ClientID%>').val("");
            $('#<%=rbFixed.ClientID%>').attr('checked', false);
            $('#<%=rbDelimiter.ClientID%>').attr('checked', false);
            $('#<%=txtOtherDelimiter.ClientID%>').val("");
            $('#<%=ddlSpDelimiter.ClientID%>').val("Tab");
            var fileType = "IMPORT";
            var fullPath = window.location.href;
            var fileName = fullPath.replace(/^.*[\\\/]/, '');
            $(document.getElementById('<%=hdnTemplateId.ClientID%>')).val("0");
            $('#<%=ddlSpDelimiter.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            jQuery("#dgdImportConfiguration").jqGrid('clearGridData');
            loadImportConfigGrid(fileType, fileName, 0);
            var colPos = 2;
            var myGrid = $('#dgdImportConfiguration');
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
            myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
            myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos].name);
            myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);

        });

        $("input[id$='rbFixed']").change(function () {
            if ($(this).is(":checked")) {
                $('#<%=ddlSpDelimiter.ClientID%>').attr("disabled", "disabled");
                var fileType = "IMPORT";
                var fullPath = window.location.href;
                var fileName = fullPath.replace(/^.*[\\\/]/, '');
                jQuery("#dgdImportConfiguration").jqGrid('clearGridData');
                if ($('#<%=hdnMode.ClientID%>').val() == "Edit") {
                    var templateId = $('#<%=hdnTemplateId.ClientID%>').val()
                    loadImportConfigGrid(fileType, fileName, templateId);


                }
                else {
                    loadImportConfigGrid(fileType, fileName, 0);

                }

                var colPos = 2;
                var myGrid = $('#dgdImportConfiguration');
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
                myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 2].name);
               //Grid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);
            }

        });


        $("input[id$='rbDelimiter']").change(function () {
            if ($(this).is(":checked")) {
                $('#<%=ddlSpDelimiter.ClientID%>').removeAttr("disabled");
                var fileType = "IMPORT";
                var fullPath = window.location.href;
                var fileName = fullPath.replace(/^.*[\\\/]/, '');
                jQuery("#dgdExportConfiguration").jqGrid('clearGridData');
                if ($('#<%=hdnMode.ClientID%>').val() == "Edit") {
                    var templateId = $('#<%=hdnTemplateId.ClientID%>').val()
                    loadImportConfigGrid(fileType, fileName, templateId);

                }
                else {
                    loadImportConfigGrid(fileType, fileName, 0);

                }
                var colPos = 2;
                var myGrid = $('#dgdImportConfiguration');
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
                myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
                myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos].name);
                myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);
            }

        });

        $('#<%=ddlSpDelimiter.ClientID%>').change(function (e) {
            var delim = $('#<%=ddlSpDelimiter.ClientID%>').val();
            if (delim == "Others") {
                $('#<%=txtOtherDelimiter.ClientID%>').removeAttr("disabled");
            }
            else {
                $('#<%=txtOtherDelimiter.ClientID%>').attr("disabled", "disabled");
            }
        });

        $('#<%=ddlCharSet.ClientID%>').change(function (e) {
            var CharSet = $('#<%=ddlCharSet.ClientID%>').val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "CustomerExport.aspx/loadCharSetControls",
                data: "{'CharSet':'" + CharSet + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    data = data.d;
                    var decDelim = data[0].DecimalDelimiter;
                    $('#<%=ddlDecDelimiter.ClientID%>').append($("<option></option>").val(decDelim).html(decDelim));
                    $('#<%=ddlThousDelimiter.ClientID%>').append($("<option></option>").val(data[0].ThousandsDelimiter).html(data[0].ThousandsDelimiter));
                    $('#<%=ddlDate.ClientID%>').append($("<option></option>").val(data[0].DateFormat).html(data[0].DateFormat));
                    $('#<%=ddlTime.ClientID%>').append($("<option></option>").val(data[0].TimeFormat).html(data[0].TimeFormat));

                    $('#<%=ddlDecDelimiter.ClientID%> option:contains("' + data[0].DecimalDelimiter + '")').attr('selected', 'selected');
                    $('#<%=ddlThousDelimiter.ClientID%> option:contains("' + data[0].ThousandsDelimiter + '")').attr('selected', 'selected');
                    $('#<%=ddlDate.ClientID%> option:contains("' + data[0].DateFormat + '")').attr('selected', 'selected');
                    $('#<%=ddlTime.ClientID%> option:contains("' + data[0].TimeFormat + '")').attr('selected', 'selected');

                }
            });
        });



        $('#<%=btnSave.ClientID%>').click(function () {
            SaveImportConfiguration();
        });
        $('#<%=btnCancel.ClientID%>').click(function () {
            $('#divControls').hide();
            $('#divExpGrid').hide();
            $('#<%=txtExportTypeName.ClientID%>').val("");
            $('#<%=txtDesc.ClientID%>').val("");
            $('#<%=rbFixed.ClientID%>').attr('checked', false);
            $('#<%=rbDelimiter.ClientID%>').attr('checked', false);
            jQuery("#dgdImportList").jqGrid('clearGridData');
            $('#<%=RTlblError.ClientID%>').text("");
            loadImportListGrid();
        });





    });//end of ready
    function loadImportListGrid() {
        var grid = $("#dgdImportList");
        var fileType = "IMPORT";
        var fullPath = window.location.href;
        var fileName = fullPath.replace(/^.*[\\\/]/, '');
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var mydata;
        grid.jqGrid({
            datatype: "local",
            data: mydata,
            colNames: ['ID', 'Import Type Name', 'Description',''],
            colModel: [
                     { name: 'TemplateId', index: 'TemplateId', width: 60, sorttype: "string" },
                     { name: 'TemplateName', index: 'TemplateName', width: 200, sorttype: "string" },
                     { name: 'Description', index: 'Description', width: 390, sorttype: "string" },
                     { name: 'TemplateId', index: 'TemplateId', sortable: false, formatter: editList }
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
            url: "CustomerImport.aspx/LoadImportListGrd",
            data: "{'fileType':'" + fileType + "','fileName':'" + fileName + "'}",
            dataType: "json",
            async: false,//Very important
            success: function (data) {
                for (i = 0; i < data.d.length; i++) {
                    mydata = data;
                    jQuery("#dgdImportList").jqGrid('addRowData', i + 1, mydata.d[i]);
                }
            }
        });

        jQuery("#dgdImportList").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
        $("#dgdImportList").jqGrid("hideCol", "subgrid");
    }

    function editList(cellvalue, options, rowObject) {
        var templateId = rowObject.TemplateId.toString();
        $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit");
        $(document.getElementById('<%=hdnTemplateId.ClientID%>')).val(templateId);
        var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
        var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=loadImpConfig(" + "'" + templateId + "'); />";
        return edit;
    }
    function loadImpConfig(templateId) {
        debugger;
        $('#divControls').show();
        $('#divExpGrid').show();
        var templateId = templateId;
        var fileType = "IMPORT";
        var fullPath = window.location.href;
        var fileName = fullPath.replace(/^.*[\\\/]/, '');
        loadAllControls(fileType, fileName, templateId);
        jQuery("#dgdImportConfiguration").jqGrid('clearGridData');
        loadImportConfigGrid(fileType, fileName, templateId);
    }
    function loadAllControls(fileType, fileName, templateId) {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "CustomerImport.aspx/loadControls",
            data: "{'fileType':'" + fileType + "','fileName':'" + fileName + "','templateId':'" + templateId + "'}",
            dataType: "json",
            async: false,//Very important
            success: function (data) {
                data = data.d;
                var fileMode;
                $('#<%=txtExportTypeName.ClientID%>').val(data[0].TemplateName);
                $('#<%=txtDesc.ClientID%>').val(data[0].Description);
                $('#<%=txtOtherDelimiter.ClientID%>').val(data[0].DelimiterOther);
                $('#<%=ddlCharSet.ClientID%>').val(data[0].CharacterSet);
                $('#<%=ddlDecDelimiter.ClientID%>').empty();
                $('#<%=ddlThousDelimiter.ClientID%>').empty();
                $('#<%=ddlDate.ClientID%>').empty();
                $('#<%=ddlTime.ClientID%>').empty();
                var decDelim = data[0].DecimalDelimiter;
                $('#<%=ddlDecDelimiter.ClientID%>').append($("<option></option>").val(decDelim).html(decDelim));
                $('#<%=ddlThousDelimiter.ClientID%>').append($("<option></option>").val(data[0].ThousandsDelimiter).html(data[0].ThousandsDelimiter));
                $('#<%=ddlDate.ClientID%>').append($("<option></option>").val(data[0].DateFormat).html(data[0].DateFormat));
                $('#<%=ddlTime.ClientID%>').append($("<option></option>").val(data[0].TimeFormat).html(data[0].TimeFormat));

                $('#<%=ddlDecDelimiter.ClientID%> option:contains("' + data[0].DecimalDelimiter + '")').attr('selected', 'selected');
                $('#<%=ddlThousDelimiter.ClientID%> option:contains("' + data[0].ThousandsDelimiter + '")').attr('selected', 'selected');
                $('#<%=ddlDate.ClientID%> option:contains("' + data[0].DateFormat + '")').attr('selected', 'selected');
                $('#<%=ddlTime.ClientID%> option:contains("' + data[0].TimeFormat + '")').attr('selected', 'selected');
                fileMode = data[0].FileMode;
                $('#<%=hdnFileMode.ClientID%>').val(fileMode);
                if (fileMode == "FIXED") {
                    $('#<%=rbFixed.ClientID%>').attr('checked', 'checked');
                    $('#<%=ddlSpDelimiter.ClientID%>').attr("disabled", "disabled");
                }
                else {
                    $('#<%=rbDelimiter.ClientID%>').attr('checked', 'checked');
                    $('#<%=ddlSpDelimiter.ClientID%>').removeAttr("disabled");
                }

                $('#<%=ddlSpDelimiter.ClientID%>').val(data[0].SpecialDelimiter);
                if ($('#<%=ddlSpDelimiter.ClientID%>').val() == "Others") {
                    $('#<%=txtOtherDelimiter.ClientID%>').removeAttr("disabled");
                }
                else {
                    $('#<%=txtOtherDelimiter.ClientID%>').attr("disabled", "disabled");
                }
            }
        });
    }

    function loadImportConfigGrid(fileType, fileName, templateId) {
        var grid = $("#dgdImportConfiguration");
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var mydata;
        grid.jqGrid({
            datatype: "local",
            data: mydata,
            colNames: ['FieldName', 'PostionFrom', 'FieldLength', 'OrderInFile', 'DecimalDivide', 'FixedInformation', 'FieldId', 'IsDecimalDivide'],
            colModel: [

                     { name: 'FieldName', index: 'FieldName', width: 390, sorttype: "string" },
                     { name: 'PositionFrom', index: 'PositionFrom', width: 120, sorttype: "string", editable: true, editrules: { custom: true, custom_func: ValidateNumber } },
                     { name: 'Length', index: 'Length', width: 120, sorttype: "string", editable: true, editrules: { custom: true, custom_func: ValidateNumber } },
                     { name: 'OrderInFile', index: 'OrderInFile', width: 120, sorttype: "string", editable: true, editrules: { custom: true, custom_func: ValidateNumber } },
                     { name: 'DecimalDivide', index: 'DecimalDivide', width: 120, sorttype: "string" },
                     { name: 'FixedInformation', index: 'FixedInformation', width: 120, sorttype: "string", editable: true, editrules: { custom: true, custom_func: ValidateAlphabets } },
                      { name: 'FieldId', index: 'FieldId', width: 390, sorttype: "string", hidden: true },
                       { name: 'IsDecimalDivide', index: 'IsDecimalDivide', width: 20, sorttype: "string", hidden: true },

            ],
            multiselect: false,
            pager: jQuery('#pagerImportConfiguration'),
            rowNum: pageSize,//can fetch from webconfig
            rowList: 5,
            sortorder: 'asc',
            viewrecords: true,
            height: "50%",
            autoWidth: true,
            shrinkToFit: true,
            caption: "Customer  Import List",
            async: false, //Very important,
            subgrid: false,
            'cellEdit': true,
            'cellsubmit': "clientArray",
            editurl: "clientArray",
            onCellSelect: function (rowid) {
                var rowData = $(this).jqGrid("getRowData", rowid);
                if (rowData.IsDecimalDivide == 'False') {
                    jQuery('#dgdImportConfiguration').setColProp('DecimalDivide', { editable: false });
                }
                else {
                    jQuery('#dgdImportConfiguration').setColProp('DecimalDivide', { editable: true });

                }
                // now you can use rowData.name2, rowData.name3, rowData.name4 ,...
            },
            gridComplete: function () {
                var rowData = $('#dgdImportConfiguration').jqGrid('getGridParam', 'data');
                for (var i = 0; i < rowData.length; i++) {
                    var row = rowData[i];
                    var rowid = row.id;
                    if (row.IsDecimalDivide == "False") {
                        grid.jqGrid('setCell', rowid, "DecimalDivide", "", {
                            'background-color': '#e0e1e2',
                            'color': 'rgba(0, 0, 0, 0.6)',
                            'background-image': 'none'
                        });
                    }
                    // $('#dgdExportConfiguration').jqGrid('setRowData', rowid, false, { color: 'white', weightfont: 'bold', background: 'blue' });
                }
            }


        });

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "CustomerImport.aspx/BindImportConfig",
            data: "{'fileType':'" + fileType + "','fileName':'" + fileName + "','templateId':'" + templateId + "'}",
            dataType: "json",
            async: false,//Very important
            success: function (data) {
                debugger;
                if (data.d[0].FileMode = "Fixed") {
                    for (i = 1; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdImportConfiguration").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                    var colPos = 2;
                    var myGrid = $('#dgdImportConfiguration');
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 2].name);
                }
                if (data.d[0].FileMode = "Delimiter") {
                    for (i = 1; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdImportConfiguration").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                    var colPos = 2;
                    var myGrid = $('#dgdImportConfiguration');
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 2].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 3].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 4].name);
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos].name);
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                }
            }
        });

        jQuery("#dgdImportConfiguration").setGridParam({ rowNum: 20 }).trigger("reloadGrid");
        $("#dgdImportConfiguration").jqGrid("hideCol", "subgrid");
    }
 

    function ValidateNumber(value) {
        var val = value;
        var val_Length = value.length;
        if (isNaN(val) || (val < 0)) {


            msg = GetMultiMessage('0090', '', '')
            //alert(msg);
            return [false, msg];
        }
        for (i = 0; i < val_Length; i++) {
            str = val.charCodeAt(i);
            if ((str == 46) || (str == 101) || (str == 32) || (str == 45) || (str == 43)) {
                //alert(GetMultiMessage('MSGGERR1', '', ''));
                msg = GetMultiMessage('MSGGERR1', '', '')
                return [false, msg];
            }
        }
        return [true];
    }

    function ValidateAlphabets(value) {
        var val = value;

        if (val != undefined) {
            var val_Length = value.length;

            for (i = 0; i < val_Length; i++) {
                var iChars = ";=&\\\'\""; //"&='\\""?";
                if (iChars.indexOf(val.charAt(i)) != -1) {
                    var msg = GetMultiMessage('0012', '', '');
                    return [false, msg];
                }
            }
            return [true];
        }
    }

    function ValidateNumDot(value) {
        var FieldValue;
        var msg
        var FieldLength;
        var Onechar;
        var dotcount = 0;
        FieldValue = value;
        FieldLength = FieldValue.length;

        Onechar = FieldValue.charAt(0);
        //to check each charecter lies in between the numbers and dots.
        for (IntCount = 0; IntCount < FieldLength; IntCount++) {
            Onechar = FieldValue.charAt(IntCount);
            if ((Onechar < "0" || Onechar > "9") && Onechar != "." && Onechar != "," && Onechar != " ") {
                if (field.id == 'txtMileage')
                    msg = GetMultiMessage('MSGGERR15', '', '');
                    //alert(GetMultiMessage('MSGGERR15', '', ''));
                else
                    msg = GetMultiMessage('MSGGERR11', '', '');
                //alert(GetMultiMessage('MSGGERR11', '', ''));
                return [false, msg];
            }
            if (Onechar == ".") {
                dotcount = dotcount + 1
            }
        }
        if (dotcount > 1) {
            var msg = GetMultiMessage('0162', '', '');
            return [false, msg];
        }
        return [true];
    }
    function SaveImportConfiguration() {
        var bool = DoValidate();
        if (bool == true) {
            if ($('#<%=hdnTemplateId.ClientID%>').val() == "0") {
                var templateId = 0;
            }
            else {
                var templateId = $('#<%=hdnTemplateId.ClientID%>').val();

            }
            var fileType = "IMPORT"
            var fullPath = window.location.href;
            var fileName = fullPath.replace(/^.*[\\\/]/, '');
            var importTypeName = $('#<%=txtExportTypeName.ClientID%>').val();
            var charSet = $('#<%=ddlCharSet.ClientID%>').val();
            var decimalDelim = $('#<%=ddlDecDelimiter.ClientID%>').find('option:selected').text();
            var thouDelim = $('#<%=ddlThousDelimiter.ClientID%>').find('option:selected').text();
            var dateFormat = $('#<%=ddlDate.ClientID%>').find('option:selected').text();
            var timeFormat = $('#<%=ddlTime.ClientID%>').find('option:selected').text();
            if ($('#<%=rbFixed.ClientID%>').is(':checked')) {
                var fileMode = "FIXED"
            }
            else {
                var fileMode = "DELIMITER"
            }


            var otherDelimiter = $('#<%=txtOtherDelimiter.ClientID%>').val();
            var splDelimiter = $('#<%=ddlSpDelimiter.ClientID%>').val();
            var desc = $('#<%=txtDesc.ClientID%>').val();
            var StrIntXML = "";
            var StrIntXMLs = "";
            var rowData = $('#dgdImportConfiguration').jqGrid('getGridParam', 'data');
            var fieldcnt = 0;
            for (var i = 0; i < rowData.length; i++) {
                var fieldId = rowData[i].FieldId;
                var positionFrom = rowData[i].PositionFrom;
                if (positionFrom == null) {
                    positionFrom = ""
                }
                else {
                    if (positionFrom !== "") {
                        ValidateNumber(positionFrom);
                    }
                }
                var fldlength = rowData[i].Length;
                if (fldlength == null) {
                    fldlength = ""
                }
                else {
                    if (fldlength !== "") {
                        ValidateNumber(fldlength);
                    }
                }

                if (fileMode == "FIXED") {
                    for (var k = 0; k < rowData.length; k++) {
                        var posFrom = rowData[k].PositionFrom;
                        var fieldlength = rowData[k].Length;
                        if (rowData[k].FieldName == "Kundenr")
                        {
                            if (((posFrom == "") || (posFrom == null)) && ((fieldlength == "") || (fieldlength == null)))
                            {
                                var msg = GetMultiMessage('0022', GetMultiMessage(rowData[k].FieldName, '', ''), '');
                                alert(msg);
                                return false;
                            }

                            else if (((posFrom != "") || (posFrom != null)) && ((fieldlength == "") || (fieldlength == null))) {
                                        alert(GetMultiMessage('FU009', '', ''));
                                        return false;
                               
                            }

                            else if (((posFrom == "") || (posFrom == null)) && ((fieldlength != "") || (fieldlength != null))) {
                                        alert(GetMultiMessage('FU009', '', ''));
                                        return false;
                            }
                        }

                        if (rowData[k].FieldName == "Kundenavn") {
                            if (((posFrom == "") || (posFrom == null)) && ((fieldlength == "") || (fieldlength == null))) {
                                var msg = GetMultiMessage('0022', GetMultiMessage(rowData[k].FieldName, '', ''), '');
                                alert(msg);
                                return false;
                            }

                            else if (((posFrom != "") || (posFrom != null)) && ((fieldlength == "") || (fieldlength == null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;

                            }

                            else if (((posFrom == "") || (posFrom == null)) && ((fieldlength != "") || (fieldlength != null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;
                            }
                        }

                        if (rowData[k].FieldName == "Kundegruppe") {
                            if (((posFrom == "") || (posFrom == null)) && ((fieldlength == "") || (fieldlength == null))) {
                                var msg = GetMultiMessage('0022', GetMultiMessage(rowData[k].FieldName, '', ''), '');
                                alert(msg);
                                return false;
                            }

                            else if (((posFrom != "") || (posFrom != null)) && ((fieldlength == "") || (fieldlength == null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;

                            }

                            else if (((posFrom == "") || (posFrom == null)) && ((fieldlength != "") || (fieldlength != null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;
                            }
                        }

                        if (rowData[k].FieldName == "Betalingsbetingelser") {
                            if (((posFrom == "") || (posFrom == null)) && ((fieldlength == "") || (fieldlength == null))) {
                                var msg = GetMultiMessage('0022', GetMultiMessage(rowData[k].FieldName, '', ''), '');
                                alert(msg);
                                return false;
                            }

                            else if (((posFrom != "") || (posFrom != null)) && ((fieldlength == "") || (fieldlength == null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;

                            }

                            else if (((posFrom == "") || (posFrom == null)) && ((fieldlength != "") || (fieldlength != null))) {
                                alert(GetMultiMessage('FU009', '', ''));
                                return false;
                            }
                        }
                        
                    }
                }

                if (fileMode == "DELIMITER") {
                    if (fieldlength != '') {
                        fieldcnt = 1;
                    }
                }

                if (fileMode == "FIXED") {
                    if (posFrom != '') {
                        fieldcnt = 1;
                    }
                }

                //if (fieldcnt != 1) {
                //    var msg = GetMultiMessage('0100', '', '');
                //    alert(msg);
                //    return false;
                //}


                var ordInFile = rowData[i].OrderInFile;
                if (ordInFile == null) {
                    ordInFile = ""
                }
                else {
                    if (ordInFile !== "") {
                        ValidateNumber(ordInFile);
                    }
                }
                var decimalDivide = rowData[i].DecimalDivide;
                if (decimalDivide == null) {
                    decimalDivide = ""
                }
                else {
                    if (decimalDivide !== "") {
                        ValidateNumDot(decimalDivide);
                    }
                }
                var fxdInfo = rowData[i].FixedInformation;
                if (fxdInfo == null) {
                    fxdInfo = ""
                }
                else {
                    if (fxdInfo !== "") {
                        ValidateAlphabets(fxdInfo);
                    }
                }
                var encChar = rowData[i].EnclosingChar;
                if (encChar == null) {
                    encChar = ""
                }
                StrIntXML = '<Configuration TEMPLATE_ID= "' + templateId + '" FIELD_ID= "' + fieldId + '" POSITION_FROM= "' + positionFrom +
                    '" FIELD_LENGTH= "' + fldlength + '" ORDER_IN_FILE= "' + ordInFile + '" DECIMAL_DIVIDE= "' + decimalDivide + '" FIXED_VALUE= "' + fxdInfo + '" FIELD_ENCLOSING_CH= "' + encChar + '"/>'
                StrIntXMLs += StrIntXML;
            }
            StrIntXMLs = "<ROOT>" + StrIntXMLs + "</ROOT>";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "CustomerImport.aspx/SaveImportConfig",
                data: "{'fileType':'" + fileType + "','fileName':'" + fileName + "','templateId':'" + templateId + "','importTypeName':'" + importTypeName + "','charSet':'" + charSet + "','decimalDelim':'" + decimalDelim + "','thouDelim':'" + thouDelim +
                    "','dateFormat':'" + dateFormat + "','timeFormat':'" + timeFormat + "','fileMode':'" + fileMode + "','otherDelimiter':'" + otherDelimiter + "','desc':'" + desc + "','Configuration':'" + StrIntXMLs + "','splDelimiter':'" + splDelimiter + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    data = data.d
                    if (data != "") {
                        $('#<%=RTlblError.ClientID%>').text(data);
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        jQuery("#dgdImportList").jqGrid('clearGridData');
                        $('#divControls').hide();
                        $('#divExpGrid').hide();
                        loadImportListGrid();

                    }
                }
            });
        }
    }

    function deleteExpConfig() {
        var idPTseq = "";
        $('#dgdImportList input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                idPTseq = $('#dgdImportList tr ')[row].cells[1].innerHTML.toString();
            }
        });

        if (idPTseq != "") {
            var msg = GetMultiMessage('0016', '', '');
            var r = confirm(msg);
            if (r == true) {
                delExpConfig();
            }
        }
        else {
            var msg = GetMultiMessage('SelectRecord', '', '');
            alert(msg);
        }
    }

    function delExpConfig() {
        var row;
        var templateId;
        var fileType = "IMPORT"
        var fullPath = window.location.href;
        var fileName = fullPath.replace(/^.*[\\\/]/, '');
        var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
        var resultmsg = "";

        $('#dgdImportList input:checkbox').attr("checked", function () {
            if (this.checked) {
                row = $(this).closest('td').parent()[0].sectionRowIndex;
                templateId = $('#dgdImportList tr ')[row].cells[2].innerHTML.toString();
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "CustomerImport.aspx/DeleteImportConfig",
                    data: "{templateId: '" + templateId + "',FileType: '" + fileType + "',fileName: '" + fileName + "'}",
                    dataType: "json",
                    success: function (data) {
                        var result = data.d;
                        result = templateId + result;
                        resultmsg += result
                        jQuery("#dgdImportList").jqGrid('clearGridData');
                        $('#divControls').hide();
                        $('#divExpGrid').hide();
                        loadImportListGrid();
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
            $('#<%=RTlblError.ClientID%>').text(resultmsg);

        });

    }


</script>
    <div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Customer Import"></asp:Label>
    <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
    <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
     <asp:HiddenField id="hdnMode" runat="server" /> 
     <asp:HiddenField id="hdnTemplateId" runat="server" Value="" /> 
     <asp:HiddenField id="hdnFileMode" runat="server" Value="" />
</div>
     <div id="divCfInvDetails" class="ui raised segment signup inactive">
         <div class="six fields">
             <div style="text-align:center">
                <input id="btnAdd1" runat="server" class="ui button"  value="Add" type="button"   />
                 <input id="btnDelete1" runat="server" class="ui button" value="Delete" type="button" onclick="deleteExpConfig()" />
            </div>
         </div>
         <div style="padding:0.5em"></div>
         <div>
             <table id="dgdImportList"></table>
                <div id="pagerImportList"></div>
         </div>
         <div class="six fields">
             <div style="text-align:center">
                <input id="btnAdd2" runat="server" class="ui button"  value="Add" type="button"   />
                 <input id="btnDelete2" runat="server" class="ui button" value="Delete" type="button" onclick="deleteExpConfig()" />
            </div>
         </div>
         <div id="divControls">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A3" runat="server" class="active item">Main Information</a>  
         </div> 
          <div style="padding:0.5em"></div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblExportType" runat="server" Text="Export Type Name" Width="180px"></asp:Label>
              <asp:TextBox ID="txtExportTypeName" runat="server" Width="200px"></asp:TextBox>                  
             <asp:Label ID="lblCharSet" runat="server" Text="Character Set" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlCharSet" runat="server" Width="160px"></asp:DropDownList>
         </div>

      </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="Label1" runat="server" Text="" Width="180px"></asp:Label>
               <asp:Label ID="Label8" runat="server" Text="" Width="200px"></asp:Label>               
             <asp:Label ID="lblDecimal" runat="server" Text="Decimal Delimiter" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlDecDelimiter" runat="server" Width="160px"></asp:DropDownList>
         </div>
     </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="Label2" runat="server" Text="" Width="180px"></asp:Label>
              <asp:Label ID="Label7" runat="server" Text="" Width="200px"></asp:Label>               
             <asp:Label ID="lblThousand" runat="server" Text="Thousands Delimiter" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlThousDelimiter" runat="server" Width="160px"></asp:DropDownList>
         </div>
     </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="Label3" runat="server" Text="" Width="180px"></asp:Label>
               <asp:Label ID="Label6" runat="server" Text="" Width="200px"></asp:Label>                
             <asp:Label ID="lblDate" runat="server" Text="Date" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlDate" runat="server" Width="160px"></asp:DropDownList>
         </div>
     </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="Label4" runat="server" Text="" Width="180px"></asp:Label>
              <asp:Label ID="Label9" runat="server" Text="" Width="200px"></asp:Label>                  
             <asp:Label ID="lblTime" runat="server" Text="Time" Width="180px" ></asp:Label>
             <asp:DropDownList ID="ddlTime" runat="server" Width="160px"></asp:DropDownList>
         </div>
     </div>

          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblFile" runat="server" Text="File" Width="180px"></asp:Label>
              <asp:RadioButton ID="rbFixed" name="postage" GroupName="rbFile" runat="server" Text="Fixed Length" />                 
             <asp:RadioButton ID="rbDelimiter" Width="195px" GroupName="rbFile" runat="server" Text="Delimiter"  />
         </div>
     </div>
         <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="Label5" runat="server" Text="" Width="180px"></asp:Label>
             <asp:DropDownList ID="ddlSpDelimiter" runat="server" CssClass="drpdwm" Width="105px">
                                            <asp:ListItem Value="\t">Tab</asp:ListItem>
                                            <asp:ListItem Value=";">Semicolon</asp:ListItem>
                                            <asp:ListItem Value=",">Comma</asp:ListItem>
                                            <asp:ListItem Value=" ">Space</asp:ListItem>
                                            <asp:ListItem Value="Others">Others</asp:ListItem>
             </asp:DropDownList>
             <asp:TextBox ID="txtOtherDelimiter" runat="server" Width="40px" />
         </div>
     </div>
          <div class="six fields" style="border-color:#e5e5e5;border-style: solid;border-width: 1px;height:31px">
              <div class="field" style="padding:0.55em;height:40px">
             <asp:Label ID="lblDesc" runat="server" Text="Description" Width="180px"></asp:Label>
             <asp:TextBox ID="txtDesc" runat="server" Width="500px"/>
         </div>
     </div>
             </div>
         <div id="divExpGrid">
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A1" runat="server" class="active item">File Information</a>  
         </div>
      <div>
             <table id="dgdImportConfiguration"></table>
                <div id="pagerImportConfiguration"></div>
         </div>

        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a id="A2" runat="server" class="active item">Condition for Import   
        </a>  
         </div>
             <div>
             <table id="dgdImportCondition"></table>
                <div id="pagerImportCondition"></div>
         </div>

        <div style="padding:0.5em"></div>
              <div style="text-align:center">
                <input id="btnSave" runat="server" class="ui button"  value="Save" type="button"   />
                 <input id="btnCancel" runat="server" class="ui button" value="Cancel" type="button" />
            </div>
</div>
      </div><!--MAin Div-->

    </asp:Content>
