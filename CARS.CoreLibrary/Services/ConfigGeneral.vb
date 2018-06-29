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
Namespace CARS.Services.ConfigGeneral
    Public Class ConfigGeneral
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Shared objConfigZipCodesBO As New ZipCodesBO
        Shared objConfigZipCodeDO As New CARS.ZipCodes.ZipCodesDO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO

        Public Function FetchAllZipCode() As Collection
            Dim dsConfigZipCode As New DataSet
            Dim dtConfigZipCode As New DataTable
            Dim dtConfigZCColl As New Collection
            Try
                dsConfigZipCode = objConfigZipCodeDO.Fetch_AllZipCode()
                HttpContext.Current.Session("AllZipCodes") = dsConfigZipCode

                If dsConfigZipCode.Tables.Count > 0 Then
                    'ZipCodes
                    If (dsConfigZipCode.Tables(0).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(0)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim zipCode As New ZipCodesBO()
                            zipCode.ZipCode = dtrow("ZipCode").ToString()
                            zipCode.Country = dtrow("Country").ToString()
                            zipCode.State = IIf(IsDBNull(dtrow("State")) = True, "", dtrow("State"))
                            zipCode.City = IIf(IsDBNull(dtrow("City")) = True, "", dtrow("City"))
                            details.Add(zipCode)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(0).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(0)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'Currency
                    If (dsConfigZipCode.Tables(1).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(1)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim currency As New ZipCodesBO()
                            currency.IdParam = dtrow("ID_PARAM").ToString()
                            currency.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(currency)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(1).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(1)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'Time Format
                    If (dsConfigZipCode.Tables(2).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(2)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim timeFormat As New ZipCodesBO()
                            timeFormat.Description = dtrow("DESCRIPTION").ToString()
                            HttpContext.Current.Session("TimeFormat") = dtrow("DESCRIPTION").ToString()
                            details.Add(timeFormat)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(2).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(2)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'Unit of Timings
                    If (dsConfigZipCode.Tables(3).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(3)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim unitTime As New ZipCodesBO()
                            unitTime.Description = dtrow("DESCRIPTION").ToString()
                            HttpContext.Current.Session("UnitofTimings") = dtrow("DESCRIPTION").ToString()
                            details.Add(unitTime)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(3).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(3)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'Current Currency set
                    If (dsConfigZipCode.Tables(4).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(4)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                           Dim currency As New ZipCodesBO()
                            currency.IdParam = dtrow("ID_PARAM").ToString()
                            currency.Description = dtrow("DESCRIPTION").ToString()
                            HttpContext.Current.Session("Currency") = dtrow("ID_PARAM").ToString()
                            details.Add(currency)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(4).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(4)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'Minimum Splitting Time
                    If (dsConfigZipCode.Tables(5).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(5)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim minST As New ZipCodesBO()
                            minST.Description = dtrow("DESCRIPTION").ToString()
                            HttpContext.Current.Session("MinimumSpilts") = dtrow("DESCRIPTION").ToString()
                            details.Add(minST)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(5).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(5)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USESUBREPC
                    If (dsConfigZipCode.Tables(6).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(6)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("SubRepairCode") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(6).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(6)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEDAYPLAN
                    If (dsConfigZipCode.Tables(7).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(7)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("SubDayPlanCode") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(7).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(7)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEJOBCARD
                    If (dsConfigZipCode.Tables(8).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(8)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("JobCard") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(8).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(8)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'EDITSTDTIM
                    If (dsConfigZipCode.Tables(9).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(9)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("EditStdTim") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(9).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(9)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'VIEWGARSUM
                    If (dsConfigZipCode.Tables(10).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(10)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("ViewGarSum") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(10).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(10)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'MONASSTAT
                    If (dsConfigZipCode.Tables(11).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(11)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("MonAsStart") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(11).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(11)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'VEHREGNDP
                    If (dsConfigZipCode.Tables(12).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(12)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("VehRegnDP") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(12).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(12)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEINVPDF
                    If (dsConfigZipCode.Tables(13).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(13)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("UseInvPDF") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(13).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(13)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEDYNCLKT
                    If (dsConfigZipCode.Tables(14).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(14)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("DynClkTime") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(14).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(14)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEDBS
                    If (dsConfigZipCode.Tables(15).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(15)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("UseDBSLnk") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(15).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(15)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEAPPROVE
                    If (dsConfigZipCode.Tables(16).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(16)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("UseApprove") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(16).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(16)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'USEMECGRID
                    If (dsConfigZipCode.Tables(17).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(17)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("UseMechGrid") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(17).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(17)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'SORTBYLOC
                    If (dsConfigZipCode.Tables(18).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(18)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("SortByLoc") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(18).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(18)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'VLDSTDTIME
                    If (dsConfigZipCode.Tables(19).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(19)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("ValidateStdTime") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(19).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(19)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'EDTCHGTIME
                    If (dsConfigZipCode.Tables(20).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(20)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("EditChgTime") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(20).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(20)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'VLDMILEAGE
                    If (dsConfigZipCode.Tables(21).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(21)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("ValidateMileage") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(21).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(21)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'SAVEUPDDP
                    If (dsConfigZipCode.Tables(22).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(22)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("SAVEUPDDP") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(22).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(22)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'INT-NOTE
                    If (dsConfigZipCode.Tables(23).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(23)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("DispIntNote") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(23).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(23)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'GRP-SP-BO
                    If (dsConfigZipCode.Tables(24).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(24)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("GrpSpBO") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(24).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(24)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                    'DISWOSPARE
                    If (dsConfigZipCode.Tables(25).Rows.Count > 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(25)
                        Dim details As New List(Of ZipCodesBO)()
                        For Each dtrow As DataRow In dtConfigZipCode.Rows
                            Dim desc As New ZipCodesBO()
                            desc.Description = dtrow("DESCRIPTION").ToString().ToLower()
                            HttpContext.Current.Session("DispWoSpares") = dtrow("DESCRIPTION").ToString().ToLower()
                            details.Add(desc)
                        Next
                        dtConfigZCColl.Add(details)
                    ElseIf (dsConfigZipCode.Tables(25).Rows.Count = 0) Then
                        dtConfigZipCode = dsConfigZipCode.Tables(25)
                        Dim details As New List(Of ZipCodesBO)()
                        dtConfigZCColl.Add(details)
                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "FetchAllZipCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtConfigZCColl
        End Function
        Public Function SaveGenSettings(ByVal timeFormat As String, ByVal unitOfTime As String, ByVal currency As String, ByVal minSplits As String,
                                      ByVal useSubRepCode As String, ByVal useAutoResize As String, ByVal useDynClkTime As String, ByVal useNewJobCard As String,
                                      ByVal useEdtStdTime As String, ByVal useViewGarSum As String, ByVal useMondStDay As String, ByVal useVehRegn As String,
                                      ByVal useInvPdf As String, ByVal useDBS As String, ByVal useApprIR As String, ByVal useMechGrid As String,
                                      ByVal useSortPL As String, ByVal useValStdTime As String, ByVal useEdtChgTime As String, ByVal useValMileage As String,
                                      ByVal useSavUpdDP As String, ByVal useIntNote As String, ByVal useGrpSPBO As String, ByVal useDispWOSpares As String) As String
            Dim strResult As String = ""
            Dim strCommon As String = ""
            Dim strRes As String = ""
            Try

                strCommon = ""
                If (timeFormat <> "") Then
                    If (HttpContext.Current.Session("TimeFormat") <> timeFormat) Then
                        strResult = objConfigSettingsDO.SaveGenSettings("TIMEFORMAT", timeFormat)
                        HttpContext.Current.Session("TimeFormat") = timeFormat
                        strCommon += timeFormat + " "
                    Else
                        strCommon += ""
                    End If
                End If

                If (unitOfTime <> "") Then
                    If (HttpContext.Current.Session("UnitofTimings") <> unitOfTime) Then
                        strResult = objConfigSettingsDO.SaveGenSettings("UNITTIMING", unitOfTime)
                        HttpContext.Current.Session("UnitofTimings") = unitOfTime
                        strCommon += unitOfTime + " "
                    Else
                        strCommon += ""
                    End If
                End If

                If (currency <> "") Then
                    If (HttpContext.Current.Session("Currency") <> currency) Then
                        strResult = objConfigSettingsDO.SaveGenSettings("CURRENCY", currency)
                        HttpContext.Current.Session("Currency") = currency
                        strCommon += currency + " "
                    Else
                        strCommon += ""
                    End If
                End If

                If (minSplits <> "") Then
                    If (HttpContext.Current.Session("MinimumSpilts") <> minSplits) Then
                        strResult = objConfigSettingsDO.SaveGenSettings("MINSPILTS", minSplits)
                        HttpContext.Current.Session("MinimumSpilts") = minSplits
                        strCommon += minSplits + " "
                    Else
                        strCommon += ""
                    End If
                End If


                If (HttpContext.Current.Session("SubRepairCode") <> useSubRepCode) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USESUBREPC", useSubRepCode)
                    HttpContext.Current.Session("SubRepairCode") = useSubRepCode
                    strCommon += useSubRepCode + " "
                Else
                    strCommon += ""
                End If


                If (HttpContext.Current.Session("SubDayPlanCode") <> useAutoResize) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEDAYPLAN", useAutoResize)
                    HttpContext.Current.Session("SubDayPlanCode") = useAutoResize
                    strCommon += useAutoResize + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("JobCard") <> useNewJobCard) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEJOBCARD", useNewJobCard)
                    HttpContext.Current.Session("JobCard") = useNewJobCard
                    strCommon += useNewJobCard + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("EditStdTim") <> useEdtStdTime) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("EDITSTDTIM", useEdtStdTime)
                    HttpContext.Current.Session("EditStdTim") = useEdtStdTime
                    strCommon += useEdtStdTime + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("ViewGarSum") <> useViewGarSum) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("VIEWGARSUM", useViewGarSum)
                    HttpContext.Current.Session("ViewGarSum") = useViewGarSum
                    strCommon += useViewGarSum + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("MonAsStart") <> useMondStDay) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("MONASSTAT", useMondStDay)
                    HttpContext.Current.Session("MonAsStart") = useMondStDay
                    strCommon += useMondStDay + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("VehRegnDP") <> useVehRegn) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("VEHREGNDP", useVehRegn)
                    HttpContext.Current.Session("VehRegnDP") = useVehRegn
                    strCommon += useVehRegn + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("UseInvPDF") <> useInvPdf) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEINVPDF", useInvPdf)
                    HttpContext.Current.Session("UseInvPDF") = useInvPdf
                    strCommon += useInvPdf + " "
                Else
                    strCommon += ""
                End If


                If (HttpContext.Current.Session("DynClkTime") <> useDynClkTime) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEDYNCLKT", useInvPdf)
                    HttpContext.Current.Session("DynClkTime") = useDynClkTime
                    strCommon += useDynClkTime + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("UseDBSLnk") <> useDBS) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEDBS", useDBS)
                    HttpContext.Current.Session("UseDBSLnk") = useDBS
                    strCommon += useDBS + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("UseApprove") <> useApprIR) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEAPPROVE", useApprIR)
                    HttpContext.Current.Session("UseApprove") = useApprIR
                    strCommon += useApprIR + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("UseMechGrid") <> useMechGrid) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("USEMECGRID", useMechGrid)
                    HttpContext.Current.Session("UseMechGrid") = useMechGrid
                    strCommon += useMechGrid + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SortByLoc") <> useSortPL) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("SORTBYLOC", useSortPL)
                    HttpContext.Current.Session("SortByLoc") = useSortPL
                    strCommon += useSortPL + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("ValidateStdTime") <> useValStdTime) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("VLDSTDTIME", useValStdTime)
                    HttpContext.Current.Session("ValidateStdTime") = useValStdTime
                    strCommon += useValStdTime + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("EditChgTime") <> useEdtChgTime) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("EDTCHGTIME", useEdtChgTime)
                    HttpContext.Current.Session("EditChgTime") = useEdtChgTime
                    strCommon += useEdtChgTime + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("ValidateMileage") <> useValMileage) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("VLDMILEAGE", useValMileage)
                    HttpContext.Current.Session("ValidateMileage") = useValMileage
                    strCommon += useValMileage + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SAVEUPDDP") <> useSavUpdDP) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("SAVEUPDDP", useSavUpdDP)
                    HttpContext.Current.Session("SAVEUPDDP") = useSavUpdDP
                    strCommon += useSavUpdDP + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("DispIntNote") <> useIntNote) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("INT-NOTE", useIntNote)
                    HttpContext.Current.Session("DispIntNote") = useIntNote
                    strCommon += useIntNote + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("GrpSpBO") <> useGrpSPBO) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("GRP-SP-BO", useGrpSPBO)
                    HttpContext.Current.Session("GrpSpBO") = useGrpSPBO
                    strCommon += useGrpSPBO + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("DispWoSpares") <> useDispWOSpares) Then
                    strResult = objConfigSettingsDO.SaveGenSettings("DISWOSPARE", useDispWOSpares)
                    HttpContext.Current.Session("DispWoSpares") = useDispWOSpares
                    strCommon += useDispWOSpares + " "
                Else
                    strCommon += ""
                End If

                strRes += strCommon

                If (strRes <> "") Then
                    strRes = objErrHandle.GetErrorDesc("SETSAVE")
                Else
                    strRes = ""
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveGenSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function SaveZipCodes(ByVal objZipCodes As ZipCodesBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If (mode = "Add") Then
                    strResult = objConfigZipCodeDO.Add_ZipCode(objZipCodes)
                Else
                    strResult = objConfigZipCodeDO.Update_ZipCode(objZipCodes)
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function GetZipCodeDetails(ByVal zipCode As String) As List(Of ZipCodesBO)
            Dim details As New List(Of ZipCodesBO)()
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("AllZipCodes")
                If (ds.Tables.Count > 0) Then

                    If (ds.Tables(0).Rows.Count > 0) Then
                        dt = ds.Tables(0)
                        dv = dt.DefaultView
                        dv.RowFilter = "zipcode = '" + zipCode + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim zipCodes As New ZipCodesBO()
                            zipCodes.ZipCode = dtrow("ZipCode").ToString()
                            zipCodes.Country = dtrow("Country").ToString()
                            zipCodes.State = dtrow("State").ToString()
                            zipCodes.City = dtrow("City").ToString()
                            details.Add(zipCodes)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "GetZipCodeDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function DeleteZipCode(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigZipCodeDO.DeleteZipCode(xmlDoc)
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
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "DeleteConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function FetchConfigSettings() As Collection
            Dim dsConfigGen As New DataSet
            Dim dtConfigGen As New DataTable
            Dim dsStationType As New DataSet
            Dim dtStationType As New DataTable
            Dim dsDepartment As New DataSet
            Dim dtDepartment As New DataTable
            Dim dtConfigGenColl As New Collection
            Try
                dsConfigGen = objConfigSettingsDO.Fetch_TRConfiguration(HttpContext.Current.Session("UserID").ToString(), "DISCD", "VAT", "LEAVE_RESN", Nothing, Nothing)
                HttpContext.Current.Session("ConfigGeneral") = dsConfigGen

                If dsConfigGen.Tables.Count > 0 Then
                    'Discount Code
                    If (dsConfigGen.Tables(0).Rows.Count > 0) Then
                        dtConfigGen = dsConfigGen.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtConfigGen.Rows
                            Dim dcDet As New ConfigSettingsBO()
                            dcDet.IdSettings = dtrow("ID_SETTINGS").ToString()
                            dcDet.IdConfig = dtrow("ID_CONFIG").ToString()
                            dcDet.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(dcDet)
                        Next
                        dtConfigGenColl.Add(details)
                    ElseIf (dsConfigGen.Tables(0).Rows.Count = 0) Then
                        dtConfigGen = dsConfigGen.Tables(0)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtConfigGenColl.Add(details)
                    End If

                    'VAT Code
                    If (dsConfigGen.Tables(1).Rows.Count > 0) Then
                        dtConfigGen = dsConfigGen.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtConfigGen.Rows
                            Dim vatcode As New ConfigSettingsBO()
                            vatcode.IdSettings = dtrow("ID_SETTINGS").ToString()
                            vatcode.IdConfig = dtrow("ID_CONFIG").ToString()
                            vatcode.Description = dtrow("DESCRIPTION").ToString()
                            vatcode.VatPerc = dtrow("VAT_PERCENTAGE").ToString()
                            vatcode.ExtVatCode = dtrow("EXT_VAT_CODE").ToString()
                            vatcode.ExtAccntCode = dtrow("EXT_ACC_CODE").ToString()
                            details.Add(vatcode)
                        Next
                        dtConfigGenColl.Add(details)
                    ElseIf (dsConfigGen.Tables(1).Rows.Count = 0) Then
                        dtConfigGen = dsConfigGen.Tables(1)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtConfigGenColl.Add(details)
                    End If

                    'Reason for Leave
                    If (dsConfigGen.Tables(2).Rows.Count > 0) Then
                        dtConfigGen = dsConfigGen.Tables(2)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtConfigGen.Rows
                            Dim reason As New ConfigSettingsBO()
                            reason.IdSettings = dtrow("ID_SETTINGS").ToString()
                            reason.IdConfig = dtrow("ID_CONFIG").ToString()
                            reason.Description = dtrow("DESCRIPTION").ToString()
                            details.Add(reason)
                        Next
                        dtConfigGenColl.Add(details)
                    ElseIf (dsConfigGen.Tables(2).Rows.Count = 0) Then
                        dtConfigGen = dsConfigGen.Tables(2)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtConfigGenColl.Add(details)
                    End If

                    'SMS Settings
                    If (dsConfigGen.Tables(4).Rows.Count > 0) Then
                        dtConfigGen = dsConfigGen.Tables(4)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtConfigGen.Rows
                            Dim reason As New ConfigSettingsBO()
                            reason.SmsServer = dtrow("SmsServer").ToString()
                            HttpContext.Current.Session("SmsServer") = dtrow("SmsServer").ToString()
                            reason.SmsPrefix = dtrow("SmsPrefix").ToString()
                            HttpContext.Current.Session("SmsPrefix") = dtrow("SmsPrefix").ToString()
                            reason.SmsSuffix = dtrow("SmsSuffix").ToString()
                            HttpContext.Current.Session("SmsSuffix") = dtrow("SmsSuffix").ToString()
                            reason.SmsCtryCde = dtrow("SmsCtryCde").ToString()
                            HttpContext.Current.Session("SmsCtryCde") = dtrow("SmsCtryCde").ToString()
                            reason.SmsNoChars = dtrow("SmsNoChars").ToString()
                            HttpContext.Current.Session("SmsNoChars") = dtrow("SmsNoChars").ToString()
                            reason.SmsStDigit = dtrow("SmsStDigit").ToString()
                            HttpContext.Current.Session("SmsStDigit") = dtrow("SmsStDigit").ToString()
                            reason.SmsMailUsr = dtrow("SmsMailUsr").ToString().ToLower()
                            HttpContext.Current.Session("SmsMailUsr") = dtrow("SmsMailUsr").ToString().ToLower()
                            details.Add(reason)
                        Next
                        dtConfigGenColl.Add(details)
                    ElseIf (dsConfigGen.Tables(4).Rows.Count = 0) Then
                        dtConfigGen = dsConfigGen.Tables(4)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtConfigGenColl.Add(details)
                    End If

                    'Dept-Messages
                    If (dsConfigGen.Tables(5).Rows.Count > 0) Then
                        dtConfigGen = dsConfigGen.Tables(5)
                        Dim details As New List(Of ConfigSettingsBO)()
                        For Each dtrow As DataRow In dtConfigGen.Rows
                            Dim mess As New ConfigSettingsBO()
                            mess.MessId = dtrow("ID_MESSAGES").ToString()
                            mess.DeptId = dtrow("ID_DEPT").ToString()
                            mess.DeptName = dtrow("DPT_NAME").ToString()
                            mess.CommercialText = dtrow("COMMERCIAL_TEXT").ToString()
                            mess.DetailText = dtrow("DETAIL_TEXT").ToString()
                            details.Add(mess)
                        Next
                        dtConfigGenColl.Add(details)
                    ElseIf (dsConfigGen.Tables(5).Rows.Count = 0) Then
                        dtConfigGen = dsConfigGen.Tables(5)
                        Dim details As New List(Of ConfigSettingsBO)()
                        dtConfigGenColl.Add(details)
                    End If

                    'Station Type
                    dsStationType = objConfigSettingsDO.Fetch_StationType()
                    If (dsStationType.Tables.Count > 0) Then
                        If (dsStationType.Tables(0).Rows.Count > 0) Then
                            dtStationType = dsStationType.Tables(0)
                            Dim details As New List(Of ConfigSettingsBO)()
                            For Each dtrow As DataRow In dtStationType.Rows
                                Dim statType As New ConfigSettingsBO()
                                statType.IdStype = dtrow("ID_STYPE").ToString()
                                statType.StationType = dtrow("TYPE_STATION").ToString()
                                details.Add(statType)
                            Next
                            dtConfigGenColl.Add(details)
                        ElseIf (dsStationType.Tables(0).Rows.Count = 0) Then
                            dtStationType = dsStationType.Tables(0)
                            Dim details As New List(Of ConfigSettingsBO)()
                            dtConfigGenColl.Add(details)
                        End If
                    End If

                    'All Departments
                    dsDepartment = objConfigSettingsDO.Fetch_AllDepartment()
                    If (dsDepartment.Tables.Count > 0) Then
                        If (dsDepartment.Tables(0).Rows.Count > 0) Then
                            dtDepartment = dsDepartment.Tables(0)
                            Dim details As New List(Of ConfigSettingsBO)()
                            For Each dtrow As DataRow In dtDepartment.Rows
                                Dim dept As New ConfigSettingsBO()
                                dept.DeptId = dtrow("ID_DEPT").ToString()
                                dept.DeptName = dtrow("DPT_NAME").ToString()
                                details.Add(dept)
                            Next
                            dtConfigGenColl.Add(details)
                        ElseIf (dsDepartment.Tables(0).Rows.Count = 0) Then
                            dtDepartment = dsDepartment.Tables(0)
                            Dim details As New List(Of ConfigSettingsBO)()
                            dtConfigGenColl.Add(details)
                        End If

                    End If

                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "FetchConfigSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return dtConfigGenColl
        End Function
        Public Function AddStationType(ByVal strXMLDocMas As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objConfigSettingsDO.AddStationType(strXMLDocMas)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then

                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim configCodeDet As New ConfigSettingsBO()
                    configCodeDet.RetVal_Saved = strSaved
                    configCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(configCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "AddStationType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function UpdateStationType(ByVal strXMLDoc As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objConfigSettingsDO.UpdateStationType(strXMLDoc)
                strResultArr = strResult.Split(","c)

                If strResultArr.Length >= 3 Then
                    strSaved += "" + strResultArr(2).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""
                    strCannotSaved += "" + strResultArr(1).Replace(";", "';'").Replace("<", "&lt;").Replace(">", "&gt;") + ""

                    Dim configCodeDet As New ConfigSettingsBO()
                    configCodeDet.RetVal_Saved = strSaved
                    configCodeDet.RetVal_NotSaved = strCannotSaved
                    details.Add(configCodeDet)

                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "UpdateStationType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function DeleteStationType(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteStationType(xmlDoc)
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
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "DeleteStationType", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

        Public Function SaveSMSSettings(ByVal smsServer As String, ByVal smsPrefix As String, ByVal smsSuffix As String, ByVal smsCtryCode As String,
                                        ByVal smsNoChars As String, ByVal smsStDigit As String, ByVal smsMailUsr As String) As String
            Dim strResult As String = ""
            Dim strCommon As String = ""
            Dim strRes As String = ""
            Try

                strCommon = ""
                If (smsServer <> "") Then
                    If (HttpContext.Current.Session("SmsServer") <> smsServer) Then
                        strResult = objConfigSettingsDO.SaveSMSSetting("SMSSERVER", smsServer)
                        HttpContext.Current.Session("SmsServer") = smsServer
                        strCommon += smsServer + " "
                    Else
                        strCommon += ""
                    End If
                End If

                If (HttpContext.Current.Session("SmsPrefix") <> smsPrefix) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSPREFIX", smsPrefix)
                    HttpContext.Current.Session("SmsPrefix") = smsPrefix
                    strCommon += smsPrefix + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SmsSuffix") <> smsSuffix) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSSUFFIX", smsSuffix)
                    HttpContext.Current.Session("SmsSuffix") = smsSuffix
                    strCommon += smsSuffix + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SmsCtryCde") <> smsCtryCode) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSCTRYCDE", smsCtryCode)
                    HttpContext.Current.Session("SmsCtryCde") = smsCtryCode
                    strCommon += smsCtryCode + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SmsNoChars") <> smsNoChars) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSNOCHARS", smsNoChars)
                    HttpContext.Current.Session("SmsNoChars") = smsNoChars
                    strCommon += smsNoChars + " "
                Else
                    strCommon += ""
                End If


                If (HttpContext.Current.Session("SmsStDigit") <> smsStDigit) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSSTDIGIT", smsStDigit)
                    HttpContext.Current.Session("SmsStDigit") = smsStDigit
                    strCommon += smsStDigit + " "
                Else
                    strCommon += ""
                End If

                If (HttpContext.Current.Session("SmsMailUsr") <> smsMailUsr) Then
                    strResult = objConfigSettingsDO.SaveSMSSetting("SMSMAILUSR", smsMailUsr)
                    HttpContext.Current.Session("SmsMailUsr") = smsMailUsr
                    strCommon += smsMailUsr + " "
                Else
                    strCommon += ""
                End If

                strRes += strCommon

                If (strRes <> "") Then
                    strRes = objErrHandle.GetErrorDesc("SETSAVE")
                Else
                    strRes = ""
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "SaveSMSSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strRes
        End Function
        Public Function AddDeptMessage(ByVal xmlDoc As String, ByVal deptId As String, ByVal messageid As String) As String
            Dim strResult As String = ""
            Dim strExists As String = ""
            Try
                strExists = CheckDeptMessExists(deptId, messageid)
                If (strExists = "AEXISTS") Then
                    strResult = "AEXISTS"
                Else
                    strResult = objConfigSettingsDO.AddDeptMessage(xmlDoc)
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "AddDeptMessage", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function UpdateDeptMessage(ByVal xmlDoc As String, ByVal deptId As String, ByVal messageid As String) As String
            Dim strResult As String = ""
            Dim strExists As String = ""
            Try
                strExists = CheckDeptMessExists(deptId, messageid)
                If (strExists = "AEXISTS") Then
                    strResult = "AEXISTS"
                Else
                    strResult = objConfigSettingsDO.UpdateDeptMessage(xmlDoc)
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "UpdateDeptMessage", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteDeptMessage(ByVal xmlDoc As String) As String
            Dim strResult As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteDeptMessage(xmlDoc)

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "DeleteDeptMessage", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function GetDeptMessDetails(ByVal messId As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("ConfigGeneral")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(5).Rows.Count > 0) Then
                        dt = ds.Tables(5)
                        dv = dt.DefaultView
                        dv.RowFilter = "id_messages = '" + messId + "'"
                    End If

                    dt = dv.ToTable

                    If (dt.Rows.Count > 0) Then
                        For Each dtrow As DataRow In dt.Rows
                            Dim mess As New ConfigSettingsBO()
                            mess.MessId = dtrow("ID_MESSAGES").ToString()
                            mess.DeptId = dtrow("ID_DEPT").ToString()
                            mess.DeptName = dtrow("DPT_NAME").ToString()
                            mess.CommercialText = dtrow("COMMERCIAL_TEXT").ToString()
                            mess.DetailText = dtrow("DETAIL_TEXT").ToString()
                            details.Add(mess)
                        Next
                    End If
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "GetDeptMessDetails", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function

        Public Function CheckDeptMessExists(ByVal deptId As String, ByVal messageid As String) As String
            Dim strResult As String = ""
            Try
                Dim ds As New DataSet
                Dim dt As New DataTable
                Dim dv As New DataView

                ds = HttpContext.Current.Session("ConfigGeneral")
                If (ds.Tables.Count > 0) Then
                    If (ds.Tables(5).Rows.Count > 0) Then
                        dt = ds.Tables(5)
                        dv = dt.DefaultView
                        If (messageid = "") Then
                            dv.RowFilter = "id_dept = '" + deptId + "'"
                        Else
                            dv.RowFilter = "id_dept = '" + deptId + "' and id_messages <> '" + messageid + "'"
                        End If
                    End If
                End If
                dt = dv.ToTable

                If (dt.Rows.Count = 0) Then
                    strResult = "NEXISTS"
                Else
                    strResult = "AEXISTS"
                End If


            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigGeneral", "CheckDeptMessExists", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function


    End Class
End Namespace

