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
Namespace CARS.Services.ConfigWarehouse
    Public Class ConfigWarehouse
        Shared objConfigWHBO As New ConfigWarehouseBO
        Shared objConfigWHDO As New CARS.ConfigWarehouse.ConfigWarehouseDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objConfigDeptDO As New CARS.Department.ConfigDepartmentDO
        Public Function GetWarehouseDetails(ByVal login As String) As List(Of ConfigWarehouseBO)
            Dim details As New List(Of ConfigWarehouseBO)()
            Dim dsWhDetails As New DataSet
            Dim dtwhDetails As New DataTable
            Try
                dsWhDetails = objConfigWHDO.GetWarehouseDetails(login)
                HttpContext.Current.Session("WhConfigDetails") = dsWhDetails
                If dsWhDetails.Tables.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(0)
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigWarehouseBO()
                        whDet.WarehouseID = dtrow("ID_WH").ToString
                        whDet.WarehouseName = dtrow("WH_NAME").ToString
                        whDet.WarehouseManagerName = dtrow("WH_MGR_NAME").ToString
                        whDet.WarehouseLocation = dtrow("WH_LOCATION").ToString
                        whDet.WareHouseSubsideryName = dtrow("SS_NAME").ToString
                        details.Add(whDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "GetWarehouseDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetEditWarehouse(ByVal whId As String) As List(Of ConfigWarehouseBO)
            Dim details As New List(Of ConfigWarehouseBO)()
            Dim dsWhDetails As New DataSet
            Dim dtwhDetails As New DataTable
            Dim dvwhDetails As New DataView

            Try
                dsWhDetails = HttpContext.Current.Session("WhConfigDetails")
                If dsWhDetails.Tables.Count > 0 Then
                    dtwhDetails = dsWhDetails.Tables(0)
                    dvwhDetails = dtwhDetails.DefaultView
                    dvwhDetails.RowFilter = "ID_WH = '" + whId.Trim + "'"
                    dtwhDetails = dvwhDetails.ToTable
                    For Each dtrow As DataRow In dtwhDetails.Rows
                        Dim whDet As New ConfigWarehouseBO()
                        whDet.WarehouseID = dtrow("ID_WH").ToString
                        whDet.WarehouseName = dtrow("WH_NAME").ToString
                        whDet.WarehouseManagerName = dtrow("WH_MGR_NAME").ToString
                        whDet.WarehouseLocation = dtrow("WH_LOCATION").ToString
                        whDet.WareHouseSubsideryName = dtrow("SS_NAME").ToString
                        whDet.WarehousePhone = dtrow("WH_PHONE").ToString
                        whDet.WarehousePhoneMobile = dtrow("WH_PHONE_MOBILE").ToString
                        whDet.WarehouseAddress1 = dtrow("WH_ADDRESS1").ToString
                        whDet.WarehouseAddress2 = dtrow("WH_ADDRESS2").ToString
                        whDet.WarehouseZipcode = dtrow("WH_ID_ZIPCODE").ToString
                        'whDet.WarehouseCity = dtrow("WH_ID_ZIPCODE").ToString
                        'whDet.WarehouseCountry = dtrow("WH_ID_ZIPCODE").ToString
                        'whDet.WarehouseState = dtrow("WH_ID_ZIPCODE").ToString
                        details.Add(whDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "GetWarehouseDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadSubsidiaries(objConfigDeptBO) As List(Of ConfigWarehouseBO)
            Dim dsFetchSubs As DataSet
            Dim dtFetchSubs As DataTable
            Dim details As New List(Of ConfigWarehouseBO)()
            Dim dvSubs As DataView
            Try
                dsFetchSubs = objConfigDeptDO.GetSubsidiares(objConfigDeptBO)
                'dtFetchSubs = dsFetchSubs.Tables(0)
                dvSubs = dsFetchSubs.Tables(0).DefaultView
                dvSubs.Sort = "SS_NAME"
                dtFetchSubs = dvSubs.ToTable
                For Each dtrow As DataRow In dtFetchSubs.Rows
                    Dim deptSubs As New ConfigWarehouseBO()
                    deptSubs.WarehouseIDSubsidery = dtrow("ID_SUBSIDERY").ToString()
                    deptSubs.WareHouseSubsideryName = dtrow("SS_NAME").ToString()
                    details.Add(deptSubs)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "LoadSubsidiaries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveWarehouse(ByVal objConfigWHBO As ConfigWarehouseBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If mode = "Edit" Then
                    strResult = objConfigWHDO.UpdateWarehouse(objConfigWHBO)
                Else
                    strResult = objConfigWHDO.InsertWarehouse(objConfigWHBO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigWarehouse", "SaveWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteWarehouse(ByVal whId As String) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            Dim strArray As Array
            strResult = objConfigWHDO.DeleteWarehouse(whId)
            strArray = strResult.Split(";")
            If strArray(0) = "True" Then
                strRes = objErrHandle.GetErrorDescParameter("DDEL")
            ElseIf strArray(0) = "False" Then
                strRes = objErrHandle.GetErrorDescParameter("DDN")
            End If
            Return strRes
        End Function
    End Class
End Namespace