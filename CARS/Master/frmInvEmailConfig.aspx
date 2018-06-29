<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmInvEmailConfig.aspx.vb" Inherits="CARS.frmInvEmailConfig" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 


    <script type="text/javascript">

        $(document).ready(function () {
            $("#accordion").accordion();
            $("#accordion").height('auto');

            $('#divInvEmailTemp').hide();
            detectfocus(document.getElementById('<%=txtMessage.ClientID%>'), 50);

            var grid = $("#dgdInvEmailTemp");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            //Invoice Email Config
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Template Code', 'Subject', 'ShortMessage', 'Message', 'IsDefault','Id_Template', ''],
                colModel: [
                         { name: 'Template_Code', index: 'Template_Code', width: 150, sorttype: "string" },
                         { name: 'Subject', index: 'Subject', width: 200, sorttype: "string" },
                         { name: 'Short_Message', index: 'Short_Message', width: 250, sorttype: "string" },
                         { name: 'Message', index: 'Message', width: 350, sorttype: "string" },
                         { name: 'Flg_Default', index: 'Flg_Default', width: 100, sorttype: "string" },
                         { name: 'Id_Template', index: 'Id_Template', width: 100, sorttype: "string", hidden: true },
                         { name: 'Id_Template', index: 'Id_Template', sortable: false, formatter: editInvEmailTemp }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Invoice Email Template",
                async: false, //Very important,
                subgrid: false

            });

            loadInvoiceEmailTemp();
            loadInvoiceEmailSchedule();

            $('#<%=txtStartTime.ClientID%>').change(function (e) {
                if ($('#<%=txtStartTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtStartTime.ClientID%>'));
                }
            });

        });

        function detectfocus(field, cols) {
            var substr1 = "";
            var substr2 = "";

            var lbkInvCustName = document.getElementById('<%=lbInvCustName.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvCustName.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkInvNo = document.getElementById('<%=lbInvNo.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvNo.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkInvDate = document.getElementById('<%=lbInvDate.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvDate.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkInvDueDate = document.getElementById('<%=lbInvDueDate.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvDueDate.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkInvKidNo = document.getElementById('<%=lbInvKidNo.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvKidNo.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkInvAmt = document.getElementById('<%=lbInvAmt.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbInvAmt.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }
        }

        function loadInvoiceEmailTemp() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvEmailConfig.aspx/LoadInvEmailTemplate",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdInvEmailTemp").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdInvEmailTemp").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdInvEmailTemp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdInvEmailTemp").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function loadInvoiceEmailSchedule() {

            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvEmailConfig.aspx/LoadInvEmailSchedule",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {                       
                        $('#<%=txtStartTime.ClientID%>').val(data.d[0].Start_Time);
                        if (data.d[0].Use_Mon == "1") {
                            $("#<%=cbMonday.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbMonday.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Tue == "1") {
                            $("#<%=cbTuesday.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbTuesday.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Wed == "1") {
                            $("#<%=cbWed.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbWed.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Thur == "1") {
                            $("#<%=cbThur.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbThur.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Fri == "1") {
                            $("#<%=cbFri.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbFri.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Sat == "1") {
                            $("#<%=cbSat.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbSat.ClientID%>").attr('checked', false);
                        }
                        if (data.d[0].Use_Sun == "1") {
                            $("#<%=cbSun.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbSun.ClientID%>").attr('checked', false);
                        }
                    }
                }
            });
        }


        function addInvEmailTemp() {
            $('#divInvEmailTemp').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSaveInvEmailTemp.ClientID%>').show();
            $('#<%=btnResetInvEmailTemp.ClientID%>').show();
            $('#<%=txtTempCode.ClientID%>').val("");
            $('#<%=txtMessage.ClientID%>').val("");
            $('#<%=txtSubject.ClientID%>').val("");
            $('#<%=hdnMode.ClientID%>').val("Add");
            $('#<%=hdnIdInvEmailTempId.ClientID%>').val("");
        }

        function resetInvEmailTemp() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divInvEmailTemp').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSaveInvEmailTemp.ClientID%>').hide();
                $('#<%=btnResetInvEmailTemp.ClientID%>').hide();
                $('#<%=txtTempCode.ClientID%>').val("");
                $('#<%=txtMessage.ClientID%>').val("");
                $('#<%=txtSubject.ClientID%>').val("");
                $('#<%=hdnMode.ClientID%>').val("");
                $('#<%=hdnIdInvEmailTempId.ClientID%>').val("");
            }
        }

        function editInvEmailTemp(cellvalue, options, rowObject) {
            var idTemplate = rowObject.Id_Template.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editInvEmailTemplate(" + "'" + idTemplate + "'" + "); />";
            return edit;
        }

        function editInvEmailTemplate(idTemplate) {
            $('#divInvEmailTemp').show();
            getInvEmailTemplate(idTemplate);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSaveInvEmailTemp.ClientID%>').show();
            $('#<%=btnResetInvEmailTemp.ClientID%>').show();
            $('#<%=hdnIdInvEmailTempId.ClientID%>').val(idTemplate);
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function getInvEmailTemplate(idTemplate) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmInvEmailConfig.aspx/GetInvEmailTemplateConfig",
                data: "{idTemplate: '" + idTemplate + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtTempCode.ClientID%>').val(data.d[0].Template_Code);
                        $('#<%=txtSubject.ClientID%>').val(data.d[0].Subject);
                        $('#<%=txtMessage.ClientID%>').val(data.d[0].Message);

                        if (data.d[0].Flg_Default == true) {
                            $("#<%=cbIsDefault.ClientID%>").attr('checked', true);
                        } else {
                            $("#<%=cbIsDefault.ClientID%>").attr('checked', false);
                        }
                    }
                }
            });
        }

        function saveInvEmailTemp() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var idTemplate = $('#<%=hdnIdInvEmailTempId.ClientID%>').val();
            var templateCode = $('#<%=txtTempCode.ClientID%>').val();
            var subject = $('#<%=txtSubject.ClientID%>').val();
            var message = $('#<%=txtMessage.ClientID%>').val();
            var isDefault = $('#<%=cbIsDefault.ClientID%>').is(':checked');
            if (isDefault == true) {
                isDefault = "1";
            } else { isDefault = "0"; }

            var result = fnValidateTempCode();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmInvEmailConfig.aspx/SaveInvEmailTemplate",
                    data: "{idTemplate: '" + idTemplate + "', templateCode:'" + templateCode + "', subject:'" + subject + "', message:'" + message + "', isDefault:'" + isDefault + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divInvEmailTemp').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdInvEmailTemp").jqGrid('clearGridData');
                            loadInvoiceEmailTemp();
                            jQuery("#dgdInvEmailTemp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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


        function delInvEmailTemp(rowObject, options) {
            var emailTempId = "";
            $('#dgdInvEmailTemp input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    emailTempId = $('#dgdInvEmailTemp tr ')[row].cells[7].innerHTML.toString();
                }
            });

            if (emailTempId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteInvEmailTemp();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteInvEmailTemp() {
            var row;
            var emailTempId;
            var emailTempIdxml;
            var emailTempIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdInvEmailTemp input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    emailTempId = $('#dgdInvEmailTemp tr ')[row].cells[7].innerHTML.toString();
                    emailTempIdxml = '<DELETE ID_TEMPLATE= "' + emailTempId + '" />';
                    emailTempIdxmls += emailTempIdxml;
                }
            });

            if (emailTempIdxmls != "") {
                emailTempIdxmls = "<ROOT><DELETE>" + emailTempIdxmls + "</DELETE></ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmInvEmailConfig.aspx/DeleteInvEmailTemplate",
                    data: "{emailTempIdxmls: '" + emailTempIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdInvEmailTemp").jqGrid('clearGridData');
                        loadInvoiceEmailTemp();
                        jQuery("#dgdInvEmailTemp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divInvEmailTemp').hide();
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
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

        function fnValidateTempCode() {
            if (!(gfi_CheckEmpty($('#<%=txtTempCode.ClientID%>'), '0210'))) {
                return false;
            }
            return true;
        }

        function saveInvEmailSchedule() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var startTime = $('#<%=txtStartTime.ClientID%>').val();
            var wkMon = $('#<%=cbMonday.ClientID%>').is(':checked');
            var wkTue = $('#<%=cbTuesday.ClientID%>').is(':checked');
            var wkWed = $('#<%=cbWed.ClientID%>').is(':checked');
            var wkThur = $('#<%=cbThur.ClientID%>').is(':checked');
            var wkFri = $('#<%=cbFri.ClientID%>').is(':checked');
            var wkSat = $('#<%=cbSat.ClientID%>').is(':checked');
            var wkSun = $('#<%=cbSun.ClientID%>').is(':checked');

            //var result = fnValidateTempCode();
            //if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmInvEmailConfig.aspx/SaveInvEmailSchedule",
                    data: "{startTime: '" + startTime + "', wkMon:'" + wkMon + "', wkTue:'" + wkTue + "', wkWed:'" + wkWed + "', wkThur:'" + wkThur + "', wkFri:'" + wkFri + "', wkSat:'" + wkSat + "', wkSun:'" + wkSun + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divInvEmailTemp').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdInvEmailTemp").jqGrid('clearGridData');
                            loadInvoiceEmailTemp();
                            jQuery("#dgdInvEmailTemp").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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
           // }
        }

        function resetInvEmailSch() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#<%=txtStartTime.ClientID%>').val("");
                $("#<%=cbMonday.ClientID%>").prop('checked', false);
                $("#<%=cbTuesday.ClientID%>").prop('checked', false);
                $("#<%=cbWed.ClientID%>").prop('checked', false);
                $("#<%=cbThur.ClientID%>").prop('checked', false);
                $("#<%=cbFri.ClientID%>").prop('checked', false);
                $("#<%=cbSat.ClientID%>").prop('checked', false);
                $("#<%=cbSun.ClientID%>").prop('checked', false);
            }
        }

    </script>

    <div class="header1 two fields" style="padding-top:0.5em">
        <asp:Label ID="lblHead" runat="server" Text="Email Invoice Configuration" ></asp:Label>
        <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField id="hdnPageSize" runat="server" />  
        <asp:HiddenField id="hdnEditCap" runat="server" />
        <asp:HiddenField id="hdnMode" runat="server" /> 
        <asp:HiddenField id="hdnIdInvEmailTempId" runat="server" /> 
    </div>

    <div id="accordion">
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
           <a class="item" id="a2" runat="server" >Invoice Email Template</a>
        </div>
        <div > 
            <div style="text-align:left;padding-left:35em;padding-bottom:1em">
                <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addInvEmailTemp()"/>
                <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="delInvEmailTemp()"/>
            </div>  
            <div >
                <table id="dgdInvEmailTemp" title="Invoice Email Template" ></table>
                <div id="pager"></div>
            </div>         
            <div style="text-align:left;padding-left:35em;padding-top:1em"">
                <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addInvEmailTemp()"/>
                <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="delInvEmailTemp()"/>
            </div>
            <div id="divInvEmailTemp">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="aheader" runat="server" >Invoice Email Template</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="width:160px">
                            <asp:Label ID="lblTempCode" runat="server" Text="Template Code"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtTempCode"  padding="0em" runat="server" ></asp:TextBox>
                        </div>                            
                    </div>
                    <div class="four fields">
                        <div class="field" style="width:160px;">
                            <asp:Label ID="lblSubject" runat="server" Text="Subject"></asp:Label>
                        </div>
                        <div class="field" style="width:150px">
                            <asp:TextBox ID="txtSubject"  padding="0em" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="width:160px;">
                            <asp:Label ID="lblMessage" runat="server" Text="Message"></asp:Label>
                        </div>
                        <div class="field" style="width:300px">
                             <asp:TextBox ID="txtMessage" runat="server"  Width="280px" Height="150px" TextMode="MultiLine" onblur="detectfocus(this.name, 50)"></asp:TextBox>
                        </div>   
                        <div>
                            <asp:LinkButton runat="server" ID="lbInvCustName" Text="Kundenavn" style="color:#4183c4"></asp:LinkButton><br />
                            <asp:LinkButton runat="server" ID="lbInvNo" Text="Kundenr" style="color:#4183c4"></asp:LinkButton><br />
                            <asp:LinkButton runat="server" ID="lbInvDate" Text="Fakturadato" style="color:#4183c4"></asp:LinkButton><br />
                            <asp:LinkButton runat="server" ID="lbInvDueDate" Text="Forfallsdato" style="color:#4183c4"></asp:LinkButton><br />
                            <asp:LinkButton runat="server" ID="lbInvKidNo" Text="KID nummer" style="color:#4183c4"></asp:LinkButton><br />
                            <asp:LinkButton runat="server" ID="lbInvAmt" Text="Fakturabeløp" style="color:#4183c4"></asp:LinkButton><br />
                        </div>                         
                    </div>
                    <div class="four fields">
                        <div class="field" style="width:100px">
                            <asp:CheckBox ID="cbIsDefault" runat="server" />
                            <asp:Label ID="lblisDefault" runat="server" Text="IsDefault" />
                        </div>                   
                    </div>

                </div>             

                <div style="text-align:center">
                    <input id="btnSaveInvEmailTemp" class="ui button" runat="server"  value="Save" type="button" onclick="saveInvEmailTemp()"/>
                    <input id="btnResetInvEmailTemp" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetInvEmailTemp()" />
                </div>               
            </div>
        </div>

         <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
            <a class="item" id="a1" runat="server" >E-Mail Invoice Scheduler </a>
         </div>

        <div>
            <div class="ui form" style="width: 100%;">
                <div class="four fields">
                    <div class="field" style="width:160px">
                        <asp:Label ID="lblStartTime" runat="server" Text="Start Time"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtStartTime"  padding="0em" runat="server" ></asp:TextBox>
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px">
                        <asp:Label ID="lblDaysActive" runat="server" Text="Day's Active"></asp:Label>
                    </div>
                           
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbMonday" runat="server" />
                        <asp:Label ID="lblMon" runat="server" Text="Monday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"> </div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbTuesday" runat="server" />
                        <asp:Label ID="lblTue" runat="server" Text="Tuesday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbWed" runat="server" />
                        <asp:Label ID="lblWed" runat="server" Text="Wednesday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbThur" runat="server" />
                        <asp:Label ID="lblThur" runat="server" Text="Thursday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbFri" runat="server" />
                        <asp:Label ID="lblFri" runat="server" Text="Friday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSat" runat="server" />
                        <asp:Label ID="lblSat" runat="server" Text="Saturday" />
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:160px"></div>
                    <div class="field" style="width:200px">
                        <asp:CheckBox ID="cbSun" runat="server" />
                        <asp:Label ID="lblSun" runat="server" Text="Sunday" />
                    </div>                            
                </div>
                <div style="text-align:left;padding-left:100px;padding-top:20px">
                    <input id="btnSaveInvEmailSch" class="ui button" runat="server"  value="Save" type="button" onclick="saveInvEmailSchedule()"/>
                    <input id="btnResetInvEmailSch" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetInvEmailSch()" />
                </div> 
            </div>
        </div>     

    </div>



</asp:Content>