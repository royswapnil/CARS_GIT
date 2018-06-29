Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS

Public Class ucTopBannerMain1
    Inherits System.Web.UI.UserControl
      Dim dtvMenu As DataView
    Dim dtMenu As New DataTable
    Dim instance As Menu
    Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim MainMenuBO As New ConfigRoleBO
    Dim LoginBO As New LoginBO
    'Dim objLangaugeCheckListBO As New 
    Dim dtLanguage As DataTable
    Dim objLoginDO As New Login.LoginDO
    Dim objConfigRoleMenu As New Services.ConfigRole.Role
    Dim LefMenu() As String = {"/Transactions/frmTimeRegCTPMech.aspx", "/Transactions/frmTimeRegCTPOrder.aspx", "/Transactions/frmTimeRegInsInOut.aspx"}

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim SitePath As String
        Dim ds As New DataSet
        Dim relation As DataRelation
        Dim MainMenuItem As New MenuItem
        Try
            If System.Configuration.ConfigurationManager.AppSettings("Language").ToUpper <> "ENGLISH" Then
                If Session("TopMenu") Is Nothing Then
                    ' LanguageChange()
                Else
                    Dim arrTopMenu As String()
                    arrTopMenu = Session("TopMenu").ToString.Split(";")
                    'RTlblLoginInfo.Text = arrTopMenu(0)
                    'hlnkMsgHelp.Text = arrTopMenu(1)
                    hlnkMSGLogout.Text = arrTopMenu(2)
                    RTLblVersion.Text = arrTopMenu(3)
                    RTlblPageTitle.Text = arrTopMenu(4)
                    RTlblLanguage.Text = arrTopMenu(5)
                    RTlblExpand.Text = arrTopMenu(6)
                End If
            End If

            Menu1.DynamicPopOutImageTextFormatString = RTlblExpand.Text + " {0}"
            Menu1.StaticPopOutImageTextFormatString = RTlblExpand.Text + " {0}"
            hlnkMSGLogout.NavigateUrl = Application("AppPath") & "/frmlogin.aspx"
            ' Dim s As String = Request.PhysicalApplicationPath
            If Session("UserId") Is Nothing Then
                RTLblUser.Text = "'" + "ABS-10 User" + "'"

            Else
                If Not Page.IsPostBack Then
                    LoadImages()
                    SitePath = Application("AppPath")
                    ' RTDeptName.Text = Session("DeptName")

                    RTLblUser.Text = "'" + Session("UserId") + "'" ' + Request.PhysicalPath.ToString()
                    ds = Session("usermenu")
                    If (ds Is Nothing) Then
                        MainMenuBO.User = Session("UserId")
                        MainMenuBO.LanguageId = ConfigurationManager.AppSettings("Language")
                        ds = objConfigRoleMenu.GetMenuData(MainMenuBO)
                        ds.DataSetName = "Menus"
                        ds.Tables(0).TableName = "TBL_UTIL_MOD_DETAILS"
                        relation = New DataRelation("ParentChild", ds.Tables("TBL_UTIL_MOD_DETAILS").Columns("MenuID"), ds.Tables("TBL_UTIL_MOD_DETAILS").Columns("ParentID"), True)
                        relation.Nested = True
                        ds.Relations.Add(relation)
                        Session("usermenu") = ds
                    End If
                    DrawUserMenu(ds)

                    RTlblver.Text = IIf(System.Configuration.ConfigurationManager.AppSettings("Version") Is Nothing, "", System.Configuration.ConfigurationManager.AppSettings("Version"))
                End If
                If Not GetPageAcess() Then
                    ' Response.Redirect(SitePath & "/frmLogin.aspx")
                End If
                If Not Session("OtherScreen") Is Nothing Then
                    Menu1.Visible = False
                End If

            End If
        Catch exth As System.Threading.ThreadAbortException
            'Throw exth
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "UserCtrl_ucTopBannerMain", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "usercontrol")
            oErrHandle = Nothing
            Throw ex
        End Try
    End Sub
    'Public Sub LanguageChange()            'multilingual
    '    Try
    '        If ViewState("frmVehicleDetail_dsLang") Is Nothing Then
    '            objLangaugeCheckListBO.PScrn_name = IO.Path.GetFileName("ucTopBannerMain.ascx")
    '            objLangaugeCheckListBO.PRdlSelection _
    '                = CType(IIf(ConfigurationManager.AppSettings("Language") Is Nothing, "English", ConfigurationManager.AppSettings("Language")), String)

    '            dtLanguage = objLangaugeCheckListBO.FillGridLan().Tables(0)
    '            ViewState("frmVehicleDetail_dsLang") = dtLanguage
    '        Else
    '            dtLanguage = CType(ViewState("frmVehicleDetail_dsLang"), DataTable)
    '        End If



    '        If dtLanguage.Rows.Count > 0 Then
    '            If Convert.ToString(dtLanguage.Rows(0).Item(0)).ToUpper <> "FALSE" Then
    '                ''to be addded

    '                'RTlblLoginInfo.Text = GetTextValue(RTlblLoginInfo.ID)
    '                'hlnkMsgHelp.Text = GetTextValue(hlnkMsgHelp.ID)
    '                hlnkMSGLogout.Text = GetTextValue(hlnkMSGLogout.ID)
    '                RTLblVersion.Text = GetTextValue(RTLblVersion.ID)
    '                RTlblPageTitle.Text = GetTextValue(RTlblPageTitle.ID)
    '                RTlblLanguage.Text = GetTextValue(RTlblLanguage.ID)
    '                RTlblExpand.Text = GetTextValue(RTlblExpand.ID)
    '                'Session("TopMenu") = RTlblLoginInfo.Text + ";" + hlnkMsgHelp.Text + ";" + hlnkMSGLogout.Text + ";" + RTLblVersion.Text + ";" + RTlblPageTitle.Text + ";" + RTlblLanguage.Text + ";" + RTlblExpand.Text
    '                Session("TopMenu") = hlnkMSGLogout.Text + ";" + RTLblVersion.Text + ";" + RTlblPageTitle.Text + ";" + RTlblLanguage.Text + ";" + RTlblExpand.Text
    '            Else
    '                'RTlblError.Visible = True
    '                'RTlblError.Text = oErrHandle.GetErrorDescParameter("CSL")
    '            End If
    '        End If
    '    Catch ex As Exception

    '        oErrHandle.WriteErrorLog(1, "UserCtrl_LeftMenuStatic", "LanguageChange", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
    '        Throw ex
    '    End Try
    'End Sub


    Public Function GetTextValue(ByVal strCtrlName As String) As String
        Try
            dtLanguage.DefaultView.RowFilter = "cntrlname='" + strCtrlName + "'"
            If dtLanguage.DefaultView.Count > 0 Then
                Dim strToReturn As String
                strToReturn = dtLanguage.DefaultView.Item(0).Item(3).ToString
                dtLanguage.DefaultView.RowFilter = "true"
                Return strToReturn
            End If
            Return ""
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "UserCtrl_LeftMenuStatic", "GetTextValue", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            Return ""
        End Try

    End Function

    Private Sub DrawUserMenu(ByVal ds As DataSet)
        Try
            Dim m As MenuItem
            Dim i As Integer
            Dim dr As DataRow

            Dim lev As String
            '   Menu1.Items.Clear()
            For i = 0 To ds.Tables("TBL_UTIL_MOD_DETAILS").Rows.Count - 1
                m = New MenuItem
                dr = ds.Tables("TBL_UTIL_MOD_DETAILS").Rows(i)
                m.Text = dr("text").ToString()
                m.Value = dr("MenuID").ToString()
                lev = dr("parentid").ToString()


                If lev = "" Then
                    submenus(m, ds.Tables("TBL_UTIL_MOD_DETAILS"), dr("MenuID").ToString())

                    Menu1.Items.Add(m)
                    If (dr("DESCRIPTION").ToString() <> "") Then
                        m.NavigateUrl = Application("AppPath") & dr("DESCRIPTION").ToString()
                    Else
                        m.NavigateUrl = ""
                        m.Selectable = True
                    End If
                End If
            Next
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "DrawUserMenu", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")
            'oErrHandle = Nothing
            Throw ex
        End Try
    End Sub
    '*********************************************************************************
    '  Name of Method         		:  submenus
    '  Description            		:  
    '  Input Params           		:  strAnchorControlID
    '  Output Params          		:  
    '  I/O Params             		:   
    '  Globals Used           		:  
    '  Routines Called        		:  
    '*********************************************************************************
    Private Sub submenus(ByRef menuItemParent As MenuItem, ByVal dt As DataTable, ByVal intmenuID As Integer)
        Dim i As Integer
        Dim SitePath As String
        Dim m1 As MenuItem
        Dim dr1 As DataRow
        Dim drs() As DataRow
        SitePath = Application("AppPath")
        ' drs = dt.DefaultView.RowFilter = "MenuID='" + intmenuID.ToString() + "'"
        drs = dt.Select("parentid='" + intmenuID.ToString() + "'")
        For i = 0 To drs.Length - 1
            m1 = New MenuItem
            dr1 = drs(i)
            m1.Text = dr1("text").ToString()
            m1.Value = dr1("MenuID").ToString()
            m1.NavigateUrl = SitePath & dr1("DESCRIPTION").ToString()
            menuItemParent.ChildItems.Add(m1)
            submenus(m1, dt, dr1("MenuID").ToString())
        Next

    End Sub

    '*********************************************************************************
    '  Name of Method         		:  GetPageAcess
    '  Description            		:  
    '  Input Params           		:  strAnchorControlID
    '  Output Params          		:  
    '  I/O Params             		:   
    '  Globals Used           		:  
    '  Routines Called        		:  
    '*********************************************************************************
    Private Function GetPageAcess() As Boolean
        Dim FilePath As String
        Dim RootPath As String
        Dim FileName As String
        Dim BolRet As Boolean = False
        Dim Dr As DataRow
        Dim IntRowc As Integer

        Try

            Dim DsUser As DataSet = CType(Session("UserPerDel"), DataSet)
            If (DsUser Is Nothing) Then
                LoginBO.UserId = Session("UserId")
                DsUser = objLoginDO.GetPageAcess(LoginBO)
                Session("UserPerDel") = DsUser
            End If
            FilePath = Request.PhysicalPath.Trim()
            RootPath = Request.PhysicalApplicationPath.Trim()
            FileName = FilePath.Substring(RootPath.Length - 1)
            GetUserScrPer(DsUser.Tables(2), FileName)
            For IntRowc = 0 To DsUser.Tables(0).Rows.Count - 1
                Dr = DsUser.Tables(0).Rows(IntRowc)
                Dim s As String
                s = Dr("Description").ToString()
                s = s.Replace("/", "\")
                If s.Trim.ToUpper() = FileName.Trim.ToUpper() Then
                    BolRet = True
                    Exit For
                End If
                Dim i As Integer
                For i = 0 To LefMenu.Length - 1
                    If LefMenu(i).Trim.ToUpper() = FileName.ToUpper() Then
                        BolRet = True
                        Exit For
                    End If
                Next
            Next

            Dim intfstpos, intsndpos As Int16
            intfstpos = FileName.IndexOf("\")
            Dim str1, strpagename As String
            str1 = Mid(FileName, intfstpos + 2)
            intsndpos = str1.IndexOf("\")
            strpagename = Mid(str1, intsndpos + 2)
            If strpagename.ToUpper() = "frmTimeRegistration.aspx".ToUpper() Or strpagename.ToUpper() = "frmTimeRegCTPMech.aspx".ToUpper() Or strpagename.ToUpper() = "frmTimeRegCTPOrder.aspx".ToUpper() Or strpagename.ToUpper() = "frmTimeRegOTdetails.aspx".ToUpper() Or strpagename.ToUpper() = "frmTimeRegInsInOut.aspx".ToUpper() Or strpagename.ToUpper() = "frmVehTechInfo.aspx".ToUpper() Or strpagename.ToUpper() = "frmVehCOC.aspx".ToUpper() Or strpagename.ToUpper() = "frmVehRegBook.aspx".ToUpper() Then
                BolRet = True
            End If
            If strpagename.ToUpper() = "frminvprint.aspx".ToUpper() Or strpagename.ToUpper() = "frmWOHead.aspx".ToUpper() Or strpagename.ToUpper() = "frmWOJobDetails.aspx".ToUpper() Or strpagename.ToUpper() = "frmWOPaydetails.aspx".ToUpper() Or strpagename.ToUpper() = "frmWOhistory.aspx".ToUpper() Then
                BolRet = True
            End If


            Return BolRet
        Catch exth As System.Threading.ThreadAbortException
            'Throw exth
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "GetPageAcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")

            Throw ex
        End Try
    End Function
    '*********************************************************************************
    '  Name of Method         		:  GetUserScrPer
    '  Description            		:  
    '  Input Params           		:  
    '  Output Params          		:  
    '  I/O Params             		:   
    '  Globals Used           		:  
    '  Routines Called        		:  
    '*********************************************************************************
    Public Sub GetUserScrPer(ByVal DT As DataTable, ByVal FileName As String) 'As UserAccessPermissions
        Dim objuserper As New UserAccessPermissionsBO
        Dim dr() As DataRow
        Dim dr1 As DataRow
        Try
            FileName = FileName.Replace("\", "/")
            dr = DT.Select("NAME_URL LIKE '" & FileName.Trim().ToUpper() & "'")
            If dr.Length <> 0 Then
                dr1 = dr(0)
                objuserper.PF_ACC_SCR = Convert.ToInt16(dr1(1).ToString())
                objuserper.PF_ACC_VIEW = Convert.ToBoolean(dr1(2).ToString())
                objuserper.PF_ACC_ADD = Convert.ToBoolean(dr1(3).ToString())
                objuserper.PF_ACC_EDIT = Convert.ToBoolean(dr1(4).ToString())
                objuserper.PF_ACC_PRINT = Convert.ToBoolean(dr1(5).ToString())
                objuserper.PF_ACC_DELETE = Convert.ToBoolean(dr1(6).ToString())
            End If
            Session("UserPerDetails") = objuserper
        Catch exth As System.Threading.ThreadAbortException
            ' Throw exth
        Catch ex As Exception
            Session("UserPerDetails") = objuserper
        End Try
        'Return objuserper
    End Sub
    '*********************************************************************************
    '  Name of Method         		:  LoadImages
    '  Description            		:  
    '  Input Params           		:  
    '  Output Params          		:  
    '  I/O Params             		:   
    '  Globals Used           		:  
    '  Routines Called        		:  
    '*********************************************************************************
    Private Sub LoadImages()
        Dim Strlang As String
        Dim StrSitePath As String

        Dim StrFileName As String
        Strlang = System.Configuration.ConfigurationManager.AppSettings("Language")
        StrSitePath = IO.Path.GetDirectoryName(Application("AppPhyPath")) + "\Images\"
    End Sub


End Class