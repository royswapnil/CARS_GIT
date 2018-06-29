Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Configuration
Imports System.IO
Imports System.Drawing
Imports System.Web.Script.Serialization.JavaScriptSerializer
Imports System.Object
Imports System.MarshalByRefObject
Imports System.Net.WebRequest
Imports System.Net.HttpWebRequest
Imports System.Net.HttpWebResponse
Imports System.Net
Imports System.Web
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls.WebParts
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Globalization
Imports System.Xml
Imports System.Text
Namespace CARS.Services.InvDetail
    Public Class InvDetail
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objInvDetDO As New CARS.InvDetailDO.InvDetailDO
        Shared objInvDetBO As New InvDetailBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Public Function FetchOrdersToBeInvoiced(ByVal id_login As String, ByVal id_customer As String, ByVal id_veh_seq As Integer, ByVal id_wo_no As String, ByVal language As String, ByVal emailorders As String) As Collection
            Dim dsInvDet As New DataSet
            Dim dtInvDet As New DataTable
            Dim dtColl As New Collection
            Try
                dsInvDet = objInvDetDO.FetchOrdersToBeInvoiced(id_login, id_customer, id_veh_seq, id_wo_no, language, emailorders)
                HttpContext.Current.Session("OrdersToBeInvoiced") = dsInvDet
                If dsInvDet.Tables(0).Rows.Count > 0 Then
                    Dim details As New List(Of InvDetailBO)()
                    dtInvDet = dsInvDet.Tables(0)
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_WO_NO = dtrow("Id_WO_NO")
                        invDet.Id_WO_Prefix = dtrow("Id_WO_Prefix")
                        invDet.Dt_Order = dtrow("Dt_Order")
                        invDet.No_Of_Jobs = dtrow("No_Of_Jobs")
                        invDet.Deb_Name = dtrow("Deb_Name")
                        invDet.Deb_Id = dtrow("Deb_Id")
                        invDet.MaxInvoice = IIf(IsDBNull(dtrow("MaxInvoice")) = True, "", dtrow("MaxInvoice"))
                        invDet.Id_Job_Deb = dtrow("Id_Job_Deb")
                        invDet.WO_Veh_Reg_No = dtrow("WO_Veh_Reg_No")
                        invDet.WO_Amount = dtrow("WO_Amount")
                        invDet.Flg_Cust_Batchinv = dtrow("Flg_Cust_Batchinv")
                        invDet.PayType = dtrow("PayType")
                        invDet.WO_Type_Woh = dtrow("WO_Type_Woh")
                        invDet.WO_Type = dtrow("WO_Type")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                End If

                If dsInvDet.Tables(1).Rows.Count > 0 Then
                    dtInvDet = dsInvDet.Tables(1)
                    Dim details As New List(Of InvDetailBO)()
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_WO_NO = dtrow("Id_WO_NO")
                        invDet.Id_WO_Prefix = dtrow("Id_WO_Prefix")
                        invDet.Id_WoDet_Seq = dtrow("Id_WoDet_Seq")
                        invDet.Id_Job = dtrow("Id_Job")
                        invDet.WO_Job_Text = dtrow("WO_Job_Txt")
                        invDet.Id_Rep_Code_WO = dtrow("Id_Rep_Code_WO1")
                        invDet.Rep_Code_WO = dtrow("Id_Rep_Code_WO")
                        invDet.Id_Rpg_Code_WO = IIf(IsDBNull(dtrow("Id_Rpg_Code_WO1")) = True, "", dtrow("Id_Rpg_Code_WO1"))
                        invDet.Rpg_Code_WO = dtrow("Id_Rpg_Code_WO")
                        invDet.Job_Amount = dtrow("Job_Amount1")
                        invDet.Job_Amount_Format = dtrow("Job_Amount")
                        invDet.Id_Job_Deb = dtrow("Id_Job_Deb")
                        invDet.Is_Selected = dtrow("Is_Selected")
                        invDet.Deb_Id = dtrow("Deb_Id")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                ElseIf (dsInvDet.Tables(1).Rows.Count = 0) Then
                    dtInvDet = dsInvDet.Tables(1)
                    Dim details As New List(Of InvDetailBO)()
                    dtColl.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "FetchOrdersToBeInvoiced", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtColl
        End Function
        Public Function FetchChildOrdersToBeInvoiced(ByVal id_login As String, ByVal id_customer As String, ByVal id_veh_seq As Integer, ByVal id_wo_no As String, ByVal language As String, ByVal emailorders As String) As Collection
            Dim dsInvDet As New DataSet
            Dim dtInvDet As New DataTable
            Dim dtColl As New Collection
            Try
                dsInvDet = objInvDetDO.FetchOrdersToBeInvoiced(id_login, id_customer, id_veh_seq, id_wo_no, language, emailorders)

                If dsInvDet.Tables(0).Rows.Count > 0 Then
                    Dim details As New List(Of InvDetailBO)()
                    dtInvDet = dsInvDet.Tables(0)
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_WO_NO = dtrow("Id_WO_NO")
                        invDet.Id_WO_Prefix = dtrow("Id_WO_Prefix")
                        invDet.Dt_Order = dtrow("Dt_Order")
                        invDet.No_Of_Jobs = dtrow("No_Of_Jobs")
                        invDet.Deb_Name = dtrow("Deb_Name")
                        invDet.Deb_Id = dtrow("Deb_Id")
                        invDet.MaxInvoice = IIf(IsDBNull(dtrow("MaxInvoice")) = True, "", dtrow("MaxInvoice"))
                        invDet.Id_Job_Deb = dtrow("Id_Job_Deb")
                        invDet.WO_Veh_Reg_No = dtrow("WO_Veh_Reg_No")
                        invDet.WO_Amount = dtrow("WO_Amount")
                        invDet.Flg_Cust_Batchinv = dtrow("Flg_Cust_Batchinv")
                        invDet.PayType = dtrow("PayType")
                        invDet.WO_Type_Woh = dtrow("WO_Type_Woh")
                        invDet.WO_Type = dtrow("WO_Type")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                End If

                If dsInvDet.Tables(1).Rows.Count > 0 Then
                    dtInvDet = dsInvDet.Tables(1)
                    Dim details As New List(Of InvDetailBO)()
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_WO_NO = dtrow("Id_WO_NO")
                        invDet.Id_WO_Prefix = dtrow("Id_WO_Prefix")
                        invDet.Id_WoDet_Seq = dtrow("Id_WoDet_Seq")
                        invDet.Id_Job = dtrow("Id_Job")
                        invDet.WO_Job_Text = dtrow("WO_Job_Txt")
                        invDet.Id_Rep_Code_WO = dtrow("Id_Rep_Code_WO1")
                        invDet.Rep_Code_WO = dtrow("Id_Rep_Code_WO")
                        invDet.Id_Rpg_Code_WO = IIf(IsDBNull(dtrow("Id_Rpg_Code_WO1")) = True, "", dtrow("Id_Rpg_Code_WO1"))
                        invDet.Rpg_Code_WO = dtrow("Id_Rpg_Code_WO")
                        invDet.Job_Amount = dtrow("Job_Amount1")
                        invDet.Job_Amount_Format = dtrow("Job_Amount")
                        invDet.Id_Job_Deb = dtrow("Id_Job_Deb")
                        invDet.Is_Selected = dtrow("Is_Selected")
                        invDet.Deb_Id = dtrow("Deb_Id")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                ElseIf (dsInvDet.Tables(1).Rows.Count = 0) Then
                    dtInvDet = dsInvDet.Tables(1)
                    Dim details As New List(Of InvDetailBO)()
                    dtColl.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "FetchOrdersToBeInvoiced", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtColl
        End Function
        Public Function FetchInvoices(ByVal strXML As String, ByVal dt_invoice_from As String, ByVal dt_invoice_to As String, ByVal inv_amt_from As String, ByVal inv_amt_to As String, ByVal id_customer As String, ByVal id_debitor As String, ByVal id_veh_seq As String, ByVal id_wo_no As String, ByVal inv_status As String, ByVal flg_batch_inv As Boolean, ByVal crOrder As String, ByVal searchbasedonamount As Boolean, ByVal searchbasedinvdate As Boolean) As Collection
            Dim dsInvDet As New DataSet
            Dim dtInvDet As New DataTable
            Dim dtColl As New Collection
            Try

                Dim invAmtFrom As Decimal = IIf(inv_amt_from = "", 0D, inv_amt_from)
                Dim invAmtTo As Decimal = IIf(inv_amt_to = "", 0D, inv_amt_to)
                Dim idVehSeq As Integer = IIf(id_veh_seq = "", 0, id_veh_seq)
                Dim invStatus As Integer = IIf(inv_status = "", 0, inv_status)

                dsInvDet = objInvDetDO.Search_Invoices(strXML, dt_invoice_from, dt_invoice_to, invAmtFrom, invAmtTo, id_customer, id_debitor, idVehSeq, id_wo_no, invStatus, flg_batch_inv, crOrder, searchbasedonamount, searchbasedinvdate)
                If dsInvDet.Tables(0).Rows.Count > 0 Then
                    Dim details As New List(Of InvDetailBO)()
                    dtInvDet = dsInvDet.Tables(0)
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_Inv_No = dtrow("Id_Inv_NO")
                        invDet.Dt_Invoice = dtrow("DT_INVOICE")
                        invDet.WO_Veh_Reg_No = dtrow("VEH_REG_NO")
                        invDet.CustomerName = dtrow("CUST_NAME")
                        invDet.InvoiceAmt = dtrow("INV_AMT")
                        invDet.Flg_Batch_Inv = dtrow("FLG_BATCH_INV")
                        invDet.Credit_No = IIf(IsDBNull(dtrow("ID_CN_NO")) = True, "", dtrow("ID_CN_NO"))
                        invDet.WO_Type_Woh = dtrow("WO_TYPE_WOH")
                        invDet.InvoicePDF = dtrow("ID_PARENT_INV_NO")
                        invDet.Flg_Alrdy_Cr = dtrow("Flg_Kre_Ord")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "FetchInvoices", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtColl
        End Function
        Public Function FetchOrderList(objInvDetBO) As List(Of InvDetailBO)
            Dim details As New List(Of InvDetailBO)()
            Dim dsInvDetails As New DataSet
            Dim dtInvDetails As New DataTable
            Try
                dsInvDetails = objInvDetDO.Fetch_OrderList(objInvDetBO)
                HttpContext.Current.Session("InvoicedOrders") = dsInvDetails.Tables(0)
                If dsInvDetails.Tables.Count > 0 Then
                    If dsInvDetails.Tables(0).Rows.Count > 0 Then
                        dtInvDetails = dsInvDetails.Tables(0)
                        For Each dtrow As DataRow In dtInvDetails.Rows
                            Dim invDet As New InvDetailBO()
                            invDet.Id_WO_NO = dtrow("ID_WO_NO")
                            invDet.No_Of_Jobs = dtrow("NO_OF_JOBS")
                            invDet.Dt_Order = dtrow("DT_ORDER")
                            invDet.SeqNo = dtrow("ID_VEH_SEQ_WO")
                            invDet.WO_Amount = dtrow("TOT_ORD_AMT")
                            invDet.Id_WO_Prefix = dtrow("ID_WO_PREFIX")
                            invDet.Flg_Kre_Ord = dtrow("Flg_Kre_Ord")
                            details.Add(invDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "FetchOrderList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function CreateCrNote(ByVal orders As String, ByVal regnDate As String) As String()
            Dim strArray As Array
            Try
                Dim dsOrds As New DataSet 'No of Jobs
                Dim dtOrds As New DataTable 'No of Jobs
                Dim dvOrds As New DataView
                Dim InvoiceListXML As String = ""
                Dim strRetVal As String = ""
                Dim strInvLstXml As String = ""
                Dim invDetBO As New InvDetailBO
                Dim strCNLstXml As String = ""
                Dim creditNoteDate As String = Nothing
                If regnDate = "" Then
                    creditNoteDate = Nothing
                Else
                    creditNoteDate = regnDate
                End If
                Dim items = JsonConvert.DeserializeObject(Of List(Of InvDetailBO))(orders)

                For i As Integer = 0 To items.Count - 1
                    dsOrds = objInvDetDO.Fetch_OrderList(items(i).Id_Inv_No)

                    If (dsOrds.Tables(0).Rows.Count > 0) Then
                        InvoiceListXML += "<INV_CN " _
                        + " ID_INV_NO=""" + objCommonUtil.ConvertStr(items(i).Id_Inv_No) + """ " _
                        + " FLG_BATCH=""" + objCommonUtil.ConvertStr("0") + """ " _
                        + "/>"

                    End If
                Next
                InvoiceListXML = "<root>" + InvoiceListXML + "</root>"

                strRetVal = objInvDetDO.Create_CreditNote(InvoiceListXML, strCNLstXml, GetInvoiceNo(items), creditNoteDate)
                strCNLstXml = strCNLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strCNLstXml
                HttpContext.Current.Session("RptType") = "CreditNote"
                strArray = strRetVal.Split(",") 'Need to initialize array(1)
                strRetVal = strRetVal.Split(",")(0)
                If strRetVal = "INVWRN" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("CRNWRN")
                    'END
                Else
                    If strRetVal = "WARN" Then
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INVWRN")
                    End If
                    strArray(0) = "SUCCESS"
                    strArray(1) = objErrHandle.GetErrorDescParameter("CREATE", objErrHandle.GetErrorDesc("INV"))

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "CreateCreditNote", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Private Function GetInvoiceNo(items) As String
            Dim dsOrds As New DataSet
            Dim dtOrds As New DataTable 'No of Jobs
            Dim dvOrds As New DataView
            Dim strInvXML As StringBuilder = New StringBuilder
            Try
                For i As Integer = 0 To items.Count - 1
                    strInvXML.Append("'" + objCommonUtil.ConvertStr((items(i).Id_Inv_No)) + "'" + ",")
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "GetInvoiceNo", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strInvXML.ToString.Substring(0, strInvXML.ToString.LastIndexOf(","))
        End Function
        Public Function InvoiceProcess(ByVal orders As String) As String()
            Dim strArray As Array
            Try
                Dim dsOrds As New DataSet 'No of Jobs
                Dim dtOrds As New DataTable 'No of Jobs
                Dim dvOrds As New DataView
                Dim InvoiceListXML As String = ""
                Dim strRetVal As String = ""
                Dim strInvLstXml As String = ""
                Dim invDetBO As New InvDetailBO
                Dim invoicedate As String = ""
                Dim strFLG_BATCH As String = ""
                Dim strFLG_BATCH_INV As String = ""
                Dim items = JsonConvert.DeserializeObject(Of List(Of InvDetailBO))(orders)

                dsOrds = HttpContext.Current.Session("OrdersToBeInvoiced")

                For i As Integer = 0 To items.Count - 1
                    If (dsOrds.Tables(1).Rows.Count > 0) Then
                        dsOrds.Tables(1).DefaultView.RowFilter = "ID_WO_NO='" + items(i).Id_WO_NO + "' AND " _
                                + "ID_WO_PREFIX='" + items(i).Id_WO_Prefix + "' AND " _
                                + "ID_JOB_DEB='" + items(i).Id_Job_Deb + "'"

                        dvOrds = dsOrds.Tables(1).DefaultView
                        dtOrds = dvOrds.ToTable

                        strFLG_BATCH_INV = items(i).Flg_Batch_Inv

                        If (items(i).Dt_Order <> "") Then
                            invoicedate = items(i).Dt_Order
                            invoicedate = objCommonUtil.GetDefaultDate_MMDDYYYY(invoicedate)
                        Else
                            invoicedate = ""
                        End If

                        For Each dtrow As DataRow In dtOrds.Rows
                            If strFLG_BATCH_INV = objErrHandle.GetErrorDesc("D_TRUE") Then
                                strFLG_BATCH = "1"
                            Else
                                strFLG_BATCH = "0"
                            End If

                            InvoiceListXML += "<INV_GENERATE " _
                            + " ID_WO_PREFIX=""" + objCommonUtil.ConvertStr(dtrow("Id_WO_Prefix")) + """ " _
                            + " ID_WO_NO=""" + objCommonUtil.ConvertStr(dtrow("Id_WO_NO")) + """ " _
                            + " ID_WODET_SEQ=""" + objCommonUtil.ConvertStr(dtrow("ID_WODET_SEQ")) + """ " _
                            + " ID_JOB_DEB=""" + objCommonUtil.ConvertStr(dtrow("ID_JOB_DEB")) + """ " _
                            + " FLG_BATCH=""" + objCommonUtil.ConvertStr(strFLG_BATCH) + """ " _
                            + " IV_DATE =""" + invoicedate + """ " _
                            + "/>"
                        Next
                    End If
                Next
                InvoiceListXML = "<ROOT>" + InvoiceListXML + "</ROOT>"
                strRetVal = objInvDetDO.Generate_Invoices_Intermediate(InvoiceListXML, HttpContext.Current.Session("UserID"), strInvLstXml)

                strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                HttpContext.Current.Session("RptType") = "INVOICE"
                strArray = strRetVal.Split(",") 'Need to initialize array(1)

                strRetVal = strRetVal.Split(",")(0)

                If strRetVal = "OFL" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVNOOFL")
                ElseIf strRetVal = "NOCONFIG" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("NOCONFIG")
                    'START
                ElseIf strRetVal = "INVWRNPAY" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVWRNPAY")
                    'END
                ElseIf strRetVal <> "0" And strRetVal <> "WARN" And strRetVal <> "INVOICED" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVERR")
                Else
                    If strRetVal = "WARN" Then
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INVWRN")
                    End If

                    'Double Invoicing Check
                    If strRetVal = "INC_INV" Then 'Incomplete invoicing
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INC_INV")
                    End If
                    strArray(0) = "SUCCESS"
                    strArray(1) = objErrHandle.GetErrorDescParameter("CREATE", objErrHandle.GetErrorDesc("INV"))

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "InvoiceProcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray

        End Function
        Public Function FetchInvoiceListCN(ByVal strXML As String, ByVal dt_invoice_from As String, ByVal dt_invoice_to As String, ByVal id_wo_no As String, ByVal flg_batch_inv As Boolean) As Collection
            Dim dsInvDet As New DataSet
            Dim dtInvDet As New DataTable
            Dim dtColl As New Collection
            Try


                dsInvDet = objInvDetDO.Search_InvoicesCN(strXML, dt_invoice_from, dt_invoice_to, id_wo_no, flg_batch_inv)
                If dsInvDet.Tables(0).Rows.Count > 0 Then
                    Dim details As New List(Of InvDetailBO)()
                    dtInvDet = dsInvDet.Tables(0)
                    For Each dtrow As DataRow In dtInvDet.Rows
                        Dim invDet As New InvDetailBO()
                        invDet.Id_Inv_No = dtrow("Id_Inv_NO")
                        invDet.Dt_Invoice = dtrow("DT_INVOICE")
                        invDet.WO_Veh_Reg_No = dtrow("VEH_REG_NO")
                        invDet.CustomerName = dtrow("CUST_NAME")
                        invDet.InvoiceAmt = dtrow("INV_AMT")
                        invDet.Flg_Batch_Inv = dtrow("FLG_BATCH_INV")
                        invDet.Credit_No = IIf(IsDBNull(dtrow("ID_CN_NO")) = True, "", dtrow("ID_CN_NO"))
                        invDet.WO_Type_Woh = dtrow("WO_TYPE_WOH")
                        invDet.InvoicePDF = dtrow("ID_PARENT_INV_NO")
                        details.Add(invDet)
                    Next
                    dtColl.Add(details)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "FetchInvoiceListCN", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtColl
        End Function
        Public Function CreateCrNoteOrders(ByVal idWoNo As String, ByVal idWoPr As String) As String
            Dim strStatus As String
            Dim strArray As Array
            Try
                strStatus = objInvDetDO.Insert_DupWorkOrder(idWoNo, idWoPr)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "CreateCrNoteOrders", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strStatus
        End Function
        Public Function CreateInv_CreditNoteOrders(ByVal id_inv_no As String) As String()
            Dim strStatus As String
            Dim strRetVal As String = ""
            Dim strInvLstXml As String = ""
            Dim strUpdStock As String = ""
            Dim strArray As Array
            Try
                strStatus = objInvDetDO.Insert_INV_DupWorkOrder(id_inv_no)
                strRetVal = objInvDetDO.Generate_Invoices_Intermediate(strStatus, HttpContext.Current.Session("UserID"), strInvLstXml)


                strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                HttpContext.Current.Session("RptType") = "INVOICE"
                strArray = strRetVal.Split(",") 'Need to initialize array(1)

                strRetVal = strRetVal.Split(",")(0)

                If strRetVal = "OFL" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVNOOFL")
                ElseIf strRetVal = "NOCONFIG" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("NOCONFIG")
                    'START
                ElseIf strRetVal = "INVWRNPAY" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVWRNPAY")
                    'END
                ElseIf strRetVal <> "0" And strRetVal <> "WARN" And strRetVal <> "INVOICED" Then
                    strArray(0) = "ERROR"
                    strArray(1) = objErrHandle.GetErrorDesc("INVERR")
                Else
                    If strRetVal = "WARN" Then
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INVWRN")
                    End If

                    'Double Invoicing Check
                    If strRetVal = "INC_INV" Then 'Incomplete invoicing
                        strArray(0) = "ERROR"
                        strArray(1) = objErrHandle.GetErrorDesc("INC_INV")
                    End If
                    strArray(0) = "SUCCESS"
                    strArray(1) = objErrHandle.GetErrorDescParameter("CREATE", objErrHandle.GetErrorDesc("INV"))
                    strUpdStock = objInvDetDO.UpdateToStock(strStatus)

                End If



            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.InvDetail", "CreateCrNoteOrders", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
    End Class
End Namespace

