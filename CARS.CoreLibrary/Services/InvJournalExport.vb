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
Namespace CARS.Services.InvJournalExport
    Public Class InvJournalExport
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objInvExpDO As New CARS.InvoiceJournalExport.InvJournalExportDO
        Shared objInvExpBO As New InvJournalExportBO
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim objDB As Database
        Dim ConnectionString As String
        Public Function FetchImportListGrd(ByVal objInvExpBO As InvJournalExportBO) As List(Of InvJournalExportBO)
            Dim dsInvExprt As New DataSet
            Dim dtInvExprt As New DataTable
            Dim details As New List(Of InvJournalExportBO)()
            dsInvExprt = objInvExpDO.FetchFieldConfiguration(objInvExpBO)
            If dsInvExprt.Tables(0).Rows.Count > 0 Then
                dtInvExprt = dsInvExprt.Tables(0)
                For Each dtrow As DataRow In dtInvExprt.Rows
                    Dim InvExpDet As New InvJournalExportBO()
                    InvExpDet.TemplateId = dtrow("TEMPLATE_ID")
                    InvExpDet.TemplateName = dtrow("TEMPLATE_NAME")
                    InvExpDet.Description = dtrow("DESCRIPTION")
                    details.Add(InvExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchExportConfig(ByVal objInvExpBO As InvJournalExportBO) As List(Of InvJournalExportBO)
            Dim dsInvExprt As New DataSet
            Dim dtInvExprt As New DataTable
            Dim details As New List(Of InvJournalExportBO)()
            dsInvExprt = objInvExpDO.FetchConfiguration(objInvExpBO)
            If dsInvExprt.Tables(1).Rows.Count > 0 Then
                dtInvExprt = dsInvExprt.Tables(1)
                For Each dtrow As DataRow In dtInvExprt.Rows
                    Dim InvExpDet As New InvJournalExportBO()
                    InvExpDet.FieldName = dtrow("FIELD_NAME")
                    InvExpDet.FieldId = dtrow("FIELD_ID")
                    InvExpDet.PositionFrom = IIf(IsDBNull(dtrow("POSITION_FROM")) = True, "", dtrow("POSITION_FROM"))
                    InvExpDet.Length = IIf(IsDBNull(dtrow("FIELD_LENGTH")) = True, "", dtrow("FIELD_LENGTH"))
                    InvExpDet.OrderInFile = IIf(IsDBNull(dtrow("ORDER_IN_FILE")) = True, "", dtrow("ORDER_IN_FILE"))
                    InvExpDet.DecimalDivide = IIf(IsDBNull(dtrow("DECIMAL_DIVIDE")) = True, "", dtrow("DECIMAL_DIVIDE"))
                    InvExpDet.FixedInformation = IIf(IsDBNull(dtrow("FIXED_VALUE")) = True, "", dtrow("FIXED_VALUE"))
                    InvExpDet.EnclosingChar = IIf(IsDBNull(dtrow("ENCLOSING_CHAR")) = True, "", dtrow("ENCLOSING_CHAR"))
                    InvExpDet.ARVatFree = IIf(IsDBNull(dtrow("AR_VAT_FREE")) = True, "", dtrow("AR_VAT_FREE"))
                    InvExpDet.ARVatPaying = IIf(IsDBNull(dtrow("AR_VAT_PAYING")) = True, "", dtrow("AR_VAT_PAYING"))
                    InvExpDet.GLVatFree = IIf(IsDBNull(dtrow("GL_VAT_FREE")) = True, "", dtrow("GL_VAT_FREE"))
                    InvExpDet.GLVatPaying = IIf(IsDBNull(dtrow("GL_VAT_PAYING")) = True, "", dtrow("GL_VAT_PAYING"))
                    InvExpDet.IsVatCheck = dtrow("IS_VAT_CHECK")
                    InvExpDet.IsDecimalDivide = dtrow("IS_DECIMAL_DIVIDE")
                    details.Add(InvExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function FetchExportConfigEdit(ByVal objInvExpBO As InvJournalExportBO) As List(Of InvJournalExportBO)
            Dim dsInvExprt As New DataSet
            Dim dtInvExprt As New DataTable
            Dim details As New List(Of InvJournalExportBO)()
            dsInvExprt = objInvExpDO.FetchConfiguration(objInvExpBO)
            If dsInvExprt.Tables(0).Rows.Count > 0 Then
                dtInvExprt = dsInvExprt.Tables(0)
                For Each dtrow As DataRow In dtInvExprt.Rows
                    Dim InvExpDet As New InvJournalExportBO()
                    InvExpDet.TemplateName = dtrow("TEMPLATE_NAME")
                    InvExpDet.Description = IIf(IsDBNull(dtrow("DESCRIPTION")) = True, "", dtrow("DESCRIPTION"))
                    InvExpDet.DelimiterOther = IIf(IsDBNull(dtrow("DELIMITER_OTHER")) = True, "", dtrow("DELIMITER_OTHER"))
                    InvExpDet.CharacterSet = IIf(IsDBNull(dtrow("CHARACTER_SET")) = True, "", dtrow("CHARACTER_SET"))
                    InvExpDet.DecimalDelimiter = IIf(IsDBNull(dtrow("DECIMAL_DELIMITER")) = True, "", dtrow("DECIMAL_DELIMITER"))
                    InvExpDet.ThousandsDelimiter = IIf(IsDBNull(dtrow("THOUSANDS_DELIMITER")) = True, "", dtrow("THOUSANDS_DELIMITER"))
                    InvExpDet.DateFormat = IIf(IsDBNull(dtrow("DATE_FORMAT")) = True, "", dtrow("DATE_FORMAT"))
                    InvExpDet.TimeFormat = IIf(IsDBNull(dtrow("TIME_FORMAT")) = True, "", dtrow("TIME_FORMAT"))
                    InvExpDet.FileMode = IIf(IsDBNull(dtrow("FILE_MODE")) = True, "", dtrow("FILE_MODE"))
                    InvExpDet.SpecialDelimiter = dtrow("DELIMITER")
                    details.Add(InvExpDet)
                Next
            End If
            Return details.ToList
        End Function
        Public Function SaveExportConfig(ByVal objInvExpBO As InvJournalExportBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objInvExpDO.SaveConfiguration(objInvExpBO)
            If strResult = "" Then
                strRes = objErrHandle.GetErrorDescParameter("SAVED")
            ElseIf strResult.ToLower() = "exists" Then
                strRes = objErrHandle.GetErrorDescParameter("AEXISTS")
            End If
            Return strRes
        End Function
        Public Function DeleteConfiguration(ByVal objInvExpBO As InvJournalExportBO) As String
            Dim strResult As String = ""
            Dim strRes As String = ""
            strResult = objInvExpDO.DeleteConfiguration(objInvExpBO)
            If strResult.ToLower() = "deleted" Then
                strRes = objErrHandle.GetErrorDescParameter("CONFIGDELETED")
            ElseIf strResult.ToLower() = "inuse" Then
                strRes = objErrHandle.GetErrorDescParameter("CONFIGINUSE")
            End If
            Return strRes
        End Function
    End Class
End Namespace
