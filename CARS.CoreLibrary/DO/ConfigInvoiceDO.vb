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
Namespace CARS.ConfigInvoice
    Public Class ConfigInvoiceDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim commonUtil As Utilities.CommonUtility
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_PayTypes(ByVal objConfigInvBO As ConfigInvoiceBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_Inv_SETTINGS_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_CONFIG", DbType.String, "PAYTYPE")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchInvNumberSeries(ByVal objConfigInvBO As ConfigInvoiceBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_INV_NUMSERIES_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUBSIDERY_INV", DbType.String, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT_INV", DbType.String, objConfigInvBO.IdDept)
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function LoadInvSettings(ByVal objConfigInvBO As ConfigInvoiceBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INV_CONFIG_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUBSIDERY_INV", DbType.String, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT_INV", DbType.String, objConfigInvBO.IdDept)
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function LoadInvSeries(ByVal objConfigInvBO As ConfigInvoiceBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_INV_NUMSERIES_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUBSIDERY_INV", DbType.String, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT_INV", DbType.String, objConfigInvBO.IdDept)
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function LoadPayType(ByVal objConfigInvBO As ConfigInvoiceBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_Inv_SETTINGS_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_CONFIG", DbType.String, "PAYTYPE")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchKID() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INV_KID_FETCH")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_New_PayType() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INVSETTINGS_FETCH_PAYTYPE")
                    Try
                        Return objDB.ExecuteDataSet(objcmd)
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SavePayType(ByVal objConfigInvBO As ConfigInvoiceBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SAVE_PAYTYPE")
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDERY_INV", DbType.Int32, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@ID_DEPT_INV", DbType.Int32, objConfigInvBO.IdDept)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, objConfigInvBO.XmlVal)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objConfigInvBO.UserId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 20)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdatePayType(ByVal objConfigInvBO As ConfigInvoiceBO) As String
             Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_PAYTYPE")
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDERY_INV", DbType.Int32, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@ID_DEPT_INV", DbType.Int32, objConfigInvBO.IdDept)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, objConfigInvBO.XmlVal)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objConfigInvBO.UserId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 20)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Config(ByVal objConfigInvBO As ConfigInvoiceBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_INV_UPDATE")
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDERY_INV", DbType.Int32, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@ID_DEPT_INV", DbType.Int32, objConfigInvBO.IdDept)
                    objDB.AddInParameter(objcmd, "@VAT_CALC_RULE", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_UNIT", DbType.String, objConfigInvBO.InvTimeRndUnit)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND", DbType.Int32, objConfigInvBO.InvTimeRnd)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_FN", DbType.String, objConfigInvBO.InvTimeRndFn)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_PER", DbType.Int32, objConfigInvBO.InvTimeRndPer)
                    objDB.AddInParameter(objcmd, "@INV_RND_DECIMAL", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@INV_PRICE_RND_FN", DbType.String, objConfigInvBO.InvPriceRndFn)
                    objDB.AddInParameter(objcmd, "@INV_PRICE_RND_VAL_PER", DbType.Int32, objConfigInvBO.InvPrRndValPer) 'objConfigInvBO.InvPrRndValPer
                    objDB.AddInParameter(objcmd, "@KID_FIXED_NUMBER", DbType.String, objConfigInvBO.KidFixedNumber)
                    objDB.AddInParameter(objcmd, "@KID_CUST_NOD", DbType.Int32, objConfigInvBO.KidCustNod)
                    objDB.AddInParameter(objcmd, "@KID_INV_NOD", DbType.Int32, objConfigInvBO.KidInvNod)
                    objDB.AddInParameter(objcmd, "@KID_WO_NOD", DbType.Int32, objConfigInvBO.KidWoNod)
                    objDB.AddInParameter(objcmd, "@KID_FIXED_NOD", DbType.Int32, objConfigInvBO.KidFixedNod)
                    objDB.AddInParameter(objcmd, "@KID_CUST_ORD", DbType.Int32, objConfigInvBO.KidCustOrd)
                    objDB.AddInParameter(objcmd, "@KID_INV_ORD", DbType.Int32, objConfigInvBO.KidInvOrd)
                    objDB.AddInParameter(objcmd, "@KID_WO_ORD", DbType.Int32, objConfigInvBO.KidWoOrd)
                    objDB.AddInParameter(objcmd, "@KID_FIXED_ORD", DbType.Int32, objConfigInvBO.KidFixedOrd)
                    objDB.AddInParameter(objcmd, "@FLG_KID_MOD10", DbType.Boolean, objConfigInvBO.FlgKidMod10)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objConfigInvBO.UserId)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, objConfigInvBO.XmlVal)
                    objDB.AddInParameter(objcmd, "@EXT_VAT_CODE", DbType.String, objConfigInvBO.ExtVatCode)
                    objDB.AddInParameter(objcmd, "@IV_ACCOUNT_CODE", DbType.String, objConfigInvBO.AccountCode)
                    objDB.AddInParameter(objcmd, "@FLG_INV_FEES", DbType.Boolean, objConfigInvBO.FlgInvFees)
                    objDB.AddInParameter(objcmd, "@INV_FEES_AMT", DbType.Decimal, objConfigInvBO.InvFeesAmt)
                    objDB.AddInParameter(objcmd, "@INV_FEES_ACC_CODE", DbType.String, objConfigInvBO.InvFeesAccCode)
                    objDB.AddOutParameter(objcmd, "@ov_RESULT", DbType.Int32, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RESULT").ToString()
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_Config(ByVal objConfigInvBO As ConfigInvoiceBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_INV_INSERT")
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDERY_INV", DbType.Int32, objConfigInvBO.IdSubsidery)
                    objDB.AddInParameter(objcmd, "@ID_DEPT_INV", DbType.Int32, objConfigInvBO.IdDept)
                    objDB.AddInParameter(objcmd, "@VAT_CALC_RULE", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_UNIT", DbType.String, objConfigInvBO.InvTimeRndUnit)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND", DbType.Int32, objConfigInvBO.InvTimeRnd)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_FN", DbType.String, objConfigInvBO.InvTimeRndFn)
                    objDB.AddInParameter(objcmd, "@INV_TIM_RND_PER", DbType.Int32, objConfigInvBO.InvTimeRndPer)
                    objDB.AddInParameter(objcmd, "@INV_RND_DECIMAL", DbType.Int32, 0)
                    objDB.AddInParameter(objcmd, "@INV_PRICE_RND_FN", DbType.String, objConfigInvBO.InvPriceRndFn)
                    objDB.AddInParameter(objcmd, "@INV_PRICE_RND_VAL_PER", DbType.Int32, objConfigInvBO.InvPrRndValPer) 'objConfigInvBO.InvPrRndValPer
                    objDB.AddInParameter(objcmd, "@KID_FIXED_NUMBER", DbType.String, objConfigInvBO.KidFixedNumber)
                    objDB.AddInParameter(objcmd, "@KID_CUST_NOD", DbType.Int32, objConfigInvBO.KidCustNod)
                    objDB.AddInParameter(objcmd, "@KID_INV_NOD", DbType.Int32, objConfigInvBO.KidInvNod)
                    objDB.AddInParameter(objcmd, "@KID_WO_NOD", DbType.Int32, objConfigInvBO.KidWoNod)
                    objDB.AddInParameter(objcmd, "@KID_FIXED_NOD", DbType.Int32, objConfigInvBO.KidFixedNod)
                    objDB.AddInParameter(objcmd, "@KID_CUST_ORD", DbType.Int32, objConfigInvBO.KidCustOrd)
                    objDB.AddInParameter(objcmd, "@KID_INV_ORD", DbType.Int32, objConfigInvBO.KidInvOrd)
                    objDB.AddInParameter(objcmd, "@KID_WO_ORD", DbType.Int32, objConfigInvBO.KidWoOrd)
                    objDB.AddInParameter(objcmd, "@KID_FIXED_ORD", DbType.Int32, objConfigInvBO.KidFixedOrd)
                    objDB.AddInParameter(objcmd, "@FLG_KID_MOD10", DbType.Boolean, objConfigInvBO.FlgKidMod10)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objConfigInvBO.UserId)
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, objConfigInvBO.XmlVal)
                    objDB.AddInParameter(objcmd, "@EXT_VAT_CODE", DbType.String, objConfigInvBO.ExtVatCode)
                    objDB.AddInParameter(objcmd, "@IV_ACCOUNT_CODE", DbType.String, objConfigInvBO.AccountCode)
                    objDB.AddInParameter(objcmd, "@FLG_INV_FEES", DbType.Boolean, objConfigInvBO.FlgInvFees)
                    objDB.AddInParameter(objcmd, "@INV_FEES_AMT", DbType.Decimal, objConfigInvBO.InvFeesAmt)
                    objDB.AddInParameter(objcmd, "@INV_FEES_ACC_CODE", DbType.String, objConfigInvBO.InvFeesAccCode)
                    objDB.AddOutParameter(objcmd, "@ov_RESULT", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RESULT").ToString()
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
