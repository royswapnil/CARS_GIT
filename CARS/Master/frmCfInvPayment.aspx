<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfInvPayment.aspx.vb" Inherits="CARS.frmCfInvPayment" MasterPageFile="~/MasterPage.Master"%>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

    <script type="text/javascript">

        function fnClientValidate() {
            var Startno;
            var Endno;
            var Warningbefore;
            var maxint;
            maxint = 2147483647 //Maximum value of Int


            if (!(gfb_ValidateAlphabets($('#<%=txtPrefix.ClientID%>'), GetMultiMessage('0221', '', '')))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtPrefix.ClientID%>'), '0221'))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtDescription.ClientID%>'), '0185'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtDescription.ClientID%>'), GetMultiMessage('0403', '', '')))) {
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtStartNo.ClientID%>'), '0222'))) {
                return false;
            }
            if (!(gfi_ValidateNumber($('#<%=txtStartNo.ClientID%>'), '0222'))) {
                $('#<%=txtStartNo.ClientID%>').val("");
                return false;
            }

            Startno = $('#<%=txtStartNo.ClientID%>').val();
            if (eval(Startno) >= eval(maxint)) {
                var msg = GetMultiMessage('0793', '', '')
                alert(msg);
                $('#<%=txtStartNo.ClientID%>').focus();
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtEndNo.ClientID%>'), '0223'))) {
                return false;
            }
            if (!(gfi_ValidateNumber($('#<%=txtEndNo.ClientID%>'), '0223'))) {
                $('#<%=txtEndNo.ClientID%>').val("");
                return false;
            }
            Endno = $('#<%=txtEndNo.ClientID%>').val();

            if (eval(Endno) >= eval(maxint)) {
                var msg = GetMultiMessage('0795', '', '')
                alert(msg);
                $('#<%=txtEndNo.ClientID%>').focus();
                return false;
            }

            if (!(gfi_CheckEmpty($('#<%=txtWarningBefore.ClientID%>'), '0224'))) {
                return false;
            }
            if (!(gfi_ValidateNumber($('#<%=txtWarningBefore.ClientID%>'), '0224'))) {
                $('#<%=txtWarningBefore.ClientID%>').val("");
                return false;
            }

            Warningbefore = $('#<%=txtWarningBefore.ClientID%>').val();

            if (eval(Warningbefore) >= eval(maxint)) {
                var msg = GetMultiMessage('0794', '', '')
                alert(msg);
                $('#<%=txtWarningBefore.ClientID%>').focus();
                return false;
            }

            if (eval(Startno) >= eval(Endno)) {
                var msg = GetMultiMessage('0225', '', '')
                alert(msg);

                $('#<%=txtStartNo.ClientID%>').focus();
                return false;
            }

            if (eval(Warningbefore) >= eval(Endno)) {
                var msg = GetMultiMessage('0226', '', '')
                alert(msg);
                $('#<%=txtWarningBefore.ClientID%>').focus();
                return false;
            }

            if (eval(Warningbefore) <= eval(Startno)) {
                var msg = GetMultiMessage('0227', '', '')
                alert(msg);
                $('#<%=txtWarningBefore.ClientID%>').focus();
                return false;
            }
            return true;

        }
        
        $(document).ready(function () {
            $('#divInvPaymentDetails').hide();
            $('#divDetails').hide();
            var grid = $("#dgdInvPaymentDetails");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var mydata;
            var strInvPrefix = "";

            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['InvPrefix', 'InvDesc', 'InvStartNo', 'InvEndNo', 'InvWarningBefore','TextCode','InvSeries','','CreatedBy','CreatedDate','ModifiedBy','ModifiedDate'],
                colModel: [
                         { name: 'InvPrefix', index: 'InvPrefix', width: 160, sorttype: "string" },
                         { name: 'InvDesc', index: 'InvDesc', width: 160, sorttype: "string" },
                         { name: 'InvStartNo', index: 'InvStartNo', width: 160, sorttype: "string" },
                         { name: 'InvEndNo', index: 'InvEndNo', width: 160, sorttype: "string" },
                         { name: 'InvWarningBefore', index: 'InvWarningBefore', width: 160, sorttype: "string" },
                         { name: 'TextCode', index: 'TextCode', width: 160, sorttype: "string" },
                         { name: 'InvSeries', index: 'InvSeries', width: 160, sorttype: "string",hidden:true },
                         { name: 'InvSeries', index: 'InvSeries', sortable: false, formatter: editInvSeries },
                         { name: 'CreatedBy', index: 'CreatedBy', width: 160, sorttype: "string", hidden: true },
                         { name: 'CreatedDate', index: 'CreatedDate', width: 160, sorttype: "string", hidden: true },
                         { name: 'ModifiedBy', index: 'ModifiedBy', width: 160, sorttype: "string", hidden: true },
                         { name: 'ModifiedDate', index: 'ModifiedDate', width: 160, sorttype: "string", hidden: true },
                ],
                multiselect: true,
                pager: jQuery('#pager1'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Inv Payment Series Details",
                async: false, //Very important,
                subgrid: false

            });
            loadInvPaymentSeries();

        }); // end of ready function

        function loadInvPaymentSeries() {
            var strInvPrefix = "";
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfInvPayment.aspx/LoadInvPaymentSeries",
                data: "{strInvPrefix: '" + strInvPrefix + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdInvPaymentDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdInvPaymentDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#dgdInvPaymentDetails").jqGrid("hideCol", "subgrid");

        }

        function editInvSeries(cellvalue, options, rowObject) {
            var idInvSeries = rowObject.InvSeries.toString();
            var invPrefix = rowObject.InvPrefix.toString();
            var invDesc = rowObject.InvDesc.toString();
            var invStartNo = rowObject.InvStartNo.toString();
            var invEndNo = rowObject.InvEndNo.toString();
            var invWarningBefore = rowObject.InvWarningBefore.toString();
            var textCode = rowObject.TextCode.toString();
            var createdBy = rowObject.CreatedBy.toString();
            var createdDate = rowObject.CreatedDate.toString();
            var modifiedBy = rowObject.ModifiedBy.toString();
            var modifiedDate = rowObject.ModifiedDate.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editInvPaySer(" + "'" + idInvSeries + "'" + ",'" + invPrefix + "','" + invDesc + "','" + invStartNo + "','" + invEndNo + "','" + invWarningBefore + "','" + textCode + "','" + createdBy + "','" + createdDate + "','" + modifiedBy + "','" + modifiedDate + "'" + "); />";
            return edit;
        }


        function editInvPaySer(idInvSeries, invPrefix, invDesc, invStartNo, invEndNo, invWarningBefore, textCode, createdBy, createdDate, modifiedBy, modifiedDate) {
            $('#divInvPaymentDetails').show();
            $('#divDetails').show();
            $('#<%=hdnIdInvSeries.ClientID%>').val(idInvSeries);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDeleteT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDeleteB.ClientID%>').hide();
            $("#<%=txtPrefix.ClientID%>").attr("disabled", "disabled");
            $('#<%=txtPrefix.ClientID%>').val(invPrefix);
            $('#<%=txtDescription.ClientID%>').val(invDesc);
            $('#<%=txtStartNo.ClientID%>').val(invStartNo);
            $('#<%=txtEndNo.ClientID%>').val(invEndNo);
            $('#<%=txtTextCode.ClientID%>').val(textCode);
            $('#<%=txtWarningBefore.ClientID%>').val(invWarningBefore);
            $('#<%=lblUser.ClientID%>').text(createdBy);
            $('#<%=lblDate.ClientID%>').text(createdDate);
            $('#<%=lblChangedBy.ClientID%>').text(modifiedBy);
            $('#<%=lblChangedDate.ClientID%>').text(modifiedDate);
            $('#<%=hdnMode.ClientID%>').val("Edit"); 
        }

        function addInvPaymentDetails(mdoe) {
            $('#divInvPaymentDetails').show();
            $('#divDetails').hide();
            $("#<%=txtPrefix.ClientID%>").removeAttr("disabled");
            $('#<%=txtDescription.ClientID%>').val("");
            $('#<%=txtEndNo.ClientID%>').val("");
            $('#<%=txtPrefix.ClientID%>').val("");
            $('#<%=txtStartNo.ClientID%>').val("");
            $('#<%=txtTextCode.ClientID%>').val("");
            $('#<%=txtWarningBefore.ClientID%>').val("");
            $('#<%=hdnIdInvSeries.ClientID%>').val("");  
            $('#<%=hdnMode.ClientID%>').val("Add"); 
        }

        function resetDet() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divInvPaymentDetails').hide();
                $('#divDetails').hide();
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDeleteT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDeleteB.ClientID%>').show();
                $('#<%=hdnMode.ClientID%>').val(""); 
            }
        }

        function saveInvPaymentSeries() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var result = fnClientValidate();
            var mode = $('#<%=hdnMode.ClientID%>').val(); 
            var invSeries = $('#<%=hdnIdInvSeries.ClientID%>').val();  
            var invPrefix = $('#<%=txtPrefix.ClientID%>').val();  
            var invDesc = $('#<%=txtDescription.ClientID%>').val();  
            var invStartNo = $('#<%=txtStartNo.ClientID%>').val();  
            var invEndNo = $('#<%=txtEndNo.ClientID%>').val();  
            var invWarningBefore = $('#<%=txtWarningBefore.ClientID%>').val();  
            var textCode = $('#<%=txtTextCode.ClientID%>').val();  
            
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfInvPayment.aspx/SaveInvPaymentSeries",
                    data: "{invSeries: '" + invSeries + "', invPrefix:'" + invPrefix + "', invDesc:'" + invDesc + "', invStartNo:'" + invStartNo + "', invEndNo:'" + invEndNo + "', invWarningBefore:'" + invWarningBefore + "', textCode:'" + textCode + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d == "UPDFLG" || data.d == "0") {
                            jQuery("#dgdInvPaymentDetails").jqGrid('clearGridData');
                            loadInvPaymentSeries();
                            jQuery("#dgdInvPaymentDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divInvPaymentDetails').hide();
                            $('#divDetails').hide();
                            $('#<%=btnAddT.ClientID%>').show();
                            $('#<%=btnDeleteT.ClientID%>').show();
                            $('#<%=btnAddB.ClientID%>').show();
                            $('#<%=btnDeleteB.ClientID%>').show();
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d == "PRESENT" || data.d == 'INSFLGN') {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (data.d == "RECNUPD" ) {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('RECNUPD', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (data.d == "DEPTUSED") {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('USEUPDT', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr"); //colour shd b blue
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }

        function delInvPaymentSeries() {
            var idInvSeries = "";
            $('#dgdInvPaymentDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idInvSeries = $('#dgdInvPaymentDetails tr ')[row].cells[7].innerHTML.toString();
                }
            });

            if (idInvSeries != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteInvPaySeries();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteInvPaySeries() {
            var row;
            var idInvSeries;
            var invPrefix;
            var invPaySeriesxml;
            var invPaySeriesxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdInvPaymentDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    idInvSeries = $('#dgdInvPaymentDetails tr ')[row].cells[7].innerHTML.toString();
                    invPrefix = $('#dgdInvPaymentDetails tr ')[row].cells[1].innerHTML.toString();
                    invPaySeriesxml = '<MASTER INV_PREFIX ="' + idInvSeries.toString() + '" PREFIX = "' + invPrefix.toString() + '" />';
                    invPaySeriesxmls += invPaySeriesxml;
                }
            });
            //invPaySeriesxmls = "<ROOT>" + invPaySeriesxmls + "</ROOT>";
            if (invPaySeriesxmls != "") {
                invPaySeriesxmls = "<ROOT>" + invPaySeriesxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfInvPayment.aspx/DeleteInvPaymentSeries",
                    data: "{invSeriesxml: '" + invPaySeriesxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d[0] == "NDEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        jQuery("#dgdInvPaymentDetails").jqGrid('clearGridData');
                        loadInvPaymentSeries();
                        jQuery("#dgdInvPaymentDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divInvPaymentDetails').hide();
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
              <asp:Label ID="lblHead" runat="server" Text="Invoice Series Configuration" ></asp:Label>
              <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
              <asp:HiddenField id="hdnPageSize" runat="server" />  
              <asp:HiddenField id="hdnEditCap" runat="server" />
              <asp:HiddenField id="hdnIdInvSeries" runat="server" />    
              <asp:HiddenField id="hdnMode" runat="server" />    
        </div>
        <div style="text-align:center">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button" onclick="addInvPaymentDetails('NEW')"/>
            <input id="btnDeleteT" runat="server" type="button" value="Delete" class="ui button" onclick="delInvPaymentSeries()"/>
        </div>
        <div>   
            <div >
                <table id="dgdInvPaymentDetails" title="Invoice Series" ></table>
                <div id="pager1"></div>
            </div>         
            <div style="text-align:center">
                <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addInvPaymentDetails('NEW')"/>
                <input id="btnDeleteB" runat="server" type="button" value="Delete" class="ui button" onclick="delInvPaymentSeries()"/>
            </div>
            <div id="divInvPaymentDetails" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="aheader" runat="server" >Invoice Series</a>
                </div>     
                
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label ID="lblPrefix" runat="server" Text="Prefix"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtPrefix"  padding="0em" runat="server" MaxLength="3"></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label ID="lblDescription" runat="server" Text="Description"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                             <asp:TextBox ID="txtDescription"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblStartno" runat="server" Text="Start Number"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtStartNo"  padding="0em" runat="server" MaxLength="11"></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblEndNo" runat="server" Text="End Number"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtEndNo" runat="server" MaxLength="11"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblWarningBefore" runat="server" Text="Warning Before"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtWarningBefore" runat="server" MaxLength="11"></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblTextCode" runat="server" Text="Text Code"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtTextCode" runat="server" MaxLength="11"></asp:TextBox>
                        </div>                    
                    </div>
                </div>             

                <div style="text-align:center">
                    <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveInvPaymentSeries()"/>
                    <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetDet()" />
                </div>               
             </div>
            <div id="divDetails" class="ui form" style="width: 100%;">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" runat="server" id="adetails">Details</a>
                </div>
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:150px">
                        <asp:Label runat="server" id="lblCrtdBy" Text="Created By:"></asp:Label>
                    </div>
                    <div class="field" style="text-align:center">
                        <asp:Label runat="server" id="lblUser" style="background-color:#e0e0e0;width:250px" Text=""></asp:Label>
                    </div>
                    <div class="field" style="padding-left:5em;width:150px">
                        <asp:Label runat="server" id="lblOn" Text="On"></asp:Label>
                    </div>
                    <div class="field" style="width:200px;text-align:center">
                        <asp:Label runat="server" id="lblDate" style="background-color:#e0e0e0;width:250px" ></asp:Label>
                    </div>                    
                </div>
                <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblLastChngBy" Text="Last Changed By:"></asp:Label>
                        </div>
                        <div class="field" style="text-align:center">
                            <asp:Label runat="server" id="lblChangedBy" style="background-color:#e0e0e0;width:250px" Text=""></asp:Label>
                        </div>
                        <div class="field" style="padding-left:5em;width:150px">
                            <asp:Label runat="server" id="lblOn1" Text="On"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;text-align:center">
                            <asp:Label runat="server" id="lblChangedDate" style="background-color:#e0e0e0;width:250px" ></asp:Label>
                        </div>                    
               </div>
             </div>
        </div>




</asp:Content>
