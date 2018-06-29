Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Globalization
Imports System.Web
Imports System.Web.Mail
Imports System.Web.SessionState
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.Data.SqlClient
Imports System.Data
Imports Encryption
Imports System.Configuration
Imports System.Math
Imports System.Windows.Forms

Namespace CARS.Utilities
    Public Class CommonUtility
        Dim objEncryption As New Encryption64
        Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objMultiLangBO As New MultiLingualBO
        Dim objMultiLangDO As New MultiLingual.MultiLingualDO
        Dim objZipCodeBO As New ZipCodesBO
        Dim objZipCodeDO As New ZipCodes.ZipCodesDO
        Dim objConfigDeptBO As New ConfigDepartmentBO
        Dim objConfigDeptDO As New Department.ConfigDepartmentDO
        Dim objConfigSubBO As New ConfigSubsidiaryBO
        Dim objConfigSubDO As New Subsidiary.ConfigSubsidiaryDO
        Shared oConfigUserDO As New ConfigUsers.ConfigUsersDO
        Dim objWOHDO As New CARS.WOHeader.WOHeaderDO
        Shared objConfigSettingsDO As New CARS.ConfigSettings.ConfigSettingsDO
        Shared objWOJDO As New CARS.WOJobDetailDO.WOJobDetailDO
        Shared _idlang As String
        Dim objItemsDO As New ItemsDO
        Public Function fnReplaceSQL(ByVal strUnformated As String) As String
            Try
                If strUnformated Is Nothing Then Return Nothing
                Dim strFormated As String
                strFormated = strUnformated.Replace("'"c, "''")
                Return strFormated
            Catch exth As System.Threading.ThreadAbortException
                Throw exth
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "fnReplaceSQL", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return ""
        End Function
        Public Sub ddlGetValue(ByVal ScreenName As String, ByVal ddl As DropDownList)
            Try
                Dim dsLang As New DataSet
                Dim dt As DataTable
                Dim dtNew As New DataTable()
                objMultiLangBO.ScreenName = ScreenName
                objMultiLangBO.LangName = System.Configuration.ConfigurationManager.AppSettings("Language").ToString()
                dsLang = objMultiLangDO.GetScreenData(objMultiLangBO)
                If dsLang.Tables.Count > 0 Then
                    If dsLang.Tables(0).Rows.Count > 0 Then
                        dt = dsLang.Tables(0)
                        dtNew = dt.Clone()
                        Dim selectedRows As DataRow() = dt.Select("CNTRLNAME ='" + ddl.ID + "'")
                        For Each dr As DataRow In selectedRows
                            Dim row As Object() = dr.ItemArray
                            dtNew.Rows.Add(row)
                        Next
                        ddl.DataTextField = "Caption"
                        ddl.DataValueField = "Ctrl_Value"
                        ddl.DataSource = dtNew
                        ddl.DataBind()
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "ddlGetValue", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Sub
        Public Sub ddlGetInvValue(ByVal ScreenName As String, ByVal ddlLogoAlignment As DropDownList, ByVal ddlFooterAlignment As DropDownList, ByVal ddlInvoiceType As DropDownList, ByVal ddlInvoiceName As DropDownList)
            Try
                Dim dsScreen As New DataSet
                Dim dt As DataTable
                Dim dtNew As New DataTable()
                Dim dv As DataView
                objMultiLangBO.ScreenName = ScreenName
                objMultiLangBO.LangName = System.Configuration.ConfigurationManager.AppSettings("Language").ToString()
                dsScreen = objMultiLangDO.GetScreenData(objMultiLangBO)
                dt = dsScreen.Tables(0)
                dtNew = dt.Clone()

                dv = GetDropDownListDataTable(dt, ddlLogoAlignment.ID)
                ddlLogoAlignment.DataTextField = "Caption"
                ddlLogoAlignment.DataValueField = "Ctrl_Value"
                ddlLogoAlignment.DataSource = dv
                ddlLogoAlignment.DataBind()

                dv = GetDropDownListDataTable(dt, ddlFooterAlignment.ID)
                ddlLogoAlignment.DataTextField = "Caption"
                ddlLogoAlignment.DataValueField = "Ctrl_Value"
                ddlLogoAlignment.DataSource = dv
                ddlLogoAlignment.DataBind()

                dv = GetDropDownListDataTable(dt, ddlInvoiceType.ID)
                ddlLogoAlignment.DataTextField = "Caption"
                ddlLogoAlignment.DataValueField = "Ctrl_Value"
                ddlLogoAlignment.DataSource = dv
                ddlLogoAlignment.DataBind()

                dv = GetDropDownListDataTable(dt, ddlInvoiceName.ID)
                ddlLogoAlignment.DataTextField = "Caption"
                ddlLogoAlignment.DataValueField = "Ctrl_Value"
                ddlLogoAlignment.DataSource = dv
                ddlLogoAlignment.DataBind()

                'dv = GetDropDownListDataTable(dt, ddl1.ID)
                'ddlLogoAlignment.DataTextField = "Caption"
                'ddlLogoAlignment.DataValueField = "Ctrl_Value"
                'ddlLogoAlignment.DataSource = dv
                'ddlLogoAlignment.DataBind()

                'dv = GetDropDownListDataTable(dt, ddl2.ID)
                'ddl2.DataTextField = "Caption"
                'ddl2.DataValueField = "Ctrl_Value"
                'ddl2.DataSource = dv
                'ddl2.DataBind()

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "ddlGetInvValue", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Sub
        Public Function GetDropDownListDataTable(ByVal dataCtrl As DataTable, ByVal strCtrlName As String) As IEnumerable
            Try
                dataCtrl.DefaultView.RowFilter = "CNTRLNAME='" + fnReplaceSQL(strCtrlName) + "'"
                Return dataCtrl.DefaultView
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function getZipCodes(ByVal zipCode As String, ByVal userId As String) As List(Of String)
            Dim retZipCodes As New List(Of String)()
            Dim dsZipCodes As New DataSet
            Dim dtZipCodes As New DataTable
            Try
                objZipCodeBO.ZipCode = zipCode
                objZipCodeBO.UserId = userId
                dsZipCodes = objZipCodeDO.Fetch_ZipCodes(objZipCodeBO)

                If dsZipCodes.Tables.Count > 0 Then
                    If dsZipCodes.Tables(0).Rows.Count > 0 Then
                        dtZipCodes = dsZipCodes.Tables(0)
                    End If
                End If
                If zipCode <> String.Empty Then
                    For Each dtrow As DataRow In dtZipCodes.Rows
                        retZipCodes.Add(String.Format("{0}-{1}-{2}-{3}", dtrow("Zip Code"), dtrow("Country"), dtrow("State"), dtrow("City")))
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "getZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return retZipCodes
        End Function
        Public Function ConvertStr(ByVal StrF As String) As String
            Dim str As String = ""
            Dim str1 As String = """"
            Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
            Try
                str = StrF
                str = str.Replace("&", "&amp;")
                str = str.Replace("<", "&lt;")
                str = str.Replace("'", "&apos;")
                str = str.Replace("""", "&quot;")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "ConvertStr", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return str
        End Function
        Public Function DestructStr(ByVal StrF As String) As String
            Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
            Dim str As String = ""
            Dim str1 As String = """"
            Try
                str = StrF
                str = str.Replace("&amp;", "&")
                str = str.Replace("&lt;", "<")
                str = str.Replace("&apos;", "'")
                str = str.Replace("&quot;", """")
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "ConvertStr", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return str
        End Function
        Public Function FetchAllDepartment(objConfigDeptBO) As List(Of ConfigDepartmentBO)
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dsDept As New DataSet
            Dim dtDeptDetails As DataTable
            Dim dtDept As New DataTable
            Try
                dsDept = objConfigDeptDO.FetchAllDepartments(objConfigDeptBO)
                dtDeptDetails = dsDept.Tables(0)
                HttpContext.Current.Session("dvDept") = dtDeptDetails.DefaultView
                dtDept = dsDept.Tables(0)
                For Each dtrow As DataRow In dtDept.Rows
                    Dim deptDet As New ConfigDepartmentBO()
                    deptDet.DeptId = dtrow("DepartmentID").ToString()
                    deptDet.DeptName = dtrow("DepartmentName").ToString()
                    deptDet.DeptManager = dtrow("DepartmentManager").ToString()
                    deptDet.Location = dtrow("Location").ToString()
                    deptDet.Address1 = dtrow("AddressLine1").ToString()
                    deptDet.Address2 = dtrow("AddressLine2").ToString()
                    deptDet.Phone = dtrow("Telephone").ToString()
                    deptDet.Mobile = dtrow("Mobile").ToString()
                    deptDet.FlgWareHouse = dtrow("IsItWarehouse").ToString()
                    deptDet.SubsideryId = dtrow("Subsidiary").ToString()
                    deptDet.DiscountCode = dtrow("DEPTDISCODE").ToString()
                    details.Add(deptDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "FetchAllDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function FetchSubsidiary(objConfigSubBO) As List(Of ConfigSubsidiaryBO)
            Dim dsFetchAllSub As New DataSet
            Dim dtSubDetails As DataTable
            Dim details As New List(Of ConfigSubsidiaryBO)()
            Try
                dsFetchAllSub = objConfigSubDO.FetchAllSubsidiary(objConfigSubBO)
                dtSubDetails = dsFetchAllSub.Tables(0)
                HttpContext.Current.Session("dvSubsidiaryList") = dtSubDetails.DefaultView
                For Each dtrow As DataRow In dtSubDetails.Rows
                    Dim subDet As New ConfigSubsidiaryBO()
                    subDet.SubsidiaryID = dtrow("SubsidiaryID").ToString()
                    subDet.SubsidiaryName = dtrow("SubsidiaryName").ToString()
                    subDet.SubsidiaryManager = dtrow("SubsidiaryManager").ToString()
                    subDet.AddressLine1 = dtrow("AddressLine1").ToString()
                    subDet.AddressLine2 = dtrow("AddressLine2").ToString()
                    subDet.Telephone = dtrow("Telephone").ToString()
                    subDet.Mobile = dtrow("Mobile").ToString()
                    subDet.Email = dtrow("Email").ToString()
                    subDet.Organization = dtrow("Organization").ToString()
                    details.Add(subDet)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "FetchSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Fetch_Config() As DataSet
            Dim dsLang As New DataSet
            dsLang = oConfigUserDO.Fetch_Config()
            Return dsLang
        End Function
        Public Function RetrieveErrMsgs(ByVal ScrName As String) As DataSet
            Try
                Dim dslang, dsErrMess As New DataSet
                Dim lang As String = ConfigurationManager.AppSettings("Language").ToString
                objMultiLangBO.ScreenName = ScrName
                objMultiLangBO.LangName = lang
                dslang = objMultiLangDO.FillGridLan(objMultiLangBO)
                Dim dr() As DataRow = dslang.Tables(0).Select("LANG_NAME ='" + lang + "'")
                If dr.Length <> 0 Then
                    _idlang = dr(0).Item("ID_LANG")
                Else
                    Dim dr1() As DataRow = dslang.Tables(0).Select("LANG_NAME ='English'")
                    _idlang = dr1(0).Item("ID_LANG")
                End If

                objMultiLangBO.IdLang = _idlang
                dsErrMess = objMultiLangDO.GetErrMessage(objMultiLangBO)
                If (dsErrMess.Tables(0).Rows.Count > 0) Then
                    objErrHandle.CreateResource(dsErrMess, HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath.ToString()))
                Else
                    Dim norec As New Exception("No Error messages found. Please contact System Administrator")
                    Throw norec
                End If
                dsErrMess.Tables(1).TableName = "JSError"
                dsErrMess.Tables(1).WriteXml(HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath.ToString()) + ConfigurationManager.AppSettings.Get("JSLanguageChange"), XmlWriteMode.IgnoreSchema)
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "RetrieveErrMsgs", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function fnEncryptQString(ByVal strEncrypted As String) As String
            'Encryption
            Dim objEncryption As New Encryption64
            If strEncrypted Is Nothing Then Return ""
            Return objEncryption.Encrypt(strEncrypted, ConfigurationManager.AppSettings.Get("encKey"))
        End Function
        Public Function GetDefaultDate_MMDDYYYY(ByVal DateValue As String) As String
            Try
                If DateValue.Length <> 0 Then
                    Dim count As Integer = 0
                    Dim monthPosition As Integer = 0
                    Dim dayPosition As Integer = 0
                    Dim yearPosition As Integer = 0
                    Dim specialCount = 0
                    Dim specialChar As String = String.Empty

                    For Each ch As Char In System.Configuration.ConfigurationManager.AppSettings("DateFormatValidate").ToString
                        count = count + 1
                        Select Case ch
                            Case "M"
                                monthPosition = count - 2
                            Case "d"
                                dayPosition = count - 2
                            Case "y"
                                yearPosition = count - 2
                            Case Else
                                specialChar = ch
                                count = count - 1
                        End Select
                    Next

                    If specialChar.Length = 0 Then
                        monthPosition = monthPosition + 2
                        dayPosition = dayPosition + 2
                    End If
                    Dim insertStr As String = DateValue
                    Dim strMonth, strDate, strYear As String
                    Dim dtTemp As DateTime
                    Dim formatInfo1 As System.Globalization.DateTimeFormatInfo = New System.Globalization.DateTimeFormatInfo

                    insertStr = insertStr.Replace(specialChar, String.Empty)
                    strMonth = insertStr.Substring(monthPosition, 2)
                    strDate = insertStr.Substring(dayPosition, 2)
                    If insertStr.Length = 8 Then
                        strYear = insertStr.Substring(yearPosition - 2, insertStr.Length - 4)
                    Else
                        strYear = insertStr.Substring(yearPosition, insertStr.Length - 4)
                    End If

                    formatInfo1.LongDatePattern = "MM/dd/yyyy"
                    dtTemp = DateTime.Parse(strMonth + "/" + strDate + "/" + strYear, System.Globalization.CultureInfo.CreateSpecificCulture("en-us").DateTimeFormat)
                    DateValue = dtTemp.ToString("MM/dd/yyyy", formatInfo1)
                    'Insert End
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "GetDefaultDate_MMDDYYYY", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return DateValue
        End Function
        Public Function GetDefaultDate_InserZero(ByVal DateValue As String) As String
            Try
                Dim currCulture As System.Globalization.CultureInfo = System.Globalization.CultureInfo.CurrentCulture
                Dim strCulture As String
                strCulture = currCulture.IetfLanguageTag
                If strCulture = "en-US" Then
                    If DateValue.Contains(".") Then
                        Dim dd1 As String
                        Dim mm1 As String
                        Dim fdate As Array = DateValue.Split(".")
                        Dim mm As String = fdate(1)
                        Dim dd As String = fdate(0)
                        Dim yy As String = fdate(2)
                        If mm.Length = 1 Then
                            mm1 = "0" + fdate(1)
                        Else
                            mm1 = mm
                        End If
                        If dd.Length = 1 Then
                            dd1 = "0" + fdate(0)
                        Else
                            dd1 = dd
                        End If
                        Return (mm1 + "/" + dd1 + "/" + fdate(2))
                    Else
                        Dim fdate As Array = DateValue.Split("/")
                        Dim dd2 As String
                        Dim mm2 As String
                        Dim mm As String = fdate(1)
                        Dim dd As String = fdate(0)
                        Dim yy As String = fdate(2)
                        If mm.Length = 1 Then
                            mm2 = "0" + fdate(1)
                        Else
                            mm2 = mm
                        End If
                        If dd.Length = 1 Then
                            dd2 = "0" + fdate(0)
                        Else
                            dd2 = dd
                        End If
                        Return (dd2 + "/" + mm2 + "/" + fdate(2))
                    End If
                Else
                    Return DateValue
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "GetDefaultDate_InserZero", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function GetCurrentCultureDate(ByVal DateValue As String) As String
            If DateValue.Length <> 0 Then
                Dim dt As Date
                Try
                    Dim currentValue As String = GetDefaultDate_MMDDYYYY(DateValue)
                    Dim dateArray As Array
                    dateArray = Split(currentValue, "/")
                    dt = New Date(dateArray(2), dateArray(0), dateArray(1))
                Catch ex As Exception
                    objErrHandle.WriteErrorLog(1, "CommonUtility", "GetCurrentCultureDate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                End Try
                Return dt.ToShortDateString
            Else
                Return String.Empty
            End If
        End Function
        Public Function GetCurrentLanguageDate(ByVal DateValue As String) As String
            Try
                If Not DateValue Is Nothing Then
                    If DateValue.Length <> 0 Then
                        Dim strDateDisplay As DateTime
                        If DateValue.Contains("/") Then
                            strDateDisplay = DateTime.Parse(DateValue, System.Globalization.CultureInfo.CreateSpecificCulture("en-us").DateTimeFormat)
                        Else
                            strDateDisplay = DateTime.Parse(DateValue, System.Globalization.CultureInfo.CreateSpecificCulture(System.Configuration.ConfigurationManager.AppSettings("Culture")).DateTimeFormat)
                        End If

                        Dim formatInfo As System.Globalization.DateTimeFormatInfo = New System.Globalization.DateTimeFormatInfo
                        formatInfo.LongDatePattern = System.Configuration.ConfigurationManager.AppSettings("DateFormatValidate").ToString
                        DateValue = strDateDisplay.ToString(System.Configuration.ConfigurationManager.AppSettings("DateFormatValidate").ToString, formatInfo)
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "GetCurrentLanguageDate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return DateValue
        End Function
        Public Function NullCheck(ByVal StrValue As String) As String
            Try
                If IsDBNull(StrValue) Then
                    Return ""
                Else
                    Return CStr(StrValue).Trim
                End If
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        ' Get user screen Permission
        Public Function GetUserScrPer(ByVal DT As DataTable, ByVal FileName As String) As UserAccessPermissionsBO
            Dim objuserper As New UserAccessPermissionsBO
            Dim dr() As DataRow
            Dim dr1 As DataRow
            Try
                FileName = FileName.Replace("\", "/")
                FileName = FileName.Replace("~", "")
                dr = DT.Select("NAME_URL LIKE '" & FileName.Trim().ToUpper() & "'")
                If dr.Length <> 0 Then
                    dr1 = dr(0)
                    objuserper.PF_ACC_SCR = Convert.ToInt16(dr1(1).ToString())
                    objuserper.PF_ACC_VIEW = Convert.ToBoolean(dr1(2).ToString())
                    objuserper.PF_ACC_ADD = Convert.ToBoolean(dr1(4).ToString())
                    objuserper.PF_ACC_EDIT = Convert.ToBoolean(dr1(3).ToString())
                    objuserper.PF_ACC_PRINT = Convert.ToBoolean(dr1(5).ToString())
                    objuserper.PF_ACC_DELETE = Convert.ToBoolean(dr1(6).ToString())
                End If
                Return objuserper
            Catch exth As System.Threading.ThreadAbortException
                Throw exth
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "GetUserScrPer", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return objuserper
        End Function
        Public Function GetDefaultNoFormat(ByVal Language As String, ByVal Num As String) As String
            Dim Number As String = String.Empty

            If Num.Length <> 0 Then
                Dim NumberValue As Decimal = Num
                Dim EngNumFormat As System.Globalization.NumberFormatInfo = New System.Globalization.CultureInfo("en-US").NumberFormat

                Try
                    Number = NumberValue.ToString("N", EngNumFormat)
                    Return Number.Replace(EngNumFormat.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    objErrHandle.WriteErrorLog(1, "CommonUtility", "GetDefaultNoFormat", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function GetCurrentLanguageNoFormat(ByVal Language As String, ByVal Num As String) As String
            If Num.Length <> 0 Then
                Dim MultiLangNumFormat As System.Globalization.NumberFormatInfo = New System.Globalization.CultureInfo(System.Configuration.ConfigurationManager.AppSettings("Culture")).NumberFormat
                Dim NumberValue As Decimal = Num
                Try
                    Num = NumberValue.ToString("N", MultiLangNumFormat)
                    Return Num.Replace(MultiLangNumFormat.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    objErrHandle.WriteErrorLog(1, "CommonUtility", "GetCurrentLanguageNoFormat", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function GetCurrentLangNoFormat(ByVal Language As String, ByVal Num As String) As String
            If Num.Length <> 0 Then
                Dim cultinfo As System.Globalization.CultureInfo = New System.Globalization.CultureInfo(System.Configuration.ConfigurationManager.AppSettings("Culture"))
                cultinfo.NumberFormat.NumberDecimalDigits = 5
                Dim MultiLangNumFormat As System.Globalization.NumberFormatInfo = cultinfo.NumberFormat
                Dim NumberValue As Decimal = Num
                Try
                    Num = NumberValue.ToString("N", MultiLangNumFormat)
                    Return Num.Replace(MultiLangNumFormat.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    objErrHandle.WriteErrorLog(1, "CommonUtility", "GetCurrentLangNoFormat", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function GetDefaultLangNoFormat(ByVal Language As String, ByVal Num As String) As String
            Dim Number As String = String.Empty
            If Num.Length <> 0 Then
                Dim NumberValue As Decimal = Num
                Dim cultinfo As System.Globalization.NumberFormatInfo = New System.Globalization.CultureInfo("en-US").NumberFormat
                cultinfo.NumberDecimalDigits = 2
                Try
                    Number = NumberValue.ToString("N", cultinfo)
                    Return Number.Replace(cultinfo.CurrencyGroupSeparator, String.Empty)
                Catch ex As Exception
                    objErrHandle.WriteErrorLog(1, "CommonUtility", "GetDefaultLangNoFormat", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                End Try
            Else
                Return String.Empty
            End If
        End Function
        Public Function ConvertDecMins(ByVal t1 As String) As String
            Dim e As String
            Try
                e = Round(t1 / 60, 2)
                Dim returnValue As String = String.Empty
                Dim returnArray As Array
                Dim splitVar As String = String.Empty
                splitVar = System.Globalization.NumberFormatInfo.CurrentInfo.NumberDecimalSeparator
                returnValue = e
                returnArray = returnValue.Split(splitVar)
                If returnArray.Length = 2 Then
                    e = returnArray(1)
                End If
                Return e
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "ConvertDecMins", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
        End Function
        Public Function AddConfigDetails(ByVal strXMLDocMas As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objConfigSettingsDO.InsertConfig(strXMLDocMas)
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
                objErrHandle.WriteErrorLog(1, "CommonUtility", "AddConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function UpdateConfigDetails(ByVal strXMLDoc As String) As List(Of ConfigSettingsBO)
            Dim details As New List(Of ConfigSettingsBO)()
            Try
                Dim strResult As String = ""
                Dim strSaved As String = ""
                Dim strCannotSaved As String = ""
                Dim strResultArr As Array
                strResult = objConfigSettingsDO.UpdateConfig(strXMLDoc)
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
                objErrHandle.WriteErrorLog(1, "CommonUtility", "UpdateConfigDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function DeleteConfig(ByVal xmlDoc As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigSettingsDO.DeleteConfig(xmlDoc)
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
                objErrHandle.WriteErrorLog(1, "CommonUtility", "DeleteConfig", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function
        Public Function GetDepartment(objConfigDeptBO) As List(Of ConfigDepartmentBO)
            Dim deptDetails As New List(Of ConfigDepartmentBO)()
            Dim dsFetchDept As New DataSet
            Dim dtDept As New DataTable
            Dim dvDepart As DataView
            Try
                dsFetchDept = objConfigDeptDO.GetDepartments(objConfigDeptBO)
                If dsFetchDept.Tables.Count > 0 Then
                    If dsFetchDept.Tables(0).Rows.Count > 0 Then
                        'dtDept = dsFetchDept.Tables(0)
                        dvDepart = dsFetchDept.Tables(0).DefaultView
                        dvDepart.Sort = "Dpt_Name"
                        dtDept = dvDepart.ToTable
                        For Each dtrow As DataRow In dtDept.Rows
                            Dim deptDet As New ConfigDepartmentBO()
                            deptDet.DeptId = dtrow("ID_Dept").ToString()
                            deptDet.DeptName = dtrow("Dpt_Name").ToString()
                            deptDet.SubsideryId = dtrow("Id_Subsidery_Dept").ToString()
                            deptDetails.Add(deptDet)
                        Next
                    End If
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "GetDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return deptDetails.ToList
        End Function
        Public Function LoadSubsidiaries(objConfigDeptBO) As List(Of ConfigDepartmentBO)
            Dim dsFetchSubs As DataSet
            Dim dtFetchSubs As DataTable
            Dim details As New List(Of ConfigDepartmentBO)()
            Dim dvSubs As DataView
            Try
                dsFetchSubs = objConfigDeptDO.GetSubsidiares(objConfigDeptBO)
                'dtFetchSubs = dsFetchSubs.Tables(0)
                dvSubs = dsFetchSubs.Tables(0).DefaultView
                dvSubs.Sort = "SS_NAME"
                dtFetchSubs = dvSubs.ToTable
                For Each dtrow As DataRow In dtFetchSubs.Rows
                    Dim deptSubs As New ConfigDepartmentBO()
                    deptSubs.SubsideryId = dtrow("ID_SUBSIDERY").ToString()
                    deptSubs.SubsidiaryName = dtrow("SS_NAME").ToString()
                    details.Add(deptSubs)
                Next
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "LoadSubsidiaries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadVatCode() As List(Of ItemsBO)
            Dim dsFetchVatCode As DataSet
            Dim dtFetchVatCode As DataTable
            Dim details As New List(Of ItemsBO)()
            Dim dvVatCode As DataView
            Try
                dsFetchVatCode = objItemsDO.Fetch_VATCode()
                If dsFetchVatCode.Tables.Count > 0 Then
                    dtFetchVatCode = dsFetchVatCode.Tables(0)
                    For Each dtrow As DataRow In dtFetchVatCode.Rows
                        Dim itemCode As New ItemsBO()
                        itemCode.ID_SETTINGS = dtrow("ID_SETTINGS").ToString()
                        itemCode.DESCRIPTION = dtrow("DESCRIPTION").ToString()
                        details.Add(itemCode)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "LoadVatCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function LoadWarehouse() As List(Of WOJobDetailBO)
            Dim dsWarehouse As New DataSet
            Dim dtWarehouse As DataTable
            Dim details As New List(Of WOJobDetailBO)()
            Dim dvWarehouse As DataView
            Try
                dsWarehouse = objWOJDO.GetUsersWarehouse(HttpContext.Current.Session("UserID").ToString)
                If dsWarehouse.Tables.Count > 0 Then
                    dtWarehouse = dsWarehouse.Tables(0)
                    For Each dtrow As DataRow In dtWarehouse.Rows
                        Dim itemCode As New WOJobDetailBO()
                        itemCode.Id_Warehouse = dtrow("ID_WH").ToString()
                        itemCode.WarehouseName = dtrow("WH_NAME").ToString()
                        details.Add(itemCode)
                    Next
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "CommonUtility", "LoadWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function


    End Class
End Namespace
