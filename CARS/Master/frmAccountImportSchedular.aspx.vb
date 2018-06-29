Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmAccountImportSchedular
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objAccntConfigSchedulerBO As New AccountConfigSchedulerBO
    Shared objAccntConfigSchedulerServ As New Services.AccountConfigScheduler.AccountConfigScheduler
    Shared details As New List(Of AccountConfigSchedulerBO)()
    Shared configdetails As New List(Of AccountConfigSchedulerBO)()
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
            ddlBalWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlBalWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlBalMonthly.Items.Clear()
            For i = 1 To 31
                ddlBalMonthly.Items.Add(i)
            Next

            ddlCustWeeklyEvery.Items.Clear()
            For i = 1 To 7
                ddlCustWeeklyEvery.Items.Add(WeekdayName(i))
            Next
            ddlCustMonthly.Items.Clear()
            For i = 1 To 31
                ddlCustMonthly.Items.Add(i)
            Next

            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpBalance_Everyhour)
            commonUtil.ddlGetValue(IO.Path.GetFileName(Me.Request.PhysicalPath), drpCustomer_Everyhour)
            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmAccountImportSchedular", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadAccntImportScheduler() As Collection
        Dim details As New Collection
        Try
            details = objAccntConfigSchedulerServ.FetchAccountConfigScheduler()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmAccountImportSchedular", "LoadAccntImportScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function

    <WebMethod()> _
    Public Shared Function SaveAccntImportScheduler(ByVal balFileLocation As String, ByVal balFileName As String, ByVal balImportType As String, ByVal balArchiveDays As String, ByVal schBalBasis As String, ByVal schBalDailyTimeFormat As String, ByVal schBalDailyIntMins As String, ByVal schBalDailyStTime As String, ByVal schBalDailyEndTime As String, ByVal schBalWeekDay As String, ByVal schBalWeekTime As String, ByVal schBalMonthDay As String, ByVal schBalMonthTime As String, ByVal custFileLocation As String, ByVal custFileName As String, ByVal custImportType As String, ByVal schCustBasis As String, ByVal schCustDailyTimeFormat As String, ByVal schCustDailyIntMins As String, ByVal schCustDailyStTime As String, ByVal schCustDailyEndTime As String, ByVal schCustWeekDay As String, ByVal schCustWeekTime As String, ByVal schCustMonthDay As String, ByVal schCustMonthTime As String) As String()
        'ByVal expInvjournalPath As String, ByVal expCustInfoPath As String, ByVal impCustInfoPath As String, ByVal impCustBalancePath As String, ByVal expInvJrnlSeqNo As String, ByVal expCustSeqNo As String, ByVal customerId As String, ByVal custOrderNo As String, ByVal custRegNo As String, ByVal custVINNo As String, ByVal custVINNoLen As String, ByVal custName As String, ByVal custFixedText As String, ByVal invJrnlTemp As String, ByVal custInfoTemp As String, ByVal useInvNoSort As String, ByVal useCRExp As String, ByVal useBLSpaces As String, ByVal useCombLines As String, ByVal useSplit As String, ByVal addDate As String, ByVal remCostStckfromInv As String, ByVal flgAddText As String, ByVal flgAdditionalText As String, ByVal addText As String, ByVal additionalText As String, ByVal flgCustText As String, ByVal custText As String, ByVal flgVoucherType As String, ByVal voucherType As String, ByVal flgDisplayAllInvNum As String, ByVal fixedPriceAccntCode As String, ByVal flgExpValid As String, ByVal errorInvoicesName As String, ByVal suffixFileNameExpInvJrnl As String, ByVal prefixFileNameExpInvJrnl As String, ByVal prefixFileNameExpCustInfo As String, ByVal suffixFileNameExpCustInfo As String, ByVal schBasis As String, ByVal schDailyTimeFormat As String, ByVal schDailyIntMins As String, ByVal schDailyStTime As String, ByVal schDailyEndTime As String, ByVal schWeekDay As String, ByVal schWeekTime As String, ByVal schMonthDay As String, ByVal schMonthTime As String) As String()
        Dim strResult(1) As String
        Try
            balFileLocation = balFileLocation.Replace("/", "\")
            objAccntConfigSchedulerBO.Balance_FileLocation = balFileLocation
            objAccntConfigSchedulerBO.Balance_File_Name = balFileName
            objAccntConfigSchedulerBO.Balance_ArchiveDays = balArchiveDays
            objAccntConfigSchedulerBO.Balance_Sch_Basis = schBalBasis
            objAccntConfigSchedulerBO.Balance_Sch_TimeFormat = schBalDailyTimeFormat
            objAccntConfigSchedulerBO.Balance_Sch_Daily_Interval_mins = schBalDailyIntMins
            objAccntConfigSchedulerBO.Balance_Sch_Week_Day = schBalWeekDay
            objAccntConfigSchedulerBO.Balance_Sch_Month_Day = schBalMonthDay
            objAccntConfigSchedulerBO.Balance_Sch_Daily_STime = schBalDailyStTime
            objAccntConfigSchedulerBO.Balance_Sch_Daily_ETime = schBalDailyEndTime
            objAccntConfigSchedulerBO.Balance_Sch_Week_Time = schBalWeekTime
            objAccntConfigSchedulerBO.Balance_Sch_Month_Time = schBalMonthTime
            objAccntConfigSchedulerBO.Customer_FileLocation = custFileLocation.Replace("/", "\")
            objAccntConfigSchedulerBO.Customer_File_Name = custFileName
            objAccntConfigSchedulerBO.Customer_Sch_Basis = schCustBasis
            objAccntConfigSchedulerBO.Customer_Sch_TimeFormat = schCustDailyTimeFormat
            objAccntConfigSchedulerBO.Customer_Sch_Daily_Interval_mins = schCustDailyIntMins
            objAccntConfigSchedulerBO.Customer_Sch_Week_Day = schCustWeekDay
            objAccntConfigSchedulerBO.Customer_Sch_Month_Day = schCustMonthDay
            objAccntConfigSchedulerBO.Customer_Sch_Daily_STime = schCustDailyStTime
            objAccntConfigSchedulerBO.Customer_Sch_Daily_ETime = schCustDailyEndTime
            objAccntConfigSchedulerBO.Customer_Sch_Week_Time = schCustWeekTime
            objAccntConfigSchedulerBO.Customer_Sch_Month_Time = schCustMonthTime
            objAccntConfigSchedulerBO.Balance_Template = balImportType
            objAccntConfigSchedulerBO.Customer_Template = custImportType


            Dim balanceFileLocation As String = String.Empty
            Dim arrayInvoiceFolder As Array
            Dim invoiceIndex As Int32 = 0
            balanceFileLocation = objAccntConfigSchedulerBO.Balance_FileLocation.Trim

            If Not balanceFileLocation Is String.Empty Then
                If balanceFileLocation.Substring(balanceFileLocation.Length - 1, 1) <> "\" Then
                    balanceFileLocation = balanceFileLocation + "\"
                End If
                arrayInvoiceFolder = balanceFileLocation.Split("\")

                For invoiceIndex = 0 To arrayInvoiceFolder.Length - 2
                    If invoiceIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If balanceFileLocation.Length > 2 Then
                            splChar = balanceFileLocation.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayInvoiceFolder(invoiceIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayInvoiceFolder(invoiceIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        ElseIf arrayInvoiceFolder(invoiceIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If

            Dim customerFilePath As String = String.Empty
            Dim arrayCustomerFolder As Array
            Dim customerIndex As Int32 = 0
            customerFilePath = objAccntConfigSchedulerBO.Customer_FileLocation.Trim

            If Not customerFilePath Is String.Empty Then
                If customerFilePath.Substring(customerFilePath.Length - 1, 1) <> "\" Then
                    customerFilePath = customerFilePath + "\"
                End If
                arrayCustomerFolder = customerFilePath.Split("\")

                For customerIndex = 0 To arrayCustomerFolder.Length - 2
                    If customerIndex = 0 Then
                        Dim splChar As String = String.Empty
                        If customerFilePath.Length > 2 Then
                            splChar = customerFilePath.Substring(2, 1)
                        End If
                        If Not Regex.IsMatch(arrayCustomerFolder(customerIndex) + splChar, "^([a-zA-Z]:\\)+") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    Else
                        If Not Regex.IsMatch(arrayCustomerFolder(customerIndex), "^[^\\\/\?\*\""\'\>\<\:\|]*$") Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        ElseIf arrayCustomerFolder(customerIndex) = "" Then
                            strResult(0) = "InValid"
                            strResult(1) = ""
                            Return strResult
                        Else
                            strResult(0) = "Valid"
                            strResult(1) = ""
                        End If
                    End If
                Next
            End If

            If (strResult(0) <> "InValid") Then
                strResult = objAccntConfigSchedulerServ.SaveAccountConfigScheduler(objAccntConfigSchedulerBO)
            End If

            'strResult(0) = "0"
            'strResult(1) = ""


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmAccountImportSchedular", "SaveAccntImportScheduler", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/Master/frmAccountImportSchedular.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnSave.Disabled = Convert.ToBoolean(IIf(btnSave.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                End If
            End If
        End If
    End Sub
End Class