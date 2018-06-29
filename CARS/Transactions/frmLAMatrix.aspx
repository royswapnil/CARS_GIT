<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmLAMatrix.aspx.vb" Inherits="CARS.frmLAMatrix" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
     <script type="text/javascript">
         $(document).ready(function () {
             //var mode;
             var id_SellCost_GL_Id;
             var id_Cost_GL_Id;
             var id_Stock_GL_Id;
             var id_Discount_GL_Id;
             var id_Selling_GL_Id;
             // var laMatrixId;

             var getUrlParameter = function getUrlParameter(sParam) {
                 var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                     sURLVariables = sPageURL.split('&'),
                     sParameterName,
                     i;

                 for (i = 0; i < sURLVariables.length; i++) {
                     sParameterName = sURLVariables[i].split('=');

                     if (sParameterName[0] === sParam) {
                         return sParameterName[1] === undefined ? true : sParameterName[1];
                     }
                 }
             };

             //Check the page name from where it is called before hiding the banners
             pageNameFrom = getUrlParameter('pageName');

             if (pageNameFrom == "LACodeList" && pageNameFrom != undefined) {
                 $('#topBanner').hide();
                 $('#topNav').hide();
                 $('#carsSideBar').hide();
             }
            
             laMatrixId = getUrlParameter('laMatrixId');
             mode = getUrlParameter('mode');

             FillAccCode();
             //FillLAAccCodeTypes();
             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

             $('#<%=ddlType.ClientID%>').change(function (e) {
                 FillLAAccCodeTypes();
             });
             //mode="Edit"
             if (mode == "Edit") {

                 Load_LA_Matrix();
             }
             $('#<%=btnSave.ClientID%>').click(function () {
                 var bool = fnValidate();
                 if (bool == true) {
                     saveMatrix();
                 }
                 
             });

             $('#<%=chkGL.ClientID%>').change(function () {
                 if ($(this).is(":checked")) {

                     $('#<%=txtSellingGLAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtSellingGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtSellingGLDim.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbSellCredit.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbSellDebit.ClientID%>').attr("disabled", "disabled");

                     $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbDiscCredit.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");

                     $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");

                     $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");  

                     $('#<%=txtSellCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtSellCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                     $('#<%=txtSellCostGLDim.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbSellCostCredit.ClientID%>').attr("disabled", "disabled");
                     $('#<%=rdbSellCostDebit.ClientID%>').attr("disabled", "disabled"); 

                     $('#<%=ddlType.ClientID%>').attr("disabled", "disabled");
                     $('#<%=ddlAccountCode.ClientID%>').attr("disabled", "disabled");
                     

                 }
                 else {
                     $('#<%=txtSellingGLAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtSellingGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtSellingGLDim.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbSellCredit.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbSellDebit.ClientID%>').removeAttr("disabled");

                     $('#<%=txtDiscountGLAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtDiscountGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtDiscountGLDim.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbDiscCredit.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbDiscDebit.ClientID%>').removeAttr("disabled");

                     $('#<%=txtCostGLAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtCostGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtCostGLDim.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbCostCredit.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbCostDebit.ClientID%>').removeAttr("disabled");

                     $('#<%=txtStockGLAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtStockGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtStockGLDim.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbStockCredit.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbStockDebit.ClientID%>').removeAttr("disabled");

                     $('#<%=txtSellCostGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtSellCostGLDeptAccNo.ClientID%>').removeAttr("disabled");
                     $('#<%=txtSellCostGLDim.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbSellCostCredit.ClientID%>').removeAttr("disabled");
                     $('#<%=rdbSellCostDebit.ClientID%>').removeAttr("disabled");

                     $('#<%=ddlType.ClientID%>').removeAttr("disabled");
                     $('#<%=ddlAccountCode.ClientID%>').removeAttr("disabled");
                 }

             });

             function fnValidate() {
                 if (!(gfi_ValidateNumber($('#<%=txtSellingGLAccNo.ClientID%>'), '0278'))) {
                     document.forms[0].txtSellingGLAccNo.value = "";
                     return false;
                 }
                 if ($('#<%=ddlDeptAccCode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('0533', '', ''), '');
                     alert(msg);
                     document.forms[0].ddlDeptAccCode.focus();
                     return false;
                 }
                 if ($('#<%=ddlCustGrpAccCode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('0534', '', ''), '');
                     alert(msg);
                     document.forms[0].ddlCustGrpAccCode.focus();
                     return false;
                 }
                 if ($('#<%=ddlVatCode.ClientID%>')[0].selectedIndex == "0") {
                     var msg = GetMultiMessage('0007', GetMultiMessage('05341', '', ''), '');
                     alert(msg);
                     document.forms[0].ddlVatCode.focus();
                     return false;
                 }
                 if (!(gfi_ValidateNumber($('#<%=txtProject.ClientID%>'), $('#ctl00_cntMainPanel_lblProject')[0].innerHTML))) {
                     return false;
                 }

                 return true;
             }
            
         });//end of ready

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
                         $('#<%=ddlDeptAccCode.ClientID%>').empty();
                         $('#<%=ddlDeptAccCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                         var Result = data.d[0];
                         $.each(Result, function (key, value) {
                             $('#<%=ddlDeptAccCode.ClientID%>').append($("<option></option>").val(value.Id_DeptId).html(value.Id_DeptAcCode));
                         });
                     }
                     if (data.d[1].length > 0) {
                         $('#<%=ddlCustGrpAccCode.ClientID%>').empty();
                         $('#<%=ddlCustGrpAccCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                         var Result = data.d[1];
                         $.each(Result, function (key, value) {
                             $('#<%=ddlCustGrpAccCode.ClientID%>').append($("<option></option>").val(value.Id_CUSTOMER).html(value.Id_CustGrpAcCode));
                         });
                     }
                     if (data.d[2].length > 0) {
                         $('#<%=ddlVatCode.ClientID%>').empty();
                         $('#<%=ddlVatCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                         var Result = data.d[2];
                         $.each(Result, function (key, value) {
                             $('#<%=ddlVatCode.ClientID%>').append($("<option></option>").val(value.Id_VatCode).html(value.Id_VatCode));
                         });
                     }
                    
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }

         function FillLAAccCodeTypes() {
             $.ajax({
                 type: "POST",
                 url: "frmLAMatrix.aspx/LoadAccCodeType",
                 data: '{}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     if($('#<%=ddlType.ClientID%>').val() == "LA")
                     {
                         if (data.d[0].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[0];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");

                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "SP") {
                         if (data.d[1].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[1];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "GM") {
                         if (data.d[2].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[2];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "VAT") {
                         if (data.d[3].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[3];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "RD") {
                         if (data.d[4].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[4];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "OR") {
                         if (data.d[5].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[5];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "VA") {
                         if (data.d[6].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[6];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "FP") {
                         if (data.d[7].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[7];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                     }
                     if ($('#<%=ddlType.ClientID%>').val() == "IF") {
                         if (data.d[8].length > 0) {
                             $('#<%=ddlAccountCode.ClientID%>').empty();
                             $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                             var Result = data.d[8];
                             $.each(Result, function (key, value) {
                                 $('#<%=ddlAccountCode.ClientID%>').append($("<option></option>").val(value.Id_AccCodeType).html(value.Id_AccCodeType));
                             });
                         }
                         $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                         $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                         $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                     }
                    
                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }
         function saveMatrix() {
             var saleCodeType = "";
             var vatCode = "";
             var deptId = ""; var deptAccCode = ""; var custGrpId = ""; var custGrpAccCode = ""; var projectId = "";
             var selling_GL_Desc = ""; var selling_GL_Crdb = ""; var selling_GL_AccNo = ""; var selling_GL_DepAccNo = ""; var selling_GL_Dimension = "";
             var discount_GL_Desc = ""; var discount_GL_Crdb = ""; var discount_GL_AccNo = ""; var discount_GL_DepAccNo = ""; var discount_GL_Dimension = "";
             var stock_GL_Desc = ""; var stock_GL_Crdb = ""; var stock_GL_AccNo = ""; var stock_GL_DepAccNo = ""; var stock_GL_Dimension = "";
             var cost_GL_Desc = ""; var cost_GL_Crdb = ""; var cost_GL_AccNo = ""; var cost_GL_DepAccNo = ""; var cost_GL_Dimension = "";
             var sellCost_GL_Desc = ""; var sellCost_GL_Crdb = ""; var sellCost_GL_AccNo = ""; var sellCost_GL_DepAccNo = ""; var sellCost_GL_Dimension = "";
             var cust_AccNo_CrDb = "";
             var genLedger = ""; var desc = ""; var selling_GL_DeptAccNo = ""; var saleCode_desc = "";
            

             if (mode != "Edit")
             {
                 id_SellCost_GL_Id = "0";
                 id_Cost_GL_Id = "0";
                 id_Stock_GL_Id = "0";
                 id_Discount_GL_Id = "0";
                 id_Selling_GL_Id = "0"
                 laMatrixId = "";

             }


             deptId = $('#<%=ddlDeptAccCode.ClientID%>').val();
             deptAccCode = $('#<%=ddlDeptAccCode.ClientID%> :selected')[0].innerText;
             custGrpId = $('#<%=ddlCustGrpAccCode.ClientID%>').val();
             custGrpAccCode = $('#<%=ddlCustGrpAccCode.ClientID%> :selected')[0].innerText;
             vatCode = $('#<%=ddlVatCode.ClientID%> :selected')[0].innerText;
             projectId = $('#<%=txtProject.ClientID%>').val();
             if ($('#<%=rdbSellCredit.ClientID%>').is(':checked')) {
                 selling_GL_Crdb = "1";
             }
             else {
                 selling_GL_Crdb = "0";
             }
             selling_GL_AccNo = $('#<%=txtSellingGLAccNo.ClientID%>').val();
             selling_GL_DepAccNo = $('#<%=txtSellingGLDeptAccNo.ClientID%>').val();
             selling_GL_Dimension = $('#<%=txtSellingGLDim.ClientID%>').val();
             selling_GL_Desc = "";


             if ($('#<%=rdbDiscCredit.ClientID%>').is(':checked')) {
                 discount_GL_Crdb = "1";
             }
             else {
                 discount_GL_Crdb = "0";
             }
             discount_GL_AccNo = $('#<%=txtDiscountGLAccNo.ClientID%>').val();
             discount_GL_DepAccNo = $('#<%=txtDiscountGLDeptAccNo.ClientID%>').val();
             discount_GL_Dimension = $('#<%=txtDiscountGLDim.ClientID%>').val();
             discount_GL_Desc = "";

             if ($('#<%=rdbStockCredit.ClientID%>').is(':checked')) {
                 stock_GL_Crdb = "1";
             }
             else {
                 stock_GL_Crdb = "0";
             }
             stock_GL_AccNo = $('#<%=txtStockGLAccNo.ClientID%>').val();
             stock_GL_DepAccNo = $('#<%=txtStockGLDeptAccNo.ClientID%>').val();
             stock_GL_Dimension = $('#<%=txtStockGLDim.ClientID%>').val();
             stock_GL_Desc = "";

             if ($('#<%=rdbCostCredit.ClientID%>').is(':checked')) {
                 cost_GL_Crdb = "1";
             }
             else {
                 cost_GL_Crdb = "0";
             }
             cost_GL_AccNo = $('#<%=txtCostGLAccNo.ClientID%>').val();
             cost_GL_DepAccNo = $('#<%=txtCostGLDeptAccNo.ClientID%>').val();
             cost_GL_Dimension = $('#<%=txtCostGLDim.ClientID%>').val();
             cost_GL_Desc = "";

             if ($('#<%=rdbSellCostCredit.ClientID%>').is(':checked')) {
                 sellCost_GL_Crdb = "1";
             }
             else {
                 sellCost_GL_Crdb = "0";
             }
             sellCost_GL_AccNo = $('#<%=txtSellCostGLAccNo.ClientID%>').val();
             sellCost_GL_DepAccNo = $('#<%=txtSellCostGLDeptAccNo.ClientID%>').val();
             sellCost_GL_Dimension = $('#<%=txtSellCostGLDim.ClientID%>').val();
             sellCost_GL_Desc = "";


             if ($('#<%=rdbCustAccCredit.ClientID%>').is(':checked')) {
                 genLedger = "1";
             }
             else {
                 genLedger = "0";
             }
             cust_AccNo_CrDb = $("#<%=chkGL.ClientID%>").is(':checked');
             desc = $('#<%=txtDescription.ClientID%>').val();


             if ($('#<%=chkGL.ClientID%>').is(':checked')) {
                 saleCode_desc = "";
                 selling_GL_DepAccNo = $('#<%=txtGLDeptAccntNum.ClientID%>').val();
             }
             else {
                 if ($('#<%=ddlType.ClientID%>').val() == "LA") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "LA";
                    

                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "SP") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "SP";
                   
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "GM") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "GM";
                   
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "VAT") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "VAT";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "RD") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "RD";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "OR") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "OR";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "VA") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "FP") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "FP";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "IF") {
                     saleCodeType = $('#ctl00_cntMainPanel_ddlAccountCode :selected')[0].innerText;
                     saleCode_desc = "IF";
                 }
                 selling_GL_Desc = "SEGL";
                 discount_GL_Desc = "DGL";
                 stock_GL_Desc = "STGL";
                 cost_GL_Desc = "CGL";
                 sellCost_GL_Desc = "SCGL";
                 
                 if ($('#<%=ddlType.ClientID%>').val() == "LA") {
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "GM") {
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "VAT") {
                     discount_GL_Desc = "";
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "RD") {
                     discount_GL_Desc = "";
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "OR") {
                     discount_GL_Desc = "";
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "VA") {
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "FP") {
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }
                 if ($('#<%=ddlType.ClientID%>').val() == "IF") {
                     stock_GL_Desc = "";
                     cost_GL_Desc = "";
                 }




             }

             $.ajax({
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 url: "frmLAMatrix.aspx/SaveMatrix",
                 data: "{saleCodeType:'" + saleCodeType + 
                     "', deptId:'" + deptId +"', vatCode:'" + vatCode +
                     "', deptAccCode:'" + deptAccCode + "', custGrpId:'" + custGrpId + "', custGrpAccCode:'" + custGrpAccCode + "', projectId:'" + projectId + "', selling_GL_Crdb:'" + selling_GL_Crdb + "', selling_GL_AccNo:'" + selling_GL_AccNo +
                     "', selling_GL_DepAccNo:'" + selling_GL_DepAccNo + "', selling_GL_Dimension:'" + selling_GL_Dimension + "', discount_GL_Crdb:'" + discount_GL_Crdb + "', discount_GL_AccNo:'" + discount_GL_AccNo + "', discount_GL_DepAccNo:'" + discount_GL_DepAccNo + "', discount_GL_Dimension:'" + discount_GL_Dimension +
                     "', stock_GL_Crdb:'" + stock_GL_Crdb + "', stock_GL_AccNo:'" + stock_GL_AccNo + "', stock_GL_DepAccNo:'" + stock_GL_DepAccNo + "', stock_GL_Dimension:'" + stock_GL_Dimension + "', cost_GL_Crdb:'" + cost_GL_Crdb + "', cost_GL_AccNo:'" + cost_GL_AccNo +
                     "', cost_GL_DepAccNo:'" + cost_GL_DepAccNo + "', cost_GL_Dimension:'" + cost_GL_Dimension + "', sellCost_GL_Crdb:'" + sellCost_GL_Crdb + "', sellCost_GL_AccNo:'" + sellCost_GL_AccNo + "', sellCost_GL_DepAccNo:'" + sellCost_GL_DepAccNo + "', sellCost_GL_Dimension:'" + sellCost_GL_Dimension +
                     "', cust_AccNo_CrDb:'" + cust_AccNo_CrDb + "', genLedger:'" + genLedger + "', desc:'" + desc + "', saleCode_desc:'" + saleCode_desc + "', selling_GL_Desc:'" + selling_GL_Desc + "', discount_GL_Desc:'" + discount_GL_Desc + "', stock_GL_Desc:'" + stock_GL_Desc + "', cost_GL_Desc:'" + cost_GL_Desc + "', sellCost_GL_Desc:'" + sellCost_GL_Desc +
                     "', laMatrixId:'" + laMatrixId + "', id_SellCost_GL_Id:'" + id_SellCost_GL_Id + "', id_Cost_GL_Id:'" + id_Cost_GL_Id + "', id_Stock_GL_Id:'" + id_Stock_GL_Id + "', id_Discount_GL_Id:'" + id_Discount_GL_Id + "', id_Selling_GL_Id:'" + id_Selling_GL_Id + "'}",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     //data = data.d[0];
                     if (data.d.length > 0) {
                         if (data.d[0] == "0")
                         {
                             $('#<%=RTlblError.ClientID%>').text('Saved/Updated Successfully.');
                             $('#<%=RTlblError.ClientID%>').removeClass();
                             $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                         }
                         if (data.d[0] == "AEXISTS") {
                             $('#<%=RTlblError.ClientID%>').text('Already Exists.');
                         }

                         if (window.parent != undefined && window.parent != null && window.parent.length > 0) {
                             window.parent.document.getElementById('ctl00_cntMainPanel_RTlblError').innerText = 'Saved/Updated Successfully.';
                             window.parent.document.getElementById('ctl00_cntMainPanel_RTlblError').className = "lblMessage";
                             window.parent.loadLACodeList();
                             window.parent.$('.ui-dialog-content:visible').dialog('close');
                         }
                     }                    

                 },
                 error: function (result) {
                     alert("Error");
                 }
             });

             
         }

         function Load_LA_Matrix() {
             var laSLNO = laMatrixId;
             $.ajax({
                 type: "POST",
                 url: "frmLAMatrix.aspx/Load_LA_Matrix",
                 data: "{laSLNO:'" + laSLNO + "'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     if (data.d.length > 0) {
                         if (data.d[0].length > 0) {
                             $('#<%=ddlDeptAccCode.ClientID%>').val(data.d[0][0].Id_DeptId);
                             $('#<%=ddlCustGrpAccCode.ClientID%> option:contains("' + data.d[0][0].Id_CustGrpAcCode + '")').attr('selected', 'selected');
                             $('#<%=ddlVatCode.ClientID%> option:contains("' + data.d[0][0].Id_VatCode + '")').attr('selected', 'selected');
                             $('#<%=ddlType.ClientID%>').val(data.d[0][0].Id_SaleCode_Type);
                             //$('#<%=ddlAccountCode.ClientID%> option:contains("' + data.d[0][0].Id_SaleCode_Desc + '")').attr('selected', 'selected');
                             $('#<%=ddlAccountCode.ClientID%> ').children('option[value="0"]').text(data.d[0][0].Id_SaleCode_Desc);

                             $('#<%=txtProject.ClientID%>').val(data.d[0][0].Id_Project);
                             $('#<%=ddlDeptAccCode.ClientID%>').attr("disabled", "disabled");
                             $('#<%=ddlCustGrpAccCode.ClientID%>').attr("disabled", "disabled");
                             $('#<%=ddlVatCode.ClientID%>').attr("disabled", "disabled");
                             $('#<%=ddlType.ClientID%>').attr("disabled", "disabled");
                             $('#<%=ddlAccountCode.ClientID%>').attr("disabled", "disabled");

                            

                             if (data.d[0][0].Id_SaleCode_Type == "LA") {
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "GM") {
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "VAT") {
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);

                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "OR") {
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "RD") {
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "VA") {
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);

                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "FP") {
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                             }
                             if (data.d[0][0].Id_SaleCode_Type == "IF") {
                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                             }

                             if (data.d[0][0].Id_GenLedger == true) {
                                 $('#<%=txtStockGLAccNo.ClientID%>').val('');
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtStockGLDim.ClientID%>').val('');
                                 $('#<%=txtCostGLAccNo.ClientID%>').val('');
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtCostGLDim.ClientID%>').val('');
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').val('');
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtDiscountGLDim.ClientID%>').val('');
                                 $('#<%=txtSellingGLAccNo.ClientID%>').val('');
                                 $('#<%=txtSellingGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtSellingGLDim.ClientID%>').val('');
                                 $('#<%=txtSellCostGLAccNo.ClientID%>').val('');
                                 $('#<%=txtSellCostGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtSellCostGLDim.ClientID%>').val('');
                                 $('#<%=txtGLDeptAccntNum.ClientID%>').val('');
                                 $('#<%=txtStockGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtStockGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtCostGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtDiscountGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellingGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellingGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellingGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellCostGLAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellCostGLDeptAccNo.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=txtSellCostGLDim.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=ddlAccountCode.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=ddlType.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=ddlAccountCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                                 $('#<%=ddlType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                                 $('#<%=rdbStockCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbStockDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbSellCostCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbSellCostDebit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbSellCredit.ClientID%>').attr("checked", false);
                                 $('#<%=rdbSellDebit.ClientID%>').attr("checked", false);


                                 $('#<%=rdbStockCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbStockDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbDiscCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbDiscDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbSellCostCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbSellCostDebit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbSellCredit.ClientID%>').attr("disabled", "disabled");
                                 $('#<%=rdbSellDebit.ClientID%>').attr("disabled", "disabled");
                                


                                 if (data.d[1][0].Id_Cust_AccNo_CrDb == true) {
                                     $('#<%=rdbCustAccCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbCustAccDebit.ClientID%>').attr('checked', false);
                                     $('#<%=chkGL.ClientID%>').attr('checked', true);
                                     $('#<%=chkGL.ClientID%>').attr("disabled", "disabled");

                                 }
                                 else {
                                     $('#<%=rdbCustAccDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbCustAccCredit.ClientID%>').attr('checked', false);
                                     $('#<%=chkGL.ClientID%>').attr('checked', true);
                                     $('#<%=chkGL.ClientID%>').attr("disabled", "disabled");
                                 }
                                 $('#<%=txtGLDeptAccntNum.ClientID%>').val(data.d[1][0].Gl_DeptAccno);
                             }
                             else {
                                 $('#<%=chkGL.ClientID%>').attr('checked', false);
                                 $('#<%=txtStockGLAccNo.ClientID%>').val('');
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtStockGLDim.ClientID%>').val('');
                                 $('#<%=txtCostGLAccNo.ClientID%>').val('');
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtCostGLDim.ClientID%>').val('');
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').val('');
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtDiscountGLDim.ClientID%>').val('');
                                 $('#<%=txtSellingGLAccNo.ClientID%>').val('');
                                 $('#<%=txtSellingGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtSellingGLDim.ClientID%>').val('');
                                 $('#<%=txtSellCostGLAccNo.ClientID%>').val('');
                                 $('#<%=txtSellCostGLDeptAccNo.ClientID%>').val('');
                                 $('#<%=txtSellCostGLDim.ClientID%>').val('');
                                 $('#<%=txtGLDeptAccntNum.ClientID%>').val('');
                             }
                             $('#<%=txtDescription.ClientID%>').val(data.d[0][0].Id_Description);
                         }

                         
                         

                         for (var i = 0; i < data.d[1].length; i++) {
                             if (data.d[1][i].Id_Selling_GL_Desc == "SEGL") {
                                 $('#<%=txtSellingGLAccNo.ClientID%>').val(data.d[1][i].Id_Selling_GL_AccNo);
                                 $('#<%=txtSellingGLDeptAccNo.ClientID%>').val(data.d[1][i].Id_Selling_GL_DeptAccNo);
                                 $('#<%=txtSellingGLDim.ClientID%>').val(data.d[1][i].Id_Selling_GL_Dimension);
                                 if (data.d[1][0].Id_Selling_GL_CrDb == "1") {
                                     $('#<%=rdbSellCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbSellDebit.ClientID%>').attr('checked', false);
                                 }
                                 else {
                                     $('#<%=rdbSellDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbSellCredit.ClientID%>').attr('checked', false);
                                 }
                                 id_SellCost_GL_Id = laSLNO;
                                 id_Cost_GL_Id = "0";
                                 id_Stock_GL_Id = "0";
                                 id_Discount_GL_Id = "0";
                                 id_Selling_GL_Id = "0"
       

                             }

                             if (data.d[1][i].Id_Discount_GL_Desc == "DGL") {
                                 $('#<%=txtDiscountGLAccNo.ClientID%>').val(data.d[1][i].Id_Discount_GL_AccNo);
                                 $('#<%=txtDiscountGLDeptAccNo.ClientID%>').val(data.d[1][i].Id_Discount_GL_DeptAccNo);
                                 $('#<%=txtDiscountGLDim.ClientID%>').val(data.d[1][i].Id_Discount_GL_Dimension);
                                 if (data.d[1][0].Id_Discount_GL_CrDb == "1") {
                                     $('#<%=rdbDiscCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbDiscDebit.ClientID%>').attr('checked', false);
                                 }
                                 else {
                                     $('#<%=rdbDiscDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbDiscCredit.ClientID%>').attr('checked', false);
                                 }
                                 id_SellCost_GL_Id = "0";
                                 id_Cost_GL_Id = "0";
                                 id_Stock_GL_Id = "0";
                                 id_Discount_GL_Id = laSLNO;
                                 id_Selling_GL_Id = "0"
                                

                             }
                             if (data.d[1][i].Id_Cost_GL_Desc == "CGL") {
                                 $('#<%=txtCostGLAccNo.ClientID%>').val(data.d[1][i].Id_Cost_GL_AccNo);
                                 $('#<%=txtCostGLDeptAccNo.ClientID%>').val(data.d[1][i].Id_Cost_GL_DeptAccNo);
                                 $('#<%=txtCostGLDim.ClientID%>').val(data.d[1][i].Id_Cost_GL_Dimension);
                                 if (data.d[1][0].Id_Cost_GL_CrDb == "1") {
                                     $('#<%=rdbCostCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbCostDebit.ClientID%>').attr('checked', false);
                                 }
                                 else {
                                     $('#<%=rdbCostDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbCostCredit.ClientID%>').attr('checked', false);
                                 }
                                 id_SellCost_GL_Id = "0";
                                 id_Cost_GL_Id = laSLNO;
                                 id_Stock_GL_Id = "0";
                                 id_Discount_GL_Id = "0"
                                 id_Selling_GL_Id = "0"
                                
                             }
                             if (data.d[1][i].Id_Stock_GL_Desc == "STGL") {
                                 $('#<%=txtStockGLAccNo.ClientID%>').val(data.d[1][i].Id_Stock_GL_AccNo);
                                 $('#<%=txtStockGLDeptAccNo.ClientID%>').val(data.d[1][i].Id_Stock_GL_DeptAccNo);
                                 $('#<%=txtStockGLDim.ClientID%>').val(data.d[1][i].Id_Stock_GL_Dimension);
                                 if (data.d[1][0].Id_Stock_GL_CrDb == "1") {
                                     $('#<%=rdbStockCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbStockDebit.ClientID%>').attr('checked', false);
                                 }
                                 else {
                                     $('#<%=rdbStockDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbStockCredit.ClientID%>').attr('checked', false);
                                 }
                                 id_SellCost_GL_Id = "0";
                                 id_Cost_GL_Id = "0"
                                 id_Stock_GL_Id = laSLNO;
                                 id_Discount_GL_Id = "0"
                                 id_Selling_GL_Id = "0"
           

                             }

                             if (data.d[1][i].Id_SellCost_GL_Desc == "SCGL") {
                                 $('#<%=txtSellCostGLAccNo.ClientID%>').val(data.d[1][i].Id_SellCost_GL_AccNo);
                                 $('#<%=txtSellCostGLDeptAccNo.ClientID%>').val(data.d[1][i].Id_SellCost_GL_DeptAccNo);
                                 $('#<%=txtSellCostGLDim.ClientID%>').val(data.d[1][i].Id_SellCost_GL_Dimension);
                                 if (data.d[1][0].Id_SellCost_GL_CrDb == "1") {
                                     $('#<%=rdbSellCostCredit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbSellCostDebit.ClientID%>').attr('checked', false);
                                 }
                                 else {
                                     $('#<%=rdbSellCostDebit.ClientID%>').attr('checked', true);
                                     $('#<%=rdbSellCostDebit.ClientID%>').attr('checked', false);
                                 }
                                 id_SellCost_GL_Id = laSLNO;
                                 id_Cost_GL_Id = "0"
                                 id_Stock_GL_Id = "0"
                                 id_Discount_GL_Id = "0"
                                 id_Selling_GL_Id = "0"
   

                             }
                         }

                     }

                 },
                 failure: function () {
                     alert("Failed!");
                 }
             });
         }

         
</script>
<div class="header1" style="padding-top:0.5em">
     <asp:Label ID="lblHeader" runat="server" Text="Add Account Code Matrix"></asp:Label>
     <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     <asp:HiddenField ID="hdnPageSize" runat="server" />
    <asp:HiddenField ID="hdnSelect" runat="server" />
</div>

 <div class="ui form">
     <div class="twelve fields">
              <div class="field" style="padding:0.55em;height:40px">
                <asp:Label ID="lblDeptAccCode" runat="server" Text="Department Account Code" Width="200px"></asp:Label>
                 </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList ID="ddlDeptAccCode" runat="server" CssClass="dropdowns" Width="120px" ></asp:DropDownList> 
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:Label ID="lblCustGrpAccCode" runat="server" Text="Customer Group Account Code" Width="200px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList ID="ddlCustGrpAccCode" runat="server" CssClass="dropdowns" Width="100px" ></asp:DropDownList> 
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                 <asp:Label ID="lblVATCode" runat="server" Text="VAT Code" Width="100px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:40px">
                <asp:DropDownList ID="ddlVatCode" runat="server" CssClass="dropdowns" Width="90px" ></asp:DropDownList>                     
             </div>
    </div>
</div>
<div class="ui secondary vertical menu" style="width: 100%; background-color: #cce2ff">
   <a class="active item" runat="server" id="aType" style="background-color: transparent">Type</a>
 </div>
<div class="ui form">

     <div class="six fields">
         <div class="field" style="padding:0.55em;height:10px">
            <select id="ddlType" runat="server" class="dropdowns" style="width:180px" >
                            <option value="-1">Velg..</option>
                            <option value="LA">Labour</option>
                            <option value="SP">Spares</option>
                            <option value="GM">Garage Material</option>
                            <option value="VAT">VAT</option>
                            <option value="RD">Rounding</option>
                            <option value="OR">Own Risk</option>
                            <option value="VA">VA Account Code</option>
                             <option value="FP">FP Account Code</option>
                            <option value="IF">IF Account Code</option>
         </select>
         </div>
            <div class="field" style="padding-top:0.55em;padding-left:10.55em;height:10px">
         <asp:DropDownList ID="ddlAccountCode" runat="server" CssClass="dropdowns" Width="200px"  Style="padding-left:70px"></asp:DropDownList> 
          </div> 
    </div>
     <div style="padding:0.5em"></div>
    <div class="six fields ">
        <div class="field" style="padding:0.55em;height:10px">
            <asp:Label ID="lblProject" runat="server" Text="Project" Width="150px"></asp:Label>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
          <asp:TextBox ID="txtProject" runat="server" Width="400px"></asp:TextBox>
        </div>  
    </div>
     <div style="padding:0.5em"></div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px">
          <asp:Label ID="lblChk" runat="server" Text="" Width="175px"></asp:Label>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
          <asp:Label ID="lblChks" runat="server" Text="" Width="175px"></asp:Label>
         </div>
        <div class="field" style="padding:0.55em;height:10px">
        <asp:Label ID="lblAccNo" runat="server" Text="Account No." Width="170px"></asp:Label>
         </div>
         <div class="field" style="padding:0.55em;height:10px">
        <asp:Label ID="lblDeptAccNo" runat="server" Text="Department Account No." Width="170px"></asp:Label>
        </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:Label ID="lblDimension" runat="server" Text="Dimension" Width="170px"></asp:Label>
     </div>
    </div>
     <div style="padding:0.5em"></div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblSellingGL" runat="server" Text="Selling GL" Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbSellCredit" GroupName="rbSellingGL" runat="server"   />
                 <label>
                  <asp:Literal ID="lblSellCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbSellDebit" GroupName="rbSellingGL" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblSellDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellingGLAccNo" runat="server" Width="170px"  ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellingGLDeptAccNo" runat="server" Width="170px" ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellingGLDim" runat="server" Width="170px"  ></asp:TextBox>
        </div>
    </div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblDiscountGL" runat="server" Text="Discount GL" Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbDiscCredit" GroupName="rbDiscountGL" runat="server"   />
                 <label>
                  <asp:Literal ID="lblDiscCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbDiscDebit" GroupName="rbDiscountGL" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblDiscDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtDiscountGLAccNo" runat="server" Width="170px"  ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtDiscountGLDeptAccNo" runat="server" Width="170px" ></asp:TextBox>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtDiscountGLDim" runat="server" Width="170px"  ></asp:TextBox>
        </div>
    </div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblStockGL" runat="server" Text="Stock GL" Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbStockCredit" GroupName="rbStockGL" runat="server"   />
                 <label>
                  <asp:Literal ID="lblStockCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbStockDebit" GroupName="rbStockGL" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblStockDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtStockGLAccNo" runat="server" Width="170px"  ></asp:TextBox>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtStockGLDeptAccNo" runat="server" Width="170px" ></asp:TextBox>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtStockGLDim" runat="server" Width="170px"  ></asp:TextBox>
        </div>
    </div>
     <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblCostGL" runat="server" Text="Cost GL" Width="150px"></asp:Label>
            </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbCostCredit" GroupName="rbCostGL" runat="server"   />
                 <label>
                  <asp:Literal ID="lblCostCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbCostDebit" GroupName="rbCostGL" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblCostDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtCostGLAccNo" runat="server" Width="170px"  ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtCostGLDeptAccNo" runat="server" Width="170px" ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtCostGLDim" runat="server" Width="170px"  ></asp:TextBox>
        </div>
    </div>
     <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblSellCostGL" runat="server" Text="Selling Cost GL" Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbSellCostCredit" GroupName="rbSellCostGL" runat="server"   />
                 <label>
                  <asp:Literal ID="lblSellCostCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
                 </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbSellCostDebit" GroupName="rbSellCostGL" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblSellCostDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellCostGLAccNo" runat="server" Width="170px"  ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellCostGLDeptAccNo" runat="server" Width="170px" ></asp:TextBox>
         </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtSellCostGLDim" runat="server" Width="170px"  ></asp:TextBox>
        </div>
    </div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:10px;display:inline">
            <asp:Label ID="lblCustAccountNo" runat="server" Text="Customer Account No." Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
                <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbCustAccCredit" GroupName="rbCustAccNo" runat="server"   />
                 <label>
                  <asp:Literal ID="lblCustAccCredit" runat="server" Text="Credit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
            <div class="ui radio checkbox" style="width:90px">
                 <asp:RadioButton ID="rdbCustAccDebit" GroupName="rbCustAccNo" runat="server"  Checked="true" />
                 <label>
                  <asp:Literal ID="lblCustAccDebit" runat="server" Text="Debit"></asp:Literal></label>
                </div>
             </div>
            <div class="field" style="padding:1em;height:10px">
                <asp:CheckBox ID="chkGL" runat="server" Text="GL" Width="50px" />
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:Label ID="Label1" runat="server" Text="" Width="92px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:10px">
        <asp:TextBox ID="txtGLDeptAccntNum" runat="server" Width="170px" ></asp:TextBox>
        </div>
    </div>
    <div class="twelve fields">
        <div class="field" style="padding:0.55em;height:40px;display:inline">
            <asp:Label ID="lblDescription" runat="server" Text="Description " Width="150px"></asp:Label>
             </div>
            <div class="field" style="padding:0.55em;height:40px">
             <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Height="49px" Width="612px"  MaxLength="16" ></asp:TextBox>
        </div>
    </div>
    <div id="divCfInvDetails" class="ui raised segment signup inactive" style="text-align:center">
         <input id="btnSave" runat="server" class="ui button"  value="Save" type="button" style="background-color: #E0E0E0" />
         <input id="btnReset" runat="server" class="ui button"  value="Reset" type="button" style="background-color: #E0E0E0" />
    </div>
</div>

</asp:Content>

