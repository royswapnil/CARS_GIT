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
Imports System.Web
Namespace CARS.ConfigWorkOrder
    Public Class ConfigWorkOrderDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function GetConfigWorkOrder(ByVal userId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("usp_WO_CONFIG_DET")
                    objDB.AddInParameter(objcmd, "@IV_USERID", DbType.String, userId)
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
        Public Function GetConfigDiscCode(ByVal deptId As String, ByVal subId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DISCOUNT_CODE_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_DEPT", DbType.String, deptId)
                    objDB.AddInParameter(objcmd, "@ID_SUB", DbType.String, subId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchConfigWorkOderDetails(ByVal deptId As String, ByVal subId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_WORK_ORDER_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_DEPT", DbType.String, deptId)
                    objDB.AddInParameter(objcmd, "@ID_SUB", DbType.String, subId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveProdDiscGrp(ByVal xmlDoc As String) As String
            Dim strStatus As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DISCOUNT_CODE_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, "20")
                    objDB.AddOutParameter(objcmd, "@OV_Result", DbType.String, "200")
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_Result")), "", objDB.GetParameterValue(objcmd, "@OV_Result"))))

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function UpdateProdDiscGrp(ByVal xmlDoc As String) As String
            Dim strStatus As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_DISCOUNT_CODE_UPDATE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, "20")
                    objDB.AddOutParameter(objcmd, "@OV_RCOUNT", DbType.String, "200")
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_RCOUNT")), "", objDB.GetParameterValue(objcmd, "@OV_RCOUNT"))))

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function SaveVATCode(ByVal xmlDoc As String) As String
            Dim strStatus As String = ""
            Dim insCount As Integer
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VAT_INSERT")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, xmlDoc)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, "20")
                    insCount = objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + insCount.ToString())

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function UpdateVATCode(ByVal xmlDoc As String) As String
            Dim strStatus As String = ""
            Dim insCount As Integer
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VAT_UPDATE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, xmlDoc)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, "20")
                    insCount = objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + insCount.ToString())

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function DeleteVATCode(ByVal strXML As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_VAT_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_Rcount", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_RDcount", DbType.String, 2000)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_Rcount")), "", objDB.GetParameterValue(objcmd, "@ov_Rcount"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@ov_RDcount")), "", objDB.GetParameterValue(objcmd, "@ov_RDcount"))))
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveWorkOrderConfig(ByVal objConfigWO As ConfigWorkOrderBO) As String
            Dim strStatus As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_WO_ORDER_INSERT")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUB", DbType.Int32, objConfigWO.Id_Subsidery)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT", DbType.Int32, objConfigWO.Id_Dept)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_PREFIX", DbType.String, objConfigWO.WOPr)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_SERIES", DbType.String, objConfigWO.Ord_Num)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_VAT_CALCRISK", DbType.Boolean, objConfigWO.Own_Risk)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_GAR_MATPRICE_PER", DbType.Decimal, objConfigWO.WO_GMPrice_Perc)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_CHAREGE_BASE", DbType.String, objConfigWO.WO_Charege_Base)
                    objDB.AddInParameter(objcmd, "@IV_ID_WO_DISCOUNT_BASE", DbType.String, "")
                    objDB.AddInParameter(objcmd, "@IV_ID_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@USE_DELIVERY_ADDRESS", DbType.Boolean, objConfigWO.Use_Delv_Address)
                    objDB.AddInParameter(objcmd, "@USE_MANUAL_RWRK", DbType.Boolean, objConfigWO.Use_Manual_Rwrk)
                    objDB.AddInParameter(objcmd, "@USE_VEHICLE", DbType.Boolean, objConfigWO.Use_Vehicle_Sp)
                    objDB.AddInParameter(objcmd, "@USE_PC_JOB", DbType.Boolean, objConfigWO.Use_Pc_Job)
                    objDB.AddInParameter(objcmd, "@WO_DEF_STAT", DbType.String, objConfigWO.WO_Status)
                    objDB.AddInParameter(objcmd, "@USE_DEF_CUST", DbType.Boolean, objConfigWO.Use_Default_Cust)
                    objDB.AddInParameter(objcmd, "@ID_CUSTOMER", DbType.String, objConfigWO.IdCustomer)
                    objDB.AddInParameter(objcmd, "@USE_CNFRM_DIA", DbType.Boolean, objConfigWO.Use_Cnfrm_Dialogue)
                    objDB.AddInParameter(objcmd, "@USE_SAVE_JOB_GRID", DbType.Boolean, objConfigWO.Use_SaveJob_Grid)
                    objDB.AddInParameter(objcmd, "@USE_VA_ACC_CODE", DbType.Boolean, objConfigWO.Use_VA_ACC_Code)
                    objDB.AddInParameter(objcmd, "@VA_ACC_CODE", DbType.String, objConfigWO.VA_ACC_Code)
                    objDB.AddInParameter(objcmd, "@USE_ALL_SPARE_SEARCH", DbType.Boolean, objConfigWO.Use_All_Spare_Search)
                    objDB.AddInParameter(objcmd, "@DISP_RINV_PINV", DbType.Boolean, objConfigWO.Disp_Rinv_Pinv)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@ov_RetValue"))

                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function

        Public Function SaveWOCopy(ByVal subId As String, ByVal deptId As String, ByVal copySubId As String, ByVal copyDeptId As String) As String
            Dim strStatus As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_WORK_ORDER_COPY")
                    objDB.AddInParameter(objcmd, "@ID_SUB", DbType.Int32, subId)
                    objDB.AddInParameter(objcmd, "@ID_DEP", DbType.Int32, deptId)
                    objDB.AddInParameter(objcmd, "@ID_CSUB", DbType.Int32, copySubId)
                    objDB.AddInParameter(objcmd, "@ID_CDEP", DbType.Int32, copyDeptId)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    strStatus = objDB.ExecuteNonQuery(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function

    End Class
End Namespace
