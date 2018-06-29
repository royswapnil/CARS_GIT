Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports System
Imports MSGCOMMON
Imports System.Web.Security
Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common

Namespace CARS.Services.Vehicle
    Public Class VehicleDetails
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objVehicleDO As New VehicleDO
        Shared objVehicleBO As New VehicleBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Shared objWOHDO As New CARS.WOHeader.WOHeaderDO

        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function GetMVRData(ByVal regNo As String) As List(Of VehicleBO)
            Dim objMVRDetails As New List(Of VehicleBO)()
            Dim MvrDet As New VehicleBO()
            Dim myService1 As New no.pkk.app.emsService
            Dim dsReturnVal As no.pkk.app.bildataWS = myService1.vkData("IdCars1250", "IdCars1250", 47, True, 0, True, regNo.ToString())

            If dsReturnVal.status = 0 Then
                MvrDet.AxlePrBack = dsReturnVal.akseltrykkBak.ToString()
                MvrDet.VehRegNo = dsReturnVal.kjennemerke.ToString()
                MvrDet.VehVin = dsReturnVal.understellsnummer.ToString()
                If (IsDBNull(dsReturnVal.regFoerstegNorge)) Then
                    MvrDet.RegDateNorway = ""
                Else
                    MvrDet.RegDateNorway = objCommonUtil.GetCurrentLanguageDate(dsReturnVal.regFoerstegNorge)
                End If
                MvrDet.MakeCode = dsReturnVal.merkekode.ToString()
                MvrDet.Make = dsReturnVal.merkeNavn.ToString()
                MvrDet.Model = dsReturnVal.modellbetegnelse.ToString()
                MvrDet.VehType = dsReturnVal.typebetegnelse.ToString()
                MvrDet.ApprovalNo = dsReturnVal.typegodkjenningsnr.ToString()
                MvrDet.VehGrp = dsReturnVal.kjoretoygruppe.ToString()
                MvrDet.Color = dsReturnVal.farge.ToString()
                MvrDet.FuelType = dsReturnVal.drivstoff.ToString()
                MvrDet.EngineEff = dsReturnVal.motorytelse.ToString()

                MvrDet.PisDisplacement = dsReturnVal.slagvolum.ToString()
                MvrDet.Width = dsReturnVal.bredde.ToString()
                MvrDet.Length = dsReturnVal.lengde.ToString()
                MvrDet.StdTyreFront = dsReturnVal.stdDekkForan.ToString()
                MvrDet.MinLi_Front = dsReturnVal.minLIforan.ToString()
                If dsReturnVal.minHastForan IsNot Nothing Then
                    MvrDet.Min_Front = dsReturnVal.minHastForan.ToString()
                Else
                    dsReturnVal.minHastForan = ""
                    MvrDet.Min_Front = dsReturnVal.minHastForan
                End If
                MvrDet.Std_Rim_Front = dsReturnVal.stdFelgForan.ToString()
                MvrDet.Min_Inpress_Front = dsReturnVal.minInnpressForan.ToString()
                MvrDet.Max_Tyre_Width_Frnt = dsReturnVal.maksSporvForan.ToString()
                MvrDet.StdTyreBack = dsReturnVal.stdDekkBak.ToString()
                MvrDet.MinLi_Back = dsReturnVal.minLIbak.ToString()
                If dsReturnVal.minHastBak IsNot Nothing Then
                    MvrDet.Min_Back = dsReturnVal.minHastBak.ToString()
                Else
                    dsReturnVal.minHastBak = ""
                    MvrDet.Min_Back = dsReturnVal.minHastBak
                End If
                MvrDet.Std_Rim_Back = dsReturnVal.stdFelgBak.ToString()
                MvrDet.Min_Inpress_Back = dsReturnVal.minInnpressBak.ToString()
                MvrDet.Max_Tyre_Width_Bk = dsReturnVal.maksSporvBak.ToString()
                MvrDet.TotalWeight = dsReturnVal.totalvekt.ToString()
                MvrDet.NetWeight = dsReturnVal.egenvekt.ToString()
                MvrDet.AxlePrFront = dsReturnVal.akseltrykkForan.ToString()
                MvrDet.AxlePrBack = dsReturnVal.akseltrykkBak.ToString()
                MvrDet.Max_Wt_TBar = dsReturnVal.maxBelTilhFeste.ToString()
                MvrDet.Len_TBar = dsReturnVal.lngdTilhKobl.ToString()
                MvrDet.Max_Rf_Load = dsReturnVal.maxTaklast.ToString()
                MvrDet.EngineNum = dsReturnVal.motormerking.ToString()
                If (IsDBNull(dsReturnVal.nestePKK)) Then
                    MvrDet.NxtPKK_Date = ""
                Else
                    MvrDet.NxtPKK_Date = objCommonUtil.GetCurrentLanguageDate(dsReturnVal.nestePKK)
                End If
                MvrDet.ModelYear = dsReturnVal.regAAr.ToString()

                If dsReturnVal.regFgang IsNot Nothing Then
                    MvrDet.RegYear = dsReturnVal.regFgang.ToString()
                Else
                    dsReturnVal.regFgang = ""
                    MvrDet.RegYear = dsReturnVal.regFgang
                End If
                If (IsDBNull(dsReturnVal.sisteRegDato)) Then
                    MvrDet.LastRegDate = ""
                Else
                    MvrDet.LastRegDate = objCommonUtil.GetCurrentLanguageDate(dsReturnVal.sisteRegDato)
                End If
                If (IsDBNull(dsReturnVal.sistPKKgodkj)) Then
                    MvrDet.LastPKK_AppDate = ""
                Else
                    MvrDet.LastPKK_AppDate = objCommonUtil.GetCurrentLanguageDate(dsReturnVal.sistPKKgodkj)
                End If
                If (IsDBNull(dsReturnVal.avregDato)) Then
                    MvrDet.DeRegDate = ""
                Else
                    MvrDet.DeRegDate = objCommonUtil.GetCurrentLanguageDate(dsReturnVal.avregDato)
                End If

                MvrDet.Veh_Seat = dsReturnVal.sitteplasser.ToString()
                MvrDet.Cert_Text = dsReturnVal.vognkortAnm.ToString()
                MvrDet.CO2_Emission = dsReturnVal.co2Utslipp.ToString()
                MvrDet.EU_Variant = dsReturnVal.EUvariant.ToString()
                MvrDet.EU_Version = dsReturnVal.EUversjon.ToString()
                MvrDet.GearBox_Desc = dsReturnVal.girkasse.ToString()
                MvrDet.Chassi_Desc = dsReturnVal.rammeKarosseri.ToString()
                MvrDet.TrailerWth_Brks = dsReturnVal.tilhVktMbrems.ToString()
                MvrDet.TrailerWthout_Brks = dsReturnVal.tilhVktUbrems.ToString()
                MvrDet.Axles_Number = dsReturnVal.antAksler.ToString()
                MvrDet.Axles_Number_Traction = dsReturnVal.antAkslerDrift.ToString()
                MvrDet.Noise_On_Veh = dsReturnVal.standStoy.ToString()
                MvrDet.Rounds = dsReturnVal.omdreininger.ToString()
                MvrDet.EU_Main_Num = dsReturnVal.euHovednummer.ToString()
                MvrDet.EU_Norm = dsReturnVal.euronorm.ToString()
                MvrDet.Identity_Annot = dsReturnVal.identitetAnm.ToString()
                MvrDet.Wheels_Traction = dsReturnVal.drivendeHjul.ToString()
                MvrDet.Make_Part_Filter = dsReturnVal.fabPartFilter.ToString()
                objMVRDetails.Add(MvrDet)
            End If
            MvrDet.Status = dsReturnVal.status.ToString()
            Return objMVRDetails
        End Function
        'Public Function GetVehicle(ByVal vehicleRegNo As String) As List(Of VehicleBO)
        '    Dim dsVehicle As New DataSet
        '    Dim dtVehicle As DataTable
        '    Dim retVehicle As New List(Of VehicleBO)()
        '    Try
        '        dsVehicle = objVehicleDO.Get_Vehicle(vehicleRegNo)

        '        If dsVehicle.Tables.Count > 0 Then
        '            If dsVehicle.Tables(0).Rows.Count > 0 Then
        '                dtVehicle = dsVehicle.Tables(0)
        '            End If
        '        End If
        '        If vehicleRegNo <> String.Empty Then
        '            For Each dtrow As DataRow In dtVehicle.Rows
        '                'retVehicle.Id_Veh_Seq = dtrow("ID_VEH_SEQ").ToString()
        '                'retVehicle.VehRegNo = dtrow("VEH_REG_NO").ToString()
        '            Next
        '        End If
        '    Catch ex As Exception
        '        Throw ex
        '    End Try
        '    Return retVehicle
        'End Function
        Public Function Add_Vehicle(ByVal objVehicleBO As VehicleBO) As String()
            Dim strResult As String = ""
            Dim strVehSeq As String
            Dim strRefNo As String = ""
            Dim strArray As Array
            Try
                strResult = objVehicleDO.Add_Vehicle(objVehicleBO)
                strArray = strResult.Split(",")
                strResult = strArray(0)
                strVehSeq = strArray(1)
                strRefNo = strArray(2)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function VehicleSearch(ByVal q As String) As List(Of VehicleBO)
            Dim dsVehicle As New DataSet
            Dim dtVehicle As DataTable
            Dim vehicleSearchResult As New List(Of VehicleBO)()
            Try
                dsVehicle = objVehicleDO.Vehicle_Search(q)

                If dsVehicle.Tables.Count > 0 Then
                    dtVehicle = dsVehicle.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtVehicle.Rows
                        Dim vsr As New VehicleBO()
                        vsr.Id_Veh_Seq = dtrow("ID_VEH_SEQ").ToString
                        vsr.VehRegNo = dtrow("VEH_REG_NO").ToString
                        vsr.IntNo = dtrow("VEH_INTERN_NO").ToString
                        vsr.VehVin = dtrow("VEH_VIN").ToString
                        vsr.Make = dtrow("ID_MAKE_VEH").ToString
                        vsr.Model = dtrow("ID_MODEL_VEH").ToString
                        vsr.VehType = dtrow("VEH_TYPE").ToString
                        vsr.Customer = dtrow("ID_CUSTOMER_VEH").ToString
                        vsr.ModelType = dtrow("VEH_MODEL_TYPE").ToString
                        vsr.CustomerName = dtrow("CUST_NAME").ToString
                        If (dtrow("DT_VEH_ERGN").ToString() = "") Then
                            vsr.RegDate = ""
                        Else
                            vsr.RegDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_ERGN").ToString())
                        End If
                        vsr.RegYear = IIf(IsDBNull(dtrow("VEH_REGYEAR")), 0, dtrow("VEH_REGYEAR").ToString())
                        vsr.Mileage = dtrow("VEH_MILEAGE").ToString
                        vsr.VehType = dtrow("VEH_TYPE").ToString()
                        vsr.New_Used = dtrow("VEH_NEW_USED").ToString()
                        vehicleSearchResult.Add(vsr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return vehicleSearchResult
        End Function

        Public Function FetchVehicleDetails(ByVal vehicleRefNo As String, ByVal vehicleRegNo As String, ByVal vehicleSeqId As String) As List(Of VehicleBO)
            Dim dsVehicle As New DataSet
            Dim dtVehicle As DataTable
            Dim retVehicle As New List(Of VehicleBO)()
            Try
                dsVehicle = objVehicleDO.Fetch_Vehicle_Details(vehicleRefNo, vehicleRegNo, vehicleSeqId)

                If dsVehicle.Tables.Count > 0 Then
                    dtVehicle = dsVehicle.Tables(0)
                End If
                If vehicleRegNo <> String.Empty Or vehicleSeqId <> String.Empty Or vehicleRefNo <> String.Empty Then
                    For Each dtrow As DataRow In dtVehicle.Rows
                        Dim vehDet As New VehicleBO()
                        vehDet.Id_Veh_Seq = dtrow("ID_VEH_SEQ").ToString()
                        vehDet.VehRegNo = dtrow("VEH_REG_NO").ToString()
                        vehDet.IntNo = dtrow("VEH_INTERN_NO").ToString()
                        vehDet.VehVin = dtrow("VEH_VIN").ToString()
                        vehDet.Make = dtrow("ID_MAKE_VEH").ToString()
                        vehDet.Model = dtrow("ID_MODEL_VEH").ToString()

                        If (dtrow("ID_VAT_CD").ToString() = "") Then
                            vehDet.vatCode = "100"
                        Else
                            vehDet.vatCode = dtrow("ID_VAT_CD").ToString()
                        End If

                        vehDet.VehType = dtrow("VEH_TYPE").ToString()
                        If (dtrow("DT_VEH_ERGN").ToString() = "") Then
                            vehDet.RegDate = ""
                        Else
                            vehDet.RegDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_ERGN").ToString())
                        End If

                        vehDet.Mileage = IIf(IsDBNull(dtrow("VEH_MILEAGE")), 0, dtrow("VEH_MILEAGE").ToString())


                        If (dtrow("DT_VEH_MIL_REGN").ToString() = "") Then
                            vehDet.MileageRegDate = ""
                        Else
                            vehDet.MileageRegDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_MIL_REGN").ToString())
                        End If
                        vehDet.VehicleHrs = IIf(IsDBNull(dtrow("VEH_HRS")), 0, dtrow("VEH_HRS").ToString())
                        If (dtrow("DT_VEH_HRS_ERGN").ToString() = "") Then
                            vehDet.VehicleHrsDate = ""
                        Else
                            vehDet.VehicleHrsDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_HRS_ERGN").ToString())
                        End If
                        vehDet.ModelYear = IIf(IsDBNull(dtrow("VEH_MDL_YEAR")), 0, dtrow("VEH_MDL_YEAR").ToString())
                        vehDet.Id_Group_Veh = dtrow("ID_GROUP_VEH").ToString()
                        vehDet.Customer = dtrow("ID_CUSTOMER_VEH").ToString()
                        vehDet.Annotation = dtrow("VEH_ANNOT").ToString()
                        vehDet.RefNo = dtrow("VEH_REFNO").ToString()
                        vehDet.New_Used = dtrow("VEH_NEW_USED").ToString()
                        vehDet.VehStatus = dtrow("VEH_STATUS").ToString()
                        vehDet.ModelType = dtrow("VEH_MODEL_TYPE").ToString()
                        vehDet.RegYear = IIf(IsDBNull(dtrow("VEH_REGYEAR")), 0, dtrow("VEH_REGYEAR").ToString())
                        If (dtrow("VEH_REG_DATE_NO").ToString() = "") Then
                            vehDet.RegDateNorway = ""
                        Else
                            vehDet.RegDateNorway = objCommonUtil.GetCurrentLanguageDate(dtrow("VEH_REG_DATE_NO").ToString())
                        End If
                        If (dtrow("VEH_LAST_REGDATE").ToString() = "") Then
                            vehDet.LastRegDate = ""
                        Else
                            vehDet.LastRegDate = objCommonUtil.GetCurrentLanguageDate(dtrow("VEH_LAST_REGDATE").ToString())
                        End If
                        If (dtrow("VEH_DEREG_DATE").ToString() = "") Then
                            vehDet.DeRegDate = ""
                        Else
                            vehDet.DeRegDate = objCommonUtil.GetCurrentLanguageDate(dtrow("VEH_DEREG_DATE").ToString())
                        End If
                        vehDet.Category = dtrow("VEH_CATEGORY").ToString()

                        vehDet.Machine_W_Hrs = IIf(IsDBNull(dtrow("VEH_MACHINE_W_HOURS")), False, dtrow("VEH_MACHINE_W_HOURS").ToString())

                        vehDet.Color = dtrow("VEH_COLOR").ToString()
                        vehDet.Warranty_Code = dtrow("VEH_WARRANTY_CODE").ToString()
                        vehDet.NetWeight = dtrow("VEH_NET_WEIGHT").ToString()
                        vehDet.TotalWeight = dtrow("VEH_TOT_WEIGHT").ToString()
                        vehDet.Project_No = dtrow("VEH_PROJECT_NO").ToString()
                        If (dtrow("VEH_LAST_CONTACT_DATE").ToString() = "") Then
                            vehDet.Last_Contact_Date = ""
                        Else
                            vehDet.Last_Contact_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("VEH_LAST_CONTACT_DATE").ToString())
                        End If
                        vehDet.Practical_Load = dtrow("VEH_PRACTICAL_LOAD").ToString()
                        vehDet.Max_Rf_Load = dtrow("VEH_MAX_ROOF_LOAD").ToString()
                        vehDet.Earlier_Regno_1 = dtrow("VEH_EARLIER_REGNO_1").ToString()
                        vehDet.Earlier_Regno_2 = dtrow("VEH_EARLIER_REGNO_2").ToString()
                        vehDet.Earlier_Regno_3 = dtrow("VEH_EARLIER_REGNO_3").ToString()
                        vehDet.Earlier_Regno_4 = dtrow("VEH_EARLIER_REGNO_4").ToString()
                        vehDet.VehGrp = dtrow("ID_GROUP_VEH").ToString()
                        vehDet.Note = dtrow("VEH_NOTE").ToString()
                        vehDet.PickNo = dtrow("PICK").ToString()

                        vehDet.MakeCodeNo = dtrow("VEH_MAKE_CODE").ToString()
                        vehDet.RicambiNo = dtrow("VEH_RICAMBI_NO").ToString()
                        vehDet.EngineNum = dtrow("VEH_ENGINE_NO").ToString()
                        vehDet.FuelCode = dtrow("VEH_FUEL_CODE").ToString()
                        vehDet.FuelCard = dtrow("VEH_FUEL_CARD").ToString()
                        vehDet.GearBox_Desc = dtrow("VEH_GEAR_BOX").ToString()

                        vehDet.WareHouse = dtrow("VEH_WAREHOUSE").ToString()
                        vehDet.KeyNo = dtrow("VEH_KEYNO").ToString()
                        vehDet.DoorKeyNo = dtrow("VEH_DOOR_KEYNO").ToString()
                        vehDet.ControlForm = dtrow("VEH_CONTROL_FORM").ToString()
                        vehDet.InteriorCode = dtrow("VEH_INTEROR_CODE").ToString()
                        vehDet.PurchaseNo = dtrow("VEH_PURCHASE_NO").ToString()
                        vehDet.AddonGroup = dtrow("VEH_ADDON_GROUP").ToString()
                        If (dtrow("DT_VEH_EXPECTED_IN").ToString() = "") Then
                            vehDet.Date_Expected_In = ""
                        Else
                            vehDet.Date_Expected_In = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_EXPECTED_IN").ToString())
                        End If
                        vehDet.Tires = dtrow("VEH_TIRES").ToString()
                        vehDet.Service_Category = dtrow("VEH_SERVICE_CATEGORY").ToString()
                        vehDet.No_Approval_No = dtrow("VEH_NO_APPROVAL_NO").ToString()
                        vehDet.Eu_Approval_No = dtrow("VEH_EU_APPROVAL_NO").ToString()
                        vehDet.ProductNo = dtrow("VEH_PRODUCT_NO").ToString()
                        vehDet.ElCode = dtrow("VEH_EL_CODE").ToString()
                        If (dtrow("DT_VEH_TAKEN_IN").ToString() = "") Then
                            vehDet.Taken_In_Date = ""
                        Else
                            vehDet.Taken_In_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_TAKEN_IN").ToString())
                        End If
                        vehDet.Taken_In_Mileage = IIf(IsDBNull(dtrow("VEH_TAKEN_IN_MILEAGE")), 0, dtrow("VEH_TAKEN_IN_MILEAGE").ToString())
                        If (dtrow("DT_VEH_DELIVERY").ToString() = "") Then
                            vehDet.Delivery_Date = ""
                        Else
                            vehDet.Delivery_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_DELIVERY").ToString())
                        End If
                        vehDet.Delivery_Mileage = IIf(IsDBNull(dtrow("VEH_DELIVERY_MILEAGE")), 0, dtrow("VEH_DELIVERY_MILEAGE").ToString())
                        If (dtrow("DT_VEH_SERVICE").ToString() = "") Then
                            vehDet.Service_Date = ""
                        Else
                            vehDet.Service_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_SERVICE").ToString())
                        End If
                        vehDet.Service_Mileage = IIf(IsDBNull(dtrow("VEH_SERVICE_MILEAGE")), 0, dtrow("VEH_SERVICE_MILEAGE").ToString())
                        If (dtrow("DT_VEH_CALL_IN").ToString() = "") Then
                            vehDet.Call_In_Date = ""
                        Else
                            vehDet.Call_In_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_CALL_IN").ToString())
                        End If
                        vehDet.Call_In_Mileage = IIf(IsDBNull(dtrow("VEH_CALL_IN_MILEAGE")), 0, dtrow("VEH_CALL_IN_MILEAGE").ToString())
                        If (dtrow("DT_VEH_CLEANED").ToString() = "") Then
                            vehDet.Cleaned_Date = ""
                        Else
                            vehDet.Cleaned_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VEH_CLEANED").ToString())
                        End If
                        vehDet.TechDocNo = dtrow("VEH_TECHDOC_NO").ToString()
                        vehDet.Length = IIf(IsDBNull(dtrow("VEH_LENGTH")), 0, dtrow("VEH_LENGTH").ToString())
                        vehDet.Width = IIf(IsDBNull(dtrow("VEH_WIDTH")), 0, dtrow("VEH_WIDTH").ToString())
                        vehDet.Noise_On_Veh = IIf(IsDBNull(dtrow("VEH_NOISE")), 0, dtrow("VEH_NOISE").ToString())
                        vehDet.EngineEff = IIf(IsDBNull(dtrow("VEH_EFFECT_KW")), 0, dtrow("VEH_EFFECT_KW").ToString())
                        vehDet.PisDisplacement = dtrow("VEH_PISTON_DISPLACEMENT").ToString()
                        vehDet.Rounds = dtrow("VEH_ROUNDS_PER_MIN").ToString()
                        vehDet.Used_Imported = IIf(IsDBNull(dtrow("VEH_USED_IMPORTED")), False, dtrow("VEH_USED_IMPORTED").ToString())
                        vehDet.Pressure_Mech_Brakes = IIf(IsDBNull(dtrow("VEH_PRESSURE_MECH_BRAKES")), False, dtrow("VEH_PRESSURE_MECH_BRAKES").ToString())
                        vehDet.Towbar = IIf(IsDBNull(dtrow("VEH_TOWBAR")), False, dtrow("VEH_TOWBAR").ToString())
                        vehDet.Service_Book = IIf(IsDBNull(dtrow("VEH_SERVICE_BOOK")), False, dtrow("VEH_SERVICE_BOOK").ToString())
                        If (dtrow("DT_LAST_PKK_APPROVED").ToString() = "") Then
                            vehDet.LastPKK_AppDate = ""
                        Else
                            vehDet.LastPKK_AppDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_LAST_PKK_APPROVED").ToString())
                        End If
                        If (dtrow("DT_NEXT_PKK").ToString() = "") Then
                            vehDet.NxtPKK_Date = ""
                        Else
                            vehDet.NxtPKK_Date = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_NEXT_PKK").ToString())
                        End If
                        If (dtrow("DT_LAST_PKK_INVOICED").ToString() = "") Then
                            vehDet.Last_PKK_Invoiced = ""
                        Else
                            vehDet.Last_PKK_Invoiced = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_LAST_PKK_INVOICED").ToString())
                        End If
                        vehDet.Call_In_Service = IIf(IsDBNull(dtrow("VEH_CALL_IN_SERVICE")), False, dtrow("VEH_CALL_IN_SERVICE").ToString())
                        vehDet.Call_In_Month_Service = IIf(IsDBNull(dtrow("VEH_CALL_IN_MONTH")), 0, dtrow("VEH_CALL_IN_MONTH").ToString())
                        vehDet.Call_In_Mileage_Service = IIf(IsDBNull(dtrow("VEH_CALL_IN_SERVICE_MILEAGE")), 0, dtrow("VEH_CALL_IN_SERVICE_MILEAGE").ToString())
                        vehDet.Do_Not_Call_PKK = IIf(IsDBNull(dtrow("VEH_DO_NOT_CALL_PKK")), False, dtrow("VEH_DO_NOT_CALL_PKK").ToString())
                        vehDet.Deviations_PKK = dtrow("VEH_DEVIATIONS_PKK").ToString()
                        vehDet.Yearly_Mileage = IIf(IsDBNull(dtrow("VEH_YEARLY_MILAGE")), 0, dtrow("VEH_YEARLY_MILAGE").ToString())
                        vehDet.Radio_Code = dtrow("VEH_RADIO_CODE").ToString()
                        vehDet.Start_Immobilizer = dtrow("VEH_START_IMMOBILIZER").ToString()
                        vehDet.Qty_Keys = IIf(IsDBNull(dtrow("VEH_QTY_KEYS")), 0, dtrow("VEH_QTY_KEYS").ToString())
                        vehDet.KeyTagNo = dtrow("VEH_KEYTAG_NO").ToString()
                        'fetching tabEconomy
                        vehDet.SalesPriceNet = IIf(IsDBNull(dtrow("VEH_SALESPRICE_NET")), 0, dtrow("VEH_SALESPRICE_NET").ToString())
                        vehDet.SalesSale = IIf(IsDBNull(dtrow("VEH_SALARY")), 0, dtrow("VEH_SALARY").ToString())
                        vehDet.SalesEquipment = IIf(IsDBNull(dtrow("VEH_SALES_EQUIPMENT")), 0D, dtrow("VEH_SALES_EQUIPMENT").ToString())
                        vehDet.RegCosts = IIf(IsDBNull(dtrow("VEH_REG_COSTS")), 0, dtrow("VEH_REG_COSTS").ToString())
                        vehDet.Discount = IIf(IsDBNull(dtrow("VEH_DISCOUNT")), 0, dtrow("VEH_DISCOUNT").ToString())
                        vehDet.NetSalesPrice = IIf(IsDBNull(dtrow("VEH_NET_SALESPRICE")), 0, dtrow("VEH_NET_SALESPRICE").ToString())
                        vehDet.FixCost = IIf(IsDBNull(dtrow("VEH_FIX_COST")), 0, dtrow("VEH_FIX_COST").ToString())
                        vehDet.AssistSales = IIf(IsDBNull(dtrow("VEH_ASSIST_SALE")), 0, dtrow("VEH_ASSIST_SALE").ToString())
                        vehDet.CostAfterSales = IIf(IsDBNull(dtrow("VEH_COST_AFTER_SALE")), 0, dtrow("VEH_COST_AFTER_SALE").ToString())
                        vehDet.ContributionsToday = IIf(IsDBNull(dtrow("VEH_CONTRIBUTION_TODAY")), 0, dtrow("VEH_CONTRIBUTION_TODAY").ToString())
                        vehDet.SalesPriceGross = IIf(IsDBNull(dtrow("VEH_SALESPRICE_GROSS")), 0, dtrow("VEH_SALESPRICE_GROSS").ToString())
                        vehDet.RegFee = IIf(IsDBNull(dtrow("VEH_REG_FEE")), 0, dtrow("VEH_REG_FEE").ToString())
                        vehDet.Vat = IIf(IsDBNull(dtrow("VEH_VAT")), 0, dtrow("VEH_VAT").ToString())
                        vehDet.TotAmount = IIf(IsDBNull(dtrow("VEH_TOTAL_AMOUNT")), 0, dtrow("VEH_TOTAL_AMOUNT").ToString())
                        vehDet.WreckingAmount = IIf(IsDBNull(dtrow("VEH_WRECKING_AMOUNT")), 0, dtrow("VEH_WRECKING_AMOUNT").ToString())
                        vehDet.YearlyFee = IIf(IsDBNull(dtrow("VEH_YEARLY_FEE")), 0, dtrow("VEH_YEARLY_FEE").ToString())
                        vehDet.Insurance = IIf(IsDBNull(dtrow("VEH_INSURANCE")), 0, dtrow("VEH_INSURANCE").ToString())
                        vehDet.CostPriceNet = IIf(IsDBNull(dtrow("VEH_COSTPRICE_NET")), 0, dtrow("VEH_COSTPRICE_NET").ToString())
                        vehDet.InsuranceBonus = IIf(IsDBNull(dtrow("VEH_INSURANCE_BONUS")), 0, dtrow("VEH_INSURANCE_BONUS").ToString())
                        vehDet.CostSales = IIf(IsDBNull(dtrow("VEH_COST_SALE")), 0, dtrow("VEH_COST_SALE").ToString())
                        vehDet.CostBeforeSale = IIf(IsDBNull(dtrow("VEH_COST_BEFORE_SALE")), 0, dtrow("VEH_COST_BEFORE_SALE").ToString())
                        vehDet.SalesProvision = IIf(IsDBNull(dtrow("VEH_SALES_PROVISION")), 0, dtrow("VEH_SALES_PROVISION").ToString())
                        vehDet.CommitDay = IIf(IsDBNull(dtrow("VEH_COMMIT_DAYS")), 0, dtrow("VEH_COMMIT_DAYS").ToString())
                        vehDet.AddedInterests = IIf(IsDBNull(dtrow("VEH_ADDED_INTERESTS")), 0, dtrow("VEH_ADDED_INTERESTS").ToString())
                        vehDet.CostEquipment = IIf(IsDBNull(dtrow("VEH_COST_EQUIPMENT")), 0, dtrow("VEH_COST_EQUIPMENT").ToString())
                        vehDet.TotalCost = IIf(IsDBNull(dtrow("VEH_TOTAL_COST")), 0, dtrow("VEH_TOTAL_COST").ToString())

                        vehDet.CreditNoteNo = dtrow("VEH_CREDITNOTE_NO").ToString()
                        If (dtrow("DT_CREDITNOTE").ToString() = "") Then
                            vehDet.CreditNoteDate = ""
                        Else
                            vehDet.CreditNoteDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREDITNOTE").ToString())
                        End If
                        vehDet.InvoiceNo = dtrow("VEH_INVOICE_NO").ToString()
                        If (dtrow("DT_INVOICE").ToString() = "") Then
                            vehDet.InvoiceDate = ""
                        Else
                            vehDet.InvoiceDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_INVOICE").ToString())
                        End If
                        If (dtrow("DT_REBUY").ToString() = "") Then
                            vehDet.RebuyDate = ""
                        Else
                            vehDet.RebuyDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_REBUY").ToString())
                        End If
                        vehDet.RebuyPrice = IIf(IsDBNull(dtrow("VEH_REBUY_PRICE")), 0, dtrow("VEH_REBUY_PRICE").ToString())
                        vehDet.CostPerKm = IIf(IsDBNull(dtrow("VEH_COST_PER_KM")), 0, dtrow("VEH_COST_PER_KM").ToString())
                        vehDet.Turnover = IIf(IsDBNull(dtrow("VEH_TURNOVER")), 0, dtrow("VEH_TURNOVER").ToString())
                        vehDet.Progress = IIf(IsDBNull(dtrow("VEH_PROGRESS")), 0, dtrow("VEH_PROGRESS").ToString())
                        vehDet.Axle1 = dtrow("VEH_AXLE1").ToString()
                        vehDet.Axle2 = dtrow("VEH_AXLE2").ToString()
                        vehDet.Axle3 = dtrow("VEH_AXLE3").ToString()
                        vehDet.Axle4 = dtrow("VEH_AXLE4").ToString()
                        vehDet.Axle5 = dtrow("VEH_AXLE5").ToString()
                        vehDet.Axle6 = dtrow("VEH_AXLE6").ToString()
                        vehDet.Axle7 = dtrow("VEH_AXLE7").ToString()
                        vehDet.Axle8 = dtrow("VEH_AXLE8").ToString()
                        vehDet.TrailerDesc = dtrow("VEH_TRAILER_DESC").ToString()

                        'fetch certificate tab
                        vehDet.StdTyreFront = dtrow("VEH_STD_TIRE_FRONT").ToString()
                        vehDet.StdTyreBack = dtrow("VEH_STD_TIRE_BACK").ToString()
                        vehDet.MinLi_Front = dtrow("VEH_MINLI_FRONT").ToString()
                        vehDet.MinLi_Back = dtrow("VEH_MINLI_BACK").ToString()
                        vehDet.Min_Inpress_Front = dtrow("VEH_MIN_INPRESS_FRONT").ToString()
                        vehDet.Min_Inpress_Back = dtrow("VEH_MIN_INPRESS_BACK").ToString()
                        vehDet.Std_Rim_Front = dtrow("VEH_STD_RIM_FRONT").ToString()
                        vehDet.Std_Rim_Back = dtrow("VEH_STD_RIM_BACK").ToString()
                        vehDet.Min_Front = dtrow("VEH_MIN_SPEED_FRONT").ToString()
                        vehDet.Min_Back = dtrow("VEH_MIN_SPEED_BACK").ToString()
                        vehDet.Max_Tyre_Width_Frnt = dtrow("VEH_MAX_TRACK_FRONT").ToString()
                        vehDet.Max_Tyre_Width_Bk = dtrow("VEH_MAX_TRACK_BACK").ToString()
                        vehDet.AxlePrFront = dtrow("VEH_ALLOWABLE_WEIGHT_FRONT").ToString()
                        vehDet.AxlePrBack = dtrow("VEH_ALLOWABLE_WEIGHT_BACK").ToString()
                        vehDet.Axles_Number = dtrow("VEH_QTY_AXLES").ToString()
                        vehDet.Axles_Number_Traction = dtrow("VEH_OPERATIVE_AXLES").ToString()
                        vehDet.Wheels_Traction = dtrow("VEH_DRIVE_WHEEL").ToString()
                        vehDet.TrailerWth_Brks = dtrow("VEH_TRAILER_WEIGHT_W_BRAKES").ToString()
                        vehDet.TrailerWthout_Brks = dtrow("VEH_TRAILER_WEIGHT_WO_BRAKES").ToString()
                        vehDet.Max_Wt_TBar = dtrow("VEH_MAX_LOAD_TOWBAR").ToString()
                        vehDet.Len_TBar = dtrow("VEH_LENGTH_TO_TOWBAR").ToString()
                        vehDet.TotalTrailerWeight = dtrow("VEH_TOTAL_TRAILER_WEIGHT").ToString()
                        vehDet.Seats = dtrow("VEH_SEATS").ToString()
                        If (dtrow("DT_VALID_FROM").ToString() = "") Then
                            vehDet.ValidFrom = ""
                        Else
                            vehDet.ValidFrom = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_VALID_FROM").ToString())
                        End If
                        vehDet.EU_Version = dtrow("VEH_EU_VERSION").ToString()
                        vehDet.EU_Variant = dtrow("VEH_EU_VARIANT").ToString()
                        vehDet.EU_Norm = dtrow("VEH_EURONORM").ToString()
                        vehDet.CO2_Emission = dtrow("VEH_CO2_EMISSION").ToString()
                        vehDet.Make_Part_Filter = dtrow("VEH_MAKE_PARTICLE_FILTER").ToString()
                        vehDet.Chassi_Desc = dtrow("VEH_CHASSI").ToString()
                        vehDet.Identity_Annot = dtrow("VEH_IDENTITY").ToString()
                        vehDet.Cert_Text = dtrow("VEH_CERTIFICATE").ToString()
                        vehDet.Annot = dtrow("VEH_ANNOTATIONS").ToString()

                        retVehicle.Add(vehDet)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retVehicle
        End Function

        Public Function FetchNewUsedCode() As List(Of VehicleBO)
            Dim dsFetchNewUsed As New DataSet
            Dim dtNewUsedCodes As DataTable
            Dim newUsedList As New List(Of VehicleBO)()
            Try
                dsFetchNewUsed = objVehicleDO.FetchNewUsedCodes()
                dtNewUsedCodes = dsFetchNewUsed.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtNewUsedCodes.Rows
                    Dim NewUsedDet As New VehicleBO()
                    NewUsedDet.RefnoCode = dtrow("Refno_Code").ToString()
                    NewUsedDet.RefnoDescription = dtrow("Refno_Description").ToString()
                    NewUsedDet.RefnoPrefix = dtrow("Refno_Prefix").ToString()
                    NewUsedDet.RefnoCount = dtrow("Refno_Count").ToString()
                    newUsedList.Add(NewUsedDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchNewUsedCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return newUsedList.ToList
        End Function
        Public Function GetNewUsedRefNo(ByVal refNo As String) As List(Of VehicleBO)
            Dim dsFetchNewUsed As New DataSet
            Dim dtNewUsedCodes As DataTable
            Dim newUsedList As New List(Of VehicleBO)()
            Try
                dsFetchNewUsed = objVehicleDO.GetNewUsedRefNo(refNo)
                dtNewUsedCodes = dsFetchNewUsed.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtNewUsedCodes.Rows
                    Dim RefnoDet As New VehicleBO()
                    RefnoDet.RefnoCode = dtrow("refno_code").ToString()
                    RefnoDet.RefnoPrefix = dtrow("refno_prefix").ToString()
                    RefnoDet.RefnoCount = dtrow("refno_count").ToString()
                    newUsedList.Add(RefnoDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchRefNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return newUsedList.ToList
        End Function
        Public Function SetNewUsedRefNo(ByVal refNoType As String, ByVal refNo As String) As List(Of VehicleBO)
            Dim dsFetchNewUsed As New DataSet
            Dim dtNewUsedCodes As DataTable
            Dim newUsedList As New List(Of VehicleBO)()
            Try
                dsFetchNewUsed = objVehicleDO.SetNewUsedRefNo(refNoType, refNo)
                dtNewUsedCodes = dsFetchNewUsed.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtNewUsedCodes.Rows
                    Dim RefnoDet As New VehicleBO()
                    RefnoDet.RefnoCode = dtrow("refno_code").ToString()
                    RefnoDet.RefnoPrefix = dtrow("refno_prefix").ToString()
                    RefnoDet.RefnoCount = dtrow("refno_count").ToString()
                    newUsedList.Add(RefnoDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchRefNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return newUsedList.ToList
        End Function

        Public Function FetchStatusCode() As List(Of VehicleBO)
            Dim dsFetchStatus As New DataSet
            Dim dtStatusCodes As DataTable
            Dim statusList As New List(Of VehicleBO)()
            Try
                dsFetchStatus = objVehicleDO.FetchStatusCodes()
                dtStatusCodes = dsFetchStatus.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtStatusCodes.Rows
                    Dim statusDet As New VehicleBO()
                    statusDet.StatusCode = dtrow("SettingsCode").ToString()
                    statusDet.StatusDesc = dtrow("SettingDescription").ToString()
                    statusList.Add(statusDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchStatusCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return statusList.ToList
        End Function

        Public Function FetchWarrantyCode() As List(Of VehicleBO)
            Dim dsFetchAllWarranty As New DataSet
            Dim dtWarrantyCodes As DataTable
            Dim warranty As New List(Of VehicleBO)()
            Try
                dsFetchAllWarranty = objVehicleDO.FetchAllWarrantyCodes()
                dtWarrantyCodes = dsFetchAllWarranty.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtWarrantyCodes.Rows
                    Dim warrantyDet As New VehicleBO()
                    warrantyDet.WarrantyCodes = dtrow("SettingsCode").ToString()
                    warrantyDet.WarrantyDesc = dtrow("SettingDescription").ToString()
                    warranty.Add(warrantyDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchWarrantyCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return warranty.ToList
        End Function

        Public Function FetchMakeCode() As List(Of VehicleBO)
            Dim dsFetchAllMakes As New DataSet
            Dim dtMakeCodes As DataTable
            Dim Make As New List(Of VehicleBO)()
            Try
                dsFetchAllMakes = objVehicleDO.FetchAllMakeCodes()
                dtMakeCodes = dsFetchAllMakes.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtMakeCodes.Rows
                    Dim makeDet As New VehicleBO()
                    makeDet.Id_Make_Veh = dtrow("ID_MAKE").ToString()
                    makeDet.MakeName = dtrow("ID_MAKE_NAME").ToString()
                    Make.Add(makeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "FetchMakeCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Make.ToList
        End Function

        Public Function GetVehGroup(ByVal VehGrp As String) As List(Of String)
            Dim retVehGroup As New List(Of String)()
            Dim dsVehGroup As New DataSet
            Dim dtVehGroup As New DataTable
            Try
                objVehicleBO.VehGrp = VehGrp
                dsVehGroup = objVehicleDO.Fetch_VehGroup(objVehicleBO.VehGrp)

                If dsVehGroup.Tables.Count > 0 Then
                    If dsVehGroup.Tables(0).Rows.Count > 0 Then
                        dtVehGroup = dsVehGroup.Tables(0)
                    End If
                End If
                For Each dtrow As DataRow In dtVehGroup.Rows
                    retVehGroup.Add(String.Format("{0}-{1}-{2}", dtrow("ID_SETTINGS"), dtrow("Description"), dtrow("REMARKS")))
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "getVehGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retVehGroup
        End Function

        Public Function GetFuelCode(ByVal FuelCode As String) As List(Of String)
            Dim retFuelCode As New List(Of String)()
            Dim dsFuelCode As New DataSet
            Dim dtFuelCode As New DataTable
            Try
                objVehicleBO.FuelCode = FuelCode
                dsFuelCode = objVehicleDO.Fetch_FuelCode(objVehicleBO.FuelCode)

                If dsFuelCode.Tables.Count > 0 Then
                    If dsFuelCode.Tables(0).Rows.Count > 0 Then
                        dtFuelCode = dsFuelCode.Tables(0)
                    End If
                End If
                For Each dtrow As DataRow In dtFuelCode.Rows
                    retFuelCode.Add(String.Format("{0}-{1}", dtrow("SettingsCode"), dtrow("SettingDescription")))
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "getFuelCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retFuelCode
        End Function

        Public Function GetWareHouse(ByVal WH As String) As List(Of String)
            Dim retWareHouse As New List(Of String)()
            Dim dsWareHouse As New DataSet
            Dim dtWareHouse As New DataTable
            Try
                objVehicleBO.WareHouse = WH
                dsWareHouse = objVehicleDO.Fetch_WareHouse(objVehicleBO.WareHouse)

                If dsWareHouse.Tables.Count > 0 Then
                    If dsWareHouse.Tables(0).Rows.Count > 0 Then
                        dtWareHouse = dsWareHouse.Tables(0)
                    End If
                End If
                For Each dtrow As DataRow In dtWareHouse.Rows
                    retWareHouse.Add(String.Format("{0}-{1}-{2}", dtrow("ID_DEPT"), dtrow("DPT_NAME"), dtrow("DPT_LOCATION")))
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Vehicle.vb", "getWareHouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retWareHouse
        End Function
        Public Function GetVehicle(ByVal vehicleRegNo As String) As List(Of String)
            Dim dsVehicle As New DataSet
            Dim dtVehicle As DataTable
            Dim retVehicle As New List(Of String)()
            Try
                dsVehicle = objVehicleDO.GetVehicle(vehicleRegNo)

                If dsVehicle.Tables.Count > 0 Then
                    If dsVehicle.Tables(0).Rows.Count > 0 Then
                        dtVehicle = dsVehicle.Tables(0)
                    End If
                End If
                If vehicleRegNo <> String.Empty Then
                    For Each dtrow As DataRow In dtVehicle.Rows
                        retVehicle.Add(String.Format("{0}", dtrow("ACRESULT")))
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retVehicle
        End Function
        Public Function Fetch_VehConfig() As List(Of VehicleBO)
            Dim dsVehConfig As New DataSet
            Dim dtVehConfig As DataTable
            Dim details As New List(Of VehicleBO)()
            Try
                dsVehConfig = objVehicleDO.Fetch_VehConfig()

                If dsVehConfig.Tables.Count > 0 Then
                    If dsVehConfig.Tables(1).Rows.Count > 0 Then
                        dtVehConfig = dsVehConfig.Tables(1)
                        For Each dtrow As DataRow In dtVehConfig.Rows
                            Dim vehDet As New VehicleBO()
                            vehDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                            vehDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(vehDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                Throw ex
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_Model(ByVal objVehicleBO As VehicleBO) As List(Of VehicleBO)
            Dim dsVehConfig As New DataSet
            Dim dtVehConfig As DataTable
            Dim details As New List(Of VehicleBO)()
            Try
                dsVehConfig = objVehicleDO.Fetch_VehModel(objVehicleBO)
                If dsVehConfig.Tables.Count > 0 Then
                    HttpContext.Current.Session("RPMOdel") = dsVehConfig.Tables(1)
                    If dsVehConfig.Tables(0).Rows.Count > 0 Then
                        dtVehConfig = dsVehConfig.Tables(0)
                        For Each dtrow As DataRow In dtVehConfig.Rows
                            Dim vehDet As New VehicleBO()
                            vehDet.Id_Model = dtrow("ID_MG_SEQ").ToString()
                            vehDet.Model_Desc = dtrow("MG_ID_MODEL_GRP").ToString()
                            details.Add(vehDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                Throw ex
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_RPModel() As List(Of VehicleBO)
            Dim dsVehConfig As New DataSet
            Dim dtVehConfig As DataTable
            Dim details As New List(Of VehicleBO)()
            Try
                dsVehConfig = HttpContext.Current.Session("RPMOdel")

                If dsVehConfig.Tables.Count > 0 Then
                    If dsVehConfig.Tables(0).Rows.Count > 0 Then
                        dtVehConfig = dsVehConfig.Tables(0)
                        For Each dtrow As DataRow In dtVehConfig.Rows
                            Dim vehDet As New VehicleBO()
                            vehDet.Id_Model = dtrow("ID_MODEL").ToString()
                            vehDet.Model_Desc = dtrow("MODEL_ID_MAKE").ToString()
                            details.Add(vehDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                Throw ex
            End Try
            Return details.ToList
        End Function

        Public Function FetchEditMake() As List(Of VehicleBO)
            Dim dsFetchMake As New DataSet
            Dim dtMake As DataTable
            Dim Make As New List(Of VehicleBO)()
            Try
                dsFetchMake = objVehicleDO.FetchEditMake()
                dtMake = dsFetchMake.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtMake.Rows
                    Dim makeDet As New VehicleBO()
                    makeDet.MakeCode = dtrow("ID_MAKE").ToString()
                    makeDet.MakeName = dtrow("ID_MAKE_NAME").ToString()
                    Make.Add(makeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Make.ToList
        End Function

        Public Function GetEditMake(ByVal makeId As String) As List(Of VehicleBO)
            Dim dsGetMake As New DataSet
            Dim dtGetMake As DataTable
            Dim Make As New List(Of VehicleBO)()
            Try
                dsGetMake = objVehicleDO.GetEditMake(makeId)
                dtGetMake = dsGetMake.Tables(0)
                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtGetMake.Rows
                    Dim getMakeDet As New VehicleBO()
                    getMakeDet.MakeCode = dtrow("ID_MAKE").ToString()
                    getMakeDet.MakeName = dtrow("ID_MAKE_NAME").ToString()
                    If (IsDBNull(dtrow("ID_MAKE_PRICECODE").ToString())) Then
                        getMakeDet.Cost_Price = ""
                    Else
                        getMakeDet.Cost_Price = dtrow("ID_MAKE_PRICECODE").ToString()
                    End If
                    If (IsDBNull(dtrow("MAKEDISCODE").ToString())) Then
                        getMakeDet.Description = ""
                    Else
                        getMakeDet.Description = dtrow("MAKEDISCODE").ToString()
                    End If
                    If (IsDBNull(dtrow("MAKE_VATCODE").ToString())) Then
                        getMakeDet.VanNo = ""
                    Else
                        getMakeDet.VanNo = dtrow("MAKE_VATCODE").ToString()
                    End If
                    Make.Add(getMakeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Make.ToList
        End Function
        Public Function Add_EditMake(ByVal strXMLSettingsVehMake As String) As String
            Dim strResult As String = ""
            Try
                strResult = objVehicleDO.Add_EditMake(strXMLSettingsVehMake)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "Add_Vehicle", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteEditMake(ByVal editMakeId As String) As List(Of VehicleBO)
            Dim dsGetBranch As New DataSet

            Dim Branch As New List(Of VehicleBO)()
            Try
                objVehicleDO.Delete_EditMake(editMakeId)

                'HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Customer.vb", "FetchCustomerGroup", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return Branch.ToList
        End Function
        Public Function GetModel(ByVal IdMake As String, ByVal Model As String) As String
            Dim dsRes As New DataSet
            Dim strResult As String
            Try
                objVehicleBO.Id_Make_Veh = IdMake
                objVehicleBO.Model_Desc = Model
                dsRes = objVehicleDO.GetModel(objVehicleBO)
                If dsRes.Tables(0).Rows.Count > 0 Then
                    strResult = dsRes.Tables(0).Rows(0)("ID_MG_SEQ").ToString
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "GetModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function LoadModel() As List(Of VehicleBO)
            Dim details As New List(Of VehicleBO)()
            Dim dsVEHDetails As New DataSet
            Dim dtVEHDetails As New DataTable
            Try
                dsVEHDetails = objWOHDO.Fetch_WO_Config()
                If dsVEHDetails.Tables.Count > 0 Then
                    If dsVEHDetails.Tables(11).Rows.Count > 0 Then
                        dtVEHDetails = dsVEHDetails.Tables(11)
                        For Each dtrow As DataRow In dtVEHDetails.Rows
                            Dim vehDet As New VehicleBO()
                            vehDet.Id_Model = dtrow("ID_MODEL").ToString()
                            vehDet.Model_Desc = dtrow("MODEL_DESC").ToString()
                            details.Add(vehDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "LoadModel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function LoadVatCode() As List(Of VehicleBO)

            Dim details As New List(Of VehicleBO)()
            Dim dsVEHDetails As New DataSet
            Dim dtVEHDetails As New DataTable

            Try

                dsVEHDetails = objVehicleDO.Fetch_VatCode()
                If dsVEHDetails.Tables.Count > 0 Then

                    dtVEHDetails = dsVEHDetails.Tables(0)
                    For Each dtrow As DataRow In dtVEHDetails.Rows
                        Dim vehDet As New VehicleBO()
                        vehDet.vatCode = dtrow("ID_SETTINGS").ToString()
                        vehDet.vatDesc = dtrow("DESCRIPTION").ToString()
                        details.Add(vehDet)
                    Next

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Vehicle", "LoadMomskode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

    End Class
End Namespace
