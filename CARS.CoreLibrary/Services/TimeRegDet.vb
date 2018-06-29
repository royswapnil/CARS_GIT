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
Namespace CARS.Services.TimeRegDetail
    Public Class TimeRegDet
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objTimeRegDO As New CARS.TimeRegDetail.TimeRegDetailDO
        Shared objTimeRegBO As New TimeRegDetBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Public Function MechanicSearch(ByVal q As String) As List(Of TimeRegDetBO)
            Dim dsMechanic As New DataSet
            Dim dtMechanic As DataTable
            Dim mechanicSearchResult As New List(Of TimeRegDetBO)()
            Try
                dsMechanic = objTimeRegDO.Mechanic_Search(q)
                If dsMechanic.Tables.Count > 0 Then
                    dtMechanic = dsMechanic.Tables(0)

                    If q <> String.Empty Then
                        For Each dtrow As DataRow In dtMechanic.Rows
                            Dim msr As New TimeRegDetBO()
                            msr.Id_Login = dtrow("ID_LOGIN").ToString
                            msr.Mech_FirstName = dtrow("FIRST_NAME").ToString
                            msr.Login_Name = dtrow("LOGIN_NAME").ToString
                            mechanicSearchResult.Add(msr)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "MechanicSearch", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return mechanicSearchResult
        End Function
        Public Function FetchJobDetGrd(ByVal OrdNo As String) As List(Of TimeRegDetBO)
            Dim dsMechanic As New DataSet
            Dim dtMechanic As DataTable
            Dim mechanicSearchResult As New List(Of TimeRegDetBO)()
            Try
                dsMechanic = objTimeRegDO.JobDetGrid(OrdNo)

                If dsMechanic.Tables.Count > 0 Then
                    dtMechanic = dsMechanic.Tables(0)

                    If OrdNo <> String.Empty Then
                        For Each dtrow As DataRow In dtMechanic.Rows
                            Dim msr As New TimeRegDetBO()
                            msr.Job_LineNo = dtrow("JOBLINENO").ToString
                            msr.Lab_Desc = dtrow("WO_LABOUR_DESC").ToString
                            msr.Id_WoLab_Seq = dtrow("ID_WOLAB_SEQ").ToString
                            mechanicSearchResult.Add(msr)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchJobDetGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return mechanicSearchResult
        End Function
        Public Function FetchUnsoldTime() As List(Of TimeRegDetBO)
            Dim dsUnsoldTime As New DataSet
            Dim dtUnsoldTime As DataTable
            Dim unsoldTime As New List(Of TimeRegDetBO)()
            Try
                dsUnsoldTime = objTimeRegDO.FetchTimeRegSettings()
                dtUnsoldTime = dsUnsoldTime.Tables(0)
                For Each dtrow As DataRow In dtUnsoldTime.Rows
                    Dim unsoldTimeDet As New TimeRegDetBO()
                    unsoldTimeDet.Id_Settings = dtrow("ID_SETTINGS").ToString()
                    unsoldTimeDet.Description = dtrow("DESCRIPTION").ToString()
                    unsoldTime.Add(unsoldTimeDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchUnsoldTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return unsoldTime.ToList
        End Function
        Public Function MechanicExists(ByVal ordNo As String, ByVal jobNo As String, ByVal mechId As String, ByVal idWoLabSeq As String) As List(Of TimeRegDetBO)
            Dim dsMech As New DataSet
            Dim dtMech As DataTable
            Dim mechanicRes As New List(Of TimeRegDetBO)()
            Try
                dsMech = objTimeRegDO.CheckMecExists(IIf(ordNo = "", Nothing, ordNo), jobNo, mechId, idWoLabSeq)
                If dsMech.Tables.Count > 0 Then
                    Dim mechDet As New TimeRegDetBO()
                    If dsMech.Tables(0).Rows.Count > 0 Then
                        dtMech = dsMech.Tables(0)
                        For Each dtrow As DataRow In dtMech.Rows
                            'If (IIf(IsDBNull(dtrow("ID_WOLAB_SEQ")) = True, "0", dtrow("ID_WOLAB_SEQ")) = idWoLabSeq) Then
                            mechDet.Id_Tr_Seq = dtrow("ID_TR_SEQ").ToString()
                            mechDet.Dt_clockin = IIf(IsDBNull(dtrow("CLOCKIN_DATE")) = True, "", dtrow("CLOCKIN_DATE"))
                            mechDet.Dt_clockin = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockin)
                            mechDet.Dt_clockout = System.DateTime.Today
                            mechDet.Dt_clockout = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockout)
                            mechDet.Time_clockin = IIf(IsDBNull(dtrow("CLOCKIN_TIME")) = True, "", dtrow("CLOCKIN_TIME"))
                            mechDet.Time_clockout = DateAndTime.TimeOfDay
                            mechDet.Id_UnsoldTime = IIf(IsDBNull(dtrow("ID_UNSOLD_TIME")) = True, "0", dtrow("ID_UNSOLD_TIME"))
                            mechDet.Id_WoLab_Seq = IIf(IsDBNull(dtrow("ID_WOLAB_SEQ")) = True, "0", dtrow("ID_WOLAB_SEQ"))
                            'Else
                            '    If Not (IIf(IsDBNull(dtrow("ID_UNSOLD_TIME")) = True, "0", dtrow("ID_UNSOLD_TIME"))) Is Nothing And (IIf(IsDBNull(dtrow("ID_WOLAB_SEQ")) = True, "0", dtrow("ID_WOLAB_SEQ")) = "0") Then
                            '        mechDet.Id_Tr_Seq = dtrow("ID_TR_SEQ").ToString()
                            '    End If
                            If (IIf(IsDBNull(dtrow("ID_WOLAB_SEQ")) = True, "0", dtrow("ID_WOLAB_SEQ")) <> idWoLabSeq) Then
                                mechDet.Dt_clockin = System.DateTime.Today
                                mechDet.Dt_clockin = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockin)
                                mechDet.Time_clockin = DateAndTime.TimeOfDay 'IIf(IsDBNull(dtrow("CLOCKIN_TIME")) = True, "", dtrow("CLOCKIN_TIME"))
                                mechDet.Dt_clockout = Nothing
                                mechDet.Time_clockout = Nothing
                            End If

                        Next
                    Else
                        mechDet.Id_Tr_Seq = Nothing
                        mechDet.Dt_clockin = System.DateTime.Today
                        mechDet.Dt_clockin = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockin)
                        mechDet.Time_clockin = DateAndTime.TimeOfDay 'IIf(IsDBNull(dtrow("CLOCKIN_TIME")) = True, "", dtrow("CLOCKIN_TIME"))
                    End If
                    mechanicRes.Add(mechDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "MechanicExists", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return mechanicRes.ToList
        End Function
        Public Function Fetch_Mechanic_Details(ByVal mechId As String) As List(Of TimeRegDetBO)
            Dim dsMech As New DataSet
            Dim dtMech As DataTable
            Dim mechanicRes As New List(Of TimeRegDetBO)()
            Try
                dsMech = objTimeRegDO.Fetch_Mechanic_Details(mechId)
                If dsMech.Tables.Count > 0 Then

                    If dsMech.Tables(0).Rows.Count > 0 Then
                        dtMech = dsMech.Tables(0)
                        For Each dtrow As DataRow In dtMech.Rows
                            Dim mechDet As New TimeRegDetBO()
                            mechDet.Id_Tr_Seq = dtrow("ID_TR").ToString()
                            mechDet.Dt_clockin = IIf(IsDBNull(dtrow("CLOCKIN_DATE")) = True, "", dtrow("CLOCKIN_DATE"))
                            mechDet.Dt_clockin = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockin)
                            mechDet.Dt_clockout = IIf(IsDBNull(dtrow("CLOCKOUT_DATE")) = True, "", dtrow("CLOCKOUT_DATE"))
                            mechDet.Dt_clockout = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockout)
                            mechDet.Time_clockin = IIf(IsDBNull(dtrow("CLOCK IN TIME")) = True, "", dtrow("CLOCK IN TIME"))
                            mechDet.Time_clockout = IIf(IsDBNull(dtrow("CLOCK OUT TIME")) = True, "", dtrow("CLOCK OUT TIME"))
                            mechDet.OrderNo = IIf(IsDBNull(dtrow("ORDER ID")) = True, "", dtrow("ORDER ID"))
                            mechDet.JobNo = IIf(IsDBNull(dtrow("JOB ID")) = True, "", dtrow("JOB ID"))
                            mechDet.UnsoldTime = IIf(IsDBNull(dtrow("Unsold Time")) = True, "", dtrow("Unsold Time"))
                            mechDet.LineNo = IIf(IsDBNull(dtrow("LINE_NO")) = True, "", dtrow("LINE_NO"))
                            mechDet.IdMech = IIf(IsDBNull(dtrow("ID_MEC")) = True, "", dtrow("ID_MEC"))
                            mechDet.MechName = IIf(IsDBNull(dtrow("MECH_NAME")) = True, "", dtrow("MECH_NAME"))
                            mechDet.TotalClockedTime = IIf(IsDBNull(dtrow("Total_Clocked_Time")) = True, "0", dtrow("Total_Clocked_Time"))
                            mechDet.Id_WoLab_Seq = IIf(IsDBNull(dtrow("Id_Wo_Lab_Seq")) = True, "0", dtrow("Id_Wo_Lab_Seq"))
                            If (mechDet.OrderNo <> "") Then
                                mechDet.Text = IIf(IsDBNull(dtrow("WO_LABOUR_DESC")) = True, "", dtrow("WO_LABOUR_DESC"))
                            Else
                                mechDet.Text = IIf(IsDBNull(dtrow("Unsold Time")) = True, "", dtrow("Unsold Time"))
                                mechDet.LineNo = ""
                            End If
                            If dsMech.Tables(1).Rows.Count > 0 Then
                                mechDet.TotalTimeOnOrder = IIf(IsDBNull(dsMech.Tables(1).Rows(0)("TOTAL TIME ON ORDER")) = True, "", dsMech.Tables(1).Rows(0)("TOTAL TIME ON ORDER"))
                                mechDet.TotalTimeUnsold = IIf(IsDBNull(dsMech.Tables(1).Rows(0)("TOTAL TIME UNSOLD")) = True, "", dsMech.Tables(1).Rows(0)("TOTAL TIME UNSOLD"))
                            End If
                            mechanicRes.Add(mechDet)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "Fetch_Mechanic_Details", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return mechanicRes.ToList
        End Function
        Public Function FetchDefUnsoldTime() As String
            Dim dsUnsoldTime As New DataSet
            Dim dtUnsoldTime As DataTable
            Dim idUnsoldTime As String = ""
            Dim unsoldTimeDesc As String = ""
            Dim unsoldTime As String = ""

            Try
                dsUnsoldTime = objTimeRegDO.FetchDefUnsoldTime()
                dtUnsoldTime = dsUnsoldTime.Tables(0)
                idUnsoldTime = dsUnsoldTime.Tables(0).Rows(0)("ID_SETTINGS")
                unsoldTimeDesc = dsUnsoldTime.Tables(0).Rows(0)("DESCRIPTION")
                unsoldTime = idUnsoldTime + ";" + unsoldTimeDesc

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchDefUnsoldTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return unsoldTime
        End Function
        Public Function Add_ManualTimeRegDet(ByVal mechId As String, ByVal ordNo As String, ByVal jobNo As String, ByVal dtClockin As String, ByVal timeClockin As String, ByVal dtClockout As String, ByVal timeClockout As String, ByVal idWoLabSeq As String, ByVal unsoldTime As String) As String
            Dim dsMech As New DataSet
            Dim dtMech As DataTable
            Dim manualmechRes As New List(Of TimeRegDetBO)()
            Dim strRes As String
            Dim strMClkInExist As String = String.Empty
            Dim id_tr_seq As String = "0"  'Add
            Dim status As String = ""
            Dim dsMechExist As New DataSet
            Try
                Dim dsFr As String = objCommonUtil.GetDefaultDate_MMDDYYYY(dtClockin)
                Dim dsTo As String = objCommonUtil.GetDefaultDate_MMDDYYYY(dtClockout)

                Dim dtF As DateTime = objCommonUtil.GetCurrentLanguageDate(dsFr)
                Dim dtT As DateTime = objCommonUtil.GetCurrentLanguageDate(dsTo)

                Dim sFrom As String = timeClockin '"10:35:00"
                Dim sTo As String = timeClockout '"12:50:00"
                Dim strFrmDatetime As String = dtF.ToShortDateString & " " & sFrom
                Dim dtFrmDatetime As DateTime = DateTime.Parse(strFrmDatetime)
                Dim strToDatetime As String = dtT.ToShortDateString & " " & sTo
                Dim dtToDatetime As DateTime = DateTime.Parse(strToDatetime)

                Dim tSpan As TimeSpan = dtToDatetime - dtFrmDatetime
                Dim nDay As Integer = tSpan.Days
                Dim nHour As Integer = tSpan.Hours
                Dim nMin As Integer = tSpan.Minutes
                Dim nSec As Integer = tSpan.Seconds
                If nDay < 0 Or nHour < 0 Or nMin < 0 Then
                    strRes = "TODATE_LESS_FROMDATE"
                ElseIf (nDay > 1) Then
                    strRes = "TODATE_GRTR_DAY"
                ElseIf (nDay = 1 And nHour > 0) Or (nDay = 1 And nMin > 0) Then
                    strRes = "TOTIME_GRTR_FRMTIME"
                Else
                    strMClkInExist = objTimeRegDO.checkMechClkIn(id_tr_seq, mechId, ordNo, jobNo, dsFr, timeClockin, dsTo, timeClockout, idWoLabSeq, unsoldTime, status)
                    If strMClkInExist.Trim = "TRUE" Then
                        strRes = objErrHandle.GetErrorDesc("MECHCLKINEXIST") 'objErrHandle.GetErrorDesc("INVWRN").ToString '
                    Else
                        strRes = objTimeRegDO.Add_ManualTimeRegDet(mechId, ordNo, jobNo, dsFr, timeClockin, dsTo, timeClockout, idWoLabSeq, unsoldTime)
                    End If
                    End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "Add_ManualTimeRegDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function FetchInvoiceTime(ByVal OrdNo As String, ByVal idWoLabSeq As String) As List(Of TimeRegDetBO)
            Dim dsInvtime As New DataSet
            Dim dtInvtime As DataTable
            Dim invtimeResult As New List(Of TimeRegDetBO)()
            Try
                dsInvtime = objTimeRegDO.Fetch_InvTime(OrdNo, idWoLabSeq)

                If dsInvtime.Tables.Count > 0 Then
                    dtInvtime = dsInvtime.Tables(0)

                    For Each dtrow As DataRow In dtInvtime.Rows
                        Dim invTime As New TimeRegDetBO()
                        invTime.Wo_Lab_Hrs = dtrow("WO_LABOUR_HOURS").ToString
                        invtimeResult.Add(invTime)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchInvoiceTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return invtimeResult
        End Function
        Public Function FetchClockTime(ByVal ClockIn As String, ByVal ClockOut As String) As List(Of TimeRegDetBO)
            Dim dsClktime As New DataSet
            Dim dtclktime As DataTable
            Dim clktimeResult As New List(Of TimeRegDetBO)()
            Try
                dsClktime = objTimeRegDO.Fetch_clkTime(ClockIn, ClockOut)

                If dsClktime.Tables.Count > 0 Then
                    dtclktime = dsClktime.Tables(0)

                    For Each dtrow As DataRow In dtclktime.Rows
                        Dim clkTime As New TimeRegDetBO()
                        clkTime.Clocked_Time = dtrow("CLOCKED TIME").ToString
                        clktimeResult.Add(clkTime)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchClockTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return clktimeResult
        End Function
        Public Function SearchMechanicDetails(ByVal mechId As String, ByVal mechName As String, ByVal fromDate As String, ByVal orderNo As String, ByVal jobNo As String, ByVal flgOrders As String, ByVal flgUnsold As String) As Collection
            Dim dsMech As New DataSet
            Dim dtMech As DataTable
            Dim dtTotals As DataTable

            Dim dtResults As New Collection
            Try
                dsMech = objTimeRegDO.SearchMechanicDetails(mechId, mechName, fromDate, orderNo, jobNo, flgOrders, flgUnsold)
                If dsMech.Tables.Count > 0 Then

                    If dsMech.Tables(0).Rows.Count > 0 Then
                        dtMech = dsMech.Tables(0)
                        Dim mechanicRes As New List(Of TimeRegDetBO)()
                        For Each dtrow As DataRow In dtMech.Rows
                            Dim mechDet As New TimeRegDetBO()
                            mechDet.Id_Tr_Seq = dtrow("ID_TR").ToString()
                            mechDet.Dt_clockin = IIf(IsDBNull(dtrow("CLOCKIN_DATE")) = True, "", dtrow("CLOCKIN_DATE"))
                            mechDet.Dt_clockin = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockin)
                            mechDet.Dt_clockout = IIf(IsDBNull(dtrow("CLOCKOUT_DATE")) = True, "", dtrow("CLOCKOUT_DATE"))
                            mechDet.Dt_clockout = objCommonUtil.GetCurrentLanguageDate(mechDet.Dt_clockout)
                            mechDet.Time_clockin = IIf(IsDBNull(dtrow("CLOCK IN TIME")) = True, "", dtrow("CLOCK IN TIME"))
                            mechDet.Time_clockout = IIf(IsDBNull(dtrow("CLOCK OUT TIME")) = True, "", dtrow("CLOCK OUT TIME"))
                            mechDet.OrderNo = IIf(IsDBNull(dtrow("ORDER ID")) = True, "", dtrow("ORDER ID"))
                            mechDet.JobNo = IIf(IsDBNull(dtrow("JOB ID")) = True, "", dtrow("JOB ID"))
                            mechDet.UnsoldTime = IIf(IsDBNull(dtrow("Unsold Time")) = True, "", dtrow("Unsold Time"))
                            mechDet.LineNo = IIf(IsDBNull(dtrow("LINE_NO")) = True, "", dtrow("LINE_NO"))
                            mechDet.IdMech = IIf(IsDBNull(dtrow("ID_MEC")) = True, "", dtrow("ID_MEC"))
                            mechDet.MechName = IIf(IsDBNull(dtrow("MECH_NAME")) = True, "", dtrow("MECH_NAME"))
                            mechDet.TotalClockedTime = IIf(IsDBNull(dtrow("Total_Clocked_Time")) = True, "0", dtrow("Total_Clocked_Time"))
                            mechDet.Id_WoLab_Seq = IIf(IsDBNull(dtrow("Id_Wo_Lab_Seq")) = True, "0", dtrow("Id_Wo_Lab_Seq"))
                            If (mechDet.OrderNo <> "") Then
                                mechDet.Text = IIf(IsDBNull(dtrow("WO_LABOUR_DESC")) = True, "", dtrow("WO_LABOUR_DESC"))
                            Else
                                mechDet.Text = IIf(IsDBNull(dtrow("Unsold Time")) = True, "", dtrow("Unsold Time"))
                            End If
                            mechanicRes.Add(mechDet)
                        Next
                        dtResults.Add(mechanicRes)
                    End If

                    If dsMech.Tables(1).Rows.Count > 0 Then
                        dtTotals = dsMech.Tables(1)
                        Dim mechanicRes As New List(Of TimeRegDetBO)()
                        For Each dtrow As DataRow In dtTotals.Rows
                            Dim mechDet As New TimeRegDetBO()
                            mechDet.TotalTimeOnOrder = IIf(IsDBNull(dtrow("TOTAL TIME ON ORDER")) = True, "", dtrow("TOTAL TIME ON ORDER"))
                            mechDet.TotalTimeUnsold = IIf(IsDBNull(dtrow("TOTAL TIME UNSOLD")) = True, "", dtrow("TOTAL TIME UNSOLD"))
                            mechanicRes.Add(mechDet)
                        Next
                        dtResults.Add(mechanicRes)
                    End If

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "SearchMechanicDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtResults
        End Function
        Public Function FetchJobs(ByVal OrdNo As String) As List(Of TimeRegDetBO)
            Dim dsMechanic As New DataSet
            Dim dtMechanic As DataTable
            Dim mechanicSearchResult As New List(Of TimeRegDetBO)()
            Try
                dsMechanic = objTimeRegDO.FetchJobs(OrdNo)

                If dsMechanic.Tables.Count > 0 Then
                    dtMechanic = dsMechanic.Tables(0)

                    If OrdNo <> String.Empty Then
                        For Each dtrow As DataRow In dtMechanic.Rows
                            Dim msr As New TimeRegDetBO()
                            msr.JobNo = dtrow("ID_JOB").ToString
                            mechanicSearchResult.Add(msr)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "TimeRegDet.vb", "FetchJobs", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return mechanicSearchResult
        End Function
    End Class
End Namespace
