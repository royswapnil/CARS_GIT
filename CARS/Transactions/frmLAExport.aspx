<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLAExport.aspx.vb" Inherits="CARS.frmLAExport" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
 <script type="text/javascript">
     $(document).ready(function () {
         var dateFormat = "";
         if ($('#<%=hdnDateFormat.ClientID%>').val() == "dd.MM.yyyy") {
             dateFormat = "dd.mm.yy"
         }
         else {
             dateFormat = "dd/mm/yy"
         }
         $('#<%=errId.ClientID%>').hide();
         document.getElementById('<%=ddlExTrID.ClientID%>').disabled = true;
         document.getElementById('<%=lstDep.ClientID%>').disabled = false;
         document.getElementById('<%=ddlSubsidiary.ClientID%>').disabled = false;
         $('#<%=TxtDateFrom.ClientID%>').removeAttr("disabled");
         $('#<%=TxtDateTo.ClientID%>').removeAttr("disabled");
         $('#<%=rdbCustInfo.ClientID%>').removeAttr("disabled");
         $('#<%=rdbInvJrn.ClientID%>').removeAttr("disabled");
         $('#<%=rdbRecreate.ClientID%>').attr('disabled', 'disabled');
         $('#<%=rdbRegenerate.ClientID%>').attr('disabled', 'disabled');
         $('#<%=ddlExTrID.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");

         $('#<%=rdbExpTranId.ClientID%>').change(function (e) {
             LoadTransactionIds();
             document.getElementById('<%=ddlExTrID.ClientID%>').disabled = false;
             document.getElementById('<%=lstDep.ClientID%>').disabled = true;
             document.getElementById('<%=ddlSubsidiary.ClientID%>').disabled = true;
             document.getElementById('<%=TxtDateFrom.ClientID%>').disabled = true;
             document.getElementById('<%=TxtDateTo.ClientID%>').disabled = true;
             $("#<%=rdbCustInfo.ClientID%>").attr('disabled', 'disabled');
             $("#<%=rdbInvJrn.ClientID%>").attr('disabled', 'disabled');
             $('#<%=rdbRecreate.ClientID%>').removeAttr("disabled");
             $('#<%=rdbRegenerate.ClientID%>').removeAttr("disabled");
             $('#<%=rdbInvJrn.ClientID%>').attr("checked", true);
             $('#<%=rdbExpTranId.ClientID%>').attr("checked", true);
         });
         
        
         LoadSubidiary();
         $('#<%=ddlSubsidiary.ClientID%>').change(function (e) {
             var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
             LoadDept(subId);
         });

         $('#<%=rdbSelExport.ClientID%>').change(function (e) {
             document.getElementById('<%=ddlExTrID.ClientID%>').disabled = true;
             document.getElementById('<%=lstDep.ClientID%>').disabled = false;
             document.getElementById('<%=ddlSubsidiary.ClientID%>').disabled = false;
             document.getElementById('<%=TxtDateFrom.ClientID%>').disabled = false;
             document.getElementById('<%=TxtDateTo.ClientID%>').disabled = false;
             $('#<%=rdbCustInfo.ClientID%>').removeAttr("disabled");
             $('#<%=rdbInvJrn.ClientID%>').removeAttr("disabled");
             $('#<%=rdbInvJrn.ClientID%>').attr("checked", true);
             $('#<%=rdbRecreate.ClientID%>').attr('disabled', 'disabled');
             $('#<%=rdbRegenerate.ClientID%>').attr('disabled', 'disabled');
            
         });
         $('#<%=rdbCustInfo.ClientID%>').change(function (e) {
             if ($('#<%=rdbSelExport.ClientID%>').is(':checked')){
                 document.getElementById('<%=lstDep.ClientID%>').disabled = true;
                 document.getElementById('<%=ddlSubsidiary.ClientID%>').disabled = true;
                 document.getElementById('<%=TxtDateFrom.ClientID%>').disabled = true;
                 document.getElementById('<%=TxtDateTo.ClientID%>').disabled = true;
                 $('#<%=rdbRecreate.ClientID%>').attr('disabled', 'disabled');
                 $('#<%=rdbRegenerate.ClientID%>').attr('disabled', 'disabled');
             }
         });

         $('#<%=rdbInvJrn.ClientID%>').change(function (e) {
             if ($('#<%=rdbSelExport.ClientID%>').is(':checked')){
                 document.getElementById('<%=ddlExTrID.ClientID%>').disabled = true;
                 document.getElementById('<%=lstDep.ClientID%>').disabled = false;
                 document.getElementById('<%=ddlSubsidiary.ClientID%>').disabled = false;
                 document.getElementById('<%=TxtDateFrom.ClientID%>').disabled = false;
                 document.getElementById('<%=TxtDateTo.ClientID%>').disabled = false;
                 $('#<%=rdbCustInfo.ClientID%>').attr('disabled', 'disabled');
                 $('#<%=rdbInvJrn.ClientID%>').removeAttr("disabled");
                 $('#<%=rdbRecreate.ClientID%>').attr('disabled', 'disabled');
                 $('#<%=rdbRegenerate.ClientID%>').attr('disabled', 'disabled');
             }
         });

         $.datepicker.setDefaults($.datepicker.regional["no"]);
         $('#<%=TxtDateFrom.ClientID%>').datepicker({
             showButtonPanel: true,
             changeMonth: true,
             changeYear: true,
             yearRange: "-50:+1",
             dateFormat: dateFormat,
             onSelect: function () {
                 $('#<%=TxtDateTo.ClientID%>').val($('#<%=TxtDateFrom.ClientID%>').val())
             }
         });

         $.datepicker.setDefaults($.datepicker.regional["no"]);
         $('#<%=TxtDateTo.ClientID%>').datepicker({
             showButtonPanel: true,
             changeMonth: true,
             changeYear: true,
             yearRange: "-50:+1",
             dateFormat: dateFormat
         });

         $('#<%=btnExport.ClientID%>').click(function () {
             var bool = fnClientValidate();
             var strName = "Sm";
             var namesArray;

             var strSelExport = $("#<%=rdbSelExport.ClientID%>").is(':checked');
             var strExpTranId = $("#<%=rdbExpTranId.ClientID%>").is(':checked');
             var strInvJrn = $("#<%=rdbInvJrn.ClientID%>").is(':checked');
             var strCustInfo = $("#<%=rdbCustInfo.ClientID%>").is(':checked');
             var strIdSub = $("#<%=ddlSubsidiary.ClientID%>").val();
             var fromDate = $("#<%=TxtDateFrom.ClientID%>").val();
             var toDate = $("#<%=TxtDateTo.ClientID%>").val();
             var strTranId = $("#<%=ddlExTrID.ClientID%>").val();
             var strRecreate = $("#<%=rdbRecreate.ClientID%>").is(':checked');
             var strRegenerate = $("#<%=rdbRegenerate.ClientID%>").is(':checked');

             if ((strSelExport == true) && (strInvJrn == true))
             {
                 var names = document.getElementById("<%=lstDep.ClientID%>");
                 namesArray = new Array();
                 for (var i = 0; i < names.length; i++) {
                     namesArray.push(names[i].value);
                 }
             }
             else {
                 namesArray = "";
             }

             if (bool == true) {
                 $.ajax({
                     type: "POST",
                     url: "frmLAExport.aspx/Export",
                     data: "{strSelExport:'" + strSelExport + "',strExpTranId:'" + strExpTranId + "',strInvJrn:'" + strInvJrn + "',strCustInfo:'" + strCustInfo + "',strIdSub:'" + strIdSub + "',fromDate:'" + fromDate + "',dept:'" + namesArray +
                             "', toDate:'" + toDate + "', strTranId:'" + strTranId + "', strRecreate:'" + strRecreate + "', strRegenerate:'" + strRegenerate + "'}",
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     async: false,
                     success: function (data) {
                         var str = data.d;
                         if (str.indexOf("ERR") >= 0) {
                             var strSplit = str.split(",");
                             $('#<%=errId.ClientID%>').show();
                             $('#<%=errId.ClientID%>').text(strSplit[0]);
                             window.open("../Reports/frmShowReports.aspx?ReportHeader='TransactionReport'&Rpt=TransactionReport &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                             Export();

                         }
                         else if (data.d == "Customer Export") {
                             Export();
                         }
                         else {
                             if (data.d == "Success") {
                                 window.open("../Reports/frmShowReports.aspx?ReportHeader='TransactionReport'&Rpt=TransactionReport &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                                 Export();
                             }
                             else {
                                 $('#<%=RTlblError.ClientID%>').text(data.d);
                             }
                         }

                     },
                     failure: function () {
                         alert("Failed!");
                     }
                 });
             }

         });

         <%-- $('#<%=btnErrlog.ClientID%>').click(function () {
             ErrorLog();
         });--%>

         function fnClientValidate() {
             if (($('#<%=rdbSelExport.ClientID%>').is(':checked')) && ($('#<%=rdbInvJrn.ClientID%>').is(':checked'))) {
                 if ($('#<%=ddlSubsidiary.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('0122', '', ''), '');
                     alert(msg);
                     return false;
                 }
                 if (!(gfi_CheckEmpty($('#<%=TxtDateFrom.ClientID%>'), GetMultiMessage('0198', '', ''))))
                     return false;
                 if (!(gfi_CheckEmpty($('#<%=TxtDateTo.ClientID%>'), GetMultiMessage('0199', '', ''))))
                     return false;
             }
             return true;
         }

     });//end of ready
     function LoadTransactionIds() {
         $.ajax({
             type: "POST",
             url: "frmLAExport.aspx/FetchTranId",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (data) {
                 Result = data.d;
                 $('#<%=ddlExTrID.ClientID%>').empty();
                 $('#<%=ddlExTrID.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");

                 $.each(Result, function (key, value) {
                     $('#<%=ddlExTrID.ClientID%>').append($("<option></option>").val(value.Id_Tran).html(value.Transction_No));
                 });
             },
             failure: function () {
                 alert("Failed!");
             }
         });
     }

    
     function LoadSubidiary() {
         $.ajax({
             type: "POST",
             url: "frmLAExport.aspx/LoadSubsidiary",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (Result) {
                 Result = Result.d;
                 $('#<%=ddlSubsidiary.ClientID%>').empty();
                 $('#<%=ddlSubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>')[0].value + "</option>");
                 $.each(Result, function (key, value) {
                     $('#<%=ddlSubsidiary.ClientID%>').append($("<option></option>").val(value.Id_Sub).html(value.Sub_Name));
                 });
             },
             failure: function () {
                 alert("Failed!");
             }
         });
     }
     function LoadDept(subId) {
         $.ajax({
             type: "POST",
             url: "frmLAExport.aspx/FetchDept",
             data: "{'subId':'" + subId + "'}",
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (Result) {
                 Result = Result.d;
                 $('#<%=lstDep.ClientID%>').empty();
                 $.each(Result, function (key, value) {
                     $('#<%=lstDep.ClientID%>').append($("<option></option>").val(value.Id_DeptId).html(value.Id_DeptAcCode));
                 });
             },
             failure: function () {
                 alert("Failed!");
             }
         });
     }
     function Export() {
         window.open("Export.aspx");
         return true;
     }

     function ErrorLog(){
         window.open("frmPopupLog.aspx", 'info6', "resizable=no,scrollbars=1,status=yes,width=800px,height=800px,menubar=0,toolbar=0");
         return true;
     }
     function LoadErrInvoiceRpt()
     {
         $.ajax({
             type: "POST",
             url: "frmLAExport.aspx/LoadErrInvRpt",
             data: '{}',
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             async: false,
             success: function (Result) {
                 if (Result.d == "ERROR")
                 {
                     window.open("../Reports/frmShowReports.aspx?ReportHeader='ErrorInvoices'&Rpt=ErrorInvoices &scrid='1'", "info6", "resizable=yes,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");

                 }
               
             },
             failure: function () {
                 alert("Failed!");
             }
         });
     }
</script>
<div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Export"></asp:Label>
     <asp:HiddenField ID="hdnSelect" runat="server" />
     <asp:Label ID="RTlblError" runat="server" CssClass="lblErr"></asp:Label>
        <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
    <a href="#" id="errId" runat="server" title="ErrInv" onclick="LoadErrInvoiceRpt()">ErrorInvoices</a>
</div>
    <div class="ui form">
        <div class="eight fields">
        <div class="field" style="padding:0.55em;height:40px;">
                <div class="ui radio checkbox" style="width:300px">
                 <asp:RadioButton ID="rdbSelExport" GroupName="rdLstSelect" runat="server"  Checked="true"   />
                 <label style="padding-right:50px">
                  <asp:Literal ID="lblSelExport" runat="server" Text="Selective Export"></asp:Literal></label>
                </div>
         </div>
            <div class="field" style="padding:0.55em;height:40px">
                <div class="ui radio checkbox">
                 <asp:RadioButton ID="rdbExpTranId" GroupName="rdLstSelect" runat="server" />
                 <label  style="width:550px;">
                  <asp:Literal ID="lblExpTranId" runat="server" Text="Export By Transaction ID"  ></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding-left:5.55em;height:40px;padding-top:0.55em;padding-bottom:0.55em;">
            <asp:DropDownList ID="ddlExTrID" runat="server" CssClass="dropdowns" Width="200px"></asp:DropDownList> 
        </div>
    </div>
     </div>
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #cce2ff">
   <a class="active item" runat="server" id="aType" style="background-color: transparent">Export Type</a>
 </div>
    <div class="ui form">
         <div class="eight fields">
        <div class="field" style="padding:0.55em;height:40px;display:inline">
                <div class="ui radio checkbox" style="width:300px">
                 <asp:RadioButton ID="rdbInvJrn" GroupName="rdLstExportType" runat="server" Checked="true"  />
                 <label>
                  <asp:Literal ID="lblInvJrn" runat="server" Text="Invoice Journal"></asp:Literal></label>
                </div>
            </div>
            <div class="field" style="padding:0.55em;height:40px">
                <div class="ui radio checkbox" style="width:300px">
                 <asp:RadioButton ID="rdbCustInfo" GroupName="rdLstExportType" runat="server"   />
                 <label>
                  <asp:Literal ID="lblCustInfo" runat="server" Text="Customer Information"></asp:Literal></label>
                </div>
        </div>
    </div>
         <div style="padding:0.5em"></div>
      <div class="eight fields">
        <div class="field" style="padding:0.55em;">
              <asp:Label ID="lblSub" runat="server" Text="Subsidiary" Width="180px"></asp:Label>
        </div>
            <div class="field" style="padding:0.55em">
               <asp:DropDownList ID="ddlSubsidiary" runat="server" CssClass="dropdowns" Width="200px" ></asp:DropDownList> 
        </div>
        </div>
           <div class="eight fields">
          <div class="field" style="padding:0.55em;">
              <asp:Label ID="lblDepartment" runat="server" Text="Department" Width="180px"></asp:Label>
              </div>
            <div class="field" style="padding:0.55em;">
            <asp:ListBox ID="lstDep" runat="server" SelectionMode="Multiple" Height="110px" Width="187px"></asp:ListBox>       
          </div>
        </div>
     
    </div>
      <div style="padding:0.5em"></div>
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #cce2ff">
   <a class="active item" runat="server" id="a1" style="background-color: transparent">Select Date Range</a>
 </div>
    <div class="ui form">
        <div class="eight fields">
            <div class="field" style="padding:0.55em;">
                 <asp:Label ID="lblStart" runat="server" Text="Start" Width="50px" ></asp:Label>
                </div>
            <div class="field" style="padding:0.55em;">
                <asp:TextBox ID="TxtDateFrom" runat="server" Width="160px" CssClass="inp" ></asp:TextBox>
            </div>
            <div class="field" style="padding:0.55em;">
                 <asp:Label ID="lblEnd" runat="server" Text="End" Width="100px" Style="padding-left:70px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;">
                <asp:TextBox ID="TxtDateTo" runat="server" Width="160px" CssClass="inp"></asp:TextBox>
            </div>
        </div>
    </div>
      <div class="ui secondary vertical menu" style="width: 100%; background-color: #cce2ff">
   <a class="active item" runat="server" id="a2" style="background-color: transparent">File Creation Option</a>
 </div>
    <div class="ui raised segment signup inactive">
         <div class="eight fields">
        <div class="field" style="padding:0.55em;height:40px;display:inline">
                <div class="ui radio checkbox" style="width:100px">
                 <asp:RadioButton ID="rdbRecreate" GroupName="rdLstFileCreation" runat="server"   />
                 <label>
                  <asp:Literal ID="lblRecreate" runat="server" Text="Recreate"></asp:Literal></label>
                </div>
                <div class="ui radio checkbox" style="width:100px">
                 <asp:RadioButton ID="rdbRegenerate" GroupName="rdLstFileCreation" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblRegenerate" runat="server" Text="Regenerate"></asp:Literal></label>
                </div>
        </div>
    </div>
</div>
     <div class="ui raised segment signup inactive">
         <input id="btnExport" runat="server" class="ui button"  value="Export" type="button" style="background-color: #E0E0E0" />
     </div>
</asp:Content>