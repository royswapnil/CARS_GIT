<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWOHead.aspx.vb" Inherits="CARS.frmWOHead" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <%@ Register Src="../UserCtrl/ucWOMenutabs.ascx" TagName="ucWOMenutabs" TagPrefix="uc3" %>
       <script>
           $(document).ready(function () {
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

                FillType();
                FillStatus();
                FillPayType();
                FillPayTerms();
                FillCustGroup();
                FillMake();
                FillNewModel();
                $('#<%=lnkDefect.ClientID%>').hide();
               $('#<%=txtJobNo.ClientID%>').hide();
               
               //LoadAllModel();
          //  var WoNo = "56886";
               //  var WoPr = "V23";

               //WO Search Page
               var woNumber = getUrlParameter('Wonumber');
               var woPrefix = getUrlParameter('WOPrefix');
               var searchmode = getUrlParameter('Mode');
               var woSearchflag = getUrlParameter('Flag');
               var blWOsearch = getUrlParameter('blWOsearch');

               woNumber = decodeURIComponent(woNumber);
               woPrefix = decodeURIComponent(woPrefix);
               searchmode = decodeURIComponent(searchmode);
               woSearchflag = decodeURIComponent(woSearchflag);
               blWOsearch = decodeURIComponent(blWOsearch);


               if ('<%= Session("WONO")%>' != "" && (woNumber == "" || woNumber == "undefined")) {
           
                WoNo = '<%= Session("WONO")%>';
                WoPr = '<%= Session("WOPR")%>';
                $('#<%=RTlbl_OrderNo.ClientID%>').text(WoPr + WoNo);
                var Flag = getUrlParameter('Flag');
                Flag = decodeURIComponent(Flag);
                if (Flag != "") {
                    $(document.getElementById('<%=hdnWoNo.ClientID%>')).val(WoNo);
                    $(document.getElementById('<%=hdnWoPr.ClientID%>')).val(WoPr);
                    PopulateWODetails(WoNo, WoPr, Flag);
                    $('#<%=btnUpdate.ClientID%>').show();
                    $('#<%=btnSaveOrder.ClientID%>').hide();
                    $('#<%=lst_veh.ClientID%>').hide();  
                    $('#<%=txtSrchVeh.ClientID%>').show();
                    loadOrderJobsGrid();
                    $('#divJob').show();
                }
                else {
                    $('#<%=lst_veh.ClientID%>').hide();
                    $('#<%=btnUpdate.ClientID%>').hide();
                    $('#<%=btnDeleteJob.ClientID%>').removeAttr("disabled");
                    $('#<%=txtSrchVeh.ClientID%>').show();
                    //FillModel($('#<%=ddlMake.ClientID%>').val());
                    $('#divJob').hide();

                }
           }
           else {
               if (woSearchflag != "" && woSearchflag != "undefined" && woNumber !="undefined") {
                   $(document.getElementById('<%=hdnWoNo.ClientID%>')).val(woNumber);
                   $(document.getElementById('<%=hdnWoPr.ClientID%>')).val(woPrefix);
                   WoNo = woNumber;
                   WoPr = woPrefix;
                   PopulateWODetails(woNumber, woPrefix, woSearchflag);
                   $('#<%=btnUpdate.ClientID%>').show();
                   $('#<%=btnSaveOrder.ClientID%>').hide();
                   $('#<%=lst_veh.ClientID%>').hide();
                   $('#<%=txtSrchVeh.ClientID%>').show();
                   loadOrderJobsGrid();
                   $('#divJob').show();
               }
               else {

                   <%-- $('#<%=ddlVeh.ClientID%>').hide();--%>
                   $('#<%=lst_veh.ClientID%>').hide();
                   $('#<%=btnUpdate.ClientID%>').hide();
                   $('#<%=txtSrchVeh.ClientID%>').show();
                   $('#<%=btnDeleteJob.ClientID%>').removeAttr("disabled");
                   <%-- $('#<%=ddlModel.ClientID%>').empty();
                   $('#<%=ddlModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                   FillModel($('#<%=ddlMake.ClientID%>').val());--%>
                   $('#divJob').hide();
               }
           }       
                      
            var userId = '<%= Session("UserID")%>';

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtDeliveryDate.ClientID%>').datepicker({
                //showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
               // buttonImageOnly: true,
                // buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"

            });
          
            $('#<%=txtFinishDate.ClientID%>').datepicker({
                //showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                //buttonImageOnly: true,
                // buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"

            });
            $('#<%=txtDeliveryTime.ClientID%>').change(function (e) {
                fnValidateTime();
            });

            function fnValidateTime() {
                if ($('#<%=txtDeliveryTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtDeliveryTime.ClientID%>'));
                }
            }
            $('#<%=txtDeliveryDate.ClientID%>').keyup(function () {
                if ($(this).val().length == 2 || $(this).val().length == 5) {
                    $(this).val($(this).val() + $('#<%=hdnDateFormatLang.ClientID%>').val());
                }
            });
               $('#<%=CustMoreInfo.ClientID%>').click(function () {
                   
                    if($('#<%=txtSrchCust.ClientID%>').val().length > 0){
                        //LoadAllModel();
                        var custId = $('#<%=txtSrchCust.ClientID%>').val();
                        window.open("../Master/frmCustomerDetail.aspx?cust=" + custId, "info6", "resizable=no,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        //test1 = "../Master/frmVehicleDetail.aspx?vehid=" + vehId;
                            //document.write('<iframe height="450"  allowTransparency="true" frameborder="0" scrolling="yes" style="width:100%" ,target="_top"; src="' + test1 + '" type= "text/javascript"></iframe>');
                    }
                    else {
                        alert('No customer is selected. Please choose a customer first!');
                    }
                
                <%--var vid = $('#<%=txtSrchCust.ClientID%>').val();
               window.open("frmWOMoreCustInfo.aspx?vid=" + vid, 'info1', "resizable=no,scrollbars=1,status=yes,width=500px,height=400px,menubar=0,toolbar=0");--%>
            });
               $('#<%=VehMoreInfo.ClientID%>').click(function () {
                    if($('#<%=txtInternalNo.ClientID%>').val().length > 0){
                        var vehId = $('#<%=txtInternalNo.ClientID%>').val();
                        window.open("../Master/frmVehicleDetail.aspx?refno=" + vehId, "info6", "resizable=no,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        //test1 = "../Master/frmVehicleDetail.aspx?vehid=" + vehId;
                        //document.write('<iframe height="450"  allowTransparency="true" frameborder="0" scrolling="yes" style="width:100%" ,target="_top"; src="' + test1 + '" type= "text/javascript"></iframe>');
                    }
                    else {
                        alert('No vehicle is selected. Please choose a vehicle first!');
                    }
                <%--var vid = $('#<%=txtSrchVeh.ClientID%>').val();
                window.open("frmWOVehInfo.aspx?vid=" + vid, 'info2', "resizable=no,scrollbars=1,status=yes,width=500px,height=400px,menubar=0,toolbar=0");--%>
            });

            $('#<%=ddlMake.ClientID%>').change(function (e) {
                var makeId = $('#<%=ddlMake.ClientID%>').val();
                //FillModel(makeId);
            });

            $('#<%=ddlCusGroup.ClientID%>').change(function (e) {
                var custGrpId = $('#<%=ddlCusGroup.ClientID%>').val();
                FillPayDet(custGrpId);
            });
           
         
            
            $('#<%=lst_veh.ClientID%>').change(function (e) {
                <%--$('#<%=ddlVeh.ClientID%>').hide();--%>
                $('#<%=lst_veh.ClientID%>').hide();
                $('#<%=txtSrchVeh.ClientID%>').show();
                var vehId = $('#<%=lst_veh.ClientID%>')[0].value;
                $('#<%=txtSrchVeh.ClientID%>').val(vehId);
                FillVehDet(vehId);
                   
                
            });
            $('#<%=txtSrchVeh.ClientID%>').change(function (e) {
                var vehId = $('#<%=txtSrchVeh.ClientID%>').val();
                var retVal = validateVeh(vehId);
                if (retVal == "False")
                {
                    alert("Vehicle does not exist. Do you want to create a new vehicle?");
                    //LoadAllModel();
                    window.open("../Master/frmVehicleDetail.aspx?vehid=" + vehId, "info6", "resizable=no,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                    //test1 = "../Master/frmVehicleDetail.aspx?vehid=" + vehId;
                    //document.write('<iframe height="450"  allowTransparency="true" frameborder="0" scrolling="yes" style="width:100%" ,target="_top"; src="' + test1 + '" type= "text/javascript"></iframe>');
                } 
            });

               $('#<%=txtSrchCust.ClientID%>').change(function (e) {
                var custId = $('#<%=txtSrchCust.ClientID%>').val();
                var retVal = validateCust(custId);
                if (retVal == "False")
                {
                    if($('#<%=txtSrchCust.ClientID%>').val().length > 0){
                        alert("Do you want to create that customer?");
                        //LoadAllModel();
                        window.open("../Master/frmCustomerDetail.aspx?cust=" + custId, "info6", "resizable=no,scrollbars=1,status=yes,width=1000px,height=700px,menubar=0,toolbar=0");
                        //test1 = "../Master/frmVehicleDetail.aspx?vehid=" + vehId;
                            //document.write('<iframe height="450"  allowTransparency="true" frameborder="0" scrolling="yes" style="width:100%" ,target="_top"; src="' + test1 + '" type= "text/javascript"></iframe>');
                    }
                } 
            });

           // PopulateWODetails(WoNo, WoPr);
            var cust = $('#<%=txtSrchCust.ClientID%>').val();
            $('#<%=txtSrchCust.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Customer_Search",
                        data: "{'q':'" + $('#<%=txtSrchCust.ClientID%>').val() + "'}",
                        dataType: "json",
                        //success: function (data) {
                        //    response(data.d);
                        //},
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PERM_ADD1 + " - " + item.ID_CUST_PERM_ZIPCODE + " " + item.CUST_PERM_CITY,
                                    val: item.ID_CUSTOMER,
                                    value: item.ID_CUSTOMER
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    <%--$("#<%=txtCustomer.ClientID %>").val(i.item.val);--%>
                    $("#<%=txtSrchCust.ClientID%>").val(i.item.val);
                    FillCustDet($("#<%=txtSrchCust.ClientID%>").val());
                    FillVehDrpDwn($("#<%=txtSrchCust.ClientID%>").val());
                    LoadNonInvoiceOrderDet($("#<%=txtSrchCust.ClientID%>").val());

                    //NonInvoicedOrders();
                    
                },
            });
           
            $('#<%=txtSrchVeh.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOHead.aspx/GetVehicle",
                        data: "{'vehicleRegNo':'" + $('#<%=txtSrchVeh.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0]
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtSrchVeh.ClientID%>").val(i.item.value);
                    FillVehDet($("#<%=txtSrchVeh.ClientID%>").val());
                   
                }
            });
            function loadOrderJobsGrid()
            {
            if (WoNo != "" ){
                var grid = $("#dgdOrderJobs");
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                var orderdata;

                grid.jqGrid({
                    datatype: "local",
                    data: orderdata,
                    colNames: ['ID_JOB', 'JOB_STATUS', 'WO_JOB_TXT', 'JOB_AMT', 'JOB_EXVAT_AMT', 'Debtor', 'HPFlag',''],
                    colModel: [
                             { name: 'Id_Job', index: 'Id_Job', width: 60, sorttype: "string", formatter: viewJob },
                             { name: 'Job_Status', index: 'Job_Status', width: 120, sorttype: "string" },
                             { name: 'WO_Job_Txt', index: 'WO_Job_Txt', width: 160, sorttype: "string" },
                             { name: 'Job_Amt', index: 'Job_Amt', width: 100, sorttype: "string" },
                             { name: 'Job_ExVat_Amt', index: 'Job_ExVat_Amt', width: 160, sorttype: "string" },
                             { name: 'Debtor', index: 'Debtor', width: 60, sorttype: "string",hidden:true },
                             { name: 'HpFlag', index: 'HpFlag', width: 60, sorttype: "string", hidden: true },
                             { name: 'ID_JOB', index: 'ID_JOB', sortable: false, formatter: viewJobDet }
                             //,
                             //{ name: 'Id_Job_Deb', index: 'Id_Job_Deb', sortable: false, formatter: editDebitors  }
                    ],
                    multiselect: true,
                    pager: jQuery('#pagerOrderJobs'),
                    rowNum: 5,//can fetch from webconfig
                    rowList: 5,
                    viewrecords: true,
                    height: "50%",
                    async: false, //Very important,
                    subGrid: false
                });
                    sortorder: 'asc',

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOHead.aspx/Fetch_WOHeader",
                    data: "{'idWONO':'" + WoNo + "',idWOPrefix:'" + WoPr + "',userId:'" + userId + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            orderdata = data;
                            jQuery("#dgdOrderJobs").jqGrid('addRowData', i + 1, orderdata.d[i]);
                        }
                    }
                });
                jQuery("#dgdOrderJobs").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
                $("#dgdOrderJobs").jqGrid("hideCol", "subGrid");
            }

            }

           

            $('#<%=txtZipCode.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOHead.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtZipCode.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            $('#<%=hdnNewZip.ClientID%>').val("1");
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
                            $('#<%=hdnNewZip.ClientID%>').val("0");
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
                },
            });

            $('#<%=btnDeleteJob.ClientID%>').on('click', function () {
                DeleteJob();
            });
           

        }); //End of ready
                     
           function validateVeh(VehicleId) {
               var strRetVal;
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "frmWOHead.aspx/ValidateVehicle",
                   data: "{IdVehicle: '" + VehicleId + "'}",
                   dataType: "json",
                   async: false,
                   success: function (data) {
                       strRetVal = data.d.toString()

                   },
                   error: function (result) {
                       alert("Error");
                   }
               });
               return strRetVal;
           }

           function validateCust(CustomerId) {
               var strRetVal;
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "frmWOHead.aspx/ValidateCustomer",
                   data: "{IdCustomer: '" + CustomerId + "'}",
                   dataType: "json",
                   async: false,
                   success: function (data) {
                       strRetVal = data.d.toString()

                   },
                   error: function (result) {
                       alert("Error");
                   }
               });
               return strRetVal;
           }

           function loadMechanicGrid(WoNo, WoPr) {
               if (WoNo != "") {
                   var userId = '<%= Session("UserID")%>';
                   var grid = $("#dgdOrdMechanic");
                   var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                   var orderdata;

                   grid.jqGrid({
                       datatype: "local",
                       data: orderdata,
                       colNames: ['Id_Job', 'MechanicName', 'TotClockedTime', 'MechStatus'],
                       colModel: [
                                { name: 'Id_Job', index: 'Id_Job', width: 60, sorttype: "string" },
                                { name: 'MechanicName', index: 'MechanicName', width: 200, sorttype: "string" },
                                { name: 'TotClockedTime', index: 'TotClockedTime', width: 160, sorttype: "string" },
                                { name: 'MechStatus', index: 'MechStatus', width: 160, sorttype: "string" }


                               
                       ],
                       multiselect: true,
                       pager: jQuery('#pagerOrdMechanic'),
                       rowNum: 5,//can fetch from webconfig
                       rowList: 5,
                       viewrecords: true,
                       height: "50%",
                       async: false, //Very important,
                       subGrid: false
                   });
                   sortorder: 'asc',

               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "frmWOHead.aspx/Fetch_MechGrid",
                   data: "{'idWONO':'" + WoNo + "',idWOPrefix:'" + WoPr + "',userId:'" + userId + "'}",
                   //data: {},
                   dataType: "json",
                   async: false,//Very important
                   success: function (data) {
                       for (i = 0; i < data.d.length; i++) {
                           orderdata = data;
                           jQuery("#dgdOrdMechanic").jqGrid('addRowData', i + 1, orderdata.d[i]);
                       }
                   }
               });
                   jQuery("#dgdOrdMechanic").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
                   $("#dgdOrdMechanic").jqGrid("hideCol", "subGrid");

               }
           }

           function viewJob(cellvalue, options, rowObject) {
               var idWONO = $(document.getElementById('<%=hdnWoNo.ClientID%>')).val(); //'<%= Session("WONO")%>';
               var idWOPrefix = $(document.getElementById('<%=hdnWoPr.ClientID%>')).val();   //'<%= Session("WOPR")%>';
               var id_job = rowObject.Id_Job.toString();
               var selectedId = options.rowId;
               var strOptions = cellvalue;
               var hdView = document.getElementById('<%=hdnViewCap.ClientID%>').value;
               $(document.getElementById('<%=hdnVAMode.ClientID%>')).val("Edit");
               var mode = $("#<%=hdnVAMode.ClientID%>").val();

               var edit = "<a href='#' style='text-decoration:underline' type='button' title='" + id_job + "' onclick=redirectJobDet(" + "'" + id_job + "','" + idWONO + "'" + ",'" + idWOPrefix + "'" + ",'" + mode + "'" + ")>" + id_job + "</a>";
               return edit;
           }          

           function LoadAllModel()
           {
               $.ajax({
                   type: "POST",
                   url: "frmWOHead.aspx/LoadAllModel",
                   data: '{}',
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   async: false,
                   success: function (Result) {
                       $('#<%=ddlModel.ClientID%>').empty();
                       $('#<%=ddlModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                       Result = Result.d;
                       $.each(Result, function (key, value) {
                           $('#<%=ddlModel.ClientID%>').append($("<option></option>").val(value.Model_Desc).html(value.Id_Model));

                       });

                   },
                   failure: function () {
                       alert("Failed!");
                   }
               });
           }

           function FillPayDet(IdCustGrp)
           {

               var IdCustomer = $('#<%=txtSrchCust.ClientID%>').val();
              
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "frmWOHead.aspx/FillPaymentDet",
                   data: "{IdCustGrp: '" + IdCustGrp + "'}",
                   dataType: "json",
                   success: function (data) {
                       if (data.d.length > 0) {
                           var cashPayType = data.d[0].Pay_Type.toString();
                           if (cashPayType == "Cash") {
                               var msg = GetMultiMessage('WOCASH_PAY', '', '');
                               alert(msg);
                               FillCustDet(IdCustomer);
                           }
                           if (data.d[0].ErrorMessage != "") {
                               alert(data.d[0].ErrorMessage);
                               FillCustDet(IdCustomer);
                              
                           }
                           else {
                               
                               if (data.d[0].Pay_Type == 0) {
                                   $('#<%=ddlPayType.ClientID%>')[0].selectedIndex = 0;
                               }
                               else {
                                   //$('#<%=ddlPayType.ClientID%>').val(data.d[0].Pay_Type);
                                   $('#<%=ddlPayType.ClientID%> option:contains("' + data.d[0].Pay_Type + '")').attr('selected', 'selected');
                                   $("#<%=ddlPayType.ClientID%>").attr('disabled', 'disabled');
                               }

                               if (data.d[0].Pay_Term == 0) {
                                   $('#<%=ddlPayTerms.ClientID%>')[0].selectedIndex = 0;
                               }
                               else {
                                   //$('#<%=ddlPayTerms.ClientID%>').val(data.d[0].Pay_Term);
                                   $('#<%=ddlPayTerms.ClientID%> option:contains("' + data.d[0].Pay_Term + '")').attr('selected', 'selected');
                                   $("#<%=ddlPayTerms.ClientID%>").attr('disabled', 'disabled');
                               }
                           }
                       }
                      
                   },
                   error: function (result) {
                       alert("Error");
                   }
               });
            }

           function DeleteJob()
           {
               var row;
               var jobId;
               var IdWoNo;
               var IdWoPr;
               var jobIdXml;
               var jobIdXmls = "";
               var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

               $('#dgdOrderJobs input:checkbox').attr("checked", function () {
                   if (this.checked) {
                       row = $(this).closest('td').parent()[0].sectionRowIndex;
                       IdWoNo = $('#<%=lbl_h_ordno.ClientID%>').text();
                       IdWoPr = $('#<%=lbl_h_prefix.ClientID%>').text();
                       jobId = $('#dgdOrderJobs tr ')[row].cells[1].innerText.toString();
                       jobIdXml = "<JOB><ID_JOBS>" + jobId + "</ID_JOBS><ID_PR>" + IdWoPr + "</ID_PR> <ID_WO>" + IdWoNo + "</ID_WO></JOB>";
                       jobIdXmls += jobIdXml;
                       $('#dgdOrderJobs').jqGrid('delRowData', jobId);
                   }
               });

               if (jobIdXmls != "") {
                   jobIdXmls = "<ROOT>" + jobIdXmls + "</ROOT>";
                   $.ajax({
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       url: "frmWOHead.aspx/DeleteJob",
                       data: "{jobIdXmls: '" + jobIdXmls + "'}",
                       dataType: "json",
                       success: function (data) {
                           //jQuery("#dgdOrderJobs").jqGrid('clearGridData');
                           //gridload();
                           
                           jQuery("#dgdOrderJobs").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                           
                           if (data.d[0] == "DEL") {
                               if (data.d[2].toString() != "") {
                                   alert(data.d[2].toString());
                                   $('#<%=RTlblError.ClientID%>').text(data.d[1].toString());
                                   $('#<%=RTlblError.ClientID%>').removeClass();
                                   $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                   
                               }
                               else
                               {
                                   $('#<%=RTlblError.ClientID%>').text(data.d[1].toString());
                                   $('#<%=RTlblError.ClientID%>').removeClass();
                                   $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                               }
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
        
           function viewJobDet(cellvalue, options, rowObject) {
            var id_job = rowObject.Id_Job.toString();
            var selectedId = options.rowId;
            var strOptions = cellvalue;
            var hdView = document.getElementById('<%=hdnViewCap.ClientID%>').value;
            $(document.getElementById('<%=hdnVAMode.ClientID%>')).val("Edit");
            $(document.getElementById('<%=hdnNewZip.ClientID%>')).val("1");
            var mode = $("#<%=hdnVAMode.ClientID%>").val();
            var woNo = $(document.getElementById('<%=hdnWoNo.ClientID%>')).val();
               var woPr = $(document.getElementById('<%=hdnWoPr.ClientID%>')).val();    

               var edit = "<input style='...' type='button' value='" + hdView + "' onclick=redirectJobDet(" + "'" + id_job + "','" + woNo + "'" + ",'" + woPr + "'" + ",'" + mode + "'" + "); />";
            return edit;
        }    
        

        function FillVehDrpDwn(CustID) {
            <%-- $('#<%=ddlVeh.ClientID%>').show();--%>
            $('#<%=lst_veh.ClientID%>').show();
            $('#<%=txtSrchVeh.ClientID%>').hide();
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadVehDrpdwn",
                data: "{'IdCustomer':'" + CustID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    if (Result.length != 0) {
                    $('#<%=lst_veh.ClientID%>').empty();
                    if (Result[0].ErrorMessage != "" && $('#<%=txtRegNo.ClientID%>').val() !="") {
                        var con = confirm(Result[0].ErrorMessage);
                        if (con == true)
                        {
                            $('#<%=lst_veh.ClientID%>').show();
                            $('#<%=txtSrchVeh.ClientID%>').hide();
                            $.each(Result, function (key, value) {
                                $('#<%=lst_veh.ClientID%>').append($("<option></option>").val(value.Id_Veh_Seq_WO).html(value.Veh_Det));
                            });
                        }
                        else
                        {
                            $('#<%=lst_veh.ClientID%>').hide();
                            $('#<%=txtSrchVeh.ClientID%>').show();
                        }
                       
                    }
                    else
                    {
                        $('#ctl00_cntMainPanel_lst_veh').show();
                        $.each(Result, function (key, value) {
                            $('#ctl00_cntMainPanel_lst_veh').append($("<option></option>").val(value.Id_Veh_Seq_WO).html(value.Veh_Det));
                        });
                    }
                    }
                    else
                    {
                        $('#<%=lst_veh.ClientID%>').hide();
                        $('#<%=txtSrchVeh.ClientID%>').show();
                    }                  
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function FillType() {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadOrdTypes",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlType.ClientID%>').empty();
                    $('#<%=ddlType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlType.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                        $('#<%=ddlType.ClientID%>')[0].selectedIndex = 3;
                        $('#<%=btnConfirmation.ClientID%>').show();
                        $('#<%=btnProposal.ClientID%>').hide();
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
           function FillStatus() {
               var ordType = $('#<%=ddlType.ClientID%>').val();
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/FillOrdStatus",
                data: "{'ordType':'" + ordType + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlStatus.ClientID%>').empty();
                   $('#<%=ddlStatus.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        var ordType = $('#<%=ddlType.ClientID%>').val();
                        if (ordType == "ORD")
                        {
                            if ((value.Id_Settings == "CSA") || (value.Id_Settings == "JST") || (value.Id_Settings == "RES"))
                            {
                                $('#<%=ddlStatus.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                            }
                           
                           
                        }
                        if (ordType == "CRSL") {
                            if ((value.Id_Settings == "STR")) {
                                $('#<%=ddlStatus.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                            }
                        }
                    });
                   
                    if (Result[0].Tmp_Id_Settings != "") {
                        $('#<%=ddlStatus.ClientID%>').val(Result[0].Tmp_Id_Settings);
                    }

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillOrderStatus(ordType) {
            
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadOrdStatus",
                data: "{'OrderType':'" + ordType + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlStatus.ClientID%>').empty();
                    $('#<%=ddlStatus.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlStatus.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                    
                    });
                   

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillPayType() {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadPayTypes",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlPayType.ClientID%>').empty();
                    $('#<%=ddlPayType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlPayType.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                        $("#<%=ddlPayType.ClientID%>").attr('disabled', 'disabled');
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillPayTerms() {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadPayTerms",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlPayTerms.ClientID%>').empty();
                    $('#<%=ddlPayTerms.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlPayTerms.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                        $("#<%=ddlPayTerms.ClientID%>").attr('disabled', 'disabled');
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillCustGroup() {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadCustGroup",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlCusGroup.ClientID%>').empty();
                    $('#<%=ddlCusGroup.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlCusGroup.ClientID%>').append($("<option></option>").val(value.Id_Cust_Group_Seq).html(value.Cust_Group));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function FillMake() {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadVehMake",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlMake.ClientID%>').empty();
                    $('#<%=ddlMake.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlMake.ClientID%>').append($("<option></option>").val(value.Id_Make).html(value.Veh_Make));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

           function FillNewModel() {
               $.ajax({
                   type: "POST",
                   url: "frmWOHead.aspx/LoadModel",
                   data: '{}',
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   async: false,
                   success: function (Result) {
                       Result = Result.d;
                       $('#<%=ddlModel.ClientID%>').empty();
                       $('#<%=ddlModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                       $.each(Result, function (key, value) {
                           $('#<%=ddlModel.ClientID%>').append($("<option></option>").val(value.Id_Model).html(value.Model_Desc));

                       });

                   },
                   failure: function () {
                       alert("Failed!");
                   }
               });
           }
           

        function FillModel(IdMake) {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadVehModel",
                data: "{'IdMake':'" + IdMake + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlModel.ClientID%>').empty();
                    $('#<%=ddlModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlModel.ClientID%>').append($("<option></option>").val(value.Model_Desc).html(value.Id_Model));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
           function LoadNonInvoiceOrderDet(custId)
           {
               var userId = '<%= Session("UserID")%>';
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "NonInvoiceOrder.aspx/LoadNonInvoiceOrderDet",
                   data: "{'idCust':'" + custId + "',idUser:'" + userId + "'}",
                   //data: {},
                   dataType: "json",
                   async: false,//Very important
                   success: function (data) {
                       if (data.d.length !=0)
                       {
                            window.open("NonInvoiceOrder.aspx", 'info6', "resizable=no,scrollbars=1,status=yes,width=500px,height=300px,menubar=0,toolbar=0");
                       }
                   }
               });
           }
        
           function PopulateWODetails(WoNo, WoPr, Flag) {
            $('#<%=RTlblError.ClientID%>').text("");
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/FetchWODetails",
                data: "{'WoNo':'" + WoNo + "','WoPr':'" + WoPr + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    FillOrderStatus(data.d[0].WO_Type);
                    if (data.d[0].WO_Type == 0) {
                        $('#<%=ddlType.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlType.ClientID%>').val(data.d[0].WO_Type);
                    }
                    if (data.d[0].WO_Type == "ORD") {

                        $('#<%=btnConfirmation.ClientID%>').show();
                        $('#<%=btnProposal.ClientID%>').hide();
                    }
                    else if (data.d[0].WO_Type == "BAR")
                    {
                        $('#<%=btnConfirmation.ClientID%>').hide();
                        $('#<%=btnProposal.ClientID%>').show();
                    }

                    if (data.d[0].WO_Status == 0) {
                        $('#<%=ddlStatus.ClientID%>')[0].selectedIndex = 0;
                    }
                    else 
                        {
                            $('#<%=ddlStatus.ClientID%>').val(data.d[0].WO_Status);
                        }
                      $("#<%=ddlStatus.ClientID%>").attr('disabled', 'disabled'); 
                   

                    if (data.d[0].WO_Status == 'RINV' || data.d[0].WO_Status == 'INV')
                    {
                        $("#<%=btnDeleteJob.ClientID%>").attr('disabled', 'disabled'); 
                    }
                    else
                    {
                        $('#<%=btnDeleteJob.ClientID%>').removeAttr("disabled");

                    }

                    if (data.d[0].Veh_Make == 0) {
                        $('#<%=ddlMake.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                       $('#<%=ddlMake.ClientID%> option:contains("' + data.d[0].Veh_Make + '")').attr('selected', 'selected');
                        <%--$('#<%=ddlMake.ClientID%>').val(data.d[0].Veh_Make);--%>
                    }

                    //FillModel(data.d[0].Veh_Make);
                    
                    if (data.d[0].Id_Model == "") {
                        $('#<%=ddlModel.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        //$('#<%=ddlModel.ClientID%> option:contains("' + data.d[0].Id_Model + '")').attr('selected', 'selected');
                        $('#<%=ddlModel.ClientID%>').val(data.d[0].Id_Model);
                    }
                    $('#<%=txtSrchCust.ClientID%>').val(data.d[0].Id_Cust_Wo);
                    $('#<%=txtName.ClientID%>').val(data.d[0].WO_Cust_Name);
                    $('#<%=txtAddress1.ClientID%>').val(data.d[0].WO_Cust_Add1);
                    $('#<%=txtAddress2.ClientID%>').val(data.d[0].Cust_Perm_Add2);
                    $('#<%=txtZipCode.ClientID%>').val(data.d[0].Id_Zipcode_WO);
                    $('#<%=txtState.ClientID%>').val(data.d[0].City);
                    $('#<%=txtCountry.ClientID%>').val(data.d[0].Country_WO);
                    $('#<%=txtHPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Off);
                    $('#<%=txtOPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Home);
                    $('#<%=txtMobNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Mobile);
                    $('#<%=txtDeliveryTime.ClientID%>').val(data.d[0].WO_Tm_Deliv);
                    $('#<%=txtFinishDate.ClientID%>').val(data.d[0].Dt_Finish);
                    $('#<%=txtDeliveryDate.ClientID%>').val(data.d[0].Dt_Delivery);

                    $('#<%=txtSrchVeh.ClientID%>').val(data.d[0].Id_Veh_Seq_WO);
                    $('#<%=txtRegNo.ClientID%>').val(data.d[0].WO_Veh_Reg_NO);
                    $('#<%=txtInternalNo.ClientID%>').val(data.d[0].Veh_Int_No);
                    $('#<%=txtVIN.ClientID%>').val(data.d[0].WO_Veh_Vin);
                    $('#<%=txtMileage.ClientID%>').val(data.d[0].WO_Veh_Mileage);
                    $('#<%=txtHours.ClientID%>').val(data.d[0].WO_Veh_Hrs);
                    $('#<%=txtCostPrice.ClientID%>').val(data.d[0].VA_Cost_Price);
                    $('#<%=txtSellPrice.ClientID%>').val(data.d[0].VA_Sell_Price);
                    $('#<%=txtVANum.ClientID%>').val(data.d[0].Van_Num)
                    $('#<%=txtDeptAccntNum.ClientID%>').val(data.d[0].La_Dept_Account_No);
                    $('#<%=TxtAnnotation.ClientID%>').val(data.d[0].WO_Annot);

                    if (data.d[0].Id_Pay_Type_WO == 0) {
                        $('#<%=ddlPayType.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlPayType.ClientID%>').val(data.d[0].Id_Pay_Type_WO);
                        $("#<%=ddlPayType.ClientID%>").attr('disabled', 'disabled'); 
                    }

                    if (data.d[0].Id_Pay_Terms_WO == 0) {
                        $('#<%=ddlPayTerms.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlPayTerms.ClientID%>').val(data.d[0].Id_Pay_Terms_WO);
                        $("#<%=ddlPayTerms.ClientID%>").attr('disabled', 'disabled'); 
                    }
                    if (data.d[0].Id_Cust_Group_Seq == 0) {
                        $('#<%=ddlCusGroup.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        //$('#<%=ddlCusGroup.ClientID%>')[0].val("5");
                        //$('#<%=ddlCusGroup.ClientID%> option:contains("' + data.d[0].Id_Cust_Group_Seq + '")').attr('selected', 'selected');
                        $('#<%=ddlCusGroup.ClientID%>').val(data.d[0].Id_Cust_Group_Seq);
                    }
                    if ((data.d[0].WO_Status == "INV") || (data.d[0].WO_Status == "RINV"))
                    {
                        $('#<%=btnUpdate.ClientID%>').attr("disabled", "disabled");
                        $('#<%=btnAddJob.ClientID%>').attr("disabled", "disabled");
                    }

                    $('#<%=lbl_h_ordno.ClientID%>').text(WoNo);
                    $('#<%=lbl_h_prefix.ClientID%>').text(WoPr);
                    $('#<%=RTlbl_OrderNo.ClientID%>').text(WoPr + WoNo);
                    $('#<%=RTlblOrderDate.ClientID%>').text(data.d[0].Dt_Order);
                    $('#<%=txtJobNo.ClientID%>').show();
                    FetchDefectNote(data.d[0].Id_Veh_Seq_WO);
                    loadMechanicGrid(WoNo, WoPr);

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillCustDet(IdCustomer) {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadCustDet",
                data: "{IdCustomer: '" + IdCustomer + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    $('#<%=txtSrchCust.ClientID%>').val(data.d[0].Cust_ID);
                    $('#<%=txtName.ClientID%>').val(data.d[0].WO_Cust_Name);
                    $('#<%=txtAddress1.ClientID%>').val(data.d[0].WO_Cust_Add1);
                    $('#<%=txtAddress2.ClientID%>').val(data.d[0].Cust_Perm_Add2);
                    $('#<%=txtState.ClientID%>').val(data.d[0].PState);
                    $('#<%=txtZipCode.ClientID%>').val(data.d[0].PZipcode);
                    $('#<%=txtCountry.ClientID%>').val(data.d[0].PCountry);
                    $('#<%=txtHPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Off);
                    $('#<%=txtOPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Home);
                    $('#<%=txtMobNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Mobile);
                    if (data.d[0].Id_Pay_Type_WO == 0) {
                        $('#<%=ddlPayType.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlPayType.ClientID%>').val(data.d[0].Id_Pay_Type_WO);
                    }

                    if (data.d[0].Id_Pay_Terms_WO == 0) {
                        $('#<%=ddlPayTerms.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlPayTerms.ClientID%>').val(data.d[0].Id_Pay_Terms_WO);
                    }
                    if (data.d[0].Cust_Group == 0) {
                        $('#<%=ddlCusGroup.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlCusGroup.ClientID%> option:contains("' + data.d[0].Cust_Group + '")').attr('selected', 'selected');
                    }
                

                },
                failure: function () {
                    alert("Failed!");
                }
            });
           
        }
       
        function FillVehDet(VehicleId) {
            $.ajax({
                type: "POST",
                url: "frmWOHead.aspx/LoadVehDet",
                data: "{VehicleId: '" + VehicleId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    debugger;
                    $('#<%=txtRegNo.ClientID%>').val(data.d[0].WO_Veh_Reg_NO);
                    $('#<%=txtInternalNo.ClientID%>').val(data.d[0].Veh_Int_No);
                    $('#<%=txtVIN.ClientID%>').val(data.d[0].WO_Veh_Vin);
                    $('#<%=txtMileage.ClientID%>').val(data.d[0].WO_Veh_Mileage);
                    $('#<%=txtHours.ClientID%>').val(data.d[0].WO_Veh_Hrs);
                    $('#<%=txtCostPrice.ClientID%>').val(data.d[0].VA_Cost_Price);
                    $('#<%=txtSellPrice.ClientID%>').val(data.d[0].VA_Sell_Price);
                    $('#<%=txtVANum.ClientID%>').val(data.d[0].Van_Num)
                    if (data.d[0].Id_Make == 0) {
                        $('#<%=ddlMake.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        $('#<%=ddlMake.ClientID%>').val(data.d[0].Id_Make);
                        //$('#<%=ddlMake.ClientID%> option:contains("' + data.d[0].Id_Make + '")').attr('selected', 'selected');
                    }

                    //FillModel(data.d[0].Id_Make);

                    if (data.d[0].Id_Model == 0) {
                        $('#<%=ddlModel.ClientID%>')[0].selectedIndex = 0;
                    }
                    else {
                        //$('#<%=ddlModel.ClientID%> option:contains("' + data.d[0].Id_Model + '")').attr('selected', 'selected');
                        $('#<%=ddlModel.ClientID%>').val(data.d[0].Id_Model);
                    }
                    $(document.getElementById('<%=hdnVehGrpDesc.ClientID%>')).val(data.d[0].Veh_Grpdesc); 

                    if ($('#<%=txtName.ClientID%>').val() == "")
                    {
                        $('#<%=txtSrchCust.ClientID%>').val(data.d[0].Cust_ID);
                        $('#<%=txtName.ClientID%>').val(data.d[0].WO_Cust_Name);
                        $('#<%=txtAddress1.ClientID%>').val(data.d[0].WO_Cust_Add1);
                        $('#<%=txtAddress2.ClientID%>').val(data.d[0].Cust_Perm_Add2);
                        $('#<%=txtState.ClientID%>').val(data.d[0].PState);
                        $('#<%=txtZipCode.ClientID%>').val(data.d[0].PZipcode);
                        $('#<%=txtCountry.ClientID%>').val(data.d[0].PCountry);
                        $('#<%=txtHPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Off);
                        $('#<%=txtOPhoneNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Home);
                        $('#<%=txtMobNo.ClientID%>').val(data.d[0].WO_Cust_Phone_Mobile);
                        if (data.d[0].Id_Pay_Type_WO == 0) {
                            $('#<%=ddlPayType.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlPayType.ClientID%>').val(data.d[0].Id_Pay_Type_WO);
                        }

                        if (data.d[0].Id_Pay_Terms_WO == 0) {
                            $('#<%=ddlPayTerms.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlPayTerms.ClientID%>').val(data.d[0].Id_Pay_Terms_WO);
                        }
                        if (data.d[0].Id_Cust_Group_Seq == 0) {
                            $('#<%=ddlCusGroup.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlCusGroup.ClientID%> option:contains("' + data.d[0].Id_Cust_Group_Seq + '")').attr('selected', 'selected');
                           
                        }
                    }
                    FetchDefectNote(VehicleId);

                },
                failure: function () {
                    alert("Failed!");
                }
            });

        }
           function FetchDefectNote(vehicleId)
           {
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "frmWOHead.aspx/Fetch_DefectNote",
                   data: "{'idVeh':'" + vehicleId + "'}",
                   //data: {},
                   dataType: "json",
                   async: false,//Very important
                   success: function (data) {
                       strValue = data.d.toString();
                       if (strValue=="True")
                       {
                           $('#<%=lnkDefect.ClientID%>').show();
                       }
                       else
                       {
                           $('#<%=lnkDefect.ClientID%>').hide();
                       }
                   }

               });
           }

           function openDefect() {
               var vid = $('#<%=txtSrchVeh.ClientID%>').val();
               var vRegNo = $('#<%=txtRegNo.ClientID%>').val();
               var vVIN = $('#<%=txtVIN.ClientID%>').val();
               var vInternNo = $('#<%=txtInternalNo.ClientID%>').val();
               var url = "frmWODefectNotes.aspx?FLG=1&VID=" + vid + "&RegNo=" + vRegNo + "&InternalNo=" + vInternNo + "&VIN=" + vVIN ;
               var win = window.open(url, 'info3', 'resizable=no,scrollbars=1,status=yes,width=600px,height=400px,menubar=0,toolbar=0');
               win.focus();
           }

           function SaveOrder() {
               var dtord = $('#<%=RTlblOrderDate.ClientID%>').val();
               var model = $("#<%=ddlModel.ClientID%> option:selected").text();
               var make = $("#<%=ddlMake.ClientID%> option:selected").text();
            var result = fnClientValidate();
            var bool = chkCreditLimit_Customer();
            if ((result == true) && (bool == true)) {
                $.ajax({
                    type: "POST",
                    url: "frmWOHead.aspx/SaveOrderDetails",
                    data: "{custID: '" + $('#<%=txtSrchCust.ClientID%>').val() + "',Id_Wo_No: '', ordDt:'" + $('#<%=RTlblOrderDate.ClientID%>')[0].innerHTML + "', woType:'" + $('#<%=ddlType.ClientID%>').val() + "', woStatus:'" + $('#<%=ddlStatus.ClientID%>').val() + "', Wo_Tm_Deliv:'" + $('#<%=txtDeliveryTime.ClientID%>').val() + "', delivDate:'" + $('#<%=txtDeliveryDate.ClientID%>').val() + "', finishDate:'" + $('#<%=txtFinishDate.ClientID%>').val() + "',payType:'" + $('#<%=ddlPayType.ClientID%>').val() + "',payTerms:'" + $('#<%=ddlPayTerms.ClientID%>').val() + "',custPermAddr1:'" + $('#<%=txtAddress1.ClientID%>').val() + "',custPermAddr2:'" + $('#<%=txtAddress2.ClientID%>').val() + "',zipCode:'" + $('#<%=txtZipCode.ClientID%>').val() + "',custOffPh:'" + $('#<%=txtOPhoneNo.ClientID%>').val() + "',custHmPh:'" + $('#<%=txtHPhoneNo.ClientID%>').val() + "',idVehSeq:'" + $('#<%=txtSrchVeh.ClientID%>').val() + "',vehRegNo:'" + $('#<%=txtRegNo.ClientID%>').val() + "',annotation:'" + $('#<%=TxtAnnotation.ClientID%>').val() + "',custName:'" + $('#<%=txtName.ClientID%>').val() + "',custMob:'" + $('#<%=txtMobNo.ClientID%>').val() + "',vehInterNo:'" + $('#<%=txtInternalNo.ClientID%>').val() + "',vehVin:'" + $('#<%=txtVIN.ClientID%>').val() + "',updVehFlag:'0" + 
                        "',vehMileage: '" + $('#<%=txtMileage.ClientID%>').val() + "', vehHrs:'" + $('#<%=txtHours.ClientID%>').val() + "', country:'" + $('#<%=txtCountry.ClientID%>').val() + "', state:'" + $('#<%=txtState.ClientID%>').val() + "', vehMake:'" + make + "', vehModel:'" + $('#<%=ddlModel.ClientID%>').val() + "', custGrp:'" + $('#<%=ddlCusGroup.ClientID%>').val() + "', vehGrpDesc:'" + $(document.getElementById('<%=hdnVehGrpDesc.ClientID%>')).val() + "', deptAccntNum:'" + $('#<%=txtDeptAccntNum.ClientID%>').val() + "', VACostPrice:'" + $('#<%=txtCostPrice.ClientID%>').val() + "', VASellPrice:'" + $('#<%=txtSellPrice.ClientID%>').val() + "', VANum:'" + $('#<%=txtVANum.ClientID%>').val() + "', IntNote:'',DeptAccNum:'" + $('#<%=txtDeptAccntNum.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d[0];
                        if (Result.SuccessMessage == "INSFLG")  {
                            var OrdNo = Result.Id_WO_Prefix + Result.Id_WO_NO;
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=RTlbl_OrderNo.ClientID%>').text(OrdNo);
                            window.location.href = 'frmWOJobDetails.aspx?TabId=3&Name=' + $('#<%=txtName.ClientID%>').val() + '&Mode=Add';
                   

                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(Result.ErrorMessage);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }

                    

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }
        }
        function chkCreditLimit_Customer()
        {
            var custId = $('#<%=txtSrchCust.ClientID%>').val();
            var strValue;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmWOHead.aspx/CreditLimit_Customer",
                data: "{'idCust':'" + custId + "'}",
                //data: {},
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    strValue = data.d.toString();
                    }
               
            });
            if (strValue != "True")
            {
                return confirm(strValue);
            }
            else {
                return true;
            }
        }
           function UpdateOrder() {
               var dtord = $('#<%=RTlblOrderDate.ClientID%>').val();
               var model = $("#<%=ddlModel.ClientID%> option:selected").text();
               var make = $("#<%=ddlMake.ClientID%> option:selected").text();
            var bool = chkCreditLimit_Customer();
            if ((bool == true)) {
                $.ajax({
                    type: "POST",
                    url: "frmWOHead.aspx/UpdateOrderDetails",
                    data: "{custID: '" + $('#<%=txtSrchCust.ClientID%>').val() + "',Id_Wo_No: '', ordDt:'" + $('#<%=RTlblOrderDate.ClientID%>')[0].innerHTML + "', woType:'" + $('#<%=ddlType.ClientID%>').val() + "', woStatus:'" + $('#<%=ddlStatus.ClientID%>').val() + "', Wo_Tm_Deliv:'" + $('#<%=txtDeliveryTime.ClientID%>').val() + "', delivDate:'" + $('#<%=txtDeliveryDate.ClientID%>').val() + "', finishDate:'" + $('#<%=txtFinishDate.ClientID%>').val() + "',payType:'" + $('#<%=ddlPayType.ClientID%>').val() + "',payTerms:'" + $('#<%=ddlPayTerms.ClientID%>').val() + "',custPermAddr1:'" + $('#<%=txtAddress1.ClientID%>').val() + "',custPermAddr2:'" + $('#<%=txtAddress2.ClientID%>').val() + "',zipCode:'" + $('#<%=txtZipCode.ClientID%>').val() + "',custOffPh:'" + $('#<%=txtOPhoneNo.ClientID%>').val() + "',custHmPh:'" + $('#<%=txtHPhoneNo.ClientID%>').val() + "',idVehSeq:'" + $('#<%=txtSrchVeh.ClientID%>').val() + "',vehRegNo:'" + $('#<%=txtRegNo.ClientID%>').val() + "',annotation:'" + $('#<%=TxtAnnotation.ClientID%>').val() + "',custName:'" + $('#<%=txtName.ClientID%>').val() + "',custMob:'" + $('#<%=txtMobNo.ClientID%>').val() + "',vehInterNo:'" + $('#<%=txtInternalNo.ClientID%>').val() + "',vehVin:'" + $('#<%=txtVIN.ClientID%>').val() + "',updVehFlag:'0" +
                           "',vehMileage: '" + $('#<%=txtMileage.ClientID%>').val() + "', vehHrs:'" + $('#<%=txtHours.ClientID%>').val() + "', country:'" + $('#<%=txtCountry.ClientID%>').val() + "', state:'" + $('#<%=txtState.ClientID%>').val() + "', vehMake:'" + make + "', vehModel:'" + $('#<%=ddlModel.ClientID%>').val() + "', custGrp:'" + $('#<%=ddlCusGroup.ClientID%>').val() + "', vehGrpDesc:'" + $(document.getElementById('<%=hdnVehGrpDesc.ClientID%>')).val() + "', deptAccntNum:'" + $('#<%=txtDeptAccntNum.ClientID%>').val() + "', VACostPrice:'" + $('#<%=txtCostPrice.ClientID%>').val() + "', VASellPrice:'" + $('#<%=txtSellPrice.ClientID%>').val() + "', VANum:'" + $('#<%=txtVANum.ClientID%>').val() + "', IntNote:'',DeptAccNum:'" + $('#<%=txtDeptAccntNum.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d[0];
                        if (Result.SuccessMessage != "") {
                            var OrdNo = ('<%= Session("WOPR")%>') + ('<%= Session("WONO")%>');
                            $('#<%=RTlblError.ClientID%>').text(Result.SuccessMessage);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=RTlbl_OrderNo.ClientID%>').text(OrdNo);


                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(Result.ErrorMessage);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }



                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

        }

           function fnClientValidate() {
            if ($('#<%=ddlType.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0007', GetMultiMessage('0324', '', ''), ''));
                $('#<%=ddlType.ClientID%>')[0].focus();
                return false;
            }
            if ($('#<%=ddlStatus.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0007', GetMultiMessage('0325', '', ''), ''));
                $('#<%=ddlStatus.ClientID%>')[0].focus();
                return false;
            }

            if (($('#<%=txtFinishDate.ClientID%>')[0].value != "") &&($('#<%=txtDeliveryDate.ClientID%>')[0].value !="")) {
                var DeliveryDate = fnValidateDate($('#<%=txtDeliveryDate.ClientID%>').val(), $('#<%=hdnDateFormat.ClientID%>').val());
                var finishDate = fnValidateDate($('#<%=txtFinishDate.ClientID%>').val(), $('#<%=hdnDateFormat.ClientID%>').val());

                if (finishDate < DeliveryDate) {
                    alert(GetMultiMessage('0328', '', ''))
                    return false;
                }
            }


            if ($('#<%=txtSrchVeh.ClientID%>').val() == "") {
                if (($('#<%=txtRegNo.ClientID%>').val() != "") || ($('#<%=txtInternalNo.ClientID%>').val() != "") || ($('#<%=txtVIN.ClientID%>').val() != "")) {
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0606', '', ''));
                        $('#<%=ddlMake.ClientID%>')[0].focus();
                        return false;
                    }
                    if ($('#<%=ddlModel.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0607', '', ''));
                        $('#<%=ddlModel.ClientID%>')[0].focus();
                        return false;
                    }
                }
            }
            else {
                if (($('#<%=txtRegNo.ClientID%>').val() != "") || ($('#<%=txtInternalNo.ClientID%>').val() != "") || ($('#<%=txtVIN.ClientID%>').val() != "")) {
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0606', '', ''));
                        $('#<%=ddlMake.ClientID%>')[0].focus();
                        return false;
                    }
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0607', '', ''));
                        $('#<%=ddlModel.ClientID%>')[0].focus();
                        return false;
                    }
                }
            }

            if (!(gfi_ValidateNumDot($('#<%=txtMileage.ClientID%>')))) {

                return false;
            }
            if (!(gfi_ValidateNumDot($('#<%=txtHours.ClientID%>')))) {

                $('#<%=txtHours.ClientID%>').val('');
                $('#<%=txtHours.ClientID%>').focus();
                return false;
            }
            if (!(gfi_ValidateNumber($('#<%=txtMileage.ClientID%>'), '0262')))
                return false;
            if (!(gfi_ValidateNumber($('#<%=txtHours.ClientID%>'), 'VEHHRS')))
                return false;

            if (!(gfi_CheckEmpty($('#<%=txtName.ClientID%>'), '0265'))) {
                return false;
            }
            if (!(gfi_CheckEmptySpace($('#<%=txtName.ClientID%>'), '0265'))) {
                return false;
            }

            if ($('#<%=ddlCusGroup.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0205', '', ''));
                $('#<%=ddlCusGroup.ClientID%>')[0].focus();
                return false;
            }

           <%-- if (parseFloat($('#<%=txtMileage.ClientID%>').val()) != parseFloat(document.forms[0].HFMileage.value) || (parseFloat(document.forms[0].txtHours.value) != parseFloat(document.forms[0].HFHours.value))) {
                var con = confirm(GetMultiMessage('WO_VEHCONFIRM', '', ''));
                if (con == true) {
                    document.forms[0].hdnconfirm.value = "1"
                }
                else {
                    document.forms[0].hdnconfirm.value = "0"
                }
            }
            else {
                document.forms[0].hdnconfirm.value = "0"
            }--%>
            var UzipCode = $('#<%=txtZipCode.ClientID%>').val();
            if (UzipCode != "") {
               
                if (!(gfb_ValidateAlphabets($('#<%=txtCountry.ClientID%>'), '0192'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193'))) {
                    return false;
                }
            }

            window.scrollTo(0, 0);
            return true;
        }



        function fnClientUpdValidate() {
            if ($('#<%=ddlType.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0007', GetMultiMessage('0324', '', ''), ''));
                $('#<%=ddlType.ClientID%>')[0].focus();
                return false;
            }
            if ($('#<%=ddlStatus.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0007', GetMultiMessage('0325', '', ''), ''));
                document.forms[0].CmbStatus.focus();
                return false;
            }

            if ($('#<%=txtDeliveryTime.ClientID%>').val() != "") {

                Validatetime($('#<%=txtDeliveryTime.ClientID%>'));

            }

            if (($('#<%=txtFinishDate.ClientID%>')[0].value != "") && ($('#<%=txtDeliveryDate.ClientID%>')[0].value != "")) {
                var DeliveryDate = fnValidateDate($('#<%=txtDeliveryDate.ClientID%>').val(), $('#<%=hdnDateFormat.ClientID%>').val());
                var finishDate = fnValidateDate($('#<%=txtFinishDate.ClientID%>').val(), $('#<%=hdnDateFormat.ClientID%>').val());

                if (finishDate < DeliveryDate) {
                    alert(GetMultiMessage('0328', '', ''))
                    return false;
                }
            }

            if ($('#<%=txtSrchVeh.ClientID%>').val() == "") {
                if (($('#<%=txtRegNo.ClientID%>').val() != "") || ($('#<%=txtInternalNo.ClientID%>').val() != "") || ($('#<%=txtVIN.ClientID%>').val() != "")) {
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0606', '', ''));
                        $('#<%=ddlMake.ClientID%>')[0].focus();
                        return false;
                    }
                    if ($('#<%=ddlModel.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0607', '', ''));
                        $('#<%=ddlModel.ClientID%>')[0].focus();
                        return false;
                    }
                }
            }
            else {
                if (($('#<%=txtRegNo.ClientID%>').val() != "") || ($('#<%=txtInternalNo.ClientID%>').val() != "") || ($('#<%=txtVIN.ClientID%>').val() != "")) {
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0606', '', ''));
                        $('#<%=ddlMake.ClientID%>')[0].focus();
                        return false;
                    }
                    if ($('#<%=ddlMake.ClientID%>')[0].selectedIndex == "0") {
                        alert(GetMultiMessage('0607', '', ''));
                        $('#<%=ddlModel.ClientID%>')[0].focus();
                        return false;
                    }
                }
            }

            if (!(gfi_CheckEmpty($('#<%=txtName.ClientID%>'), '0265'))) {
                return false;
            }

            if ($('#<%=ddlCusGroup.ClientID%>')[0].selectedIndex == "0") {
                alert(GetMultiMessage('0205', '', ''));
                $('#<%=ddlCusGroup.ClientID%>')[0].focus();
                return false;
            }

            if (!(gfi_ValidateNumDot($('#<%=txtMileage.ClientID%>')))) {

                return false;
            }
            if (!(gfi_ValidateNumDot($('#<%=txtHours.ClientID%>')))) {

                $('#<%=txtHours.ClientID%>').val('');
                $('#<%=txtHours.ClientID%>').focus();
                return false;
            }
            if (!(gfi_ValidateNumber($('#<%=txtMileage.ClientID%>'), '0262')))
                return false;
            if (!(gfi_ValidateNumber($('#<%=txtHours.ClientID%>'), 'VEHHRS')))
                return false;

          


            //if ((parseFloat(document.forms[0].txtMileage.value) != parseFloat(document.forms[0].HFMileage.value)) || (parseFloat(document.forms[0].txtHours.value) != parseFloat(document.forms[0].HFHours.value))) {
            //    var con = confirm(GetMultiMessage('WO_VEHCONFIRM', '', ''));
            //    if (con == true) {
            //        document.forms[0].hdnconfirm.value = "1"
            //    }
            //    else {
            //        document.forms[0].hdnconfirm.value = "0"
            //    }

            //}
            //else {
            //    document.forms[0].hdnconfirm.value = "0"
            //}

            var UzipCode = $('#<%=txtZipCode.ClientID%>').val();
            if (UzipCode != "") {

                if (!(gfb_ValidateAlphabets($('#<%=txtCountry.ClientID%>'), '0192'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193'))) {
                    return false;
                }
            }


            if (UzipCode != "") {
                if (document.forms[0].hdnNewZip.value == 0) {
                    if (document.forms[0].txtCountry.value.length == 0 && document.forms[0].txtState.value.length == 0) {
                        if (confirm(GetMultiMessage('ZIPCONFIRM', '', '')) == 1) {
                            $('#<%=hdnConfigZipSave.ClientID%>').val("1");
                        }
                        else {
                            $('#<%=hdnConfigZipSave.ClientID%>').val("0");
                        }
                    }
                }
            }

            //if (UzipCode.value == UzipCode.defaultValue) {
            //    if (document.forms[0].txtCountry.value != document.forms[0].txtCountry.defaultValue ||
            //    document.forms[0].txtState.value != document.forms[0].txtState.defaultValue) {
            //        if (confirm(GetMultiMessage('ZIPUPDATE', '', '')) == 1) {
            //            document.forms[0].txtCountry.value = document.forms[0].txtCountry.value;
            //            document.forms[0].txtState.value = document.forms[0].txtState.value;
            //        }
            //        else {
            //            document.forms[0].txtCountry.value = document.forms[0].txtCountry.defaultValue;
            //            document.forms[0].txtState.value = document.forms[0].txtState.defaultValue;
            //        }
            //    }
            //}

            //var stay = confirm(GetMultiMessage('0331', '', ''));
            //if (stay == false) {
            //    return false;
            //}


            window.scrollTo(0, 0);
        }

        function redirectJobDet(id_job, WoNo, WoPr, VAmode) {
        window.location.href = 'frmWOJobDetails.aspx?epjid=' + id_job + '&Wonumber=' + WoNo + '&WOPrefix=' + WoPr + '&VAMode=' + VAmode + '&Mode=View' + '&TabId=3'
        }

        function AddJob()
           {
           var WoNo = '<%= Session("WONO")%>';
            var WoPr = '<%= Session("WOPR")%>';
            var idJob = $('#<%=txtJobNo.ClientID%>').val();
            var bool = chkCreditLimit_Customer();
            if (bool == true && idJob !="")
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOHead.aspx/checkJobNo",
                    data: "{'WoNo':'" + WoNo + "',WoPr:'" + WoPr + "',IdJob:'" + idJob + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        strValue = data.d.toString();
                        if (strValue=="False")
                        {
                            window.location.href = 'frmWOJobDetails.aspx?TabId=3&Name=' + $('#<%=txtName.ClientID%>').val() + '&Mode=Add';

                        }                        
                    }
                });
            }
            else
            {
                window.location.href = 'frmWOJobDetails.aspx?TabId=3&Name=' + $('#<%=txtName.ClientID%>').val() + '&Mode=Add';
            }
        }
        function fnunload()
        {
    
   
            var btnSaveOrder = document.getElementById("<%= btnSaveOrder.ClientID %>");
           var btnUpdate = document.getElementById("<%= btnUpdate.ClientID %>");
           //document.getElementById("hdnWono").value =  document.getElementById('lbl_h_ordno').innerHTML;
           //document.getElementById("hdnPrefix").value =  document.getElementById('lbl_h_prefix').innerHTML;
           //var myvar = document.getElementById("hdnWono").value ;
    
           //PageMethods.SetValue(myvar);
           if(btnSaveOrder == null && !btnUpdate.disabled)
           {
               if (document.forms[0].RTlblHFDefStat.value == "True")
               {
                   var res; 
                   var msg=GetMultiMessage('0242','','');
                   res = confirm(msg); 
                   return res;
               }
               else if(!(ChkFormDataChange(document.forms["frmWOHead"])))
               {
                   return false;
               }
           }
           else if(btnUpdate == null && !btnSaveOrder.disabled)
           {
               if (document.forms[0].RTlblHFDefStat.value == "True")
               {
                   var res; 
                   var msg=GetMultiMessage('0242','','');
                   res = confirm(msg); 
                   return res;
               }
               else if(!(ChkFormDataChange(document.forms["frmWOHead"])))
               {
                   return false;
               }
           }
        }
        </script>
     <div class="header1 two fields" >
        <asp:Label ID="lblHead" runat="server" Text="Work Order Details" ></asp:Label>
        <asp:Label ID="Label1" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
        <asp:HiddenField ID="hdnVAMode" runat="server" />
        <asp:HiddenField ID="hdnViewCap" runat="server" Value="View" />
        <asp:HiddenField ID="hdnWoNo" runat="server" />
        <asp:HiddenField ID="hdnWoPr" runat="server" />
        <asp:HiddenField ID="hdnVehGrpDesc" runat="server" />
        <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
        <asp:HiddenField ID="hdnDateFormatLang" Value="<%$ appSettings:DateFormatLang %>" runat="server"/>
        <asp:HiddenField ID="hdnConfigZipSave" runat="server" Value="1" />
        <asp:HiddenField ID="hdnNewZip" runat="server" />
         
       
    </div>
    <div>
        <uc3:ucWOMenutabs ID="UcWOMenutabs1" runat="server" />
    </div>
     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
         <a class="active item" runat="server" id="aAddrComm" style="background-color:transparent ">Order Head Details</a>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     </div>
      <div class="ui form" style="width:100%">
            <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                     <asp:Label ID="lbl_Order" runat="server" Text="Order Series"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                         <asp:Label ID="RTlbl_OrderNo" runat="server" Width="123px"></asp:Label>
                    </div>
                   <div class="field" style="padding-left:1em;width:147px">
                   </div>
                   <div class="field" style="width:200px">
                   </div>
                                     
                </div>
            <div class="six fields lbl" >
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblOrdDate" runat="server" Text="Order Date"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:Label ID="RTlblOrderDate" runat="server" Width="93px"></asp:Label>
                    </div>
                   <div class="field" style="padding-left:1em;width:147px">
                        <asp:Label ID="lblType" runat="server" Text="Type"></asp:Label><span class="mand">*</span>
                   </div>
                   <div class="field" style="width:200px">
                        <asp:DropDownList ID="ddlType" runat="server" Width="120px" class="dropdowns"></asp:DropDownList>
                   </div>
                 <div class="field" style="padding-left:1em;width:147px">
                       <asp:Label ID="lblStatus" runat="server" Text="Status"></asp:Label><span class="mand">*</span>
                   </div>
                   <div class="field" style="width:200px">
                        <asp:DropDownList ID="ddlStatus" runat="server" Width="180px" class="dropdowns"></asp:DropDownList>
                   </div>
                                     
                </div>
           <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDeliveryDate" runat="server" Text="Delivery Date"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtDeliveryDate" runat="server"  Width="140px" MaxLength="25" Columns="50"></asp:TextBox>
                    </div>
                   <div class="field" style="padding-left:1em;width:147px">
                        <asp:Label ID="lblDeliveryTime" runat="server" Text="Delivery Time"></asp:Label>
                   </div>
                   <div class="field" style="width:200px">
                        <asp:TextBox ID="txtDeliveryTime" runat="server" Columns="50"  MaxLength="25" Width="120px"></asp:TextBox>
                   </div>
                 <div class="field" style="padding-left:1em;width:147px">
                      <asp:Label ID="lblFinishDate" runat="server" Text="Finish Date"></asp:Label>
                   </div>
                   <div class="field" style="width:200px">
                       <asp:TextBox ID="txtFinishDate" runat="server" Columns="50"  MaxLength="25" Width="140px"></asp:TextBox>
                   </div>
                                     
                </div>
          <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                     <asp:Label ID="lblAnnotation" runat="server" Text="Annotation"></asp:Label>
                    </div>
                    <div class="field">
                        <asp:TextBox ID="TxtAnnotation" runat="server"  MaxLength="50" TextMode="MultiLine" Height="45px"></asp:TextBox>
                    </div>
                </div>
           <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDeptAccntNum" runat="server" Text="Department Account Number"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                        <asp:TextBox ID="txtDeptAccntNum" runat="server"  MaxLength="50" Width="140px"></asp:TextBox>
                    </div>
             </div>
          
      </div>

     <div class="ui page grid" style="padding-left:0%;padding-right:0%;margin-top:10px">
          <div class="two column row">
            <div class="column" style="padding-left:0em;width:40%">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item">
                 <div class="ui form" style="width:100%">
                    <div class="four fields">
                        <div class="field" style="width:70%">Vehicle Details</div>
                         <div id="VehMoreInfo" class="field" runat="server" style="width:30%;text-decoration:underline">More Information</div>
                    </div>
                </div>
                </a>
            </div>
               
                 <div class="ui form" style="width:90%">
                    <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                        <asp:Label ID="lblVehicle" runat="server" Text="Search vehicle"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                      <div class="ui action input mini">
                        <asp:TextBox ID="txtSrchVeh" CssClass="inp" runat="server" Width="330px" ></asp:TextBox>
                    </div>
                     <%-- <asp:DropDownList ID="ddlVeh" runat="server" Width="300px"></asp:DropDownList>--%>
                     <asp:ListBox ID="lst_veh" runat="server" Width="289px" ></asp:ListBox>
                   </div>
                 </div>
                 <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblRegNo" runat="server" Text="Reg.No"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtRegNo"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblInternalNo" runat="server" Text="Internal No"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtInternalNo"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblVin" runat="server" Text="VIN"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtVIN"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
             <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblMake" runat="server" Text="Make"></asp:Label><span class="mand">*</span>
                 </div>
                 <div class="field" style="width:250px">
                          <asp:DropDownList ID="ddlMake" runat="server" class="dropdowns" >
                        </asp:DropDownList>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblModel" runat="server" Text="Model"></asp:Label><span class="mand">*</span>
                 </div>
                 <div class="field" style="width:250px">
                          <asp:DropDownList ID="ddlModel" runat="server" class="dropdowns">
                        </asp:DropDownList>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblVehMileage" runat="server" Text="Mileage"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                         <asp:TextBox ID="txtMileage"  runat="server"></asp:TextBox>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblVehHours" runat="server" Text="Hours"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                         <asp:TextBox ID="txtHours"  runat="server"></asp:TextBox>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblCostPrice" runat="server" Text="Cost Price" Visible="false"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                         <asp:TextBox ID="txtCostPrice"  runat="server" Visible="false" ></asp:TextBox>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblSellPrice" runat="server" Text="Selling Price" Visible="false"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                         <asp:TextBox ID="txtSellPrice"  runat="server" Visible="false" ></asp:TextBox>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblVANum" runat="server" Text="VA Number"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                         <asp:TextBox ID="txtVANum"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
            <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:HyperLink ID="lnkDefect" runat="server"  NavigateUrl="javascript:openDefect()">Defect Note</asp:HyperLink>
                 </div>
              
             </div>
               </div>
            </div>
            <div class="column" style="width:50%">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item">
                 <div class="ui form" style="width:100%">
                    <div class="four fields">
                        <div class="field" style="width:70%">Customer Details</div>
                        <div id="CustMoreInfo" class="field" runat="server" style="width:30%;text-decoration:underline">More Information</div>
                    </div>
                </div>
                </a>
            </div>
                  <div class="ui form" style="width:100%">
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblCustomer" runat="server" Text="Search customer"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                    <div class="ui action input mini">
                       <asp:TextBox ID="txtSrchCust" CssClass="inp" runat="server" Width="300px" ></asp:TextBox>
                     </div>
                   </div>
                 </div>
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblName" runat="server" Text="Name"></asp:Label><span class="mand">*</span>
                 </div>
                 <div class="field" style="width:250px">
                       <asp:TextBox ID="txtName"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblPaymentType" runat="server" Text="Payment Type" ></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="ddlPayType" runat="server" class="dropdowns">
                        </asp:DropDownList>
                   </div>
                 </div>
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblPaymentTerms" runat="server" Text="Payment Terms"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="ddlPayTerms" runat="server" class="dropdowns">
                        </asp:DropDownList>
                   </div>
                 </div>

                 <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblCusGroup" runat="server" Text="Group"></asp:Label><span class="mand">*</span>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:DropDownList ID="ddlCusGroup" runat="server" class="dropdowns">
                        </asp:DropDownList>
                   </div>
                 </div>

                  <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblAddress1" runat="server" Text="Address1"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtAddress1"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
                  <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblAddress2" runat="server" Text="Adress2"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtAddress2"  runat="server" ></asp:TextBox>
                   </div>
                 </div>

                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblZipcode" runat="server" Text="ZipCode"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtZipCode"  runat="server"></asp:TextBox>
                   </div>
                 </div>
                 <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblState" runat="server" Text="State"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtState"  runat="server" ></asp:TextBox>
                   </div>
                 </div>
                 <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblCountry" runat="server" Text="Country"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtCountry"  runat="server" ></asp:TextBox>
                   </div>
                 </div>

                  <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblPhHome" runat="server" Text="Phone 1"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtHPhoneNo"  runat="server" ></asp:TextBox>
                   </div>
                 </div>

                  <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblPhOff" runat="server" Text="Phone 2"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtOPhoneNo"  runat="server"></asp:TextBox>
                   </div>
                 </div>
               
                <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:200px">
                         <asp:Label ID="lblMobNo" runat="server" Text="Mobile Phone"></asp:Label>
                 </div>
                 <div class="field" style="width:250px">
                        <asp:TextBox ID="txtMobNo"  runat="server"></asp:TextBox>
                   </div>
                 </div>

                 <div class="four fields lbl">
                <div class="field" style="padding-left:0.55em;width:50px;text-decoration:underline">
                        <asp:LinkButton ID="lnkEmail" runat="server">E-Mail</asp:LinkButton>
                 </div>
                 <div class="field" style="width:270px;text-decoration:underline">
                        <asp:LinkButton ID="lnkLog" runat="server">SMS</asp:LinkButton>
                   </div>
                <div class="field" style="text-decoration:underline">
                        <asp:LinkButton ID="LinkButton1" runat="server">SMS/E-Mail Log</asp:LinkButton>
                   </div>
                 </div>

                 </div>
            </div>
        </div>
       </div>  
    <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
         <a class="active item" runat="server" id="aOrderJobs">Order Jobs</a>
       <table id="dgdOrderJobs" title="Order Details" style="width: 90%;"></table>
       <div id="pagerOrderJobs"></div>
     </div>
       <div id="divJob" style="text-align:center">
                    <asp:TextBox ID="txtJobNo"  runat="server" style=" color: rgba(0, 0, 0, 0.85);border-color: rgba(39, 41, 43, 0.3);border-radius: 0em 0.2857rem 0.2857rem 0em;background: #ffffff; box-shadow: inset 1px 0em 0em 0em rgba(39,41,43,0.3);width:140px"  ></asp:TextBox>
                    <input id="btnAddJob" runat="server" class="ui button"  value="Add Job" type="button" onclick="AddJob()" />
                    <input id="btnDeleteJob" runat="server" class="ui button" value="Delete Job" type="button"  style="background-color: #E0E0E0"  />
                   
           </div>   
    <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1">
         <a class="active item" runat="server" id="aMechanicDet">Mechanic Details</a>
     </div>
    <table id="dgdOrdMechanic" title="Mechanic Details" style="width:100%" ></table>
       <div id="pagerOrdMechanic"></div>
          <div style="text-align:center">
                    <input id="btnSaveOrder" runat="server" class="ui button"  value="Save" type="button" onclick="SaveOrder()" />
                    <input id="btnCancel" runat="server" class="ui button" value="Cancel" type="button" style="background-color: #E0E0E0"   />
                    <input id="btnUpdate" runat="server" class="ui button"  value="Update" type="button" onclick="UpdateOrder()" />
                    <input id="btnReport" runat="server" class="ui button"  value="Print Job Card" type="button" />
                    <input id="btnProposal" runat="server" class="ui button" value="Proposal" type="button"  />
                    <input id="btnConfirmation" runat="server" class="ui button"  value="Confirmation" type="button" />
                    <input id="btnPickingList" runat="server" class="ui button" value="Picking List" type="button"   />
                    <input id="btnUpdOrdStatus" runat="server" class="ui button"  value="Update Status" type="button" Visible="false" />
           </div> 
         <asp:Label ID="lbl_h_ordno" runat="server" Text="Label" style="display:none"></asp:Label>
         <asp:Label ID="lbl_h_prefix" runat="server" Text="Label" style="display:none"></asp:Label>
         <asp:HiddenField ID="hdnScrName" runat="server" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
    </asp:Content>
