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
Namespace CARS.Services.ConfigDepartment
    Public Class Department
        Shared objConfigDeptBO As New ConfigDepartmentBO
        Shared objConfigDeptDO As New CARS.Department.ConfigDepartmentDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function FetchDepartment(ByVal deptID As String) As List(Of ConfigDepartmentBO)
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dsDeptDetails As New DataSet
            Dim dtDeptDetails As New DataTable
            Try
                objConfigDeptBO.DeptId = deptID
                dsDeptDetails = objConfigDeptDO.Fetch_Department(objConfigDeptBO)
                dtDeptDetails = dsDeptDetails.Tables(0)

                For Each dtrow As DataRow In dtDeptDetails.Rows
                    Dim deptDet As New ConfigDepartmentBO()
                    deptDet.DeptId = dtrow("ID_Dept").ToString()
                    deptDet.DeptName = IIf(IsDBNull(dtrow("DPT_Name").ToString()) = True, "", dtrow("DPT_Name").ToString())
                    deptDet.DeptManager = IIf(IsDBNull(dtrow("Dpt_Mgr_Name").ToString()) = True, "", dtrow("Dpt_Mgr_Name").ToString())
                    deptDet.Address1 = IIf(IsDBNull(dtrow("Dpt_Address1").ToString()) = True, "", dtrow("Dpt_Address1").ToString())
                    deptDet.Address2 = IIf(IsDBNull(dtrow("Dpt_Address2").ToString()) = True, "", dtrow("Dpt_Address2").ToString())
                    deptDet.Phone = IIf(IsDBNull(dtrow("Dpt_Phone").ToString()) = True, "", dtrow("Dpt_Phone").ToString())
                    deptDet.Mobile = IIf(IsDBNull(dtrow("Dpt_Phone_Mobile").ToString()) = True, "", dtrow("Dpt_Phone_Mobile").ToString())
                    deptDet.Location = IIf(IsDBNull(dtrow("Dpt_Location").ToString()) = True, "", dtrow("Dpt_Location").ToString())
                    deptDet.FlgWareHouse = IIf(IsDBNull(dtrow("FLG_DPT_WAREHOUSE").ToString()) = True, "", dtrow("FLG_DPT_WAREHOUSE").ToString())
                    deptDet.ZipCode = IIf(IsDBNull(dtrow("ID_ZIPCODE").ToString()) = True, "", dtrow("ID_ZIPCODE").ToString())
                    deptDet.DeptAccountCode = IIf(IsDBNull(dtrow("DPT_ACCCODE").ToString()) = True, "", dtrow("DPT_ACCCODE").ToString())
                    deptDet.DiscountCode = IIf(IsDBNull(dtrow("DEPTDISCODE").ToString()) = True, "", dtrow("DEPTDISCODE").ToString())
                    deptDet.IdMake = IIf(IsDBNull(dtrow("ID_MAKE").ToString()) = True, "", dtrow("ID_MAKE").ToString())
                    deptDet.SubsideryId = dtrow("ID_SUBSIDERY_DEPT").ToString()
                    deptDet.FlgAccValReq = IIf(IsDBNull(dtrow("Flg_Validation_Req").ToString()) = True, "", dtrow("Flg_Validation_Req").ToString())
                    deptDet.FlgExportSupplier = IIf(IsDBNull(dtrow("FLG_EXPORT_SUPPLIER").ToString()) = True, "", dtrow("FLG_EXPORT_SUPPLIER").ToString())
                    deptDet.OwnRiskAcctCode = IIf(IsDBNull(dtrow("OWNRISK_ACCTCODE").ToString()) = True, "", dtrow("OWNRISK_ACCTCODE").ToString())
                    deptDet.FlgLunchWithdraw = IIf(IsDBNull(dtrow("LUNCH_WITHDRAW").ToString()) = True, "", dtrow("LUNCH_WITHDRAW").ToString())
                    deptDet.FromTime = IIf(IsDBNull(dtrow("FROM_TIME").ToString()) = True, "", dtrow("FROM_TIME").ToString())
                    deptDet.ToTime = IIf(IsDBNull(dtrow("TO_TIME").ToString()) = True, "", dtrow("TO_TIME").ToString())
                    If dtrow("FLG_INTCUST_EXP").ToString() = "" Then
                        deptDet.FlgIntCustExp = "False"
                    Else
                        deptDet.FlgIntCustExp = dtrow("FLG_INTCUST_EXP").ToString()
                    End If
                    deptDet.CreatedBy = IIf(IsDBNull(dtrow("CREATED_BY").ToString()) = True, "", dtrow("CREATED_BY").ToString())
                    deptDet.ModifiedBy = IIf(IsDBNull(dtrow("MODIFIED_BY").ToString()) = True, "", dtrow("MODIFIED_BY").ToString())

                    If (IsDBNull(dtrow("DT_CREATED").ToString())) Then
                        deptDet.DateCreated = ""
                    Else
                        deptDet.DateCreated = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                    End If
                    If (IsDBNull(dtrow("DT_MODIFIED").ToString())) Then
                        deptDet.DateModified = ""
                    Else
                        deptDet.DateModified = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                    End If
                    deptDet.RPIdMake = IIf(IsDBNull(dtrow("RP_ID_MAKE").ToString()) = True, "", dtrow("RP_ID_MAKE").ToString())
                    deptDet.TempCode = IIf(IsDBNull(dtrow("ID_TEMPLATE").ToString()) = True, "", dtrow("ID_TEMPLATE").ToString())
                    deptDet.DeptAccountCode = IIf(IsDBNull(dtrow("DPT_ACCCODE").ToString()) = True, "", dtrow("DPT_ACCCODE").ToString())
                    deptDet.OwnRiskAcctCode = IIf(IsDBNull(dtrow("OWNRISK_ACCTCODE").ToString()) = True, "", dtrow("OWNRISK_ACCTCODE").ToString())
                    deptDet.FlgAccValReq = IIf(IsDBNull(dtrow("Flg_Validation_Req").ToString()) = True, "", dtrow("Flg_Validation_Req").ToString())
                    deptDet.FlgExportSupplier = IIf(IsDBNull(dtrow("FLG_EXPORT_SUPPLIER").ToString()) = True, "", dtrow("FLG_EXPORT_SUPPLIER").ToString())
                    deptDet.City = IIf(IsDBNull(dtrow("City").ToString()) = True, "", dtrow("City").ToString())
                    deptDet.Country = IIf(IsDBNull(dtrow("Country").ToString()) = True, "", dtrow("Country").ToString())
                    deptDet.State = IIf(IsDBNull(dtrow("State").ToString()) = True, "", dtrow("State").ToString())
                    deptDet.IdItemCatg = IIf(IsDBNull(dtrow("ID_ITEM_CATEG").ToString()) = True, "", dtrow("ID_ITEM_CATEG").ToString())
                    deptDet.RPIdItemCatg = IIf(IsDBNull(dtrow("RP_ID_ITEM_CATG").ToString()) = True, "", dtrow("RP_ID_ITEM_CATG").ToString())

                    details.Add(deptDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "FetchDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetSPRCategory(ByVal makeF As String, ByVal makeT As String, ByVal filter As String) As List(Of ConfigDepartmentBO)
            Dim dsFetchCatg As DataSet
            Dim dtFetchCatg As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dvCatg As DataView
            Try
                objConfigDeptBO.MakeFrom = makeF
                objConfigDeptBO.MakeTo = makeT
                objConfigDeptBO.Filter = filter
                dsFetchCatg = objConfigDeptDO.GetCategory(objConfigDeptBO)
                'dtFetchCatg = dsFetchCatg.Tables(0)
                dvCatg = dsFetchCatg.Tables(0).DefaultView
                dvCatg.Sort = "CATEGORY"
                dtFetchCatg = dvCatg.ToTable
                For Each dtrow As DataRow In dtFetchCatg.Rows
                    Dim deptCatgDet As New ConfigDepartmentBO()
                    deptCatgDet.ItemCatg = dtrow("CATEGORY").ToString()
                    deptCatgDet.IdItemCatg = dtrow("ID_ITEM_CATG").ToString()
                    details.Add(deptCatgDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "GetSPRCategory", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchVehicleConfig() As List(Of ConfigDepartmentBO)
            Dim dsFetchMake As DataSet
            Dim dtFetchMake As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dvMake As DataView
            Try
                dsFetchMake = objConfigDeptDO.Fetch_Vehicle_Config(objConfigDeptBO)
                'dtFetchMake = dsFetchMake.Tables(0)
                dvMake = dsFetchMake.Tables(0).DefaultView
                dvMake.Sort = "ID_MAKE_NAME"
                dtFetchMake = dvMake.ToTable
                For Each dtrow As DataRow In dtFetchMake.Rows
                    Dim deptMakeDet As New ConfigDepartmentBO()
                    deptMakeDet.IdMake = dtrow("ID_MAKE").ToString()
                    deptMakeDet.IdMakeName = dtrow("ID_MAKE_NAME").ToString()
                    details.Add(deptMakeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "FetchVehicleConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadTemplateCode() As List(Of ConfigDepartmentBO)
            Dim dsFetchTempCode As DataSet
            Dim dtFetchTempCode As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dvTcode As DataView
            Try
                dsFetchTempCode = objConfigDeptDO.Fetch_TemplateCodes()
                'dtFetchTempCode = dsFetchTempCode.Tables(0)
                dvTcode = dsFetchTempCode.Tables(0).DefaultView
                dvTcode.Sort = "TEMPLATE_CODE"
                dtFetchTempCode = dvTcode.ToTable
                For Each dtrow As DataRow In dtFetchTempCode.Rows
                    Dim deptTempCodeDet As New ConfigDepartmentBO()
                    deptTempCodeDet.IdTempCode = dtrow("ID_TEMPLATE").ToString()
                    deptTempCodeDet.TempCode = dtrow("TEMPLATE_CODE").ToString()
                    details.Add(deptTempCodeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "LoadTemplateCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetDisListData() As List(Of ConfigDepartmentBO)
            Dim dsFetchDiscCode As DataSet
            Dim dtFetchDiscCode As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Try
                dsFetchDiscCode = objConfigDeptDO.GetDisListData()
                dtFetchDiscCode = dsFetchDiscCode.Tables(1)
                For Each dtrow As DataRow In dtFetchDiscCode.Rows
                    Dim deptDiscCodeDet As New ConfigDepartmentBO()
                    deptDiscCodeDet.DiscountCode = dtrow("DESCRIPTION").ToString()
                    details.Add(deptDiscCodeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "GetDisListData", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function SaveDepartment(ByVal objConfigDeptBO As ConfigDepartmentBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If mode = "Edit" Then
                    strResult = objConfigDeptDO.Update_Department(objConfigDeptBO)
                Else
                    strResult = objConfigDeptDO.Add_Department(objConfigDeptBO)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "SaveDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function LoadSubsidiaries(objConfigDeptBO) As List(Of ConfigDepartmentBO)
            Dim dsFetchSubs As DataSet
            Dim dtFetchSubs As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dvSubs As DataView
            Try
                dsFetchSubs = objConfigDeptDO.GetSubsidiares(objConfigDeptBO)
                'dtFetchSubs = dsFetchSubs.Tables(0)
                dvSubs = dsFetchSubs.Tables(0).DefaultView
                dvSubs.Sort = "SS_NAME"
                dtFetchSubs = dvSubs.ToTable
                For Each dtrow As DataRow In dtFetchSubs.Rows
                    Dim deptSubs As New ConfigDepartmentBO()
                    deptSubs.SubsideryId = dtrow("ID_SUBSIDERY").ToString()
                    deptSubs.SubsidiaryName = dtrow("SS_NAME").ToString()
                    details.Add(deptSubs)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "LoadSubsidiaries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteDepartment(objConfigDeptBO) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigDeptDO.Delete_Department(objConfigDeptBO)
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
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "DeleteDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function Save_ImportScanDataSettings(ByVal objConfigDeptBO As ConfigDepartmentBO) As String()
            Dim strResult As String = ""
            Dim strResVal As Array
            Try
                strResult = objConfigDeptDO.Save_DeptScanDataSettings(objConfigDeptBO)
                strResVal = strResult.Split(",")
                If strResVal(0) = "INST" Then
                    strResVal(0) = "INSERTED"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("SETSAVE")
                ElseIf strResVal(0) = "ERROR" Then
                    strResVal(0) = "ERROR"
                    strResVal(1) = objErrHandle.GetErrorDescParameter("DUPSAVE")
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "Save_ImportScanDataSettings", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResVal
        End Function

        Public Function Fetch_DepartmentScanDataSettings(ByVal objConfigDeptBO As ConfigDepartmentBO) As List(Of ConfigDepartmentBO)
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dsDeptScanData As New DataSet
            Dim dtDeptScanData As New DataTable
            Try
                dsDeptScanData = objConfigDeptDO.Fetch_DeptScanDataSettings(objConfigDeptBO)
                If dsDeptScanData.Tables.Count > 0 Then
                    If dsDeptScanData.Tables(0).Rows.Count > 0 Then
                        dtDeptScanData = dsDeptScanData.Tables(0)
                        For Each dtrow As DataRow In dtDeptScanData.Rows
                            Dim dept As New ConfigDepartmentBO()
                            dept.Dpt_ScanFlg = dtrow("Dpt_ScanFlag").ToString
                            dept.Dpt_Sch_ImportFlag = dtrow("Dpt_Sch_ImportFlag")
                            details.Add(dept)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigDepartment", "Fetch_DepartmentScanDataSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function



    End Class
End Namespace
