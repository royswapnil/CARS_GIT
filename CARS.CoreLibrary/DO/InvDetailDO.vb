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
Namespace CARS.InvDetailDO

    Public Class InvDetailDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function Fetch_SearchInvoices(ByVal idcustomer As String, ByVal id_veh_seq As Integer, ByVal id_wo_no As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SEARCH_INVLST")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddInParameter(objcmd, "@iv_ID_CUSTOMER", DbType.String, idcustomer)
                    objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ", DbType.String, id_veh_seq)
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, id_wo_no)
                    objDB.AddInParameter(objcmd, "@IV_LANGUAGE", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function Check_BO_QTY(ByVal id_wo_no As String, ByVal id_wo_prefix As String, ByVal id_wodet_seq As Integer) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_BO_QTY")
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, id_wo_no)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, id_wo_prefix)
                    objDB.AddInParameter(objcmd, "@ID_WODET_SEQ", DbType.String, id_wodet_seq)
                    objDB.AddInParameter(objcmd, "@USER_ID", DbType.String, HttpContext.Current.Session("UserID"))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Generate_Invoices_Intermediate(ByVal strXmlInvList As String, ByVal strUserID As String, ByRef strInvLstXml As String) As String
            Dim strRetVal As String
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_CREATEINV_INSERT_INTERMEDIATE")
                objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXmlInvList)
                objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, strUserID)
                objDB.AddOutParameter(objcmd, "@OV_INV_RETVAL", DbType.String, 10)
                objDB.AddOutParameter(objcmd, "@OV_INV_LIST", DbType.String, 7000)
                objDB.ExecuteNonQuery(objcmd)
                strInvLstXml = objDB.GetParameterValue(objcmd, "@OV_INV_LIST").ToString
                strRetVal = objDB.GetParameterValue(objcmd, "@OV_INV_RETVAL").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_INV_LIST").ToString
            End Using
            Return strRetVal
        End Function
        Public Function FetchOrdersToBeInvoiced(ByVal id_login As String, ByVal id_customer As String, ByVal id_veh_seq As Integer, ByVal id_wo_no As String, ByVal language As String, ByVal emailorders As String) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_INVLST_VIEW")
                objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, id_login)
                objDB.AddInParameter(objcmd, "@iv_ID_CUSTOMER", DbType.String, id_customer)
                objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ", DbType.Int32, id_veh_seq)
                objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, id_wo_no)
                objDB.AddInParameter(objcmd, "@IV_LANGUAGE", DbType.String, language)
                objDB.AddInParameter(objcmd, "@IV_CHK_EMAIL", DbType.Boolean, Convert.ToBoolean(emailorders))
                objDB.ExecuteDataSet(objcmd)
                Return objDB.ExecuteDataSet(objcmd)
            End Using
        End Function
        Public Function Search_Invoices(ByVal strXML As String, ByVal DT_INVOICE_FROM As String, ByVal DT_INVOICE_TO As String, ByVal INV_AMT_FROM As Decimal, ByVal INV_AMT_TO As Decimal, ByVal ID_CUSTOMER As String, ByVal ID_DEBITOR As String, ByVal ID_VEH_SEQ As Integer, ByVal ID_WO_NO As String, ByVal INV_STATUS As Integer, ByVal FLG_BATCH_INV As Boolean, ByVal crOrder As String, ByVal SearchBasedOnAmount As Boolean, ByVal SearchBasedInvDate As Boolean) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_INV_SEARCH")
                objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)
                If SearchBasedInvDate Then
                    objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_FROM", DbType.String, DT_INVOICE_FROM)
                    objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_TO", DbType.String, DT_INVOICE_TO)
                Else
                    objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_FROM", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_TO", DbType.String, Nothing)
                End If
                If SearchBasedOnAmount Then
                    objDB.AddInParameter(objcmd, "@iv_INV_AMT_FROM", DbType.String, INV_AMT_FROM)
                    objDB.AddInParameter(objcmd, "@iv_INV_AMT_TO", DbType.String, INV_AMT_TO)
                Else
                    objDB.AddInParameter(objcmd, "@iv_INV_AMT_FROM", DbType.String, Nothing)
                    objDB.AddInParameter(objcmd, "@iv_INV_AMT_TO", DbType.String, Nothing)
                End If
                If ID_CUSTOMER = "" Then
                    objDB.AddInParameter(objcmd, "@iv_ID_CUSTOMER", DbType.String, Nothing)
                Else
                    objDB.AddInParameter(objcmd, "@iv_ID_CUSTOMER", DbType.String, ID_CUSTOMER)
                End If

                If ID_DEBITOR = "" Then
                    objDB.AddInParameter(objcmd, "@iv_ID_DEBITOR", DbType.String, Nothing)
                Else
                    objDB.AddInParameter(objcmd, "@iv_ID_DEBITOR", DbType.String, ID_DEBITOR)
                End If

                objDB.AddInParameter(objcmd, "@iv_ID_VEH_SEQ", DbType.String, ID_VEH_SEQ)
                If ID_WO_NO = "" Then
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, Nothing)

                Else
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, ID_WO_NO)
                End If
                objDB.AddInParameter(objcmd, "@iv_INV_STATUS", DbType.String, INV_STATUS)
                objDB.AddInParameter(objcmd, "@FLG_BATCH_INV", DbType.String, FLG_BATCH_INV)
                objDB.AddInParameter(objcmd, "@iv_UserID", DbType.String, HttpContext.Current.Session("UserID"))
                objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                objDB.AddInParameter(objcmd, "@Cr_Orders", DbType.String, crOrder)
                Return objDB.ExecuteDataSet(objcmd)
            End Using

        End Function
        Public Function Fetch_OrderList(ByVal id_inv_no As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_INVORD_SEARCH")
                    objDB.AddInParameter(objcmd, "@iv_ID_INV_NO", DbType.String, id_inv_no)
                    objDB.AddInParameter(objcmd, "@FLG_CREDIT", DbType.String, 1)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Create_CreditNote(ByVal strInvListXML As String, ByRef strCNLstXml As String, ByRef InvNo As String, ByVal creditNoteDate As String) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_CREDITNOTE_CREATE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strInvListXML)
                    objDB.AddInParameter(objcmd, "@iv_Inv_No", DbType.String, InvNo)
                    objDB.AddInParameter(objcmd, "@ov_CREDITNOTEDATE", DbType.String, creditNoteDate)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.AddOutParameter(objcmd, "@ov_CNLstXml", DbType.String, 4000)
                    objDB.ExecuteNonQuery(objcmd)
                    strCNLstXml = objDB.GetParameterValue(objcmd, "@ov_CNLstXml").ToString
                    Return objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + strCNLstXml.ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Search_InvoicesCN(ByVal strXML As String, ByVal DT_INVOICE_FROM As String, ByVal DT_INVOICE_TO As String, ByVal ID_WO_NO As String, ByVal FLG_BATCH_INV As Boolean) As DataSet
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_INV_SEARCH")
                objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, strXML)

                objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_FROM", DbType.String, DT_INVOICE_FROM)
                objDB.AddInParameter(objcmd, "@iv_DT_INVOICE_TO", DbType.String, DT_INVOICE_TO)


                If ID_WO_NO = "" Then
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, Nothing)

                Else
                    objDB.AddInParameter(objcmd, "@iv_ID_WO_NO", DbType.String, ID_WO_NO)
                End If
                objDB.AddInParameter(objcmd, "@FLG_BATCH_INV", DbType.String, FLG_BATCH_INV)
                objDB.AddInParameter(objcmd, "@iv_UserID", DbType.String, HttpContext.Current.Session("UserID"))
                objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                Return objDB.ExecuteDataSet(objcmd)
            End Using

        End Function
        Public Function Insert_DupWorkOrder(ByVal woNo As String, ByVal woPr As String) As String
            Dim strCNLstXml As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CREATE_DUP_WO")
                    objDB.AddInParameter(objcmd, "@ID_WO_NO", DbType.String, woNo)
                    objDB.AddInParameter(objcmd, "@ID_WO_PREFIX", DbType.String, woPr)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_INV_LIST", DbType.String, 7000)
                    objDB.ExecuteNonQuery(objcmd)
                    strCNLstXml = objDB.GetParameterValue(objcmd, "@OV_INV_LIST").ToString
                    Return strCNLstXml
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Insert_INV_DupWorkOrder(ByVal id_inv_no As String) As String
            Dim strCNLstXml As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_WONOS_INV")
                    objDB.AddInParameter(objcmd, "@ID_INV_NO", DbType.String, id_inv_no)
                    objDB.AddOutParameter(objcmd, "@OV_RETVAL", DbType.String, 7000)
                    objDB.ExecuteNonQuery(objcmd)
                    strCNLstXml = objDB.GetParameterValue(objcmd, "@OV_RETVAL").ToString
                    Return strCNLstXml
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateToStock(ByVal strWonoXml As String) As String
            Dim strCNLstXml As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_Update_Stock")
                    objDB.AddInParameter(objcmd, "@IV_XMLDOC", DbType.String, strWonoXml)
                    objDB.AddInParameter(objcmd, "@IV_CREATEDBY", DbType.String, HttpContext.Current.Session("UserID"))
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 7000)
                    objDB.ExecuteNonQuery(objcmd)
                    strCNLstXml = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    Return strCNLstXml
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace


