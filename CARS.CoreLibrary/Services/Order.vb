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
Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common

Namespace CARS.Services.Order
    Public Class OrderDetails
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objOrderDO As New OrderDO
        Shared objOrderBO As New OrderBO
        Dim objDB As Database
        Dim ConnectionString As String
        Shared objWOPayDO As New WOPaymentDetailDO.WOPaymentDetailDO
        Shared objWOPayBO As New WOPaymentDetailBO
        Shared objInvDetailDO As New InvDetailDO.InvDetailDO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objInvConfigurationDO As New InvConfigurationDO.InvConfigurationDO

        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function GetOrder(ByVal orderNo As String) As List(Of String)
            Dim dsOrder As New DataSet
            Dim dtOrder As DataTable
            Dim retOrder As New List(Of String)()
            Try
                dsOrder = objOrderDO.GetOrder(orderNo)

                If dsOrder.Tables.Count > 0 Then
                    If dsOrder.Tables(0).Rows.Count > 0 Then
                        dtOrder = dsOrder.Tables(0)
                    End If
                End If
                If orderNo <> String.Empty Then
                    For Each dtrow As DataRow In dtOrder.Rows
                        retOrder.Add(String.Format("{0}", dtrow("ORDERDATA")))
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return retOrder
        End Function

        Public Function Order_Search(ByVal q As String, ByVal isBargain As String, ByVal isOrder As String, ByVal isCreditnote As String, ByVal isOpenorder As String, ByVal isReadyforinvoice As String) As List(Of OrderBO)
            Dim dsOrder As New DataSet
            Dim dtOrder As DataTable
            Dim orderSearchResult As New List(Of OrderBO)()
            Try
                dsOrder = objOrderDO.Order_Search(q, isBargain, isOrder, isCreditnote, isOpenorder, isReadyforinvoice)

                If dsOrder.Tables.Count > 0 Then
                    dtOrder = dsOrder.Tables(0)
                End If
                If q <> String.Empty Then
                    For Each dtrow As DataRow In dtOrder.Rows
                        Dim vsr As New OrderBO()
                        vsr.ORDNO = dtrow("ID_WO_NO").ToString
                        vsr.IDCUSTOMER = dtrow("ID_CUST_WO").ToString
                        vsr.CUSTOMER = dtrow("WO_CUST_NAME").ToString
                        If (dtrow("WO_CUST_PERM_ADD1").ToString() = "") Then
                            vsr.CUSTADD1 = ""
                        Else
                            vsr.CUSTADD1 = dtrow("WO_CUST_PERM_ADD1").ToString
                        End If

                        If (dtrow("ID_ZIPCODE_WO").ToString() = "") Then
                            vsr.CUSTZIP = ""
                        Else
                            vsr.CUSTZIP = dtrow("ID_ZIPCODE_WO").ToString
                        End If

                        If (dtrow("WO_CUST_PHONE_MOBILE").ToString() = "") Then
                            vsr.CUSTPHONEMOBILE = ""
                        Else
                            vsr.CUSTPHONEMOBILE = dtrow("WO_CUST_PHONE_MOBILE").ToString
                        End If
                        vsr.REFNO = dtrow("WO_VEH_INTERN_NO").ToString


                        If (dtrow("WO_VEH_REG_NO").ToString() = "") Then
                            vsr.REGNO = ""
                        Else
                            vsr.REGNO = dtrow("WO_VEH_REG_NO").ToString
                        End If

                        If (dtrow("ID_INV_NO").ToString() = "") Then
                            vsr.InvNo = ""
                        Else
                            vsr.InvNo = dtrow("ID_INV_NO").ToString
                        End If

                        If (dtrow("DT_INVOICE").ToString() = "") Then
                            vsr.InvDate = ""
                        Else
                            vsr.InvDate = objCommonUtil.GetCurrentLanguageDate(IIf(IsDBNull(dtrow("DT_INVOICE")) = True, "", dtrow("DT_INVOICE").ToString()))
                        End If

                        If (dtrow("WO_PREFIX").ToString() = "") Then
                            vsr.PREFIX = ""
                        Else
                            vsr.PREFIX = dtrow("WO_PREFIX").ToString
                        End If

                        If (dtrow("WO_NO").ToString() = "") Then
                            vsr.WOSeries = ""
                        Else
                            vsr.WOSeries = dtrow("WO_NO").ToString
                        End If
                        vsr.PayType = dtrow("TERMS").ToString
                        vsr.OrderType = dtrow("WO_TYPE_WOH").ToString
                        vsr.OrderStatus = IIf(IsDBNull(dtrow("ORDERSTATUS")) = True, "", dtrow("ORDERSTATUS").ToString())
                        vsr.STATUS = dtrow("WO_STATUS").ToString

                        orderSearchResult.Add(vsr)
                    Next
                End If
            Catch ex As Exception
                Throw ex
            End Try
            Return orderSearchResult
        End Function

        Public Function CreateInvoice(ByVal orderNo As String, ByVal orderPr As String, ByVal custId As String, ByVal flgBkOrd As String, ByVal payType As String, ByVal orderType As String) As String
            Dim strResult As String = ""
            Dim strScript As String = String.Empty
            Try
                Dim blIschecked As Boolean
                Dim InvoiceListXML As String = ""

                If (orderType = "ORD") Then
                    HttpContext.Current.Session("RptType") = "INVOICE"
                End If

                Dim dsInv As DataSet = objInvDetailDO.Fetch_SearchInvoices(custId, 0, orderPr.ToString() + orderNo.ToString())
                HttpContext.Current.Session("WoNum") = orderNo.ToString()
                HttpContext.Current.Session("WoPrefix") = orderPr.ToString()

                objWOPayBO.Id_WO_NO = orderNo
                objWOPayBO.Id_WO_Prefix = orderPr
                Dim dsUnclkdJobs = objWOPayDO.Load_PaymentDetails(objWOPayBO)

                If (dsInv.Tables.Count > 0) Then
                    If dsInv.Tables(0).Rows.Count > 0 And IsDBNull(dsUnclkdJobs.Tables(1).Rows(0)("DT_CLOCK_OUT")) = False Then
                        If dsInv.Tables(1).Rows.Count > 0 Then
                            For i As Integer = 0 To dsInv.Tables(1).DefaultView.Count - 1
                                blIschecked = Convert.ToBoolean(dsInv.Tables(1).DefaultView(i).Item("IS_SELECTED"))
                                If blIschecked = True Then
                                    Dim strFLG_BATCH As String = objCommonUtil.ConvertStr(dsInv.Tables(0).DefaultView(0).Item("FLG_CUST_BATCHINV").ToString)
                                    If strFLG_BATCH = objErrHandle.GetErrorDesc("D_TRUE") Then
                                        strFLG_BATCH = "1"
                                    Else
                                        strFLG_BATCH = "0"
                                    End If
                                    InvoiceListXML += "<INV_GENERATE " _
                                                        + " ID_WO_PREFIX=""" + objCommonUtil.ConvertStr(orderPr) + """ " _
                                                        + " ID_WO_NO=""" + objCommonUtil.ConvertStr(orderNo) + """ " _
                                                        + " ID_WODET_SEQ=""" + objCommonUtil.ConvertStr(dsInv.Tables(1).DefaultView(i).Item("ID_WODET_SEQ").ToString) + """ " _
                                                        + " ID_JOB_DEB=""" + objCommonUtil.ConvertStr(dsInv.Tables(1).DefaultView(i).Item("ID_JOB_DEB").ToString) + """ " _
                                                        + " FLG_BATCH=""" + objCommonUtil.ConvertStr(strFLG_BATCH) + """ " _
                                                        + " IV_DATE =""" + "" + """ " _
                                                        + "/>"


                                    If flgBkOrd = "false" Then
                                        Dim ID_WODET_SEQ As Integer = Convert.ToInt32(dsInv.Tables(1).DefaultView(i).Item("ID_WODET_SEQ").ToString)
                                        Dim dschkboqty As DataSet = objInvDetailDO.Check_BO_QTY(orderNo, orderPr, ID_WODET_SEQ)

                                        If dschkboqty.Tables.Count > 0 Then
                                            If dschkboqty.Tables(0).Rows.Count > 0 Then
                                                If dschkboqty.Tables(0).Rows(0)("TOT_BO_QTY").ToString <> "0" Then
                                                    flgBkOrd = "False"
                                                    Dim WoNo As String = dschkboqty.Tables(0).Rows(0)("ID_WO_PREFIX").ToString + dschkboqty.Tables(0).Rows(0)("ID_WO_NO").ToString
                                                    Dim JobNo As String = dschkboqty.Tables(0).Rows(0)("ID_JOB").ToString
                                                    Dim BOQtyMsg As String = "Confirm," + objErrHandle.GetErrorDesc("CHKBOQTY") + orderNo.ToString + " - " + JobNo.ToString + ". " + objErrHandle.GetErrorDesc("MESS_CONFIRM")
                                                    Return BOQtyMsg
                                                End If
                                            End If
                                        End If
                                    End If
                                End If
                            Next
                        End If
                    Else
                        strResult = "Err," + objErrHandle.GetErrorDescParameter("CANNOTINVOICE") + "</Font>"
                    End If
                End If

                If InvoiceListXML = "" Then
                    strResult = "Err," + +objErrHandle.GetErrorDescParameter("WRKORD") + "</Font>"
                End If
                InvoiceListXML = "<ROOT>" + InvoiceListXML + "</ROOT>"

                Dim strRetValue As String
                Dim strInvLstXml As String = ""

                'Logging
                'Logging(InvoiceListXML)
                'strRetValue = objInvDetailBO.Generate_Invoices(InvoiceListXML, Session("UserId"), strInvLstXml)
                strRetValue = objWOPayDO.Generate_Invoices(InvoiceListXML, HttpContext.Current.Session("UserId"), strInvLstXml)
                strInvLstXml = HttpContext.Current.Session("strinvListXml") ' can be used as byref instead session

                'RTlblError.Visible = True
                If strRetValue = "OFL" Then
                    strResult = "Err," + objErrHandle.GetErrorDesc("INVNOOFL") + "</Font>"
                ElseIf strRetValue = "NOCONFIG" Then
                    strResult = "Err," + objErrHandle.GetErrorDesc("NOCONFIG") + "</Font>"
                ElseIf strRetValue = "INVWRNPAY" Then
                    strResult = "Err," + objErrHandle.GetErrorDesc("INVWRNPAY") + "</Font>"
                ElseIf strRetValue <> "0" And strRetValue <> "WARN" And strRetValue <> "INVOICED" Then
                    strResult = "Err," + objErrHandle.GetErrorDesc("INVERR") + "</Font>"
                Else
                    Dim WarningMsg As String = ""
                    If strRetValue = "WARN" Then
                        strResult = "Err," + objErrHandle.GetErrorDesc("INVWRN") + "</Font>"
                        WarningMsg = "INVWRN"
                    End If
                    strResult = objErrHandle.GetErrorDescParameter("CREATE", objErrHandle.GetErrorDesc("INV"))
                    strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                    HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                    Dim rnd As New Random
                    If (payType = "0") Then
                        HttpContext.Current.Session("RptType") = "CashInvoice"
                        strScript = "Succ," + "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("CashInvoice") + "&InvoiceType=" + objCommonUtil.fnEncryptQString("CashInvoice") + "&Rpt=" + objCommonUtil.fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString()
                    Else
                        HttpContext.Current.Session("RptType") = "INVOICE"
                        strScript = "Succ," + "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("Invoice") + "&InvoiceType=" + objCommonUtil.fnEncryptQString("INVOICE") + "&Rpt=" + objCommonUtil.fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString()
                    End If
                   
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Order", "CreateInvoice", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return strScript
        End Function
        Public Function OpenInvoicePdf(ByVal orderNo As String, ByVal orderPr As String, ByVal custId As String, ByVal invNo As String) As String
            Dim strScript As String = ""
            Dim strInvLstXml As String = ""
            Try
                Dim copy As String = "False" 'check
                Dim blIsCN As Boolean
                blIsCN = "False" ' Need to check
                'strInvLstXml = "<ROOT><OPTIONS FLG_COPYTEXT=""" + copy + """ /><INVNO ID_INV_NO=""" + invNo + """ FLG_INVORCN=""" + blIsCN.ToString + """ /><INVNO ID_INV_NO=""" + invNo + """ FLG_INVORCN=""" + blIsCN.ToString + """ /></ROOT>"
                strInvLstXml = "<ROOT><INVNO ID_INV_NO=""" + invNo + """ /><INVNO ID_INV_NO=""" + invNo + """ /></ROOT>"
                strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                Dim rnd As New Random

                HttpContext.Current.Session("RptType") = "INVOICE"
                strScript = "Succ," + "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("Invoice") + "&InvoiceType=" + objCommonUtil.fnEncryptQString("INVOICE") + "&Rpt=" + objCommonUtil.fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString()

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Order", "OpenInvoicePdf", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserId"))
            End Try
            Return strScript
        End Function
        Public Function DeleteOrder(ByVal WoNo As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objOrderDO.Delete_Order(WoNo)
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
                objErrHandle.WriteErrorLog(1, "Services.Order", "DeleteOrder", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function Copy_WorkOrder(ByVal IdWoNo As String, ByVal IdWoPr As String) As List(Of OrderBO)
            Dim dsOrder As New DataSet
            Dim dtOrder As DataTable
            Dim orderCopyResult As New List(Of OrderBO)()
            Try
                dsOrder = objOrderDO.CopyWorkOrder(IdWoNo, IdWoPr)
                If dsOrder.Tables.Count > 0 Then
                    dtOrder = dsOrder.Tables(0)
                End If
                For Each dtrow As DataRow In dtOrder.Rows
                    Dim newOrder As New OrderBO()
                    newOrder.ORDNO = dtrow("ID_WO_NO").ToString
                    newOrder.PREFIX = dtrow("ID_WO_PREFIX").ToString
                    orderCopyResult.Add(newOrder)
                Next

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.Order", "Copy_WorkOrder", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return orderCopyResult
        End Function


    End Class
End Namespace