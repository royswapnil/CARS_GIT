Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Namespace CARS.Services.ConfigVehicle
    Public Class ConfigVehicle
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objConfigVehDO As New ConfigVehicleDO
        Shared objConfigVehBO As New ConfigVehicleBO
        Shared objConfigWODO As New ConfigWorkOrder.ConfigWorkOrderDO
        Shared objConfigSettDO As New ConfigSettings.ConfigSettingsDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Public Function Fetch_ConfigDetails() As Collection
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim dt As New Collection
            dsVehDetails = objConfigVehDO.Fetch_Config()
            If dsVehDetails.Tables(0).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(0)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Make_Code = IIf(IsDBNull(dtrow("Id_Make")) = True, "", dtrow("Id_Make"))
                    vehDet.Description = IIf(IsDBNull(dtrow("Id_Make_Name")) = True, "", dtrow("Id_Make_Name"))
                    vehDet.Price_Code = IIf(IsDBNull(dtrow("Id_Price_Code")) = True, "", dtrow("Id_Price_Code"))
                    vehDet.Discount_Code = IIf(IsDBNull(dtrow("MakeDisCode")) = True, "", dtrow("MakeDisCode"))
                    vehDet.Vat_Code = IIf(IsDBNull(dtrow("Make_VatCode")) = True, "", dtrow("Make_VatCode"))
                    vehDet.Id_Make_Code = IIf(IsDBNull(dtrow("Id_Make_PriceCode")) = True, "", dtrow("Id_Make_PriceCode"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(0)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If
            If dsVehDetails.Tables(9).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(9)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    vehDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(9)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If
            If dsVehDetails.Tables(7).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(7)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Description = IIf(IsDBNull(dtrow("MODEL_DESC")) = True, "", dtrow("MODEL_DESC"))
                    vehDet.Model_Group = IIf(IsDBNull(dtrow("ID_MODEL")) = True, "", dtrow("ID_MODEL"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(7)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If
            If dsVehDetails.Tables(2).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(2)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    vehDet.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(2)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If
            If dsVehDetails.Tables(11).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(11)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Id_Settings = IIf(IsDBNull(dtrow("Id_Settings")) = True, "", dtrow("Id_Settings"))
                    vehDet.Id_Veh_Grp = IIf(IsDBNull(dtrow("Id_Veh_Grp")) = True, "", dtrow("Id_Veh_Grp"))
                    vehDet.Veh_Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    vehDet.Id_Vg_PCode = IIf(IsDBNull(dtrow("ID_VG_PCODE")) = True, "", dtrow("ID_VG_PCODE"))
                    vehDet.Vh_IntervalName = IIf(IsDBNull(dtrow("VH_IntervalName")) = True, "", dtrow("VH_IntervalName"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(11)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If
            If dsVehDetails.Tables(10).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(10)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Id_Settings = IIf(IsDBNull(dtrow("ID_SETTINGS")) = True, "", dtrow("ID_SETTINGS"))
                    vehDet.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(11)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If

            If dsVehDetails.Tables(12).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(12)
                Dim details As New List(Of ConfigVehicleBO)()
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Id_Settings = IIf(IsDBNull(dtrow("IntervalName")) = True, "", dtrow("IntervalName"))
                    details.Add(vehDet)
                Next
                dt.Add(details)
            Else
                dtVehDetails = dsVehDetails.Tables(11)
                Dim details As New List(Of ConfigVehicleBO)()
                dt.Add(details)
            End If

            Return dt
        End Function
        Public Function Load_DisListData() As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            dsVehDetails = objConfigWODO.GetDisListData()
            If dsVehDetails.Tables(1).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(1)
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    details.Add(vehDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function Load_VatCode(ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            dsVehDetails = objConfigVehDO.Fetch_VEHConfiguration(IdLogin)
            If dsVehDetails.Tables(1).Rows.Count > 0 Then
                dtVehDetails = dsVehDetails.Tables(1)
                For Each dtrow As DataRow In dtVehDetails.Rows
                    Dim vehDet As New ConfigVehicleBO()
                    vehDet.Description = IIf(IsDBNull(dtrow("Description")) = True, "", dtrow("Description"))
                    details.Add(vehDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function UpdateVehMakeModelConfig(ByVal strXmlVehMake As String, ByVal strXmlVehModel As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.UpdateConfig(strXmlVehModel)
            strArray = strResult.Split(";")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function UpdateVehMakeConfig(ByVal strXmlVehMake As String, ByVal strXmlVehModel As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigVehDO.UpdateMakeMG(strXmlVehMake, strXmlVehModel, IdLogin)
            strArray = strResult.Split(";")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveVehMakeConfig(ByVal strXmlVehMake As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigVehDO.SaveMake(strXmlVehMake, IdLogin)
            strArray = strResult.Split(";")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function UpdateVehGroup(ByVal strXmlVehGrp As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigVehDO.UpdateVehGrp(strXmlVehGrp, IdLogin)
            strArray = strResult.Split(";")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function saveVehGroup(ByVal strXmlVehGrp As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigVehDO.saveVehGrp(strXmlVehGrp, IdLogin)
            strArray = strResult.Split(";")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function SaveVehModelConfig(ByVal strXmlVehModel As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.InsertConfig(strXmlVehModel)
            strArray = strResult.Split(",")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function saveLoc(ByVal strXMLSettingsUpdate As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.InsertConfig(strXMLSettingsUpdate)
            strArray = strResult.Split(",")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function updLoc(ByVal strXMLSettingsUpdate As String, ByVal IdLogin As String) As List(Of ConfigVehicleBO)
            Dim dsVehDetails As New DataSet
            Dim dtVehDetails As New DataTable
            Dim details As New List(Of ConfigVehicleBO)()
            Dim strArray As Array
            Dim strResult As String = ""
            strResult = objConfigSettingsDO.UpdateConfig(strXMLSettingsUpdate)
            strArray = strResult.Split(",")
            Dim vehDet As New ConfigVehicleBO()
            If strArray.Length > 0 Then
                vehDet.RetVal_Saved = strArray(2)
                vehDet.RetVal_NotSaved = strArray(1)
                details.Add(vehDet)
            End If
            Return details.ToList
        End Function
        Public Function DeleteConfigMake(ByVal makexml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigVehDO.DeleteConfigMake(makexml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigVehicle", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteConfigModel(ByVal modelxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(modelxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigVehicle", "DeleteConfigMake", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DeleteVehGroup(ByVal vehIdxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(vehIdxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigVehicle", "DeleteVehGroup", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function DelLocation(ByVal locIdxml As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(locIdxml)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigVehicle", "DelLocation", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace

