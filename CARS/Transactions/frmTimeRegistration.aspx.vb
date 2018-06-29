Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmTimeRegistration
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objTimeRegDO As New CARS.CoreLibrary.CARS.TimeRegDetail.TimeRegDetailDO
    Shared objTimeRegServ As New CARS.CoreLibrary.CARS.Services.TimeRegDetail.TimeRegDet
    Shared objTimeRegBO As New TimeRegDetBO
    Shared details As New List(Of TimeRegDetBO)()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
    End Sub
    <WebMethod()> _
    Public Shared Function MechClockIn(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal clockIn As String, ByVal id_tr_seq As String, ByVal reas_code As String, ByVal comp_per As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
        Dim strResult As String = ""
        Dim mechDetails As New List(Of TimeRegDetBO)()
        Dim unsoldTimeText As String = String.Empty
        Dim UTime As Array
        If clockIn <> "L" Then
            If unsoldTime = "0" And ordNo = "" Then
                unsoldTimeText = objTimeRegServ.FetchDefUnsoldTime()
                UTime = unsoldTimeText.ToString.Split(";")
                unsoldTime = UTime(0)
            End If
        End If

        mechDetails = objTimeRegServ.MechanicExists(ordNo, jobNo, mechId, idWoLabSeq)
        If mechDetails.Count > 0 Then
            id_tr_seq = IIf(mechDetails(0).Id_Tr_Seq = Nothing, "0", mechDetails(0).Id_Tr_Seq)
        End If

        If unsoldTime = "0" Then
            unsoldTime = Nothing
        Else
            reas_code = Nothing
            comp_per = Nothing
        End If
        If ordNo = "" Then
            ordNo = Nothing
        End If
        If idWoLabSeq = "0" Then
            idWoLabSeq = Nothing
        End If
        If clockIn = "C" Then
            'id_tr_seq = 0
            reas_code = Nothing
            If Not unsoldTime Is Nothing Then
                ordNo = Nothing
                jobNo = 0
            End If
        ElseIf clockIn = "L" Then
            ordNo = Nothing
            jobNo = 0
        End If
        If id_tr_seq <> "0" Then
            If reas_code = "true" Then
                reas_code = 94
                comp_per = "100"
            Else
                reas_code = 91
                comp_per = "50"
            End If
        End If



        'If (id_tr_seq = 0 And unsoldTime <> "0") Or (id_tr_seq <> 0 And unsoldTime = "0") Then
        strResult = objTimeRegDO.Add_TimeRegDet(mechId, ordNo, jobNo, dtClockin, timeClockin, clockIn, id_tr_seq, reas_code, comp_per, idWoLabSeq, unsoldTime)
        ' End If
        Return strResult
    End Function
    <WebMethod()>
    Public Shared Function Mechanic_Search(ByVal q As String) As TimeRegDetBO()
        Dim mechDetails As New List(Of TimeRegDetBO)()
        Try
            mechDetails = objTimeRegServ.MechanicSearch(q)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "Mechanic_Search", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return mechDetails.ToList.ToArray
    End Function
    <WebMethod()> _
    Public Shared Function FetchJobDet(ByVal OrderNo As String) As TimeRegDetBO()
        Try
            details = objTimeRegServ.FetchJobDetGrd(OrderNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "FetchJobDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()>
    Public Shared Function LoadUnsoldTime() As TimeRegDetBO()
        Dim reasCode As New List(Of TimeRegDetBO)()
        Try
            reasCode = objTimeRegServ.FetchUnsoldTime()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "LoadUnsoldTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reasCode.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function MecDetExists(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal idWoLabSeq As String) As TimeRegDetBO()
        Dim mechDetails As New List(Of TimeRegDetBO)()
        Try
            If ordNo = "" Then
                ordNo = Nothing
            End If
            mechDetails = objTimeRegServ.MechanicExists(ordNo, jobNo, mechId, idWoLabSeq)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "MecDetExists", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return mechDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchMechanicDetails(ByVal mechId As String) As TimeRegDetBO()
        Try
            details = objTimeRegServ.Fetch_Mechanic_Details(mechId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "FetchMechanicDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    '<WebMethod()> _
    'Public Shared Function TimeReg_ManClockIn(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal dtClockout As String, ByVal timeClockout As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
    '    Dim strResult As String = ""
    '    Try
    '        strResult = objTimeRegDO.Add_ManualTimeRegDet(mechId, ordNo, jobNo, dtClockin, timeClockin, dtClockout, timeClockout, idWoLabSeq, unsoldTime)
    '    Catch ex As Exception
    '        objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "TimeReg_ManClockIn", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
    '    End Try
    '    Return strResult
    'End Function
    <WebMethod()> _
    Public Shared Function SearchMechanicDetails(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal mechName As String, ByVal searchDate As String, ByVal flgOrders As String, ByVal flgUnsold As String) As Collection
        Dim dt As New Collection
        Try

            If (mechId = "" And ordNo = "" And jobNo = "0" And searchDate = "") Then
                searchDate = System.DateTime.Today
                searchDate = commonUtil.GetCurrentLanguageDate(searchDate)
            End If

            If (searchDate <> "") Then
                'searchDate = commonUtil.GetCurrentLanguageDate(searchDate)
                searchDate = commonUtil.GetDefaultDate_MMDDYYYY(searchDate)
            Else
                searchDate = Nothing
            End If

            dt = objTimeRegServ.SearchMechanicDetails(mechId, mechName, searchDate, IIf(ordNo = "", Nothing, ordNo), IIf(ordNo = "", "0", jobNo), flgOrders, flgUnsold)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "SearchMechanicDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dt
    End Function
    <WebMethod()> _
    Public Shared Function FetchJobs(ByVal OrderNo As String) As TimeRegDetBO()
        Try
            details = objTimeRegServ.FetchJobs(OrderNo)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "FetchJobs", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function PrintSearchReport(ByVal mechId As String, ByVal mechName As String, ByVal orderNo As String, ByVal jobNo As String, ByVal fromDate As String, ByVal toDate As String, ByVal flgOrders As String, ByVal flgUnsold As String) As String

        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim idmr As String = "0"
        Dim searchTimeRegXML As String = String.Empty
        Try
            If (mechId = "" And orderNo = "" And jobNo = "0" And fromDate = "" And toDate = "") Then
                fromDate = System.DateTime.Today
                fromDate = commonUtil.GetCurrentLanguageDate(fromDate)

                toDate = System.DateTime.Today
                toDate = commonUtil.GetCurrentLanguageDate(toDate)
            End If

            If toDate <> "" Then
                toDate = commonUtil.GetDefaultDate_MMDDYYYY(toDate)
            Else
                toDate = ""
            End If
            If fromDate <> "" Then
                fromDate = commonUtil.GetDefaultDate_MMDDYYYY(fromDate)
            Else
                fromDate = ""
            End If

            searchTimeRegXML += "<ROOT> <Parameters " _
                            + " IV_MECH_CODE=""" + IIf(mechId = "", Nothing, mechId) + """ " _
                            + " IV_MECH_NAME=""" + IIf(mechName = "", Nothing, mechName) + """ " _
                            + " IV_FROM_DATE=""" + IIf(fromDate = "", Nothing, fromDate) + """ " _
                            + " IV_TO_DATE=""" + IIf(toDate = "", Nothing, toDate) + """ " _
                            + " IV_ID_WO_NO=""" + IIf(orderNo = "", Nothing, orderNo) + """ " _
                            + " IV_ID_JOB=""" + IIf(jobNo = "0", "0", jobNo) + """ " _
                            + " IV_ID_MR=""" + IIf(idmr = "0", "0", idmr) + """ " _
                            + " IV_ID_DEPT=""" + HttpContext.Current.Session("UserDept") + """ " _
                            + " IV_FLG_ORDERS=""" + flgOrders + """ " _
                            + " IV_FLG_UNSOLD=""" + flgUnsold + """ " _
                            + "/> </ROOT>"

            HttpContext.Current.Session("TimeRegCTPMechXML") = searchTimeRegXML
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("TimeRegCTPMech") + "&Rpt=" + commonUtil.fnEncryptQString("TimeRegCTPMech") + "&scrid=" + rnd.Next().ToString()

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "PrintReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
    <WebMethod()> _
    Public Shared Function PrintMechReport(ByVal mechId As String, ByVal mechName As String, ByVal orderNo As String, ByVal jobNo As String, ByVal fromDate As String, ByVal toDate As String, ByVal flgOrders As String, ByVal flgUnsold As String) As String

        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim idmr As String = "0"
        Dim mechTimeRegXML As String = String.Empty
        Try
            fromDate = System.DateTime.Today
            fromDate = commonUtil.GetCurrentLanguageDate(fromDate)
            toDate = System.DateTime.Today
            toDate = commonUtil.GetCurrentLanguageDate(toDate)


            If toDate <> "" Then
                toDate = commonUtil.GetDefaultDate_MMDDYYYY(toDate)
            Else
                toDate = ""
            End If
            If fromDate <> "" Then
                fromDate = commonUtil.GetDefaultDate_MMDDYYYY(fromDate)
            Else
                fromDate = ""
            End If

            mechTimeRegXML += "<ROOT> <Parameters " _
                            + " IV_MECH_CODE=""" + IIf(mechId = "", Nothing, mechId) + """ " _
                            + " IV_MECH_NAME=""" + IIf(mechName = "", Nothing, mechName) + """ " _
                            + " IV_FROM_DATE=""" + IIf(fromDate = "", Nothing, fromDate) + """ " _
                            + " IV_TO_DATE=""" + IIf(toDate = "", Nothing, toDate) + """ " _
                            + " IV_ID_WO_NO=""" + IIf(orderNo = "", Nothing, orderNo) + """ " _
                            + " IV_ID_JOB=""" + IIf(jobNo = "0", "0", jobNo) + """ " _
                            + " IV_ID_MR=""" + IIf(idmr = "0", "0", idmr) + """ " _
                            + " IV_ID_DEPT=""" + HttpContext.Current.Session("UserDept") + """ " _
                            + " IV_FLG_ORDERS=""" + flgOrders + """ " _
                            + " IV_FLG_UNSOLD=""" + flgUnsold + """ " _
                            + "/> </ROOT>"

            HttpContext.Current.Session("TimeRegMechXML") = mechTimeRegXML
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("TimeRegMech") + "&Rpt=" + commonUtil.fnEncryptQString("TimeRegMech") + "&scrid=" + rnd.Next().ToString()

            'End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transaction_TimeRegistration", "PrintReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function
End Class