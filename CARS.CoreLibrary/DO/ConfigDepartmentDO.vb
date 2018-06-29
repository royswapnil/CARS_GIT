Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Security.Cryptography
Imports System.IO
Imports CARS.CoreLibrary
Namespace CARS.Department
    Public Class ConfigDepartmentDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchAllDepartments(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FetchDepartment")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, objConfigDeptBO.LoginId)
                    objDB.AddInParameter(objcmd, "@IV_LANG", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Role1(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USER_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_Login", DbType.String, objConfigDeptBO.LoginId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_Department(ByVal objConfigDeptBO As ConfigDepartmentBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_DEPT_INSERT")
                    objDB.AddInParameter(objcmd, "@Ii_ID_Dept", DbType.Int32, objConfigDeptBO.DeptId)
                    objDB.AddInParameter(objcmd, "@Ii_ID_SUBSIDERY_DEPT", DbType.Int32, objConfigDeptBO.SubsideryId)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Name", DbType.String, objConfigDeptBO.DeptName)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Mgr_Name", DbType.String, objConfigDeptBO.DeptManager)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Location", DbType.String, objConfigDeptBO.Location)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Phone", DbType.String, objConfigDeptBO.Phone)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Phone_Mobile", DbType.String, objConfigDeptBO.Mobile)
                    objDB.AddInParameter(objcmd, "@IV_FLG_DPT_WareHouse", DbType.Boolean, objConfigDeptBO.FlgWareHouse)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objConfigDeptBO.CreatedBy)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 20)
                    objDB.AddInParameter(objcmd, "@iv_DPT_Address1", DbType.String, objConfigDeptBO.Address1)
                    objDB.AddInParameter(objcmd, "@iv_DPT_Address2", DbType.String, objConfigDeptBO.Address2)
                    objDB.AddInParameter(objcmd, "@iv_DPT_ID_Zipcode", DbType.String, objConfigDeptBO.ZipCode)
                    objDB.AddInParameter(objcmd, "@iv_DPT_ACCOUNTCODE", DbType.String, objConfigDeptBO.DeptAccountCode)
                    objDB.AddInParameter(objcmd, "@IV_DISCOUNT_CODE", DbType.String, objConfigDeptBO.DiscountCode)
                    objDB.AddInParameter(objcmd, "@IV_MAKE_CODE", DbType.String, objConfigDeptBO.IdMake)
                    objDB.AddInParameter(objcmd, "@IV_ITEM_CATEG", DbType.String, objConfigDeptBO.ItemCatg)
                    objDB.AddInParameter(objcmd, "@IV_RP_ID_MAKE", DbType.String, objConfigDeptBO.RPIdMake)
                    objDB.AddInParameter(objcmd, "@IV_RP_ID_ITEM_CATG", DbType.String, objConfigDeptBO.RPIdItemCatg)
                    objDB.AddInParameter(objcmd, "@IV_FlgAccVal", DbType.Boolean, objConfigDeptBO.FlgAccValReq)
                    objDB.AddInParameter(objcmd, "@IV_FlgExportSupplier", DbType.Boolean, objConfigDeptBO.FlgExportSupplier)
                    objDB.AddInParameter(objcmd, "@IV_OWNRISK_ACCTCODE", DbType.String, objConfigDeptBO.OwnRiskAcctCode)
                    objDB.AddInParameter(objcmd, "@IV_FLG_WITHDRAW_LUNCH", DbType.Boolean, objConfigDeptBO.FlgLunchWithdraw)
                    objDB.AddInParameter(objcmd, "@IV_FROMTIME", DbType.String, objConfigDeptBO.FromTime)
                    objDB.AddInParameter(objcmd, "@IV_TOTIME", DbType.String, objConfigDeptBO.ToTime)
                    objDB.AddInParameter(objcmd, "@IV_USE_INT_CUST_RULE", DbType.Boolean, objConfigDeptBO.FlgIntCustExp)
                    objDB.AddInParameter(objcmd, "@Temp_Code", DbType.String, objConfigDeptBO.TempCode)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Department(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_Fetch_Department")
                    objDB.AddInParameter(objcmd, "@ID_Department", DbType.Int32, Convert.ToInt32(objConfigDeptBO.DeptId))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetCategory(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Dim dsCategory As New DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_BO_CATEGORY_FETCH")

                    If objConfigDeptBO.MakeFrom <> String.Empty Or objConfigDeptBO.MakeTo <> String.Empty Then
                        If objConfigDeptBO.MakeFrom <> "" Then
                            objDB.AddInParameter(objcmd, "@MakeFrom", DbType.String, objConfigDeptBO.MakeFrom)
                        Else
                            objDB.AddInParameter(objcmd, "@MakeFrom", DbType.String, DBNull.Value)
                        End If
                        If objConfigDeptBO.MakeTo <> "" Then
                            objDB.AddInParameter(objcmd, "@MakeTo", DbType.String, objConfigDeptBO.MakeTo)
                        Else
                            objDB.AddInParameter(objcmd, "@MakeTo", DbType.String, DBNull.Value)
                        End If
                        If objConfigDeptBO.Filter <> "" Then
                            objDB.AddInParameter(objcmd, "@Filter", DbType.String, objConfigDeptBO.Filter)
                        Else
                            objDB.AddInParameter(objcmd, "@Filter", DbType.String, objConfigDeptBO.Filter)
                        End If
                        dsCategory = objDB.ExecuteDataSet(objcmd)

                    Else
                        If objConfigDeptBO.Filter <> "" Then

                            If objConfigDeptBO.MakeFrom <> "" Then
                                objDB.AddInParameter(objcmd, "@MakeFrom", DbType.String, objConfigDeptBO.MakeFrom)
                            Else
                                objDB.AddInParameter(objcmd, "@MakeFrom", DbType.String, DBNull.Value)
                            End If
                            If objConfigDeptBO.MakeTo <> "" Then
                                objDB.AddInParameter(objcmd, "@MakeTo", DbType.String, objConfigDeptBO.MakeTo)
                            Else
                                objDB.AddInParameter(objcmd, "@MakeTo", DbType.String, DBNull.Value)
                            End If
                            If objConfigDeptBO.Filter <> "" Then
                                objDB.AddInParameter(objcmd, "@Filter", DbType.String, objConfigDeptBO.Filter)
                            Else
                                objDB.AddInParameter(objcmd, "@Filter", DbType.String, objConfigDeptBO.Filter)
                            End If
                            dsCategory = objDB.ExecuteDataSet(objcmd)

                        Else
                            dsCategory = objDB.ExecuteDataSet(objcmd)
                        End If

                    End If
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return dsCategory
        End Function
        Public Function Fetch_Vehicle_Config(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_VEHICLE_CONFIG")
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG", DbType.String, objConfigDeptBO.IdConfig)
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG2", DbType.String, objConfigDeptBO.IdConfig2)
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG3", DbType.String, objConfigDeptBO.IdConfig3)
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG4", DbType.String, objConfigDeptBO.IdConfig4)
                    objDB.AddInParameter(objcmd, "@iv_ID_CONFIG5", DbType.String, objConfigDeptBO.IdConfig5)

                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_TemplateCodes() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICE_MESSAGETEMPLATE")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetDisListData() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DIS_LIST")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetSubsidiares(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_SUBSIDERY_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, objConfigDeptBO.LoginId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Department(ByVal objConfigDeptBO As ConfigDepartmentBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_DEPT_Update")
                    objDB.AddInParameter(objcmd, "@Ii_ID_Dept", DbType.Int32, objConfigDeptBO.DeptId)
                    objDB.AddInParameter(objcmd, "@Ii_ID_SUBSIDERY_DEPT", DbType.Int32, objConfigDeptBO.SubsideryId)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Name", DbType.String, objConfigDeptBO.DeptName)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Mgr_Name", DbType.String, objConfigDeptBO.DeptManager)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Location", DbType.String, objConfigDeptBO.Location)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Phone", DbType.String, objConfigDeptBO.Phone)
                    objDB.AddInParameter(objcmd, "@IV_DPT_Phone_Mobile", DbType.String, objConfigDeptBO.Mobile)
                    objDB.AddInParameter(objcmd, "@IV_FLG_DPT_WareHouse", DbType.Boolean, objConfigDeptBO.FlgWareHouse)
                    objDB.AddInParameter(objcmd, "@IV_MODIFIED_BY", DbType.String, objConfigDeptBO.ModifiedBy)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 20)
                    objDB.AddInParameter(objcmd, "@iv_DPT_Address1", DbType.String, objConfigDeptBO.Address1)
                    objDB.AddInParameter(objcmd, "@iv_DPT_Address2", DbType.String, objConfigDeptBO.Address2)
                    objDB.AddInParameter(objcmd, "@iv_DPT_ID_Zipcode", DbType.String, objConfigDeptBO.ZipCode)
                    objDB.AddInParameter(objcmd, "@IV_DEPTACCCODE   ", DbType.String, objConfigDeptBO.DeptAccountCode)
                    objDB.AddInParameter(objcmd, "@IV_DISCOUNT_CODE", DbType.String, objConfigDeptBO.DiscountCode)
                    objDB.AddInParameter(objcmd, "@IV_MAKE_CODE", DbType.String, objConfigDeptBO.IdMake)
                    objDB.AddInParameter(objcmd, "@IV_ITEM_CATEG", DbType.String, objConfigDeptBO.IdItemCatg)
                    objDB.AddInParameter(objcmd, "@IV_RP_ID_MAKE", DbType.String, objConfigDeptBO.RPIdMake)
                    objDB.AddInParameter(objcmd, "@IV_RP_ID_ITEM_CATG", DbType.String, objConfigDeptBO.RPIdItemCatg)
                    objDB.AddInParameter(objcmd, "@IV_FlgAccVal", DbType.Boolean, objConfigDeptBO.FlgAccValReq)
                    objDB.AddInParameter(objcmd, "@IV_FlgExportSupplier", DbType.Boolean, objConfigDeptBO.FlgExportSupplier)
                    objDB.AddInParameter(objcmd, "@IV_OWNRISK_ACCTCODE", DbType.String, objConfigDeptBO.OwnRiskAcctCode)
                    objDB.AddInParameter(objcmd, "@IV_FLG_WITHDRAW_LUNCH", DbType.Boolean, objConfigDeptBO.FlgLunchWithdraw)
                    objDB.AddInParameter(objcmd, "@IV_FROMTIME", DbType.String, objConfigDeptBO.FromTime)
                    objDB.AddInParameter(objcmd, "@IV_TOTIME", DbType.String, objConfigDeptBO.ToTime)
                    objDB.AddInParameter(objcmd, "@IV_USE_INT_CUST_RULE", DbType.Boolean, objConfigDeptBO.FlgIntCustExp)
                    objDB.AddInParameter(objcmd, "@Temp_Code", DbType.String, objConfigDeptBO.TempCode)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Delete_Department(ByVal objConfigDeptBO As ConfigDepartmentBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DEPARTMENT_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_DeptId", DbType.String, objConfigDeptBO.DeptId)
                    objDB.AddOutParameter(objcmd, "@OV_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@OV_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@OV_DeletedCfg", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_DeletedCfg").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_CntDelete").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetDepartments(ByVal objConfigUser As ConfigDepartmentBO) As DataSet
            Dim dsSubs As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_GET_DEPT_FETCH")
                objDB.AddInParameter(objCMD, "@ID_USER", DbType.String, objConfigUser.LoginId)
                objDB.AddInParameter(objCMD, "@ID_SUB", DbType.String, objConfigUser.SubsideryId)
                Try
                    dsSubs = objDB.ExecuteDataSet(objCMD)
                Catch generatedExceptionName As Exception
                    Throw
                End Try
            End Using
            Return dsSubs
        End Function
        Public Function Fetch_DeptScanDataSettings(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_DEPTSETTINGS")
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT", DbType.String, objConfigDeptBO.DeptId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Save_DeptScanDataSettings(ByVal objConfigDeptBO As ConfigDepartmentBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SAVESCANSETTINGS")
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT", DbType.String, objConfigDeptBO.DeptId)
                    objDB.AddInParameter(objcmd, "@IV_USERID", DbType.String, objConfigDeptBO.CreatedBy)
                    objDB.AddInParameter(objcmd, "@USE_SCANNERINTERFACE", DbType.Boolean, objConfigDeptBO.Dpt_ScanFlg)
                    objDB.AddInParameter(objcmd, "@USE_SCHEDULEIMPORT", DbType.Boolean, objConfigDeptBO.Dpt_Sch_ImportFlag)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 10)

                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Dept_sales(ByVal objConfigDeptBO As ConfigDepartmentBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_DEPARTMENTS")
                    objDB.AddInParameter(objcmd, "@ID_USER", DbType.String, objConfigDeptBO.LoginId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class
End Namespace
