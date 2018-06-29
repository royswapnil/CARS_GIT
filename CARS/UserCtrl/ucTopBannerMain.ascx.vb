Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Threading
Imports System.Globalization
Imports System.Reflection
Public Class ucTopBannerMain
    Inherits System.Web.UI.UserControl
    Dim objMainMenuBO As New ConfigRoleBO
    Dim objMainMenuDO As New Role.ConfigRoleDO
    Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim objConfigRoleMenu As New Services.ConfigRole.Role
    Dim leftMenu() As String = {"/Transactions/frmTimeRegCTPMech.aspx", "/Transactions/frmTimeRegCTPOrder.aspx", "/Transactions/frmTimeRegInsInOut.aspx"}
    Dim objLoginBO As New LoginBO
    Dim objLoginDO As New Login.LoginDO
    Dim SitePath As String
    Dim dsMenuData As New DataSet
    Dim MainMenuItem As New MenuItem
    Dim strLanguage As String = ""
    Dim screenName As String = ""
    Dim dtCaption As DataTable


    Protected Sub btn_Click(sender As Object, e As EventArgs)
        Dim btn As Button = sender

        Select Case btn.ID
            Case ("btnEngland")
                Session("culture") = "en-GB"
                Server.Transfer(Request.Url.PathAndQuery, False)
            Case ("btnNorway")
                Session("culture") = "nb-NO"
                Server.Transfer(Request.Url.PathAndQuery, False)
            Case ("btnLituania")
                Session("culture") = "lt-LT"
                Server.Transfer(Request.Url.PathAndQuery, False)
        End Select
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hlnkMSGLogout.Text = dtCaption.Select("TAG='lblLogout'")(0)(1)
            RTLblVersion.Text = dtCaption.Select("TAG='lblVersion'")(0)(1)

            Menu1.DynamicPopOutImageTextFormatString = RTlblExpand.Text + " {0}"
            Menu1.StaticPopOutImageTextFormatString = RTlblExpand.Text + " {0}"
            strLanguage = System.Configuration.ConfigurationManager.AppSettings("Language")
            screenName = IO.Path.GetFileName("ucTopBannerMain.ascx")

            hlnkMSGLogout.NavigateUrl = "~/frmlogin.aspx"

            If Session("UserId") Is Nothing Then
                RTLblUser.Text = "'" + "ABS-10 User" + "'"
            Else
                If Not Page.IsPostBack Then
                    SitePath = Application("AppPath")
                    RTLblUser.Text = "'" + Session("UserId") + "'" ' + Request.PhysicalPath.ToString()
                    'RTDeptName.Text = Session("DeptName")
                    dsMenuData = Session("usermenu")
                    If (dsMenuData Is Nothing) Then
                        objMainMenuBO.User = Session("UserId")
                        objMainMenuBO.LanguageId = ConfigurationManager.AppSettings("Language")
                        dsMenuData = objConfigRoleMenu.GetMenuData(objMainMenuBO)
                        Session("usermenu") = dsMenuData
                    End If
                    DrawUserMenu(dsMenuData)
                    RTlblver.Text = IIf(System.Configuration.ConfigurationManager.AppSettings("Version") Is Nothing, "", System.Configuration.ConfigurationManager.AppSettings("Version"))
                End If
                GetPageAcess()
                If Not Session("OtherScreen") Is Nothing Then
                    Menu1.Visible = False
                End If
            End If
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "DrawUserMenu", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")
        End Try
    End Sub
    Private Sub DrawUserMenu(ByVal dsMenuData As DataSet)
        Try
            Dim m As MenuItem
            Dim i As Integer
            Dim dr As DataRow
            Dim lev As String
            For i = 0 To dsMenuData.Tables("TBL_UTIL_MOD_DETAILS").Rows.Count - 1
                m = New MenuItem
                dr = dsMenuData.Tables("TBL_UTIL_MOD_DETAILS").Rows(i)
                m.Text = dr("text").ToString()
                m.Value = dr("MenuID").ToString()
                lev = dr("parentid").ToString()

                If lev = "" Then
                    submenus(m, dsMenuData.Tables("TBL_UTIL_MOD_DETAILS"), dr("MenuID").ToString())
                    Menu1.Items.Add(m)
                    If (dr("DESCRIPTION").ToString() <> "") Then
                        m.NavigateUrl = Application("AppPath") & dr("DESCRIPTION").ToString()
                    Else
                        m.NavigateUrl = ""
                        m.Selectable = True
                    End If
                End If
            Next
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "DrawUserMenu", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")
        End Try
    End Sub
    Private Sub submenus(ByRef menuItemParent As MenuItem, ByVal dt As DataTable, ByVal intmenuID As Integer)
        Try
            Dim i As Integer
            Dim SitePath As String
            Dim retVal As String = ""
            Dim PageN As String = ""
            Dim ret As String = ""
            Dim PageName As String = ""
            Dim m1 As MenuItem
            Dim drMenu As DataRow
            Dim drs() As DataRow
            Dim PopUpQW As String = ""
            Dim PopUpTH As String = ""

            SitePath = Application("AppPath")
            drs = dt.Select("parentid='" + intmenuID.ToString() + "'")
            For i = 0 To drs.Length - 1
                m1 = New MenuItem
                drMenu = drs(i)
                m1.Text = drMenu("text").ToString()
                Dim arrMenu As Array = drMenu("DESCRIPTION").ToString().Split("/")
                m1.NavigateUrl = arrMenu(2).ToString
                m1.Value = drMenu("MenuID").ToString()

                If m1.Text = PageN And retVal = "0" Then
                    menuItemParent.ChildItems.Remove(m1)
                ElseIf m1.Text = PageName And ret = "0" Then
                    menuItemParent.ChildItems.Remove(m1)
                Else
                    If m1.Text = PopUpQW Then
                        menuItemParent.ChildItems.Remove(m1)
                    ElseIf m1.Text = PopUpTH Then
                        menuItemParent.ChildItems.Remove(m1)
                    Else
                        m1.NavigateUrl = SitePath & drMenu("DESCRIPTION").ToString()
                        menuItemParent.ChildItems.Add(m1)
                        submenus(m1, dt, drMenu("MenuID").ToString())
                    End If
                End If
            Next
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "DrawUserMenu", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")
        End Try
    End Sub
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
                objLoginBO.UserId = Session("UserId")
                DsUser = objLoginDO.GetPageAcess(objLoginBO)
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
            Next
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "DrawUserMenu", "GetPageAcess", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserControl")
        End Try
        Return BolRet
    End Function
    Public Sub GetUserScrPer(ByVal DT As DataTable, ByVal FileName As String)
        Dim objuserper As New CoreLibrary.UserAccessPermissionsBO
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
        Catch ex As Exception
            Session("UserPerDetails") = objuserper
        End Try
    End Sub
    
End Class