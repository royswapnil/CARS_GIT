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
Namespace CARS.Services.ConfigTimeRegistration
    Public Class ConfigTimeRegistration

        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objConfigSettingsBO As New ConfigSettingsBO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Public Function FetchAllTimeRegConfig() As Collection
            Dim dsTRConfig As New DataSet
            Dim dtTRConfig As New DataTable
            Dim dtTRConfigColl As New Collection
            Try
                dsTRConfig = objConfigSettingsDO.Fetch_TRConfiguration(HttpContext.Current.Session("UserID").ToString(), "TR-REASCD", "TR-COUT", Nothing, Nothing, Nothing)
                HttpContext.Current.Session("TimeRegConfig") = dsTRConfig

                If dsTRConfig.Tables.Count > 0 Then
                    'Reasons for Unsold Time
                    If (dsTRConfig.Tables(0).Rows.Count > 0) Then
                        dtTRConfig = dsTRConfig.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtTRConfig.Rows
                            Dim trCodeDet As New ConfigSettingsBO()
                            trCodeDet.IdSettings = dtrow("ID_SETTINGS").ToString()
                            trCodeDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            trCodeDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(trCodeDet)
                        Next
                        dtTRConfigColl.Add(details)
                    ElseIf (dsTRConfig.Tables(0).Rows.Count = 0) Then
                        dtTRConfig = dsTRConfig.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtTRConfigColl.Add(details)
                    End If

                    'Reasons for clockout
                    If (dsTRConfig.Tables(1).Rows.Count > 0) Then
                        dtTRConfig = dsTRConfig.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtTRConfig.Rows
                            Dim trCodeDet As New ConfigSettingsBO()
                            trCodeDet.IdSettings = dtrow("ID_SETTINGS").ToString()
                            trCodeDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            trCodeDet.Description = dtrow("DESCRIPTION").ToString()
                            trCodeDet.TR_Percentage = dtrow("TR_PER").ToString()
                            details.Add(trCodeDet)
                        Next
                        dtTRConfigColl.Add(details)
                    ElseIf (dsTRConfig.Tables(1).Rows.Count = 0) Then
                        dtTRConfig = dsTRConfig.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtTRConfigColl.Add(details)
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigTimeRegistration", "FetchAllTimeRegConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtTRConfigColl
        End Function
        Public Function GetTimeRegDet(ByVal idconfig As String, ByVal idsettings As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("TimeRegConfig")
                If (ds.Tables.Count > 0) Then

                    If (idconfig = "TR-REASCD") Then
                        If (ds.Tables(0).Rows.Count > 0) Then
                            dt = ds.Tables(0)
                            dv = dt.DefaultView
                            dv.RowFilter = "id_settings = '" + idsettings + "'"

                        End If
                    ElseIf (idconfig = "TR-COUT") Then
                        If (ds.Tables(1).Rows.Count > 0) Then
                            dt = ds.Tables(1)
                            dv = dt.DefaultView
                            dv.RowFilter = "id_settings = '" + idsettings + "'"
                        End If
                    ElseIf (idconfig = "TR-IDLECD") Then
                        If (ds.Tables(0).Rows.Count > 0) Then
                            dt = ds.Tables(0)
                            dv = dt.DefaultView
                            dv.RowFilter = "id_settings = '" + idsettings + "'"
                        End If
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim trCodeDet As New ConfigSettingsBO()
                            trCodeDet.IdSettings = dtrow("ID_SETTINGS").ToString()
                            trCodeDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            trCodeDet.Description = dtrow("DESCRIPTION").ToString()
                            trCodeDet.TR_Percentage = IIf(IsDBNull(dtrow("TR_PER")) = True, "0", dtrow("TR_PER"))
                            details.Add(trCodeDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigTimeRegistration", "GetTimeRegDet", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function


    End Class
End Namespace

