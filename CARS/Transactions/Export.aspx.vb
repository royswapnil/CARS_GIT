Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Imports System.IO
Public Class Export
    Inherits System.Web.UI.Page
    Dim objCommonUtil As New Utilities.CommonUtility
    Dim objLADO As New LinkToAccountingDO.LinkToAccountingDO
    Dim objLABO As New LinkToAccountingBO
    Dim objConfigLADO As New ConfigLADO.ConfigLADO
    Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim objDr() As DataRow
    Dim TemplateID As String
    Dim Char_Set As String
    Dim ExpMode As String
    Dim DataSeparator As String
    Dim dblValue As Decimal
    Dim boolVal As Boolean
    Dim StrReturn As String = ""
    Dim TableColumns As DataColumnCollection
    Dim TableRows As DataRowCollection
    Dim TableRowsgross As DataRowCollection
    Dim Config_Path As String
    Dim strFilename As String
    Dim ds_Config As New DataSet
    Dim Flg_DateCheck As String
    Dim Flg_Textcheck As String
    Dim Flg_AdditionalText As String
    Dim Flg_CustomerText As String
    Dim strErrlogMsg As String
    Dim dsfetchinvtransid As DataSet
    Dim dsCustomer As DataSet
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("strReturn") = "Customer Export" Then
                dsCustomer = Session("dsCustomer")
                strFilename = Session("CustFileName")

            Else
                Config_Path = GetConfigPath_InvExport()
                If Session("TransId") = "0" Then
                    strFilename = GetFileName_InvExport()
                Else
                    strFilename = GetFileName_InvExport_TransId()
                End If

                dsfetchinvtransid = Session("ds")
                fndstofile(dsfetchinvtransid)
            End If


            Response.Buffer = True
            Response.ClearContent()
            Response.ClearHeaders()

            Dim suffixfile
            suffixfile = strFilename.Split(".")
            If Session("strReturn") = "Customer Export" Then
                If suffixfile(1).ToString = "CSV" Then
                    Response.ContentType = "application/vnd.csv"
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))
                End If

                If suffixfile(1).ToString = "TXT" Then
                    Response.ContentType = "application/vnd.text"
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))
                End If
                If suffixfile(1).ToString = "XML" Then
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))
                    Dim strDesktoppath As String = String.Empty
                    Dim tempPath As String = String.Empty

                    tempPath = MapPath("..\TempFile\")

                    strDesktoppath = strFilename
                    Dim xmlDoc As New StreamWriter(strDesktoppath, False)
                    dsCustomer.WriteXml(xmlDoc)
                    xmlDoc.Close()
                    Response.Clear()
                End If
                Response.TransmitFile(strFilename)
                Response.Flush()
                Response.End()
            Else
                'fndstofile(dsfetchinvtransid)
                If suffixfile(1).ToString = "CSV" Then
                    Response.ContentType = "application/vnd.csv"
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))
                End If

                If suffixfile(1).ToString = "TXT" Then
                    Response.ContentType = "application/vnd.text"
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))
                End If
                If suffixfile(1).ToString = "XML" Then
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(strFilename))

                    Dim strDesktoppath As String = String.Empty
                    Dim tempPath As String = String.Empty

                    tempPath = MapPath("..\TempFile\")
                    strDesktoppath = strFilename
                    Dim xmlDoc As New StreamWriter(strDesktoppath, False)

                    dsfetchinvtransid.Tables(0).WriteXml(xmlDoc)
                    xmlDoc.Close()
                    Response.Clear()
                End If
                Response.Charset = ""
                Response.TransmitFile(strFilename)
                Response.Flush()
                Response.End()
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_Export", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
    Public Function GetFileName_InvExport_TransId() As String
        Dim DS As New DataSet
        Dim FileName As String = ""

        Try
            DS = objLADO.GetFileName_InvExport_TransId(HttpContext.Current.Session("TransId"))
            If DS.Tables(0).Rows.Count > 0 Then
                FileName = DS.Tables(0).Rows(0).Item("PrefixFileName").ToString + "_" + DS.Tables(0).Rows(0).Item("InvJournalSeries").ToString + "." + DS.Tables(0).Rows(0).Item("SuffixFileName").ToString
            Else
                FileName = "Export_1.csv"
            End If

            Return FileName
        Catch ex As Exception
            'Throw ex
        End Try
    End Function
    Public Function fndstofile(ByVal dsfetchinvtransid As DataSet)
        Dim strRet As String
        TableColumns = dsfetchinvtransid.Tables(0).Columns
        TableRows = dsfetchinvtransid.Tables(0).Rows
        objDr = dsfetchinvtransid.Tables(4).Select("LANG_NAME = '" & ConfigurationManager.AppSettings("Language").ToUpper & "'")

        strFilename = Createfile_Export(Config_Path, strFilename)

        HttpContext.Current.Session("errlog") = ""
        strErrlogMsg = ""
        ' HttpContext.Current.Session("StrReturn") = ""
        HttpContext.Current.Session("strErrlogMsg") = Nothing
        HttpContext.Current.Session("strErrlogMsg") = ""
        strRet = WriteBodyinFile(strFilename, TableColumns, TableRows, objDr)
        strRet = WriteIntoFile(strFilename, HttpContext.Current.Session("strErrlogMsg"))
        HttpContext.Current.Session("errlog") = strRet

        Return strRet


    End Function
    Public Function WriteBodyinFile(ByVal strPath As String, ByVal tableColumns As DataColumnCollection, ByVal tableRows As DataRowCollection, ByVal objDr() As DataRow) As String
        Dim StrReturnCSV As String = ""
        Dim File As System.IO.StreamWriter = New System.IO.StreamWriter(strPath)
        Dim RowsCreated As Integer = 0
        Dim SqlInsert As String = ""
        Dim DsDate As New DataSet
        DsDate = objLADO.GetFilePath_Export()
        Flg_DateCheck = DsDate.Tables(0).Rows(0)("FLG_ADD_DATE").ToString
        Flg_Textcheck = DsDate.Tables(0).Rows(0)("FLG_ADD_TEXT").ToString
        Flg_AdditionalText = DsDate.Tables(0).Rows(0)("FLG_ADDITINAL_TEXT").ToString

        If Flg_Textcheck = "True" Then
            SqlInsert += DsDate.Tables(0).Rows(0)("ADD_TEXT").ToString & Environment.NewLine
        End If

        If Flg_DateCheck = "True" Then
            Dim CurrentDate As String = DateTime.Today.Date.ToString("yyyyMMdd")
            SqlInsert += """" + CurrentDate + """" & Environment.NewLine & Environment.NewLine
        End If

        If Flg_AdditionalText = "True" Then
            SqlInsert += DsDate.Tables(0).Rows(0)("ADDITINAL_TEXT").ToString & Environment.NewLine
        End If
        File.WriteLine(SqlInsert)
        Try
            strErrlogMsg = HttpContext.Current.Session("strErrlogMsg").ToString
            Dim CtrColumn As Integer = 0
            Dim DC As DataColumn
            'For Each DC In tableColumns
            '    'If CtrColumn < tableColumns.Count - 1 Then
            '    '    SqlInsert += objDr(CtrColumn)("CAPTION").ToString + DataSeparator
            '    'Else
            '    '    SqlInsert += objDr(CtrColumn)("CAPTION").ToString
            '    'End If
            '    'CtrColumn = CtrColumn + 1
            'Next
            ''File.WriteLine(SqlInsert)
            If strErrlogMsg = String.Empty Then
                strErrlogMsg = SqlInsert
            Else
                strErrlogMsg = strErrlogMsg + vbCrLf + SqlInsert
            End If
            Dim dsfetchinvtransid = HttpContext.Current.Session("ds")
            Dim ColCnt As Integer = dsfetchinvtransid.Tables(0).Columns.Count
            Dim RwCnt As Integer = dsfetchinvtransid.Tables(0).Rows.Count
            Dim DSEncCh As New DataSet
            Dim DSTemplate As New DataSet
            Dim TemplateId As String
            Dim ExpMode As String
            DSTemplate = objLADO.GetTemplate_Config()
            Dim objDrow() As DataRow = DSTemplate.Tables(0).Select("FILE_NAME = 'InvoiceJournalExport.aspx'")
            objDrow = DSTemplate.Tables(0).Select("FILE_NAME = 'InvoiceJournalExport.aspx'")
            If objDrow.Length = 1 Then
                TemplateId = objDrow(0)("TEMPLATE_ID").ToString
                ExpMode = objDrow(0)("FILE_MODE").ToString
                HttpContext.Current.Session("ExpMode") = ExpMode
                HttpContext.Current.Session("TemplateID") = TemplateId
            End If
            Dim Row As DataRow
            Dim i As Integer = 0
            Dim s As Integer = 0
            For Each Row In tableRows

                SqlInsert = ""
                Dim sqlvalues As String = ""
                Dim rowItems As Object() = Row.ItemArray
                CtrColumn = 0
                Dim Dcol As DataColumn
                Dim k As Integer = 0
                For Each Dcol In tableColumns


                    If CtrColumn < tableColumns.Count - 1 Then

                        Dim Str As String = ""
                        If HttpContext.Current.Session("ExpMode") <> "FIXED" Then
                            DSEncCh = objLADO.GetEnclosingCharacter(Dcol.ColumnName, "InvoiceJournalExport.aspx", HttpContext.Current.Session("TemplateID"))
                            Str = DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + rowItems(CtrColumn).ToString + DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + HttpContext.Current.Session("Dataseperator").ToString
                            If DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString = "" Then
                                If HttpContext.Current.Session("BlankSp") = "True" Then
                                    If Str = HttpContext.Current.Session("Dataseperator").ToString Then
                                        Str = Str.Replace(HttpContext.Current.Session("Dataseperator").ToString, """ """ + HttpContext.Current.Session("Dataseperator").ToString)
                                    End If
                                End If
                            End If
                        Else
                            Str = rowItems(CtrColumn).ToString + HttpContext.Current.Session("Dataseperator").ToString
                        End If
                        If Str = "" Then
                            For j As Integer = 0 To ColCnt - 1
                                Dim strArray(ColCnt) As String
                                strArray(j) = dsfetchinvtransid.Tables(0).Rows(i)(j).ToString()
                                If strArray(j) = "" Then
                                    Dim StrLength As Integer
                                    StrLength = dsfetchinvtransid.Tables(0).Columns(j).ToString().Length()
                                    StrLength = StrLength - 1
                                    Dim StrBlnk As String = ""
                                    HttpContext.Current.Session("StrBlnk") = StrBlnk.PadRight(StrLength, " ")
                                End If
                            Next
                        End If


                        sqlvalues += Str + HttpContext.Current.Session("StrBlnk")
                        HttpContext.Current.Session("StrBlnk") = Nothing
                    Else
                        Dim Str As String = ""
                        If HttpContext.Current.Session("ExpMode") <> "FIXED" Then
                            DSEncCh = objLADO.GetEnclosingCharacter(Dcol.ColumnName, "InvoiceJournalExport.aspx", HttpContext.Current.Session("TemplateID"))
                            Str = DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + rowItems(CtrColumn).ToString + DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString + HttpContext.Current.Session("Dataseperator").ToString
                            If DSEncCh.Tables(0).Rows(0).Item("ENCLOSING CHARACTER").ToString = "" Then
                                If HttpContext.Current.Session("BlankSp") = "True" Then
                                    If Str = HttpContext.Current.Session("Dataseperator").ToString Then
                                        Str = Str.Replace(HttpContext.Current.Session("Dataseperator").ToString, """ """ + HttpContext.Current.Session("Dataseperator").ToString)
                                    End If
                                End If
                            End If
                        Else
                            Str = rowItems(CtrColumn).ToString + HttpContext.Current.Session("Dataseperator").ToString
                        End If
                        sqlvalues += Str

                    End If

                    CtrColumn = CtrColumn + 1
                    k = k + 1
                    If k = ColCnt Then
                        Exit For
                    End If
                Next

                SqlInsert = SqlInsert + sqlvalues
                File.WriteLine(SqlInsert)

                If strErrlogMsg = String.Empty Then
                    strErrlogMsg = SqlInsert
                Else
                    strErrlogMsg = strErrlogMsg + vbCrLf + SqlInsert
                End If

                RowsCreated = RowsCreated + 1

                i = i + 1
                If i = RwCnt Then
                    Exit For
                End If
            Next

            HttpContext.Current.Session("strErrlogMsg") = strErrlogMsg
            HttpContext.Current.Session("StrReturn") = StrReturnCSV
            Return StrReturnCSV

        Catch ex As Exception
            'Throw ex
        Finally
            File.Close()

        End Try

    End Function
    Public Function WriteIntoFile(ByVal strPath As String, ByVal strErrlogMsg As String) As String
        Dim StrReturn As String = ""
        Dim File As System.IO.StreamWriter = New System.IO.StreamWriter(strPath)
        Try
            File.WriteLine(strErrlogMsg)
            File.Close()
            StrReturn = HttpContext.Current.Session("StrReturn")
            Return StrReturn

        Catch ex As Exception
            'Throw ex
        Finally
            File.Close()

        End Try

    End Function
    Public Function GetConfigPath_InvExport() As String
        Dim Ds As New DataSet
        Dim FilePath As String = String.Empty
        Try
            Ds = objLADO.GetFilePath_Export()
            If Ds.Tables(0).Rows.Count <> 0 Then
                FilePath = Ds.Tables(0).Rows(0).Item("Path_Export_InvJournal").ToString

                Dim tempPath As String = String.Empty

                If FilePath = String.Empty Then
                    tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                    FilePath = tempPath
                End If

            Else

                Dim tempPath As String = String.Empty

                If FilePath = String.Empty Then
                    tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                    FilePath = tempPath
                End If

            End If
            Return FilePath

        Catch ex As Exception

            'Throw ex

        End Try
    End Function
    Public Function GetFileName_InvExport() As String
        Dim DS As New DataSet
        Dim FileName As String = ""
        Dim Cur_SeqNo As Integer
        Dim New_SeqNo As Integer

        Try
            DS = objLADO.GetFileName_InvExport()
            If DS.Tables(0).Rows.Count > 0 Then

                If DS.Tables(0).Rows(0).Item("Exp_InvJournal_Series").ToString <> "" Then
                    If DS.Tables(0).Rows(0).Item("Exp_InvJournal_Cur_Series").ToString <> "" Then
                        Cur_SeqNo = CType(DS.Tables(0).Rows(0).Item("Exp_InvJournal_Cur_Series").ToString, Integer)
                        New_SeqNo = Cur_SeqNo
                    Else
                        Cur_SeqNo = 1
                        New_SeqNo = 1
                    End If

                    FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_InvJournal").ToString + "_" + CType(New_SeqNo, String) + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_InvJournal").ToString
                Else
                    FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_InvJournal").ToString + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_InvJournal").ToString
                End If
            End If
            Return FileName
        Catch ex As Exception
            'Throw ex
        End Try
    End Function
    Public Function Createfile_Export(ByVal Config_Path As String, ByVal strFilename As String) As String

        Try
            If Not (Directory.Exists(Config_Path)) Then
                Directory.CreateDirectory(Config_Path)
            End If

            If Config_Path.EndsWith("\") Or Config_Path.EndsWith("/") Then
                strFilename = Config_Path + strFilename
            Else
                strFilename = Config_Path + "\" + strFilename
            End If

            Dim NewFile As FileStream = New FileStream(strFilename, FileMode.Create, FileAccess.ReadWrite)

            NewFile.Close()

        Catch ex As Exception
            'Throw ex
        Finally
        End Try
        Return strFilename
    End Function
    Public Function GetGrouping_Export() As String
        Dim Ds As New DataSet
        Dim Grouping As String
        Try
            Ds = objLADO.GetGrouping_Export()
            If Ds.Tables(0).Rows.Count <> 0 Then
                Grouping = Ds.Tables(0).Rows(0).Item("Flg_Grouping").ToString
                Return Grouping

            End If
            Return ""
        Catch ex As Exception
            'Throw ex

        End Try
    End Function
    Public Function GetConfigPath_Export() As String
        Dim Ds As New DataSet
        Dim FilePath As String = String.Empty
        Try
            Ds = objLADO.GetFilePath_Export()
            If Ds.Tables(0).Rows.Count <> 0 Then
                FilePath = Ds.Tables(0).Rows(0).Item("Path_Export_CustInfo").ToString
                Dim tempPath As String = String.Empty
                If FilePath = String.Empty Then
                    tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                    FilePath = tempPath
                End If
            Else
                Dim tempPath As String = String.Empty
                If FilePath = String.Empty Then
                    tempPath = HttpContext.Current.Server.MapPath("..\TempFile\")
                    FilePath = tempPath
                End If
            End If
            Return FilePath

        Catch ex As Exception
            'Throw ex
        End Try
    End Function
    Public Function GetFileName_Export() As String
        Dim DS As New DataSet
        Dim FileName As String = ""
        Dim Cur_SeqNo As Integer
        Dim New_SeqNo As Integer

        Try
            DS = objLADO.GetFileName_Export()
            If DS.Tables(0).Rows.Count > 0 Then

                If DS.Tables(0).Rows(0).Item("Exp_Cust_Series").ToString <> "" Then
                    If DS.Tables(0).Rows(0).Item("Exp_Cust_Cur_Series").ToString <> "" Then
                        Cur_SeqNo = CType(DS.Tables(0).Rows(0).Item("Exp_Cust_Cur_Series").ToString, Integer)
                        'New_SeqNo += 1
                        New_SeqNo = Cur_SeqNo + 1
                    Else
                        Cur_SeqNo = 1
                        New_SeqNo = 1
                    End If

                    FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_CustInfo").ToString + "_" + CType(New_SeqNo, String) + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_CustInfo").ToString
                Else
                    FileName = DS.Tables(0).Rows(0).Item("PrefixFileName_Export_CustInfo").ToString + "." + DS.Tables(0).Rows(0).Item("SuffixFileName_Export_CustInfo").ToString
                End If
            End If
            Return FileName
        Catch ex As Exception
            'Throw ex
        End Try
    End Function
End Class