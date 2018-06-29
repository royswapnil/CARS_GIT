Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfLA
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objLABO As New ConfigLABO
    Shared objLAServ As New Services.ConfigLA.ConfigLA
    Shared details As New List(Of ConfigLABO)()
    Shared configdetails As New List(Of ConfigLABO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Shared strscreenName As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            Dim i As Integer
            ddlWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlMonthly.Items.Clear()
            For i = 1 To 31
                ddlMonthly.Items.Add(i)
            Next


            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpdailyHM)
            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpDisplayVchrType)
            drpDisplayVchrType.Items.Insert(0, New ListItem(Session("Select"), "Select"))
            'SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfLA", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadConfiguration() As Collection
        Dim details As New Collection
        Try
            details = objLAServ.FetchAllConfiguration()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfLA", "LoadConfiguration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function LoadCustInfoSett() As ConfigLABO()
        Dim details As New List(Of ConfigLABO)()
        Try
            details = objLAServ.FetchCustInfoSettings()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfLA", "LoadCustInfoSett", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveConfiguration(ByVal flgGrouping As String, ByVal flgExpMode As String, ByVal flgExpAllowMulMonths As String, ByVal flgExpEachInvoice As String, ByVal expInvjournalPath As String, ByVal expCustInfoPath As String, ByVal impCustInfoPath As String, ByVal impCustBalancePath As String, ByVal expInvJrnlSeqNo As String, ByVal expCustSeqNo As String, ByVal customerId As String, ByVal custOrderNo As String, ByVal custRegNo As String, ByVal custVINNo As String, ByVal custVINNoLen As String, ByVal custName As String, ByVal custFixedText As String, ByVal invJrnlTemp As String, ByVal custInfoTemp As String, ByVal useInvNoSort As String, ByVal useCRExp As String, ByVal useBLSpaces As String, ByVal useCombLines As String, ByVal useSplit As String, ByVal addDate As String, ByVal remCostStckfromInv As String, ByVal flgAddText As String, ByVal flgAdditionalText As String, ByVal addText As String, ByVal additionalText As String, ByVal flgCustText As String, ByVal custText As String, ByVal flgVoucherType As String, ByVal voucherType As String, ByVal flgDisplayAllInvNum As String, ByVal fixedPriceAccntCode As String, ByVal flgExpValid As String, ByVal errorInvoicesName As String, ByVal suffixFileNameExpInvJrnl As String, ByVal prefixFileNameExpInvJrnl As String, ByVal prefixFileNameExpCustInfo As String, ByVal suffixFileNameExpCustInfo As String, ByVal schBasis As String, ByVal schDailyTimeFormat As String, ByVal schDailyIntMins As String, ByVal schDailyStTime As String, ByVal schDailyEndTime As String, ByVal schWeekDay As String, ByVal schWeekTime As String, ByVal schMonthDay As String, ByVal schMonthTime As String, ByVal flgUseBillAddrExp As String, ByVal errAccntCode As String, ByVal expInvJournalSeries As String, ByVal expCustSeries As String) As String()
        'ByVal expInvjournalPath As String, ByVal expCustInfoPath As String, ByVal impCustInfoPath As String, ByVal impCustBalancePath As String, ByVal expInvJrnlSeqNo As String, ByVal expCustSeqNo As String, ByVal customerId As String, ByVal custOrderNo As String, ByVal custRegNo As String, ByVal custVINNo As String, ByVal custVINNoLen As String, ByVal custName As String, ByVal custFixedText As String, ByVal invJrnlTemp As String, ByVal custInfoTemp As String, ByVal useInvNoSort As String, ByVal useCRExp As String, ByVal useBLSpaces As String, ByVal useCombLines As String, ByVal useSplit As String, ByVal addDate As String, ByVal remCostStckfromInv As String, ByVal flgAddText As String, ByVal flgAdditionalText As String, ByVal addText As String, ByVal additionalText As String, ByVal flgCustText As String, ByVal custText As String, ByVal flgVoucherType As String, ByVal voucherType As String, ByVal flgDisplayAllInvNum As String, ByVal fixedPriceAccntCode As String, ByVal flgExpValid As String, ByVal errorInvoicesName As String, ByVal suffixFileNameExpInvJrnl As String, ByVal prefixFileNameExpInvJrnl As String, ByVal prefixFileNameExpCustInfo As String, ByVal suffixFileNameExpCustInfo As String, ByVal schBasis As String, ByVal schDailyTimeFormat As String, ByVal schDailyIntMins As String, ByVal schDailyStTime As String, ByVal schDailyEndTime As String, ByVal schWeekDay As String, ByVal schWeekTime As String, ByVal schMonthDay As String, ByVal schMonthTime As String) As String()
        Dim strResult(1) As String
        Try

            objLABO.Flg_Grouping = flgGrouping
            objLABO.Flg_ExportMode = flgExpMode
            objLABO.Flg_Export_AllowMulMonths = flgExpAllowMulMonths
            objLABO.Flg_Export_EachInvoice = flgExpEachInvoice
            objLABO.Path_Export_InvJournal = expInvjournalPath.Replace("/", "\")
            objLABO.Path_Export_CustInfo = expCustInfoPath.Replace("/", "\")
            objLABO.Path_Import_CustInfo = impCustInfoPath.Replace("/", "\")
            objLABO.Path_Import_CustBal = impCustBalancePath.Replace("/", "\")
            objLABO.Flg_Export_InvJournal_SeqNos = expInvJrnlSeqNo
            objLABO.Exp_InvJournal_Series = expInvJournalSeries
            objLABO.Flg_Export_Cust_SeqNos = expCustSeqNo
            objLABO.Exp_Cust_Series = expCustSeries
            objLABO.Customer_ID = customerId
            objLABO.Cust_Ord_No = custOrderNo
            objLABO.Cust_Reg_No = custRegNo
            objLABO.Cust_Vin_No = custVINNo
            objLABO.Cust_Vin_No_Len = custVINNoLen
            objLABO.Customer_Name = custName
            objLABO.Cust_Fixed_Text = custFixedText
            objLABO.Invoice_Journal_Temp = invJrnlTemp
            objLABO.CustInfo_Temp = custInfoTemp
            objLABO.Flg_Export_UseInvoiceNum = useInvNoSort
            objLABO.Flg_Export_UseCreditnote = useCRExp
            objLABO.Flg_Export_UseBlankSp = useBLSpaces
            objLABO.Flg_Export_UseCombLines = useCombLines
            objLABO.Flg_Export_UseSplit = useSplit
            objLABO.Flg_Export_UseAddDate = addDate
            objLABO.Flg_Export_RemCost = remCostStckfromInv
            objLABO.Flg_Export_UseAddText = flgAddText
            objLABO.Export_AddText = addText
            objLABO.Export_AdditionalText = additionalText
            objLABO.Flg_Export_UseAdditionalText = flgAdditionalText
            objLABO.Flg_Export_UseCustomerText = flgCustText
            objLABO.Export_CustomerText = custText
            objLABO.Flg_Export_VocherType = flgVoucherType
            objLABO.Export_VocherType = voucherType
            objLABO.Flg_Display_AllInvNum = flgDisplayAllInvNum
            objLABO.FP_Acc_Code = fixedPriceAccntCode
            objLABO.Flg_Export_Valid = flgExpValid
            objLABO.ErrInvoicesName = errorInvoicesName
            objLABO.SuffixFileName_Export_InvJournal = suffixFileNameExpInvJrnl
            objLABO.PrefixFileName_Export_InvJournal = prefixFileNameExpInvJrnl
            objLABO.PrefixFileName_Export_CustInfo = prefixFileNameExpCustInfo
            objLABO.SuffixFileName_Export_CustInfo = suffixFileNameExpCustInfo
            objLABO.Sch_Basis = schBasis
            objLABO.Sch_TimeFormat = schDailyTimeFormat
            objLABO.Sch_Daily_Interval_mins = schDailyIntMins
            objLABO.Sch_Daily_STime = schDailyStTime
            objLABO.Sch_Daily_ETime = schDailyEndTime
            objLABO.Sch_Week_Day = schWeekDay
            objLABO.Sch_Week_Time = schWeekTime
            objLABO.Sch_Month_Day = schMonthDay
            objLABO.Sch_Month_Time = schMonthTime
            objLABO.Flg_Use_Bill_Addr_Exp = flgUseBillAddrExp
            objLABO.Error_Acc_Code = errAccntCode


            Dim invoiceExportPath As String = String.Empty
            Dim arrayInvoiceFolder As Array
            Dim invoiceIndex As Int32 = 0
            invoiceExportPath = objLABO.Path_Export_InvJournal.Trim

            If Not invoiceExportPath Is String.Empty Then
                If invoiceExportPath.Substring(invoiceExportPath.Length - 1, 1) <> "\" Then
                    invoiceExportPath = invoiceExportPath + "\"
                End If
                arrayInvoiceFolder = invoiceExportPath.Split("\")

                For invoiceIndex = 0 To arrayInvoiceFolder.Length - 2
                    If invoiceIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If invoiceExportPath.Length > 2 Then
                            splChar = invoiceExportPath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayInvoiceFolder(invoiceIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG040")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayInvoiceFolder(invoiceIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG040")
                        ElseIf arrayInvoiceFolder(invoiceIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG040")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If

            Dim customerExportPath As String = String.Empty
            Dim arrayCustomerFolder As Array
            Dim customerIndex As Int32 = 0
            customerExportPath = objLABO.Path_Export_CustInfo

            If Not customerExportPath Is String.Empty Then
                If customerExportPath.Substring(customerExportPath.Length - 1, 1) <> "\" Then
                    customerExportPath = customerExportPath + "\"
                End If
                arrayCustomerFolder = customerExportPath.Split("\")

                For customerIndex = 0 To arrayCustomerFolder.Length - 2
                    If customerIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If customerExportPath.Length > 2 Then
                            splChar = customerExportPath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayCustomerFolder(customerIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG037")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayCustomerFolder(customerIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG037")
                        ElseIf arrayCustomerFolder(customerIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG037")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If

            Dim customerImportPath As String = String.Empty
            Dim arrayCustomerImpFolder As Array
            Dim customerImpIndex As Int32 = 0
            customerImportPath = objLABO.Path_Import_CustInfo

            If Not customerImportPath Is String.Empty Then
                If customerImportPath.Substring(customerImportPath.Length - 1, 1) <> "\" Then
                    customerImportPath = customerImportPath + "\"
                End If
                arrayCustomerImpFolder = customerImportPath.Split("\")

                For customerImpIndex = 0 To arrayCustomerImpFolder.Length - 2
                    If customerImpIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If customerImportPath.Length > 2 Then
                            splChar = customerImportPath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayCustomerImpFolder(customerImpIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG039")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayCustomerImpFolder(customerImpIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG039")
                        ElseIf arrayCustomerImpFolder(customerImpIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG039")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If


            Dim customerBalImportPath As String = String.Empty
            Dim arrayCustomerBalImpFolder As Array
            Dim customerBalImpIndex As Int32 = 0
            customerBalImportPath = objLABO.Path_Import_CustBal

            If Not customerBalImportPath Is String.Empty Then
                If customerBalImportPath.Substring(customerBalImportPath.Length - 1, 1) <> "\" Then
                    customerBalImportPath = customerBalImportPath + "\"
                End If
                arrayCustomerBalImpFolder = customerBalImportPath.Split("\")

                For customerBalImpIndex = 0 To arrayCustomerBalImpFolder.Length - 2
                    If customerBalImpIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If customerBalImportPath.Length > 2 Then
                            splChar = customerBalImportPath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayCustomerBalImpFolder(customerBalImpIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG038")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayCustomerBalImpFolder(customerBalImpIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG038")
                        ElseIf arrayCustomerBalImpFolder(customerBalImpIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = objErrHandle.GetErrorDesc("MSG038")
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If


            If (strResult(0) <> "InValid") Then
                strResult = objLAServ.SaveConfiguration(objLABO)
            End If

            'strResult(0) = "0"
            'strResult(1) = ""


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfLA", "SaveConfiguration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function




End Class