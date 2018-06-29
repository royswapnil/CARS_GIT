<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfTimeRegistration.aspx.vb" Inherits="CARS.frmCfTimeRegistration" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

     <script type="text/javascript">


         function fnValidateSpCh() {
             if (!(gfi_CheckEmpty($('#<%=txtReasforUnsoldTime.ClientID%>'), '0163'))) {
                 return false;
             }
             else {
                 if (!(gfb_ValidateAlphabets($('#<%=txtReasforUnsoldTime.ClientID%>'), '0163'))) {
                     return false;
                 }
             }
             return true;
         }

         function fnValidateSpChCOut() {
             if (!(gfi_CheckEmpty($('#<%=txtReaforClockOut.ClientID%>'), '0164'))) {
                 return false;
             }
             else {
                 if (!(gfb_ValidateAlphabets($('#<%=txtReaforClockOut.ClientID%>'), '0164'))) {
                     return false;
                 }
             }
             return true;
         }

         $(document).ready(function () {
             $("#accordion").accordion();
             var grid = $("#dgdReasonUT");
             var gridClkOut = $("#dgdClkOut");
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var mydata,clkOdata;

             $('#divUSTime').hide();
             $('#divClkOut').hide();

             //Reasons for Unsold Time
             grid.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Description', 'IdSettings', 'IdConfig', ''],
                 colModel: [
                          { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                          { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editUSTime }
                 ],
                 multiselect: true,
                 pager: jQuery('#pager1'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "Reasons for Unsold Time",
                 async: false, //Very important,
                 subgrid: false

             });

             //Reasons for ClkOut
             gridClkOut.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['Description','% Complete', 'IdSettings', 'IdConfig', ''],
                 colModel: [
                          { name: 'Description', index: 'Description', width: 160, sorttype: "string" },
                          { name: 'TR_Percentage', index: 'TR_Percentage', width: 160, sorttype: "string" },
                          { name: 'IdSettings', index: 'IdSettings', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdConfig', index: 'IdConfig', width: 160, sorttype: "string", hidden: true },
                          { name: 'IdSettings', index: 'IdSettings', sortable: false, formatter: editClkOut }
                 ],
                 multiselect: true,
                 pager: jQuery('#pagerClkOut'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "Reasons for Clock Out",
                 async: false, //Very important,
                 subgrid: false

             });

             loadTimeRegConfig();

         });//end of ready

         function loadTimeRegConfig() {
             var mydata;
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfTimeRegistration.aspx/LoadTimeRegConfig",
                 data: "{}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     loadUSTime(data.d[0]);
                     loadClkOut(data.d[1]);
                 }
             });
         }

         function loadUSTime(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdReasonUT").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 mydata = data;
                 jQuery("#dgdReasonUT").jqGrid('addRowData', i + 1, mydata[i]);
             }
             jQuery("#dgdReasonUT").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdReasonUT").jqGrid("hideCol", "subgrid");
             return true;
         }

         function loadClkOut(data) {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             jQuery("#dgdClkOut").jqGrid('clearGridData');
             for (i = 0; i < data.length; i++) {
                 clkOdata = data;
                 jQuery("#dgdClkOut").jqGrid('addRowData', i + 1, clkOdata[i]);
             }
             jQuery("#dgdClkOut").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             $("#dgdClkOut").jqGrid("hideCol", "subgrid");
             return true;
         }

         function addUSTime() {
             $('#divUSTime').show();
             $('#<%=txtReasforUnsoldTime.ClientID%>').val("");
             $('#<%=btnAddUSTimeT.ClientID%>').hide();
             $('#<%=btnDelUSTimeT.ClientID%>').hide();
             $('#<%=btnAddUSTimeB.ClientID%>').hide();
             $('#<%=btnDelUSTimeB.ClientID%>').hide();
             $('#<%=btnSaveUSTime.ClientID%>').show();
             $('#<%=btnResetUSTime.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=hdnUSTimeId.ClientID%>').val("");
         }

         function resetUSTime() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divUSTime').hide();
                 $('#<%=txtReasforUnsoldTime.ClientID%>').val("");
                 $('#<%=btnAddUSTimeT.ClientID%>').show();
                 $('#<%=btnAddUSTimeB.ClientID%>').show();
                 $('#<%=btnDelUSTimeT.ClientID%>').show();
                 $('#<%=btnDelUSTimeB.ClientID%>').show();
                 $('#<%=btnSaveUSTime.ClientID%>').hide();
                 $('#<%=btnResetUSTime.ClientID%>').hide();
                 $('#<%=hdnUSTimeId.ClientID%>').val("");
             }  
         }

         function editUSTime(cellvalue, options, rowObject) {
             var idSettings = rowObject.IdSettings.toString();
             var idConfig = rowObject.IdConfig.toString();

             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editUSTimeDetails(" + "'" + idSettings + "'" + ",'" + idConfig + "'" + "); />";
             return edit;
         }

         function editUSTimeDetails(idSettings, idConfig) {
             $('#divUSTime').show();
             $('#<%=hdnUSTimeId.ClientID%>').val(idSettings);
             getTimeRegDet(idConfig, idSettings)
             $('#<%=btnAddUSTimeT.ClientID%>').hide();
             $('#<%=btnDelUSTimeT.ClientID%>').hide();
             $('#<%=btnAddUSTimeB.ClientID%>').hide();
             $('#<%=btnDelUSTimeB.ClientID%>').hide();
             $('#<%=btnSaveUSTime.ClientID%>').show();
             $('#<%=btnResetUSTime.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");

         }

         function saveUSTime() {
             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnValidateSpCh();
            if (result == true) {
                 var usTDesc = $('#<%=txtReasforUnsoldTime.ClientID%>').val();
                 var idconfig = "TR-REASCD";
                 var idsettings = $('#<%=hdnUSTimeId.ClientID%>').val();

                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfTimeRegistration.aspx/SaveUSTime",
                     data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + usTDesc + "', mode:'" + mode + "'}",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         data = data.d[0];
                         if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                             jQuery("#dgdReasonUT").jqGrid('clearGridData');
                             loadTimeRegConfig();
                             jQuery("#dgdReasonUT").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divUSTime').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                             $('#<%=btnAddUSTimeT.ClientID%>').show();
                             $('#<%=btnAddUSTimeB.ClientID%>').show();
                             $('#<%=btnDelUSTimeT.ClientID%>').show();
                             $('#<%=btnDelUSTimeB.ClientID%>').show();

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

         function delUSTime() {
             var ustId = "";
             $('#dgdReasonUT input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     ustId = $('#dgdReasonUT tr ')[row].cells[2].innerHTML.toString();
                 }
             });

             if (ustId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteUSTime();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteUSTime() {
             var row;
             var ustId;
             var ustDesc;
             var ustIdxml;
             var ustIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdReasonUT input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     ustId = $('#dgdReasonUT tr ')[row].cells[2].innerHTML.toString();
                     ustDesc = $('#dgdReasonUT tr ')[row].cells[1].innerHTML.toString();
                     ustIdxml = '<delete><TR-REASCD ID_SETTINGS= "' + ustId + '" ID_CONFIG= "TR-REASCD" DESCRIPTION= "' + ustDesc + '"/></delete>';
                     ustIdxmls += ustIdxml;
                 }
             });

             if (ustIdxmls != "") {
                 ustIdxmls = "<root>" + ustIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfTimeRegistration.aspx/Delete",
                     data: "{xmlDoc: '" + ustIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         jQuery("#dgdReasonUT").jqGrid('clearGridData');
                         loadTimeRegConfig();
                         jQuery("#dgdReasonUT").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $('#divRepairPkgCatg').hide();
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

         function addClkOut() {
             $('#divClkOut').show();
             $('#<%=txtReaforClockOut.ClientID%>').val("");
             $('#<%=btnAddClkOutT.ClientID%>').hide();
             $('#<%=btnDelClkOutT.ClientID%>').hide();
             $('#<%=btnAddClkOutB.ClientID%>').hide();
             $('#<%=btnDelClkOutB.ClientID%>').hide();
             $('#<%=btnSaveClkOut.ClientID%>').show();
             $('#<%=btnResetClkOut.ClientID%>').show();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
             $('#<%=hdnClkOutId.ClientID%>').val("");
             $('#<%=ddlPerComp.ClientID%>')[0].selectedIndex = 0;
         }

         function delClkOut() {
             var clkoutId = "";
             $('#dgdClkOut input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     clkoutId = $('#dgdClkOut tr ')[row].cells[3].innerHTML.toString();
                 }
             });

             if (clkoutId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteClkOut();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteClkOut() {
             var row;
             var clkOutId;
             var clkOutDesc;
             var clkOutIdxml;
             var clkOutIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdClkOut input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     clkOutId = $('#dgdClkOut tr ')[row].cells[3].innerHTML.toString();
                     clkOutDesc = $('#dgdClkOut tr ')[row].cells[1].innerHTML.toString();
                     clkOutIdxml = '<delete><TR-COUT ID_SETTINGS= "' + clkOutId + '" ID_CONFIG= "TR-COUT" DESCRIPTION= "' + clkOutDesc + '"/></delete>';
                     clkOutIdxmls += clkOutIdxml;
                 }
             });

             if (clkOutIdxmls != "") {
                 clkOutIdxmls = "<root>" + clkOutIdxmls + "</root>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfTimeRegistration.aspx/Delete",
                     data: "{xmlDoc: '" + clkOutIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         jQuery("#dgdClkOut").jqGrid('clearGridData');
                         loadTimeRegConfig();
                         jQuery("#dgdClkOut").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $('#divClkOut').hide();
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

         function saveClkOut() {

             var mode = $('#<%=hdnMode.ClientID%>').val();
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnValidateSpChCOut();
              if (result == true) {
             var desc = $('#<%=txtReaforClockOut.ClientID%>').val();
             var idconfig = "TR-COUT";
             var idsettings = $('#<%=hdnClkOutId.ClientID%>').val();
             var trPerc = $('#<%=ddlPerComp.ClientID%>').val();

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfTimeRegistration.aspx/SaveClockOut",
                 data: "{idconfig: '" + idconfig + "', idsettings:'" + idsettings + "', desc:'" + desc + "', trperc:'" + trPerc + "', mode:'" + mode + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     data = data.d[0];
                     if (data.RetVal_Saved != "" || data.RetVal_NotSaved == "") {
                         jQuery("#dgdClkOut").jqGrid('clearGridData');
                         loadTimeRegConfig();
                         jQuery("#dgdClkOut").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $('#divClkOut').hide();
                         $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                         $('#<%=RTlblError.ClientID%>').removeClass();
                         $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         $('#<%=btnAddClkOutT.ClientID%>').show();
                         $('#<%=btnAddClkOutB.ClientID%>').show();
                         $('#<%=btnDelClkOutT.ClientID%>').show();
                         $('#<%=btnDelClkOutB.ClientID%>').show();
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

         function resetClkOut() {
             var msg = GetMultiMessage('0161', '', '');
             var r = confirm(msg);
             if (r == true) {
                 $('#divClkOut').hide();
                 $('#<%=txtReaforClockOut.ClientID%>').val("");
                 $('#<%=btnAddClkOutT.ClientID%>').show();
                 $('#<%=btnAddClkOutB.ClientID%>').show();
                 $('#<%=btnDelClkOutT.ClientID%>').show();
                 $('#<%=btnDelClkOutB.ClientID%>').show();
                 $('#<%=btnSaveClkOut.ClientID%>').hide();
                 $('#<%=btnResetClkOut.ClientID%>').hide();
                 $('#<%=hdnClkOutId.ClientID%>').val("");
             }
         }

         function editClkOut(cellvalue, options, rowObject) {
             var idSettings = rowObject.IdSettings.toString();
             var idConfig = rowObject.IdConfig.toString();
             $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editClkOutDetails(" + "'" + idSettings + "'" + ",'" + idConfig + "'" + "); />";
             return edit;
         }

         function editClkOutDetails(idSettings, idConfig) {
             $('#divClkOut').show();
             $('#<%=hdnClkOutId.ClientID%>').val(idSettings);
             getTimeRegDet(idConfig, idSettings);
             $('#<%=btnAddClkOutT.ClientID%>').hide();
             $('#<%=btnDelClkOutT.ClientID%>').hide();
             $('#<%=btnAddClkOutB.ClientID%>').hide();
             $('#<%=btnDelClkOutB.ClientID%>').hide();
             $('#<%=btnSaveClkOut.ClientID%>').show();
             $('#<%=btnResetClkOut.ClientID%>').show();
             $('#<%=hdnMode.ClientID%>').val("Edit");

         }

         function getTimeRegDet(idConfig, idSettings) {

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfTimeRegistration.aspx/GetTimeRegDet",
                 data: "{idConfig: '" + idConfig + "', idSettings:'" + idSettings + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0) {
                         if (data.d[0].IdConfig == "TR-REASCD" || data.d[0].IdConfig == "TR-IDLECD") {
                             $('#<%=txtReasforUnsoldTime.ClientID%>').val(data.d[0].Description);
                         }
                         else if (data.d[0].IdConfig == "TR-COUT") {
                            $('#<%=txtReaforClockOut.ClientID%>').val(data.d[0].Description);
                            if (data.d[0].TR_Percentage != "0" || data.d[0].TR_Percentage != "") {
                                $("#<%=ddlPerComp.ClientID%>").val(data.d[0].TR_Percentage);
                            } else {
                                $('#<%=ddlPerComp.ClientID%>')[0].selectedIndex = 0;
                            }
                         }
                     }                     
                 }
             });
         }


     </script>



            <div class="header1 two fields" style="padding-top:0.5em">
                <asp:Label ID="lblHead" runat="server" Text="Time Registration Configuration" ></asp:Label>
                <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
                <asp:HiddenField id="hdnPageSize" runat="server" />  
                <asp:HiddenField id="hdnEditCap" runat="server" />
                <asp:HiddenField id="hdnMode" runat="server" /> 
                <asp:HiddenField id="hdnSelect" runat="server" />    
                <asp:HiddenField id="hdnUSTimeId" runat="server" />
                <asp:HiddenField id="hdnClkOutId" runat="server" />
            </div>
            <div id="accordion">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a2" runat="server" >Reasons for Unsold Time</a>
                </div> 
                <div > 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddUSTimeT" runat="server" type="button" value="Add" class="ui button"  onclick="addUSTime()"/>
                        <input id="btnDelUSTimeT" runat="server" type="button" value="Delete" class="ui button" onclick="delUSTime()"/>
                    </div>  
                    <div >
                        <table id="dgdReasonUT" title="Reasons for Unsold Time" ></table>
                        <div id="pager1"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddUSTimeB" runat="server" type="button" value="Add" class="ui button" onclick="addUSTime()"/>
                        <input id="btnDelUSTimeB" runat="server" type="button" value="Delete" class="ui button" onclick="delUSTime()"/>
                    </div>
                    <div id="divUSTime">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="aheader" runat="server" >Reasons for Unsold Time</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblUT" runat="server" Text="Reasons for Unsold Time"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtReasforUnsoldTime"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>                            
                            </div>
                        </div>             

                        <div style="text-align:left">
                            <input id="btnSaveUSTime" class="ui button" runat="server"  value="Save" type="button" onclick="saveUSTime()"/>
                            <input id="btnResetUSTime" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetUSTime()" />
                        </div>               
                   </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="item" id="a1" runat="server" >Reasons for Clock Out</a>
                </div> 
                <div> 
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddClkOutT" runat="server" type="button" value="Add" class="ui button"  onclick="addClkOut()"/>
                        <input id="btnDelClkOutT" runat="server" type="button" value="Delete" class="ui button" onclick="delClkOut()"/>
                    </div>  
                    <div >
                        <table id="dgdClkOut" title="Reasons for Clock Out" ></table>
                        <div id="pagerClkOut"></div>
                    </div>         
                    <div style="text-align:left;padding-left:5em">
                        <input id="btnAddClkOutB" runat="server" type="button" value="Add" class="ui button" onclick="addClkOut()"/>
                        <input id="btnDelClkOutB" runat="server" type="button" value="Delete" class="ui button" onclick="delClkOut()"/>
                    </div>
                    <div id="divClkOut" class="ui raised segment signup inactive">
                        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                            <a class="active item" id="a3" runat="server" >Reasons for Clock Out</a>
                        </div>
                        <div class="ui form" style="width: 100%;">
                            <div class="four fields">
                                <div class="field" style="width:180px">
                                    <asp:Label ID="lblReasUnsoldTime" runat="server" Text="Reasons for Unsold Time"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                    <asp:TextBox ID="txtReaforClockOut"  padding="0em" runat="server" MaxLength="50"></asp:TextBox>
                                </div>     
                                 <div class="field" style="width:180px">
                                    <asp:Label ID="lblPerComp" runat="server" Text="% Complete"></asp:Label><span class="mand">*</span>
                                </div>
                                <div class="field" style="width:200px">
                                     <asp:DropDownList ID="ddlPerComp" runat="server" Width="250px" ></asp:DropDownList>
                                </div>                              
                            </div>
                        </div>             

                        <div style="text-align:left">
                            <input id="btnSaveClkOut" class="ui button" runat="server"  value="Save" type="button" onclick="saveClkOut()"/>
                            <input id="btnResetClkOut" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetClkOut()" />
                        </div>               
                   </div>
                </div>
            </div>

</asp:Content>