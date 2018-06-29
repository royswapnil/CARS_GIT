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
Namespace CARS.Services.ConfigDeptWarehouse
    Public Class ConfigDeptWarehouse
        Shared objConfigDeptWhBO As New ConfigDeptWarehouseBO
        Shared objConfigDeptWhDO As New CARS.ConfigDeptWarehouseDO.ConfigDeptWarehouseDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function GetDeptWarehouse(ByVal login As String) As List(Of ConfigDeptWarehouseBO)
            Dim details As New List(Of ConfigDeptWarehouseBO)()
            Dim dsWhDetails As New DataSet
            Dim dtwhDetails As New DataTable
            Try
                dsWhDetails = objConfigDeptWhDO.GetDeptWarehouse(login)
                HttpContext.Current.Session("ConfigDeptWhDetails") = dsWhDetails
                HttpContext.Current.Session("subsideryId") = dsWhDetails.Tables(1).Rows(0)("ID_SUBSID").ToString
                If dsWhDetails.Tables.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(2)
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigDeptWarehouseBO()
                        whDet.WareHouseId = dtrow("ID_WH").ToString
                        whDet.WareHouseValue = dtrow("WH_NAME").ToString
                        details.Add(whDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDeptWarehouse", "GetDeptWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadDepartment() As List(Of ConfigDeptWarehouseBO)
            Dim dsFetchSubs As DataSet
            Dim dtFetchSubs As DataTable
            Dim details As New List(Of ConfigDeptWarehouseBO)()
            Dim dvSubs As DataView
            Try
                dsFetchSubs = HttpContext.Current.Session("ConfigDeptWhDetails")
                dvSubs = dsFetchSubs.Tables(1).DefaultView
                dtFetchSubs = dvSubs.ToTable
                For Each dtrow As DataRow In dtFetchSubs.Rows
                    Dim deptSubs As New ConfigDeptWarehouseBO()
                    deptSubs.DepartmentId = dtrow("DEPTCODE").ToString()
                    deptSubs.DepartmentName = dtrow("DEPTNAME").ToString()
                    details.Add(deptSubs)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDeptWarehouse", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadDeptWarehouseDet(ByVal login As String) As List(Of ConfigDeptWarehouseBO)
            Dim dsWhDetails As DataSet
            Dim dtwhDetails As DataTable
            Dim details As New List(Of ConfigDeptWarehouseBO)()
            Dim dvSubs As DataView
            Try
                dsWhDetails = objConfigDeptWhDO.GetDeptWarehouse(Login)
                HttpContext.Current.Session("ConfigDeptWhDetails") = dsWhDetails
                If dsWhDetails.Tables.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(0)
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigDeptWarehouseBO()
                        whDet.DepartmentId = dtrow("DEPTCODE").ToString
                        whDet.DepartmentName = dtrow("DEPTNAME").ToString
                        whDet.ConnWarehouses = dtrow("CONNWAREHOUSE").ToString
                        details.Add(whDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDeptWarehouse", "LoadDeptWarehouseDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetEditConnDeptWh(ByVal deptId As String) As Collection
            Dim details As New List(Of ConfigDeptWarehouseBO)()
            Dim dsWhDetails As New DataSet
            Dim dtwhDetails As New DataTable
            Dim dvwhDetails As New DataView
            Dim dt As New Collection

            Try
                dsWhDetails = HttpContext.Current.Session("ConfigDeptWhDetails")
                If dsWhDetails.Tables.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(3)
                    dvwhDetails = dtwhDetails.DefaultView
                    dvwhDetails.RowFilter = "ID_DEPT = '" + deptId.Trim + "' and Defaultwh = True"
                    dtwhDetails = dvwhDetails.ToTable
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigDeptWarehouseBO()
                        whDet.WareHouseId = dtrow("ID_WH").ToString
                        whDet.WareHouseValue = dtrow("WH_NAME").ToString
                        whDet.IsDefault = dtrow("DEFAULTWH").ToString
                        whDet.DepartmentId = dtrow("ID_DEPT").ToString
                        details.Add(whDet)
                    Next
                    dt.Add(details)
                End If
                If dsWhDetails.Tables(3).Rows.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(3)
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigDeptWarehouseBO()
                        whDet.WareHouseId = dtrow("ID_WH").ToString
                        whDet.WareHouseValue = dtrow("WH_NAME").ToString
                        details.Add(whDet)
                    Next
                    dt.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "GetWarehouseDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dt
        End Function
        Public Function SaveDeptWarehouse(ByVal objDeptConfigWHBO As ConfigDeptWarehouseBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            Dim strArray As Array
            Try
                If mode = "Edit" Then
                    strResult = objConfigDeptWhDO.SaveDeptWarehouse(objDeptConfigWHBO)
                End If
                strArray = strResult.Split(";")
                If strArray(0) = "True" Then
                    strRes = objErrHandle.GetErrorDescParameter("WSAVED")
                    'ElseIf strArray(0) = "False" Then
                    '    strRes = objErrHandle.GetErrorDescParameter("DDN")
                End If
                Return strRes
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "SaveWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
    End Class
End Namespace