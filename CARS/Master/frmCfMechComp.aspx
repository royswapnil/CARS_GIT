<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfMechComp.aspx.vb" Inherits="CARS.frmCfMechComp" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 


    <script type="text/javascript">

        function fnValidateCompLevel() {
            if (!(gfi_CheckEmpty($('#<%=txtCompLevelCode.ClientID%>'), '0210'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtCompLevelCode.ClientID%>'), '0210'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtCompLevelDesc.ClientID%>'), '0211'))) {
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtCompLevelDesc.ClientID%>'), '0211'))) {
                return false;
            }

            var compLevel = $('#<%=txtCompLevelCode.ClientID%>').val();
            var chkcompLevel = compLevel.split(" ");
            if(chkcompLevel.length >1){
               var msg=GetMultiMessage('0116',GetMultiMessage('0210','',''),'');
               alert(msg);
                return false;
            }

            return true;
        }

        function fnValidateMechCost() {

            if (!(gfi_CheckEmpty($('#<%=txtCostTime.ClientID%>'), '0212'))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtCostPerHour.ClientID%>'), '0213'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtCostToGarage.ClientID%>'), '0214'))) {
                return false;
            }
            
            if (!(fn_ValidateDecimal(document.getElementById('<%=txtCostTime.ClientID%>'), '<%= Session("Decimal_Seperator") %>'))) {
                var msg = GetMultiMessage('0116', GetMultiMessage('0212', '', ''), '');
                alert(msg);
                $('#<%=txtCostTime.ClientID%>').focus();
                return false;
            }

            if (!(fn_ValidateDecimal(document.getElementById('<%=txtCostPerHour.ClientID%>'), '<%= Session("Decimal_Seperator") %>'))) {
                var msg = GetMultiMessage('0116', GetMultiMessage('0213', '', ''), '');
                alert(msg);
                $('#<%=txtCostPerHour.ClientID%>').focus();
                return false;
            }

            if (!(fn_ValidateDecimal(document.getElementById('<%=txtCostToGarage.ClientID%>'), '<%= Session("Decimal_Seperator") %>'))) {
                var msg = GetMultiMessage('0116', GetMultiMessage('0214', '', ''), '');
                alert(msg);
                $('#<%=txtCostToGarage.ClientID%>').focus();
                return false;
            }
            return true;
        }


        $(document).ready(function () {
            //$('#divProdGrp').hide();
            $('#divCompLevel').hide();
            $('#divMechComp').hide();
            $('#divMechCost').hide();
            $("#accordion").accordion();
            $("#accordion div").css({ 'height': 'auto' });
            var mydata, mechcompcostdata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var gridCompLevel = $("#dgdCompLevel");
            var gridMechComp = $("#dgdMechComp");
            var gridMechCost = $("#dgdMechCost");

            //Comeptency Levels
            gridCompLevel.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Level Code', 'Description', 'HiIdCompt', ''],
                colModel: [
                         { name: 'IdCompt', index: 'IdCompt', width: 160, sorttype: "string" },
                         { name: 'Compt_Description', index: 'Compt_Description', width: 160, sorttype: "string" },
                         { name: 'HiIdCompt', index: 'HiIdCompt', width: 160, sorttype: "string", hidden: true },
                         { name: 'IdCompt', index: 'IdCompt', sortable: false, formatter: editCompLevel }
                ],
                multiselect: true,
                pager: jQuery('#pagerCompLevel'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "CompLevel",
                async: false, //Very important,
                subgrid: false

            });

            //Mechanic Competency
            gridMechComp.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Mechanic Id', 'Price Code', 'Competency Code','IdSeq', ''],
                colModel: [
                         { name: 'MechanicId', index: 'MechanicId', width: 160, sorttype: "string" },
                         { name: 'PriceCode', index: 'PriceCode', width: 160, sorttype: "string" },
                         { name: 'CompetencyCode', index: 'CompetencyCode', width: 160, sorttype: "string" },
                         { name: 'IdSeq', index: 'IdSeq', width: 160, sorttype: "string",hidden:true },
                         { name: 'IdSeq', index: 'IdSeq', sortable: false, formatter: editMechComp }
                ],
                multiselect: true,
                pager: jQuery('#pagerMechComp'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "MechComp",
                async: false, //Very important,
                subgrid: false

            });

            //Mechanic Cost
            gridMechCost.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Cost Time', 'Cost Per Hour', 'Cost of Garage', 'IdMech','IdSeq', ''],
                colModel: [
                         { name: 'CostTime', index: 'CostTime', width: 160, sorttype: "string" },
                         { name: 'CostHour', index: 'CostHour', width: 160, sorttype: "string" },
                         { name: 'CostGarage', index: 'CostGarage', width: 160, sorttype: "string" },
                         { name: 'IdMech', index: 'IdMech', width: 160, sorttype: "string", hidden: true },
                         { name: 'IdSeq', index: 'IdSeq', width: 160, sorttype: "string", hidden: true },
                         { name: 'IdSeq', index: 'IdSeq', sortable: false, formatter: editMechCost }
                ],
                multiselect: true,
                pager: jQuery('#pagerMechCost'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "MechCost",
                async: false, //Very important,
                subgrid: false

            });

            loadCompLevelDetails();
            loadMechCompDetails();
            loadPCCompCode();
                       

        }); //end of ready

        function loadCompLevelDetails() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfMechComp.aspx/LoadCompLevel",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdCompLevel").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdCompLevel").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdCompLevel").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdCompLevel").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function loadMechCompDetails() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfMechComp.aspx/LoadMechComp",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdMechComp").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdMechComp").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdMechComp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdMechComp").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function loadPCCompCode() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfMechComp.aspx/LoadPCCompCode",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        loadPriceCode(data.d[0]);
                        loadCompCode(data.d[1]);
                    }
                }
            });
        }

        function loadPriceCode(data) {
            $('#<%=ddlPriceCode.ClientID%>').empty();
            $('#<%=ddlPriceCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            //data = data.d;
            $.each(data, function (key, value) {
                $('#<%=ddlPriceCode.ClientID%>').append($("<option></option>").val(value.IdSettings).html(value.Description));
            });
            return true;
        }

        function loadCompCode(data) {
            $('#<%=lstCompCode.ClientID%>').empty();
            //$('#<%=lstCompCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            //data = data.d;
            $.each(data, function (key, value) {
                $('#<%=lstCompCode.ClientID%>').append($("<option></option>").val(value.IdCompt).html(value.IdCompt));
            });
            return true;
        }


        function editCompLevel(cellvalue, options, rowObject) {
            var idCompt = rowObject.IdCompt.toString();
            var compLevelDesc = rowObject.Compt_Description.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            //var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editCompLevelDetails(" + "'" + idCompt + "','" + compLevelDesc + "'" + "); />";
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editCompLevelDetails(" + "'" + idCompt + "'" + "); />";
            return edit;
        }

        function editCompLevelDetails(idCompt) {
            //$('#<%=txtCompLevelDesc.ClientID%>').val(compLevelDesc);
            $('#<%=txtCompLevelCode.ClientID%>').val(idCompt);
            $('#<%=hdnCompLevelId.ClientID%>').val(idCompt);
            getMechCompLevelDetails(idCompt);
            $('#divCompLevel').show();
            $('#<%=btnAddCompLevelT.ClientID%>').hide();
            $('#<%=btnAddCompLevelB.ClientID%>').hide();
            $('#<%=btnDelCompLevelT.ClientID%>').hide();
            $('#<%=btnDelCompLevelB.ClientID%>').hide();
            $('#<%=btnSaveCompLevel.ClientID%>').show();
            $('#<%=btnResetCompLevel.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");

        }

        function addCompLevel() {
            $('#divCompLevel').show();
            $('#<%=hdnCompLevelId.ClientID%>').val("");
            $('#<%=txtCompLevelDesc.ClientID%>').val("");
            $('#<%=txtCompLevelCode.ClientID%>').val("");
            $('#<%=btnAddCompLevelT.ClientID%>').hide();
            $('#<%=btnDelCompLevelT.ClientID%>').hide();
            $('#<%=btnAddCompLevelB.ClientID%>').hide();
            $('#<%=btnDelCompLevelB.ClientID%>').hide();
            $('#<%=btnSaveCompLevel.ClientID%>').show();
            $('#<%=btnResetCompLevel.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Add");

        }

        function resetCompLevel() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divCompLevel').hide();
                $('#<%=txtCompLevelDesc.ClientID%>').val("");
                $('#<%=txtCompLevelCode.ClientID%>').val("");
                $('#<%=btnAddCompLevelT.ClientID%>').show();
                $('#<%=btnAddCompLevelB.ClientID%>').show();
                $('#<%=btnDelCompLevelT.ClientID%>').show();
                $('#<%=btnDelCompLevelB.ClientID%>').show();
                $('#<%=btnSaveCompLevel.ClientID%>').hide();
                $('#<%=btnResetCompLevel.ClientID%>').hide();
                $('#<%=hdnCompLevelId.ClientID%>').val("");
            }
        }

        function saveCompLevel() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var idComp = $('#<%=hdnCompLevelId.ClientID%>').val();
            var idCompModify = $('#<%=txtCompLevelCode.ClientID%>').val();
            var compDesc = $('#<%=txtCompLevelDesc.ClientID%>').val();

            var result = fnValidateCompLevel();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfMechComp.aspx/SaveCompLevel",
                    data: "{idComp: '" + idComp + "', idCompModify:'" + idCompModify + "', compDesc:'" + compDesc + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "SAVED" || data.d[0] == "UPDATED") {
                            $('#divCompLevel').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddCompLevelT.ClientID%>').show();
                            $('#<%=btnAddCompLevelB.ClientID%>').show();
                            $('#<%=btnDelCompLevelT.ClientID%>').show();
                            $('#<%=btnDelCompLevelB.ClientID%>').show();
                            jQuery("#dgdCompLevel").jqGrid('clearGridData');
                            loadCompLevelDetails();
                            jQuery("#dgdCompLevel").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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

        function delCompLevel() {
            var complevel = "";
            $('#dgdCompLevel input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    complevel = $('#dgdCompLevel tr ')[row].cells[3].innerHTML.toString();
                }
            });

            if (complevel != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteCompLevel();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteCompLevel() {
            var row;
            var pccomplevelid;
            var pccompleveldesc;
            var pccomplevelidxml;
            var pccomplevelidxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdCompLevel input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    pccomplevelid = $('#dgdCompLevel tr ')[row].cells[1].innerHTML.toString();
                    pccompleveldesc = $('#dgdCompLevel tr ')[row].cells[2].innerHTML.toString();
                    pccomplevelidxml = '<DELETE ID_COMPT= "' + pccomplevelid + '" COMPT_DESCRIPTION= "' + pccompleveldesc + '"></DELETE>';
                    pccomplevelidxmls += pccomplevelidxml;
                }
            });

            if (pccomplevelidxmls != "") {
                pccomplevelidxmls = "<ROOT>" + pccomplevelidxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfMechComp.aspx/DeleteCompLevel",
                    data: "{delxml: '" + pccomplevelidxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            jQuery("#dgdCompLevel").jqGrid('clearGridData');
                            loadCompLevelDetails();
                            jQuery("#dgdCompLevel").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divCompLevel').hide();
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


        function getMechCompLevelDetails(mechComptLevelId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfMechComp.aspx/GetMechCompLevelDetails",
                data: "{mechComptLevelId: '" + mechComptLevelId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {                    
                    if (data.d.length > 0) {
                        $('#<%=txtCompLevelDesc.ClientID%>').val(data.d[0].Compt_Description);
                    }
                }
            });
        }


        function editMechComp(cellvalue, options, rowObject) {
            var idSeq = rowObject.IdSeq.toString();
            if (idSeq == "") { idSeq = "0";}

            var mechId = rowObject.MechanicId.toString();

            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editMechCompDetails(" + "'" + idSeq +"','"+ mechId +"'" + "); />";
            return edit;
        }

        function editMechCompDetails(idSeq,mechId) {
            $('#<%=hdnIdSeq.ClientID%>').val(idSeq);
            $('#<%=hdnMechId.ClientID%>').val(mechId);
            $('#<%=hdnMode.ClientID%>').val("Edit");
            $('#divMechComp').show();
            var mecCost = $('#<%=mechanicCost.ClientID%>')[0].innerText;
            $("#dgdMechCost").setCaption(mecCost + " : " + mechId.toString());
            $('#<%=ddlPriceCode.ClientID%>')[0].selectedIndex = 0;
            $('#<%=lstCompCode.ClientID%> option').attr('selected', false);
            getPCCompCostDetails(mechId);
            $('#<%=txtMechanic.ClientID%>').attr('disabled', 'disabled');
        }

        function getPCCompCostDetails(mechId) {
            var compCode;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfMechComp.aspx/GetPCCompCostDetails",
                data: "{mechId: '" + mechId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    
                    if (data.d.length > 0) {
                        $('#<%=txtMechanic.ClientID%>').val(mechId);

                        compCode = data.d[0].CompetencyCode.split(",");

                        if (compCode.length > 0) {
                            for (i = 0; i < compCode.length; i++) {
                                if (compCode[i] != "") {
                                    $('#<%=lstCompCode.ClientID%> option:contains("' + compCode[i] + '")').attr('selected', 'selected');
                                } else { $('#<%=lstCompCode.ClientID%> option').attr('selected', false); }                                
                            }
                        } else {
                            $('#<%=lstCompCode.ClientID%> option').attr('selected', false);
                        }

                        if (data.d[0].PriceCode == "") {
                            $('#<%=ddlPriceCode.ClientID%>')[0].selectedIndex = 0;
                        } else {
                            $('#<%=ddlPriceCode.ClientID%> option:contains("' + data.d[0].PriceCode + '")').attr('selected', 'selected');
                        }

                        if (data.d[1].length > 0) {
                            loadMechCompCost(data.d[1]);
                        } else {
                            jQuery("#dgdMechCost").jqGrid('clearGridData');
                        }
                    }
                }
            });
        }

        function saveMechCompDetails() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mechId = $('#<%=txtMechanic.ClientID%>').val();
            var idSeq = $('#<%=hdnIdSeq.ClientID%>').val();
            var priceCode = $('#<%=ddlPriceCode.ClientID%>').val();
            var mechCompIdxml;
            var mechCompIdxmls = "";

                //Competency Codes
                $('#<%=lstCompCode.ClientID%> :selected').each(function (i, selected) {
                    mechCompIdxml = '<INSERT ID_MAP_SEQ = "' + idSeq + '" ID_MEC= "' + mechId + '" ID_COMPT_MEC= "' + $(selected).val() + '" ID_MECPCD= "' + priceCode + '"/>';
                    mechCompIdxmls += mechCompIdxml;
                });

                if (mechCompIdxmls != "") {
                    mechCompIdxmls = "<ROOT>" + mechCompIdxmls + "</ROOT>";

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfMechComp.aspx/SaveMechCompMapping",
                        data: "{xmlDoc: '" + mechCompIdxmls + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            if (data.d[0] == "SAVED") {
                                $('#divMechComp').hide();
                                $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");

                                jQuery("#dgdMechComp").jqGrid('clearGridData');
                                loadMechCompDetails();
                                jQuery("#dgdMechComp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");

                            }
                            else {
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


        function saveMechCostDetails() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mechId = $('#<%=txtMechanic.ClientID%>').val();
            var idSeq = $('#<%=hdnIdSeq.ClientID%>').val();
            var priceCode = $('#<%=ddlPriceCode.ClientID%>').val();
            var costTime = $('#<%=txtCostTime.ClientID%>').val();
            var costHour = $('#<%=txtCostPerHour.ClientID%>').val();
            var costGarage = $('#<%=txtCostToGarage.ClientID%>').val();
            var mechCostIdxml;
            var mechCostIdxmls = "";

            
            var result = fnValidateMechCost();
            if (result == true) {
                //Mechanic Cost
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfMechComp.aspx/SaveMechCostDetails",
                    //data: "{xmlDoc: '" + mechCostIdxmls + "'}",
                    data: "{idSeq: '" + idSeq + "', mechId:'" + mechId + "', costTime:'" + costTime + "', costHour:'" + costHour + "', costGarage:'" + costGarage + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "SAVED") {
                            $('#divMechCost').hide();
                            $('#<%=btnAddMechCost.ClientID%>').show();
                            $('#<%=btnDelMechCost.ClientID%>').show();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");

                            jQuery("#dgdMechCost").jqGrid('clearGridData');
                            getPCCompCostDetails(mechId);
                            jQuery("#dgdMechCost").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");

                        }
                        else {
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

        function loadMechCompCost(data) {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            jQuery("#dgdMechCost").jqGrid('clearGridData');
            for (i = 0; i < data.length; i++) {
                mechcompcostdata = data;
                jQuery("#dgdMechCost").jqGrid('addRowData', i + 1, mechcompcostdata[i]);
            }
            jQuery("#dgdMechCost").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdMechCost").jqGrid("hideCol", "subgrid");
            return true;
        }

        function resetMechComp() {
            loadCompLevelDetails();
            loadMechCompDetails();
        }

         function editMechCost(cellvalue, options, rowObject) {
            var idSeq = rowObject.IdSeq.toString();
            var idMech = rowObject.IdMech.toString();
            var costTime = rowObject.CostTime.toString();
            var costHour = rowObject.CostHour.toString();
            var costGarage = rowObject.CostGarage.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editMechCostDetails(" + "'" + idSeq + "','" + idMech + "','" + costTime + "','" + costHour + "','" + costGarage + "'" + "); />";
            return edit;
        }

        function editMechCostDetails(idSeq, idMech, costTime, costHour, costGarage) {
            $('#<%=hdnIdSeq.ClientID%>').val(idSeq);
            $('#<%=hdnMechId.ClientID%>').val(idMech);
            $('#<%=txtCostTime.ClientID%>').val(costTime);
            $('#<%=txtCostPerHour.ClientID%>').val(costHour);
            $('#<%=txtCostToGarage.ClientID%>').val(costGarage);
            $('#divMechCost').show();
            $('#<%=btnAddMechCost.ClientID%>').hide();
            $('#<%=btnDelMechCost.ClientID%>').hide();
            $('#<%=btnSaveMechCost.ClientID%>').show();
            $('#<%=btnCancelMechCost.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function addMechCost() {
            $('#divMechCost').show();
            $('#<%=hdnIdSeq.ClientID%>').val("");
            $('#<%=txtCostPerHour.ClientID%>').val("");
            $('#<%=txtCostToGarage.ClientID%>').val("");
            $('#<%=btnAddMechCost.ClientID%>').hide();
            $('#<%=btnDelMechCost.ClientID%>').hide();
            $('#<%=btnSaveMechCost.ClientID%>').show();
            $('#<%=btnCancelMechCost.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Add");

            var rowData = $('#dgdMechCost').jqGrid('getGridParam', 'data');
            if (rowData.length == 0) {
                $('#<%=txtCostTime.ClientID%>').val("0");
                $('#<%=txtCostTime.ClientID%>').attr('disabled', 'disabled');
            } else {
                $('#<%=txtCostTime.ClientID%>').val("");
                $('#<%=txtCostTime.ClientID%>').removeAttr('disabled');
            }
        }

        function cancelMechCost() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divMechCost').hide();
                $('#<%=txtCostTime.ClientID%>').val("");
                $('#<%=txtCostPerHour.ClientID%>').val("");
                $('#<%=txtCostToGarage.ClientID%>').val("");
                $('#<%=btnAddMechCost.ClientID%>').show();
                $('#<%=btnDelMechCost.ClientID%>').show();
                $('#<%=btnSaveMechCost.ClientID%>').hide();
                $('#<%=btnCancelMechCost.ClientID%>').hide();
                $('#<%=hdnIdSeq.ClientID%>').val("");
            }
        }

        function cancelMechComp() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divMechComp').hide();
                $('#divMechCost').hide();
                $('#<%=btnSaveMechCost.ClientID%>').hide();
                $('#<%=btnCancelMechCost.ClientID%>').hide();
                $('#<%=hdnIdSeq.ClientID%>').val("");
            }
        }

        function delMechCost() {
            var mechCost = "";
            $('#dgdMechCost input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    mechCost = $('#dgdMechCost tr ')[row].cells[5].innerHTML.toString();
                }
            });

            if (mechCost != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteMechCost();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteMechCost() {
            var row;
            var mechCostid;
            var mechId;
            var costTime;
            var costHour;
            var mechCostIdxml;
            var mechCostIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var selectedMechId = $('#<%=txtMechanic.ClientID%>').val();

            $('#dgdMechCost input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    mechCostid = $('#dgdMechCost tr ')[row].cells[5].innerHTML.toString();
                    mechId = $('#dgdMechCost tr ')[row].cells[4].innerHTML.toString();
                    costTime = $('#dgdMechCost tr ')[row].cells[1].innerHTML.toString().replace(",", "").replace(".", "").substr(0, 3);//since the cost time column is of size (5,2)

                    costHour = $('#dgdMechCost tr ')[row].cells[2].innerHTML.toString().replace(",", "").replace(".", "");

                    mechCostIdxml = '<DELETE ID_SEQ= "' + mechCostid + '" ID_MEC= "' + mechId + '" COST_TIME= "' + costTime + '" COST_HOUR= "' + costHour + '"></DELETE>';
                    mechCostIdxmls += mechCostIdxml;
                }
            });

            if (mechCostIdxmls != "") {
                mechCostIdxmls = "<ROOT>" + mechCostIdxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfMechComp.aspx/DeleteMechCostDetails",
                    data: "{delxml: '" + mechCostIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.length == 0) {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (data != null) {
                            if (data.d[0] == "DEL") {
                                $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                jQuery("#dgdMechCost").jqGrid('clearGridData');
                                getPCCompCostDetails(selectedMechId);
                                jQuery("#dgdMechCost").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                                $('#divMechCost').hide();
                            }
                            else if (data.d[0] == "NDEL") {
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                            }
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





    </script>


    <div class="header1 two fields" style="padding-top:0.5em">
        <asp:Label ID="lblHead" runat="server" Text="Mechanic Competency" ></asp:Label>
        <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField id="hdnPageSize" runat="server" />  
        <asp:HiddenField id="hdnEditCap" runat="server" />
        <asp:HiddenField id="hdnMode" runat="server" /> 
        <asp:HiddenField id="hdnSelect" runat="server" />  
        <asp:HiddenField id="hdnCompLevelId" runat="server" />
        <asp:HiddenField id="hdnMechCompId" runat="server" />
        <asp:HiddenField id="hdnIdSeq" runat="server" />
        <asp:HiddenField id="hdnMechId" runat="server" />
    </div>  

    <div id="accordion" >
       <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a1" runat="server" >Competency Levels</a>
       </div>             
       <div> 
            <div style="text-align:left;padding-left:10em">
                <input id="btnAddCompLevelT" runat="server" type="button" value="Add" class="ui button" onclick="addCompLevel()" />
                <input id="btnDelCompLevelT" runat="server" type="button" value="Delete" class="ui button" onclick="delCompLevel()"/>
            </div>  
            <div>
                <table id="dgdCompLevel" title="Competency Levels" ></table>
                <div id="pagerCompLevel"></div>
            </div>         
            <div style="text-align:left;padding-left:10em">
                <input id="btnAddCompLevelB" runat="server" type="button" value="Add" class="ui button" onclick="addCompLevel()"/>
                <input id="btnDelCompLevelB" runat="server" type="button" value="Delete" class="ui button" onclick="delCompLevel()"/>
            </div>
            <div id="divCompLevel" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a3" runat="server" >CompLevel</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblCompLevelCode" runat="server" Text="Competency Level Code"></asp:Label>
                            <asp:TextBox ID="txtCompLevelCode"  padding="0em" runat="server" ></asp:TextBox>
                        </div>     
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblCompLevelDesc" runat="server" Text="Description"></asp:Label>
                            <asp:TextBox ID="txtCompLevelDesc"  padding="0em" runat="server" ></asp:TextBox>
                        </div>                                                     
                    </div>
                </div>
                <div style="text-align:center">
                    <input id="btnSaveCompLevel" class="ui button" runat="server"  value="Save" type="button" onclick="saveCompLevel()"/>
                    <input id="btnResetCompLevel" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetCompLevel()" />
                </div>               
            </div>
       </div>

       <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a2" runat="server" >Mapping of Mechanic Competency,Price Code and cost</a>
       </div>
       <div style="text-align:center">
	       <div>
	            <table id="dgdMechComp" title="Mechanic Competency" ></table>
	            <div id="pagerMechComp"></div>
           </div>
           <div id="divMechComp" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a4" runat="server" >MechComp</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblMechId" runat="server" Text="Mechanic Id"></asp:Label>
                            <asp:TextBox ID="txtMechanic"  padding="0em" runat="server" ></asp:TextBox>
                        </div>     
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblPriceCode" runat="server" Text="Price Code"></asp:Label>
                            <asp:DropDownList ID="ddlPriceCode" runat="server" Width="156px" CssClass="drpdwm"></asp:DropDownList>
                        </div>  
                        <div class="field" style="width:200px">
                            <asp:Label ID="lblCompCode" runat="server" Text="Competency Code"></asp:Label>
                            <asp:ListBox ID="lstCompCode" padding="0em" runat="server" SelectionMode="Multiple" ></asp:ListBox>
                        </div>                                                   
                    </div>
                </div>
                <div style="text-align:left;padding-top:1em;padding-left:15em">
                    <input id="btnSaveMechComp" class="ui button" runat="server"  value="Save" type="button" onclick="saveMechCompDetails()"/>
                    <input id="btnCancelMechComp" class="ui button" runat="server"  value="Cancel" type="button" style="background-color: #E0E0E0" onclick="cancelMechComp()" />
                </div> 
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="a5" runat="server" >Mechanic Cost </a>
                </div>
                <div>
	                <table id="dgdMechCost" title="Mechanic Cost" ></table>
	                <div id="pagerMechCost"></div>
                </div>
                <div style="text-align:left;padding-left:15em">
                    <input id="btnAddMechCost" runat="server" type="button" value="Add" class="ui button" onclick="addMechCost()"/>
                    <input id="btnDelMechCost" runat="server" type="button" value="Delete" class="ui button" onclick="delMechCost()"/>
                </div>
                <div id="divMechCost" class="ui raised segment signup inactive">
                     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                        <a class="active item" id="mechanicCost" runat="server" >MechCost</a>
                    </div>
                    <div class="ui form" style="width: 100%;">
                        <div class="four fields">
                            <div class="field" style="width:200px">
                                <asp:Label ID="lblCostTime" runat="server" Text="Cost Time"></asp:Label>
                                <asp:TextBox ID="txtCostTime"  padding="0em" runat="server"  MaxLength="3" ></asp:TextBox>
                            </div>     
                            <div class="field" style="width:200px">
                                <asp:Label ID="lblCostPerHour" runat="server" Text="Cost Per Hour"></asp:Label>
                                <asp:TextBox ID="txtCostPerHour"  padding="0em" runat="server" ></asp:TextBox>
                            </div>  
                            <div class="field" style="width:200px">
                                <asp:Label ID="lblCostToGarage" runat="server" Text="Cost To Garage"></asp:Label>
                                <asp:TextBox ID="txtCostToGarage" padding="0em" runat="server" ></asp:TextBox>
                            </div>                                                   
                        </div>
                    </div>
                    <div style="text-align:left;padding-top:1em;padding-left:15em">
                        <input id="btnSaveMechCost" class="ui button" runat="server"  value="Save" type="button" onclick="saveMechCostDetails()"/>
                        <input id="btnCancelMechCost" class="ui button" runat="server"  value="Cancel" type="button" style="background-color: #E0E0E0" onclick="cancelMechCost()" />
                    </div>
                 </div>                    
            </div>                 
        </div>
    </div><%--end of accordiion--%>
<%--    <div style="text-align:left;padding-left:10em">
        <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" onclick="resetMechComp()" />
    </div>--%>
</asp:Content>