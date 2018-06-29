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
Namespace CARS.LinkToAccountingDO
    Public Class LinkToAccountingDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_AccountCodes() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_ACC_CODES_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Trans_ID() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_TRANS_ID")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_AccountCodeTypes() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_LA_CODES")
                    objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Matrix_Save(ByVal objLABO As LinkToAccountingBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_ACCMATRIX_SAVE")
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPTID", DbType.Int32, objLABO.Id_DeptId)
                    objDB.AddInParameter(objcmd, "@IV_ID_DeptAcCode", DbType.String, objLABO.Id_DeptAcCode)
                    objDB.AddInParameter(objcmd, "@IV_ID_CUSTGRPID", DbType.Int32, objLABO.Id_CUSTOMER)
                    objDB.AddInParameter(objcmd, "@IV_ID_CustGrpAcCode", DbType.String, objLABO.Id_CustGrpAcCode)
                    objDB.AddInParameter(objcmd, "@IB_FreeDuty", DbType.Boolean, objLABO.Id_FreeDuty)
                    objDB.AddInParameter(objcmd, "@IV_SALECODE_DESC", DbType.String, objLABO.Id_SaleCode_Desc)
                    objDB.AddInParameter(objcmd, "@IV_SaleCode_Type", DbType.String, objLABO.Id_SaleCode_Type)
                    objDB.AddInParameter(objcmd, "@IV_Project", DbType.String, objLABO.Id_Project)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_Desc", DbType.String, objLABO.Id_Selling_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Selling_GL_CrDb", DbType.Boolean, objLABO.Id_Selling_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_AccNo", DbType.String, objLABO.Id_Selling_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_DeptAccNo", DbType.String, objLABO.Id_Selling_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_Dimension", DbType.String, objLABO.Id_Selling_GL_Dimension)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_Desc", DbType.String, objLABO.Id_Discount_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Discount_GL_CrDb", DbType.Boolean, objLABO.Id_Discount_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_AccNo", DbType.String, objLABO.Id_Discount_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_DeptAccNo", DbType.String, objLABO.Id_Discount_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_Dimension", DbType.String, objLABO.Id_Discount_GL_Dimension)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_Desc", DbType.String, objLABO.Id_Stock_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Stock_GL_CrDb", DbType.Boolean, objLABO.Id_Stock_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_AccNo", DbType.String, objLABO.Id_Stock_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_DeptAccNo", DbType.String, objLABO.Id_Stock_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_Dimension", DbType.String, objLABO.Id_Stock_GL_Dimension)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_Desc", DbType.String, objLABO.Id_Cost_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Cost_GL_CrDb", DbType.Boolean, objLABO.Id_Cost_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_AccNo", DbType.String, objLABO.Id_Cost_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_DeptAccNo", DbType.String, objLABO.Id_Cost_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_Dimension", DbType.String, objLABO.Id_Cost_GL_Dimension)
                    objDB.AddInParameter(objcmd, "@IB_Cust_AccNo_CrDb", DbType.Boolean, objLABO.Id_Cust_AccNo_CrDb)
                    objDB.AddInParameter(objcmd, "@IB_GenLedger", DbType.Boolean, objLABO.Id_GenLedger)
                    objDB.AddInParameter(objcmd, "@IV_Description", DbType.String, objLABO.Id_Description)
                    objDB.AddInParameter(objcmd, "@IV_Created_By", DbType.String, objLABO.Id_Created_By)
                    objDB.AddInParameter(objcmd, "@IV_VAT_Code", DbType.String, objLABO.Id_VatCode)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_Desc", DbType.String, objLABO.Id_SellCost_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_SellCost_GL_CrDb", DbType.Boolean, objLABO.Id_SellCost_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_AccNo", DbType.String, objLABO.Id_SellCost_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_DeptAccNo", DbType.String, objLABO.Id_SellCost_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_Dimension", DbType.String, objLABO.Id_SellCost_GL_Dimension)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 20)
                    objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Function Fetch_Configuration(ByVal laSLNO As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_ACCMATRIX_FETCH")
                    objDB.AddInParameter(objcmd, "@Ii_LA_SLNO", DbType.Int32, laSLNO)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Matrix_Update(ByVal objLABO As LinkToAccountingBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_ACCMATRIX_UPDATE")
                    objDB.AddInParameter(objcmd, "@Ii_LA_SLNO", DbType.Int32, objLABO.LA_SlNo)
                    objDB.AddInParameter(objcmd, "@Ii_ID_DEPTID", DbType.Int32, objLABO.Id_DeptId)
                    objDB.AddInParameter(objcmd, "@IV_ID_DeptAcCode", DbType.String, objLABO.Id_DeptAcCode)
                    objDB.AddInParameter(objcmd, "@Ii_ID_CUSTGRPID", DbType.Int32, objLABO.Id_CUSTOMER)
                    objDB.AddInParameter(objcmd, "@IV_ID_CustGrpAcCode", DbType.String, objLABO.Id_CustGrpAcCode)
                    objDB.AddInParameter(objcmd, "@IB_FreeDuty", DbType.Boolean, objLABO.Id_FreeDuty)
                    objDB.AddInParameter(objcmd, "@IV_SALECODE_DESC", DbType.String, objLABO.Id_SaleCode_Desc)
                    objDB.AddInParameter(objcmd, "@IV_SaleCode_Type", DbType.String, objLABO.Id_SaleCode_Type)
                    objDB.AddInParameter(objcmd, "@IV_Project", DbType.String, objLABO.Id_Project)

                    objDB.AddInParameter(objcmd, "@Ii_Selling_GL_ID", DbType.Int32, objLABO.Id_Selling_GL_Id)

                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_Desc", DbType.String, objLABO.Id_Selling_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Selling_GL_CrDb", DbType.Boolean, objLABO.Id_Selling_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_AccNo", DbType.String, objLABO.Id_Selling_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_DeptAccNo", DbType.String, objLABO.Id_Selling_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Selling_GL_Dimension", DbType.String, objLABO.Id_Selling_GL_Dimension)

                    objDB.AddInParameter(objcmd, "@Ii_Discount_GL_Id", DbType.Int32, objLABO.Id_Discount_GL_Id)

                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_Desc", DbType.String, objLABO.Id_Discount_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Discount_GL_CrDb", DbType.Boolean, objLABO.Id_Discount_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_AccNo", DbType.String, objLABO.Id_Discount_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_DeptAccNo", DbType.String, objLABO.Id_Discount_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Discount_GL_Dimension", DbType.String, objLABO.Id_Discount_GL_Dimension)

                    objDB.AddInParameter(objcmd, "@Ii_Stock_GL_Id", DbType.Int32, objLABO.Id_Stock_GL_Id)

                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_Desc", DbType.String, objLABO.Id_Stock_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Stock_GL_CrDb", DbType.Boolean, objLABO.Id_Stock_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_AccNo", DbType.String, objLABO.Id_Stock_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_DeptAccNo", DbType.String, objLABO.Id_Stock_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Stock_GL_Dimension", DbType.String, objLABO.Id_Stock_GL_Dimension)

                    objDB.AddInParameter(objcmd, "@Ii_Cost_GL_Id", DbType.Int32, objLABO.Id_Cost_GL_Id)

                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_Desc", DbType.String, objLABO.Id_Cost_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_Cost_GL_CrDb", DbType.Boolean, objLABO.Id_Cost_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_AccNo", DbType.String, objLABO.Id_Cost_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_DeptAccNo", DbType.String, objLABO.Id_Cost_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_Cost_GL_Dimension", DbType.String, objLABO.Id_Cost_GL_Dimension)
                    objDB.AddInParameter(objcmd, "@IB_Cust_AccNo_CrDb", DbType.Boolean, objLABO.Id_Cust_AccNo_CrDb)
                    objDB.AddInParameter(objcmd, "@IB_GenLedger", DbType.Boolean, objLABO.Id_GenLedger)
                    objDB.AddInParameter(objcmd, "@IV_Description", DbType.String, objLABO.Id_Description)
                    objDB.AddInParameter(objcmd, "@IV_Modified_By", DbType.String, objLABO.Id_Created_By)
                    objDB.AddInParameter(objcmd, "@IV_VAT_Code", DbType.String, objLABO.Id_VatCode)

                    objDB.AddInParameter(objcmd, "@II_SellCost_GL_Id", DbType.Int32, objLABO.Id_SellCost_GL_Id)

                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_Desc", DbType.String, objLABO.Id_SellCost_GL_Desc)
                    objDB.AddInParameter(objcmd, "@IB_SellCost_GL_CrDb", DbType.Boolean, objLABO.Id_SellCost_GL_CrDb)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_AccNo", DbType.String, objLABO.Id_SellCost_GL_AccNo)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_DeptAccNo", DbType.String, objLABO.Id_SellCost_GL_DeptAccNo)
                    objDB.AddInParameter(objcmd, "@IV_SellCost_GL_Dimension", DbType.String, objLABO.Id_SellCost_GL_Dimension)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 20)
                    objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strStatus
        End Function
        Public Function Fetch_Subsidiary(ByVal loginName As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_SUBSIDERY_DEPT")
                    objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, loginName)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetTemplate_Config() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_TEMPLATE_CONFIG")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetTemplate_Config", ex.Message, 544)
            End Try
        End Function
        Public Function GetGrouping_Export() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_GETGROUPING_CUSTOMER_EXPORT")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetGrouping_Export", ex.Message, 544)
            End Try
        End Function
        Public Function GetFilePath_Export() As DataSet
            Try

                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_GETFILEPATH_CUSTOMER_EXPORT")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetFilePath_Export", ex.Message, 544)
            End Try
        End Function
        Public Function GetFileName_InvExport() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_GETFILENAME_INVOICE_EXPORT")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetFileName_InvExport", ex.Message, 544)
            End Try
        End Function
        Public Function GetFileName_Export() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_GETFILENAME_CUSTOMER_EXPORT")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetFileName_Export", ex.Message, 544)
            End Try
        End Function
        Public Function FetchExportData(ByVal objLABO As LinkToAccountingBO) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_EXPORTDATA")
                objDB.AddInParameter(objcmd, "@TABLEFLAG", DbType.String, objLABO.Table_Flag)
                objDB.AddInParameter(objcmd, "@ID_INV_NO", DbType.String, objLABO.Id_Inv_No)
                objDB.AddInParameter(objcmd, "@FROMDATE", DbType.String, objLABO.From_Date)
                objDB.AddInParameter(objcmd, "@TODATE", DbType.String, objLABO.To_Date)
                objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.Int32, objLABO.TemplateId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function UpdateExportData(ByVal objLABO As LinkToAccountingBO) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_UPDATE_EXPORTDATA")
                objDB.AddInParameter(objcmd, "@TABLEFLAG", DbType.String, objLABO.Table_Flag)
                objDB.AddInParameter(objcmd, "@ID_INV_NO", DbType.String, objLABO.Id_Inv_No)
                objDB.AddInParameter(objcmd, "@FROMDATE", DbType.String, objLABO.From_Date)
                objDB.AddInParameter(objcmd, "@TODATE", DbType.String, objLABO.To_Date)
                objDB.AddInParameter(objcmd, "@EXPORTFLAG", DbType.String, objLABO.Export_Flag)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function GetEnclosingCharacter(ByVal fldName As String, ByVal fileName As String, ByVal templateId As String) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GetEnclosingCharacter")
                objDB.AddInParameter(objcmd, "@FLDNAME", DbType.String, fldName)
                objDB.AddInParameter(objcmd, "@FILENAME", DbType.String, fileName)
                objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, templateId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function FetchInvJrnlRecreate(ByVal objLABO As LinkToAccountingBO) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICEJOURNAL")
                objDB.AddInParameter(objcmd, "@INV_SUBSIDIARY", DbType.String, objLABO.Id_Sub)
                objDB.AddInParameter(objcmd, "@INV_STATRTDATE", DbType.String, objLABO.From_Date)
                objDB.AddInParameter(objcmd, "@INV_ENDDATE", DbType.String, objLABO.To_Date)
                objDB.AddInParameter(objcmd, "@INV_DEPT", DbType.String, objLABO.InvDept)
                objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, objLABO.TemplateId)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function GetEachInvoice() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_GET_EACHINVOICE")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetEachInvoice", ex.Message, 544)
            End Try
        End Function
        Public Function Fetch_Post_Journal_Report(ByVal strXmlTC As String) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RPT_POSTING_JOURNAL_XML")
                objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXmlTC)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function Get_Recreate_Template_Config(ByVal Trans_Id As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_RECREATE_TEMPLATE_CONFIG")
                    objDB.AddInParameter(objcmd, "@TRANS_ID", DbType.String, Trans_Id)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "Get_Recreate_Template_Config", ex.Message, 544)
            End Try
        End Function
        Public Function FetchInvJrnlRecreateTrnsId(ByVal objLABO As LinkToAccountingBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICEJOURNAL_TRANSACTIONID_RECREATE")
                    objDB.AddInParameter(objcmd, "@TRANSID", DbType.String, objLABO.Id_Tran)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "FetchInvJrnlRecreateTrnsId", ex.Message, 544)
            End Try
        End Function
        Public Function FetchInvJrnlRegenerateTrnsId(ByVal objLABO As LinkToAccountingBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVOICEJOURNAL_TRANSACTIONID")
                    objDB.AddInParameter(objcmd, "@TRANSID", DbType.String, objLABO.Id_Tran)
                    objDB.AddInParameter(objcmd, "@TEMPLATE_ID", DbType.String, objLABO.TemplateId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "FetchInvJrnlRegenerateTrnsId", ex.Message, 544)
            End Try
        End Function
        Public Function GetFileName_InvExport_TransId(ByVal Trans_Id As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_GETFILENAME_INVOICE_EXPORT_TRANSID")
                    objDB.AddInParameter(objcmd, "@TRANS_ID", DbType.String, Trans_Id)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Link to Accounting Configuration DO", "GetFileName_InvExport_TransId", ex.Message, 544)

            End Try
        End Function
        Public Function Fetch_LACodeList(ByVal deptCode As String, ByVal custGrpCode As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_CODELIST")
                    objDB.AddInParameter(objcmd, "@IV_LA_DEPTCODE", DbType.String, deptCode)
                    objDB.AddInParameter(objcmd, "@IV_LA_CUSGRPCODE", DbType.String, custGrpCode)
                    objDB.AddInParameter(objcmd, "@IV_ID_LOGIN", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())

                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function DeleteLACodeList(ByVal strXML As String) As String
            Try
                Dim strStatus As String = ""
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_LA_CODELIST_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_XML", DbType.String, strXML)

                    strStatus = objDB.ExecuteNonQuery(objcmd)
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_InvoicesExported(ByVal tranId As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INV_EXP_SEARCH")
                    objDB.AddInParameter(objcmd, "@IV_TRAN_ID", DbType.String, tranId)
                    objDB.AddInParameter(objcmd, "@IV_LANG", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Error_Invoices_Report(ByVal strxmltc As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_RPT_ERROR_INVOICE")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strxmltc)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Cust_Balance(ByVal balanceXml As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_BalanceInformation_ImportFile")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, balanceXml)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function import_file(ByVal strXml As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CustomerInformation_ImportFile")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strXml)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
