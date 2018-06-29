Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports CARS.CoreLibrary.CARS.Services
Imports System.Reflection

Public Class frmVehicleDetail
    Inherits System.Web.UI.Page
    Shared objVehicleService As New CARS.CoreLibrary.CARS.Services.Vehicle.VehicleDetails
    Shared objCustService As New CARS.CoreLibrary.CARS.Services.Customer.CustomerDetails
    Shared objVehBo As New VehicleBO
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of VehicleBO)()
    Shared commonUtil As New Utilities.CommonUtility
    Shared OErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared _loginName As String
    Shared loginName As String
    Shared objCustomerService As New Customer.CustomerDetails

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            Dim dtCaption As DataTable
            _loginName = CType(Session("UserID"), String)

            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                lblRefNoCreate.Text = dtCaption.Select("TAG='lblRefNo'")(0)(1)
                lblRegNoCreate.Text = dtCaption.Select("TAG='lblRegNo'")(0)(1)
                lblCreateNewUsed.InnerText = dtCaption.Select("TAG='lblNewUsed'")(0)(1)
                lblCreateStatus.InnerText = dtCaption.Select("TAG='lblVehicleStatus'")(0)(1)
                lblNewVehicle.InnerText = dtCaption.Select("TAG='lblNewVehicle'")(0)(1)
                lblChooseStatus.InnerText = dtCaption.Select("TAG='lblChooseStatus'")(0)(1)
                lblRefNo.Text = dtCaption.Select("TAG='lblRefNo'")(0)(1)
                lblRegNo.Text = dtCaption.Select("TAG='lblRegNo'")(0)(1)
                lblVin.Text = dtCaption.Select("TAG='lblChassiNo'")(0)(1)
                lblNewUsed.InnerText = dtCaption.Select("TAG='lblNewUsed'")(0)(1)
                lblVehicleStatus.InnerText = dtCaption.Select("TAG='lblVehicleStatus'")(0)(1)
                btnFetchMVR.Value = dtCaption.Select("TAG='btnFetch'")(0)(1)
                btnAddAnnotation.Value = dtCaption.Select("TAG='btnAnnotation'")(0)(1)
                btnAddNote.Value = dtCaption.Select("TAG='btnNote'")(0)(1)
                lblGeneralMake.InnerText = "Bilmerke"
                lblModelForm.InnerText = dtCaption.Select("TAG='lblModelForm'")(0)(1)
                lblModelType.Text = dtCaption.Select("TAG='lblModelType'")(0)(1)
                lblModelYear.InnerText = dtCaption.Select("TAG='lblModelYear'")(0)(1)
                lblRegYear.InnerText = dtCaption.Select("TAG='lblRegYear'")(0)(1)
                lblRegDate.InnerText = dtCaption.Select("TAG='lblRegDate'")(0)(1)
                lblRegDateNO.InnerText = dtCaption.Select("TAG='lblRegDateNO'")(0)(1)
                lblLastRegDate.InnerText = dtCaption.Select("TAG='lblLastRegDate'")(0)(1)
                lblDeregDate.InnerText = dtCaption.Select("TAG='lblDeregDate'")(0)(1)
                lblColor.InnerText = dtCaption.Select("TAG='lblColor'")(0)(1)
                lblMileage.Text = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblMileageDate.Text = dtCaption.Select("TAG='lblMileageDate'")(0)(1)
                lblHours.Text = dtCaption.Select("TAG='lblHours'")(0)(1)
                lblHoursDate.Text = dtCaption.Select("TAG='lblHoursDate'")(0)(1)
                cbMachineHours.Text = dtCaption.Select("TAG='lblMachineHours'")(0)(1)
                lblCategory.InnerText = dtCaption.Select("TAG='lblCategory'")(0)(1)
                lblVehicleType.InnerText = dtCaption.Select("TAG='lblVehicleType'")(0)(1)
                lblWarrantyCode.InnerText = dtCaption.Select("TAG='lblWarrantyCode'")(0)(1)
                lblNetWeight.InnerText = dtCaption.Select("TAG='lblNetWeight'")(0)(1)
                lblTotWeight.InnerText = dtCaption.Select("TAG='lblTotWeight'")(0)(1)
                lblProjectNumber.InnerText = dtCaption.Select("TAG='lblProjectNumber'")(0)(1)
                lblLastContactDate.InnerText = dtCaption.Select("TAG='lblLastContactDate'")(0)(1)
                lblPracticalLoad.InnerText = dtCaption.Select("TAG='lblPracticalLoad'")(0)(1)
                lblMaxRoofLoad.InnerText = dtCaption.Select("TAG='lblMaxRoofLoad'")(0)(1)
                liEarlyRegNo1.Text = dtCaption.Select("TAG='lblEarlyRegNo1'")(0)(1)
                liEarlyRegNo2.Text = dtCaption.Select("TAG='lblEarlyRegNo2'")(0)(1)
                liEarlyRegNo3.Text = dtCaption.Select("TAG='lblEarlyRegNo3'")(0)(1)
                liEarlyRegNo4.Text = dtCaption.Select("TAG='lblEarlyRegNo4'")(0)(1)
                lblVehicleModel.InnerText = dtCaption.Select("TAG='lblVehicleModel'")(0)(1)
                lblVehicleInformation.InnerText = dtCaption.Select("TAG='lblVehicleInformation'")(0)(1)
                lblVehicleDetails.InnerText = dtCaption.Select("TAG='lblVehicleDetails'")(0)(1)
                lblInformation.InnerText = dtCaption.Select("TAG='lblInformation'")(0)(1)
                lblEarlierRegNumbers.InnerText = dtCaption.Select("TAG='lblEarlierRegNumbers'")(0)(1)
                'Technical tab labels
                lblTechnicalData.InnerText = dtCaption.Select("TAG='lblTechnicalData'")(0)(1)
                lblVehicleGroup.InnerText = dtCaption.Select("TAG='lblVehicleGroup'")(0)(1)
                lblVinNo.InnerText = dtCaption.Select("TAG='lblVinNumber'")(0)(1)
                lblPickNo.InnerText = dtCaption.Select("TAG='lblPickNumber'")(0)(1)
                lblMakeCode.InnerText = dtCaption.Select("TAG='lblMakeCode'")(0)(1)
                lblRicambiNo.InnerText = dtCaption.Select("TAG='lblRicambiNumber'")(0)(1)
                lblEngineNo.InnerText = dtCaption.Select("TAG='lblEngineNumber'")(0)(1)
                lblFuelCode.InnerText = dtCaption.Select("TAG='lblFuelCode'")(0)(1)
                lblFuelCard.InnerText = dtCaption.Select("TAG='lblFuelCard'")(0)(1)
                lblGearbox.InnerText = dtCaption.Select("TAG='lblGearbox'")(0)(1)
                lblDetails.InnerText = dtCaption.Select("TAG='lblDetails'")(0)(1)
                lblWarehouseNo.InnerText = dtCaption.Select("TAG='lblWarehouseNumber'")(0)(1)
                lblKeyNumber.InnerText = dtCaption.Select("TAG='lblKeyNumber'")(0)(1)
                lblDoorKey.InnerText = dtCaption.Select("TAG='lblDoorKey'")(0)(1)
                lblForm.InnerText = dtCaption.Select("TAG='lblForm'")(0)(1)
                lblInterorCode.InnerText = dtCaption.Select("TAG='lblInterorCode'")(0)(1)
                lblPurchaseOrder.InnerText = dtCaption.Select("TAG='lblPurchaseOrder'")(0)(1)
                lblAddonGroup.InnerText = dtCaption.Select("TAG='lblAddonGroup'")(0)(1)
                lblDateExpectedIn.InnerText = dtCaption.Select("TAG='lblDateExpectedIn'")(0)(1)
                lblTires.InnerText = dtCaption.Select("TAG='lblTires'")(0)(1)
                lblServiceCategory.InnerText = dtCaption.Select("TAG='lblServiceCategory'")(0)(1)
                lblNOApprovalNo.InnerText = dtCaption.Select("TAG='lblNOApprovalNumber'")(0)(1)
                lblEUApprovalNo.InnerText = dtCaption.Select("TAG='lblEUApprovalNumber'")(0)(1)
                lblVanNumber.InnerText = dtCaption.Select("TAG='lblVanNumber'")(0)(1)
                lblProductNumber.InnerText = dtCaption.Select("TAG='lblProductNumber'")(0)(1)
                lblElCode.InnerText = dtCaption.Select("TAG='lblElCode'")(0)(1)
                lblVehicleDateMileage.InnerText = dtCaption.Select("TAG='lblVehicleDateMileage'")(0)(1)
                lblTakenInDate.InnerText = dtCaption.Select("TAG='lblTakenInDate'")(0)(1)
                lblMileageTakenIn.InnerText = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblDeliveryDate.InnerText = dtCaption.Select("TAG='lblDeliveryDate'")(0)(1)
                lblMileageDelivered.InnerText = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblServiceDate.InnerText = dtCaption.Select("TAG='lblServiceDate'")(0)(1)
                lblMileageService.InnerText = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblCallInDate.InnerText = dtCaption.Select("TAG='lblCallInDate'")(0)(1)
                lblMileageCallIn.InnerText = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblCleanedDate.InnerText = dtCaption.Select("TAG='lblCleanedDate'")(0)(1)
                lblLength.InnerText = dtCaption.Select("TAG='lblLength'")(0)(1)
                lblWidth.InnerText = dtCaption.Select("TAG='lblWidth'")(0)(1)
                lblTechDocNo.InnerText = dtCaption.Select("TAG='lblTechDocNumber'")(0)(1)
                lblStdNoise.InnerText = dtCaption.Select("TAG='lblStdNoise'")(0)(1)
                lblEffectKw.InnerText = dtCaption.Select("TAG='lblEffectKw'")(0)(1)
                lblPistonDisp.InnerText = dtCaption.Select("TAG='lblPistonDisp'")(0)(1)
                lblRoundMin.InnerText = dtCaption.Select("TAG='lblRoundsMin'")(0)(1)
                cbTechUsedImported.Text = dtCaption.Select("TAG='lblUsedImported'")(0)(1)
                cbTechPressureMechBrakes.Text = dtCaption.Select("TAG='lblPressureMechBrakes'")(0)(1)
                cbTechTowbar.Text = dtCaption.Select("TAG='lblTowbar'")(0)(1)
                cbTechServiceBook.Text = dtCaption.Select("TAG='lblServiceBook'")(0)(1)
                liTechLastPkkOk.Text = dtCaption.Select("TAG='lblLastPKKOk'")(0)(1)
                liTechNextPkk.Text = dtCaption.Select("TAG='lblNextPKK'")(0)(1)
                liTechLastInvoicedPkk.Text = dtCaption.Select("TAG='lblLastInvoicedPKK'")(0)(1)
                cbTechCallInService.Text = dtCaption.Select("TAG='lblCallInService'")(0)(1)
                liTechCallInMonth.Text = dtCaption.Select("TAG='lblCallInMonth'")(0)(1)
                liTechMileage.Text = dtCaption.Select("TAG='lblMileage'")(0)(1)
                cbTechDoNotCallPkk.Text = dtCaption.Select("TAG='lblDoNotCallPKK'")(0)(1)
                liTechDeviationsPkk.Text = dtCaption.Select("TAG='lblDeviationsPKK'")(0)(1)
                liTechYearlyMileage.Text = dtCaption.Select("TAG='lblYearlyMileage'")(0)(1)
                liTechRadioCode.Text = dtCaption.Select("TAG='lblRadioCode'")(0)(1)
                liTechStartImmobilizer.Text = dtCaption.Select("TAG='lblStartImobilizer'")(0)(1)
                liTechQtyKeys.Text = dtCaption.Select("TAG='lblQtyKeys'")(0)(1)
                liTechKeyTag.Text = dtCaption.Select("TAG='lblKeyTagNumber'")(0)(1)
                'TAB Economy captions
                lblSalesPriceExVat.InnerText = dtCaption.Select("TAG='lblSalesPriceExVat'")(0)(1)
                lblSalesFees.InnerText = dtCaption.Select("TAG='lblSalesFees'")(0)(1)
                lblSalesEquipment.InnerText = dtCaption.Select("TAG='lblSalesEquipment'")(0)(1)
                lblRegistrationCosts.InnerText = dtCaption.Select("TAG='lblRegistrationCosts'")(0)(1)
                lblSubtractedDiscount.InnerText = dtCaption.Select("TAG='lblSubtractedDiscount'")(0)(1)
                lblSalesPriceNet.InnerText = dtCaption.Select("TAG='lblSalesPriceNet'")(0)(1)
                lblSubtractedCosts.InnerText = dtCaption.Select("TAG='lblSubtractedCosts'")(0)(1)
                lblAssistSales.InnerText = dtCaption.Select("TAG='lblAssistSales'")(0)(1)
                lblCostAfterSale.InnerText = dtCaption.Select("TAG='lblCostAfterSale'")(0)(1)
                lblContributionToday.InnerText = dtCaption.Select("TAG='lblContributionToday'")(0)(1)
                lblVehiclePrice.InnerText = dtCaption.Select("TAG='lblVehiclePrice'")(0)(1)
                lblSalesPriceGross.InnerText = dtCaption.Select("TAG='lblSalesPriceGross'")(0)(1)
                lblRegistrationFee.InnerText = dtCaption.Select("TAG='lblRegistrationFees'")(0)(1)
                lblVatFromSalesprice.InnerText = dtCaption.Select("TAG='lblVatFromSalesPrice'")(0)(1)
                lblTotalVehicleAmount.InnerText = dtCaption.Select("TAG='lblTotalVehicleAmount'")(0)(1)
                lblWreckingAmount.InnerText = dtCaption.Select("TAG='lblWreckingAmount'")(0)(1)
                lblYearlyFee.InnerText = dtCaption.Select("TAG='lblYearlyFee'")(0)(1)
                lblInsurance.InnerText = dtCaption.Select("TAG='lblInsurance'")(0)(1)
                lblCosts.InnerText = dtCaption.Select("TAG='lblCosts'")(0)(1)
                lblCostPriceNet.InnerText = dtCaption.Select("TAG='lblCostPriceNet'")(0)(1)
                lblInsuranceBonus.InnerText = dtCaption.Select("TAG='lblInsuranceBonus'")(0)(1)
                lblCostFee.InnerText = dtCaption.Select("TAG='lblCostFee'")(0)(1)
                lblCostBeforeSale.InnerText = dtCaption.Select("TAG='lblCostBeforeSale'")(0)(1)
                lblSalesProvision.InnerText = dtCaption.Select("TAG='lblSalesProvision'")(0)(1)
                lblCommitDay.InnerText = dtCaption.Select("TAG='lblCommitDays'")(0)(1)
                lblAddedInterests.InnerText = dtCaption.Select("TAG='lblAddedInterests'")(0)(1)
                lblCostEquipment.InnerText = dtCaption.Select("TAG='lblCostEquipment'")(0)(1)
                lblTotalCost.InnerText = dtCaption.Select("TAG='lblTotalCost'")(0)(1)

                'captions for customer tab is set "on hold"
                '-------------------------------
                'captions for Web tab
                lblWebMake.InnerText = dtCaption.Select("TAG='lblMake'")(0)(1)
                lblWebModel.InnerText = dtCaption.Select("TAG='lblModelType'")(0)(1)
                lblWebDescription.InnerText = dtCaption.Select("TAG='lblDescription'")(0)(1)
                lblWebGearbox.InnerText = dtCaption.Select("TAG='lblGearbox'")(0)(1)
                lblWebGearboxDescription.InnerText = dtCaption.Select("TAG='lblGearboxDescription'")(0)(1)
                lblWebTraction.InnerText = dtCaption.Select("TAG='lblTraction'")(0)(1)
                lblWebTractionDescription.InnerText = dtCaption.Select("TAG='lblTractionDescription'")(0)(1)
                lblWebModelYear.InnerText = dtCaption.Select("TAG='lblModelYear'")(0)(1)
                lblWebPrice.InnerText = dtCaption.Select("TAG='lblAskingPrice'")(0)(1)
                lblWebMileage.InnerText = dtCaption.Select("TAG='lblMileage'")(0)(1)
                lblWebFuel.InnerText = dtCaption.Select("TAG='lblFuelCode'")(0)(1)
                lblWebEffectBHP.InnerText = dtCaption.Select("TAG='lblEffectBHP'")(0)(1)
                lblWebCylinderLitres.InnerText = dtCaption.Select("TAG='lblCylinderLitres'")(0)(1)
                cbWebAsShown.Text = dtCaption.Select("TAG='lblAsShown'")(0)(1)
                cbWebInclYearlyFee.Text = dtCaption.Select("TAG='lblIncludeYearlyFee'")(0)(1)
                cbWebinclRegFee.Text = dtCaption.Select("TAG='lblWebIncludeRegFee'")(0)(1)
                cbWebInclRegCosts.Text = dtCaption.Select("TAG='lblIncludeRegCosts'")(0)(1)
                btnEquipment.Value = dtCaption.Select("TAG='lblEquipment'")(0)(1)
                btnPublish.Value = dtCaption.Select("TAG='lblPublish'")(0)(1)
                cbWebPublish.Text = dtCaption.Select("TAG='lblPublish'")(0)(1)
                lblWebMainColor.InnerText = dtCaption.Select("TAG='lblMainColor'")(0)(1)
                lblWebColorDescription.InnerText = dtCaption.Select("TAG='lblColorDescription'")(0)(1)
                lblWebInteriorColor.InnerText = dtCaption.Select("TAG='lblInteriorColor'")(0)(1)
                lblWebChassi.InnerText = dtCaption.Select("TAG='lblChassi'")(0)(1)
                lblWebFirstTimeReg.InnerText = dtCaption.Select("TAG='lblFirstTimeReg'")(0)(1)
                lblWebRegno.InnerText = dtCaption.Select("TAG='lblRegNo'")(0)(1)
                lblWebDoorQty.InnerText = dtCaption.Select("TAG='lblDoorQty'")(0)(1)
                lblWebSeatQty.InnerText = dtCaption.Select("TAG='lblSeatQty'")(0)(1)
                lblWebOwnerQty.InnerText = dtCaption.Select("TAG='lblOwnerQty'")(0)(1)
                lblWebHeaderSalesPlace.InnerText = dtCaption.Select("TAG='lblSalesPlace'")(0)(1)
                lblWebAddress.InnerText = dtCaption.Select("TAG='lblAddress'")(0)(1)
                lblWebZipcode.InnerText = dtCaption.Select("TAG='lblZipCode'")(0)(1)
                lblWebPlace.InnerText = dtCaption.Select("TAG='lblPlace'")(0)(1)
                lblWebCountry.InnerText = dtCaption.Select("TAG='lblCountry'")(0)(1)
                lblWebHeaderContactPerson.InnerText = dtCaption.Select("TAG='lblContactPerson'")(0)(1)
                lblWebName.InnerText = dtCaption.Select("TAG='lblName'")(0)(1)
                lblWebMail.InnerText = dtCaption.Select("TAG='lblMail'")(0)(1)
                lblWebPhone1.InnerText = dtCaption.Select("TAG='lblPhone1'")(0)(1)
                lblWebPhone2.InnerText = dtCaption.Select("TAG='lblPhone2'")(0)(1)
                'web page equipment window
                'Multimedia
                cbEqCdPlayer.Text = dtCaption.Select("TAG='lblEqCDPlayer'")(0)(1)
                cbEqRadio.Text = dtCaption.Select("TAG='lblEqRadio'")(0)(1)
                cbEqSpeakers.Text = dtCaption.Select("TAG='lblEqSpeakers'")(0)(1)
                cbEqBandPlayer.Text = dtCaption.Select("TAG='lblEqBandPlayer'")(0)(1)
                cbEqCDChanger.Text = dtCaption.Select("TAG='lblEqCDChanger'")(0)(1)
                cbEqMP3player.Text = dtCaption.Select("TAG='lblEqMP3Player'")(0)(1)
                cbEqSubwoofer.Text = dtCaption.Select("TAG='lblEqSubWoofer'")(0)(1)
                cbEqDVDVideo.Text = dtCaption.Select("TAG='lblEqDVDVideo'")(0)(1)
                cbEqDVDAudio.Text = dtCaption.Select("TAG='lblEqDVDAudio'")(0)(1)
                cbEqScreen.Text = dtCaption.Select("TAG='lblEqScreen'")(0)(1)
                cbEqSacdPlayer.Text = dtCaption.Select("TAG='lblEqSACDPlayer'")(0)(1)
                cbEqNavigation.Text = dtCaption.Select("TAG='lblEqNavigation'")(0)(1)
                cbEqRemoteControl.Text = dtCaption.Select("TAG='lblEqRemoteControl'")(0)(1)
                cbEqSteeringControl.Text = dtCaption.Select("TAG='lblEqSteeringControl'")(0)(1)
                cbEqPhone.Text = dtCaption.Select("TAG='lblPhone'")(0)(1)
                cbEqTV.Text = dtCaption.Select("TAG='lblEqTV'")(0)(1)
                cbEqDrivingCpu.Text = dtCaption.Select("TAG='lblEqDrivingCpu'")(0)(1)
                cbEqOutputAUX.Text = dtCaption.Select("TAG='lblEqOutputAux'")(0)(1)
                'Comfort
                cbEqCentralLock.Text = dtCaption.Select("TAG='lblEqCentralLock'")(0)(1)
                cbEqAirCondition.Text = dtCaption.Select("TAG='lblEqAircondition'")(0)(1)
                cbEqElClimate.Text = dtCaption.Select("TAG='lblEqElClimate'")(0)(1)
                cbEqEngineVarmer.Text = dtCaption.Select("TAG='lblEqEngineVarmer'")(0)(1)
                cbEqCupeVarm.Text = dtCaption.Select("TAG='lblEqElCoupeVarmer'")(0)(1)
                cbEqAutomaticGear.Text = dtCaption.Select("TAG='lblEqAutomaticGear'")(0)(1)
                cbEqHandlingControl.Text = dtCaption.Select("TAG='lblEqHandlingControl'")(0)(1)
                cbEqElJustableMirror.Text = dtCaption.Select("TAG='lblEqElJustableMirrors'")(0)(1)
                cbEqElClosingMirrors.Text = dtCaption.Select("TAG='lblEqElClosingMirrors'")(0)(1)
                cbEqElVarmingMirrors.Text = dtCaption.Select("TAG='lblEqElVarmingMirrors'")(0)(1)
                cbEqHatch.Text = dtCaption.Select("TAG='lblEqElHatch'")(0)(1)
                cbEqElCab.Text = dtCaption.Select("TAG='lblEqElCab'")(0)(1)
                cbEqCruiseControl.Text = dtCaption.Select("TAG='lblEqCruiseControl'")(0)(1)
                cbEqRainSensor.Text = dtCaption.Select("TAG='lblEqRainSensor'")(0)(1)
                cbEqMultiFunctionSteering.Text = dtCaption.Select("TAG='lblEqMultiFunctionSteering'")(0)(1)
                cbEqElWindows.Text = dtCaption.Select("TAG='lblEqElWindows'")(0)(1)
                cbEqElJustSeats.Text = dtCaption.Select("TAG='lblEqElSeats'")(0)(1)
                cbEqElCurtain.Text = dtCaption.Select("TAG='lblEqElCurtain'")(0)(1)
                cbEqElAntenna.Text = dtCaption.Select("TAG='lblEqElAntenna'")(0)(1)
                cbEqAirVentilatedChairs.Text = dtCaption.Select("TAG='lblEqAirVentilatedSeats'")(0)(1)
                cbEqHeightJustableSeats.Text = dtCaption.Select("TAG='lblEqHeightJustableSeats'")(0)(1)
                cbEqJustableSteering.Text = dtCaption.Select("TAG='lblEqJustableSteeringWheel'")(0)(1)
                cbEqColoredGlass.Text = dtCaption.Select("TAG='lblEqColoredGlass'")(0)(1)
                cbEqArmLean.Text = dtCaption.Select("TAG='lblEqArmLean'")(0)(1)
                cbEqAirSuspension.Text = dtCaption.Select("TAG='lblEqAirSuspension'")(0)(1)
                cbEqSunCurtain.Text = dtCaption.Select("TAG='lblEqSunCurtain'")(0)(1)
                cbEqVarmSoothingFront.Text = dtCaption.Select("TAG='lblEqVarmSoothingFront'")(0)(1)
                cbEqVarmingSeats.Text = dtCaption.Select("TAG='lblEqVarmingSeats'")(0)(1)
                cbEqMemorySeats.Text = dtCaption.Select("TAG='lblEqMemorySeats'")(0)(1)
                ''Safety
                cbEqABSBrakes.Text = dtCaption.Select("TAG='lblEqABSBrakes'")(0)(1)
                cbEqAirBag.Text = dtCaption.Select("TAG='lblEqAirBag'")(0)(1)
                cbEqXenonLight.Text = dtCaption.Select("TAG='lblEqXenonLights'")(0)(1)
                cbEqAntiSpin.Text = dtCaption.Select("TAG='lblEqAntiSpin'")(0)(1)
                cbEqESP.Text = dtCaption.Select("TAG='lblEqESP'")(0)(1)
                cbEqDimCenterMirror.Text = dtCaption.Select("TAG='lblEqDimCenterMirror'")(0)(1)
                cbEqHandsfree.Text = dtCaption.Select("TAG='lblEqHandsfree'")(0)(1)
                cbEqParkingSystem.Text = dtCaption.Select("TAG='lblEqParkingSystem'")(0)(1)
                cbEqElVarmingFrontWindow.Text = dtCaption.Select("TAG='lblEqElVarmingFrontWindow'")(0)(1)
                cbEq4WD.Text = dtCaption.Select("TAG='lblEq4WD'")(0)(1)
                cbEqDiffBrake.Text = dtCaption.Select("TAG='lblEqDifferentialBrakes'")(0)(1)
                cbEqLevelRegulator.Text = dtCaption.Select("TAG='lblEqLevelregulator'")(0)(1)
                cbEqLightWasher.Text = dtCaption.Select("TAG='lblEqLightWasher'")(0)(1)
                cbEqDirectionsInMirrors.Text = dtCaption.Select("TAG='lblEqDirectionsInMirrors'")(0)(1)
                cbEqExtraLights.Text = dtCaption.Select("TAG='lblEqExtraLights'")(0)(1)
                cbEqAlarm.Text = dtCaption.Select("TAG='lblEqAlarm'")(0)(1)
                cbEqKeylessGo.Text = dtCaption.Select("TAG='lblEqKeylessGo'")(0)(1)
                cbEqStartBlock.Text = dtCaption.Select("TAG='lblEqStartBlock'")(0)(1)
                cbEqParkSensor.Text = dtCaption.Select("TAG='lblEqParkSensor'")(0)(1)
                cbEqBackingCamera.Text = dtCaption.Select("TAG='lblEqBackingCamera'")(0)(1)
                cbEqIntegratedChildSeats.Text = dtCaption.Select("TAG='lblEqIntegratedChildSeats'")(0)(1)
                ''Sport
                cbEqSportSteeringwheel.Text = dtCaption.Select("TAG='lblEqSportSteeringWheel'")(0)(1)
                cbEqLoweredChassi.Text = dtCaption.Select("TAG='lblEqLoweredChassi'")(0)(1)
                cbEqSportsSeats.Text = dtCaption.Select("TAG='lblEqSportsSeats'")(0)(1)
                ''View
                cbEqAluminiumRims.Text = dtCaption.Select("TAG='lblEqAluminiumRims'")(0)(1)
                cbEqRails.Text = dtCaption.Select("TAG='lblEqRails'")(0)(1)
                cbEqLeather.Text = dtCaption.Select("TAG='lblEqLeather'")(0)(1)
                cbEqWoodenInterior.Text = dtCaption.Select("TAG='lblEqWoodenInterior'")(0)(1)
                cbEqMirrors.Text = dtCaption.Select("TAG='lblEqMirrors'")(0)(1)
                cbEqBumpers.Text = dtCaption.Select("TAG='lblEqBumpers'")(0)(1)
                cbEqSpoilerBack.Text = dtCaption.Select("TAG='lblEqRearSpoiler'")(0)(1)
                cbEqPartLeather.Text = dtCaption.Select("TAG='lblEqPartLeather'")(0)(1)
                cbEqMetalicPaint.Text = dtCaption.Select("TAG='lblEqMetalicPaint'")(0)(1)
                cbEqDarkSideScreens.Text = dtCaption.Select("TAG='lblEqDarkSideScreens'")(0)(1)
                ''Others
                cbEqTowbar.Text = dtCaption.Select("TAG='lblTowbar'")(0)(1)
                cbEqSkiBag.Text = dtCaption.Select("TAG='lblEqSkiBag'")(0)(1)
                cbEqSkiBox.Text = dtCaption.Select("TAG='lblEqSkiBox'")(0)(1)
                cbEqLoadroomMat.Text = dtCaption.Select("TAG='lblEqLoadRoomMat'")(0)(1)
                cbEq12V.Text = dtCaption.Select("TAG='lblEq12V'")(0)(1)
                'Prospect tab
                lblProsProspect.InnerText = dtCaption.Select("TAG='lblProspect'")(0)(1)
                lblProsTitle.InnerText = dtCaption.Select("TAG='lblTitle'")(0)(1)
                lblProsDescription.InnerText = dtCaption.Select("TAG='lblDescription'")(0)(1)
                lblProsVideoUrl.InnerText = dtCaption.Select("TAG='lblVideoUrl'")(0)(1)
                cbProsShowOnMonitor.Text = dtCaption.Select("TAG='lblShowOnMonitor'")(0)(1)
                lblProsTopLogoPath.InnerText = dtCaption.Select("TAG='lblTopLogoPath'")(0)(1)
                btnProsFindTopLogo.Value = dtCaption.Select("TAG='btnFindTarget'")(0)(1)
                lblProsBottomLogoPath.InnerText = dtCaption.Select("TAG='lblBottomLogoPath'")(0)(1)
                btnProsBottomLogoPath.Value = dtCaption.Select("TAG='btnFindTarget'")(0)(1)
                'Trailer tab
                lblTrailerChassi.InnerText = dtCaption.Select("TAG='lblTrailerChassi'")(0)(1)
                lblTrailerAxle1.InnerText = dtCaption.Select("TAG='lblAxle1'")(0)(1)
                lblTrailerAxle2.InnerText = dtCaption.Select("TAG='lblAxle2'")(0)(1)
                lblTrailerAxle3.InnerText = dtCaption.Select("TAG='lblAxle3'")(0)(1)
                lblTrailerAxle4.InnerText = dtCaption.Select("TAG='lblAxle4'")(0)(1)
                lblTrailerAxle5.InnerText = dtCaption.Select("TAG='lblAxle5'")(0)(1)
                lblTrailerAxle6.InnerText = dtCaption.Select("TAG='lblAxle6'")(0)(1)
                lblTrailerAxle7.InnerText = dtCaption.Select("TAG='lblAxle7'")(0)(1)
                lblTrailerAxle8.InnerText = dtCaption.Select("TAG='lblAxle8'")(0)(1)
                lblTrailerDescription.InnerText = dtCaption.Select("TAG='lblDescription'")(0)(1)
                'Certificate tab
                lblCertVehicleCertification.InnerText = dtCaption.Select("TAG='lblVehicleCertification'")(0)(1)
                lblCertTireDimFront.InnerText = dtCaption.Select("TAG='lblTireDimFront'")(0)(1)
                lblCertTireDimBack.InnerText = dtCaption.Select("TAG='lblTireDimBack'")(0)(1)
                lblCertLiPlyratFront.InnerText = dtCaption.Select("TAG='lblLiPlyratFront'")(0)(1)
                lblCertLiPlyratBack.InnerText = dtCaption.Select("TAG='lblLiPlyratBack'")(0)(1)
                lblCertMinInpressFront.InnerText = dtCaption.Select("TAG='lblMinInpressFront'")(0)(1)
                lblCertMinInpressBack.InnerText = dtCaption.Select("TAG='lblMinInpressBack'")(0)(1)
                lblCertStdRimFront.InnerText = dtCaption.Select("TAG='lbllblStdRimFront'")(0)(1)
                lblCertStdRimBack.InnerText = dtCaption.Select("TAG='lblStdRimBack'")(0)(1)
                lblCertMinSpeedFront.InnerText = dtCaption.Select("TAG='lblMinSpeedFront'")(0)(1)
                lblCertMinSpeedBack.InnerText = dtCaption.Select("TAG='lblMinSpeedBack'")(0)(1)
                lblCertMaxWheelWidthFront.InnerText = dtCaption.Select("TAG='lblMaxWheelWidthFront'")(0)(1)
                lblCertMaxWheelWidthBack.InnerText = dtCaption.Select("TAG='lblMaxWheelWidthBack'")(0)(1)
                lblCertAxlePressureFront.InnerText = dtCaption.Select("TAG='lblAxlePressureFront'")(0)(1)
                lblCertAxlePressureBack.InnerText = dtCaption.Select("TAG='lblAxlePressureBack'")(0)(1)
                lblCertNumberOfAxles.InnerText = dtCaption.Select("TAG='lblNumberOfAxles'")(0)(1)
                lblCertAxlesWithTraction.InnerText = dtCaption.Select("TAG='lblAxlesWithTraction'")(0)(1)
                lblCertGear.InnerText = dtCaption.Select("TAG='lblGear'")(0)(1)
                lblCertMaxRoofWeight.InnerText = dtCaption.Select("TAG='lblMaxRoofWeight'")(0)(1)
                lblCertTrailerEtc.InnerText = dtCaption.Select("TAG='lblTrailerEtc'")(0)(1)
                lblCertTrailerWeightWBrakes.InnerText = dtCaption.Select("TAG='lblTrailerWeightWithBrakes'")(0)(1)
                lblCertTrailerWeight.InnerText = dtCaption.Select("TAG='lblTrailerWeight'")(0)(1)
                lblCertMaxWeightTowbar.InnerText = dtCaption.Select("TAG='lblMaxWeightTowbar'")(0)(1)
                lblCertLengthToTowbar.InnerText = dtCaption.Select("TAG='lblLengthToTowbar'")(0)(1)
                lblCertTotTrailerWeight.InnerText = dtCaption.Select("TAG='lblTotalTrailerWeight'")(0)(1)
                lblCertNumberOfSeats.InnerText = dtCaption.Select("TAG='lblNumberOfSeats'")(0)(1)
                lblCertValidFrom.InnerText = dtCaption.Select("TAG='lblValidFrom'")(0)(1)
                lblCertEuVersion.InnerText = dtCaption.Select("TAG='lblEUversion'")(0)(1)
                lblCertEuVariant.InnerText = dtCaption.Select("TAG='lblEUVariant'")(0)(1)
                lblCertEuronorm.InnerText = dtCaption.Select("TAG='lblEuronorm'")(0)(1)
                lblCertCO2Emission.InnerText = dtCaption.Select("TAG='lblCO2Emission'")(0)(1)
                lblCertMakeParticleFilter.InnerText = dtCaption.Select("TAG='lblMakeParticleFilter'")(0)(1)
                lblCertAnnotation.InnerText = dtCaption.Select("TAG='lblNotes'")(0)(1)
                liCertChassi.Text = dtCaption.Select("TAG='lblChassi'")(0)(1)
                liCertIdentity.Text = dtCaption.Select("TAG='lblIdentity'")(0)(1)
                liCertCertificate.Text = dtCaption.Select("TAG='lblCertificate'")(0)(1)
                liCertNote.Text = dtCaption.Select("TAG='lblAnnotation'")(0)(1)
                'mod boxes and buttons in the system etc.
                lblModAnnotation.InnerText = dtCaption.Select("TAG='lblAnnotation'")(0)(1)
                btnSaveGeneralAnnotation.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                lblModNote.InnerText = dtCaption.Select("TAG='lblNote'")(0)(1)
                btnSaveGeneralNote.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                lblModVehicleEquipment.InnerText = dtCaption.Select("TAG='lblVehicleEquipment'")(0)(1)
                lblOthers.InnerText = dtCaption.Select("TAG='lblOthers'")(0)(1)
                btnSaveEquipment.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)

                lblContactResults.Text = ""
                lblContactResults.Visible = False


            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
    End Sub
    <WebMethod()>
    Public Shared Function FetchMVRDetails(ByVal regNo As String) As VehicleBO()
        Try
            details = objVehicleService.GetMVRData(regNo)
        Catch ex As Exception
            'objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "LoadSubsidiary", ex.Message, _loginName)
        End Try
        Return details.ToList.ToArray
    End Function
    <WebMethod()>
    Public Shared Function AddVehicle(ByVal refNo As String, ByVal regNo As String, ByVal chassi_vin As String, ByVal vehType As String, ByVal vehStatus As String, ByVal makeCode As String, ByVal model As String, ByVal vehicleType As String, ByVal annotation As String, ByVal note As String, ByVal modelYear As String, ByVal regYear As String, ByVal regDate As String, ByVal regDateNor As String, ByVal lastRegDate As String, ByVal deregDate As String, ByVal color As String, ByVal mileage As String, ByVal mileageDate As String, ByVal hours As String, ByVal hoursDate As String, ByVal machineHrs As String, ByVal category As String, ByVal modelType As String, ByVal warrantyCode As String, ByVal netWeight As String, ByVal totWeight As String, ByVal projNo As String, ByVal lastContDate As String, ByVal practicalLoad As String, ByVal maxRoofLoad As String, ByVal earlrRegNo1 As String, ByVal earlrRegNo2 As String, ByVal earlrRegNo3 As String, ByVal earlrRegNo4 As String, ByVal vehGroup As String, ByVal pickNo As String, ByVal makeCodeNo As String, ByVal ricambiNo As String, ByVal engineNo As String, ByVal fuelCode As String, ByVal fuelCard As String, ByVal gearBox As String, ByVal wareHouse As String, ByVal keyNo As String, ByVal doorKeyNo As String, ByVal controlForm As String, ByVal interiorCode As String, ByVal purchaseNo As String, ByVal addonGroup As String, ByVal dateExpectedIn As String, ByVal tires As String, ByVal serviceCategory As String, ByVal noApprovalNo As String, ByVal euApprovalNo As String, ByVal vanNo As String, ByVal productNo As String, ByVal elCode As String, ByVal takenInDate As String, ByVal takenInDateMileage As String, ByVal deliveryDate As String, ByVal deliveryDateMileage As String, ByVal serviceDate As String, ByVal serviceDateMileage As String, ByVal callInDate As String, ByVal callInDateMileage As String, ByVal cleanedDate As String, ByVal techdocNo As String, ByVal length As String, ByVal width As String, ByVal noise As String, ByVal effectkW As String, ByVal pistonDisp As String, ByVal rounds As String, ByVal usedImported As String, ByVal pressureMechBrakes As String, ByVal towbar As String, ByVal serviceBook As String, ByVal lastPKKApproved As String, ByVal nextPKK As String, ByVal lastPKKInvoiced As String, ByVal callInToService As Boolean, ByVal callInMonth As String, ByVal techMileage As String, ByVal doNotCallPKK As Boolean, ByVal deviationPKK As String, ByVal yearlyMileage As String, ByVal radioCode As String, ByVal startImmobilizer As String, ByVal qtyKeys As String, ByVal keyTag As String, ByVal salesPriceNet As String, ByVal salesSale As String, ByVal salesEquipment As String, ByVal regCosts As String, ByVal discount As String, ByVal netSalesPrice As String, ByVal fixCost As String, ByVal assistSales As String, ByVal costAfterSale As String, ByVal contributionsToday As String, ByVal salesPriceGross As String, ByVal regFee As String, ByVal vat As String, ByVal totAmount As String, ByVal wreckingAmount As String, ByVal yearlyFee As String, ByVal insurance As String, ByVal costPriceNet As String, ByVal insuranceBonus As String, ByVal costSales As String, ByVal costBeforeSale As String, ByVal salesProvision As String, ByVal commitDay As String, ByVal addedInterests As String, ByVal costEquipment As String, ByVal totalCost As String, ByVal creditNoteNo As String, ByVal creditNoteDate As String, ByVal invoiceNo As String, ByVal invoiceDate As String, ByVal rebuyDate As String, ByVal rebuyPrice As String, ByVal costPerKm As String, ByVal turnover As String, ByVal progress As String, ByVal axle1 As String, ByVal axle2 As String, ByVal axle3 As String, ByVal axle4 As String, ByVal axle5 As String, ByVal axle6 As String, ByVal axle7 As String, ByVal axle8 As String, ByVal trailerDesc As String, ByVal tireDimFront As String, ByVal tireDimBack As String, ByVal minliFront As String, ByVal minliBack As String, ByVal minInpressFront As String, ByVal minInpressBack As String, ByVal stdRimFront As String, ByVal stdRimBack As String, ByVal minSpeedFront As String, ByVal minSpeedBack As String, ByVal maxTrackFront As String, ByVal maxTrackBack As String, ByVal axlePressureFront As String, ByVal axlePressureBack As String, ByVal qtyAxles As String, ByVal operativeAxles As String, ByVal driveWheel As String, ByVal trailerWithBrakes As String, ByVal trailerWeight As String, ByVal maxLoadTowbar As String, ByVal lengthToTowbar As String, ByVal totalTrailerWeight As String, ByVal seats As String, ByVal validFrom As String, ByVal euVersion As String, ByVal euVariant As String, ByVal euronorm As String, ByVal co2Emission As String, ByVal makeParticleFilter As String, ByVal chassiText As String, ByVal identity As String, ByVal certificate As String, ByVal certificateAnnotation As String, ByVal idCustomer As String, ByVal idVatCode As String) As String()
        Dim strResult As String()
        Dim dsReturnValStr As String = ""
        Try

            objVehBo.IntNo = refNo.ToString()
            objVehBo.VehRegNo = regNo.ToString()
            objVehBo.VehVin = chassi_vin.ToString()
            objVehBo.VehType = vehType
            objVehBo.VehStatus = vehStatus
            objVehBo.Make = makeCode
            objVehBo.Model = model
            objVehBo.VehicleType = vehicleType
            objVehBo.Annotation = annotation
            objVehBo.Note = note

            If regDate <> "" Then
                objVehBo.ModelYear = modelYear
            Else
                objVehBo.ModelYear = Nothing
            End If

            If regYear <> "" Then
                objVehBo.RegYear = regYear
            Else
                objVehBo.RegYear = Nothing
            End If

            If regDate <> "" Then
                objVehBo.RegDate = commonUtil.GetDefaultDate_MMDDYYYY(regDate)
            Else
                objVehBo.RegDate = Nothing
            End If
            If regDateNor <> "" Then
                objVehBo.RegDateNo = commonUtil.GetDefaultDate_MMDDYYYY(regDateNor)
            Else
                objVehBo.RegDateNo = Nothing
            End If

            If lastRegDate <> "" Then
                objVehBo.LastRegDate = commonUtil.GetDefaultDate_MMDDYYYY(lastRegDate)
            Else
                objVehBo.LastRegDate = Nothing
            End If
            If deregDate <> "" Then
                objVehBo.DeRegDate = commonUtil.GetDefaultDate_MMDDYYYY(deregDate)
            Else
                objVehBo.DeRegDate = Nothing
            End If
            objVehBo.Color = color
            objVehBo.Machine_W_Hrs = machineHrs
            If (objVehBo.Machine_W_Hrs = False) Then
                If mileage <> "" Then
                    objVehBo.Mileage = mileage
                Else
                    objVehBo.Mileage = Nothing
                End If
                objVehBo.MileageRegDate = commonUtil.GetDefaultDate_MMDDYYYY(mileageDate)
                objVehBo.VehicleHrs = 0D
                objVehBo.VehicleHrsDate = Nothing
            Else
                If hours <> "" Then
                    objVehBo.VehicleHrs = hours
                Else
                    objVehBo.VehicleHrs = Nothing
                End If
                objVehBo.VehicleHrsDate = commonUtil.GetDefaultDate_MMDDYYYY(hoursDate)
                objVehBo.Mileage = 0
                objVehBo.MileageRegDate = Nothing
            End If
            objVehBo.Category = category
            objVehBo.ModelType = modelType
            objVehBo.Warranty_Code = warrantyCode
            objVehBo.NetWeight = netWeight
            objVehBo.TotalWeight = totWeight
            objVehBo.Project_No = projNo

            If lastContDate <> "" Then
                objVehBo.Last_Contact_Date = commonUtil.GetDefaultDate_MMDDYYYY(lastContDate)
            Else
                objVehBo.Last_Contact_Date = Nothing
            End If

            objVehBo.Practical_Load = practicalLoad
            objVehBo.Max_Rf_Load = maxRoofLoad
            objVehBo.Earlier_Regno_1 = earlrRegNo1
            objVehBo.Earlier_Regno_2 = earlrRegNo2
            objVehBo.Earlier_Regno_3 = earlrRegNo3
            objVehBo.Earlier_Regno_4 = earlrRegNo4
            objVehBo.VehGrp = vehGroup
            objVehBo.PickNo = pickNo
            objVehBo.MakeCodeNo = makeCodeNo
            objVehBo.RicambiNo = ricambiNo
            objVehBo.EngineNum = engineNo
            objVehBo.FuelCode = fuelCode
            objVehBo.FuelCard = fuelCard
            objVehBo.GearBox_Desc = gearBox
            objVehBo.WareHouse = wareHouse
            objVehBo.KeyNo = keyNo
            objVehBo.DoorKeyNo = doorKeyNo
            objVehBo.ControlForm = controlForm
            objVehBo.InteriorCode = interiorCode
            objVehBo.PurchaseNo = purchaseNo
            objVehBo.AddonGroup = addonGroup
            If dateExpectedIn <> "" Then
                objVehBo.Date_Expected_In = commonUtil.GetDefaultDate_MMDDYYYY(dateExpectedIn)
            Else
                objVehBo.Date_Expected_In = Nothing
            End If
            objVehBo.Tires = tires
            objVehBo.Service_Category = serviceCategory
            objVehBo.No_Approval_No = noApprovalNo
            objVehBo.Eu_Approval_No = euApprovalNo
            objVehBo.VanNo = vanNo
            objVehBo.ProductNo = productNo
            objVehBo.ElCode = elCode
            If takenInDate <> "" Then
                objVehBo.Taken_In_Date = commonUtil.GetDefaultDate_MMDDYYYY(takenInDate)
            Else
                objVehBo.Taken_In_Date = Nothing
            End If

            If takenInDateMileage <> "" Then
                objVehBo.Taken_In_Mileage = takenInDateMileage
            Else
                objVehBo.Taken_In_Mileage = 0
            End If

            If deliveryDate <> "" Then
                objVehBo.Delivery_Date = commonUtil.GetDefaultDate_MMDDYYYY(deliveryDate)
            Else
                objVehBo.Delivery_Date = Nothing
            End If

            If deliveryDateMileage <> "" Then
                objVehBo.Delivery_Mileage = deliveryDateMileage
            Else
                objVehBo.Delivery_Mileage = Nothing
            End If

            If serviceDate <> "" Then
                objVehBo.Service_Date = commonUtil.GetDefaultDate_MMDDYYYY(serviceDate)
            Else
                objVehBo.Service_Date = Nothing
            End If

            If serviceDateMileage <> "" Then
                objVehBo.Service_Mileage = serviceDateMileage
            Else
                objVehBo.Service_Mileage = Nothing
            End If

            If callInDate <> "" Then
                objVehBo.Call_In_Date = commonUtil.GetDefaultDate_MMDDYYYY(callInDate)
            Else
                objVehBo.Call_In_Date = Nothing
            End If

            If callInDateMileage <> "" Then
                objVehBo.Call_In_Mileage = callInDateMileage
            Else
                objVehBo.Call_In_Mileage = Nothing
            End If

            If cleanedDate <> "" Then
                objVehBo.Cleaned_Date = commonUtil.GetDefaultDate_MMDDYYYY(cleanedDate)
            Else
                objVehBo.Cleaned_Date = Nothing
            End If
            objVehBo.TechDocNo = techdocNo
            If length <> "" Then
                objVehBo.Length = length
            Else
                objVehBo.Length = 0
            End If
            If width <> "" Then
                objVehBo.Width = width
            Else
                objVehBo.Width = 0
            End If
            If noise <> "" Then
                objVehBo.Noise_On_Veh = noise
            Else
                objVehBo.Noise_On_Veh = 0
            End If
            If effectkW <> "" Then
                objVehBo.EngineEff = effectkW
            Else
                objVehBo.EngineEff = 0
            End If
            objVehBo.PisDisplacement = pistonDisp
            objVehBo.Rounds = rounds
            objVehBo.Used_Imported = usedImported
            objVehBo.Pressure_Mech_Brakes = pressureMechBrakes
            objVehBo.Towbar = towbar
            objVehBo.Service_Book = serviceBook
            If lastPKKApproved <> "" Then
                objVehBo.LastPKK_AppDate = commonUtil.GetDefaultDate_MMDDYYYY(lastPKKApproved)
            Else
                objVehBo.LastPKK_AppDate = Nothing
            End If
            If nextPKK <> "" Then
                objVehBo.NxtPKK_Date = commonUtil.GetDefaultDate_MMDDYYYY(nextPKK)
            Else
                objVehBo.NxtPKK_Date = Nothing
            End If
            If lastPKKInvoiced <> "" Then
                objVehBo.Last_PKK_Invoiced = commonUtil.GetDefaultDate_MMDDYYYY(lastPKKInvoiced)
            Else
                objVehBo.Last_PKK_Invoiced = Nothing
            End If
            objVehBo.Call_In_Service = callInToService
            If callInMonth <> "" Then
                objVehBo.Call_In_Month_Service = callInMonth
            Else
                objVehBo.Call_In_Month_Service = Nothing
            End If
            If techMileage <> "" Then
                objVehBo.Call_In_Mileage_Service = techMileage
            Else
                objVehBo.Call_In_Mileage_Service = Nothing
            End If
            objVehBo.Do_Not_Call_PKK = doNotCallPKK
            objVehBo.Deviations_PKK = deviationPKK
            If yearlyMileage <> "" Then
                objVehBo.Yearly_Mileage = yearlyMileage
            Else
                objVehBo.Yearly_Mileage = Nothing
            End If
            objVehBo.Radio_Code = radioCode
            objVehBo.Start_Immobilizer = startImmobilizer
            If qtyKeys <> "" Then
                objVehBo.Qty_Keys = qtyKeys
            Else
                objVehBo.Qty_Keys = Nothing
            End If
            If keyTag <> "" Then
                objVehBo.KeyTagNo = keyTag
            Else
                objVehBo.KeyTagNo = Nothing
            End If

            If salesPriceNet <> "" Then
                objVehBo.SalesPriceNet = salesPriceNet
            Else
                objVehBo.SalesPriceNet = 0.0
            End If
            If salesSale <> "" Then
                objVehBo.SalesSale = salesSale
            Else
                objVehBo.SalesSale = 0.0
            End If

            If salesEquipment <> "" Then
                objVehBo.SalesEquipment = salesEquipment
            Else
                objVehBo.SalesEquipment = 0.0
            End If

            If regCosts <> "" Then
                objVehBo.RegCosts = regCosts
            Else
                objVehBo.RegCosts = 0.0
            End If

            If discount <> "" Then
                objVehBo.Discount = discount
            Else
                objVehBo.Discount = 0
            End If

            If netSalesPrice <> "" Then
                objVehBo.NetSalesPrice = netSalesPrice
            Else
                objVehBo.NetSalesPrice = 0.0
            End If

            If fixCost <> "" Then
                objVehBo.FixCost = fixCost
            Else
                objVehBo.FixCost = 0.0
            End If

            If assistSales <> "" Then
                objVehBo.AssistSales = assistSales
            Else
                objVehBo.AssistSales = 0.0
            End If

            If costAfterSale <> "" Then
                objVehBo.CostAfterSales = costAfterSale
            Else
                objVehBo.CostAfterSales = 0.0
            End If

            If contributionsToday <> "" Then
                objVehBo.ContributionsToday = contributionsToday
            Else
                objVehBo.ContributionsToday = 0.0
            End If

            If salesPriceGross <> "" Then
                objVehBo.SalesPriceGross = salesPriceGross
            Else
                objVehBo.SalesPriceGross = 0.0
            End If

            If regFee <> "" Then
                objVehBo.RegFee = regFee
            Else
                objVehBo.RegFee = 0.0
            End If

            If vat <> "" Then
                objVehBo.Vat = vat
            Else
                objVehBo.Vat = 0.0
            End If

            If totAmount <> "" Then
                objVehBo.TotAmount = totAmount
            Else
                objVehBo.TotAmount = 0.0
            End If

            If wreckingAmount <> "" Then
                objVehBo.WreckingAmount = wreckingAmount
            Else
                objVehBo.WreckingAmount = 0.0
            End If

            If yearlyFee <> "" Then
                objVehBo.YearlyFee = yearlyFee
            Else
                objVehBo.YearlyFee = 0.0
            End If

            If insurance <> "" Then
                objVehBo.Insurance = insurance
            Else
                objVehBo.Insurance = 0.0
            End If

            If costPriceNet <> "" Then
                objVehBo.CostPriceNet = costPriceNet
            Else
                objVehBo.CostPriceNet = 0.0
            End If

            If insuranceBonus <> "" Then
                objVehBo.InsuranceBonus = insuranceBonus
            Else
                objVehBo.InsuranceBonus = 0
            End If

            If costSales <> "" Then
                objVehBo.CostSales = costSales
            Else
                objVehBo.CostSales = 0.0
            End If

            If costBeforeSale <> "" Then
                objVehBo.CostBeforeSale = costBeforeSale
            Else
                objVehBo.CostBeforeSale = 0.0
            End If

            If salesProvision <> "" Then
                objVehBo.SalesProvision = salesProvision
            Else
                objVehBo.SalesProvision = 0.0
            End If

            If commitDay <> "" Then
                objVehBo.CommitDay = commitDay
            Else
                objVehBo.CommitDay = 0
            End If

            If addedInterests <> "" Then
                objVehBo.AddedInterests = addedInterests
            Else
                objVehBo.AddedInterests = 0
            End If

            If costEquipment <> "" Then
                objVehBo.CostEquipment = costEquipment
            Else
                objVehBo.CostEquipment = 0
            End If

            If totalCost <> "" Then
                objVehBo.TotalCost = totalCost
            Else
                objVehBo.TotalCost = 0
            End If
            If creditNoteNo <> "" Then
                objVehBo.CreditNoteNo = creditNoteNo
            Else
                objVehBo.CreditNoteNo = ""
            End If
            If creditNoteDate <> "" Then
                objVehBo.CreditNoteDate = commonUtil.GetDefaultDate_MMDDYYYY(creditNoteDate)
            Else
                objVehBo.CreditNoteDate = Nothing
            End If
            If invoiceNo <> "" Then
                objVehBo.InvoiceNo = invoiceNo
            Else
                objVehBo.InvoiceNo = ""
            End If
            If invoiceDate <> "" Then
                objVehBo.InvoiceDate = commonUtil.GetDefaultDate_MMDDYYYY(invoiceDate)
            Else
                objVehBo.InvoiceDate = Nothing
            End If
            If rebuyDate <> "" Then
                objVehBo.RebuyDate = commonUtil.GetDefaultDate_MMDDYYYY(rebuyDate)
            Else
                objVehBo.RebuyDate = Nothing
            End If
            If rebuyPrice <> "" Then
                objVehBo.RebuyPrice = Convert.ToDecimal(rebuyPrice)
            Else
                objVehBo.RebuyPrice = 0.0
            End If
            If costPerKm <> "" Then
                objVehBo.CostPerKm = costPerKm
            Else
                objVehBo.CostPerKm = 0.0
            End If
            If turnover <> "" Then
                objVehBo.Turnover = turnover
            Else
                objVehBo.Turnover = 0.0
            End If
            If progress <> "" Then
                objVehBo.Progress = progress
            Else
                objVehBo.Progress = 0.0
            End If

            objVehBo.Axle1 = axle1
            objVehBo.Axle2 = axle2
            objVehBo.Axle3 = axle3
            objVehBo.Axle4 = axle4
            objVehBo.Axle5 = axle5
            objVehBo.Axle6 = axle6
            objVehBo.Axle7 = axle7
            objVehBo.Axle8 = axle8
            objVehBo.TrailerDesc = trailerDesc

            objVehBo.StdTyreFront = tireDimFront
            objVehBo.StdTyreBack = tireDimBack
            objVehBo.MinLi_Front = minliFront
            objVehBo.MinLi_Back = minliBack
            objVehBo.Min_Inpress_Front = minInpressFront
            objVehBo.Min_Inpress_Back = minInpressBack
            objVehBo.Std_Rim_Front = stdRimFront
            objVehBo.Std_Rim_Back = stdRimBack
            objVehBo.Min_Front = minSpeedFront
            objVehBo.Min_Back = minSpeedBack
            objVehBo.Max_Tyre_Width_Frnt = maxTrackFront
            objVehBo.Max_Tyre_Width_Bk = maxTrackBack
            objVehBo.AxlePrFront = axlePressureFront
            objVehBo.AxlePrBack = axlePressureBack
            objVehBo.Axles_Number = qtyAxles
            objVehBo.Axles_Number_Traction = operativeAxles
            objVehBo.Wheels_Traction = driveWheel
            objVehBo.TrailerWth_Brks = trailerWithBrakes
            objVehBo.TrailerWthout_Brks = trailerWeight
            objVehBo.Max_Wt_TBar = maxLoadTowbar
            objVehBo.Len_TBar = lengthToTowbar
            objVehBo.TotalTrailerWeight = totalTrailerWeight
            objVehBo.Seats = seats
            If validFrom <> "" Then
                objVehBo.ValidFrom = commonUtil.GetDefaultDate_MMDDYYYY(validFrom)
            Else
                objVehBo.ValidFrom = Nothing
            End If
            objVehBo.EU_Version = euVersion
            objVehBo.EU_Variant = euVariant
            objVehBo.EU_Norm = euronorm
            objVehBo.CO2_Emission = co2Emission
            objVehBo.Make_Part_Filter = makeParticleFilter
            objVehBo.Chassi_Desc = chassiText
            objVehBo.Identity_Annot = identity
            objVehBo.Cert_Text = certificate
            objVehBo.Annot = certificateAnnotation
            objVehBo.Id_Customer_Veh = idCustomer
            objVehBo.vatCode = idVatCode
            objVehBo.CreatedBy = _loginName
            strResult = objVehicleService.Add_Vehicle(objVehBo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()>
    Public Shared Function GetVehGroup(ByVal VehGrp As String) As List(Of String)
        Dim retVehGroup As New List(Of String)()
        Try
            retVehGroup = objVehicleService.GetVehGroup(VehGrp)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetVehicleGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retVehGroup
    End Function
    <WebMethod()>
    Public Shared Function GetFuelCode(ByVal FuelCode As String) As List(Of String)
        Dim retFuelCode As New List(Of String)()
        Try
            retFuelCode = objVehicleService.GetFuelCode(FuelCode)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetFuelCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retFuelCode
    End Function

    <WebMethod()>
    Public Shared Function GetWareHouse(ByVal WH As String) As List(Of String)
        Dim retWareHouse As New List(Of String)()
        Try
            retWareHouse = objVehicleService.GetWareHouse(WH)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetWareHouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retWareHouse
    End Function

    <WebMethod()>
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    <WebMethod()>
    Public Shared Function FetchVehicleDetails(ByVal refNo As String, ByVal regNo As String, ByVal vehId As String) As VehicleBO()
        Dim vehDetails As New List(Of VehicleBO)()
        Try
            If (refNo <> "" Or vehId <> "" Or regNo <> "") Then
                vehDetails = objVehicleService.FetchVehicleDetails(refNo, regNo, vehId)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "FetchVehicleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return vehDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function LoadNewUsedCode() As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.FetchNewUsedCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetNewUsedRefNo(ByVal refNo As String) As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.GetNewUsedRefNo(refNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function SetNewUsedRefNo(ByVal refNoType As String, ByVal refNo As String) As VehicleBO()
        Dim newUsedList As New List(Of VehicleBO)()
        Try
            newUsedList = objVehicleService.SetNewUsedRefNo(refNoType, refNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return newUsedList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadStatusCode() As VehicleBO()
        Dim statusList As New List(Of VehicleBO)()
        Try
            statusList = objVehicleService.FetchStatusCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return statusList.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadWarrantyCode() As VehicleBO()
        Dim warranty As New List(Of VehicleBO)()
        Try
            warranty = objVehicleService.FetchWarrantyCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadWarrantyCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return warranty.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadCustomerGroup() As CustomerBO()
        Dim customerGroup As New List(Of CustomerBO)()
        Try
            customerGroup = objCustService.FetchCustomerGroup()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return customerGroup.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadMakeCode() As VehicleBO()
        Dim Make As New List(Of VehicleBO)()
        Try
            Make = objVehicleService.FetchMakeCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadMakeCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
        Return Make.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function FetchEniro(ByVal search As String) As CustomerBO()
        Dim details As New List(Of CustomerBO)()
        Try
            details = objCustomerService.GetEniroData(search)
            Dim dt As New DataTable()
            dt.TableName = "localCustDetails"
            For Each [property] As PropertyInfo In details(0).[GetType]().GetProperties()
                dt.Columns.Add(New DataColumn([property].Name, [property].PropertyType))
            Next

            For Each vehicle As CustomerBO In details
                Dim newRow As DataRow = dt.NewRow()
                For Each [property] As PropertyInfo In vehicle.[GetType]().GetProperties()
                    newRow([property].Name) = vehicle.[GetType]().GetProperty([property].Name).GetValue(vehicle, Nothing)
                Next
                dt.Rows.Add(newRow)
            Next
            HttpContext.Current.Session("CustomerDet") = dt

            Return details.ToList.ToArray
        Catch ex As Exception
            'objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "LoadSubsidiary", ex.Message, _loginName)
        End Try
    End Function

    <WebMethod()>
    Public Shared Function LoadEniroDet(ByVal EniroId As String) As CustomerBO()
        Try
            Dim details As New List(Of CustomerBO)()
            details = objCustomerService.LoadEniroDetails(EniroId)
            Return details.ToList.ToArray
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadEniroDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, _loginName)
        End Try
    End Function

    <WebMethod()>
    Public Shared Function LoadEditMake() As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            EditMake = objVehicleService.FetchEditMake()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function GetEditMake(ByVal makeId As String) As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            EditMake = objVehicleService.GetEditMake(makeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function
    '<WebMethod()>
    'Public Shared Function AddEditMake(ByVal editMakeCode As String, ByVal editMakeDesc As String, ByVal editMakePriceCode As String, ByVal editMakeDiscount As String, ByVal editMakeVat As String) As String
    '    Dim strResult As String = ""
    '    Dim dsReturnValStr As String = ""
    '    Try
    '        objVehBo.MakeCode = editMakeCode
    '        objVehBo.MakeName = editMakeDesc
    '        objVehBo.Cost_Price = editMakePriceCode
    '        objVehBo.Description = editMakeDiscount
    '        objVehBo.VanNo = editMakeVat

    '        strResult = objVehicleService.Add_EditMake(objVehBo)
    '    Catch ex As Exception
    '        objErrHandle.WriteErrorLog(1, "Master_frmVehicleDetail", "AddVehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
    '    End Try
    '    Return strResult
    'End Function

    <WebMethod()>
    Public Shared Function DeleteEditMake(ByVal editMakeId As String) As VehicleBO()
        Dim EditMake As New List(Of VehicleBO)()
        Try
            'EditMake = objVehicleService.DeleteBranch(editMakeId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "LoadCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return EditMake.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function FetchModel(ByVal IdMake As String, ByVal Model As String) As String
        Dim IdModel As String = ""
        Try
            IdModel = objVehicleService.GetModel(IdMake, Model)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_VehicleDetail", "FetchModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return IdModel.ToString()
    End Function
    <WebMethod()>
    Public Shared Function LoadModel() As VehicleBO()
        Try
            details = objVehicleService.LoadModel()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehMake", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    <WebMethod()>
    Public Shared Function LoadVatCode() As VehicleBO()
        Try
            details = objVehicleService.LoadVatCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWoHead", "LoadVehMake", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function


End Class


