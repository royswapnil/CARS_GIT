<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmEmailTemplateConfig.aspx.vb" Inherits="CARS.frmEmailTemplateConfig" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        

        $(document).ready(function () {
            $('#divEmailTempConfig').hide();           
            detectfocus(document.getElementById('<%=txtMessage.ClientID%>'), 50);

            var grid = $("#dgdEmailTempConfig");
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            //Email EmailTempConfig
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Template Code', 'Subject', 'ShortMessage', 'Message', 'Id_Template',''],
                colModel: [
                         { name: 'Template_Code', index: 'Template_Code', width: 150, sorttype: "string" },
                         { name: 'Subject', index: 'Subject', width: 200, sorttype: "string" },
                         { name: 'Short_Message', index: 'Short_Message', width: 250, sorttype: "string" },
                         { name: 'Message', index: 'Message', width: 350, sorttype: "string" },
                         { name: 'Id_Template', index: 'Id_Template', width: 350, sorttype: "string",hidden:true },
                         { name: 'Id_Template', index: 'Id_Template', sortable: false, formatter: editEmailTempConfig }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Message Template",
                async: false, //Very important,
                subgrid: false

            });

            loadEmailTempConfig();

        });


        function detectfocus(field, cols) {
            var substr1 = "";
            var substr2 = "";

            var lbkRepairDate = document.getElementById('<%=lbRepDate.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbRepDate.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkRegNoDate = document.getElementById('<%=lbRegNo.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbRegNo.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkCustNo = document.getElementById('<%=lbCustNo.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbCustNo.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkCustName = document.getElementById('<%=lbCustName.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbCustName.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkCommercialText = document.getElementById('<%=lbCommercialText.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbCommercialText.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }

            var lbkDetails = document.getElementById('<%=lbDetails.ClientID%>').onclick = function () {
                substr1 = document.getElementById('<%=txtMessage.ClientID%>').value;
                if (field != undefined) {
                    document.getElementById('<%=txtMessage.ClientID%>').value = substr1 + "{{" + document.getElementById('<%=lbDetails.ClientID%>').innerHTML + "}}" + substr2;
                    document.getElementById('<%=txtMessage.ClientID%>').focus();
                    return false;
                }
            }
        }


        function loadEmailTempConfig() {

            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmEmailTemplateConfig.aspx/LoadConfigEmailTemplate",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdEmailTempConfig").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdEmailTempConfig").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdEmailTempConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdEmailTempConfig").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function editEmailTempConfig(cellvalue, options, rowObject) {
            var idTemplate = rowObject.Id_Template.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editEmailTemplate(" + "'" + idTemplate + "'" + "); />";
            return edit;          
        }

        function editEmailTemplate(idTemplate) {
            $('#divEmailTempConfig').show();
            getEmailTemplateConfig(idTemplate);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=hdnIdTemplateId.ClientID%>').val(idTemplate);
            $('#<%=hdnMode.ClientID%>').val("Edit");
        }

        function getEmailTemplateConfig(idTemplate) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmEmailTemplateConfig.aspx/GetEmailTemplateConfig",
                data: "{idTemplate: '" + idTemplate + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtTemplateCode.ClientID%>').val(data.d[0].Template_Code);
                        $('#<%=txtSubject.ClientID%>').val(data.d[0].Subject);
                        $('#<%=txtMessage.ClientID%>').val(data.d[0].Message);
                        
                    }
                }
            });
        }


        function saveEmailTemplateConfig() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var idTemplate = $('#<%=hdnIdTemplateId.ClientID%>').val();
            var templateCode = $('#<%=txtTemplateCode.ClientID%>').val();
            var subject = $('#<%=txtSubject.ClientID%>').val();
            var message = $('#<%=txtMessage.ClientID%>').val();

            var result = fnValidateTempCode();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmEmailTemplateConfig.aspx/SaveConfigEmailTemplate",
                    data: "{idTemplate: '" + idTemplate + "', templateCode:'" + templateCode + "', subject:'" + subject + "', message:'" + message + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == "INSERTED" || data.d[0] == "UPDATED") {
                            $('#divEmailTempConfig').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDelT.ClientID%>').show();
                            $('#<%=btnDelB.ClientID%>').show();
                            jQuery("#dgdEmailTempConfig").jqGrid('clearGridData');
                            loadEmailTempConfig();
                            jQuery("#dgdEmailTempConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
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


        function addEmailTempConfig() {
            $('#divEmailTempConfig').show();
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=txtTemplateCode.ClientID%>').val("");
            $('#<%=txtMessage.ClientID%>').val("");
            $('#<%=txtSubject.ClientID%>').val("");
            $('#<%=hdnMode.ClientID%>').val("Add");
            $('#<%=hdnIdTemplateId.ClientID%>').val("");
        }

        function resetEmailTempConfig() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divEmailTempConfig').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSave.ClientID%>').hide();
                $('#<%=btnReset.ClientID%>').hide();
                $('#<%=txtTemplateCode.ClientID%>').val("");
                $('#<%=txtMessage.ClientID%>').val("");
                $('#<%=txtSubject.ClientID%>').val("");
                $('#<%=hdnMode.ClientID%>').val("");
                $('#<%=hdnIdTemplateId.ClientID%>').val("");
            }
        }

        function delEmailTempConfig() {
            var emailTempId = "";
            $('#dgdEmailTempConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    emailTempId = $('#dgdEmailTempConfig tr ')[row].cells[6].innerHTML.toString();
                }
            });

            if (emailTempId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteEmailTempConfig();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteEmailTempConfig() {
            var row;
            var emailTempId;
            var emailTempIdxml;
            var emailTempIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdEmailTempConfig input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    emailTempId = $('#dgdEmailTempConfig tr ')[row].cells[6].innerHTML.toString();
                    emailTempIdxml = '<DELETE ID_TEMPLATE= "' + emailTempId + '" />';
                    emailTempIdxmls += emailTempIdxml;
                }
            });

            if (emailTempIdxmls != "") {
                emailTempIdxmls = "<ROOT><DELETE>" + emailTempIdxmls + "</DELETE></ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmEmailTemplateConfig.aspx/DeleteEmailTemplate",
                    data: "{emailTempIdxmls: '" + emailTempIdxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdEmailTempConfig").jqGrid('clearGridData');
                        loadEmailTempConfig();
                        jQuery("#dgdEmailTempConfig").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divEmailTempConfig').hide();
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
            if (!(gfi_CheckEmpty($('#<%=txtTemplateCode.ClientID%>'), '0210'))) {
                return false;
            }
            return true;
        }

    </script>
    




    <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblEmailTempConfig" runat="server" Text="Message Template Configuration"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
         <asp:HiddenField id="hdnIdTemplateId" runat="server" />
    </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >Message Template</a>
    </div> 
    <div>
        <div style="text-align:left;padding-left:10em;padding-bottom:1em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addEmailTempConfig()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="delEmailTempConfig()"/>
        </div>  
        <div >
            <table id="dgdEmailTempConfig" title="Message Template Configuration" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:left;padding-left:10em;padding-top:1em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addEmailTempConfig()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="delEmailTempConfig()"/>
        </div>

        <div id="divEmailTempConfig" style="padding-left:2em;width:50%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Message Template</a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;">
                        <asp:Label ID="lblTemplateCode" runat="server" Text="Template Code"></asp:Label>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:TextBox ID="txtTemplateCode"  padding="0em" runat="server"></asp:TextBox>
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
                        <asp:LinkButton runat="server" ID="lbRepDate" Text="Rep dato"></asp:LinkButton><br />
                        <asp:LinkButton runat="server" ID="lbRegNo" Text="Regnr"></asp:LinkButton><br />
                        <asp:LinkButton runat="server" ID="lbCustNo" Text="Kundenr"></asp:LinkButton><br />
                        <asp:LinkButton runat="server" ID="lbCustName" Text="Kunde"></asp:LinkButton><br />
                        <asp:LinkButton runat="server" ID="lbCommercialText" Text="Reklametekst"></asp:LinkButton><br />
                        <asp:LinkButton runat="server" ID="lbDetails" Text="Detaljer"></asp:LinkButton><br />
                    </div>                 
                </div>
            </div>            

            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveEmailTemplateConfig()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetEmailTempConfig()" />
            </div>               
        </div>
    </div>








    <%--<div>
        <asp:Label ID="lblHeader" runat="server" Text="Email Template Config"></asp:Label>
    </div>
    <div>
        <asp:TextBox ID="txtEmailTemplate" runat="server"  Width="160px" TextMode="MultiLine" onblur="detectfocus(this.name, 50)"></asp:TextBox>
        <asp:LinkButton runat="server" ID="lbTest" Text="Repair Date"></asp:LinkButton>
    </div>--%>

</asp:Content>
