Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class ucWOMenutabs
    Inherits System.Web.UI.UserControl
    Dim objUserPermBO As New UserAccessPermissionsBO
    Dim objUserPermServ As New CARS.CoreLibrary.CARS.Services.Login.MenuDetails
    Dim dtvMenu As DataView
    Dim dsMenu As DataSet
    Dim dtMenu As New DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ind As Integer
        Dim intstatus As Integer
        Dim strpagename, strnpagename As String
        'If IsNothing(Request.QueryString("TabId")) Or Session("sessMaintTab") Is Nothing Then
        If (Session.Item("sessMaintTab") Is Nothing) Or ((Not IsNothing(Session.Item("sessMaintTab")) And (Session("CurModule") <> "WO"))) Then
            objUserPermBO.Lang_Name = System.Configuration.ConfigurationManager.AppSettings("Language")
            objUserPermBO.Module_Name = "WO"
            dsMenu = objUserPermServ.GetTopMenuDetails(objUserPermBO)
            dtMenu = dsMenu.Tables(0)
            Dim DsUser As DataSet = CType(Session("UserPerDel"), DataSet)
            For ind = 0 To dtMenu.Rows.Count - 1
                strpagename = dtMenu.Rows(ind)(2)
                intstatus = GetUserScrPermStatus(DsUser.Tables(2), strpagename)
                If intstatus = 1 Then
                    If dtMenu.Rows(ind)(0).ToString() = 2 Then
                        strnpagename = strpagename + "?TabId=" + dtMenu.Rows(ind)(0).ToString() + "&Flag=" + fnEncryptQString("Ser")
                    Else
                        strnpagename = strpagename + "?TabId=" + dtMenu.Rows(ind)(0).ToString()
                    End If

                    'Modified Date: 24 Sep 2008
                    'Comments: Top Banner not to be displayed when called from frmGPDayplanMech.aspx
                    If Not Request.QueryString("Scr") Is Nothing Then
                        strnpagename = strnpagename + "&Scr=" + fnEncryptQString("Dis")
                    End If
                    'End of Modification

                Else
                    strnpagename = ""
                End If

                dtMenu.Rows(ind).BeginEdit()
                dtMenu.Rows(ind)(2) = strnpagename
                dtMenu.Rows(ind).EndEdit()

            Next
            dtMenu.AcceptChanges()
            dtvMenu = dtMenu.DefaultView
            Session.Item("sessMaintTab") = dtvMenu
            Session("CurModule") = "WO"
        Else
            dtvMenu = Session.Item("sessMaintTab")
        End If
        With RptrMainTabs
            .DataSource = dtvMenu
            .DataBind()
        End With
    End Sub
    Public Function GetUserScrPermStatus(ByVal DT As DataTable, ByVal FileName As String) As Integer
        Dim dr() As DataRow
        Try
            FileName = FileName.Replace("\", "/")
            FileName = FileName.Substring(FileName.IndexOf("/"), FileName.Length - 2)
            dr = DT.Select("NAME_URL LIKE '" & FileName.Trim() & "'")
            If dr.Length <> 0 Then
                Return 1
            Else
                Return 0
            End If
        Catch ex As Exception
        End Try

    End Function
    Protected Sub RptrMainTabs_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles RptrMainTabs.ItemCommand
        Dim s1 As String
        s1 = e.Item.ToString()
    End Sub
    Protected Sub RptrMainTabs_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles RptrMainTabs.ItemDataBound
        Dim MainTabHPLink As System.Web.UI.WebControls.HyperLink
        Dim intTabidHighlgt As Integer


        MainTabHPLink = e.Item.FindControl("HLlnkMainLinks")
        If Request.QueryString("TabId") <> "" Then
            intTabidHighlgt = Request.QueryString("TabId")
        Else
            intTabidHighlgt = dtvMenu.Item(0)(0)
        End If

        If Not IsNothing(MainTabHPLink) Then

            If MainTabHPLink.TabIndex = intTabidHighlgt Then
                MainTabHPLink.CssClass = "lvl12LnSel"
                'added on oct 23
                MainTabHPLink.NavigateUrl = ""
            Else
                MainTabHPLink.CssClass = "lvl12Lnnrm"
            End If
        End If

    End Sub
    Public Function fnEncryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Try
            Dim objEncryption As New Encryption64
            If strEncrypted Is Nothing Then Return ""
            Return objEncryption.Encrypt(strEncrypted, ConfigurationManager.AppSettings.Get("encKey"))
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        End Try
    End Function
End Class