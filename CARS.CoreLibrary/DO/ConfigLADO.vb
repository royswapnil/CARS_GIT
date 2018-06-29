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
Namespace CARS.ConfigLADO
    Public Class ConfigLADO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Shared objConfigLABO As New ConfigLABO
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function FetchConfiguration() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_LA_FETCH")
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchCustInfoSettings() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ACCOUNT_CUST_INFO_SETT_FETCH")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchFilePathSettings() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_ACCOUNT_CUST_FILE_IMP_SETTINGS")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchCustInfoTemplateConfig() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_CUST_TEMP_CONFIG")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function FetchBalanceTemplateConfig() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_BALANCE_TEMP_CONFIG")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function AddConfiguration(ByVal firstUpdate As Boolean, ByVal config As Boolean, ByVal journ_export_seq As Boolean, ByVal cust_export_seq As Boolean, ByVal acc_code As Boolean, ByVal schedule As Boolean, ByVal objConfigLABO As ConfigLABO) As String
            Dim strResult As String
            Try
                If (firstUpdate) Then

                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ALL_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_FLG_GROUPING", DbType.String, objConfigLABO.Flg_Grouping)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORTMODE", DbType.String, objConfigLABO.Flg_ExportMode)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_ALLOWMULMONTHS", DbType.String, objConfigLABO.Flg_Export_AllowMulMonths)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_EACHINVOICE", DbType.String, objConfigLABO.Flg_Export_EachInvoice)
                        objDB.AddInParameter(objcmd, "@IV_PATH_EXPORT_INVJOURNAL", DbType.String, objConfigLABO.Path_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_PATH_EXPORT_CUSTINFO", DbType.String, objConfigLABO.Path_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_PATH_IMPORT_CUSTINFO", DbType.String, objConfigLABO.Path_Import_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_PATH_IMPORT_CUSTBAL", DbType.String, objConfigLABO.Path_Import_CustBal)
                        objDB.AddInParameter(objcmd, "@IV_PREFIXFILENAME_EXPORT_INVJOURNAL", DbType.String, objConfigLABO.PrefixFileName_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_SUFFIXFILENAME_EXPORT_INVJOURNAL", DbType.String, objConfigLABO.SuffixFileName_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_INVJOURNAL_SEQNOS", DbType.String, objConfigLABO.Flg_Export_InvJournal_SeqNos)
                        objDB.AddInParameter(objcmd, "@IV_PREFIXFILENAME_EXPORT_CUSTINFO", DbType.String, objConfigLABO.PrefixFileName_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_SUFFIXFILENAME_EXPORT_CUSTINFO", DbType.String, objConfigLABO.SuffixFileName_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_CUST_SEQNOS", DbType.String, objConfigLABO.Flg_Export_Cust_SeqNos)
                        objDB.AddInParameter(objcmd, "@IV_EXP_INVJOURNAL_SERIES", DbType.String, objConfigLABO.Exp_InvJournal_Series)
                        objDB.AddInParameter(objcmd, "@IV_EXP_CUST_SERIES", DbType.String, objConfigLABO.Exp_Cust_Series)
                        objDB.AddInParameter(objcmd, "@IV_ERROR_ACC_CODE", DbType.String, objConfigLABO.Error_Acc_Code)
                        objDB.AddInParameter(objcmd, "@IV_SCH_BASIS", DbType.String, objConfigLABO.Sch_Basis)
                        objDB.AddInParameter(objcmd, "@IV_SCH_TIMEFORMAT", DbType.String, objConfigLABO.Sch_TimeFormat)
                        objDB.AddInParameter(objcmd, "@IV_SCH_DAILY_INTERVAL_MINS", DbType.String, objConfigLABO.Sch_Daily_Interval_mins)
                        objDB.AddInParameter(objcmd, "@IV_SCH_WEEK_DAY", DbType.String, objConfigLABO.Sch_Week_Day)
                        objDB.AddInParameter(objcmd, "@IV_SCH_MONTH_DAY", DbType.String, objConfigLABO.Sch_Month_Day)
                        objDB.AddInParameter(objcmd, "@IV_SCH_DAILY_STIME", DbType.String, objConfigLABO.Sch_Daily_STime)
                        objDB.AddInParameter(objcmd, "@IV_SCH_WEEK_TIME", DbType.String, objConfigLABO.Sch_Week_Time)
                        objDB.AddInParameter(objcmd, "@IV_SCH_MONTH_TIME", DbType.String, objConfigLABO.Sch_Month_Time)
                        objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddInParameter(objcmd, "@IV_MODIFIED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_ID", DbType.String, objConfigLABO.Customer_ID)
                        objDB.AddInParameter(objcmd, "@IV_CUST_ORD_NO", DbType.String, objConfigLABO.Cust_Ord_No)
                        objDB.AddInParameter(objcmd, "@IV_CUS_REG_NO", DbType.String, objConfigLABO.Cust_Reg_No)
                        objDB.AddInParameter(objcmd, "@IV_CUST_VIN_NO", DbType.String, objConfigLABO.Cust_Vin_No)
                        objDB.AddInParameter(objcmd, "@IV_CUST_VIN_NO_LEN", DbType.String, objConfigLABO.Cust_Vin_No_Len)
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_NAME", DbType.String, objConfigLABO.Customer_Name)
                        objDB.AddInParameter(objcmd, "@IV_CUST_FIXED_TEXT", DbType.String, objConfigLABO.Cust_Fixed_Text)
                        objDB.AddInParameter(objcmd, "@INVJOURNAL_TEMP", DbType.String, objConfigLABO.Invoice_Journal_Temp)
                        objDB.AddInParameter(objcmd, "@CUSTINFO_TEMP", DbType.String, objConfigLABO.CustInfo_Temp)
                        objDB.AddInParameter(objcmd, "@IV_USE_INVNO_SORT", DbType.String, objConfigLABO.Flg_Export_UseInvoiceNum)
                        objDB.AddInParameter(objcmd, "@IV_USE_CR_EXP", DbType.String, objConfigLABO.Flg_Export_UseCreditnote)
                        objDB.AddInParameter(objcmd, "@IV_USE_BL_SPACS", DbType.String, objConfigLABO.Flg_Export_UseBlankSp)
                        objDB.AddInParameter(objcmd, "@IV_USE_COMB_LINES", DbType.String, objConfigLABO.Flg_Export_UseCombLines)
                        objDB.AddInParameter(objcmd, "@IV_USE_SPLIT", DbType.String, objConfigLABO.Flg_Export_UseSplit)
                        objDB.AddInParameter(objcmd, "@IV_ADD_DATE", DbType.String, objConfigLABO.Flg_Export_UseAddDate)
                        objDB.AddInParameter(objcmd, "@IV_REM_COST", DbType.String, objConfigLABO.Flg_Export_RemCost)
                        objDB.AddInParameter(objcmd, "@IV_FLG_TEXT", DbType.String, objConfigLABO.Flg_Export_UseAddText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_ADDITONAL", DbType.String, objConfigLABO.Flg_Export_UseAdditionalText)
                        objDB.AddInParameter(objcmd, "@IV_ADD_TEXT", DbType.String, objConfigLABO.Export_AddText)
                        objDB.AddInParameter(objcmd, "@IV_ADDITINAL_TEXT", DbType.String, objConfigLABO.Export_AdditionalText)
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_TEXT", DbType.String, objConfigLABO.Export_CustomerText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_CUSTOMER_TEXT", DbType.String, objConfigLABO.Flg_Export_UseCustomerText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_VOCHER_TYPE", DbType.String, objConfigLABO.Flg_Export_VocherType)
                        objDB.AddInParameter(objcmd, "@IV_VOCHER_TYPE", DbType.String, objConfigLABO.Export_VocherType)
                        objDB.AddInParameter(objcmd, "@IV_FLG_DISPLAY_ALL_INVNUM", DbType.String, objConfigLABO.Flg_Display_AllInvNum)
                        objDB.AddInParameter(objcmd, "@IV_FP_ACC_CODE", DbType.String, objConfigLABO.FP_Acc_Code)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPRT_VALID", DbType.String, objConfigLABO.Flg_Export_Valid)
                        objDB.AddInParameter(objcmd, "@IV_ERR_INVOICES_NAME", DbType.String, objConfigLABO.ErrInvoicesName)
                        objDB.AddInParameter(objcmd, "@IV_FLG_USE_BILL_ADDR_EXP", DbType.String, objConfigLABO.Flg_Use_Bill_Addr_Exp)

                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString

                    End Using
                End If

                If (config) Then
                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_FLG_GROUPING", DbType.String, objConfigLABO.Flg_Grouping)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORTMODE", DbType.String, objConfigLABO.Flg_ExportMode)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_ALLOWMULMONTHS", DbType.String, objConfigLABO.Flg_Export_AllowMulMonths)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_EACHINVOICE", DbType.String, objConfigLABO.Flg_Export_EachInvoice)
                        objDB.AddInParameter(objcmd, "@IV_PATH_EXPORT_INVJOURNAL", DbType.String, objConfigLABO.Path_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_PATH_EXPORT_CUSTINFO", DbType.String, objConfigLABO.Path_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_PATH_IMPORT_CUSTINFO", DbType.String, objConfigLABO.Path_Import_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_PATH_IMPORT_CUSTBAL", DbType.String, objConfigLABO.Path_Import_CustBal)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_INVJOURNAL_SEQNOS", DbType.String, objConfigLABO.Flg_Export_InvJournal_SeqNos)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPORT_CUST_SEQNOS", DbType.String, objConfigLABO.Flg_Export_Cust_SeqNos)
                        objDB.AddInParameter(objcmd, "@IV_MODIFIED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_ID", DbType.String, objConfigLABO.Customer_ID)
                        objDB.AddInParameter(objcmd, "@IV_CUST_ORD_NO", DbType.String, objConfigLABO.Cust_Ord_No)
                        objDB.AddInParameter(objcmd, "@IV_CUS_REG_NO", DbType.String, objConfigLABO.Cust_Reg_No)
                        objDB.AddInParameter(objcmd, "@IV_CUST_VIN_NO", DbType.String, objConfigLABO.Cust_Vin_No)
                        objDB.AddInParameter(objcmd, "@IV_CUST_VIN_NO_LEN", DbType.String, objConfigLABO.Cust_Vin_No_Len)
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_NAME", DbType.String, objConfigLABO.Customer_Name)
                        objDB.AddInParameter(objcmd, "@IV_CUST_FIXED_TEXT", DbType.String, objConfigLABO.Cust_Fixed_Text)
                        objDB.AddInParameter(objcmd, "@INVJOURNAL_TEMP", DbType.String, objConfigLABO.Invoice_Journal_Temp)
                        objDB.AddInParameter(objcmd, "@CUSTINFO_TEMP", DbType.String, objConfigLABO.CustInfo_Temp)
                        objDB.AddInParameter(objcmd, "@IV_USE_INVNO_SORT", DbType.String, objConfigLABO.Flg_Export_UseInvoiceNum)
                        objDB.AddInParameter(objcmd, "@IV_USE_CR_EXP", DbType.String, objConfigLABO.Flg_Export_UseCreditnote)
                        objDB.AddInParameter(objcmd, "@IV_USE_BL_SPACS", DbType.String, objConfigLABO.Flg_Export_UseBlankSp)
                        objDB.AddInParameter(objcmd, "@IV_USE_COMB_LINES", DbType.String, objConfigLABO.Flg_Export_UseCombLines)
                        objDB.AddInParameter(objcmd, "@IV_USE_SPLIT", DbType.String, objConfigLABO.Flg_Export_UseSplit)
                        objDB.AddInParameter(objcmd, "@IV_ADD_DATE", DbType.String, objConfigLABO.Flg_Export_UseAddDate)
                        objDB.AddInParameter(objcmd, "@IV_REM_COST", DbType.String, objConfigLABO.Flg_Export_RemCost)
                        objDB.AddInParameter(objcmd, "@IV_FLG_TEXT", DbType.String, objConfigLABO.Flg_Export_UseAddText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_ADDITONAL", DbType.String, objConfigLABO.Flg_Export_UseAdditionalText)
                        objDB.AddInParameter(objcmd, "@IV_ADD_TEXT", DbType.String, objConfigLABO.Export_AddText)
                        objDB.AddInParameter(objcmd, "@IV_ADDITINAL_TEXT", DbType.String, objConfigLABO.Export_AdditionalText)
                        objDB.AddInParameter(objcmd, "@IV_CUSTOMER_TEXT", DbType.String, objConfigLABO.Export_CustomerText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_CUSTOMER_TEXT", DbType.String, objConfigLABO.Flg_Export_UseCustomerText)
                        objDB.AddInParameter(objcmd, "@IV_FLG_VOCHER_TYPE", DbType.String, objConfigLABO.Flg_Export_VocherType)
                        objDB.AddInParameter(objcmd, "@IV_VOCHER_TYPE", DbType.String, objConfigLABO.Export_VocherType)
                        objDB.AddInParameter(objcmd, "@IV_FLG_DISPLAY_ALL_INVNUM", DbType.String, objConfigLABO.Flg_Display_AllInvNum)
                        objDB.AddInParameter(objcmd, "@IV_FP_ACC_CODE", DbType.String, objConfigLABO.FP_Acc_Code)
                        objDB.AddInParameter(objcmd, "@IV_FLG_EXPRT_VALID", DbType.String, objConfigLABO.Flg_Export_Valid)
                        objDB.AddInParameter(objcmd, "@IV_ERR_INVOICES_NAME", DbType.String, objConfigLABO.ErrInvoicesName)
                        objDB.AddInParameter(objcmd, "@IV_FLG_USE_BILL_ADDR_EXP", DbType.String, objConfigLABO.Flg_Use_Bill_Addr_Exp)

                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString

                    End Using
                End If

                If (journ_export_seq) Then

                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_JOURN_EXPORT_SEQ_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_Exp_InvJournal_Series", DbType.String, objConfigLABO.Exp_InvJournal_Series)
                        objDB.AddInParameter(objcmd, "@IV_SuffixFileName_Export_InvJournal", DbType.String, objConfigLABO.SuffixFileName_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_PrefixFileName_Export_InvJournal", DbType.String, objConfigLABO.PrefixFileName_Export_InvJournal)
                        objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    End Using
                End If

                If (cust_export_seq) Then
                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_CUST_EXPORT_SEQ_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_EXP_CUST_SERIES", DbType.String, objConfigLABO.Exp_Cust_Series)
                        objDB.AddInParameter(objcmd, "@IV_PREFIXFILENAME_EXPORT_CUSTINFO", DbType.String, objConfigLABO.PrefixFileName_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_SUFFIXFILENAME_EXPORT_CUSTINFO", DbType.String, objConfigLABO.SuffixFileName_Export_CustInfo)
                        objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    End Using
                End If

                If (acc_code) Then
                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ACC_CODE_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_ERROR_ACC_CODE", DbType.String, objConfigLABO.Error_Acc_Code)
                        objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    End Using
                End If

                If (schedule) Then
                    Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_SCHEDULE_LA_INSERT")
                        objDB.AddInParameter(objcmd, "@IV_SCH_BASIS", DbType.String, objConfigLABO.Sch_Basis)
                        objDB.AddInParameter(objcmd, "@IV_SCH_TIMEFORMAT", DbType.String, objConfigLABO.Sch_TimeFormat)
                        objDB.AddInParameter(objcmd, "@IV_SCH_DAILY_INTERVAL_MINS", DbType.String, objConfigLABO.Sch_Daily_Interval_mins)
                        objDB.AddInParameter(objcmd, "@IV_SCH_WEEK_DAY", DbType.String, objConfigLABO.Sch_Week_Day)
                        objDB.AddInParameter(objcmd, "@IV_SCH_MONTH_DAY", DbType.String, objConfigLABO.Sch_Month_Day)
                        objDB.AddInParameter(objcmd, "@IV_SCH_DAILY_STIME", DbType.String, objConfigLABO.Sch_Daily_STime)
                        objDB.AddInParameter(objcmd, "@IV_SCH_DAILY_ETIME", DbType.String, objConfigLABO.Sch_Daily_ETime)
                        objDB.AddInParameter(objcmd, "@IV_SCH_WEEK_TIME", DbType.String, objConfigLABO.Sch_Week_Time)
                        objDB.AddInParameter(objcmd, "@IV_SCH_MONTH_TIME", DbType.String, objConfigLABO.Sch_Month_Time)
                        objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                        objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.Int32, 10)
                        objDB.ExecuteNonQuery(objcmd)
                        strResult = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    End Using
                End If

            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function
        Public Function SaveServiceSettings()
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INSERT_ACC_EXP_SERV_SETTINGS")
                    objDB.AddInParameter(objcmd, "@Task_Time", DbType.String, "")
                    objDB.ExecuteNonQuery(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class

End Namespace

