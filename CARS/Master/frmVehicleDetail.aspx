<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmVehicleDetail.aspx.vb" Inherits="CARS.frmVehicleDetail" MasterPageFile="~/MasterPage.Master" meta:resourcekey="PageResource1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    <style type="text/css">
        .ui-jqgrid-disablePointerEvents {
            pointer-events: none;
        }
        .ui-jqgrid tr.ui-row-ltr td {
            text-align: center;
        }
        .context-menu-list {
            z-index: 10;
        }
        .ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus {
            border: 1px solid #999999;
            font-weight: normal;
            color: #212121;
            background-color: white;
        }

        /*added for dialog close button*/
        .ui-dialog .ui-dialog-titlebar-close span {
            display: block;
            margin-bottom: 0px;
            padding: 0px;
            margin-left: -9px;
            margin-top: -9px;
        }

        .ui-dialog .ui-dialog-titlebar button.ui-button:focus,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-focus,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-active,
        .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-hover {
            outline: none;
        }

    </style>

    <script type="text/javascript">

        /* 
            saveCustomer() :
            Function that was previously called by a "save" button.
            This button now instead shows more information of customer when clicked
            So this function is no longer being called by this button, and perhaps its not used at all?
            Lets just keep it for now
            -Koenraad
        */
        function saveCustomer() {
            var customer = {};
            $('[data-submit]').each(function (index, elem) {
                var st = $(elem).data('submit');
                var dv = $(elem).val();
                console.log(index + ' i was runned ' + st + 'and has the value of ' + dv);
                customer[st] = dv;
            });
            console.log(customer);
            console.log(customer.CUST_FIRST_NAME);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCustomerDetail.aspx/InsertCustomerDetails",
                data: "{'Customer': '" + JSON.stringify(customer) + "'}",
                dataType: "json",
                //async: false,//Very important
                success: function (data) {
                    console.log('success' + data.d);
                },
                success: function (data) {
                    if (data.d == "INSFLG") {
                        systemMSG('success', 'Kunden har blitt lagret!', 4000);
                    }
                    else if (data.d == "UPDFLG") {
                        systemMSG('success', 'Kunden har blitt oppdatert!', 4000);
                    }
                    else if (data.d == "ERRFLG") {
                        systemMSG('error', 'Det oppstod en feil ved lagring av kunde! Sjekk inndata!', 4000);
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                }
            });
        }

        function FetchCustomerDetails() {

            $.ajax({
                type: "POST",
                url: "frmCustomerDetail.aspx/FetchCustomerDetails",
                data: "{custId: '" + $('#<%=txtCustNo.ClientID()%>').val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    $('#<%=txtCustAdd1.ClientID()%>').val(data.d[0].CUST_PERM_ADD1);
                    $('#<%=txtCustVisitZip.ClientID()%>').val(data.d[0].ID_CUST_PERM_ZIPCODE);
                    $('#<%=txtCustVisitPlace.ClientID()%>').val(data.d[0].CUST_PERM_CITY);
                    $('#<%=txtCustBillAdd.ClientID()%>').val(data.d[0].CUST_BILL_ADD1);
                    $('#<%=txtCustBillZip.ClientID()%>').val(data.d[0].ID_CUST_BILL_ZIPCODE);
                    $('#<%=txtCustBillPlace.ClientID()%>').val(data.d[0].CUST_BILL_CITY);
                    $('#<%=txtCustMail.ClientID()%>').val(data.d[0].CUST_ID_EMAIL);
                    $('#<%=txtCustFirstName.ClientID()%>').val(data.d[0].CUST_FIRST_NAME);
                    $('#<%=txtCustMiddleName.ClientID()%>').val(data.d[0].CUST_MIDDLE_NAME);
                    $('#<%=txtCustLastName.ClientID()%>').val(data.d[0].CUST_LAST_NAME);
                    $('#<%=txtCustOrgNo.ClientID()%>').val(data.d[0].CUST_SSN_NO);
                    $('#<%=txtCustPersonNo.ClientID()%>').val(data.d[0].CUST_BORN);
                    

                    //CUST_PHONE_ALT	txtPhoneSwitchboard	txtCustSwitchboard	txtprivCustAltPhone
                    //CUST_PHONE_MOBILE	txtPhoneMobile	txtCustMobile	txtprivCustMobile
                    //CUST_FAX	txtPhoneFax	txtCustFax	txtprivCustFax
                    //CUST_PHONE_OFF	txtPhoneDirect	txtCustDirect	txtprivCustDirect
                    //CUST_PHONE_HOME	txtPhonePrivate	txtCustPrivate	txtprivCustPrivate
                    //CUST_ID_EMAIL	txtPhoneEmail	txtCustEmail	txtprivCustEmail
                    //CUST_INV_EMAIL	txtPhoneInvEmail	txtCustInvEmail	txtprivCustInvEmail
                    //CUST_HOMEPAGE	txtPhoneHomepage	txtCustHomepage	
                },
                failure: function () {
                    alert("Failed!");
                }
            });

        };
                  

        $(document).ready(function () {


            function FetchVehicleDetails(regNo, refNo, vehId, type) {
                console.log('fetchvehicle');
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/FetchVehicleDetails",
                    data: "{'refNo':'" + refNo + "', 'regNo':'" + regNo + "', 'vehId':'" + vehId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (data) {
                        if (data.d.length != 0) {
                            console.log('Success response');
                            var r;
                            if (type != "load") {
                                r = confirm(GetMultiMessage('VEH_EXISTS', '', ''));
                            }
                            else {
                                r = true;
                            }

                            if (r == true) {
                                var vehModel = data.d[0].Model;
                                var vehType = data.d[0].VehType;
                                
                                $('#<%=drpMakeCodes.ClientID%>').val(data.d[0].MakeCodeNo);
                                if ($('#<%=txtRegNoCreate.ClientID%>').val() != "") {
                                    $('#<%=txtRegNo.ClientID%>').val($('#<%=txtRegNoCreate.ClientID%>').val())
                                }
                                if (type === "load") { // RegNo usually fetched from popup, needs to be fetched from db on load. This might have to be changed to default in order to prevent data missmatch.
                                    $('#<%=txtRegNo.ClientID%>').val(data.d[0].VehRegNo);
                                }
                                $('#<%=ddlVehType.ClientID%> ').val(data.d[0].New_Used);
                                $('#<%=ddlVehStatus.ClientID%>').val(data.d[0].VehStatus);
                                $('#<%=txtGeneralMake.ClientID%>').val(data.d[0].Make);
                                $('#<%=cmbModelForm.ClientID%>').val(data.d[0].Model);
                                $('#<%=ddlVatCode.ClientID%>').val(data.d[0].vatCode);
                                console.log(data.d[0].vatCode);
                               
                                $('#<%=txtVehicleType.ClientID%>').val(data.d[0].VehType);
                                $('#<%=txtRegDate.ClientID%>').val(data.d[0].RegDate);
                                $('#<%=txtDeregDate.ClientID%>').val(data.d[0].DeRegDate);
                                $('#<%=txtTotWeight.ClientID%>').val(data.d[0].TotalWeight);
                                $('#<%=txtNetWeight.ClientID%>').val(data.d[0].NetWeight);
                                $('#<%=txtRegDateNorway.ClientID%>').val(data.d[0].RegDateNorway);
                                $('#<%=txtLastRegDate.ClientID%>').val(data.d[0].LastRegDate);
                                $('#<%=txtRegyr.ClientID%>').val(data.d[0].RegYear);
                                $('#<%=txtModelyr.ClientID%>').val(data.d[0].ModelYear);
                                $('#<%=txtColor.ClientID%>').val(data.d[0].Color);
                                $('#<%=txtTechVin.ClientID%>').val(data.d[0].VehVin);
                                $('#<%=txtVinNo.ClientID%>').val(data.d[0].VehVin);
                                $('#<%=txtType.ClientID%>').val(data.d[0].ModelType);
                                $('#<%=txtMaxRoofLoad.ClientID%>').val(data.d[0].Max_Rf_Load);
                                $('#<%=txtIntNo.ClientID%>').val(data.d[0].IntNo);
                                $('#<%=txtCategory.ClientID%>').val(data.d[0].Category);
                                $('#<%=txtGeneralAnnotation.ClientID%>').val(data.d[0].Annotation);
                                if (data.d[0].Annotation != "") {
                                    $('#<%=btnAddAnnotation.ClientID%>').addClass('warningAN');
                                }
                                else {
                                    $('#<%=btnAddAnnotation.ClientID%>').removeClass('warningAN');
                                }
                                $('#<%=txtGeneralNote.ClientID%>').val(data.d[0].Note);
                                if (data.d[0].Note != "") {
                                    $('#<%=btnAddNote.ClientID%>').addClass('warningAN');
                                }
                                else {
                                    $('#<%=btnAddNote.ClientID%>').removeClass('warningAN');
                                }
                                $('#<%=drpWarrantyCode.ClientID%>').val(data.d[0].Warranty_Code);
                                $('#<%=txtProjectNo.ClientID%>').val(data.d[0].Project_No);
                                $('#<%=txtLastContactDate.ClientID%>').val(data.d[0].Last_Contact_Date);
                                $('#<%=txtPracticalLoad.ClientID%>').val(data.d[0].Practical_Load);
                                $('#<%=txtEarlyRegNo1.ClientID%>').val(data.d[0].Earlier_Regno_1);
                                $('#<%=txtEarlyRegNo2.ClientID%>').val(data.d[0].Earlier_Regno_2);
                                $('#<%=txtEarlyRegNo3.ClientID%>').val(data.d[0].Earlier_Regno_3);
                                $('#<%=txtEarlyRegNo4.ClientID%>').val(data.d[0].Earlier_Regno_4);
                                $('#<%=txtTechVehGrp.ClientID%>').val(data.d[0].VehGrp);
                                $('#<%=txtMileage.ClientID%>').val(data.d[0].Mileage);
                                $('#<%=txtMileageDate.ClientID%>').val(data.d[0].MileageRegDate);
                                $('#<%=txtHours.ClientID%>').val(data.d[0].VehicleHrs);
                                $('#<%=txtHoursDate.ClientID%>').val(data.d[0].VehicleHrsDate);
                                if (data.d[0].Machine_W_Hrs == 0) {
                                    $("#<%=cbMachineHours.ClientID%>").attr('checked', false);
                                    $('#<%=lblMileage.ClientID%>').show();
                                    $('#<%=txtMileage.ClientID%>').show();
                                    $('#<%=lblMileageDate.ClientID%>').show();
                                    $('#<%=txtMileageDate.ClientID%>').show();
                                    $('#<%=lblHours.ClientID%>').hide();
                                    $('#<%=txtHours.ClientID%>').hide();
                                    $('#<%=lblHoursDate.ClientID%>').hide();
                                    $('#<%=txtHoursDate.ClientID%>').hide();
                                }
                                else {
                                    $("#<%=cbMachineHours.ClientID%>").attr('checked', true);
                                    $('#<%=lblMileage.ClientID%>').hide();
                                    $('#<%=txtMileage.ClientID%>').hide();
                                    $('#<%=lblMileageDate.ClientID%>').hide();
                                    $('#<%=txtMileageDate.ClientID%>').hide();
                                    $('#<%=lblHours.ClientID%>').show();
                                    $('#<%=txtHours.ClientID%>').show();
                                    $('#<%=lblHoursDate.ClientID%>').show();
                                    $('#<%=txtHoursDate.ClientID%>').show();
                                }
                                $('#<%=txtTechPick.ClientID%>').val(data.d[0].PickNo);
                                $('#<%=txtTechMake.ClientID%>').val(data.d[0].MakeCodeNo);
                                $('#<%=txtTechRicambiNo.ClientID%>').val(data.d[0].RicambiNo);
                                $('#<%=txtTechEngineNo.ClientID%>').val(data.d[0].EngineNum);
                                $('#<%=txtTechFuelCode.ClientID%>').val(data.d[0].FuelCode);
                                if (data.d[0].FuelCode == "1") {
                                    $('#<%=txtTechFuelName.ClientID%>').val("Bensin");
                                }
                                if (data.d[0].FuelCode == "2") {
                                    $('#<%=txtTechFuelName.ClientID%>').val("Diesel");
                                }
                                $('#<%=txtTechFuelCard.ClientID%>').val(data.d[0].FuelCard);
                                $('#<%=txtTechGearBox.ClientID%>').val(data.d[0].GearBox_Desc);
                                $('#<%=txtTechWarehouse.ClientID%>').val(data.d[0].WareHouse);
                                $('#<%=txtTechKeyNo.ClientID%>').val(data.d[0].KeyNo);
                                $('#<%=txtTechDoorKeyNo.ClientID%>').val(data.d[0].DoorKeyNo);
                                $('#<%=txtTechControlForm.ClientID%>').val(data.d[0].ControlForm);
                                $('#<%=txtTechInteriorCode.ClientID%>').val(data.d[0].InteriorCode);
                                $('#<%=txtTechPurchaseNo.ClientID%>').val(data.d[0].PurchaseNo);
                                $('#<%=txtTechAddonGrp.ClientID%>').val(data.d[0].AddonGroup);
                                $('#<%=txtTechDateExpectedIn.ClientID%>').val(data.d[0].Date_Expected_In);
                                $('#<%=txtTechTireInfo.ClientID%>').val(data.d[0].Tires);
                                $('#<%=txtTechServiceCategory.ClientID%>').val(data.d[0].Service_Category);
                                $('#<%=txtTechApprovalNo.ClientID%>').val(data.d[0].No_Approval_No);
                                $('#<%=txtTechEUApprovalNo.ClientID%>').val(data.d[0].Eu_Approval_No);
                                $('#<%=txtTechProductNo.ClientID%>').val(data.d[0].ProductNo);
                                $('#<%=txtTechElCode.ClientID%>').val(data.d[0].ElCode);
                                $('#<%=txtTechTakenInDate.ClientID%>').val(data.d[0].Taken_In_Date);
                                $('#<%=txtTechMileageTakenIn.ClientID%>').val(data.d[0].Taken_In_Mileage);
                                $('#<%=txtTechDeliveryDate.ClientID%>').val(data.d[0].Delivery_Date);
                                $('#<%=txtTechMileageDelivered.ClientID%>').val(data.d[0].Delivery_Mileage);
                                $('#<%=txtTechServiceDate.ClientID%>').val(data.d[0].Service_Date);
                                $('#<%=txtTechMileageService.ClientID%>').val(data.d[0].Service_Mileage);
                                $('#<%=txtTechCallInDate.ClientID%>').val(data.d[0].Call_In_Date);
                                $('#<%=txtTechMileageCallIn.ClientID%>').val(data.d[0].Call_In_Mileage);
                                $('#<%=txtTechCleanedDate.ClientID%>').val(data.d[0].Cleaned_Date);
                                $('#<%=txtTechTechdocNo.ClientID%>').val(data.d[0].TechDocNo);
                                $('#<%=txtTechLength.ClientID%>').val(data.d[0].Length);
                                $('#<%=txtTechWidth.ClientID%>').val(data.d[0].Width);
                                $('#<%=txtTechNoise.ClientID%>').val(data.d[0].Noise_On_Veh);
                                $('#<%=txtTechEffect.ClientID%>').val(data.d[0].EngineEff);
                                $('#<%=txtTechPistonDisp.ClientID%>').val(data.d[0].PisDisplacement);
                                $('#<%=txtTechRoundperMin.ClientID%>').val(data.d[0].Rounds);

                                if (data.d[0].Used_Imported == 0) {
                                    $("#<%=cbTechUsedImported.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechUsedImported.ClientID%>").prop('checked', true);
                                }
                                if (data.d[0].Pressure_Mech_Brakes == 0) {
                                    $("#<%=cbTechPressureMechBrakes.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechPressureMechBrakes.ClientID%>").prop('checked', true);
                                }
                                if (data.d[0].Towbar == 0) {
                                    $("#<%=cbTechTowbar.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechTowbar.ClientID%>").prop('checked', true);
                                }
                                if (data.d[0].Service_Book == 0) {
                                    $("#<%=cbTechServiceBook.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechServiceBook.ClientID%>").prop('checked', true);
                                }
                                $('#<%=txtTechLastPkkOk.ClientID%>').val(data.d[0].LastPKK_AppDate);
                                $('#<%=txtTechNextPkk.ClientID%>').val(data.d[0].NxtPKK_Date);
                                $('#<%=txtTechLastInvoicedPkk.ClientID%>').val(data.d[0].Last_PKK_Invoiced);
                                if (data.d[0].Call_In_Service == 0) {
                                    $("#<%=cbTechCallInService.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechCallInService.ClientID%>").prop('checked', true);
                                }
                                $('#<%=txtTechCallInMonth.ClientID%>').val(data.d[0].Call_In_Month_Service);
                                $('#<%=txtTechMileage.ClientID%>').val(data.d[0].Call_In_Mileage_Service);
                                if (data.d[0].Do_Not_Call_PKK == 0) {
                                    $("#<%=cbTechDoNotCallPkk.ClientID%>").prop('checked', false);
                                }
                                else {
                                    $("#<%=cbTechDoNotCallPkk.ClientID%>").prop('checked', true);
                                }
                                $('#<%=txtTechDeviationsPkk.ClientID%>').val(data.d[0].Deviations_PKK);
                                $('#<%=txtTechYearlyMileage.ClientID%>').val(data.d[0].Yearly_Mileage);
                                $('#<%=txtTechRadioCode.ClientID%>').val(data.d[0].Radio_Code);
                                $('#<%=txtTechStartImmobilizer.ClientID%>').val(data.d[0].Start_Immobilizer);
                                $('#<%=txtTechQtyKeys.ClientID%>').val(data.d[0].Qty_Keys);
                                $('#<%=txtTechKeyTag.ClientID%>').val(data.d[0].KeyTagNo);
                                //tabeconomy
                                $('#<%=txtEcoSalespriceNet.ClientID%>').val(data.d[0].SalesPriceNet);
                                $('#<%=txtEcoSalesSale.ClientID%>').val(data.d[0].SalesSale);
                                $('#<%=txtEcoSalesEquipment.ClientID%>').val(data.d[0].SalesEquipment);
                                $('#<%=txtEcoRegCost.ClientID%>').val(data.d[0].RegCosts);
                                $('#<%=txtEcoDiscount.ClientID%>').val(data.d[0].Discount);
                                $('#<%=txtEcoNetSalesPrice.ClientID%>').val(data.d[0].NetSalesPrice);
                                $('#<%=txtEcoFixCost.ClientID%>').val(data.d[0].FixCost);
                                $('#<%=txtEcoAssistSales.ClientID%>').val(data.d[0].AssistSales);
                                $('#<%=txtEcoCostAfterSale.ClientID%>').val(data.d[0].CostAfterSales);
                                $('#<%=txtEcoContributionsToday.ClientID%>').val(data.d[0].ContributionsToday);
                                $('#<%=txtEcoSalesPriceGross.ClientID%>').val(data.d[0].SalesPriceGross);
                                $('#<%=txtEcoRegFee.ClientID%>').val(data.d[0].RegFee);
                                $('#<%=txtEcoVat.ClientID%>').val(data.d[0].Vat);
                                $('#<%=txtEcoVehTotAmount.ClientID%>').val(data.d[0].TotAmount);
                                $('#<%=txtEcoWreckingAmount.ClientID%>').val(data.d[0].WreckingAmount);
                                $('#<%=txtEcoYearlyFee.ClientID%>').val(data.d[0].YearlyFee);
                                $('#<%=txtEcoInsurance.ClientID%>').val(data.d[0].Insurance);
                                $('#<%=txtEcoCostPriceNet.ClientID%>').val(data.d[0].CostPriceNet);
                                $('#<%=txtEcoInsuranceBonus.ClientID%>').val(data.d[0].InsuranceBonus);
                                $('#<%=txtEcoInntakeSaler.ClientID%>').val(data.d[0].CostSales);
                                $('#<%=txtEcoCostBeforeSale.ClientID%>').val(data.d[0].CostBeforeSale);
                                $('#<%=txtEcoSalesProvision.ClientID%>').val(data.d[0].SalesProvision);
                                $('#<%=txtEcoCommitDay.ClientID%>').val(data.d[0].CommitDay);
                                $('#<%=txtEcoAddedInterests.ClientID%>').val(data.d[0].AddedInterests);
                                $('#<%=txtEcoCostEquipment.ClientID%>').val(data.d[0].CostEquipment);
                                $('#<%=txtEcoTotalCost.ClientID%>').val(data.d[0].TotalCost);
                                $('#<%=txtEcoCreditNote.ClientID%>').val(data.d[0].CreditNoteNo);
                                $('#<%=txtEcoCreditDate.ClientID%>').val(data.d[0].CreditNoteDate);
                                $('#<%=txtEcoInvoiceNo.ClientID%>').val(data.d[0].InvoiceNo);
                                $('#<%=txtEcoInvoiceDate.ClientID%>').val(data.d[0].InvoiceDate);
                                $('#<%=txtEcoRebuy.ClientID%>').val(data.d[0].RebuyDate);
                                $('#<%=txtEcoRebuyPrice.ClientID%>').val(data.d[0].RebuyPrice);
                                $('#<%=txtEcoCostKm.ClientID%>').val(data.d[0].CostPerKm);
                                $('#<%=txtEcoTurnover.ClientID%>').val(data.d[0].Turnover);
                                $('#<%=txtEcoProgress.ClientID%>').val(data.d[0].Progress);
                                //tabCustomer
                                $('#<%=txtCustNo.ClientID%>').val(data.d[0].Customer);
                                if (data.d[0].Customer != '') {
                                    FetchCustomerDetails();
                                }
                                //tabtrailer
                                $('#<%=txtTraAxle1.ClientID%>').val(data.d[0].Axle1);
                                $('#<%=txtTraAxle2.ClientID%>').val(data.d[0].Axle2);
                                $('#<%=txtTraAxle3.ClientID%>').val(data.d[0].Axle3);
                                $('#<%=txtTraAxle4.ClientID%>').val(data.d[0].Axle4);
                                $('#<%=txtTraAxle5.ClientID%>').val(data.d[0].Axle5);
                                $('#<%=txtTraAxle6.ClientID%>').val(data.d[0].Axle6);
                                $('#<%=txtTraAxle7.ClientID%>').val(data.d[0].Axle7);
                                $('#<%=txtTraAxle8.ClientID%>').val(data.d[0].Axle8);
                                $('#<%=txtTraDesc.ClientID%>').val(data.d[0].TrailerDesc);
                                //tabcertificate
                                $('#<%=txtCertTireDimFront.ClientID%>').val(data.d[0].StdTyreFront);
                                $('#<%=txtCertTireDimBack.ClientID%>').val(data.d[0].StdTyreBack);
                                $('#<%=txtCertLiFront.ClientID%>').val(data.d[0].MinLi_Front);
                                $('#<%=txtCertLiBack.ClientID%>').val(data.d[0].MinLi_Back);
                                $('#<%=txtCertMinInpressFront.ClientID%>').val(data.d[0].Min_Inpress_Front);
                                $('#<%=txtCertMinInpressBack.ClientID%>').val(data.d[0].Min_Inpress_Back);
                                $('#<%=txtCertRimFront.ClientID%>').val(data.d[0].Std_Rim_Front);
                                $('#<%=txtCertRimBack.ClientID%>').val(data.d[0].Std_Rim_Back);
                                $('#<%=txtCertminSpeedFront.ClientID%>').val(data.d[0].Min_Front);
                                $('#<%=txtCertMinSpeedBack.ClientID%>').val(data.d[0].Min_Back);
                                $('#<%=txtCertMaxWidthFront.ClientID%>').val(data.d[0].Max_Tyre_Width_Frnt);
                                $('#<%=txtCertMaxWidthBack.ClientID%>').val(data.d[0].Max_Tyre_Width_Bk);
                                $('#<%=txtCertAxlePressureFront.ClientID%>').val(data.d[0].AxlePrFront);
                                $('#<%=txtCertAxlePressureBack.ClientID%>').val(data.d[0].AxlePrBack);
                                $('#<%=txtCertAxleQty.ClientID%>').val(data.d[0].Axles_Number);
                                $('#<%=txtCertAxleWithTraction.ClientID%>').val(data.d[0].Axles_Number_Traction);
                                $('#<%=txtCertGear.ClientID%>').val(data.d[0].Wheels_Traction);
                                $('#<%=txtCertTrailerWeightBrakes.ClientID%>').val(data.d[0].TrailerWth_Brks);
                                $('#<%=txtCertTrailerWeight.ClientID%>').val(data.d[0].TrailerWthout_Brks);
                                $('#<%=txtCertWeightTowbar.ClientID%>').val(data.d[0].Max_Wt_TBar);
                                $('#<%=txtCertLengthTowbar.ClientID%>').val(data.d[0].Len_TBar);
                                $('#<%=txtCertTotalTrailerWeight.ClientID%>').val(data.d[0].TotalTrailerWeight);
                                $('#<%=txtCertSeats.ClientID%>').val(data.d[0].Seats);
                                $('#<%=txtCertValidFrom.ClientID%>').val(data.d[0].ValidFrom);
                                $('#<%=txtCertEuVersion.ClientID%>').val(data.d[0].EU_Version);
                                $('#<%=txtCertEuVariant.ClientID%>').val(data.d[0].EU_Variant);
                                $('#<%=txtCertEuronorm.ClientID%>').val(data.d[0].EU_Norm);
                                $('#<%=txtCertCo2Emission.ClientID%>').val(data.d[0].CO2_Emission);
                                $('#<%=txtCertMakeParticleFilter.ClientID%>').val(data.d[0].Make_Part_Filter);
                                $('#<%=txtCertChassi.ClientID%>').val(data.d[0].Chassi_Desc);
                                $('#<%=txtCertIdentity.ClientID%>').val(data.d[0].Identity_Annot);
                                $('#<%=txtCertCertificate.ClientID%>').val(data.d[0].Cert_Text);
                                $('#<%=txtCertNotes.ClientID%>').val(data.d[0].Annot);

                                overlay('off', '');
                            }
                        }
                        else {
                            var res = GetMultiMessage('0008', '', '');
                        }
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //Moved this into get ready for it to be closed on escape binding when opened as pop-up
            function overlay(state, mod) {
                $('body').focus();
                if (mod == "") {
                    $('.modal').addClass('hidden');
                }
                else {
                    $('#' + mod).removeClass('hidden');
                }
                if (state == "") {
                    $('.overlayHide').toggleClass('ohActive');
                } else if (state == "on") {
                    $('.overlayHide').addClass('ohActive');
                } else {
                    $('.overlayHide').removeClass('ohActive');
                }
            }

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

            var srchVeh = "";
            srchVeh = getUrlParameter('vehId');

            //if (window.parent != undefined && window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchVeh') != null) {
            //    srchVeh = window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchVeh').value;
            //}
            $('#<%=txtRegNoCreate.ClientID%>').val(srchVeh); //window.opener.parent.document.getElementById('ctl00_cntMainPanel_txtSrchVeh').value

            //Check the page name from where it is called before hiding the banners
            var pageNameFrom = getUrlParameter('pageName');

            if (pageNameFrom == "OrderHead" && pageNameFrom != undefined) {
                $('#topBanner').hide();
                $('#topNav').hide();
                $('#carsSideBar').hide();

                $('#<%=txtRefNoCreate.ClientID%>').val("");
            }

            loadInit();

            function loadInit() {
                setTab('General');
                //Loading all drop down boxes
                loadNewUsedCode();
                loadStatusCode();
                $('#ctl00_cntMainPanel_ddlVehicleType option[value="2"]').prop('selected', true);
                $('#ctl00_cntMainPanel_ddlVehicleStatus option[value="6"]').prop('selected', true);
                getNewUsedRefNo();
                loadWarrantyCode();
                loadMakeCode();
                loadModel();
                loadCustomerGroup();
                loadEditMake();
                loadVatCode();
                $('#<%=txtRegNoCreate.ClientID%>').focus();

            }      

            var veh = getUrlParameter('veh');
            var regno = getUrlParameter('regno');
            var refno = getUrlParameter('refno');
            if (typeof refno !== "undefined" && veh != "new") {
                (typeof regno == "undefined") ? regno = '' : regno = regno;
                (typeof veh == "undefined") ? veh = '' : veh = veh;
                FetchVehicleDetails(regno, refno, veh, 'load');
            }
            else if (typeof regno !== "undefined" && veh == "new") {
                $('#<%=txtRegNoCreate.ClientID%>').val(regno);
                overlay('on', 'modNewVehicle');
            }
            else {
                overlay('on', 'modNewVehicle');
            }

            /*
                Button that "onclick" opens a popupwindow and provides more info about customer by providing custId to the popup
                Location: Dashboard->Vehicle->Customer
                Calls   : moreInfo
                ↓ ↓ ↓ 
            */   
         
            $('#<%=btnMoreInfo.ClientID%>').click(function ()
            {
                if ($('#<%=txtCustNo.ClientID%>').val().length > 0)
                {
                    var custId = $('#<%=txtCustNo.ClientID%>').val();
                    moreInfo('../Master/frmCustomerDetail.aspx?cust=' + custId + '&pageName=Vehicle', 'Kundedetaljer');
                }
                else
                {
                    moreInfo('../Master/frmCustomerDetail.aspx?pageName=Vehicle', 'Kundedetaljer');
                }
            });

            //IS BIND DEPRECATED?
            /* MODAL FUNCTIONS */
            $(document).bind('keydown', function (e) { // BIND ESCAPE TO CLOSE
                if (e.which == 27) {
                    overlay('off', '');
                }
            });
            $(".modClose").on('click', function (e) {
                overlay('off', '');
            });


            $('#<%=btnFetchMVR.ClientID%>').on('click', function (e) {
                if ($('#<%=txtRefNoCreate.ClientID%>').val() != "") {
                    FetchMVR();

                }
                else {
                    //Changed by ABS
                    //FetchVehicleDetails($('#<%=txtIntNo.ClientID%>').val(),'', '');
                    FetchVehicleDetails($('#<%=txtRegNo.ClientID%>').val(), '', '');
                }
                
            });

            $("#<%=cbMachineHours.ClientID%>").on("click", function () {
                mhToggle();
            });
            function mhToggle() {
                //$("#<%=cbMachineHours.ClientID%>").prop('checked', !$("#<%=cbMachineHours.ClientID%>").prop('checked'));
                if ($("#<%=cbMachineHours.ClientID%>").is(':checked')) {
                    $('.mil').hide();
                    $('.hrs').show();
                }
                else {
                    $('.mil').show();
                    $('.hrs').hide();
                }
            }

            $('#<%=lblHours.ClientID%>').hide();
            $('#<%=txtHours.ClientID%>').hide();
            $('#<%=lblHoursDate.ClientID%>').hide();
            $('#<%=txtHoursDate.ClientID%>').hide();
            //Temporary hides the newvehicle pop up when doing action on the page. Must be fixed in a permanent good way
            <%--if ($('#<%=txtRegNo.ClientID%>').val() != "") {
                 $('#modNewVehicle').addClass('hidden');
                 $('.overlayHide').removeClass('ohActive');
             }
             else {
                 $('#modNewVehicle').removeClass('hidden');
                 $('.overlayHide').addClass('ohActive');
             }--%>


            function setTab(cTab) {
                var regState = true;
                var tabID = "";
                tabID = $(cTab).data('tab') || cTab; // Checks if click or function call
                var tab;
                (tabID == "") ? tab = cTab : tab = tabID;

                $('.tTab').addClass('hidden'); // Hides all tabs
                $('#tab' + tabID).removeClass('hidden'); // Shows target tab and sets active class
                $('.cTab').removeClass('tabActive'); // Removes the tabActive class for all 
                $("#btn" + tabID).addClass('tabActive'); // Sets tabActive to clicked or active tab
                (tab == 'General') ? regState = false : regState = true; // Check for current tab
                $('#<%=txtRegNo.ClientID%>').prop('disabled', regState); // Sets state of txtRegno field
            }

            $('.cTab').on('click', function (e) {
                setTab($(this));
            });

            $('#<%=btnNewVehicleOK.ClientID%>').on('click', function () {
                overlay('off', '');
                //Refno will be set in insert cript in DB and redirected
                <%--if ($('#<%=txtRefNoCreate.ClientID%>').val() != "") {
                    $('#<%=txtIntNo.ClientID%>').val($('#<%=txtRefNoCreate.ClientID%>').val());
                }--%>
                $('#<%=txtRegNo.ClientID%>').val($('#<%=txtRegNoCreate.ClientID%>').val());
                $('#<%=ddlVehType.ClientID%>').val($('#<%=ddlVehicleType.ClientID%>').val());
                $('#<%=ddlVehStatus.ClientID%>').val($('#<%=ddlVehicleStatus.ClientID%>').val());
                $('#btnSaveVehicle').prop('disabled', false);
                $('#<%=txtRegNo.ClientID%>').focus();

            });
            $('#<%=txtRegNoCreate.ClientID()%>').on('blur', function () {
                FetchVehicleDetails($('#<%=txtRegNoCreate.ClientID%>').val(), '', '', '');
            });


            $('#<%=btnNewVehicleCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modNewVehicle').addClass('hidden');
                $('#btnSaveVehicle').prop('disabled', true);
                $('#<%=txtRegNo.ClientID%>').focus();
            });

            $('#btnNewVehicle').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modNewVehicle').removeClass('hidden');
                $('#btnSaveVehicle').prop('disabled', false);
                $('#ddlVehType').val(-1);
                $('#ddlVehStatus').val(-1);
                $('#<%=txtRefNoCreate.ClientID%>').val('');
                $('#<%=txtRegNoCreate.ClientID%>').val('');
                $('#ctl00_cntMainPanel_ddlVehicleType option[value="2"]').prop('selected', true);
                $('#ctl00_cntMainPanel_ddlVehicleStatus option[value="6"]').prop('selected', true);
                getNewUsedRefNo();
                $('#<%=txtRegNoCreate.ClientID%>').focus();

            });

            $('.modClose').on('click', function () {
                $('#modNewVehicle').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                $('#btnSaveVehicle').prop('disabled', true);
            });

            //Contextmenu for Vegvesen
            $.contextMenu({
                selector: '#<%=txtRegNo.ClientID%>',
                items: {
                    vegvesen: {
                        name: "Åpne i Vegvesen",
                        callback: function (key, opt) {
                            window.open('http://www.vegvesen.no/Kjoretoy/Eie+og+vedlikeholde/EU-kontroll/Kontrollfrist?ticket=74DFF3E8A21733B50546C640D6B752F8&registreringsnummer=' + $(this).val() + '&captcha=');
                        }
                    },
                    brreg: {
                        name: "Åpne i Brreg",
                        callback: function (key, opt) {
                            window.open('https://w2.brreg.no/motorvogn/heftelser_motorvogn.jsp?regnr=' + $(this).val());
                        }
                    },
                }
            });

            //Make edit mod scripts
            $('#<%=btnEditMake.ClientID%>').on('click', function () {
                overlay('on', 'modEditMake');
            });
            
            $('#<%=btnEditMakeCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modEditMake').addClass('hidden');
            });
            $('#<%=btnEditMakeNew.ClientID%>').on('click', function () {
                $('#<%=txtEditMakeCode.ClientID%>').val('');
                $('#<%=txtEditMakeDescription.ClientID%>').val('');
                $('#<%=txtEditMakePriceCode.ClientID%>').val('');
                $('#<%=txtEditMakeDiscount.ClientID%>').val('');
                $('#<%=txtEditMakeVat.ClientID%>').val('')
                $('#<%=lblEditMakeStatus.ClientID%>').html('Oppretter nytt bilmerke.')
            });

            function loadEditMake() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadEditMake",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpEditMakeList.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpEditMakeList.ClientID%>').append($("<option></option>").val(value.MakeCode).html(value.MakeName));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpEditMakeList.ClientID%>').change(function () {
                var makeId = this.value;
                getEditMake(makeId);
            });

            function getEditMake(makeId) {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/GetEditMake",
                    data: "{makeId: '" + makeId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        console.log(Result);
                        console.log(Result.d[0].Cost_Price);
                    $('#<%=txtEditMakeCode.ClientID%>').val(Result.d[0].MakeCode);
                    $('#<%=txtEditMakeDescription.ClientID%>').val(Result.d[0].MakeName);
                    $('#<%=txtEditMakePriceCode.ClientID%>').val(Result.d[0].Cost_Price);
                    $('#<%=txtEditMakeDiscount.ClientID%>').val(Result.d[0].Description);
                    $('#<%=txtEditMakeVat.ClientID%>').val(Result.d[0].VanNo);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            $('#<%=btnEditMakeSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modEditMake').addClass('hidden');
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddEditMake",
                    data: "{editMakeCode: '" + $('#<%=txtEditMakeCode.ClientID%>').val() + "', editMakeDesc:'" + $('#<%=txtEditMakeDescription.ClientID%>').val() + "', editMakePriceCode:'" + $('#<%=txtEditMakePriceCode.ClientID%>').val() + "', editMakeDiscount:'" + $('#<%=txtEditMakeDiscount.ClientID%>').val() + "', editMakeVat:'" + $('#<%=txtEditMakeVat.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                            
                                 var res = 'Bilmerke er lagt til.';
                                 alert(res);
                             
                            
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                //loadEditMake();
                //test
            });

            $('#<%=btnEditMakeDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtEditMakeCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteBranch",
                        data: "{editMakeId: '" + $('#<%=txtEditMakeCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        <%--$('#<%=lblAdvBranchStatus.ClientID%>').html($('#<%=txtAdvBranchCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvBranchCode.ClientID%>').val('');
                    $('#<%=txtAdvBranchText.ClientID%>').val('');
                    $('#<%=txtAdvBranchNote.ClientID%>').val('');
                    $('#<%=txtAdvBranchRef.ClientID%>').val('');
                    loadBranch();--%>

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblEditMakeStatus.ClientID%>').html('Vennligst først velg yrkeskoden i listen til venstre før du klikker slett.');
                }


            });

            /*------------End of make edit mod scripts-------------------------------------------------------------------------------------------*/

            $('#<%=btnEquipment.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modWebEquipment').removeClass('hidden');
            });

            $('#btnSaveEquipment').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modWebEquipment').addClass('hidden');
            });
            $('.modCloseEquipment').on('click', function () {
                $('#modWebEquipment').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });

            $('#btnPrintVehicle').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modPrintVehicle').removeClass('hidden');
            });
            $('.modClosePrint').on('click', function () {
                $('#modPrintVehicle').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });

            /*Annotation on the general tab*/
            $('#<%=btnAddAnnotation.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modGeneralAnnotation').removeClass('hidden');
            });
            $('.modCloseGeneralAnnotation').on('click', function () {
                $('#modGeneralAnnotation').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#<%=btnSaveGeneralAnnotation.ClientID%>').on('click', function () {
                $('#modGeneralAnnotation').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#<%=txtGeneralAnnotation.ClientID%>').val() != "") {
                    $('#<%=btnAddAnnotation.ClientID%>').addClass('warningAN');
                }
                else {
                    $('#<%=btnAddAnnotation.ClientID%>').removeClass('warningAN');
                }
            });

            /*Note on the general tab*/
            $('#<%=btnAddNote.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modGeneralNote').removeClass('hidden');
            });
            $('.modCloseGeneralNote').on('click', function () {
                $('#modGeneralNote').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#<%=btnSaveGeneralNote.ClientID%>').on('click', function () {
                $('#modGeneralNote').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#<%=txtGeneralNote.ClientID%>').val() != "") {
                    $('#<%=btnAddNote.ClientID%>').addClass('warningAN');
                }
                else {
                    $('#<%=btnAddNote.ClientID%>').removeClass('warningAN');
                }
            });

            //ENIRO FUNCTIONS
            $('#<%=CustSelect.ClientID%>').change(function () {
                var eniroId = this.value;
                LoadEniroDet(eniroId);
            });

            //New customer popup
            $('.modCloseCust').on('click', function () {
                $('#modNewCust').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });

            //Code for customer page
            //Eniro customer search functionality

            $('#<%=btnSearchEniro.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modNewCust').removeClass('hidden');
                FetchEniro($('#<%=txtCustSearchEniro.ClientID()%>').val());
            });

            $('#<%=btnEniroFetch.ClientID%>').on('click', function () {
                FetchEniro($('#<%=txtEniro.ClientID()%>').val());
            });

            function FetchEniro(eniroId) {
                $('#<%=txtCustSearchEniro.ClientID%>').val(eniroId);
                $('#<%=txtEniro.ClientID%>').val(eniroId);

                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/FetchEniro",
                    data: "{search: '" + eniroId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            $('#<%=CustSelect.ClientID%>').empty();
                                 var res = data.d;
                                 $.each(res, function (key, value) {
                                     var name = value.CUST_FIRST_NAME + " " + value.CUST_MIDDLE_NAME + " " + value.CUST_LAST_NAME + " - " + value.CUST_PERM_ADD1 + " - " + value.ID_CUST_PERM_ZIPCODE + " " + value.CUST_PERM_ADD2 + " - " + value.CUST_PHONE_MOBILE;
                                     $('#<%=CustSelect.ClientID%>').append($("<option></option>").val(value.ENIRO_ID).html(name));
                                 });
                             }
                             else {
                                 alert('No customer was found. Please search with something else as your data.')
                             }
                         },
                    failure: function () {
                        alert("Failed!");
                    },
                    select: function (e, i) {
                        alert('hi');

                    },
                });
                 }

            function LoadEniroDet(eniroId) {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadEniroDet",
                    data: "{EniroId: '" + eniroId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            $('#<%=txtCustFirstName.ClientID%>').val(data.d[0].CUST_FIRST_NAME);
                            $('#<%=txtCustMiddleName.ClientID%>').val(data.d[0].CUST_MIDDLE_NAME);
                            $('#<%=txtCustLastName.ClientID%>').val(data.d[0].CUST_LAST_NAME);
                            $('#<%=txtCustAdd1.ClientID%>').val(data.d[0].CUST_PERM_ADD1);
                            $('#<%=txtCustPersonNo.ClientID%>').val(data.d[0].CUST_BORN);
                            $('#<%=txtCustOrgNo.ClientID%>').val(data.d[0].CUST_SSN_NO);
                            $('#<%=txtCustVisitZip.ClientID%>').val(data.d[0].ID_CUST_PERM_ZIPCODE);
                            $('#<%=txtCustVisitPlace.ClientID%>').val(data.d[0].CUST_PERM_ADD2);
                            $('#<%=lblCustEniroId.ClientID%>').text(data.d[0].ENIRO_ID);
                            if (data.d[0].PHONE_TYPE == 'M') {
                                $('#<%=txtCustPhone.ClientID%>').val(data.d[0].CUST_PHONE_MOBILE);
                            }
                            if (data.d[0].PHONE_TYPE == 'T') {
                                $('#<%=txtCustPhone2.ClientID%>').val(data.d[0].CUST_PHONE_MOBILE);
                            }

                            $('#modNewCust').addClass('hidden');
                            $('.overlayHide').removeClass('ohActive');
                            $('#<%=txtCustSearchEniro.ClientID%>').val('');
                        }
                        else {
                            systemMSG('error', 'No customer was found. Please search with something else as your data.', 4000);
                        }
                    },
                    failure: function () {
                        systemMSG('error', 'Something wen wrong.', 4000);
                    }
                });
            }

            
            
            //taken from frmWOJobDetails.aspx
            function validateCust(CustomerId)
            {
                var strRetVal;
                $.ajax(
                {
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "../Transactions/frmWOHead.aspx/ValidateCustomer",
                        data: "{IdCustomer: '" + CustomerId + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data)
                        {
                        strRetVal = data.d.toString()

                        },
                        error: function (result)
                        {
                            alert("Error");
                        }
                });
                return strRetVal;
            }
           
           

            $('#<%=txtCustSearchEniro.ClientID%>').autocomplete(
            {
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "../Transactions/frmWoSearch.aspx/Customer_Search",
                        data: "{q:'" + $('#<%=txtCustSearchEniro.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data)
                         {

                             console.log($('#<%=txtCustSearchEniro.ClientID%>').val());
                            if (data.d.length === 0)  // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                            { 
                                response([{ label: 'Ingen treff i lokalt kunderegister. Vil du opprette ny kunde?', value: $('#<%=txtCustSearchEniro.ClientID%>').val(), val: 'new' }]);
                            }
                            else
                                response($.map(data.d, function (item)
                                {
                                    return {
                                        label: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PHONE_MOBILE,
                                        val: item.ID_CUSTOMER,
                                        value: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME
                                    }
                                }))
                        },
                        error: function (xhr, status, error)
                        {
                             alert("Error" + error);
                             var err = eval("(" + xhr.responseText + ")");
                             alert('Error: ' + err.Message);
                         }
                     });
                 },
                select: function (e, i)
                {
                    //alert(i.item.val);
                    if (i.item.val != 'new')
                    {
                        $('#<%=txtCustFirstName.ClientID%>').val('');
                        $('#<%=txtCustMiddleName.ClientID%>').val('');
                        $('#<%=txtCustLastName.ClientID%>').val('');
                        $('#<%=txtCustAdd1.ClientID%>').val('');
                        $('#<%=txtCustVisitZip.ClientID%>').val('');
                        $('#<%=txtCustVisitPlace.ClientID%>').val('');
                        $('#<%=txtCustBillAdd.ClientID%>').val('');
                        $('#<%=txtCustBillZip.ClientID%>').val('');
                        $('#<%=txtCustBillPlace.ClientID%>').val('');
                        $('#<%=txtCustPhone.ClientID%>').val('');
                        $('#<%=txtCustPhone2.ClientID%>').val('');
                        $('#<%=txtCustMail.ClientID%>').val('');
                        $('#<%=txtCustPersonNo.ClientID%>').val('');
                        $('#<%=txtCustOrgNo.ClientID%>').val('');

                        $('#<%=txtCustNo.ClientID()%>').val(i.item.val);
                        FetchCustomerDetails(i.item.val);
                    }
                    else
                    {                      
                        console.log("Inside else statement of select of autocomplete");
                        var custId = $('#<%=txtCustSearchEniro.ClientID%>').val();
                        console.log("Cust id is "+custId);
                        moreInfo("../Master/frmCustomerDetail.aspx?"  + "&pageName=Vehicle");                  
                    }         
                }
            });

           
            /*Autocomplete on the vehicle group*/
            $(function () {
                $('#<%=txtTechVehGrp.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmVehicleDetail.aspx/GetVehGroup",
                            data: "{'VehGrp':'" + $('#<%=txtTechVehGrp.ClientID%>').val() + "'}",
                            dataType: "json",
                            success: function (data) {
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.split('-')[1] + "-" + item.split('-')[2],
                                        val: item.split('-')[0],
                                        value: item.split('-')[1],
                                        desc: item.split('-')[1],
                                        remark: item.split('-')[2],

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
                    minLength: 0,
                    select: function (e, i) {
                        $("#<%=txtTechVehGrp.ClientID%>").val(i.item.value);
                        $("#<%=txtTechVehGrpName.ClientID%>").val(i.item.remark);
                        //alert(i.item.val); //gir rett id i tbl_mas_settings tabellen
                    },

                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                }
                )
            });

            /*Autocomplete on the fuelcode*/
            $(function () {
                $('#<%=txtTechFuelCode.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmVehicleDetail.aspx/GetFuelCode",
                            data: "{'FuelCode':'" + $('#<%=txtTechFuelCode.ClientID%>').val() + "'}",
                            dataType: "json",
                            success: function (data) {
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.split('-')[1],
                                        val: item.split('-')[0],
                                        value: item.split('-')[0],
                                        desc: item.split('-')[1],
                                       

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
                    minLength: 0,
                    select: function (e, i) {
                        $("#<%=txtTechFuelCode.ClientID%>").val(i.item.value);
                        $("#<%=txtTechFuelName.ClientID%>").val(i.item.desc);
                        //alert(i.item.val); //gir rett id i tbl_mas_settings tabellen
                    },

                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                }
                )
            });

            /*Autocomplete on the WAREHOUSE*/
            $(function () {
                $('#<%=txtTechWarehouse.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "frmVehicleDetail.aspx/GetWareHouse",
                            data: "{'WH':'" + $('#<%=txtTechWarehouse.ClientID%>').val() + "'}",
                            dataType: "json",
                            success: function (data) {
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2],
                                        val: item.split('-')[0],
                                        value: item.split('-')[0],
                                        name: item.split('-')[1],
                                        location: item.split('-')[2],

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
                    minLength: 0,
                    select: function (e, i) {
                        $("#<%=txtTechWarehouse.ClientID%>").val(i.item.val);
                        $("#<%=txtTechWarehouseName.ClientID%>").val(i.item.name + " - " + i.item.location);
                        //alert(i.item.val); //gir rett id i tbl_mas_settings tabellen
                    },

                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                }
                )
            });


            //Autocomplete for zip codes
            $('#<%=txtCustVisitZip.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmVehicleDetail.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtCustVisitZip.ClientID%>').val() + "'}",
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
                    $("#<%=txtCustVisitZip.ClientID%>").val(i.item.val);
                         $("#<%=txtCustVisitPlace.ClientID%>").val(i.item.city);
                     },
            });

            $('#<%=txtCustBillZip.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmVehicleDetail.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtCustBillZip.ClientID%>').val() + "'}",
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
                    $("#<%=txtCustBillZip.ClientID%>").val(i.item.val);
                         $("#<%=txtCustBillPlace.ClientID%>").val(i.item.city);
                     },
            });

            $('#<%=cbCustSameAdd.ClientID%>').on('click', function () {

                if ($('#<%=cbCustSameAdd.ClientID%>').is(':checked')) {
                    $('#<%=txtCustBillAdd.ClientID%>').val($('#<%=txtCustAdd1.ClientID%>').val());
                    $('#<%=txtCustBillZip.ClientID%>').val($('#<%=txtCustVisitZip.ClientID%>').val());
                    $('#<%=txtCustBillPlace.ClientID%>').val($('#<%=txtCustVisitPlace.ClientID%>').val());

                };

            });

            /*BilXtrasjekk notatkode*/
            $('.engineOilAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modEngineOil').removeClass('hidden');
            });
            $('.modCloseEngineOil').on('click', function () {
                $('#modEngineOil').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveEngineOilAnnot').on('click', function () {
                $('#modEngineOil').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormEngineOilAnnot').val() != "") {
                    $('.engineOilAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.engineOilAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.cFLevelAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modcFLevel').removeClass('hidden');
            });
            $('.modClosecFLevel').on('click', function () {
                $('#modcFLevel').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSavecFLevelAnnot').on('click', function () {
                $('#modcFLevel').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormcFLevelAnnot').val() != "") {
                    $('.cFLevelAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.cFLevelAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.cfTempAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modcfTemp').removeClass('hidden');
            });
            $('.modClosecfTemp').on('click', function () {
                $('#modcfTemp').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSavecfTempAnnot').on('click', function () {
                $('#modcfTemp').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormcfTempAnnot').val() != "") {
                    $('.cfTempAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.cfTempAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.brakeFluidAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modbrakeFluid').removeClass('hidden');
            });
            $('.modCloseBrakeFluid').on('click', function () {
                $('#modbrakeFluid').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBrakeFluidAnnot').on('click', function () {
                $('#modbrakeFluid').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBrakeFluidAnnot').val() != "") {
                    $('.brakeFluidAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.brakeFluidAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.batteryAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modBattery').removeClass('hidden');
            });
            $('.modCloseBattery').on('click', function () {
                $('#modBattery').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBatteryAnnot').on('click', function () {
                $('#modBattery').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBatteryAnnot').val() != "") {
                    $('.batteryAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.batteryAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.vipesFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modVipesFront').removeClass('hidden');
            });
            $('.modCloseVipesFront').on('click', function () {
                $('#modVipesFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveVipesFrontAnnot').on('click', function () {
                $('#modVipesFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormVipesFrontAnnot').val() != "") {
                    $('.vipesFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.vipesFrontAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.vipesBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modVipesBack').removeClass('hidden');
            });
            $('.modCloseVipesBack').on('click', function () {
                $('#modVipesBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveVipesBackAnnot').on('click', function () {
                $('#modVipesBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormVipesBackAnnot').val() != "") {
                    $('.vipesBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.vipesBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.lightsFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modLightsFront').removeClass('hidden');
            });
            $('.modCloseLightsFront').on('click', function () {
                $('#modLightsFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveLightsFrontAnnot').on('click', function () {
                $('#modLightsFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormLightsFrontAnnot').val() != "") {
                    $('.lightsFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.lightsFrontAnnotIcon').removeClass('alarm icon');
                }
            });
            $('.lightsBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modLightsBack').removeClass('hidden');
            });
            $('.modCloseLightsBack').on('click', function () {
                $('#modLightsBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveLightsBackAnnot').on('click', function () {
                $('#modLightsBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormLightsBackAnnot').val() != "") {
                    $('.lightsBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.lightsBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.bumperFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modBumperFront').removeClass('hidden');
            });
            $('.modCloseBumperFront').on('click', function () {
                $('#modBumperFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBumperFrontAnnot').on('click', function () {
                $('#modBumperFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBumperFrontAnnot').val() != "") {
                    $('.bumperFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.bumperFrontAnnotIcon').removeClass('alarm icon');
                }
            });
            $('.bumperBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modBumperBack').removeClass('hidden');
            });
            $('.modCloseBumperBack').on('click', function () {
                $('#modBumperBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBumperBackAnnot').on('click', function () {
                $('#modBumperBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBumperBackAnnot').val() != "") {
                    $('.bumperBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.bumperBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.tiresFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modTiresFront').removeClass('hidden');
            });
            $('.modCloseTiresFront').on('click', function () {
                $('#modTiresFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveTiresFrontAnnot').on('click', function () {
                $('#modTiresFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormTiresFrontAnnot').val() != "") {
                    $('.tiresFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.tiresFrontAnnotIcon').removeClass('alarm icon');
                }
            });
            $('.tiresBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modTiresBack').removeClass('hidden');
            });
            $('.modCloseTiresBack').on('click', function () {
                $('#modTiresBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveTiresBackAnnot').on('click', function () {
                $('#modTiresBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormTiresBackAnnot').val() != "") {
                    $('.tiresBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.tiresBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.suspensionFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modSuspensionFront').removeClass('hidden');
            });
            $('.modCloseSuspensionFront').on('click', function () {
                $('#modSuspensionFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveSuspensionFrontAnnot').on('click', function () {
                $('#modSuspensionFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormSuspensionFrontAnnot').val() != "") {
                    $('.suspensionFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.suspensionFrontAnnotIcon').removeClass('alarm icon');
                }
            });
            $('.suspensionBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modSuspensionBack').removeClass('hidden');
            });
            $('.modCloseSuspensionBack').on('click', function () {
                $('#modSuspensionBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveSuspensionBackAnnot').on('click', function () {
                $('#modSuspensionBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormSuspensionBackAnnot').val() != "") {
                    $('.suspensionBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.suspensionBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.brakesFrontAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modBrakesFront').removeClass('hidden');
            });
            $('.modCloseBrakesFront').on('click', function () {
                $('#modBrakesFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBrakesFrontAnnot').on('click', function () {
                $('#modBrakesFront').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBrakesFrontAnnot').val() != "") {
                    $('.brakesFrontAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.brakesFrontAnnotIcon').removeClass('alarm icon');
                }
            });
            $('.brakesBackAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modBrakesBack').removeClass('hidden');
            });
            $('.modCloseBrakesBack').on('click', function () {
                $('#modBrakesBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveBrakesBackAnnot').on('click', function () {
                $('#modBrakesBack').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormBrakesBackAnnot').val() != "") {
                    $('.brakesBackAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.brakesBackAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.exhaustAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modExhaust').removeClass('hidden');
            });
            $('.modCloseExhaust').on('click', function () {
                $('#modExhaust').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveExhaustAnnot').on('click', function () {
                $('#modExhaust').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormExhaustAnnot').val() != "") {
                    $('.exhaustAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.exhaustAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.sealedEngineAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modSealedEngine').removeClass('hidden');
            });
            $('.modCloseSealedEngine').on('click', function () {
                $('#modSealedEngine').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveSealedEngineAnnot').on('click', function () {
                $('#modSealedEngine').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormSealedEngineAnnot').val() != "") {
                    $('.sealedEngineAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.sealedEngineAnnotIcon').removeClass('alarm icon');
                }
            });

            $('.sealedGearboxAnnot').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modSealedGearbox').removeClass('hidden');
            });
            $('.modCloseSealedGearbox').on('click', function () {
                $('#modSealedGearbox').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });
            $('#btnSaveSealedGearboxAnnot').on('click', function () {
                $('#modSealedGearbox').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
                if ($('#txtFormSealedGearboxAnnot').val() != "") {
                    $('.sealedGearboxAnnotIcon').addClass('alarm icon');
                }
                else {
                    $('.sealedGearboxAnnotIcon').removeClass('alarm icon');
                }
            });







            /*Code for the "BilXtra-sjekken" to add/remove the check mark*/
            /*Motorolje*/
            $('.engineOilBad').on('click', function () {
                $('.engineOilBadBox').toggleClass('large black checkmark icon');
                $('.engineOilOKBox, .engineOilGoodBox').removeClass('large black checkmark icon');
            });
            $('.engineOilOK').on('click', function () {
                $('.engineOilOKBox').toggleClass('large black checkmark icon');
                $('.engineOilBadBox, .engineOilGoodBox').removeClass('large black checkmark icon');
            });
            $('.engineOilGood').on('click', function () {
                $('.engineOilGoodBox').toggleClass('large black checkmark icon');
                $('.engineOilBadBox, .engineOilOKBox').removeClass('large black checkmark icon');
            });
            /*Frostvæske nivå*/
            $('.cFLevelBad').on('click', function () {
                $('.cFLevelBadBox').toggleClass('large black checkmark icon');
                $('.cFLevelOKBox, .cFLevelGoodBox').removeClass('large black checkmark icon');
            });
            $('.cFLevelOK').on('click', function () {
                $('.cFLevelOKBox').toggleClass('large black checkmark icon');
                $('.cFLevelBadBox, .cFLevelGoodBox').removeClass('large black checkmark icon');
            });
            $('.cFLevelGood').on('click', function () {
                $('.cFLevelGoodBox').toggleClass('large black checkmark icon');
                $('.cFLevelBadBox, .cFLevelOKBox').removeClass('large black checkmark icon');
            });
            /*Frostvæske Temperatur frysepunkt*/
            $('.cFTempBad').on('click', function () {
                $('.cFTempBadBox').toggleClass('large black checkmark icon');
                $('.cFTempOKBox, .cFTempGoodBox').removeClass('large black checkmark icon');
            });
            $('.cFTempOK').on('click', function () {
                $('.cFTempOKBox').toggleClass('large black checkmark icon');
                $('.cFTempBadBox, .cFTempGoodBox').removeClass('large black checkmark icon');
            });
            $('.cFTempGood').on('click', function () {
                $('.cFTempGoodBox').toggleClass('large black checkmark icon');
                $('.cFTempBadBox, .cFTempOKBox').removeClass('large black checkmark icon');
            });
            /*Bremsevæske nivå*/
            $('.brakeFluidBad').on('click', function () {
                $('.brakeFluidBadBox').toggleClass('large black checkmark icon');
                $('.brakeFluidOKBox, .brakeFluidGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakeFluidOK').on('click', function () {
                $('.brakeFluidOKBox').toggleClass('large black checkmark icon');
                $('.brakeFluidBadBox, .brakeFluidGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakeFluidGood').on('click', function () {
                $('.brakeFluidGoodBox').toggleClass('large black checkmark icon');
                $('.brakeFluidBadBox, .brakeFluidOKBox').removeClass('large black checkmark icon');
            });
            /*Batteri nivå*/
            $('.batteryBad').on('click', function () {
                $('.batteryBadBox').toggleClass('large black checkmark icon');
                $('.batteryOKBox, .batteryGoodBox').removeClass('large black checkmark icon');
            });
            $('.batteryOK').on('click', function () {
                $('.batteryOKBox').toggleClass('large black checkmark icon');
                $('.batteryBadBox, .batteryGoodBox').removeClass('large black checkmark icon');
            });
            $('.batteryGood').on('click', function () {
                $('.batteryGoodBox').toggleClass('large black checkmark icon');
                $('.batteryBadBox, .batteryOKBox').removeClass('large black checkmark icon');
            });
            /*Vindusvisker foran*/
            $('.vipesFrontBad').on('click', function () {
                $('.vipesFrontBadBox').toggleClass('large black checkmark icon');
                $('.vipesFrontOKBox, .vipesFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.vipesFrontOK').on('click', function () {
                $('.vipesFrontOKBox').toggleClass('large black checkmark icon');
                $('.vipesFrontBadBox, .vipesFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.vipesFrontGood').on('click', function () {
                $('.vipesFrontGoodBox').toggleClass('large black checkmark icon');
                $('.vipesFrontBadBox, .vipesFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Vindusvisker bak*/
            $('.vipesBackBad').on('click', function () {
                $('.vipesBackBadBox').toggleClass('large black checkmark icon');
                $('.vipesBackOKBox, .vipesBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.vipesBackOK').on('click', function () {
                $('.vipesBackOKBox').toggleClass('large black checkmark icon');
                $('.vipesBackBadBox, .vipesBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.vipesBackGood').on('click', function () {
                $('.vipesBackGoodBox').toggleClass('large black checkmark icon');
                $('.vipesBackBadBox, .vipesBackOKBox').removeClass('large black checkmark icon');
            });
            /*Lyspærer foran*/
            $('.lightsFrontBad').on('click', function () {
                $('.lightsFrontBadBox').toggleClass('large black checkmark icon');
                $('.lightsFrontOKBox, .lightsFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.lightsFrontOK').on('click', function () {
                $('.lightsFrontOKBox').toggleClass('large black checkmark icon');
                $('.lightsFrontBadBox, .lightsFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.lightsFrontGood').on('click', function () {
                $('.lightsFrontGoodBox').toggleClass('large black checkmark icon');
                $('.lightsFrontBadBox, .lightsFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Lyspærer back*/
            $('.lightsBackBad').on('click', function () {
                $('.lightsBackBadBox').toggleClass('large black checkmark icon');
                $('.lightsBackOKBox, .lightsBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.lightsBackOK').on('click', function () {
                $('.lightsBackOKBox').toggleClass('large black checkmark icon');
                $('.lightsBackBadBox, .lightsBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.lightsBackGood').on('click', function () {
                $('.lightsBackGoodBox').toggleClass('large black checkmark icon');
                $('.lightsBackBadBox, .lightsBackOKBox').removeClass('large black checkmark icon');
            });
            /*Støtdemper foran*/
            $('.bumperFrontBad').on('click', function () {
                $('.bumperFrontBadBox').toggleClass('large black checkmark icon');
                $('.bumperFrontOKBox, .bumperFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.bumperFrontOK').on('click', function () {
                $('.bumperFrontOKBox').toggleClass('large black checkmark icon');
                $('.bumperFrontBadBox, .bumperFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.bumperFrontGood').on('click', function () {
                $('.bumperFrontGoodBox').toggleClass('large black checkmark icon');
                $('.bumperFrontBadBox, .bumperFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Støtdemper bak*/
            $('.bumperBackBad').on('click', function () {
                $('.bumperBackBadBox').toggleClass('large black checkmark icon');
                $('.bumperBackOKBox, .bumperBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.bumperBackOK').on('click', function () {
                $('.bumperBackOKBox').toggleClass('large black checkmark icon');
                $('.bumperBackBadBox, .bumperBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.bumperBackGood').on('click', function () {
                $('.bumperBackGoodBox').toggleClass('large black checkmark icon');
                $('.bumperBackBadBox, .bumperBackOKBox').removeClass('large black checkmark icon');
            });
            /*Dekk foran*/
            $('.tiresFrontBad').on('click', function () {
                $('.tiresFrontBadBox').toggleClass('large black checkmark icon');
                $('.tiresFrontOKBox, .tiresFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.tiresFrontOK').on('click', function () {
                $('.tiresFrontOKBox').toggleClass('large black checkmark icon');
                $('.tiresFrontBadBox, .tiresFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.tiresFrontGood').on('click', function () {
                $('.tiresFrontGoodBox').toggleClass('large black checkmark icon');
                $('.tiresFrontBadBox, .tiresFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Dekk bak*/
            $('.tiresBackBad').on('click', function () {
                $('.tiresBackBadBox').toggleClass('large black checkmark icon');
                $('.tiresBackOKBox, .tiresBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.tiresBackOK').on('click', function () {
                $('.tiresBackOKBox').toggleClass('large black checkmark icon');
                $('.tiresBackBadBox, .tiresBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.tiresBackGood').on('click', function () {
                $('.tiresBackGoodBox').toggleClass('large black checkmark icon');
                $('.tiresBackBadBox, .tiresBackOKBox').removeClass('large black checkmark icon');
            });
            /*Forstilling*/
            $('.suspensionFrontBad').on('click', function () {
                $('.suspensionFrontBadBox').toggleClass('large black checkmark icon');
                $('.suspensionFrontOKBox, .suspensionFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.suspensionFrontOK').on('click', function () {
                $('.suspensionFrontOKBox').toggleClass('large black checkmark icon');
                $('.suspensionFrontBadBox, .suspensionFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.suspensionFrontGood').on('click', function () {
                $('.suspensionFrontGoodBox').toggleClass('large black checkmark icon');
                $('.suspensionFrontBadBox, .suspensionFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Bakstilling*/
            $('.suspensionBackBad').on('click', function () {
                $('.suspensionBackBadBox').toggleClass('large black checkmark icon');
                $('.suspensionBackOKBox, .suspensionBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.suspensionBackOK').on('click', function () {
                $('.suspensionBackOKBox').toggleClass('large black checkmark icon');
                $('.suspensionBackBadBox, .suspensionBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.suspensionBackGood').on('click', function () {
                $('.suspensionBackGoodBox').toggleClass('large black checkmark icon');
                $('.suspensionBackBadBox, .suspensionBackOKBox').removeClass('large black checkmark icon');
            });
            /*Bremser foran*/
            $('.brakesFrontBad').on('click', function () {
                $('.brakesFrontBadBox').toggleClass('large black checkmark icon');
                $('.brakesFrontOKBox, .brakesFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakesFrontOK').on('click', function () {
                $('.brakesFrontOKBox').toggleClass('large black checkmark icon');
                $('.brakesFrontBadBox, .brakesFrontGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakesFrontGood').on('click', function () {
                $('.brakesFrontGoodBox').toggleClass('large black checkmark icon');
                $('.brakesFrontBadBox, .brakesFrontOKBox').removeClass('large black checkmark icon');
            });
            /*Bremser bak*/
            $('.brakesBackBad').on('click', function () {
                $('.brakesBackBadBox').toggleClass('large black checkmark icon');
                $('.brakesBackOKBox, .brakesBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakesBackOK').on('click', function () {
                $('.brakesBackOKBox').toggleClass('large black checkmark icon');
                $('.brakesBackBadBox, .brakesBackGoodBox').removeClass('large black checkmark icon');
            });
            $('.brakesBackGood').on('click', function () {
                $('.brakesBackGoodBox').toggleClass('large black checkmark icon');
                $('.brakesBackBadBox, .brakesBackOKBox').removeClass('large black checkmark icon');
            });
            /*Eksosanlegg*/
            $('.exhaustBad').on('click', function () {
                $('.exhaustBadBox').toggleClass('large black checkmark icon');
                $('.exhaustOKBox, .exhaustGoodBox').removeClass('large black checkmark icon');
            });
            $('.exhaustOK').on('click', function () {
                $('.exhaustOKBox').toggleClass('large black checkmark icon');
                $('.exhaustBadBox, .exhaustGoodBox').removeClass('large black checkmark icon');
            });
            $('.exhaustGood').on('click', function () {
                $('.exhaustGoodBox').toggleClass('large black checkmark icon');
                $('.exhaustBadBox, .exhaustOKBox').removeClass('large black checkmark icon');
            });
            /*Tetthet Motor*/
            $('.sealedEngineBad').on('click', function () {
                $('.sealedEngineBadBox').toggleClass('large black checkmark icon');
                $('.sealedEngineOKBox, .sealedEngineGoodBox').removeClass('large black checkmark icon');
            });
            $('.sealedEngineOK').on('click', function () {
                $('.sealedEngineOKBox').toggleClass('large black checkmark icon');
                $('.sealedEngineBadBox, .sealedEngineGoodBox').removeClass('large black checkmark icon');
            });
            $('.sealedEngineGood').on('click', function () {
                $('.sealedEngineGoodBox').toggleClass('large black checkmark icon');
                $('.sealedEngineBadBox, .sealedEngineOKBox').removeClass('large black checkmark icon');
            });
            /*Tetthet Girkasse*/
            $('.sealedGearboxBad').on('click', function () {
                $('.sealedGearboxBadBox').toggleClass('large black checkmark icon');
                $('.sealedGearboxOKBox, .sealedGearboxGoodBox').removeClass('large black checkmark icon');
            });
            $('.sealedGearboxOK').on('click', function () {
                $('.sealedGearboxOKBox').toggleClass('large black checkmark icon');
                $('.sealedGearboxBadBox, .sealedGearboxGoodBox').removeClass('large black checkmark icon');
            });
            $('.sealedGearboxGood').on('click', function () {
                $('.sealedGearboxGoodBox').toggleClass('large black checkmark icon');
                $('.sealedGearboxBadBox, .sealedGearboxOKBox').removeClass('large black checkmark icon');
            });

            /*STARTER UTSKRIFT AV VALGT RAPPORT*/
            $('#btnStartPrint').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modPrintVehicle').addClass('hidden');
                window.print();
            });

            //constrainInput: false gjør at en ikke trenger punktumer
            $('#txtLastRegDate').datepicker($.datepicker.regional["no"]);



            

            $('#<%=txtMileage.ClientID%>').blur(function () {
                if ($('#<%=txtMileage.ClientID%>').val() != '') {
                    $('#<%=txtMileageDate.ClientID%>').datepicker('setDate', new Date());
                    $('#<%=txtType.ClientID%>').focus();
                     }

            });
            $('#<%=txtHours.ClientID%>').blur(function () {
                if ($('#<%=txtHours.ClientID%>').val() != '') {
                    $('#<%=txtHoursDate.ClientID%>').datepicker('setDate', new Date());
                    $('#<%=txtType.ClientID%>').focus();
                }
            });

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtRegDate.ClientID%>,#<%=txtRegDateNorway.ClientID%>,#<%=txtLastRegDate.ClientID%>,#<%=txtDeregDate.ClientID%>,#<%=txtMileageDate.ClientID%>,#<%=txtHoursDate.ClientID%>,#<%=txtTechDateExpectedIn.ClientID%>,#<%=txtTechTakenInDate.ClientID%>,#<%=txtTechDeliveryDate.ClientID%>,#<%=txtTechServiceDate.ClientID%>,#<%=txtTechCallInDate.ClientID%>,#<%=txtTechCleanedDate.ClientID%>,#<%=txtTechLastPkkOk.ClientID%>,#<%=txtTechNextPkk.ClientID%>,#<%=txtTechLastInvoicedPkk.ClientID%>,#<%=txtEcoCreditDate.ClientID%>,#<%=txtEcoInvoiceDate.ClientID%>,#<%=txtEcoRebuy.ClientID%>').datepicker({
                showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                //buttonImageOnly: true,
                //buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1"

            });
           $('#btnEmptyScreen').on('click', function (e) {
                $('#aspnetForm')[0].reset();
                $('#<%=btnAddAnnotation.ClientID()%>').removeClass('warningAN');
                $('#<%=btnAddNote.ClientID()%>').removeClass('warningAN');
                
            });
            //$("#btnEmptyScreen").datepicker($.datepicker.regional["no"]);
            //alert('heisan');

            //$('#btnFetchMVR').on('click', function (e) {
            //    e.preventDefault();
            //});

            $('#btnSaveVehicle').on('click', function () {
                     var vehType = "";
                     var vehStatus = "";
                     var model = "";
                     var machineHrs = "";
                     var usedImported = "";
                     var pressureMechBrakes = "";
                     var towbar = "";
                     var serviceBook = "";
                     var callInToService = "";
                     var doNotCallPKK = "";


                 if ($('#<%=ddlVehType.ClientID%> :selected')[0].value != "-1") {
                     vehType = $('#<%=ddlVehType.ClientID%> :selected')[0].value;
                 }
                 if ($('#<%=ddlVehStatus.ClientID%> :selected')[0].value != "-1") {
                     vehStatus = $('#<%=ddlVehStatus.ClientID%> :selected')[0].value;
                 }
                 if ($('#<%=cmbModelForm.ClientID%>')[0].selectedIndex != "0") {
                     model = $('#<%=cmbModelForm.ClientID%>').val();
                 }
                    <%-- if ($('#<%=cmbModelForm.ClientID%> :selected')[0].value != "-1") {
                         model = $('#<%=cmbModelForm.ClientID%> :selected')[0].value;
                 }--%>
                     machineHrs = $('#<%=cbMachineHours.ClientID%>')[0].checked;
                     usedImported = $('#<%=cbTechUsedImported.ClientID%>')[0].checked;
                     pressureMechBrakes = $('#<%=cbTechPressureMechBrakes.ClientID%>')[0].checked;
                     towbar = $('#<%=cbTechTowbar.ClientID%>')[0].checked;
                     serviceBook = $('#<%=cbTechServiceBook.ClientID%>')[0].checked;
                     callInToService = $('#<%=cbTechCallInService.ClientID%>')[0].checked;
                     doNotCallPKK = $('#<%=cbTechDoNotCallPkk.ClientID%>')[0].checked;   
               
                     $.ajax({

                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         url: "frmVehicleDetail.aspx/AddVehicle",
                         data: "{refNo: '" + $('#<%=txtIntNo.ClientID%>').val() + "', regNo:'" + $('#<%=txtRegNo.ClientID%>').val() + "', chassi_vin:'" + $('#<%=txtVinNo.ClientID%>').val() + "', vehType:'" + vehType + "', vehStatus:'" + vehStatus + "', makeCode:'" + $('#<%=drpMakeCodes.ClientID%> :selected')[0].text + "', model:'" + model + "', vehicleType:'" + $('#<%=txtVehicleType.ClientID%>').val() + "', annotation:'" + $('#<%=txtGeneralAnnotation.ClientID%>').val() + "', note:'" + $('#<%=txtGeneralNote.ClientID%>').val() + "', modelYear:'" + $('#<%=txtModelyr.ClientID%>').val() + "', regYear:'" + $('#<%=txtRegyr.ClientID%>').val() + "', regDate:'" + $('#<%=txtRegDate.ClientID%>').val() + "', regDateNor:'" + $('#<%=txtRegDateNorway.ClientID%>').val() + "', lastRegDate:'" + $('#<%=txtLastRegDate.ClientID%>').val() + "', deregDate:'" + $('#<%=txtDeregDate.ClientID%>').val() + "', color:'" + $('#<%=txtColor.ClientID%>').val() + "', mileage:'" + $('#<%=txtMileage.ClientID%>').val() + "', mileageDate:'" + $('#<%=txtMileageDate.ClientID%>').val() + "', hours:'" + $('#<%=txtHours.ClientID%>').val() + "', hoursDate:'" + $('#<%=txtHoursDate.ClientID%>').val() + "', machineHrs:'" + machineHrs + "', category:'" + $('#<%=txtCategory.ClientID%>').val() + "', modelType:'" + $('#<%=txtType.ClientID%>').val() + "', warrantyCode:'" + $('#<%=drpWarrantyCode.ClientID%>').val() + "', netWeight:'" + $('#<%=txtNetWeight.ClientID%>').val() + "', totWeight:'" + $('#<%=txtTotWeight.ClientID%>').val() + "', projNo:'" + $('#<%=txtProjectNo.ClientID%>').val() + "', lastContDate:'" + $('#<%=txtLastContactDate.ClientID%>').val() + "', practicalLoad:'" + $('#<%=txtPracticalLoad.ClientID%>').val() + "', maxRoofLoad:'" + $('#<%=txtMaxRoofLoad.ClientID%>').val() + "', earlrRegNo1:'" + $('#<%=txtEarlyRegNo1.ClientID%>').val() + "', earlrRegNo2:'" + $('#<%=txtEarlyRegNo2.ClientID%>').val() + "', earlrRegNo3:'" + $('#<%=txtEarlyRegNo3.ClientID%>').val() + "', earlrRegNo4:'" + $('#<%=txtEarlyRegNo4.ClientID%>').val() + "', vehGroup:'" + $('#<%=txtTechVehGrp.ClientID%>').val() + "', pickNo:'" + $('#<%=txtTechPick.ClientID%>').val() + "', makeCodeNo:'" + $('#<%=txtTechMake.ClientID%>').val() + "', ricambiNo:'" + $('#<%=txtTechRicambiNo.ClientID%>').val() + "', engineNo:'" + $('#<%=txtTechEngineNo.ClientID%>').val() + "', fuelCode:'" + $('#<%=txtTechFuelCode.ClientID%>').val() + "', fuelCard:'" + $('#<%=txtTechFuelCard.ClientID%>').val() + "', gearBox:'" + $('#<%=txtTechGearBox.ClientID%>').val() +
                         "', wareHouse:'" + $('#<%=txtTechWarehouse.ClientID%>').val() + "', keyNo:'" + $('#<%=txtTechKeyNo.ClientID%>').val() + "', doorKeyNo:'" + $('#<%=txtTechDoorKeyNo.ClientID%>').val() + "', controlForm:'" + $('#<%=txtTechControlForm.ClientID%>').val() + "', interiorCode:'" + $('#<%=txtTechInteriorCode.ClientID%>').val() + "', purchaseNo:'" + $('#<%=txtTechPurchaseNo.ClientID%>').val() + "', addonGroup:'" + $('#<%=txtTechAddonGrp.ClientID%>').val() +
                         "', dateExpectedIn:'" + $('#<%=txtTechDateExpectedIn.ClientID%>').val() + "', tires:'" + $('#<%=txtTechTireInfo.ClientID%>').val() + "', serviceCategory:'" + $('#<%=txtTechServiceCategory.ClientID%>').val() + "', noApprovalNo:'" + $('#<%=txtTechApprovalNo.ClientID%>').val() + "', euApprovalNo:'" + $('#<%=txtTechEUApprovalNo.ClientID%>').val() + "', vanNo:'" + $('#<%=txtTechVanNo.ClientID%>').val() + "', productNo:'" + $('#<%=txtTechProductNo.ClientID%>').val() +
                         "', elCode:'" + $('#<%=txtTechElCode.ClientID%>').val() + "', takenInDate:'" + $('#<%=txtTechTakenInDate.ClientID%>').val() + "', takenInDateMileage:'" + $('#<%=txtTechMileageTakenIn.ClientID%>').val() + "', deliveryDate:'" + $('#<%=txtTechDeliveryDate.ClientID%>').val() + "', deliveryDateMileage:'" + $('#<%=txtTechMileageDelivered.ClientID%>').val() + "', serviceDate:'" + $('#<%=txtTechServiceDate.ClientID%>').val() + "', serviceDateMileage:'" + $('#<%=txtTechMileageService.ClientID%>').val() + "', callInDate:'" + $('#<%=txtTechCallInDate.ClientID%>').val() + "', callInDateMileage:'" + $('#<%=txtTechMileageCallIn.ClientID%>').val() + "', cleanedDate:'" + $('#<%=txtTechCleanedDate.ClientID%>').val() +
                         "', techdocNo:'" + $('#<%=txtTechTechdocNo.ClientID%>').val() + "', length:'" + $('#<%=txtTechLength.ClientID%>').val() + "', width:'" + $('#<%=txtTechWidth.ClientID%>').val() + "', noise:'" + $('#<%=txtTechNoise.ClientID%>').val() + "', effectkW:'" + $('#<%=txtTechEffect.ClientID%>').val() + "', pistonDisp:'" + $('#<%=txtTechPistonDisp.ClientID%>').val() + "', rounds:'" + $('#<%=txtTechRoundperMin.ClientID%>').val() + "', usedImported:'" + usedImported + "', pressureMechBrakes:'" + pressureMechBrakes + "', towbar:'" + towbar + "', serviceBook:'" + serviceBook + "', lastPKKApproved:'" + $('#<%=txtTechLastPkkOk.ClientID%>').val() + "', nextPKK:'" + $('#<%=txtTechNextPkk.ClientID%>').val() +
                         "', lastPKKInvoiced:'" + $('#<%=txtTechLastInvoicedPkk.ClientID%>').val() + "', callInToService:'" + callInToService + "', callInMonth:'" + $('#<%=txtTechCallInMonth.ClientID%>').val() + "', techMileage:'" + $('#<%=txtTechMileage.ClientID%>').val() + "', doNotCallPKK:'" + doNotCallPKK + "', deviationPKK:'" + $('#<%=txtTechDeviationsPkk.ClientID%>').val() + "', yearlyMileage:'" + $('#<%=txtTechYearlyMileage.ClientID%>').val() + "', radioCode:'" + $('#<%=txtTechRadioCode.ClientID%>').val() + "', startImmobilizer:'" + $('#<%=txtTechStartImmobilizer.ClientID%>').val() + "', qtyKeys:'" + $('#<%=txtTechQtyKeys.ClientID%>').val() + "', keyTag:'" + $('#<%=txtTechKeyTag.ClientID%>').val() +
                         "', salesPriceNet:'" + $('#<%=txtEcoSalespriceNet.ClientID%>').val() + "', salesSale:'" + $('#<%=txtEcoSalesSale.ClientID%>').val() + "', salesEquipment:'" + $('#<%=txtEcoSalesEquipment.ClientID%>').val() + "', regCosts:'" + $('#<%=txtEcoRegCost.ClientID%>').val() + "', discount:'" + $('#<%=txtEcoDiscount.ClientID%>').val() + "', netSalesPrice:'" + $('#<%=txtEcoNetSalesPrice.ClientID%>').val() + "', fixCost:'" + $('#<%=txtEcoFixCost.ClientID%>').val() + "', assistSales:'" + $('#<%=txtEcoAssistSales.ClientID%>').val() + "', costAfterSale:'" + $('#<%=txtEcoCostAfterSale.ClientID%>').val() + "', contributionsToday:'" + $('#<%=txtEcoContributionsToday.ClientID%>').val() + "', salesPriceGross:'" + $('#<%=txtEcoSalesPriceGross.ClientID%>').val() + "', regFee:'" + $('#<%=txtEcoRegFee.ClientID%>').val() + "', vat:'" + $('#<%=txtEcoVat.ClientID%>').val() + "', totAmount:'" + $('#<%=txtEcoVehTotAmount.ClientID%>').val() + "', wreckingAmount:'" + $('#<%=txtEcoWreckingAmount.ClientID%>').val() + "', yearlyFee:'" + $('#<%=txtEcoYearlyFee.ClientID%>').val() + "', insurance:'" + $('#<%=txtEcoInsurance.ClientID%>').val() + "', costPriceNet:'" + $('#<%=txtEcoCostPriceNet.ClientID%>').val() + "', insuranceBonus:'" + $('#<%=txtEcoInsuranceBonus.ClientID%>').val() + "', costSales:'" + $('#<%=txtEcoInntakeSaler.ClientID%>').val() + "', costBeforeSale:'" + $('#<%=txtEcoCostBeforeSale.ClientID%>').val() + "', salesProvision:'" + $('#<%=txtEcoSalesProvision.ClientID%>').val() + "', commitDay:'" + $('#<%=txtEcoCommitDay.ClientID%>').val() + "', addedInterests:'" + $('#<%=txtEcoAddedInterests.ClientID%>').val() + "', costEquipment:'" + $('#<%=txtEcoCostEquipment.ClientID%>').val() + "', totalCost:'" + $('#<%=txtEcoTotalCost.ClientID%>').val() +
                         "', creditNoteNo:'" + $('#<%=txtEcoCreditNote.ClientID%>').val() + "', creditNoteDate:'" + $('#<%=txtEcoCreditDate.ClientID%>').val() + "', invoiceNo:'" + $('#<%=txtEcoInvoiceNo.ClientID%>').val() + "', invoiceDate:'" + $('#<%=txtEcoInvoiceDate.ClientID%>').val() + "', rebuyDate:'" + $('#<%=txtEcoRebuy.ClientID%>').val() + "', rebuyPrice:'" + $('#<%=txtEcoRebuyPrice.ClientID%>').val() + "', costPerKm:'" + $('#<%=txtEcoCostKm.ClientID%>').val() + "', turnover:'" + $('#<%=txtEcoTurnover.ClientID%>').val() + "', progress:'" + $('#<%=txtEcoProgress.ClientID%>').val() +
                         "', axle1:'" + $('#<%=txtTraAxle1.ClientID%>').val() + "', axle2:'" + $('#<%=txtTraAxle2.ClientID%>').val() + "', axle3:'" + $('#<%=txtTraAxle3.ClientID%>').val() + "', axle4:'" + $('#<%=txtTraAxle4.ClientID%>').val() + "', axle5:'" + $('#<%=txtTraAxle5.ClientID%>').val() + "', axle6:'" + $('#<%=txtTraAxle6.ClientID%>').val() + "', axle7:'" + $('#<%=txtTraAxle7.ClientID%>').val() + "', axle8:'" + $('#<%=txtTraAxle8.ClientID%>').val() + "', trailerDesc:'" + $('#<%=txtTraDesc.ClientID%>').val() +
                         "', tireDimFront:'" + $('#<%=txtCertTireDimFront.ClientID%>').val() + "', tireDimBack:'" + $('#<%=txtCertTireDimBack.ClientID%>').val() + "', minliFront:'" + $('#<%=txtCertLiFront.ClientID%>').val() + "', minliBack:'" + $('#<%=txtCertLiBack.ClientID%>').val() + "', minInpressFront:'" + $('#<%=txtCertMinInpressFront.ClientID%>').val() + "', minInpressBack:'" + $('#<%=txtCertMinInpressBack.ClientID%>').val() + "', stdRimFront:'" + $('#<%=txtCertRimFront.ClientID%>').val() + "', stdRimBack:'" + $('#<%=txtCertRimBack.ClientID%>').val() + "', minSpeedFront:'" + $('#<%=txtCertminSpeedFront.ClientID%>').val() + "', minSpeedBack:'" + $('#<%=txtCertMinSpeedBack.ClientID%>').val() + "', maxTrackFront:'" + $('#<%=txtCertMaxWidthFront.ClientID%>').val() + "', maxTrackBack:'" + $('#<%=txtCertMaxWidthBack.ClientID%>').val() + "', axlePressureFront:'" + $('#<%=txtCertAxlePressureFront.ClientID%>').val() + "', axlePressureBack:'" + $('#<%=txtCertAxlePressureBack.ClientID%>').val() + "', qtyAxles:'" + $('#<%=txtCertAxleQty.ClientID%>').val() + "', operativeAxles:'" + $('#<%=txtCertAxleWithTraction.ClientID%>').val() + "', driveWheel:'" + $('#<%=txtCertGear.ClientID%>').val() + "', trailerWithBrakes:'" + $('#<%=txtCertTrailerWeightBrakes.ClientID%>').val() + "', trailerWeight:'" + $('#<%=txtCertTrailerWeight.ClientID%>').val() + "', maxLoadTowbar:'" + $('#<%=txtCertWeightTowbar.ClientID%>').val() + "', lengthToTowbar:'" + $('#<%=txtCertLengthTowbar.ClientID%>').val() + "', totalTrailerWeight:'" + $('#<%=txtCertTotalTrailerWeight.ClientID%>').val() + "', seats:'" + $('#<%=txtCertSeats.ClientID%>').val() + "', validFrom:'" + $('#<%=txtCertValidFrom.ClientID%>').val() + "', euVersion:'" + $('#<%=txtCertEuVersion.ClientID%>').val() + "', euVariant:'" + $('#<%=txtCertEuVariant.ClientID%>').val() + "', euronorm:'" + $('#<%=txtCertEuronorm.ClientID%>').val() + "', co2Emission:'" + $('#<%=txtCertCo2Emission.ClientID%>').val() + "', makeParticleFilter:'" + $('#<%=txtCertMakeParticleFilter.ClientID%>').val() + "', chassiText:'" + $('#<%=txtCertChassi.ClientID%>').val() + "', identity:'" + $('#<%=txtCertIdentity.ClientID%>').val() + "', certificate:'" + $('#<%=txtCertCertificate.ClientID%>').val() + "', certificateAnnotation:'" + $('#<%=txtCertNotes.ClientID%>').val() + "', idCustomer:'" + $('#<%=txtCustNo.ClientID%>').val() + "', idVatCode:'" + $('#<%=ddlVatCode.ClientID%>').val()+ "'}",
                     dataType: "json",
                     success: function (data) {
                         if (data.d[0] == "INSFLG") {
                             var res = GetMultiMessage('MSG126', '', '');
                             //alert(res);
                             systemMSG('success', 'Kjøretøydetaljer ble lagret', 4000);
                             $('#<%=txtIntNo.ClientID%>').val(data.d[2]);
                             var idVehSeq = data.d[1].toString();
                             if (window.parent != undefined && window.parent != null && window.parent.length > 0) {
                                 var idModel;
                                 var make = $('#<%=drpMakeCodes.ClientID%>').val();
                                 var model = $('#<%=cmbModelForm.ClientID%> :selected')[0].innerText;

                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtRegNo').value = $('#<%=txtRegNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtVIN').value = $('#<%=txtVinNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtMileage').value = $('#<%=txtMileage.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtHours').value = $('#<%=txtHours.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtInternalNo').value = $('#<%=txtIntNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_ddlMake').value = $('#<%=drpMakeCodes.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchVeh').value = idVehSeq;

                                 if ($("#<%=txtCustNo.ClientID%>").val().length > 0) {
                                     window.parent.FillCustDet($("#<%=txtCustNo.ClientID%>").val());
                                 }

                                 idModel = $('#<%=cmbModelForm.ClientID%>').val();
                                 //FetchModelId(make, model);
                                 window.parent.document.getElementById('ctl00_cntMainPanel_ddlModel').value = idModel;

                                 //window.opener.document.getElementById('ctl00_cntMainPanel_ddlModel option:contains("' + $('#<%=cmbModelForm.ClientID%> :selected')[0].innerText + '")');//.attr('selected', 'selected');
                                 // window.self.close();
                                 window.parent.$('.ui-dialog-content:visible').dialog('close');
                             }
                         }          
                         else if (data.d[0] == "UPDFLG") {
                             var res = GetMultiMessage('UPDATED', '', '');
                             //alert(res);
                             systemMSG('success', 'Kjøretøydetaljer ble oppdatert', 4000);
                             var idVehSeq = data.d[1].toString();
                             // $('#<%=txtIntNo.ClientID%>').val(data.d[2]);
                             if (window.parent != undefined && window.parent != null && window.parent.length > 0) {
                                 var idModel;
                                 var make = $('#<%=drpMakeCodes.ClientID%>').val();
                                 var model = $('#<%=cmbModelForm.ClientID%> :selected')[0].innerText;

                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtRegNo').value = $('#<%=txtRegNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtVIN').value = $('#<%=txtVinNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtMileage').value = $('#<%=txtMileage.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtHours').value = $('#<%=txtHours.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtInternalNo').value = $('#<%=txtIntNo.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_ddlMake').value = $('#<%=drpMakeCodes.ClientID%>').val();
                                 window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchVeh').value = idVehSeq;

                                 if ($("#<%=txtCustNo.ClientID%>").val().length > 0) {
                                     window.parent.FillCustDet($("#<%=txtCustNo.ClientID%>").val());
                                 }

                                 idModel = $('#<%=cmbModelForm.ClientID%>').val();
                                 //FetchModelId(make, model);
                                 window.parent.document.getElementById('ctl00_cntMainPanel_ddlModel').value = idModel;
                                 window.parent.$('.ui-dialog-content:visible').dialog('close');
                             }
                         }
                     },
                     error: function (result) {
                         alert("Error");
                     }
                 });

                 });
            function FetchModelId(make, model) {
                var modelId = "";

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmVehicleDetail.aspx/FetchModel",
                    data: "{'IdMake':'" + make + "','Model':'" + model + "'}",
                    //data: {},
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        modelId = data.d.toString();
                    }
                });

                return modelId;
            }

            function loadMakeCode() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadMakeCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpMakeCodes.ClientID%>').empty();
                        $('#<%=drpMakeCodes.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpMakeCodes.ClientID%>').append($("<option></option>").val(value.Id_Make_Veh).html(value.MakeName));

                             });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function loadModel()
            {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadModel",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //debugger;
                        Result = Result.d;
                        $('#<%=cmbModelForm.ClientID%>').empty();
                        $('#<%=cmbModelForm.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        $.each(Result, function (key, value) {
                            $('#<%=cmbModelForm.ClientID%>').append($("<option></option>").val(value.Id_Model).html(value.Model_Desc));
                            $('#<%=cmbModelForm.ClientID%>')[0].selectedIndex = 1;
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function loadVatCode()
            {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadVatCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        
                        Result = Result.d;
                        $('#<%=ddlVatCode.ClientID%>').empty();
                        
                        
                        $.each(Result, function (key, value) {
                            
                            $('#<%=ddlVatCode.ClientID%>').append($("<option></option>").val(value.vatCode).html(value.vatDesc));
                            $('#<%=ddlVatCode.ClientID%>')[0].selectedIndex = 0;
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function loadNewUsedCode() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadNewUsedCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlVehicleType.ClientID%>').empty();
                        $('#<%=ddlVehType.ClientID%>').empty();
                        $('#<%=ddlVehType.ClientID%>').prepend("<option value='-1'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=ddlVehicleType.ClientID%>').append($("<option></option>").val(value.RefnoCode).html(value.RefnoDescription));
                            $('#<%=ddlVehType.ClientID%>').append($("<option></option>").val(value.RefnoCode).html(value.RefnoDescription));

                        });
                        $('#<%=txtRefNoCreate.ClientID%>').val(value.refno);

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }
            //Fetches the refno value based on the selected new/used value with a standard of value 2 which is "brukt bil"
            function getNewUsedRefNo() {

                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/GetNewUsedRefNo",
                    data: '{refNo: ' + $('#<%=ddlVehicleType.ClientID%> option:selected').val() + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $.each(Result.d, function (key, value) {
                            $('#<%=txtRefNoCreate.ClientID%>').val(value.RefnoPrefix + value.RefnoCount);
                        })
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //Fetches the refno value based on the selected new/used value with a standard of value 2 which is "brukt bil"
            function setNewUsedRefNo() {

                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/SetNewUsedRefNo",
                    data: '{refNoType: ' + $('#<%=ddlVehType.ClientID%> option:selected').val() + 'refNo: ' + $('#<%=txtIntNo.ClientID%>').val() + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $.each(Result.d, function (key, value) {
                            $('#<%=txtIntNo.ClientID%>').val(value.RefnoPrefix + value.RefnoCount);
                        })
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //updates and fetches the correct refno value based on the selected new/used value with a standard of value 2 which is "brukt bil"
            $('#<%=txtRefNoCreate.ClientID%>').on('blur', function () {
                
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/FetchVehicleDetails",
                    data: "{'refNo':'" + $('#<%=txtRefNoCreate.ClientID%>').val() + "', 'regNo':'" + '' + "', 'vehId':'" + '' + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == null) {
                            console.log('OK');
                        } else {
                            console.log('Error');
                            $('.overlayHide').removeClass('ohActive');
                            $('#modNewVehicle').addClass('hidden');
                            $('#mceMSG').html('Refnr er allerede i bruk på et kjøretøy ' + data.d[0].VehRegNo + ' ' + data.d[0].Make + ' ' + data.d[0].Id_Veh_Seq + ', vil du åpne kjøretøy for redigering eller vil du prøve et annet nummer?')
                            $('#modVehicleExists').modal('setting', {
                                autofocus: false,
                                onShow: function () {
                                },
                                onDeny: function () {
                                    $('.overlayHide').addClass('ohActive');
                                    $('#modNewVehicle').removeClass('hidden');
                                    $('#<%=txtRefNoCreate.ClientID%>').val('');
                                    $('#<%=txtRefNoCreate.ClientID%>').focus();
                                },
                                onApprove: function () {
                                    FetchVehicleDetails(data.d[0].VehRegNo, '','','');
                                }
                            }).modal('show');
                        }
                    }
                });
            });
        

            //on selected change on new/used, it sends the correct value to get the new refno to the new added vehicle.
            $('#<%=ddlVehicleType.ClientID%>').on('change', function () {
                //alert(this.value); // or $(this).val()
                getNewUsedRefNo($(this).val());
            });

            function loadStatusCode() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadStatusCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlVehicleStatus.ClientID%>').empty();
                        $('#<%=ddlVehStatus.ClientID%>').empty();
                        $('#<%=ddlVehStatus.ClientID%>').prepend("<option value='-1'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=ddlVehicleStatus.ClientID%>').append($("<option></option>").val(value.StatusCode).html(value.StatusDesc));
                                 $('#<%=ddlVehStatus.ClientID%>').append($("<option></option>").val(value.StatusCode).html(value.StatusDesc));
                             });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                 }

            function loadWarrantyCode() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadWarrantyCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpWarrantyCode.ClientID%>').empty();
                        $('#<%=drpWarrantyCode.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpWarrantyCode.ClientID%>').append($("<option></option>").val(value.WarrantyCodes).html(value.WarrantyDesc));

                             });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function loadCustomerGroup() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadCustomerGroup",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpCustGroup.ClientID%>').empty();
                        $('#<%=drpCustGroup.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpCustGroup.ClientID%>').append($("<option></option>").val(value.ID_CUST_GROUP).html(value.ID_CUST_GROUP_DESC));

                             });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                     }

            function FetchMVR() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/FetchMVRDetails",
                    data: "{regNo: '" + $('#<%=txtRegNo.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            
                            var vehModel = data.d[0].Model;
                            var vehType = data.d[0].VehType;
                            var modelType = vehModel;
                            <%--$('#<%=drpMakeCodes.ClientID%>').val(data.d[0].MakeCode);--%>
                            //$('#<%=drpMakeCodes.ClientID%> option:contains("' + data.d[0].Make + '")').attr('selected', 'selected');
                            $('#<%=drpMakeCodes.ClientID%>').val(data.d[0].MakeCode);
                                 $('#<%=txtGeneralMake.ClientID%>').val(data.d[0].Make);
                                 $('#<%=txtVehicleType.ClientID%>').val(modelType);


                                 /*Issue #22. Setting correct regdate based on 2 fields from MVR that needs to be split to work properly*/
                                 if (data.d[0].RegYear) { }
                                 var reg = data.d[0].RegYear;
                                 //alert(d);
                                 var lengthCheck = reg.toString().length;
                                 //alert(lengthCheck);
                                 if (lengthCheck == 1) {
                                     var month = '01';
                                     var day = '01';
                                     //alert(day + " " + month);
                                     $('#<%=txtRegDate.ClientID%>').val(day + '.' + month + '.' + data.d[0].ModelYear);
                                 }
                                 if (lengthCheck == 3) {
                                     var month = '0' + reg.toString().substring(0, 1);
                                     var day = reg.toString().substring(1, 3);
                                     //alert(day + " " + month);
                                     $('#<%=txtRegDate.ClientID%>').val(day + '.' + month + '.' + data.d[0].ModelYear);
                                 }
                                 if (lengthCheck == 4) {
                                     var month = reg.toString().substring(0, 2);
                                     var day = reg.toString().substring(2, 4);
                                     //alert(day + " " + month);
                                     $('#<%=txtRegDate.ClientID%>').val(day + '.' + month + '.' + data.d[0].ModelYear);
                                 }

                                 //$('#<%=txtRegDate.ClientID%>').val(data.d[0].RegYear + "." + data.d[0].ModelYear);
                                 $('#<%=txtDeregDate.ClientID%>').val(data.d[0].DeRegDate);
                                 $('#<%=txtTotWeight.ClientID%>').val(data.d[0].TotalWeight);
                                 $('#<%=txtNetWeight.ClientID%>').val(data.d[0].NetWeight);
                                 $('#<%=txtRegDateNorway.ClientID%>').val(data.d[0].RegDateNorway);
                                 $('#<%=txtLastRegDate.ClientID%>').val(data.d[0].LastRegDate);
                                 $('#<%=txtRegyr.ClientID%>').val(data.d[0].ModelYear);
                                 $('#<%=txtModelyr.ClientID%>').val(data.d[0].ModelYear);
                                 $('#<%=txtColor.ClientID%>').val(data.d[0].Color);
                                 $('#<%=txtTechVin.ClientID%>').val(data.d[0].VehVin);
                                 $('#<%=txtVinNo.ClientID%>').val(data.d[0].VehVin);
                                 $('#<%=txtType.ClientID%>').val(vehType);
                                 $('#<%=txtMaxRoofLoad.ClientID%>').val(data.d[0].Max_Rf_Load);
                                 //input data to techincal tab
                                 $('#<%=txtTechMake.ClientID%>').val(data.d[0].MakeCode);
                                 $('#<%=txtTechMakeName.ClientID%>').val(data.d[0].Make);
                                 $('#<%=txtTechGearBox.ClientID%>').val(data.d[0].GearBox_Desc);
                                 $('#<%=txtTechEUApprovalNo.ClientID%>').val(data.d[0].EU_Main_Num);
                                 $('#<%=txtTechVehGrp.ClientID%>').val(data.d[0].VehGrp);
                                 if ($('#<%=txtTechVehGrp.ClientID%>').val() == '101') {
                                     $('#<%=txtTechVehGrpName.ClientID%>').val('Personbil');
                             }
                             $('#<%=txtTechFuelCode.ClientID%>').val(data.d[0].FuelType);
                                 if ($('#<%=txtTechFuelCode.ClientID%>').val() == '1') {
                                     $('#<%=txtTechFuelName.ClientID%>').val('Bensin');
                                 $('#<%=txtWebFuelType.ClientID%>').val('Bensin');
                             }
                             else if ($('#<%=txtTechFuelCode.ClientID%>').val() == '2') {
                                 $('#<%=txtTechFuelName.ClientID%>').val('Diesel');
                             $('#<%=txtWebFuelType.ClientID%>').val('Diesel');
                         }
                     $('#<%=txtTechEngineNo.ClientID%>').val(data.d[0].EngineNum);
                                 $('#<%=txtTechNextPkk.ClientID%>').val(data.d[0].NxtPKK_Date);
                                 $('#<%=txtTechLastPkkOk.ClientID%>').val(data.d[0].LastPKK_AppDate);
                                 $('#<%=txtTechApprovalNo.ClientID%>').val(data.d[0].ApprovalNo);
                                 $('#<%=txtTechLength.ClientID%>').val(data.d[0].Length);
                                 $('#<%=txtTechWidth.ClientID%>').val(data.d[0].Width);
                                 $('#<%=txtTechNoise.ClientID%>').val(data.d[0].Noise_On_Veh);
                                 $('#<%=txtTechEffect.ClientID%>').val(data.d[0].EngineEff);
                                 $('#<%=txtTechPistonDisp.ClientID%>').val(data.d[0].PisDisplacement);
                                 $('#<%=txtTechRoundperMin.ClientID%>').val(data.d[0].Rounds);
                                 //input data into web tab
                                 $('#<%=txtWebMake.ClientID%>').val(data.d[0].Make);
                                 $('#<%=txtWebModel.ClientID%>').val(data.d[0].Model);
                                 $('#<%=txtWebGearBox.ClientID%>').val(data.d[0].GearBox_Desc);
                                 $('#<%=txtWebModelYear.ClientID%>').val(data.d[0].ModelYear);
                                 $('#<%=txtWebMainColor.ClientID%>').val(data.d[0].Color);
                                 $('#<%=txtWebRegDate.ClientID%>').val(data.d[0].RegDateNorway);
                                 $('#<%=txtWebChassi.ClientID%>').val(data.d[0].Chassi_Desc);
                                 $('#<%=txtWebRegNo.ClientID%>').val(data.d[0].VehRegNo);
                                 $('#<%=txtWebSeatQty.ClientID%>').val(data.d[0].Veh_Seat);
                                 //Calculates the BHP based on the kW in Tech Page
                                 if ($('#<%=txtTechEffect.ClientID%>').val() != '') {
                                     $('#<%=txtWebBHP.ClientID%>').val(Math.round(parseInt($('#<%=txtTechEffect.ClientID%>').val()) * '1.36'));
                             }
                                 //input data into certificate tab
                             $('#<%=txtCertTireDimFront.ClientID%>').val(data.d[0].StdTyreFront);
                                 $('#<%=txtCertTireDimBack.ClientID%>').val(data.d[0].StdTyreBack);
                                 $('#<%=txtCertLiFront.ClientID%>').val(data.d[0].MinLi_Front);
                                 $('#<%=txtCertLiBack.ClientID%>').val(data.d[0].MinLi_Back);
                                 $('#<%=txtCertMinInpressFront.ClientID%>').val(data.d[0].Min_Inpress_Front);
                                 $('#<%=txtCertMinInpressBack.ClientID%>').val(data.d[0].Min_Inpress_Back);
                                 $('#<%=txtCertRimFront.ClientID%>').val(data.d[0].Std_Rim_Front);
                                 $('#<%=txtCertRimBack.ClientID%>').val(data.d[0].Std_Rim_Back);
                                 $('#<%=txtCertminSpeedFront.ClientID%>').val(data.d[0].Min_Front);
                                 $('#<%=txtCertMinSpeedBack.ClientID%>').val(data.d[0].Min_Back);
                                 $('#<%=txtCertMaxWidthFront.ClientID%>').val(data.d[0].Max_Tyre_Width_Frnt);
                                 $('#<%=txtCertMaxWidthBack.ClientID%>').val(data.d[0].Max_Tyre_Width_Bk);
                                 $('#<%=txtCertAxlePressureFront.ClientID%>').val(data.d[0].AxlePrFront);
                                 $('#<%=txtCertAxlePressureBack.ClientID%>').val(data.d[0].AxlePrBack);
                                 $('#<%=txtCertAxleQty.ClientID%>').val(data.d[0].Axles_Number);
                                 $('#<%=txtCertAxleWithTraction.ClientID%>').val(data.d[0].Axles_Number_Traction);
                                 $('#<%=txtCertMaxRoofWeight.ClientID%>').val(data.d[0].Max_Rf_Load);
                                 $('#<%=txtCertTrailerWeightBrakes.ClientID%>').val(data.d[0].TrailerWth_Brks);
                                 $('#<%=txtCertTrailerWeight.ClientID%>').val(data.d[0].TrailerWthout_Brks);
                                 $('#<%=txtCertWeightTowbar.ClientID%>').val(data.d[0].Max_Wt_TBar);
                                 $('#<%=txtCertLengthTowbar.ClientID%>').val(data.d[0].Len_TBar);
                                 $('#<%=txtCertTotalTrailerWeight.ClientID%>').val(data.d[0].TotalWeight);
                                 $('#<%=txtCertSeats.ClientID%>').val(data.d[0].Veh_Seat);
                                 $('#<%=txtCertEuronorm.ClientID%>').val(data.d[0].EU_Norm);
                                 $('#<%=txtCertEuVariant.ClientID%>').val(data.d[0].EU_Variant);
                                 $('#<%=txtCertEuVersion.ClientID%>').val(data.d[0].EU_Version);
                                 $('#<%=txtCertCo2Emission.ClientID%>').val(data.d[0].CO2_Emission);
                                 $('#<%=txtCertChassi.ClientID%>').val(data.d[0].Chassi_Desc);
                                 $('#<%=txtCertCertificate.ClientID%>').val(data.d[0].Cert_Text);
                                 $('#<%=txtCertIdentity.ClientID%>').val(data.d[0].Identity_Annot);
                                 $('#<%=txtCertGear.ClientID%>').val(data.d[0].Wheels_Traction);
                                 $('#<%=txtCertMakeParticleFilter.ClientID%>').val(data.d[0].Make_Part_Filter);
                                 $('#<%=txtTechCleanedDate.ClientID%>').datepicker('setDate', new Date());
                             }
                             else {
                                 alert('No vehicle available in MVR service! Are you sure the registration number is correct?')
                             }
                         },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                 }
            /*Updates dropdown for makecode/name when a makecode on technical is inserted and it exist in the list.*/
            $('#<%=txtTechMake.ClientID()%>').on('blur', function () {
                $('#<%=drpMakeCodes.ClientID%>').val($('#<%=txtTechMake.ClientID()%>').val());
                
            });
            $('#<%=drpMakeCodes.ClientID%>').on('change', function () {
                $('#<%=txtTechMake.ClientID()%>').val($('#<%=drpMakeCodes.ClientID%>').val());
                
            });


            /*TabEconomy calculations*/
            $('#<%=txtEcoSalespriceNet.ClientID%>, #<%=txtEcoSalesSale.ClientID%>, #<%=txtEcoDiscount.ClientID%>').blur(function () {
                $('#<%=txtEcoNetSalesPrice.ClientID%>, #<%=txtEcoAssistSales.ClientID%>, #<%=txtEcoContributionsToday.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) + (isNaN(parseInt($('#<%=txtEcoSalesSale.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalesSale.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoDiscount.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoDiscount.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoTotalCost.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoTotalCost.ClientID%>').val())));
                $('#<%=txtEcoSalesPriceGross.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())));
                $('#<%=txtEcoVehTotAmount.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) + (isNaN(parseInt($('#<%=txtEcoRegFee.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoRegFee.ClientID%>').val())));

            });
            $('#<%=txtEcoRegFee.ClientID%>').blur(function () {
                $('#<%=txtEcoVehTotAmount.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) + (isNaN(parseInt($('#<%=txtEcoRegFee.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoRegFee.ClientID%>').val())));
            });

            $('#<%=txtEcoCostPriceNet.ClientID%>, #<%=txtEcoInsuranceBonus.ClientID%>, #<%=txtEcoInntakeSaler.ClientID%>, #<%=txtEcoSalesProvision.ClientID%>').blur(function () {
                $('#<%=txtEcoTotalCost.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoCostPriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoCostPriceNet.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoInsuranceBonus.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoInsuranceBonus.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoInntakeSaler.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoInntakeSaler.ClientID%>').val())) + (isNaN(parseInt($('#<%=txtEcoSalesProvision.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalesProvision.ClientID%>').val())));
                $('#<%=txtEcoNetSalesPrice.ClientID%>, #<%=txtEcoAssistSales.ClientID%>, #<%=txtEcoContributionsToday.ClientID%>').val((isNaN(parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalespriceNet.ClientID%>').val())) + (isNaN(parseInt($('#<%=txtEcoSalesSale.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoSalesSale.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoDiscount.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoDiscount.ClientID%>').val())) - (isNaN(parseInt($('#<%=txtEcoTotalCost.ClientID%>').val())) ? 0 : parseInt($('#<%=txtEcoTotalCost.ClientID%>').val())));
            });
            $('#<%=txtRegNoCreate.ClientID%>').focus();
        });

    </script>
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <div class="overlayHide">
        <asp:Label ID="RTlblError" runat="server" CssClass="lblErr" meta:resourcekey="RTlblErrorResource1"></asp:Label>
    </div>

    <div class="ui grid">
        <div id="tabFrame" class="sixteen wide column">
            <input type="button" id="btnGeneral" value="Generelt" class="cTab ui btn" data-tab="General" />
            <input type="button" id="btnTechnical" value="Teknisk" class="cTab ui btn" data-tab="Technical" />
            <input type="button" id="btnEconomy" value="Økonomi" class="cTab ui btn" data-tab="Economy" />
            <input type="button" id="btnCustomer" value="Kunde" class="cTab ui btn" data-tab="Customer" />
            <input type="button" id="btnHistory" value="Historie" class="cTab ui btn" data-tab="History" />
            <input type="button" id="btnDocument" value="Dokument" class="cTab ui btn" data-tab="Document" />
            <input type="button" id="btnWeb" value="Web" class="cTab ui btn" data-tab="Web" />
            <input type="button" id="btnProspect" value="Prospekt" class="cTab ui btn" data-tab="Prospect" />
            <input type="button" id="btnPoster" value="Plakat" class="cTab ui btn" data-tab="Poster" />
            <input type="button" id="btnCommunication" value="Formidling" class="cTab ui btn" data-tab="Communication" />
            <input type="button" id="btnTrailer" value="Tilhenger" class="cTab ui btn" data-tab="Trailer" />
            <input type="button" id="btnCertificate" value="Vognkort" class="cTab ui btn" data-tab="Certificate" />
            <input type="button" id="btnForm" value="Skjema" class="cTab ui btn" data-tab="Form" />
        </div>
    </div>
    <div class="ui grid">
        <div class="sixteen wide column">
            <div class="ui form">
                <div class="fields">
                    <div class="two wide field">
                        <label>
                            <asp:Label ID="lblRefNo" Text="RefNo" runat="server" meta:resourcekey="lblRefNoResource1"></asp:Label></label>
                        <asp:TextBox ID="txtIntNo" runat="server" Enabled="False" meta:resourcekey="txtIntNoResource1"></asp:TextBox>
                    </div>
                    <div class="regno char field">
                        <label>
                            <asp:Label ID="lblRegNo" Text="RegNo" runat="server" meta:resourcekey="lblRegNoResource1"></asp:Label></label>
                        <%--<input type="text" id="txtRegNo" class="texttest">--%>
                        <asp:TextBox ID="txtRegNo" runat="server" Style="text-transform: uppercase;" meta:resourcekey="txtRegNoResource1"></asp:TextBox>
                    </div>
                    <div class="one wide field">
                        <label>&nbsp;</label>
                        <div class="ui mini input">
                            <input type="button" id="btnFetchMVR" runat="server" class="ui btn mini" value="Fetch" />
                            <%--<asp:Button runat="server" value="Hent" Text="Hent" Width="50px" id="btnFetchMVR" class="ui btn" />--%>
                        </div>
                    </div>
                    <div class="three wide field">
                        <label>
                            <asp:Label ID="lblVin" Text="VIN" runat="server" meta:resourcekey="lblVinResource1"></asp:Label></label>
                        <asp:TextBox ID="txtVinNo" runat="server" Enabled="False" meta:resourcekey="txtVinNoResource1"></asp:TextBox>
                    </div>
                    <div class="one wide field">
                    </div>
                    <div class="three wide field">
                        <label id="lblCreateNewUsed" runat="server">New/Used*</label>

                        <select id="ddlVehType" runat="server" class="dropdowns" disabled="disabled">
                            <option value="-1">Velg..</option>
                            <option value="0">Nytt kjøretøy</option>
                            <option value="1">Import Bil</option>
                            <option value="2">Brukt Bil</option>
                            <option value="3">Ny Elbil</option>
                            <option value="4">Ny maskin</option>
                            <option value="5">Brukt maskin</option>
                            <option value="6">Ny Båt</option>
                            <option value="7">Brukt Båt</option>
                            <option value="8">Ny Bobil</option>
                            <option value="9">Brukt Bobil</option>
                            <option value="10">Leiebil</option>
                            <option value="11">Kommisjon brukt</option>
                            <option value="12">Kommisjon ny</option>
                        </select>

                    </div>
                    <div class="three wide field">
                        <label id="lblCreateStatus" runat="server">Status*</label>
                        <select id="ddlVehStatus" runat="server" class="dropdowns" disabled="disabled"></select>
                    </div>
                    <div class="one wide field">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modNewVehicle" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblNewVehicle" runat="server">New vehicle</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt kjøretøy</label>
                    <div class="ui small info message">
                        <p id="lblChooseStatus" runat="server">Velg bilstatus før du går videre</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form ">
                        <div class="fields">
                            <div class="eight wide field">
                                <asp:Label ID="lblRefNoCreate" Text="Refnr." runat="server" meta:resourcekey="lblRefNoCreateResource1"></asp:Label>
                                <asp:TextBox ID="txtRefNoCreate" runat="server" meta:resourcekey="txtRefNoCreateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <asp:Label ID="lblRegNoCreate" Text="Regnr." runat="server" meta:resourcekey="lblRegNoCreateResource1"></asp:Label>
                                <asp:TextBox ID="txtRegNoCreate" Style="text-transform: uppercase;" runat="server" meta:resourcekey="txtRegNoCreateResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblNewUsed" runat="server">New/Used*</label>

                                <select id="ddlVehicleType" runat="server" size="13" class="wide dropdownList">
                                    <option value="0" id="ddlItemNewVehicle">Nytt kjøretøy</option>
                                    <option value="1" id="ddlItemNewImportVehicle">Import Bil</option>
                                    <option value="2" selected="selected" id="ddlItemUsedVehicle">Brukt Bil</option>
                                    <option value="3" id="ddlItemNewElVehicle">Ny Elbil</option>
                                    <option value="4" id="ddlItemNewMachine">Ny maskin</option>
                                    <option value="5" id="ddlItemUsedMachine">Brukt maskin</option>
                                    <option value="6" id="ddlItemNewBoat">Ny Båt</option>
                                    <option value="7" id="ddlItemUsedBoat">Brukt Båt</option>
                                    <option value="8" id="ddlItemNewHouseCar">Ny Bobil</option>
                                    <option value="9" id="ddlItemUsedHouseCar">Brukt Bobil</option>
                                    <option value="10" id="ddlItemRentalVehicle">Leiebil</option>
                                    <option value="11" id="ddlItemCommisionUsed">Kommisjon brukt</option>
                                    <option value="12" id="ddlItemCommissionNew">Kommisjon ny</option>
                                </select>

                            </div>
                            <div class="eight wide field">
                                <label id="lblVehicleStatus" runat="server">Status</label>
                                <select id="ddlVehicleStatus" runat="server" size="13" class="wide dropdownList"></select>
                                <%--<asp:DropDownList ID="drpVehicleStatus" CssClass="dropdowns" runat="server"></asp:DropDownList>--%>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnNewVehicleOK" runat="server" class="ui btn wide" value="OK" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnNewVehicleCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal for sjekking av eksisterende kundenummer --%>
    <div id="modVehicleExists" class="ui modal">
        <div class="header">
            Advarsel!
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p id="mceMSG"></p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok">Se på kjøretøy</div>
            <div class="ui button cancel">Prøv nytt refnr</div>
        </div>
    </div>

    <div id="tabGeneral" class="tTab">
        <div class="ui form stackable two column grid ">
            <div class="thirteen wide column">
                <%--left column--%>

                <h3 id="lblVehicleModel" runat="server" class="ui top attached tiny header">Vehicle model:</h3>
                <div class="ui attached segment">
                    <%--vehicle model panel--%>
                    <div class="fields">
                        <div class="three wide field">
                                <label id="lblGeneralMake" runat="server">Bilmerke</label>
                                <asp:DropDownList ID="drpMakeCodes" CssClass="dropdowns" runat="server" meta:resourcekey="drpMakeCodesResource1"></asp:DropDownList>
                                <div class="hidden">
                                    <asp:TextBox ID="txtTechMakeName" runat="server" meta:resourcekey="txtTechMakeNameResource1"></asp:TextBox>
                                    <asp:TextBox ID="txtGeneralMake" runat="server" meta:resourcekey="txtGeneralMakeResource1"></asp:TextBox>
                                    <input type="button" id="btnEditMake" runat="server" class="ui btn mini" value=" + " />
                                </div>
                            </div>
                        <div class="two wide field">
                            <label id="lblMakeCode" runat="server">Fabr.kode</label>
                            <asp:TextBox ID="txtTechMake" runat="server" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                        </div>
                        <div class="six wide field">
                            <label>
                                <asp:Literal ID="lblModelType" runat="server" Text="Model type" meta:resourcekey="lblModelTypeResource1"></asp:Literal></label>
                            <asp:TextBox runat="server" ID="txtVehicleType" meta:resourcekey="txtVehicleTypeResource1"></asp:TextBox>
                        </div>
                        <div class="three wide field">
                            <label id="lblModelForm" runat="server">ModelForm</label>
                             <asp:DropDownList ID="cmbModelForm" CssClass="dropdowns" runat="server" meta:resourcekey="cmbModelFormResource1"></asp:DropDownList>
                        </div>
                        <div class="two wide field">
                        </div>
                    </div>
                </div>
                <%--end vehicle model panel--%>

                <h3 id="lblVehicleInformation" runat="server" class="ui top attached tiny header">Vehicle info:</h3>
                <div class="ui attached segment">
                    <%--vehicle info panel--%>
                    <label id="switchMachineHours" class="inHeaderCheckbox">
                        <asp:CheckBox ID="cbMachineHours" Text="Machine W/Hours" runat="server" meta:resourcekey="cbMachineHoursResource1" />
                    </label>
                    <div class="fields">
                        <div class="year char field">
                            <label id="lblModelYear" runat="server">Mod.year</label>
                            <asp:TextBox runat="server" ID="txtModelyr" meta:resourcekey="txtModelyrResource1"></asp:TextBox>
                        </div>
                        <div class="year char field">
                            <label id="lblRegYear" runat="server">Reg.year</label>
                            <asp:TextBox runat="server" ID="txtRegyr" meta:resourcekey="txtRegyrResource1"></asp:TextBox>
                        </div>
                        <div class="date char field">
                            <label id="lblRegDate" runat="server">RegDate</label>
                            <asp:TextBox runat="server" ID="txtRegDate" meta:resourcekey="txtRegDateResource1"></asp:TextBox>
                        </div>
                        <div class="date char field">
                            <label id="lblRegDateNO" runat="server">RegDate NO</label>
                            <asp:TextBox runat="server" ID="txtRegDateNorway" meta:resourcekey="txtRegDateNorwayResource1"></asp:TextBox>
                        </div>
                        <div class="date char field">
                            <label id="lblLastRegDate" runat="server">LastRegDate</label>
                            <asp:TextBox runat="server" ID="txtLastRegDate" meta:resourcekey="txtLastRegDateResource1"></asp:TextBox>
                        </div>
                        <div class="date char field">
                            <label id="lblDeregDate" runat="server">DeRegDate</label>
                            <asp:TextBox runat="server" ID="txtDeregDate" meta:resourcekey="txtDeregDateResource1"></asp:TextBox>
                        </div>
                        <div class="three wide field">
                            <label id="lblColor" runat="server">Color</label>
                            <asp:TextBox runat="server" ID="txtColor" meta:resourcekey="txtColorResource1"></asp:TextBox>
                        </div>
                        <div class="six char field">
                            <label id="lblCategory" runat="server">Category</label>
                            <asp:TextBox runat="server" ID="txtCategory" meta:resourcekey="txtCategoryResource1"></asp:TextBox>
                        </div>
                        <div class="fields">
                            <div class="mileage char field">
                                <label>
                                    <asp:Label ID="lblMileage" Text="Mileage" runat="server" CssClass="mil" meta:resourcekey="lblMileageResource1"></asp:Label>
                                    <asp:Label ID="lblHours" Text="Hours" runat="server" CssClass="hrs" meta:resourcekey="lblHoursResource1"></asp:Label>
                                </label>
                                <asp:TextBox runat="server" ID="txtMileage" CssClass="texttest mil" meta:resourcekey="txtMileageResource1"></asp:TextBox>
                                <asp:TextBox runat="server" ID="txtHours" CssClass="texttest hrs" meta:resourcekey="txtHoursResource1"></asp:TextBox>
                            </div>
                            <div class="date char field">
                                <label>
                                    <asp:Label ID="lblMileageDate" Text="Mileage Date" runat="server" CssClass="mil" meta:resourcekey="lblMileageDateResource1"></asp:Label>
                                    <asp:Label ID="lblHoursDate" Text="Hours Date" runat="server" CssClass="hrs" meta:resourcekey="lblHoursDateResource1"></asp:Label>
                                </label>
                                <asp:TextBox runat="server" ID="txtMileageDate" CssClass="texttest mil" meta:resourcekey="txtMileageDateResource1"></asp:TextBox>
                                <asp:TextBox runat="server" ID="txtHoursDate" CssClass="texttest hrs" meta:resourcekey="txtHoursDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <%--end vehicle info panel--%>

                <h3 id="lblVehicleDetails" runat="server" class="ui top attached tiny header">Vehicle details:</h3>
                <div class="ui attached segment">
                    <%--vehicle details panel--%>
                    <div class="fields">
                        <div class="four wide field">
                            <label id="lblVehicleType" runat="server">Type</label>
                            <asp:TextBox runat="server" ID="txtType" meta:resourcekey="txtTypeResource1"></asp:TextBox>
                        </div>
                        <div class="four wide field">
                            <label id="lblWarrantyCode" runat="server">Warranty Code</label>
                            <%--<asp:TextBox runat="server" ID="txtWarrantyCode" ></asp:TextBox>--%>
                            <asp:DropDownList ID="drpWarrantyCode" CssClass="dropdowns" runat="server" meta:resourcekey="drpWarrantyCodeResource1"></asp:DropDownList>
                        </div>
                        <div class="four char field">
                            <label id="lblNetWeight" runat="server">Net Weight</label>
                            <asp:TextBox runat="server" ID="txtNetWeight" meta:resourcekey="txtNetWeightResource1"></asp:TextBox>
                        </div>
                        <div class="four char field">
                            <label id="lblTotWeight" runat="server">Tot Weight</label>
                            <asp:TextBox runat="server" ID="txtTotWeight" meta:resourcekey="txtTotWeightResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="four wide field">
                            <label id="lblProjectNumber" runat="server">ProjectNo</label>
                            <asp:TextBox runat="server" ID="txtProjectNo" meta:resourcekey="txtProjectNoResource1"></asp:TextBox>
                        </div>
                        <div class="ten char field">
                            <label id="lblLastContactDate" runat="server">Last contact Date</label>
                            <asp:TextBox runat="server" ID="txtLastContactDate" meta:resourcekey="txtLastContactDateResource1"></asp:TextBox>
                        </div>
                        <div class="three wide field">
                            <label id="lblPracticalLoad" runat="server">"Nyttelast"</label>
                            <asp:TextBox runat="server" ID="txtPracticalLoad" meta:resourcekey="txtPracticalLoadResource1"></asp:TextBox>
                        </div>
                        <div class="three wide field">
                            <label id="lblMaxRoofLoad" runat="server">Maks taklast</label>
                            <asp:TextBox runat="server" ID="txtMaxRoofLoad" meta:resourcekey="txtMaxRoofLoadResource1"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <%--end vehicle details panel--%>
            </div>
            <%--end left column--%>
            <div class="three wide column">
                <%--right column--%>
                <h3 id="lblInformation" runat="server" class="ui top attached tiny header">Information:</h3>
                <div class="ui attached segment">
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" id="btnAddAnnotation" runat="server" class="ui btn wide" value="Anmerkning" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" id="btnAddNote" runat="server" class="ui btn wide" value="Notat" />
                        </div>
                    </div>
                </div>
                <h3 id="lblEarlierRegNumbers" runat="server" class="ui top attached tiny header">Earlier reg numbers:</h3>
                <div class="ui attached segment">
                    <div class="ui stackable two column grid">
                        <div class="column">
                            <div class="regno char field">
                                <label>
                                    <asp:Literal ID="liEarlyRegNo1" runat="server" meta:resourcekey="liEarlyRegNo1Resource1" Text="Early regno 1"></asp:Literal>
                                </label>
                                <asp:TextBox ID="txtEarlyRegNo1" runat="server" meta:resourcekey="txtEarlyRegNo1Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="column">
                            <div class="regno char field">
                                <label>
                                    <asp:Literal ID="liEarlyRegNo2" runat="server" meta:resourcekey="liEarlyRegNo2Resource1" Text="Early regno 2"></asp:Literal>
                                </label>
                                <asp:TextBox ID="txtEarlyRegNo2" runat="server" meta:resourcekey="txtEarlyRegNo2Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="column">
                            <div class="regno char field">
                                <label>
                                    <asp:Literal ID="liEarlyRegNo3" runat="server" meta:resourcekey="liEarlyRegNo3Resource1" Text="Early regno 3"></asp:Literal>
                                </label>
                                <asp:TextBox ID="txtEarlyRegNo3" runat="server" meta:resourcekey="txtEarlyRegNo3Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="column">
                            <div class="regno char field">
                                <label>
                                    <asp:Literal ID="liEarlyRegNo4" runat="server" meta:resourcekey="liEarlyRegNo4Resource1" Text="Early regno 4"></asp:Literal>
                                </label>
                                <asp:TextBox ID="txtEarlyRegNo4" runat="server" meta:resourcekey="txtEarlyRegNo4Resource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--End tab general--%>

    <%-- makeEdit Modal --%>
    <div id="modEditMake" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblEditMake" runat="server"></h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt kjøretøy</label>
                    <div class="ui small info message">
                        <p id="lblEditMakeStatus" runat="server">Bilmerke status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label4" runat="server">Bilmerkeliste</label>
                                <select id="drpEditMakeList" runat="server" size="13" class="wide dropdownList"></select>
                                
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeCode" Text="Fabrikatkode" runat="server" meta:resourcekey="lblEditMakeCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeCode" runat="server" meta:resourcekey="txtEditMakeCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeDescription" Text="Beskrivelse" runat="server" meta:resourcekey="lblEditMakeDescriptionResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeDescription" runat="server" meta:resourcekey="txtEditMakeDescriptionResource1"></asp:TextBox>
                                </div>
                                <div class="hidden">
				<div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakePriceCode" Text="Priskode" runat="server" meta:resourcekey="lblEditMakePriceCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakePriceCode" runat="server" meta:resourcekey="txtEditMakePriceCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeDiscount" Text="Rabatt" runat="server" meta:resourcekey="lblEditMakeDiscountResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeDiscount" runat="server" meta:resourcekey="txtEditMakeDiscountResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblEditMakeVat" Text="Mva kode" runat="server" meta:resourcekey="lblEditMakeVatResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtEditMakeVat" runat="server" meta:resourcekey="txtEditMakeVatResource1"></asp:TextBox>
                                </div>
                                </div>
                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnEditMakeNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnEditMakeDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="fields">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnEditMakeSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnEditMakeCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modGeneralAnnotation" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation</h2>
            <div class="modCloseGeneralAnnotation"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3 id="lblModAnnotation" runat="server">Annotation:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtGeneralAnnotation" TextMode="MultiLine" runat="server" meta:resourcekey="txtGeneralAnnotationResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveGeneralAnnotation" runat="server" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modGeneralNote" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblModNote" runat="server">Annotation</h2>
            <div class="modCloseGeneralNote"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Note</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtGeneralNote" TextMode="MultiLine" runat="server" meta:resourcekey="txtGeneralNoteResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" runat="server" id="btnSaveGeneralNote" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%-- New tab for Tecnical --%>
    <div id="tabTechnical" class="tTab">
        <div class="ui grid">
            <div class="twelve wide column">
                <div class="ui form">
                    <h3 id="lblTechnicalData" runat="server" class="ui top attached tiny header">Vehicle model:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblVehicleGroup" runat="server">Veh.group</label>
                                <asp:TextBox ID="txtTechVehGrp" runat="server" meta:resourcekey="txtTechVehGrpResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <asp:TextBox ID="txtTechVehGrpName" runat="server" meta:resourcekey="txtTechVehGrpNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblVinNo" runat="server">VIN No</label>
                                <asp:TextBox ID="txtTechVin" runat="server" meta:resourcekey="txtTechVinResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblPickNo" runat="server">PickNo</label>
                                <asp:TextBox ID="txtTechPick" runat="server" meta:resourcekey="txtTechPickResource1"></asp:TextBox>
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblFuelCode" runat="server">FuelCode</label>
                                <asp:TextBox ID="txtTechFuelCode" runat="server" meta:resourcekey="txtTechFuelCodeResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <asp:TextBox ID="txtTechFuelName" runat="server" meta:resourcekey="txtTechFuelNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblRicambiNo" runat="server">RicambiNo</label>
                                <asp:TextBox ID="txtTechRicambiNo" runat="server" meta:resourcekey="txtTechRicambiNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblEngineNo" runat="server">Engine No</label>
                                <asp:TextBox ID="txtTechEngineNo" runat="server" meta:resourcekey="txtTechEngineNoResource1"></asp:TextBox>
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblMomskode" runat="server">Momskode</label>
                                <asp:DropDownList ID="ddlVatCode" CssClass="dropdowns" runat="server" meta:resourcekey="ddlVatCodeResource"></asp:DropDownList>                                             
                            </div>
                            <div class="three wide field">
                                
                            </div>
                            <div class="four wide field">
                                <label id="lblFuelCard" runat="server">Fuel Card</label>
                                <asp:TextBox ID="txtTechFuelCard" runat="server" meta:resourcekey="txtTechFuelCardResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblGearbox" runat="server">Gearbox</label>
                                <asp:TextBox ID="txtTechGearBox" runat="server" meta:resourcekey="txtTechGearBoxResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <h3 id="lblDetails" class="ui top attached tiny header" runat="server">Details:</h3>

                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblWarehouseNo" runat="server">WH</label>
                                <asp:TextBox ID="txtTechWarehouse" runat="server" meta:resourcekey="txtTechWarehouseResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <asp:TextBox ID="txtTechWarehouseName" runat="server" meta:resourcekey="txtTechWarehouseNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblKeyNumber" runat="server">KeyNo</label>
                                <asp:TextBox ID="txtTechKeyNo" runat="server" meta:resourcekey="txtTechKeyNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblDoorKey" runat="server">Door key</label>
                                <asp:TextBox ID="txtTechDoorKeyNo" runat="server" meta:resourcekey="txtTechDoorKeyNoResource1"></asp:TextBox>
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblForm" runat="server">Form</label>
                                <asp:TextBox ID="txtTechControlForm" runat="server" meta:resourcekey="txtTechControlFormResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <asp:TextBox ID="txtTechFormName" runat="server" meta:resourcekey="txtTechFormNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblInterorCode" runat="server">Interior Code</label>
                                <asp:TextBox ID="txtTechInteriorCode" runat="server" meta:resourcekey="txtTechInteriorCodeResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblPurchaseOrder" runat="server">Purchase Ord.</label>
                                <asp:TextBox ID="txtTechPurchaseNo" runat="server" meta:resourcekey="txtTechPurchaseNoResource1"></asp:TextBox>
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblAddonGroup" runat="server">Addon Group</label>
                                <asp:TextBox ID="txtTechAddonGrp" runat="server" meta:resourcekey="txtTechAddonGrpResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <asp:TextBox ID="txtTechAddonName" runat="server" meta:resourcekey="txtTechAddonNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblDateExpectedIn" runat="server">Date in</label>
                                <asp:TextBox ID="txtTechDateExpectedIn" runat="server" meta:resourcekey="txtTechDateExpectedInResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTires" runat="server">Tires</label>
                                <asp:TextBox ID="txtTechTireInfo" runat="server" meta:resourcekey="txtTechTireInfoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblServiceCategory" runat="server">Serv.Cat</label>
                                <asp:TextBox ID="txtTechServiceCategory" runat="server" meta:resourcekey="txtTechServiceCategoryResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label id="lblNOApprovalNo" runat="server">NO Approval No</label>
                                <asp:TextBox ID="txtTechApprovalNo" runat="server" meta:resourcekey="txtTechApprovalNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblEUApprovalNo" runat="server">EU Approval No</label>
                                <asp:TextBox ID="txtTechEUApprovalNo" runat="server" meta:resourcekey="txtTechEUApprovalNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblVanNumber" runat="server">VAN No</label>
                                <asp:TextBox ID="txtTechVanNo" runat="server" meta:resourcekey="txtTechVanNoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="two wide field">
                            </div>
                            <div class="three wide field">
                            </div>
                            <div class="four wide field">
                                <label id="lblProductNumber" runat="server">Pr. nummer?</label>
                                <asp:TextBox ID="txtTechProductNo" runat="server" meta:resourcekey="txtTechProductNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblElCode" runat="server">El.kode?</label>
                                <asp:TextBox ID="txtTechElCode" runat="server" meta:resourcekey="txtTechElCodeResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 id="lblPkkServiceData" class="ui top attached tiny header" runat="server">PKK/Service data:</h3>
                    <div class="ui attached segment">
                        <div class="ui grid">
                            <div class="three wide column">
                                <div class="ui form">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechUsedImported" runat="server" Text="Used imported" meta:resourcekey="cbTechUsedImportedResource1" />
                                            </label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechPressureMechBrakes" runat="server" Text="Trykkluftmek. bremser" meta:resourcekey="cbTechPressureMechBrakesResource1" />
                                            </label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechTowbar" runat="server" Text="Tilhengerfeste" meta:resourcekey="cbTechTowbarResource1" />
                                            </label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechServiceBook" runat="server" Text="Servicehefte" meta:resourcekey="cbTechServiceBookResource1" />
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="three wide column">
                                <div class="ui form">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:Literal ID="liTechLastPkkOk" runat="server" Text="Last PKK Approved" meta:resourcekey="liTechLastPkkOkResource1"></asp:Literal></label>
                                            <asp:TextBox ID="txtTechLastPkkOk" runat="server" meta:resourcekey="txtTechLastPkkOkResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:Literal ID="liTechNextPkk" runat="server" Text="Next PKK" meta:resourcekey="liTechNextPkkResource1"></asp:Literal></label>
                                            <asp:TextBox ID="txtTechNextPkk" runat="server" meta:resourcekey="txtTechNextPkkResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:Literal ID="liTechLastInvoicedPkk" runat="server" Text="Last invoiced PKK" meta:resourcekey="liTechLastInvoicedPkkResource1"></asp:Literal></label>
                                            <asp:TextBox ID="txtTechLastInvoicedPkk" runat="server" meta:resourcekey="txtTechLastInvoicedPkkResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="three wide column">
                                <div class="ui form">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechCallInService" runat="server" Text="Call in to service" meta:resourcekey="cbTechCallInServiceResource1" />
                                            </label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="five wide field">
                                            <label class="centerlabel">
                                                <asp:Literal ID="liTechCallInMonth" runat="server" Text="Innkalles" meta:resourcekey="liTechCallInMonthResource1"></asp:Literal></label>
                                        </div>
                                        <div class="five wide field">
                                            <asp:TextBox ID="txtTechCallInMonth" runat="server" meta:resourcekey="txtTechCallInMonthResource1"></asp:TextBox>
                                        </div>
                                        <div class="five wide field">
                                            <asp:Label ID="lblTechCallInMonthDesc" runat="server" Text="Januar" CssClass="centerlabel" meta:resourcekey="lblTechCallInMonthDescResource1"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="five wide field">
                                            <label class="centerlabel">
                                                <asp:Literal ID="liTechMileage" runat="server" Text="Km.stand" meta:resourcekey="liTechMileageResource1"></asp:Literal></label>
                                        </div>
                                        <div class="ten wide field">
                                            <asp:TextBox ID="txtTechMileage" runat="server" meta:resourcekey="txtTechMileageResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="three wide column">
                                <div class="ui form">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <label>
                                                <asp:CheckBox ID="cbTechDoNotCallPkk" runat="server" Text="Do not call in for Pkk" meta:resourcekey="cbTechDoNotCallPkkResource1" />
                                            </label>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="eight wide field">
                                            <label class="centerlabel">
                                                <asp:Literal ID="liTechDeviationsPkk" runat="server" Text="Avvik PKK" meta:resourcekey="liTechDeviationsPkkResource1"></asp:Literal></label>
                                        </div>
                                        <div class="five wide field">
                                            <asp:TextBox ID="txtTechDeviationsPkk" runat="server" meta:resourcekey="txtTechDeviationsPkkResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="eight wide field">
                                            <label class="centerlabel">
                                                <asp:Literal ID="liTechYearlyMileage" runat="server" Text="Årlig kjørte Km." meta:resourcekey="liTechYearlyMileageResource1"></asp:Literal></label>
                                        </div>
                                        <div class="eight wide field">
                                            <asp:TextBox ID="txtTechYearlyMileage" runat="server" meta:resourcekey="txtTechYearlyMileageResource1"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="four wide column">
                <div class="ui form">
                    <h3 id="lblVehicleDateMileage" class="ui top attached tiny header" runat="server">Vehicle dates and mileage:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblTakenInDate" runat="server">Taken in Date</label>
                                <asp:TextBox ID="txtTechTakenInDate" runat="server" Columns="10" meta:resourcekey="txtTechTakenInDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblMileageTakenIn" runat="server">Mileage</label>
                                <asp:TextBox ID="txtTechMileageTakenIn" runat="server" meta:resourcekey="txtTechMileageTakenInResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblDeliveryDate" runat="server">Delivery Date</label>
                                <asp:TextBox ID="txtTechDeliveryDate" runat="server" meta:resourcekey="txtTechDeliveryDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblMileageDelivered" runat="server">Mileage</label>
                                <asp:TextBox ID="txtTechMileageDelivered" runat="server" meta:resourcekey="txtTechMileageDeliveredResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblServiceDate" runat="server">Service Date</label>
                                <asp:TextBox ID="txtTechServiceDate" runat="server" meta:resourcekey="txtTechServiceDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblMileageService" runat="server">Mileage</label>
                                <asp:TextBox ID="txtTechMileageService" runat="server" meta:resourcekey="txtTechMileageServiceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblCallInDate" runat="server">Call in Date</label>
                                <asp:TextBox ID="txtTechCallInDate" runat="server" meta:resourcekey="txtTechCallInDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblMileageCallIn" runat="server">Mileage</label>
                                <asp:TextBox ID="txtTechMileageCallIn" runat="server" meta:resourcekey="txtTechMileageCallInResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblCleanedDate" runat="server">Cleaned date</label>
                                <asp:TextBox ID="txtTechCleanedDate" runat="server" meta:resourcekey="txtTechCleanedDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblTechDocNo" runat="server">Techdoc No</label>
                                <asp:TextBox ID="txtTechTechdocNo" runat="server" meta:resourcekey="txtTechTechdocNoResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <h3 id="measuresData" runat="server" class="ui top attached tiny header">Measure data:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <label id="lblLength" runat="server">Length</label>
                                <asp:TextBox ID="txtTechLength" runat="server" meta:resourcekey="txtTechLengthResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblWidth" runat="server">Width</label>
                                <asp:TextBox ID="txtTechWidth" runat="server" meta:resourcekey="txtTechWidthResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblStdNoise" runat="server">Std. noise</label>
                                <asp:TextBox ID="txtTechNoise" runat="server" meta:resourcekey="txtTechNoiseResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label id="lblEffectKw" runat="server">Effect kW</label>
                                <asp:TextBox ID="txtTechEffect" runat="server" meta:resourcekey="txtTechEffectResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblPistonDisp" runat="server">Piston disp</label>
                                <asp:TextBox ID="txtTechPistonDisp" runat="server" meta:resourcekey="txtTechPistonDispResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblRoundMin" runat="server">Rounds/min</label>
                                <asp:TextBox ID="txtTechRoundperMin" runat="server" meta:resourcekey="txtTechRoundperMinResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 id="interiorData" class="ui top attached tiny header" runat="server">Interiør data:</h3>
                    <div class="ui attached segment">

                        <div class="ui form">
                            <div class="fields">
                                <div class="eight wide field">
                                    <label>
                                        <asp:Literal ID="liTechRadioCode" runat="server" Text="Radiokode" meta:resourcekey="liTechRadioCodeResource1"></asp:Literal></label>
                                    <asp:TextBox ID="txtTechRadioCode" runat="server" meta:resourcekey="txtTechRadioCodeResource1"></asp:TextBox>
                                </div>
                                <div class="eight wide field">
                                    <label>
                                        <asp:Literal ID="liTechStartImmobilizer" runat="server" Text="Startsperre" meta:resourcekey="liTechStartImmobilizerResource1"></asp:Literal></label>
                                    <asp:TextBox ID="txtTechStartImmobilizer" runat="server" meta:resourcekey="txtTechStartImmobilizerResource1"></asp:TextBox>
                                </div>
                            </div>
                            <div class="fields">
                                <div class="eight wide field">
                                    <label>
                                        <asp:Literal ID="liTechQtyKeys" runat="server" Text="Ant. nøkler" meta:resourcekey="liTechQtyKeysResource1"></asp:Literal></label>
                                    <asp:TextBox ID="txtTechQtyKeys" runat="server" meta:resourcekey="txtTechQtyKeysResource1"></asp:TextBox>
                                </div>
                                <div class="eight wide field">
                                    <label>
                                        <asp:Literal ID="liTechKeyTag" runat="server" Text="Nøkkeltagnr." meta:resourcekey="liTechKeyTagResource1"></asp:Literal></label>
                                    <asp:TextBox ID="txtTechKeyTag" runat="server" meta:resourcekey="txtTechKeyTagResource1"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- New tab for Economy --%>
    <div id="tabEconomy" class="tTab">
        <div class="ui grid">

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblContribution" class="ui top attached tiny header" runat="server">Bidrag:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceExVat" runat="server">Salgspris eks. mva</label>
                                <asp:TextBox ID="txtEcoSalespriceNet" runat="server" meta:resourcekey="txtEcoSalespriceNetResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesFees" runat="server">Salgs salær</label>
                                <asp:TextBox ID="txtEcoSalesSale" runat="server" meta:resourcekey="txtEcoSalesSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesEquipment" runat="server">Sale equipment</label>
                                <asp:TextBox ID="txtEcoSalesEquipment" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoSalesEquipmentResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblRegistrationCosts" runat="server">Reg omkostninger</label>
                                <asp:TextBox ID="txtEcoRegCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoRegCostResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSubtractedDiscount" runat="server">- Rabatt</label>
                                <asp:TextBox ID="txtEcoDiscount" runat="server" meta:resourcekey="txtEcoDiscountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceNet" runat="server">Netto Salgspris</label>
                                <asp:TextBox ID="txtEcoNetSalesPrice" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoNetSalesPriceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSubtractedCosts" runat="server">- Selvkost</label>
                                <asp:TextBox ID="txtEcoFixCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoFixCostResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblAssistSales" runat="server">Bidrag ved salg</label>
                                <asp:TextBox ID="txtEcoAssistSales" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoAssistSalesResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostAfterSale" runat="server">Cost after sale</label>
                                <asp:TextBox ID="txtEcoCostAfterSale" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostAfterSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblContributionToday" runat="server">Contributions today</label>
                                <asp:TextBox ID="txtEcoContributionsToday" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoContributionsTodayResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblVehiclePrice" class="ui top attached tiny header" runat="server">Bilpris:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesPriceGross" runat="server">Salgspris inkl. mva</label>
                                <asp:TextBox ID="txtEcoSalesPriceGross" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoSalesPriceGrossResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblRegistrationFee" runat="server">Reg. avgift</label>
                                <asp:TextBox ID="txtEcoRegFee" runat="server" meta:resourcekey="txtEcoRegFeeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblVatFromSalesprice" runat="server">MVA av salgspris</label>
                                <asp:TextBox ID="txtEcoVat" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoVatResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblTotalVehicleAmount" runat="server">Total bilpris</label>
                                <asp:TextBox ID="txtEcoVehTotAmount" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoVehTotAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblEquipmentAmount" runat="server">Bidrag utstyr</label>
                                <asp:TextBox ID="txtEcoEquipmentAmount" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoEquipmentAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWreckingAmount" runat="server">Vrakpant</label>
                                <asp:TextBox ID="txtEcoWreckingAmount" runat="server" meta:resourcekey="txtEcoWreckingAmountResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblYearlyFee" runat="server">Årsavgift</label>
                                <asp:TextBox ID="txtEcoYearlyFee" runat="server" meta:resourcekey="txtEcoYearlyFeeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblInsurance" runat="server">Forsikring</label>
                                <asp:TextBox ID="txtEcoInsurance" runat="server" meta:resourcekey="txtEcoInsuranceResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="two wide column">
                <div class="ui form">
                    <h3 id="lblCosts" class="ui top attached tiny header" runat="server">Selvkost:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostPriceNet" runat="server">Inntakspris eks. mva</label>
                                <asp:TextBox ID="txtEcoCostPriceNet" runat="server" meta:resourcekey="txtEcoCostPriceNetResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblInsuranceBonus" runat="server">Oppnådd bonus</label>
                                <asp:TextBox ID="txtEcoInsuranceBonus" runat="server" meta:resourcekey="txtEcoInsuranceBonusResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostFee" runat="server">Inntaks salær</label>
                                <asp:TextBox ID="txtEcoInntakeSaler" runat="server" meta:resourcekey="txtEcoInntakeSalerResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostBeforeSale" runat="server">Påkost før salg</label>
                                <asp:TextBox ID="txtEcoCostBeforeSale" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostBeforeSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblSalesProvision" runat="server">Selger provisjon</label>
                                <asp:TextBox ID="txtEcoSalesProvision" runat="server" meta:resourcekey="txtEcoSalesProvisionResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCommitDay" runat="server">Kommisjonsdager</label>
                                <asp:TextBox ID="txtEcoCommitDay" runat="server" meta:resourcekey="txtEcoCommitDayResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblAddedInterests" runat="server">Påløpte renter</label>
                                <asp:TextBox ID="txtEcoAddedInterests" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoAddedInterestsResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblCostEquipment" runat="server">Kost utstyr</label>
                                <asp:TextBox ID="txtEcoCostEquipment" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoCostEquipmentResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblTotalCost" runat="server">Selvkost</label>
                                <asp:TextBox ID="txtEcoTotalCost" runat="server" CssClass="texttest fixed" meta:resourcekey="txtEcoTotalCostResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="ui grid">
            <div class="four wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Credit note/ taken in:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Credit note No</label>
                                <asp:TextBox ID="txtEcoCreditNote" runat="server" meta:resourcekey="txtEcoCreditNoteResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnEcoShowCreditNote" class="ui btn" value="Vis" />
                            </div>
                            <div class="six wide field">
                                <label>Credit note date</label>
                                <asp:TextBox ID="txtEcoCreditDate" runat="server" meta:resourcekey="txtEcoCreditDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="four wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Invoice/ Sale:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Invoice No</label>
                                <asp:TextBox ID="txtEcoInvoiceNo" runat="server" meta:resourcekey="txtEcoInvoiceNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnEcoShowInvoice" class="ui btn" value="Vis" />
                            </div>
                            <div class="six wide field">
                                <label>Credit note date</label>
                                <asp:TextBox ID="txtEcoInvoiceDate" runat="server" meta:resourcekey="txtEcoInvoiceDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="two wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Rebuy:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="twelve wide field">
                                <label>Date</label>
                                <asp:TextBox ID="txtEcoRebuy" runat="server" meta:resourcekey="txtEcoRebuyResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="six wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Turnover:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>Rebuy price</label>
                                <asp:TextBox ID="txtEcoRebuyPrice" runat="server" meta:resourcekey="txtEcoRebuyPriceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Cost pr km.</label>
                                <asp:TextBox ID="txtEcoCostKm" runat="server" meta:resourcekey="txtEcoCostKmResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Turnover</label>
                                <asp:TextBox ID="txtEcoTurnover" runat="server" meta:resourcekey="txtEcoTurnoverResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Progress/Drift</label>
                                <asp:TextBox ID="txtEcoProgress" runat="server" meta:resourcekey="txtEcoProgressResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modNewCust" class="modal hidden">
        <div class="modHeader">
            <h2 id="H1" runat="server">New Customer</h2>
            <div class="modCloseCust"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <%-- <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Nytt kjøretøy</label>
                        <div class="ui small info message">
                            <p id="P1" runat="server">Velg bilstatus før du går videre</p>
                        </div>
                    </div>
                </div>--%>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form ">
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="Label1" Text="Søk etter kunde (Tlf, navn, sted, etc.)" runat="server" meta:resourcekey="Label1Resource1"></asp:Label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <asp:TextBox ID="txtEniro" runat="server" meta:resourcekey="txtEniroResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnEniroFetch" runat="server" class="ui mini icon input" value="Fetch" style="width: 50%" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <label id="Label3" runat="server">Customer</label>
                                <select id="CustSelect" runat="server" size="13" class="wide dropdownList">
                                </select>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--TABCUSTOMER--%>
    <div id="tabCustomer" class="tTab">
        <div class="ui grid">
            <div class="eleven wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header">Søk etter kunde:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>Customer No</label>
                                <asp:TextBox ID="txtCustNo" runat="server" data-submit="ID_CUSTOMER" meta:resourcekey="txtCustNoResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                                <label>Søk etter kunde (Tlf, navn, sted, etc.)</label>
                                <asp:TextBox ID="txtCustSearchEniro" runat="server" meta:resourcekey="txtCustSearchEniroResource1"></asp:TextBox>
                                <asp:Label ID="lblContactResults" runat="server" CssClass="lblContactResults" meta:resourcekey="lblContactResultsResource1"></asp:Label>
                            </div>
                            <div class="one wide field">
                                <label>EniroId</label>
                                <asp:Label ID="lblCustEniroId" runat="server" data-submit="CUST_ENIRO_ID" meta:resourcekey="lblCustEniroIdResource1"></asp:Label>
                            </div>
                            <div class="three wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <%--<asp:Button runat="server" Text="Fetch" ID="btnSearchEniro" CssClass="ui btn" />--%>
                                    <input type="button" id="btnSearchEniro" runat="server" value="Fetch" class="ui btn mini" />

                                </div>

                            </div>

                        </div>
                    </div>

                    <h3 class="ui top attached tiny header">Customer information:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label>First Name</label>
                                <asp:TextBox ID="txtCustFirstName" runat="server" data-submit="CUST_FIRST_NAME" meta:resourcekey="txtCustFirstNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Middle Name</label>
                                <asp:TextBox ID="txtCustMiddleName" runat="server" data-submit="CUST_MIDDLE_NAME" meta:resourcekey="txtCustMiddleNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Last Name</label>
                                <asp:TextBox ID="txtCustLastName" runat="server" data-submit="CUST_LAST_NAME" meta:resourcekey="txtCustLastNameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <input type="button" id="btnWarningMSG" class="ui btn" value="Anmerkninger?" />
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>Visiting Address</label>
                                <asp:TextBox ID="txtCustAdd1" runat="server" data-submit="CUST_PERM_ADD1" meta:resourcekey="txtCustAdd1Resource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>Zip code</label>
                                <asp:TextBox ID="txtCustVisitZip" runat="server" data-submit="ID_CUST_PERM_ZIPCODE" meta:resourcekey="txtCustVisitZipResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Place</label>
                                <asp:TextBox ID="txtCustVisitPlace" runat="server" meta:resourcekey="txtCustVisitPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>
                                    Billing Address (Same as above?
                                                <input type="checkbox" id="cbCustSameAdd" runat="server" />)</label>
                                <asp:TextBox ID="txtCustBillAdd" runat="server" data-submit="CUST_BILL_ADD1" meta:resourcekey="txtCustBillAddResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>Zip code</label>
                                <asp:TextBox ID="txtCustBillZip" runat="server" data-submit="ID_CUST_BILL_ZIPCODE" meta:resourcekey="txtCustBillZipResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>Place</label>
                                <asp:TextBox ID="txtCustBillPlace" runat="server" meta:resourcekey="txtCustBillPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="three wide field">
                                <label>Phone1</label>
                                <asp:TextBox ID="txtCustPhone" runat="server" meta:resourcekey="txtCustPhoneResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Phone2</label>
                                <asp:TextBox ID="txtCustPhone2" runat="server" meta:resourcekey="txtCustPhone2Resource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                                <label>Mail</label>
                                <asp:TextBox ID="txtCustMail" runat="server" meta:resourcekey="txtCustMailResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <div class="ui mini icon input">
                                    <input type="button" id="btnMoreInfo" runat="server" class="ui btn" value="Se mer info" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Previous information:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <label>Previous owner</label>
                                <asp:TextBox ID="txtCustPrevOwner" runat="server" meta:resourcekey="txtCustPrevOwnerResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Selger inn</label>
                                <asp:TextBox ID="txtCustSalesmanIn" runat="server" meta:resourcekey="txtCustSalesmanInResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Selger ut</label>
                                <asp:TextBox ID="txtCustSalesmanOut" runat="server" meta:resourcekey="txtCustSalesmanOutResource1"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label>Mechanic</label>
                                <asp:TextBox ID="txtCustMechanic" runat="server" meta:resourcekey="txtCustMechanicResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="five wide column">
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Betalingsdetaljer:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label>Customer Group:</label>
                                <div class="ui mini icon input">
                                    <asp:DropDownList ID="drpCustGroup" CssClass="dropdowns" runat="server" meta:resourcekey="drpCustGroupResource1"></asp:DropDownList>
                                    <select id="ddlCustGrp" class="dropdowns">
                                        <option value="0">Kontantkunde</option>
                                        <option value="1">10 dager kreditt</option>
                                        <option value="2">30 dager kreditt</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label>Fødselsdato:</label>
                                <asp:TextBox ID="txtCustPersonNo" runat="server" meta:resourcekey="txtCustPersonNoResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label>Foretaksnr:</label>
                                <asp:TextBox ID="txtCustOrgNo" runat="server" meta:resourcekey="txtCustOrgNoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="six wide field">
                                <label>Debt</label>
                                <asp:TextBox ID="txtCustDebt" runat="server" meta:resourcekey="txtCustDebtResource1"></asp:TextBox>
                            </div>
                            <div class="ten wide field">
                                <label>Creditor</label>
                                <asp:TextBox ID="txtCustCreditor" runat="server" meta:resourcekey="txtCustCreditorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="ten wide field">
                                <label>Insurance name</label>
                                <asp:TextBox ID="txtCustInsurance" runat="server" meta:resourcekey="txtCustInsuranceResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Serviceavtale:
                        <input type="checkbox" id="cbServiceDeal" runat="server" style="width: 20px; height: 20px;" /></h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <label>To date</label>
                                <asp:TextBox ID="txtCustToDate" runat="server" meta:resourcekey="txtCustToDateResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>DealNo</label>
                                <asp:TextBox ID="txtCustDealNo" runat="server" meta:resourcekey="txtCustDealNoResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>Period</label>
                                <asp:TextBox ID="txtCustServicePeriod" runat="server" meta:resourcekey="txtCustServicePeriodResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label>Price ex. Vat</label>
                                <asp:TextBox ID="txtCustServiceNetPrice" runat="server" meta:resourcekey="txtCustServiceNetPriceResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label>Yearly milage</label>
                                <asp:TextBox ID="txtCustServiceMileage" runat="server" meta:resourcekey="txtCustServiceMileageResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabWeb" class="tTab">
        <br />
        <h3 class="ui top attached tiny header">Bilopplysninger:</h3>
        <div class="ui attached segment">
            <div class="ui grid">
                <div class="four wide column">
                    <div class="ui form">

                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMake" runat="server">Merke</label>
                                <asp:TextBox ID="txtWebMake" runat="server" meta:resourcekey="txtWebMakeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebModel" runat="server">Modell</label>
                                <asp:TextBox ID="txtWebModel" runat="server" meta:resourcekey="txtWebModelResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebDescription" runat="server">Description</label>
                                <asp:TextBox ID="txtWebDesc" runat="server" meta:resourcekey="txtWebDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebGearbox" runat="server">Girkasse</label>
                                <asp:TextBox ID="txtWebGearBox" runat="server" meta:resourcekey="txtWebGearBoxResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebGearboxDescription" runat="server">Gir betegnelse</label>
                                <asp:TextBox ID="txtWebGearDesc" runat="server" meta:resourcekey="txtWebGearDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebTraction" runat="server">Hjuldrift</label>
                                <asp:TextBox ID="txtWebTraction" runat="server" meta:resourcekey="txtWebTractionResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebTractionDescription" runat="server">Hjulbeskrivelse</label>
                                <asp:TextBox ID="txtWebTractionDesc" runat="server" meta:resourcekey="txtWebTractionDescResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="two wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebModelYear" runat="server">Årsmodell</label>
                                <asp:TextBox ID="txtWebModelYear" runat="server" meta:resourcekey="txtWebModelYearResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebPrice" runat="server">Prisantydning</label>
                                <asp:TextBox ID="txtWebVehiclePrice" runat="server" meta:resourcekey="txtWebVehiclePriceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMileage" runat="server">Kilometerstand</label>
                                <asp:TextBox ID="txtWebMileage" runat="server" meta:resourcekey="txtWebMileageResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebFuel" runat="server">Drivstoff</label>
                                <asp:TextBox ID="txtWebFuelType" runat="server" meta:resourcekey="txtWebFuelTypeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebEffectBHP" runat="server">Effekt HK</label>
                                <asp:TextBox ID="txtWebBHP" runat="server" meta:resourcekey="txtWebBHPResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebCylinderLitres" runat="server">Sylinder ltr.</label>
                                <asp:TextBox ID="txtWebCylinderLtrs" runat="server" meta:resourcekey="txtWebCylinderLtrsResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="two wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebAsShown" runat="server" Text="As shown" meta:resourcekey="cbWebAsShownResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebInclYearlyFee" runat="server" Text="Incl. yearly fee" meta:resourcekey="cbWebInclYearlyFeeResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebinclRegFee" runat="server" Text="Incl. reg. fee" meta:resourcekey="cbWebinclRegFeeResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebInclRegCosts" runat="server" Text="Incl. Reg. costs" meta:resourcekey="cbWebInclRegCostsResource1" />
                                </label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp; 
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <input type="button" id="btnEquipment" runat="server" class="ui btn wide" value="Utstyr" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp;  
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <input type="button" id="btnPublish" runat="server" class="ui btn wide" value="Publiser" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                &nbsp;  
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:CheckBox ID="cbWebPublish" runat="server" Text="Publish" meta:resourcekey="cbWebPublishResource1" />
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="four wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMainColor" runat="server">Hovedfarge</label>
                                <asp:TextBox ID="txtWebMainColor" runat="server" meta:resourcekey="txtWebMainColorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebColorDescription" runat="server">Farge beskr.</label>
                                <asp:TextBox ID="txtWebColorDesc" runat="server" meta:resourcekey="txtWebColorDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebInteriorColor" runat="server">Interiør farge</label>
                                <asp:TextBox ID="txtWebInteriorColor" runat="server" meta:resourcekey="txtWebInteriorColorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebChassi" runat="server">Karosseri</label>
                                <asp:TextBox ID="txtWebChassi" runat="server" meta:resourcekey="txtWebChassiResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblWebFirstTimeReg" runat="server">1. gang reg.</label>
                                <asp:TextBox ID="txtWebRegDate" runat="server" meta:resourcekey="txtWebRegDateResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblWebRegno" runat="server">Regnr</label>
                                <asp:TextBox ID="txtWebRegNo" runat="server" meta:resourcekey="txtWebRegNoResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label id="lblWebDoorQty" runat="server">Antall dører</label>
                                <asp:TextBox ID="txtWebDoorQty" runat="server" meta:resourcekey="txtWebDoorQtyResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblWebSeatQty" runat="server">Antall seter</label>
                                <asp:TextBox ID="txtWebSeatQty" runat="server" meta:resourcekey="txtWebSeatQtyResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <label id="lblWebOwnerQty" runat="server">Antall eiere</label>
                                <asp:TextBox ID="txtWebOwnerQty" runat="server" meta:resourcekey="txtWebOwnerQtyResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="four wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <b id="lblWebHeaderSalesPlace" runat="server">Sales place (where the car is):</b>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebAddress" runat="server">Address</label>
                                <asp:TextBox ID="txtWebAddress" runat="server" meta:resourcekey="txtWebAddressResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="four wide field">
                                <label id="lblWebZipcode" runat="server">Zipcode</label>
                                <asp:TextBox ID="txtWebZip" runat="server" meta:resourcekey="txtWebZipResource1"></asp:TextBox>
                            </div>
                            <div class="twelve wide field">
                                <label id="lblWebPlace" runat="server">Place</label>
                                <asp:TextBox ID="txtWebPlace" runat="server" meta:resourcekey="txtWebPlaceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebCountry" runat="server">Country</label>
                                <asp:TextBox ID="txtWebCountry" runat="server" meta:resourcekey="txtWebCountryResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <b id="lblWebHeaderContactPerson" runat="server">Contact person:</b>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebName" runat="server">Name</label>
                                <asp:TextBox ID="txtWebName" runat="server" meta:resourcekey="txtWebNameResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblWebMail" runat="server">E-mail</label>
                                <asp:TextBox ID="txtWebMail" runat="server" meta:resourcekey="txtWebMailResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblWebPhone1" runat="server">Phone 1</label>
                                <asp:TextBox ID="txtWebPhone1" runat="server" meta:resourcekey="txtWebPhone1Resource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblWebPhone2" runat="server">Phone 2</label>
                                <asp:TextBox ID="txtWebPhone2" runat="server" meta:resourcekey="txtWebPhone2Resource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modWebEquipment" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblModVehicleEquipment" runat="server">Vehicle equipment</h2>
            <div class="modCloseEquipment"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Vehicle equipment</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="two wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Multimedia:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <label>
                                <asp:CheckBox ID="cbEqCdPlayer" runat="server" Text="CD-Player" meta:resourcekey="cbEqCdPlayerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqRadio" runat="server" Text="Radio" meta:resourcekey="cbEqRadioResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSpeakers" runat="server" Text="Speakers" meta:resourcekey="cbEqSpeakersResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqBandPlayer" runat="server" Text="Kasett spiller" meta:resourcekey="cbEqBandPlayerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqCDChanger" runat="server" Text="CD changer" meta:resourcekey="cbEqCDChangerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqMP3player" runat="server" Text="MP3-player" meta:resourcekey="cbEqMP3playerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSubwoofer" runat="server" Text="Subwoofer" meta:resourcekey="cbEqSubwooferResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDVDVideo" runat="server" Text="DVD-Video" meta:resourcekey="cbEqDVDVideoResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDVDAudio" runat="server" Text="DVD-Audio" meta:resourcekey="cbEqDVDAudioResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqScreen" runat="server" Text="Screen" meta:resourcekey="cbEqScreenResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSacdPlayer" runat="server" Text="SACD-Player" meta:resourcekey="cbEqSacdPlayerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqNavigation" runat="server" Text="Navigation" meta:resourcekey="cbEqNavigationResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqRemoteControl" runat="server" Text="Remote Control" meta:resourcekey="cbEqRemoteControlResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSteeringControl" runat="server" Text="Steering control" meta:resourcekey="cbEqSteeringControlResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqPhone" runat="server" Text="Phone" meta:resourcekey="cbEqPhoneResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqTV" runat="server" Text="TV" meta:resourcekey="cbEqTVResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDrivingCpu" runat="server" Text="Driving computer" meta:resourcekey="cbEqDrivingCpuResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqOutputAUX" runat="server" Text="Output to AUX" meta:resourcekey="cbEqOutputAUXResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqMMadd1" runat="server" meta:resourcekey="txtEqMMadd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqMMAdd2" runat="server" meta:resourcekey="txtEqMMAdd2Resource1"></asp:TextBox>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="four wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Comfort:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="eight wide field">
                            <label>
                                <asp:CheckBox ID="cbEqCentralLock" runat="server" Text="Central lock" meta:resourcekey="cbEqCentralLockResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAirCondition" runat="server" Text="Aircondition" meta:resourcekey="cbEqAirConditionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElClimate" runat="server" Text="El.Climat" meta:resourcekey="cbEqElClimateResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqEngineVarmer" runat="server" Text="Engine varmer" meta:resourcekey="cbEqEngineVarmerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqCupeVarm" runat="server" Text="Cupe varmer" meta:resourcekey="cbEqCupeVarmResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAutomaticGear" runat="server" Text="Automatic gear" meta:resourcekey="cbEqAutomaticGearResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqHandlingControl" runat="server" Text="Handling Control" meta:resourcekey="cbEqHandlingControlResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElJustableMirror" runat="server" Text="El. justable mirrors" meta:resourcekey="cbEqElJustableMirrorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElClosingMirrors" runat="server" Text="El. closing mirrors" meta:resourcekey="cbEqElClosingMirrorsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElVarmingMirrors" runat="server" Text="El. varming mirrors" meta:resourcekey="cbEqElVarmingMirrorsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqHatch" runat="server" Text="Hatch/Takluke" meta:resourcekey="cbEqHatchResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElCab" runat="server" Text="El. Cabriolet" meta:resourcekey="cbEqElCabResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqCruiseControl" runat="server" Text="Cruise control" meta:resourcekey="cbEqCruiseControlResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqRainSensor" runat="server" Text="Rain sensor" meta:resourcekey="cbEqRainSensorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqMultiFunctionSteering" runat="server" Text="Multi function steeringwheel" meta:resourcekey="cbEqMultiFunctionSteeringResource1" />
                            </label>
                        </div>
                        <div class="eight wide field">
                            <label>
                                <asp:CheckBox ID="cbEqElWindows" runat="server" Text="El. windows" meta:resourcekey="cbEqElWindowsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElJustSeats" runat="server" Text="El. justable seats" meta:resourcekey="cbEqElJustSeatsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElCurtain" runat="server" Text="Electrical curtain" meta:resourcekey="cbEqElCurtainResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElAntenna" runat="server" Text="El. Antenna" meta:resourcekey="cbEqElAntennaResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAirVentilatedChairs" runat="server" Text="Air ventilated seats" meta:resourcekey="cbEqAirVentilatedChairsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqHeightJustableSeats" runat="server" Text="Height justable seats" meta:resourcekey="cbEqHeightJustableSeatsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqJustableSteering" runat="server" Text="Adjustable Steering" meta:resourcekey="cbEqJustableSteeringResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqColoredGlass" runat="server" Text="Colored glass" meta:resourcekey="cbEqColoredGlassResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqArmLean" runat="server" Text="Arm lean middle" meta:resourcekey="cbEqArmLeanResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAirSuspension" runat="server" Text="Air suspension" meta:resourcekey="cbEqAirSuspensionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSunCurtain" runat="server" Text="Sun curtain" meta:resourcekey="cbEqSunCurtainResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqVarmSoothingFront" runat="server" Text="Varm soothing front" meta:resourcekey="cbEqVarmSoothingFrontResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqVarmingSeats" runat="server" Text="Varming seats" meta:resourcekey="cbEqVarmingSeatsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqMemorySeats" runat="server" Text="Memory in seats" meta:resourcekey="cbEqMemorySeatsResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqCoAdd1" runat="server" meta:resourcekey="txtEqCoAdd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqCoAdd2" runat="server" meta:resourcekey="txtEqCoAdd2Resource1"></asp:TextBox>
                            </label>

                        </div>
                    </div>
                </div>
            </div>

            <div class="four wide column">
                <div class="ui form">

                    <div class="fields">
                        <div class="eight wide field">
                            <div class="fields">
                                <label>
                                    <h3>Safety:</h3>
                                </label>
                            </div>
                            <label>
                                <asp:CheckBox ID="cbEqABSBrakes" runat="server" Text="ABS brakes" meta:resourcekey="cbEqABSBrakesResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAirBag" runat="server" Text="Air bag" meta:resourcekey="cbEqAirBagResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqXenonLight" runat="server" Text="Xenon light" meta:resourcekey="cbEqXenonLightResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAntiSpin" runat="server" Text="Anti spin" meta:resourcekey="cbEqAntiSpinResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqESP" runat="server" Text="ESP" meta:resourcekey="cbEqESPResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDimCenterMirror" runat="server" Text="Dim center mirror" meta:resourcekey="cbEqDimCenterMirrorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqHandsfree" runat="server" Text="Handsfree mobile" meta:resourcekey="cbEqHandsfreeResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqParkingSystem" runat="server" Text="Parking system" meta:resourcekey="cbEqParkingSystemResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqElVarmingFrontWindow" runat="server" Text="El. varming front window" meta:resourcekey="cbEqElVarmingFrontWindowResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEq4WD" runat="server" Text="4WD" meta:resourcekey="cbEq4WDResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDiffBrake" runat="server" Text="Differential brakes" meta:resourcekey="cbEqDiffBrakeResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqLevelRegulator" runat="server" Text="Level regulator" meta:resourcekey="cbEqLevelRegulatorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqLightWasher" runat="server" Text="Frontlight washer" meta:resourcekey="cbEqLightWasherResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDirectionsInMirrors" runat="server" Text="Directions in side mirrors" meta:resourcekey="cbEqDirectionsInMirrorsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqExtraLights" runat="server" Text="Extra lights" meta:resourcekey="cbEqExtraLightsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqAlarm" runat="server" Text="Alarm" meta:resourcekey="cbEqAlarmResource1" />
                            </label>

                        </div>
                        <div class="eight wide field">
                            <label>
                                <asp:CheckBox ID="cbEqKeylessGo" runat="server" Text="Keyless Go" meta:resourcekey="cbEqKeylessGoResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqStartBlock" runat="server" Text="Start block" meta:resourcekey="cbEqStartBlockResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqParkSensor" runat="server" Text="Park sensor" meta:resourcekey="cbEqParkSensorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqBackingCamera" runat="server" Text="Backing camera" meta:resourcekey="cbEqBackingCameraResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqIntegratedChildSeats" runat="server" Text="Integrated child seats" meta:resourcekey="cbEqIntegratedChildSeatsResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqSaAdd1" runat="server" meta:resourcekey="txtEqSaAdd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqSaAdd2" runat="server" meta:resourcekey="txtEqSaAdd2Resource1"></asp:TextBox>
                            </label>
                            <div class="fields">
                                <label>
                                    <h3>Sport:</h3>
                                </label>
                            </div>
                            <label>
                                <asp:CheckBox ID="cbEqSportSteeringwheel" runat="server" Text="Sports steeringwheel" meta:resourcekey="cbEqSportSteeringwheelResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqLoweredChassi" runat="server" Text="Lowered chassi" meta:resourcekey="cbEqLoweredChassiResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSportsSeats" runat="server" Text="Sports seats" meta:resourcekey="cbEqSportsSeatsResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqSpAdd1" runat="server" meta:resourcekey="txtEqSpAdd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqSpAdd2" runat="server" meta:resourcekey="txtEqSpAdd2Resource1"></asp:TextBox>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="four wide column">
                <div class="ui form">
                    <div class="fields">
                        <div class="eight wide field">
                            <div class="fields">
                                <label>
                                    <h3>Utseende:</h3>
                                </label>
                            </div>
                            <label>
                                <asp:CheckBox ID="cbEqAluminiumRims" runat="server" Text="Aluminium rims" meta:resourcekey="cbEqAluminiumRimsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqRails" runat="server" Text="Rails" meta:resourcekey="cbEqRailsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqLeather" runat="server" Text="Leather" meta:resourcekey="cbEqLeatherResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqWoodenInterior" runat="server" Text="Wooden interior" meta:resourcekey="cbEqWoodenInteriorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqMirrors" runat="server" Text="Mirrors" meta:resourcekey="cbEqMirrorsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqBumpers" runat="server" Text="Bumpers" meta:resourcekey="cbEqBumpersResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSpoilerBack" runat="server" Text="Rear Spoiler" meta:resourcekey="cbEqSpoilerBackResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqPartLeather" runat="server" Text="Partially leather" meta:resourcekey="cbEqPartLeatherResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqMetalicPaint" runat="server" Text="Metalic paint" meta:resourcekey="cbEqMetalicPaintResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqDarkSideScreens" runat="server" Text="Dark side screens" meta:resourcekey="cbEqDarkSideScreensResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqLoAdd1" runat="server" meta:resourcekey="txtEqLoAdd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqLoAdd2" runat="server" meta:resourcekey="txtEqLoAdd2Resource1"></asp:TextBox>
                            </label>
                        </div>
                        <div class="eight wide field">
                            <div class="fields">
                                <label>
                                    <h3 id="lblOthers" runat="server">Others:</h3>
                                </label>
                            </div>
                            <label>
                                <asp:CheckBox ID="cbEqTowbar" runat="server" Text="Tilhengerfeste" meta:resourcekey="cbEqTowbarResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSkiBag" runat="server" Text="Ski bag" meta:resourcekey="cbEqSkiBagResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqSkiBox" runat="server" Text="Ski box" meta:resourcekey="cbEqSkiBoxResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEqLoadroomMat" runat="server" Text="Load room mat" meta:resourcekey="cbEqLoadroomMatResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEq12V" runat="server" Text="12V" meta:resourcekey="cbEq12VResource1" />
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqOtAdd1" runat="server" meta:resourcekey="txtEqOtAdd1Resource1"></asp:TextBox>
                            </label>
                            <label>
                                <asp:TextBox ID="txtEqOtAdd2" runat="server" meta:resourcekey="txtEqOtAdd2Resource1"></asp:TextBox>
                            </label>
                        </div>
                    </div>
                </div>
                <input type="button" id="btnSaveEquipment" runat="server" class="ui btn" value="Save" />
            </div>
        </div>
        &nbsp;
    </div>

    <div id="tabProspect" class="tTab">
        <div class="ui grid">
            <div class="eight wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header" id="lblProsProspect" runat="server">Prospect:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblProsTitle" runat="server">Title</label>
                                <asp:TextBox runat="server" ID="txtProsTitle" TextMode="MultiLine" Height="15px" meta:resourcekey="txtProsTitleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblProsDescription" runat="server">Description</label>
                                <asp:TextBox runat="server" ID="txtProsDesc" TextMode="MultiLine" Height="30px" meta:resourcekey="txtProsDescResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="twelve wide field">
                                <label id="lblProsVideoUrl" runat="server">Video URL</label>
                                <asp:TextBox runat="server" ID="txtProsVideoUrl" meta:resourcekey="txtProsVideoUrlResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                &nbsp;
                                            <label>
                                                <asp:CheckBox runat="server" ID="cbProsShowOnMonitor" Text="Show on monitor" meta:resourcekey="cbProsShowOnMonitorResource1"></asp:CheckBox></label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="twelve wide field">
                                <label id="lblProsTopLogoPath" runat="server">Top logo path</label>
                                <asp:TextBox runat="server" ID="txtProsTopLogoPath" meta:resourcekey="txtProsTopLogoPathResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                &nbsp;
                                             <input type="button" runat="server" id="btnProsFindTopLogo" class="ui btn wide" value="Find target" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="twelve wide field">
                                <label id="lblProsBottomLogoPath" runat="server">Bottom logo path</label>
                                <asp:TextBox runat="server" ID="txtProsBottomLogoPath" meta:resourcekey="txtProsBottomLogoPathResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                &nbsp;
                                             <input type="button" runat="server" id="btnProsBottomLogoPath" class="ui btn wide" value="Find target" />
                            </div>
                        </div>
                    </div>
                </div>
                <%--Other half of the tabProspect page which is blank--%>
                <div class="eight wide column">
                    <div class="ui form">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabTrailer" class="tTab">
        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header" id="lblTrailerChassi" runat="server">Trailer chassi:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <label id="lblTrailerAxle1" runat="server">Axle 1</label>
                                <asp:TextBox runat="server" ID="txtTraAxle1" meta:resourcekey="txtTraAxle1Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle2" runat="server">Axle 2</label>
                                <asp:TextBox runat="server" ID="txtTraAxle2" meta:resourcekey="txtTraAxle2Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle3" runat="server">Axle 3</label>
                                <asp:TextBox runat="server" ID="txtTraAxle3" meta:resourcekey="txtTraAxle3Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle4" runat="server">Axle 4</label>
                                <asp:TextBox runat="server" ID="txtTraAxle4" meta:resourcekey="txtTraAxle4Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="four wide field">
                                <label id="lblTrailerAxle5" runat="server">Axle 5</label>
                                <asp:TextBox runat="server" ID="txtTraAxle5" meta:resourcekey="txtTraAxle5Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle6" runat="server">Axle 6</label>
                                <asp:TextBox runat="server" ID="txtTraAxle6" meta:resourcekey="txtTraAxle6Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle7" runat="server">Axle 7</label>
                                <asp:TextBox runat="server" ID="txtTraAxle7" meta:resourcekey="txtTraAxle7Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblTrailerAxle8" runat="server">Axle 8</label>
                                <asp:TextBox runat="server" ID="txtTraAxle8" meta:resourcekey="txtTraAxle8Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label id="lblTrailerDescription" runat="server">Description</label>
                                <asp:TextBox runat="server" ID="txtTraDesc" TextMode="MultiLine" Height="30px" meta:resourcekey="txtTraDescResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabCertificate" class="tTab">
        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header" id="lblCertVehicleCertification" runat="server">Vehicle certification:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblCertTireDimFront" runat="server">Tire dim. front</label>
                                <asp:TextBox runat="server" ID="txtCertTireDimFront" meta:resourcekey="txtCertTireDimFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertTireDimBack" runat="server">Tire dim. back</label>
                                <asp:TextBox runat="server" ID="txtCertTireDimBack" meta:resourcekey="txtCertTireDimBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertLiPlyratFront" runat="server">LI (Plyrat) front</label>
                                <asp:TextBox runat="server" ID="txtCertLiFront" meta:resourcekey="txtCertLiFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertLiPlyratBack" runat="server">LI (Plyrat) back</label>
                                <asp:TextBox runat="server" ID="txtCertLiBack" meta:resourcekey="txtCertLiBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMinInpressFront" runat="server">Min. inpress front</label>
                                <asp:TextBox runat="server" ID="txtCertMinInpressFront" meta:resourcekey="txtCertMinInpressFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMinInpressBack" runat="server">Min. inpress back</label>
                                <asp:TextBox runat="server" ID="txtCertMinInpressBack" meta:resourcekey="txtCertMinInpressBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                            </div>
                            <div class="two wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblCertStdRimFront" runat="server">Std rim front</label>
                                <asp:TextBox runat="server" ID="txtCertRimFront" meta:resourcekey="txtCertRimFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertStdRimBack" runat="server">Std rim back</label>
                                <asp:TextBox runat="server" ID="txtCertRimBack" meta:resourcekey="txtCertRimBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMinSpeedFront" runat="server">Min. speed front</label>
                                <asp:TextBox runat="server" ID="txtCertminSpeedFront" meta:resourcekey="txtCertminSpeedFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMinSpeedBack" runat="server">Min. speed back</label>
                                <asp:TextBox runat="server" ID="txtCertMinSpeedBack" meta:resourcekey="txtCertMinSpeedBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMaxWheelWidthFront" runat="server">Max wheel-width front</label>
                                <asp:TextBox runat="server" ID="txtCertMaxWidthFront" meta:resourcekey="txtCertMaxWidthFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMaxWheelWidthBack" runat="server">Max wheel-width back</label>
                                <asp:TextBox runat="server" ID="txtCertMaxWidthBack" meta:resourcekey="txtCertMaxWidthBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                            </div>
                            <div class="two wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblCertAxlePressureFront" runat="server">Axel pressure front</label>
                                <asp:TextBox runat="server" ID="txtCertAxlePressureFront" meta:resourcekey="txtCertAxlePressureFrontResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertAxlePressureBack" runat="server">Axle pressure back</label>
                                <asp:TextBox runat="server" ID="txtCertAxlePressureBack" meta:resourcekey="txtCertAxlePressureBackResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertNumberOfAxles" runat="server">No. of axles</label>
                                <asp:TextBox runat="server" ID="txtCertAxleQty" meta:resourcekey="txtCertAxleQtyResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertAxlesWithTraction" runat="server">Axles with traction</label>
                                <asp:TextBox runat="server" ID="txtCertAxleWithTraction" meta:resourcekey="txtCertAxleWithTractionResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertGear" runat="server">Drivhjul</label>
                                <asp:TextBox runat="server" ID="txtCertGear" meta:resourcekey="txtCertGearResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMaxRoofWeight" runat="server">Max roof weight</label>
                                <asp:TextBox runat="server" ID="txtCertMaxRoofWeight" meta:resourcekey="txtCertMaxRoofWeightResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                            </div>
                            <div class="two wide field">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header" id="lblCertTrailerEtc" runat="server">Trailer etc.:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblCertTrailerWeightWBrakes" runat="server">Trailer weight w/brakes</label>
                                <asp:TextBox runat="server" ID="txtCertTrailerWeightBrakes" meta:resourcekey="txtCertTrailerWeightBrakesResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertTrailerWeight" runat="server">Trailer weight</label>
                                <asp:TextBox runat="server" ID="txtCertTrailerWeight" meta:resourcekey="txtCertTrailerWeightResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMaxWeightTowbar" runat="server">Max weight towbar</label>
                                <asp:TextBox runat="server" ID="txtCertWeightTowbar" meta:resourcekey="txtCertWeightTowbarResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertLengthToTowbar" runat="server">Length to towbar</label>
                                <asp:TextBox runat="server" ID="txtCertLengthTowbar" meta:resourcekey="txtCertLengthTowbarResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertTotTrailerWeight" runat="server">Total Trailer weight</label>
                                <asp:TextBox runat="server" ID="txtCertTotalTrailerWeight" meta:resourcekey="txtCertTotalTrailerWeightResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertNumberOfSeats" runat="server">No. of seats</label>
                                <asp:TextBox runat="server" ID="txtCertSeats" meta:resourcekey="txtCertSeatsResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                            </div>
                            <div class="two wide field">
                            </div>
                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblCertValidFrom" runat="server">Valid from</label>
                                <asp:TextBox runat="server" ID="txtCertValidFrom" meta:resourcekey="txtCertValidFromResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertEuVersion" runat="server">EU version</label>
                                <asp:TextBox runat="server" ID="txtCertEuVersion" meta:resourcekey="txtCertEuVersionResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertEuVariant" runat="server">EU variant</label>
                                <asp:TextBox runat="server" ID="txtCertEuVariant" meta:resourcekey="txtCertEuVariantResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertEuronorm" runat="server">Euronorm</label>
                                <asp:TextBox runat="server" ID="txtCertEuronorm" meta:resourcekey="txtCertEuronormResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertCO2Emission" runat="server">CO2 emission</label>
                                <asp:TextBox runat="server" ID="txtCertCo2Emission" meta:resourcekey="txtCertCo2EmissionResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label id="lblCertMakeParticleFilter" runat="server">Make particle filter</label>
                                <asp:TextBox runat="server" ID="txtCertMakeParticleFilter" meta:resourcekey="txtCertMakeParticleFilterResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                            </div>
                            <div class="two wide field">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">

                    <h3 class="ui top attached tiny header" id="lblCertAnnotation" runat="server">Annotations:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:Literal ID="liCertChassi" runat="server" Text="Frame/Chassis" meta:resourcekey="liCertChassiResource1"></asp:Literal>
                                </label>
                                <asp:TextBox runat="server" ID="txtCertChassi" meta:resourcekey="txtCertChassiResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:Literal ID="liCertIdentity" runat="server" Text="Identity" meta:resourcekey="liCertIdentityResource1"></asp:Literal>
                                </label>
                                <asp:TextBox runat="server" ID="txtCertIdentity" meta:resourcekey="txtCertIdentityResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:Literal ID="liCertCertificate" runat="server" Text="Certificate" meta:resourcekey="liCertCertificateResource1"></asp:Literal>
                                </label>
                                <asp:TextBox runat="server" ID="txtCertCertificate" meta:resourcekey="txtCertCertificateResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:Literal ID="liCertNote" runat="server" Text="Notes" meta:resourcekey="liCertNoteResource1"></asp:Literal>
                                </label>
                                <asp:TextBox runat="server" ID="txtCertNotes" meta:resourcekey="txtCertNotesResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tabForm" class="tTab">
        <div class="ui grid">
            <div class="two wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <table class="ui celled structured table" style="height: 80%;">
                            <thead>
                                <tr>
                                    <th colspan="2">BilXtra - Gratis Xtrasjekk</th>
                                    <th style="background-color: #ff6666">Bør utbedres</th>
                                    <th style="background-color: #FFFF55">Under oppsyn</th>
                                    <th style="background-color: #00CC00">OK</th>
                                    <th>Anm.</th>
                                    <th>SMS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Motorolje</td>
                                    <td>Nivå</td>
                                    <td class="engineOilBad">
                                        <i class="engineOilBadBox"></i>
                                    </td>
                                    <td class="engineOilOK">
                                        <i class="engineOilOKBox"></i>
                                    </td>
                                    <td class="engineOilGood">
                                        <i class="engineOilGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="engineOilAnnot">
                                        <i class="engineOilAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Frostvæske</td>
                                    <td>Nivå</td>
                                    <td class="cFLevelBad">
                                        <i class="cFLevelBadBox"></i>
                                    </td>
                                    <td class="cFLevelOK">
                                        <i class="cFLevelOKBox"></i>
                                    </td>
                                    <td class="cFLevelGood">
                                        <i class="cFLevelGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="cFLevelAnnot">
                                        <i class="cFLevelAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Frysepunkt</td>
                                    <td class="cFTempBad">
                                        <i class="cFTempBadBox"></i>
                                    </td>
                                    <td class="cFTempOK">
                                        <i class="cFTempOKBox"></i>
                                    </td>
                                    <td class="cFTempGood">
                                        <i class="cFTempGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="cfTempAnnot">
                                        <i class="cfTempAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bremsevæske</td>
                                    <td>Nivå</td>
                                    <td class="brakeFluidBad">
                                        <i class="brakeFluidBadBox"></i>
                                    </td>
                                    <td class="brakeFluidOK">
                                        <i class="brakeFluidOKBox"></i>
                                    </td>
                                    <td class="brakeFluidGood">
                                        <i class="brakeFluidGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="brakeFluidAnnot">
                                        <i class="brakeFluidAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Batteri</td>
                                    <td>Nivå</td>
                                    <td class="batteryBad">
                                        <i class="batteryBadBox"></i>
                                    </td>
                                    <td class="batteryOK">
                                        <i class="batteryOKBox"></i>
                                    </td>
                                    <td class="batteryGood">
                                        <i class="batteryGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="batteryAnnot">
                                        <i class="batteryAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Vindusvisker</td>
                                    <td>Foran</td>
                                    <td class="vipesFrontBad">
                                        <i class="vipesFrontBadBox"></i>
                                    </td>
                                    <td class="vipesFrontOK">
                                        <i class="vipesFrontOKBox"></i>
                                    </td>
                                    <td class="vipesFrontGood">
                                        <i class="vipesFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="vipesFrontAnnot">
                                        <i class="vipesFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bak</td>
                                    <td class="vipesBackBad">
                                        <i class="vipesBackBadBox"></i>
                                    </td>
                                    <td class="vipesBackOK">
                                        <i class="vipesBackOKBox"></i>
                                    </td>
                                    <td class="vipesBackGood">
                                        <i class="vipesBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="vipesBackAnnot">
                                        <i class="vipesBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Lyspærer</td>
                                    <td>Foran</td>
                                    <td class="lightsFrontBad">
                                        <i class="lightsFrontBadBox"></i>
                                    </td>
                                    <td class="lightsFrontOK">
                                        <i class="lightsFrontOKBox"></i>
                                    </td>
                                    <td class="lightsFrontGood">
                                        <i class="lightsFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="lightsFrontAnnot">
                                        <i class="lightsFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bak</td>
                                    <td class="lightsBackBad">
                                        <i class="lightsBackBadBox"></i>
                                    </td>
                                    <td class="lightsBackOK">
                                        <i class="lightsBackOKBox"></i>
                                    </td>
                                    <td class="lightsBackGood">
                                        <i class="lightsBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="lightsBackAnnot">
                                        <i class="lightsBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Støtdempere</td>
                                    <td>Foran</td>
                                    <td class="bumperFrontBad">
                                        <i class="bumperFrontBadBox"></i>
                                    </td>
                                    <td class="bumperFrontOK">
                                        <i class="bumperFrontOKBox"></i>
                                    </td>
                                    <td class="bumperFrontGood">
                                        <i class="bumperFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="bumperFrontAnnot">
                                        <i class="bumperFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bak</td>
                                    <td class="bumperBackBad">
                                        <i class="bumperBackBadBox"></i>
                                    </td>
                                    <td class="bumperBackOK">
                                        <i class="bumperBackOKBox"></i>
                                    </td>
                                    <td class="bumperBackGood">
                                        <i class="bumperBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="bumperBackAnnot">
                                        <i class="bumperBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Dekk</td>
                                    <td>Foran</td>
                                    <td class="tiresFrontBad">
                                        <i class="tiresFrontBadBox"></i>
                                    </td>
                                    <td class="tiresFrontOK">
                                        <i class="tiresFrontOKBox"></i>
                                    </td>
                                    <td class="tiresFrontGood">
                                        <i class="tiresFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="tiresFrontAnnot">
                                        <i class="tiresFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bak</td>
                                    <td class="tiresBackBad">
                                        <i class="tiresBackBadBox"></i>
                                    </td>
                                    <td class="tiresBackOK">
                                        <i class="tiresBackOKBox"></i>
                                    </td>
                                    <td class="tiresBackGood">
                                        <i class="tiresBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="tiresBackAnnot">
                                        <i class="tiresBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Forstilling</td>
                                    <td></td>
                                    <td class="suspensionFrontBad">
                                        <i class="suspensionFrontBadBox"></i>
                                    </td>
                                    <td class="suspensionFrontOK">
                                        <i class="suspensionFrontOKBox"></i>
                                    </td>
                                    <td class="suspensionFrontGood">
                                        <i class="suspensionFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="suspensionFrontAnnot">
                                        <i class="suspensionFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Bakstilling</td>
                                    <td></td>
                                    <td class="suspensionBackBad">
                                        <i class="suspensionBackBadBox"></i>
                                    </td>
                                    <td class="suspensionBackOK">
                                        <i class="suspensionBackOKBox"></i>
                                    </td>
                                    <td class="suspensionBackGood">
                                        <i class="suspensionBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="suspensionBackAnnot">
                                        <i class="suspensionBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Bremser</td>
                                    <td>Klosser foran</td>
                                    <td class="brakesFrontBad">
                                        <i class="brakesFrontBadBox"></i>
                                    </td>
                                    <td class="brakesFrontOK">
                                        <i class="brakesFrontOKBox"></i>
                                    </td>
                                    <td class="brakesFrontGood">
                                        <i class="brakesFrontGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="brakesFrontAnnot">
                                        <i class="brakesFrontAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Klosser bak</td>
                                    <td class="brakesBackBad">
                                        <i class="brakesBackBadBox"></i>
                                    </td>
                                    <td class="brakesBackOK">
                                        <i class="brakesBackOKBox"></i>
                                    </td>
                                    <td class="brakesBackGood">
                                        <i class="brakesBackGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="brakesBackAnnot">
                                        <i class="brakesBackAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Eksosanelgg</td>
                                    <td></td>
                                    <td class="exhaustBad">
                                        <i class="exhaustBadBox"></i>
                                    </td>
                                    <td class="exhaustOK">
                                        <i class="exhaustOKBox"></i>
                                    </td>
                                    <td class="exhaustGood">
                                        <i class="exhaustGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="exhaustAnnot">
                                        <i class="exhaustAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td rowspan="2">Tetthet</td>
                                    <td>Motor</td>
                                    <td class="sealedEngineBad">
                                        <i class="sealedEngineBadBox"></i>
                                    </td>
                                    <td class="sealedEngineOK">
                                        <i class="sealedEngineOKBox"></i>
                                    </td>
                                    <td class="sealedEngineGood">
                                        <i class="sealedEngineGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="sealedEngineAnnot">
                                        <i class="sealedEngineAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Girkasse</td>
                                    <td class="sealedGearboxBad">
                                        <i class="sealedGearboxBadBox"></i>
                                    </td>
                                    <td class="sealedGearboxOK">
                                        <i class="sealedGearboxOKBox"></i>
                                    </td>
                                    <td class="sealedGearboxGood">
                                        <i class="sealedGearboxGoodBox large black checkmark icon"></i>
                                    </td>
                                    <td class="sealedGearboxAnnot">
                                        <i class="sealedGearboxAnnotIcon"></i>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <label>Beskrivelse</label>
                                        <asp:TextBox runat="server" ID="txtFormDescription" TextMode="MultiLine" Rows="4" meta:resourcekey="txtFormDescriptionResource1"></asp:TextBox>
                                    </td>
                                </tr>
                            </tbody>



                        </table>

                    </div>
                </div>
            </div>
            <div class="two wide column"></div>
        </div>
    </div>

    <div id="tabBottom">
        <div id="btnEmptyScreen" class="ui button negative">Tøm</div>
        <div id="btnPrintVehicle" class="ui button">Skriv ut</div>
        <div id="btnNewVehicle" class="ui button blue">Nytt kjøretøy</div>
        <div id="btnSaveVehicle" class="ui button positive">Lagre</div>
    </div>

    <%-- POP UP BOXES FOR ANNOTATION ON THE BILXTRA fORM TAB  --%>
    <div id="modEngineOil" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Engine Oil</h2>
            <div class="modCloseEngineOil"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Engine Oil</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormEngineOilAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormEngineOilAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveEngineOilAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modcFLevel" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on cold fluid level</h2>
            <div class="modClosecFLevel"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on cold fluid level</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormcFLevelAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormcFLevelAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSavecFLevelAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modcfTemp" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on cold fluid temperature</h2>
            <div class="modClosecfTemp"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on cold fluid temperature</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormcfTempAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormcfTempAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSavecfTempAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modbrakeFluid" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on brake fluid level</h2>
            <div class="modCloseBrakeFluid"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on brake fluid level</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBrakeFluidAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBrakeFluidAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBrakeFluidAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modBattery" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on battery</h2>
            <div class="modCloseBattery"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on battery</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBatteryAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBatteryAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBatteryAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modVipesFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on vipes front</h2>
            <div class="modCloseVipesFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on vipes front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormVipesFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormVipesFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveVipesFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modVipesBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on vipes back</h2>
            <div class="modCloseVipesBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on vipes back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormVipesBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormVipesBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveVipesBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modLightsFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on lights front</h2>
            <div class="modCloseLightsFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on lights front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormLightsFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormLightsFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveLightsFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modLightsBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on lights back</h2>
            <div class="modCloseLightsBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on lights back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormLightsBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormLightsBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveLightsBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modBumperFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on lights front</h2>
            <div class="modCloseBumperFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Bumper front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBumperFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBumperFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBumperFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modBumperBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Bumper back</h2>
            <div class="modCloseBumperBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Bumper back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBumperBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBumperBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBumperBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modTiresFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Tires front</h2>
            <div class="modCloseTiresFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Tires front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormTiresFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormTiresFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveTiresFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modTiresBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Tires back</h2>
            <div class="modCloseTiresBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Tires back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormTiresBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormTiresBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveTiresBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modSuspensionFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Suspension front</h2>
            <div class="modCloseSuspensionFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Suspension front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormSuspensionFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormSuspensionFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveSuspensionFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modSuspensionBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Suspension back</h2>
            <div class="modCloseSuspensionBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Suspension back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormSuspensionBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormSuspensionBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveSuspensionBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modBrakesFront" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Brakes front</h2>
            <div class="modCloseBrakesFront"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Brakes front</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBrakesFrontAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBrakesFrontAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBrakesFrontAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modBrakesBack" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Brakes back</h2>
            <div class="modCloseBrakesBack"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Brakes back</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormBrakesBackAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormBrakesBackAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveBrakesBackAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modExhaust" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Exhaust</h2>
            <div class="modCloseExhaust"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Exhaust</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormExhaustAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormExhaustAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveExhaustAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modSealedEngine" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Sealed Engine</h2>
            <div class="modCloseSealedEngine"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Sealed Engine</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormSealedEngineAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormSealedEngineAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveSealedEngineAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="modSealedGearbox" class="modal hidden">
        <div class="modHeader">
            <h2>Annotation on Sealed Gearbox</h2>
            <div class="modCloseSealedGearbox"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Annotation on Sealed Gearbox</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="twelve wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Note:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:TextBox ID="txtFormSealedGearboxAnnot" TextMode="MultiLine" runat="server" meta:resourcekey="txtFormSealedGearboxAnnotResource1"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <input type="button" class="ui btn" id="btnSaveSealedGearboxAnnot" value="Lagre" />
                        </div>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- END OF POP UP BOXES FOR ANNOTATION ON THE BILXTRA fORM TAB  --%>

    <div id="modPrintVehicle" class="modal hidden">
        <div class="modHeader">
            <h2>Utskriftsalternativer</h2>
            <div class="modClosePrint"><i class="remove icon"></i></div>
        </div>
        <div class="ui form">
            <div class="field">
                <label class="sr-only">Utskriftsalternativer</label>
            </div>
        </div>
        <div class="ui grid">
            <div class="one wide column"></div>
            <div class="six wide column">
                <div class="ui form">
                    <div class="fields">
                        <label>
                            <h3>Rapporttype:</h3>
                        </label>
                    </div>
                    <div class="fields">
                        <div class="sixteen wide field">
                            <asp:RadioButtonList ID="rblVehicleReportList" runat="server" meta:resourcekey="rblVehicleReportListResource1">
                                <asp:ListItem Selected="True" Text="Car information" Value="0" meta:resourcekey="ListItemResource1" />
                                <asp:ListItem Text="Vehicle prospect" Value="1" meta:resourcekey="ListItemResource2" />
                                <asp:ListItem Text="Vehicle poster" Value="2" meta:resourcekey="ListItemResource3" />
                                <asp:ListItem Text="Vehicle sales prospect" Value="3" meta:resourcekey="ListItemResource4" />
                                <asp:ListItem Text="Used car warranty" Value="4" meta:resourcekey="ListItemResource5" />
                                <asp:ListItem Text="Complete vehicle history" Value="5" meta:resourcekey="ListItemResource6" />
                                <asp:ListItem Text="Vehicle key tag" Value="6" meta:resourcekey="ListItemResource7" />
                                <asp:ListItem Text="Vehicle history with sales" Value="7" meta:resourcekey="ListItemResource8" />
                                <asp:ListItem Text="Vehicle history without sales" Value="8" meta:resourcekey="ListItemResource9" />
                                <asp:ListItem Text="Vehicle Certificate" Value="9" meta:resourcekey="ListItemResource10" />
                                <asp:ListItem Text="BilXtra - Xtrasjekk" Value="10" meta:resourcekey="ListItemResource11" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>

            <div class="sixteen wide column">
                <div class="ui form">
                    <div class="fields">
                        <div class="one wide field">
                        </div>
                        <div class="fourteen wide field">
                            <input type="button" id="btnStartPrint" class="ui btn" value="Skriv ut" />
                        </div>
                        <div class="one wide field">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        &nbsp;
    </div>
</asp:Content>

