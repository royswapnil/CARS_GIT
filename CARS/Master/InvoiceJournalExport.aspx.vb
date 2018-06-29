Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Imports System.Globalization
Public Class InvoiceJournalExport
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared details As New List(Of InvJournalExportBO)()
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objInvExpBO As New CARS.CoreLibrary.InvJournalExportBO
    Shared objInvExpSvc As New Services.InvJournalExport.InvJournalExport
    Dim strText As String
    Dim strValue As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            LoginName = CType(Session("UserID"), String)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        If Not IsPostBack Then
            GetCulture()
            ddlSpDelimiter.Items.Clear()
            ddlSpDelimiter.AppendDataBoundItems = True
            objCommonUtil.ddlGetValue(strscreenName, ddlSpDelimiter)
            hdnTemplateId.Value = "0"

        End If
        hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
    End Sub
    Private Sub GetCulture()
        Dim ci As CultureInfo() = CultureInfo.GetCultures(CultureTypes.SpecificCultures)
        For i As Integer = 0 To ci.Length - 1
            'Default value for Char Set
            strText = ci(i).EnglishName
            strValue = ci(i).Name
            GetDefaultValue(ddlCharSet, strText, strValue, CultureInfo.CurrentCulture.ToString())
        Next
        SetCultureInfo()
    End Sub
    Private Sub SetCultureInfo()
        Dim info As CultureInfo = New CultureInfo(ddlCharSet.SelectedValue.ToString())

        'Default Value for Decimal Delimiter
        strText = info.NumberFormat.CurrencyDecimalSeparator
        ddlDecDelimiter.Items.Clear()
        ddlDecDelimiter.Items.Add(New ListItem(strText, strText))

        'Default Value for Thousand Delimiter
        strText = info.NumberFormat.CurrencyGroupSeparator
        ddlThousDelimiter.Items.Clear()
        ddlThousDelimiter.Items.Add(New ListItem(strText, strText))

        'Default Value for Date
        strText = info.DateTimeFormat.ShortDatePattern
        ddlDate.Items.Clear()
        ddlDate.Items.Add(New ListItem(strText, strText))


        'Default Value for Time
        strText = info.DateTimeFormat.ShortTimePattern
        ddlTime.Items.Clear()
        ddlTime.Items.Add(New ListItem(strText, strText))

    End Sub
    Private Sub GetDefaultValue(ByVal ddl As DropDownList, ByVal Text As String, ByVal Value As String, ByVal IndexValue As String)
        Try
            If Not (ddl.Items.Contains(ddl.Items.FindByText(Text))) Then
                ddl.Items.Add(New ListItem(Text, Value))

            End If
            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(IndexValue))
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "GetDefaultValue", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
            Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadImportListGrd(ByVal fileType As String, ByVal fileName As String) As InvJournalExportBO()
        Try
            objInvExpBO.FileType = fileType
            objInvExpBO.FileName = fileName
            details = objInvExpSvc.FetchImportListGrd(objInvExpBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_InvoiceJournalExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function BindExportConfig(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String) As InvJournalExportBO()
        Try
            objInvExpBO.FileType = fileType
            objInvExpBO.FileName = fileName
            objInvExpBO.TemplateId = templateId
            details = objInvExpSvc.FetchExportConfig(objInvExpBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_InvoiceJournalExport", "BindExportConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function loadControls(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String) As InvJournalExportBO()
        Try



            objInvExpBO.FileType = fileType
            objInvExpBO.FileName = fileName
            objInvExpBO.TemplateId = templateId
            details = objInvExpSvc.FetchExportConfigEdit(objInvExpBO)


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_InvoiceJournalExport", "loadControls", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveExpConfig(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String, ByVal importTypeName As String, ByVal charSet As String, ByVal decimalDelim As String, ByVal thouDelim As String, _
             ByVal dateFormat As String, ByVal timeFormat As String, ByVal fileMode As String, ByVal otherDelimiter As String, ByVal desc As String, ByVal Configuration As String, ByVal splDelimiter As String) As String
        Dim strRetVal As String
        Try
            objInvExpBO.FileType = fileType
            objInvExpBO.FileName = fileName
            If templateId = "0" Then
                objInvExpBO.TemplateId = Nothing
            Else

                objInvExpBO.TemplateId = templateId
            End If
            objInvExpBO.TemplateName = importTypeName
            objInvExpBO.CharacterSet = charSet
            objInvExpBO.DecimalDelimiter = decimalDelim
            objInvExpBO.ThousandsDelimiter = thouDelim
            objInvExpBO.DateFormat = dateFormat
            objInvExpBO.TimeFormat = timeFormat
            objInvExpBO.FileMode = fileMode
            objInvExpBO.DelimiterOther = otherDelimiter
            objInvExpBO.Description = desc
            objInvExpBO.Configuration = Configuration
            objInvExpBO.SpecialDelimiter = splDelimiter
            objInvExpBO.UserId = loginName
            strRetVal = objInvExpSvc.SaveExportConfig(objInvExpBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_InvoiceJournalExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function DeleteExportConfig(ByVal FileType As String, ByVal fileName As String, ByVal templateId As String) As String
        Dim strVal As String = ""
        Try

            objInvExpBO.FileType = FileType
            objInvExpBO.FileName = fileName
            objInvExpBO.TemplateId = templateId
            strVal = objInvExpSvc.DeleteConfiguration(objInvExpBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "DeleteExportConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
End Class