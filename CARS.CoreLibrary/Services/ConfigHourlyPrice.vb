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
Namespace CARS.Services.ConfigHourlyPrice
    Public Class ConfigHourlyPrice
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objConfigSettingsBO As New ConfigSettingsBO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO

        Public Function FetchAllHPConfig() As Collection
            Dim dsHPConfig As New DataSet
            Dim dtHPConfig As New DataTable
            Dim dtHPConfigColl As New Collection
            Try
                dsHPConfig = objConfigSettingsDO.Fetch_HPConfiguration()
                HttpContext.Current.Session("TimeRegConfig") = dsHPConfig

                If dsHPConfig.Tables.Count > 0 Then
                    'Price Code for Customer
                    If (dsHPConfig.Tables(0).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeCust As New ConfigSettingsBO()
                            prCodeCust.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeCust.Description = dtrow("DESCRIPTION").ToString()
                            prCodeCust.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeCust)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(0).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                    'Price Code for Repair Package
                    If (dsHPConfig.Tables(1).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeRpkg As New ConfigSettingsBO()
                            prCodeRpkg.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeRpkg.Description = dtrow("DESCRIPTION").ToString()
                            prCodeRpkg.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeRpkg)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(1).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                    'Price Code on Job
                    If (dsHPConfig.Tables(2).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(2)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeJob As New ConfigSettingsBO()
                            prCodeJob.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeJob.Description = dtrow("DESCRIPTION").ToString()
                            prCodeJob.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeJob)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(2).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(2)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                    'Price Code for Mechanic
                    If (dsHPConfig.Tables(3).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(3)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeMech As New ConfigSettingsBO()
                            prCodeMech.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeMech.Description = dtrow("DESCRIPTION").ToString()
                            prCodeMech.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeMech)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(3).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(3)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                    'Price Code for Make
                    If (dsHPConfig.Tables(4).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(4)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeMake As New ConfigSettingsBO()
                            prCodeMake.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeMake.Description = dtrow("DESCRIPTION").ToString()
                            prCodeMake.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeMake)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(4).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(4)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                    'Price Code for Vehicle Group
                    If (dsHPConfig.Tables(5).Rows.Count > 0) Then
                        dtHPConfig = dsHPConfig.Tables(5)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtHPConfig.Rows
                            Dim prCodeVehgrp As New ConfigSettingsBO()
                            prCodeVehgrp.IdSettings = dtrow("ID_SETTINGS").ToString()
                            prCodeVehgrp.Description = dtrow("DESCRIPTION").ToString()
                            prCodeVehgrp.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "", dtrow("TR_PER"))
                            details.Add(prCodeVehgrp)
                        Next
                        dtHPConfigColl.Add(details)
                    ElseIf (dsHPConfig.Tables(5).Rows.Count = 0) Then
                        dtHPConfig = dsHPConfig.Tables(5)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtHPConfigColl.Add(details)
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigHourlyPrice", "FetchAllHPConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtHPConfigColl
        End Function

        Public Function DeleteConfig(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteHPConfig(xmlDoc)
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
                objErrHandle.WriteErrorLog(1, "CommonUtility", "DeleteConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace

