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
Public Class CustomerExport
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared details As New List(Of CustomerExportBO)()
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objCusExpBO As New CARS.CoreLibrary.CustomerExportBO
    Shared objCusExpSvc As New Services.CustomerExport.CustomerExport
    Dim strText As String
    Dim strValue As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        If Not IsPostBack Then
            GetCulture()
            'ddlSpDelimiter.Items.Insert(0, New ListItem("--Select--", "0"))
            ddlSpDelimiter.Items.Clear()
            ddlSpDelimiter.AppendDataBoundItems = True
            objCommonUtil.ddlGetValue(strscreenName, ddlSpDelimiter)
            hdnTemplateId.Value = "0"
            'divControls.Visible = False
            'divExpGrid.Visible = False
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
    Public Shared Function LoadImportListGrd(ByVal fileType As String, ByVal fileName As String) As CustomerExportBO()
        Try
            objCusExpBO.FileType = fileType
            objCusExpBO.FileName = fileName
            details = objCusExpSvc.FetchImportLstGrd(objCusExpBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "BindExportConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function BindExportConfig(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String) As CustomerExportBO()
        Try
            If templateId <> "0" Then
                objCusExpBO.FileType = fileType
                objCusExpBO.FileName = fileName
                objCusExpBO.TemplateId = templateId
                details = objCusExpSvc.FetchExportConfigEditDelimiter(objCusExpBO)
            Else
                objCusExpBO.FileType = fileType
                objCusExpBO.FileName = fileName
                details = objCusExpSvc.FetchExportConfigAdd(objCusExpBO)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function loadControls(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String) As CustomerExportBO()
        Try

            

            objCusExpBO.FileType = fileType
            objCusExpBO.FileName = fileName
            objCusExpBO.TemplateId = templateId
            details = objCusExpSvc.FetchExportConfigEdit(objCusExpBO)


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function loadCharSetControls(ByVal CharSet As String) As CustomerExportBO()
        Try
            objCusExpBO.CharacterSet = CharSet
            details = objCusExpSvc.SetCulturInfo(objCusExpBO)


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function

    'Protected Sub ddlCharSet_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCharSet.SelectedIndexChanged
    '    Try
    '        SetCultureInfo()
    '    Catch ex As Exception
    '        objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "ddlCharSet_SelectedIndexChanged", ex.Message, ex.ToString().Trim, Session("UserID"))
    '        'Throw ex
    '    End Try
    'End Sub
    <WebMethod()> _
    Public Shared Function SaveExpConfig(ByVal fileType As String, ByVal fileName As String, ByVal templateId As String, ByVal importTypeName As String, ByVal charSet As String, ByVal decimalDelim As String, ByVal thouDelim As String, _
             ByVal dateFormat As String, ByVal timeFormat As String, ByVal fileMode As String, ByVal otherDelimiter As String, ByVal desc As String, ByVal Configuration As String, ByVal splDelimiter As String) As String
        Dim strRetVal As String
        Try
            objCusExpBO.FileType = fileType
            objCusExpBO.FileName = fileName
            If templateId = "0" Then
                objCusExpBO.TemplateId = Nothing
            Else

                objCusExpBO.TemplateId = templateId
            End If
            objCusExpBO.TemplateName = importTypeName
            objCusExpBO.CharacterSet = charSet
            objCusExpBO.DecimalDelimiter = decimalDelim
            objCusExpBO.ThousandsDelimiter = thouDelim
            objCusExpBO.DateFormat = dateFormat
            objCusExpBO.TimeFormat = timeFormat
            objCusExpBO.FileMode = fileMode
            objCusExpBO.DelimiterOther = otherDelimiter
            objCusExpBO.Description = desc
            objCusExpBO.Configuration = Configuration
            objCusExpBO.SpecialDelimiter = splDelimiter
            objCusExpBO.UserId = loginName
            strRetVal = objCusExpSvc.SaveExportConfigEdit(objCusExpBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "LoadImportListGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRetVal
    End Function
    <WebMethod()> _
    Public Shared Function DeleteExportConfig(ByVal FileType As String, ByVal fileName As String, ByVal templateId As String) As String
        Dim strVal As String = ""
        Try

            objCusExpBO.FileType = fileType
            objCusExpBO.FileName = fileName
            objCusExpBO.TemplateId = templateId
            strVal = objCusExpSvc.DeleteConfiguration(objCusExpBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CustomerExport", "DeleteExportConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
End Class