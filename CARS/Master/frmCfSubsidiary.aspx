<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfSubsidiary.aspx.vb" EnableEventValidation="true" Inherits="CARS.frmCfSubsidiary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    
     <script type="text/javascript">
         $(document).ready(function () {
             $('#divSubDetails').hide();
             $('#divDetails').hide();
             var grid = $("#dgdSubDetails"); 
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var mydata;

             $('#<%=txtSubsidiaryID.ClientID%>').change(function (e) {
                 var subId = $('#<%=txtSubsidiaryID.ClientID%>').val();
                 edt(subId);
             });

             grid.jqGrid({
                 datatype: "local",
                 data: mydata,
                 colNames: ['SubsidiaryID', 'SubsidiaryName', 'SubsidiaryManager', 'AddressLine1', 'AddressLine2', 'Telephone', 'Mobile', 'Email', 'Organization',''],
                 colModel: [
                          { name: 'SubsidiaryID', index: 'SubsidiaryID', width: 60, sorttype: "string" },
                          { name: 'SubsidiaryName', index: 'SubsidiaryName', width: 90, sorttype: "string" },
                          { name: 'SubsidiaryManager', index: 'SubsidiaryManager', width: 120, sorttype: "string" },
                          { name: 'AddressLine1', index: 'AddressLine1', width: 90, sorttype: "string" },
                          { name: 'AddressLine2', index: 'AddressLine2', width: 90, sorttype: "string" },
                          { name: 'Telephone', index: 'Telephone', width: 90, sorttype: "string" },
                          { name: 'Mobile', index: 'Mobile', width: 90, sorttype: "string" },
                          { name: 'Email', index: 'Email', width: 90, sorttype: "string" },
                          { name: 'Organization', index: 'Organization', width: 90, sorttype: "string" },
                          { name: 'SubsidiaryID', index: 'SubsidiaryID', sortable: false, formatter: displayButtons }
                 ],
                 multiselect: true,
                 pager: jQuery('#pager1'),
                 rowNum: pageSize,//can fetch from webconfig
                 rowList: 5,
                 sortorder: 'asc',
                 viewrecords: true,
                 height: "50%",
                 caption: "Subsidiary Details",
                 async: false, //Very important,
                 subgrid: false

             });

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfSubsidiary.aspx/LoadSubsidiary",
                 data: '{}',
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     for (i = 0; i < data.d.length; i++) {
                         mydata = data;
                         jQuery("#dgdSubDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                     }
                 }
             });

             jQuery("#dgdSubDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
             getGridHeaders();
             $("#dgdSubDetails").jqGrid("hideCol", "subgrid");


             $('#<%=txtZipCode.ClientID%>').autocomplete({
                 source: function (request, response) {
                     $.ajax({
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmCfSubsidiary.aspx/GetZipCodes",
                         data: "{'zipCode':'" + $('#<%=txtZipCode.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             response($.map(data.d, function (item) {
                                 return {
                                     label: item.split('-')[0] + "-" + item.split('-')[3],
                                     val: item.split('-')[0],
                                     value: item.split('-')[0],
                                     country: item.split('-')[1],
                                     state: item.split('-')[2],
                                     city: item.split('-')[3],
                                 }
                             }))
                         },
                         error: function (xhr, status, error) {
                             alert("Error" + error);
                             var err = eval("(" + xhr.responseText + ")");
                             alert('Error Response ' + err.Message);
                         }
                     });
                 },
                 select: function (e, i) {
                     $("#<%=txtZipCode.ClientID%>").val(i.item.val);
                     $("#<%=txtCountry.ClientID%>").val(i.item.country);
                     $("#<%=txtState.ClientID%>").val(i.item.state);
                     $("#<%=txtCity.ClientID%>").val(i.item.city);
                 },
             });

         });//end of ready function

         function displayButtons(cellvalue, options, rowObject) {
             var subID = rowObject.SubsidiaryID.toString();
             var strOptions = cellvalue;
             var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");

             var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edt(" + "'" + subID + "'"+ "); />";
             return edit;
         }

         function resetSubDet() {
             var msg = GetMultiMessage('0161', '', ''); 
             var r = confirm(msg); 
             if (r == true) {
                $('#divSubDetails').hide();
                $('#divDetails').hide();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("");
             }             
         }

         function addSubDetails() {
             $('#<%=txtSubsidiaryID.ClientID%>').val("");
             $('#<%=txtSubsidiaryName.ClientID%>').val("");
             $('#<%=txtSubsidiaryManager.ClientID%>').val("");
             $('#<%=txtAddrLine1.ClientID%>').val("");
             $('#<%=txtAddrLine2.ClientID%>').val("");
             $('#<%=txtTeleNo.ClientID%>').val("");
             $('#<%=txtMobileNo.ClientID%>').val("");
             $('#<%=txtFaxNo.ClientID%>').val("");
             $('#<%=txtEmail.ClientID%>').val("");
             $('#<%=txtOrganization.ClientID%>').val("");
             $('#<%=txtSwift.ClientID%>').val("");
             $('#<%=txtIBAN.ClientID%>').val("");
             $('#<%=txtBankAccnt.ClientID%>').val("");
             $('#<%=txtAccntCode.ClientID%>').val("");
             $('#<%=txtCity.ClientID%>').val("");
             $('#<%=txtCountry.ClientID%>').val("");
             $('#<%=txtState.ClientID%>').val("");
             $('#<%=DrpTransMethod.ClientID%>')[0].selectedIndex=0;
             $('#divSubDetails').show();
             $('#divDetails').hide();
             $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add")
             $('#<%=txtZipCode.ClientID%>').val("");
             $("#<%=txtSubsidiaryID.ClientID%>")[0].readOnly = false;             
             $("#<%=txtAccntCode.ClientID%>").attr("disabled", "disabled");
             $('#<%=txtSubsidiaryID.ClientID%>').focus();
         }

         function edt(subID) {
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfSubsidiary.aspx/FetchSubsidiary",
                 data: "{subID: '" + subID + "'}",
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     if (data.d.length > 0)
                     {
                         mydata = data;
                         $('#<%=txtSubsidiaryID.ClientID%>').val(data.d[0].SubsidiaryID);
                         $('#<%=txtSubsidiaryName.ClientID%>').val(data.d[0].SubsidiaryName);
                         $('#<%=txtSubsidiaryManager.ClientID%>').val(data.d[0].SubsidiaryManager);
                         $('#<%=txtAddrLine1.ClientID%>').val(data.d[0].AddressLine1);
                         $('#<%=txtAddrLine2.ClientID%>').val(data.d[0].AddressLine2);
                         $('#<%=txtTeleNo.ClientID%>').val(data.d[0].Telephone);
                         $('#<%=txtMobileNo.ClientID%>').val(data.d[0].Mobile);
                         $('#<%=txtFaxNo.ClientID%>').val(data.d[0].FaxNo);
                         $('#<%=txtEmail.ClientID%>').val(data.d[0].Email);
                         $('#<%=txtOrganization.ClientID%>').val(data.d[0].Organization);
                         $('#<%=txtSwift.ClientID%>').val(data.d[0].Swift);
                         $('#<%=txtIBAN.ClientID%>').val(data.d[0].IBAN);
                         $('#<%=txtBankAccnt.ClientID%>').val(data.d[0].BankAccnt);
                         $('#<%=txtAccntCode.ClientID%>').val(data.d[0].AccntCode);
                         $('#<%=txtCity.ClientID%>').val(data.d[0].City);
                         $('#<%=txtCountry.ClientID%>').val(data.d[0].Country);
                         $('#<%=txtState.ClientID%>').val(data.d[0].State);
                         $('#<%=DrpTransMethod.ClientID%>').val(data.d[0].TransferMethod);
                         $('#<%=txtZipCode.ClientID%>').val(data.d[0].ZipCode);
                         $('#<%=lblUser.ClientID%>').text(data.d[0].UserID);
                         $('#<%=lblDate.ClientID%>').text(data.d[0].CreatedDate);
                         $('#<%=lblChangedBy.ClientID%>').text(data.d[0].ModifiedBy);
                         $('#<%=lblChangedDate.ClientID%>').text(data.d[0].ModifiedDate);
                         $("#<%=txtSubsidiaryID.ClientID%>")[0].readOnly = true;
                         $('#divSubDetails').show();
                         $('#divDetails').show();
                         $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");

                         if ($('#<%=DrpTransMethod.ClientID%>').val()=="Gross")
                         {
                             $("#<%=txtAccntCode.ClientID%>").removeAttr("disabled");
                         }
                         else
                         {
                             $("#<%=txtAccntCode.ClientID%>").attr("disabled", "disabled");
                         }
                         $('#<%=txtSubsidiaryName.ClientID%>').focus();
                     }
                     else
                     {
                         addSubDetails();
                         $('#<%=txtSubsidiaryID.ClientID%>').val(subID);
                     }                     
                 }
             });       
         }

         function fnEnableAccCode() {
             if ($('#<%=DrpTransMethod.ClientID%>').val().toLowerCase() == 'gross') {
                    $("#<%=txtAccntCode.ClientID%>").removeAttr("disabled");
                    $("#<%=txtAccntCode.ClientID%>").focus();
                 }
                 else {
                     $("#<%=txtAccntCode.ClientID%>").val("");
                     $("#<%=txtAccntCode.ClientID%>").attr("disabled", "disabled");
                 }
         }

         function getGridHeaders() {
             $("#dgdSubDetails").setCaption($('#<%=aheader.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "SubsidiaryID", $('#<%=lblSubsidiaryID.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "SubsidiaryName", $('#<%=lblSubsidiaryName.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "SubsidiaryManager", $('#<%=lblSubsidiaryManager.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "AddressLine1", $('#<%=lblAddrLine1.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "AddressLine2", $('#<%=lblAddrLine2.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "Telephone", $('#<%=lblTele.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "Mobile", $('#<%=lblMobileNo.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "Email", $('#<%=lblEmail.ClientID%>')[0].innerText);
             $('#dgdSubDetails').jqGrid("setLabel", "Organization", $('#<%=lblOrganization.ClientID%>')[0].innerText);
         }

         function loadSubDetails() {
             jQuery("#dgdSubDetails").jqGrid('clearGridData');
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmCfSubsidiary.aspx/LoadSubsidiary",
                 data: '{}',
                 dataType: "json",
                 async: false,//Very important
                 success: function (data) {
                     for (i = 0; i < data.d.length; i++) {
                         mydata = data;
                         jQuery("#dgdSubDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                     }
                 }
             });
             jQuery("#dgdSubDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
         }

         function saveSub() {
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
             var result = fnValidate();
             if (result == true) {
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfSubsidiary.aspx/SaveSubsidiary",
                     data: "{subId: '" + $('#<%=txtSubsidiaryID.ClientID%>').val() + "', subname:'" + $('#<%=txtSubsidiaryName.ClientID%>').val() + "', subMgr:'" + $('#<%=txtSubsidiaryManager.ClientID%>').val() + "', subAddrL1:'" + $('#<%=txtAddrLine1.ClientID%>').val() + "', subAddrL2:'" + $('#<%=txtAddrLine2.ClientID%>').val() + "', subTele:'" + $('#<%=txtTeleNo.ClientID%>').val() + "', subMobile:'" + $('#<%=txtMobileNo.ClientID%>').val() + "', subEmail:'" + $('#<%=txtEmail.ClientID%>').val() + "', subOrg:'" + $('#<%=txtOrganization.ClientID%>').val() + "', subFaxno:'" + $('#<%=txtFaxNo.ClientID%>').val() + "', subIBAN:'" + $('#<%=txtIBAN.ClientID%>').val() + "', subSwift:'" + $('#<%=txtSwift.ClientID%>').val() + "', subBankAccnt:'" + $('#<%=txtBankAccnt.ClientID%>').val() + "', subCountry:'" + $('#<%=txtCountry.ClientID%>').val() + "', subState:'" + $('#<%=txtState.ClientID%>').val() + "', subCity:'" + $('#<%=txtCity.ClientID%>').val() + "', subTransferMethod:'" + $('#<%=DrpTransMethod.ClientID%>').val() + "', subAccntCode:'" + $('#<%=txtAccntCode.ClientID%>').val() + "', subZipCode:'" + $('#<%=txtZipCode.ClientID%>').val() + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d == "UPDFLG" || data.d == "INSFLG") {
                             jQuery("#dgdSubDetails").jqGrid('clearGridData');
                             loadSubDetails();
                             jQuery("#dgdSubDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                             $('#divSubDetails').hide();
                             $('#divDetails').hide();
                             $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         }
                         else if (data.d == "Present" || data.d == 'INSFLGN') {
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

         function fnValidate() {
             var zipCode = $('#<%=txtZipCode.ClientID%>').val();
             if (!(gfi_CheckEmpty($('#<%=txtSubsidiaryID.ClientID%>'), '0071'))) {
                 return false;
             }
             if (!(gfi_ValidateNumber($('#<%=txtSubsidiaryID.ClientID%>'), '0071'))) {
                 $('#<%=txtSubsidiaryID.ClientID%>').val("");
                 $('#<%=txtSubsidiaryID.ClientID%>').focus();
                 return false;
             }
             if ($('#<%=txtSubsidiaryID.ClientID%>').val() < 1) {
                 var msg = GetMultiMessage('0800', '', '');
                 alert(msg);
                 $('#<%=txtSubsidiaryID.ClientID%>').focus();
                 return false
             }
             if (!(gfi_CheckEmpty($('#<%=txtSubsidiaryName.ClientID%>'), '0113'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtSubsidiaryName.ClientID%>'), '0113'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtOrganization.ClientID%>'), '0118'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtSubsidiaryManager.ClientID%>'), '0114'))) {
                 return false;
             }
             if ($('#<%=DrpTransMethod.ClientID%>')[0].selectedIndex == 0) {
                 var msg = GetMultiMessage('ERRTM', '', '');
                 alert(msg);
                 $('#<%=DrpTransMethod.ClientID%>').focus();
                 return false
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtAddrLine1.ClientID%>'), '0115'))) {
                 return false;
             }
             if (!(gfb_ValidateAlphabets($('#<%=txtAddrLine2.ClientID%>'), '0115'))) {
                 return false;
             }
             if (zipCode != "") {
                 if (!(gfb_ValidateAlphabets($('#<%=txtCity.ClientID%>'), '0194'))) {
                     return false;
                 }
                 if (!(gfb_ValidateAlphabets($('#<%=txtCountry.ClientID%>'), '0192'))) {
                     return false;
                 }
                 if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193'))) {
                     return false;
                 }
             }
             if (!(gfi_ValidatePhoneNumber($('#<%=txtTeleNo.ClientID%>'), '0117', '-'))) {
                 return false;
             }
             if (!(gfi_ValidatePhoneNumber($('#<%=txtMobileNo.ClientID%>'), '0041', '-'))) {
                 return false;
             }
             if (!(gfi_ValidatePhoneNumber($('#<%=txtFaxNo.ClientID%>'), '0120', '-'))) {
                 return false;
             }
             if (!(gfi_ValidateEmail($('#<%=txtEmail.ClientID%>')))) {
                 return false;
             }
             return true;
         }

         function delSubsidiary() {
             var subId = "";
             $('#dgdSubDetails input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     subId = $('#dgdSubDetails tr ')[row].cells[2].innerHTML.toString();
                 }
             });

             if (subId != "") {
                 var msg = GetMultiMessage('0016', '', '');
                 var r = confirm(msg);
                 if (r == true) {
                     deleteSub();
                 }
             }
             else {
                 var msg = GetMultiMessage('SelectRecord', '', '');
                 alert(msg);
             }
         }

         function deleteSub()
         {
             var row;
             var subId;
             var subName;
             var subIdxml;
             var subIdxmls = "";
             var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

             $('#dgdSubDetails input:checkbox').attr("checked", function () {
                 if (this.checked) {
                     row = $(this).closest('td').parent()[0].sectionRowIndex;
                     subId = $('#dgdSubDetails tr ')[row].cells[2].innerHTML.toString();
                     subName = $('#dgdSubDetails tr ')[row].cells[3].innerHTML.toString();
                     subIdxml = "<Master><SubsideryId>" + subId + "</SubsideryId>" + "<Subsideryname>" + subName + "</Subsideryname></Master>";
                     subIdxmls += subIdxml;
                 }
             });

             if (subIdxmls != "") {
                 subIdxmls = "<ROOT>" + subIdxmls + "</ROOT>";
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "frmCfSubsidiary.aspx/DeleteSubsidiary",
                     data: "{subIdxmls: '" + subIdxmls + "'}",
                     dataType: "json",
                     success: function (data) {
                         jQuery("#dgdSubDetails").jqGrid('clearGridData');
                         loadSubDetails();
                         jQuery("#dgdSubDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                         $('#divSubDetails').hide();
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

     </script>


        <div class="header1 two fields" style="padding-top:0.5em">
              <asp:Label ID="lblHead" runat="server" Text="Subsidiary Details" ></asp:Label>
              <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
              <asp:HiddenField ID="hdnMode" runat="server" />
              <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
              <asp:HiddenField ID="hdnPageSize" runat="server" />
        </div>
        <div style="text-align:center">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button" onclick="addSubDetails()"/>
            <input id="btnDeleteT" runat="server" type="button" value="Delete" class="ui button" onclick="delSubsidiary()"/>
            <input id="btnPrintT" runat="server" type="button" value="Print" class="ui button" />
        </div>
        <div>
            <div class="field">
                
            </div>
            <div>
                <table id="dgdSubDetails" title="Subsidiary Details"></table>
                <div id="pager1" ></div>
            </div>
            <div style="text-align:center">
                <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addSubDetails()"/>
                <input id="btnDeleteB" runat="server" type="button" value="Delete" class="ui button" onclick="delSubsidiary()" />
                <input id="btnPrintB" runat="server" type="button" value="Print" class="ui button" />
            </div>
            <div id="divSubDetails" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a id="aheader" runat="server" class="active item">Subsidiary Details</a>  
                </div>     
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">                            
                            <asp:Label id="lblSubsidiaryID" runat="server" Text="Subsidiary ID"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtSubsidiaryID"  padding="0em"  runat="server" Class="fieldTextbox"></asp:TextBox>
                        </div>

                        <div class="field" style="padding-left:1em;width:150px">                           
                            <asp:Label runat="server" ID="lblSubsidiaryName" Text="Subsidiary Name"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtSubsidiaryName"  runat="server" ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblSubsidiaryManager" Text="Subsidiary Manager"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtSubsidiaryManager" runat="server"></asp:TextBox>
                        </div>

                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblTele" Text="Telephone No.(Personal)"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtTeleNo" runat="server" ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblMobileNo" Text="Mobile No."></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtMobileNo" runat="server" ></asp:TextBox>
                        </div>

                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblFaxNo" Text="Fax No."></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtFaxNo" runat="server"  ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblEmail" Text="E-mail"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtEmail" runat="server" ></asp:TextBox>
                        </div>

                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblOrganization" Text="Organization"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtOrganization" runat="server"  ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblSwift" Text="SWIFT"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtSwift" runat="server" ></asp:TextBox>
                        </div>

                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblIBAN" Text="IBAN"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtIBAN" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblBankAccnt" Text="Bank Account"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtBankAccnt" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblTrasnferMethod" Text="Transfer Method"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:DropDownList runat="server" ID="DrpTransMethod" onchange="fnEnableAccCode()"></asp:DropDownList>
                        </div>
                         <div class="field" style="padding-left:0.55em;width:100px">
                             <asp:Label runat="server"  id="lblAccntCode" Text="Account Code"></asp:Label>
                        </div>
                        <div class="field" style="width:60px">
                            <asp:TextBox ID="txtAccntCode" runat="server" ></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" runat="server" id="aAddrComm">Address for Communication</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblAddrLine1" Text="Address Line 1"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtAddrLine1" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblAddrLine2" Text="Address Line 2"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtAddrLine2" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblZipCode" Text="ZipCode"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <input type="text" runat="server" id="txtZipCode" />
                        </div>
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblCity" Text="City"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblCountry" Text="Country"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtCountry" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblState" Text="State"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtState" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div style="text-align:center">
                    <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" onclick="saveSub()" />
                    <input id="btnReset" runat="server" class="ui button" value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetSubDet()" />
                </div>               
             </div>
            <div id="divDetails" class="ui form" style="width: 100%;">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" runat="server" id="aDetails">Details</a>
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
                            <asp:Label runat="server" id="lblChangedBy" style="background-color:#e0e0e0;width:250px" Text="Changed By:"></asp:Label>
                        </div>
                        <div class="field" style="padding-left:5em;width:150px">
                            <asp:Label runat="server" id="lblOn1" Text="On"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;text-align:center">
                            <asp:Label runat="server" id="lblChangedDate" style="background-color:#e0e0e0;width:250px" Text="Changed By:"></asp:Label>
                        </div>                    
               </div>
             </div>            
        </div>


</asp:Content>