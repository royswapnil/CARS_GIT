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
Namespace CARS.Services.ConfigPlanning
    Public Class ConfigPlanning
        Shared objConfigPlanningBO As New ConfigPlanningBO
        Shared objConfigPlanningDO As New CARS.ConfigPlanningDO.ConfigPlanningDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr

        Public Function FetchAllStations(ByVal deptId As String) As List(Of ConfigPlanningBO)
            Dim details As New List(Of ConfigPlanningBO)()
            Dim dsConfigStations As New DataSet
            Dim dtConfigStations As New DataTable
            Dim dsStationDepMapList As New DataSet
            Try
                dsConfigStations = objConfigPlanningDO.FetchAllStations(deptId)
                HttpContext.Current.Session("AllStations") = dsConfigStations
                If dsConfigStations.Tables.Count > 0 Then
                    dtConfigStations = dsConfigStations.Tables(0)
                    For Each dtrow As DataRow In dtConfigStations.Rows
                        Dim configStationsDet As New ConfigPlanningBO()
                        configStationsDet.Id_Station = dtrow("Id_Station").ToString()
                        configStationsDet.Station_Name = dtrow("Name_Station").ToString()
                        configStationsDet.Id_StationType = dtrow("Id_SType").ToString()
                        configStationsDet.StationType = dtrow("Type_Station").ToString()

                        details.Add(configStationsDet)
                    Next
                End If

                dsStationDepMapList = objConfigPlanningDO.Fetch_StationDepMapList()
                HttpContext.Current.Session("StationDepMapList") = dsStationDepMapList


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "FetchAllStations", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchAllStationTypes() As List(Of ConfigPlanningBO)
            Dim details As New List(Of ConfigPlanningBO)()
            Dim dsConfigStationTypes As New DataSet
            Dim dtConfigStationTypes As New DataTable
            Try
                dsConfigStationTypes = objConfigPlanningDO.FetchAllStationTypes()
                If dsConfigStationTypes.Tables.Count > 0 Then
                    dtConfigStationTypes = dsConfigStationTypes.Tables(0)
                    For Each dtrow As DataRow In dtConfigStationTypes.Rows
                        Dim configStationTypesDet As New ConfigPlanningBO()
                        configStationTypesDet.Id_StationType = dtrow("Id_SType").ToString()
                        configStationTypesDet.StationType = dtrow("Type_Station").ToString()

                        details.Add(configStationTypesDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "FetchAllStationTypes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchAllDepartment() As List(Of ConfigPlanningBO)
            Dim details As New List(Of ConfigPlanningBO)()
            Dim dsConfig As New DataSet
            Dim dtConfig As New DataTable
            Try
                dsConfig = objConfigPlanningDO.FetchAllDepartment()
                If dsConfig.Tables.Count > 0 Then
                    dtConfig = dsConfig.Tables(0)
                    For Each dtrow As DataRow In dtConfig.Rows
                        Dim config As New ConfigPlanningBO()
                        config.Id_Dept = dtrow("Id_Dept").ToString()
                        config.DeptName = dtrow("Dpt_Name").ToString()
                        details.Add(config)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "FetchAllDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function AddNewStation(ByVal objConfigStatBO As ConfigPlanningBO) As String()
            Dim strResult As String = ""
            Dim strResVal(1) As String
            'Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Dim dsStationDepMap As New DataSet
            Dim dsStationsList As New DataSet
            Dim expression As String
            Try
                dsStationsList = HttpContext.Current.Session("AllStations")
                dsStationDepMap = HttpContext.Current.Session("StationDepMapList")
                dsStationsList.Tables(0).DefaultView.RowFilter = "NAME_STATION=" + "'" + objConfigStatBO.Station_Name + "'"
                For i = 0 To dsStationsList.Tables(0).DefaultView.Count - 1
                    Dim stationid As String
                    stationid = dsStationsList.Tables(0).DefaultView.Item(i).Item("ID_STATION").ToString()
                    expression = "ID_DEPT= " + "'" + objConfigStatBO.Id_Dept + "'" + " AND " + "ID_STATION= " + "'" + stationid + "'"
                    If (dsStationDepMap.Tables(0).Select(expression).Length <> 0) Then
                        strResVal(0) = "NSAVED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("AEXISTS", "'" + objConfigStatBO.Station_Name + "'")
                    End If
                Next i

                If (strResVal(0) = "") Then

                    strResult = objConfigPlanningDO.Add_NewStation(objConfigStatBO)

                    If strResult = "0" Then
                        strResVal(0) = "SAVED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + objConfigStatBO.Station_Name + "'")
                    Else
                        strResVal(0) = "NSAVED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("AEXISTS", "'" + objConfigStatBO.Station_Name + "'")
                    End If
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "SaveMechCompetency", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function UpdateNewStation(ByVal objConfigStatBO As ConfigPlanningBO) As String()
            Dim strResult As String = ""
            Dim strResVal(1) As String
            'Dim strError As String
            Dim strSaved As String = ""
            Dim strCannotSaved As String = ""
            Dim dsStationDepMap As New DataSet
            Dim dsStationsList As New DataSet
            Dim expression As String
            Try

                dsStationsList = HttpContext.Current.Session("AllStations")
                dsStationDepMap = HttpContext.Current.Session("StationDepMapList")
                dsStationsList.Tables(0).DefaultView.RowFilter = "NAME_STATION=" + "'" + objConfigStatBO.Station_Name + "'"
                For i = 0 To dsStationsList.Tables(0).DefaultView.Count - 1
                    Dim stationid As String
                    stationid = dsStationsList.Tables(0).DefaultView.Item(i).Item("ID_STATION").ToString()
                    'expression = "ID_STATION= " + "'" + objConfigStatBO.Id_Station + "'" + " AND " + "NAME_STATION= " + "'" + objConfigStatBO.Station_Name + "'" + " AND " + _
                    '          "ID_STYPE= " + "'" + objConfigStatBO.Id_StationType + "'" + " AND " + "TYPE_STATION= " + "'" + objConfigStatBO.StationType + "'"

                    expression = "NAME_STATION= " + "'" + objConfigStatBO.Station_Name.Trim + "'"

                    If (dsStationsList.Tables(0).Select(expression).Length <> 0) Then
                        strResVal(0) = "NSAVED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("USEUPDT", "'" + objConfigStatBO.Station_Name + "'")
                    End If
                Next i

                If (strResVal(0) = "") Then
                    strResult = objConfigPlanningDO.Update_NewStation(objConfigStatBO)

                    If strResult = "0" Then
                        strResVal(0) = "UPDATED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("ADD", "'" + objConfigStatBO.Station_Name + "'")
                    Else
                        strResVal(0) = "NSAVED"
                        strResVal(1) = objErrHandle.GetErrorDescParameter("USEUPDT", "'" + objConfigStatBO.Station_Name + "'")
                    End If
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "UpdateNewStation", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function
        Public Function GetStationDetails(ByVal idStation As String) As Collection
            Dim detailsColl As New Collection
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("AllStations")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "Id_Station = '" + idStation + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim configStationsDet As New ConfigPlanningBO()
                            configStationsDet.Id_Station = dtrow("Id_Station").ToString()
                            configStationsDet.Station_Name = dtrow("Name_Station").ToString()
                            configStationsDet.Id_StationType = dtrow("Id_SType").ToString()
                            configStationsDet.StationType = dtrow("Type_Station").ToString()
                            detailsColl.Add(configStationsDet)
                        Next
                    Else
                        dt = ds.Tables(0)
                        Dim details As New List(Of ConfigPlanningBO)()
                        detailsColl.Add(details)
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "GetStationDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return detailsColl
        End Function
        Public Function DeleteStationDetails(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigPlanningDO.Delete_Station(xmlDoc)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DEL", "'" + strRecordsDeleted + "'")
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDN", "'" + strRecordsNotDeleted + "'")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigPlanning", "DeleteStationDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function


    End Class
End Namespace

