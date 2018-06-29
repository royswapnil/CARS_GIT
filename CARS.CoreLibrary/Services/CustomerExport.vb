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
Imports System.Globalization
Namespace CARS.Services.CustomerExport
    Public Class CustomerExport
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objCustExpDO As New CARS.CustomerExport.CustomerExportDO
        Shared objCustExpBO As New CustomerBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Public Function FetchImportLstGrd(ByVal objCustExpBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim dsCustExprt As New DataSet
            Dim dtCustExprt As New DataTable
            Dim details As New List(Of CustomerExportBO)()
            dsCustExprt = objCustExpDO.FetchFieldConfiguration(objCustExpBO)
            If dsCustExprt.Tables(0).Rows.Count > 0 Then
                dtCustExprt = dsCustExprt.Tables(0)
                For Each dtrow As DataRow In dtCustExprt.Rows
                    Dim CustExpDet As New CustomerExportBO()
                    CustExpDet.TemplateId = dtrow("TEMPLATE_ID")
                    CustExpDet.TemplateName = dtrow("TEMPLATE_NAME")
                    CustExpDet.Description = dtrow("DESCRIPTION")
                    details.Add(CustExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchExportConfigEditDelimiter(ByVal objCustExpBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim dsCustExprt As New DataSet
            Dim dtCustExprt As New DataTable
            Dim dtFileModeCustExprt As New DataTable
            Dim details As New List(Of CustomerExportBO)()
            dsCustExprt = objCustExpDO.FetchConfiguration(objCustExpBO)
            If dsCustExprt.Tables(0).Rows.Count > 0 Then
                dtFileModeCustExprt = dsCustExprt.Tables(0)
                For Each dtrow As DataRow In dtFileModeCustExprt.Rows
                    Dim CustExpDet1 As New CustomerExportBO()
                    CustExpDet1.FileMode = dtrow("FILE_MODE")
                    details.Add(CustExpDet1)

                Next
            End If
            If dsCustExprt.Tables(1).Rows.Count > 0 Then
                dtCustExprt = dsCustExprt.Tables(1)
                For Each dtrow As DataRow In dtCustExprt.Rows
                    Dim CustExpDet As New CustomerExportBO()
                    CustExpDet.FieldName = dtrow("FIELD_NAME")
                    CustExpDet.FieldId = dtrow("FIELD_ID")
                    CustExpDet.PositionFrom = IIf(IsDBNull(dtrow("POSITION_FROM")) = True, "", dtrow("POSITION_FROM"))
                    CustExpDet.Length = IIf(IsDBNull(dtrow("FIELD_LENGTH")) = True, "", dtrow("FIELD_LENGTH"))
                    CustExpDet.OrderInFile = IIf(IsDBNull(dtrow("ORDER_IN_FILE")) = True, "", dtrow("ORDER_IN_FILE"))
                    CustExpDet.DecimalDivide = IIf(IsDBNull(dtrow("DECIMAL_DIVIDE")) = True, "", dtrow("DECIMAL_DIVIDE"))
                    CustExpDet.FixedInformation = IIf(IsDBNull(dtrow("FIXED_VALUE")) = True, "", dtrow("FIXED_VALUE"))
                    CustExpDet.EnclosingChar = IIf(IsDBNull(dtrow("ENCLOSING_CHAR")) = True, "", dtrow("ENCLOSING_CHAR"))
                    CustExpDet.IsDecimalDivide = dtrow("IS_DECIMAL_DIVIDE")
                    details.Add(CustExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchExportConfigAdd(ByVal objCustExpBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim dsCustExprt As New DataSet
            Dim dtCustExprt As New DataTable
            Dim details As New List(Of CustomerExportBO)()
            dsCustExprt = objCustExpDO.FetchTemplateConfigurations(objCustExpBO)
            If dsCustExprt.Tables(0).Rows.Count > 0 Then
                dtCustExprt = dsCustExprt.Tables(0)
                For Each dtrow As DataRow In dtCustExprt.Rows
                    Dim CustExpDet As New CustomerExportBO()
                    CustExpDet.FieldId = dtrow("FIELD_ID")
                    CustExpDet.FieldName = dtrow("FIELD_NAME")
                    CustExpDet.PositionFrom = IIf(IsDBNull(dtrow("POSITION_FROM")) = True, "", dtrow("POSITION_FROM"))
                    CustExpDet.Length = IIf(IsDBNull(dtrow("FIELD_LENGTH")) = True, "", dtrow("FIELD_LENGTH"))
                    CustExpDet.OrderInFile = IIf(IsDBNull(dtrow("ORDER_IN_FILE")) = True, "", dtrow("ORDER_IN_FILE"))
                    CustExpDet.DecimalDivide = IIf(IsDBNull(dtrow("DECIMAL_DIVIDE")) = True, "", dtrow("DECIMAL_DIVIDE"))
                    CustExpDet.FixedInformation = IIf(IsDBNull(dtrow("FIXED_VALUE")) = True, "", dtrow("FIXED_VALUE"))
                    CustExpDet.EnclosingChar = IIf(IsDBNull(dtrow("ENCLOSING_CHAR")) = True, "", dtrow("ENCLOSING_CHAR"))
                    details.Add(CustExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchExportConfigEdit(ByVal objCustExpBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim dsCustExprt As New DataSet
            Dim dtCustExprt As New DataTable
            Dim details As New List(Of CustomerExportBO)()
            dsCustExprt = objCustExpDO.FetchConfiguration(objCustExpBO)
            If dsCustExprt.Tables(0).Rows.Count > 0 Then
                dtCustExprt = dsCustExprt.Tables(0)
                For Each dtrow As DataRow In dtCustExprt.Rows
                    Dim CustExpDet As New CustomerExportBO()
                    CustExpDet.TemplateName = dtrow("TEMPLATE_NAME")
                    CustExpDet.Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    CustExpDet.DelimiterOther = IIf(IsDBNull(dtrow("DELIMITER_OTHER")) = True, "", dtrow("DELIMITER_OTHER"))
                    CustExpDet.CharacterSet = IIf(IsDBNull(dtrow("CHARACTER_SET")) = True, "", dtrow("CHARACTER_SET"))
                    CustExpDet.DecimalDelimiter = IIf(IsDBNull(dtrow("DECIMAL_DELIMITER")) = True, "", dtrow("DECIMAL_DELIMITER"))
                    CustExpDet.ThousandsDelimiter = IIf(IsDBNull(dtrow("THOUSANDS_DELIMITER")) = True, "", dtrow("THOUSANDS_DELIMITER"))
                    CustExpDet.DateFormat = IIf(IsDBNull(dtrow("DATE_FORMAT")) = True, "", dtrow("DATE_FORMAT"))
                    CustExpDet.TimeFormat = IIf(IsDBNull(dtrow("TIME_FORMAT")) = True, "", dtrow("TIME_FORMAT"))
                    CustExpDet.FileMode = IIf(IsDBNull(dtrow("FILE_MODE")) = True, "", dtrow("FILE_MODE"))
                    CustExpDet.SpecialDelimiter = dtrow("DELIMITER")
                    details.Add(CustExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function SaveExportConfigEdit(ByVal objCustExpConfigBO As CustomerExportBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objCustExpDO.SaveConfiguration(objCustExpConfigBO)
            If strResult = "" Then
                strRes = objErrHandle.GetErrorDescParameter("SAVED")
            End If
            Return strRes
        End Function
        Public Function DeleteConfiguration(ByVal objCustExpConfigBO As CustomerExportBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objCustExpDO.DeleteConfiguration(objCustExpConfigBO)
            If strResult.ToLower() = "deleted" Then
                strRes = objErrHandle.GetErrorDescParameter("CONFIGDELETED")
            ElseIf strResult.ToLower() = "inuse" Then
                strRes = objErrHandle.GetErrorDescParameter("CONFIGINUSE")
            End If
            Return strRes
        End Function
        Public Function SetCulturInfo(ByVal objCustExpConfigBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim details As New List(Of CustomerExportBO)()
            Dim info As CultureInfo = New CultureInfo(objCustExpConfigBO.CharacterSet)
            Dim CustExpDet As New CustomerExportBO()
            CustExpDet.DecimalDelimiter = info.NumberFormat.CurrencyDecimalSeparator
            CustExpDet.ThousandsDelimiter = info.NumberFormat.CurrencyGroupSeparator
            CustExpDet.DateFormat = info.DateTimeFormat.ShortDatePattern
            CustExpDet.TimeFormat = info.DateTimeFormat.ShortTimePattern
            details.Add(CustExpDet)
            Return details.ToList
        End Function
        Public Function SaveSpareConfiguration(ByVal objCustExpConfigBO As CustomerExportBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objCustExpDO.SaveSpareConfiguration(objCustExpConfigBO)
            If strResult = "" Then
                strRes = objErrHandle.GetErrorDescParameter("SAVED")
            End If
            Return strRes
        End Function
        Public Function FetchSpareTemplateConfigEdit(ByVal objCustExpBO As CustomerExportBO) As List(Of CustomerExportBO)
            Dim dsCustExprt As New DataSet
            Dim dtCustExprt As New DataTable
            Dim details As New List(Of CustomerExportBO)()
            dsCustExprt = objCustExpDO.FetchConfiguration(objCustExpBO)
            If dsCustExprt.Tables(0).Rows.Count > 0 Then
                dtCustExprt = dsCustExprt.Tables(0)
                For Each dtrow As DataRow In dtCustExprt.Rows
                    Dim CustExpDet As New CustomerExportBO()
                    CustExpDet.TemplateName = dtrow("TEMPLATE_NAME")
                    CustExpDet.Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    CustExpDet.DelimiterOther = IIf(IsDBNull(dtrow("DELIMITER_OTHER")) = True, "", dtrow("DELIMITER_OTHER"))
                    CustExpDet.CharacterSet = IIf(IsDBNull(dtrow("CHARACTER_SET")) = True, "", dtrow("CHARACTER_SET"))
                    CustExpDet.DecimalDelimiter = IIf(IsDBNull(dtrow("DECIMAL_DELIMITER")) = True, "", dtrow("DECIMAL_DELIMITER"))
                    CustExpDet.ThousandsDelimiter = IIf(IsDBNull(dtrow("THOUSANDS_DELIMITER")) = True, "", dtrow("THOUSANDS_DELIMITER"))
                    CustExpDet.DateFormat = IIf(IsDBNull(dtrow("DATE_FORMAT")) = True, "", dtrow("DATE_FORMAT"))
                    CustExpDet.TimeFormat = IIf(IsDBNull(dtrow("TIME_FORMAT")) = True, "", dtrow("TIME_FORMAT"))
                    CustExpDet.FileMode = IIf(IsDBNull(dtrow("FILE_MODE")) = True, "", dtrow("FILE_MODE"))
                    CustExpDet.SpecialDelimiter = dtrow("DELIMITER")
                    CustExpDet.PrefixLen = dtrow("ORDER_PRE_LEN")
                    CustExpDet.SeriesLen = dtrow("ORDER_SERIES_LEN")
                    CustExpDet.JobIdLen = dtrow("JOB_ID_LEN")
                    details.Add(CustExpDet)
                Next
            End If
            Return details.ToList
        End Function
    End Class
End Namespace
