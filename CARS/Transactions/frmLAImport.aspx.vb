Imports System.Data
Imports Encryption
Imports System.Data.OleDb
Imports System.IO
Imports System.Security
Imports System.Security.Principal
Imports System.Security.AccessControl
Imports System.Globalization
Public Class frmLAImport
    Inherits System.Web.UI.Page
    Dim strerror As String
    Dim StrReturn As String = ""
    Dim strUpdated As String = ""
    Dim strInserted As String = ""
    Dim strErrorRecords As String = ""
    Dim ErrMsg As String
    Dim objEncryption As New Encryption64

    Dim logfilepath As String = String.Empty
    Dim serverdate As String
    Dim servertime As String
    Dim newlog As DirectoryInfo
    Dim logDir As DirectoryInfo
    Dim logfilestream As FileStream
    Dim logpath As String = String.Empty
    Const logFileFolder As String = "AccountImportRegistry"
    Dim max As Integer = 100000
    Dim builder As StringBuilder = New StringBuilder(max)

    Dim logArchivePath As String = String.Empty
    Dim ArchivePath As String = String.Empty
    Dim ArchiveLog As DirectoryInfo
    Dim ArchiveFileStream As FileStream
    Const ArchiveFolder As String = "ImportArchives"
    Dim intArchiveDays As Integer
    Dim oErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim objLAConfig As New CARS.CoreLibrary.CARS.ConfigLADO.ConfigLADO
    Dim objLADO As New CARS.CoreLibrary.CARS.LinkToAccountingDO.LinkToAccountingDO
    Dim loginName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Session.Item("id") = Nothing
            RTlblError.Text = ""

            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                LoginName = CType(Session("UserID"), String)
            End If
            CreateLogFile()
            logfilepath = ConfigurationManager.AppSettings("MSG_Error_Log_Path").ToString()
            logDir = New DirectoryInfo(logpath + "\" + logFileFolder + "\")
            logfilepath = logDir.FullName + "AccountImportRegistry_" + "ImportLog_" + Format(Now(), "dd-MM-yyyy_hh-mm-ss") + ".txt"
            Session("errlog") = ""
            'ddlAccSys.Items.Clear()
            'ddlAccSys.Items.Insert(0, New ListItem(Session("Select"), ""))
            'ddlAccSys.Items.Insert(1, New ListItem("CSV", "1"))
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "Transactions_frmLAImport", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Public Sub CreateLogFile()
        Try
            logpath = ConfigurationManager.AppSettings("MSG_Error_Log_Path").ToString()
            newlog = New DirectoryInfo(logpath + "\" + logFileFolder + "\")
            logfilepath = newlog.FullName + "AccountImportRegistry_" + "ImportLog_" + Format(Now(), "dd-MM-yyyy_hh-mm-ss") + ".txt"
            If Not newlog.Exists() Then
                newlog.Create()
                logfilestream = File.Create(logfilepath)
                logfilestream.Close()
            End If
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "Transactions_frmLAImport", "CreateLogFile", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Public Function validatedata(ByVal datatype As String, ByVal datavalue As String) As Boolean
        Select Case datatype
            Case "String"
                Dim AlphaNumeric As String
                'AlphaNumeric = "^\w+$"
                AlphaNumeric = "^[a-zA-Z0-9*@.,_ ]+$"

                Return Regex.IsMatch(datavalue.Replace(" ", ""), AlphaNumeric)
            Case "Date"
                Dim ValidDate As String '12-03-1980 Or 12.03.1980 Or 12/03/1980 (dd-mm-yyyy)
                ValidDate = "^((0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](?:19|20)\d\d)$"
                Return Regex.IsMatch(datavalue, ValidDate)
            Case "Decimal"
                Dim Decimals As String '5.6 decimals and floats
                Decimals = "^[+]?\d*\.?\d*$"
                If datavalue = "" Then
                    Return False
                Else
                    Return Regex.IsMatch(datavalue, Decimals)
                End If

            Case "Int32"
                Dim Numeric As String
                Numeric = "^[0-9]+$"
                Return Regex.IsMatch(datavalue, Numeric)
            Case Else
                Return True
        End Select
    End Function
    Protected Sub BtnImpt_Click(sender As Object, e As EventArgs) Handles BtnImpt.Click
        Try
            Dim StrUserId As String
            Dim i As Integer
            StrUserId = Session("UserID")
            Dim DS_Config As DataSet
            Dim strXML As String
            Dim DS_ImportedFiles As New DataSet
            StrReturn = ""
            strUpdated = ""
            strInserted = ""
            strErrorRecords = ""
            Dim ErrMsg As String = ""
            Dim logArchivePath As String = String.Empty
            RTlblError.Text = ""
            ViewState("err") = Nothing
            Dim fn As String = System.IO.Path.GetFileName(FlUpload.PostedFile.FileName)
            DS_Config = objLAConfig.FetchConfiguration()
            If rdLstImport.SelectedIndex = 0 Then
                strXML = UpdateCustomerBalFromFile()
                If Len(strXML) = 0 Then

                    RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"
                Else
                    strXML = "<ROOT>" + strXML + "</ROOT>"
                    'objLADO.Balance_XML = strXML
                    DS_ImportedFiles = objLADO.Update_Cust_Balance(strXML)

                    ConstructFile(oErrHandle.GetErrorDescParameter("IMPET") + " " + Format(Now(), "dd/MM/yyyy (hh:mm:ss)"))
                    RTlblError.Text = "<Font color=""green"">" + oErrHandle.GetErrorDescParameter("SAVE") + "</Font>"
                End If
            ElseIf (rdLstImport.SelectedIndex = 1) Then
                strXML = UpdateCustomerFromFile()
                If Len(strXML) = 0 Then

                    RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"
                Else
                    strXML = "<ROOT>" + strXML + "</ROOT>"
                    DS_ImportedFiles = objLADO.import_file(strXML)
                    ConstructFile(oErrHandle.GetErrorDescParameter("IMPET") + " " + Format(Now(), "dd/MM/yyyy (hh:mm:ss)"))

                    RTlblError.Text = "<Font color=""green"">" + oErrHandle.GetErrorDescParameter("SAVE") + "</Font>"
                End If
            End If

            WriteRowInFile(builder)
            Session("errlog") = GetFileContents(logfilepath)
        Catch ex As Exception
            ErrMsg = oErrHandle.GetErrorDescParameter("WRONG")
            RTlblError.Text = "<Font color=""green"">" + ErrMsg + "</Font>"
            Session("errlog") = ErrMsg
        End Try
    End Sub
    Private Function UpdateCustomerFromFile() As String
        Dim FileName As String
        Dim ds As New DataSet
        Dim Filelines As New Collection()
        Dim ImportfileRecordcount As Integer = 0
        Dim count As Integer = 0
        Dim HeaderFields_importfile() As String
        Dim Flag As Boolean = False
        Dim StrXML As String = ""
        Dim DS_Config As DataSet
        Dim StrTepXML As String = ""
        Dim intFileFldCnt As Integer
        Dim Validate As Boolean = True
        Dim j As Integer = 0
        Try

            Dim fn As String = System.IO.Path.GetFileName(FlUpload.PostedFile.FileName)

            DS_Config = objLAConfig.FetchFilePathSettings()
            If fn = "" Then
                If DS_Config.Tables(0).Rows.Count > 0 Then
                    If rdLstImport.SelectedIndex = 0 Then
                        If DS_Config.Tables(0).Rows(0).Item("Customer_FileLocation").ToString.EndsWith("\") Then
                            fn = System.IO.Path.GetFileName(DS_Config.Tables(0).Rows(0).Item("Customer_FileLocation").ToString + DS_Config.Tables(0).Rows(0).Item("Customer_FileName").ToString)
                            ViewState("originalpath") = System.IO.Path.GetDirectoryName(DS_Config.Tables(0).Rows(0).Item("Customer_FileLocation").ToString + DS_Config.Tables(0).Rows(0).Item("Customer_FileName").ToString)
                        End If
                    Else
                        fn = System.IO.Path.GetFileName(DS_Config.Tables(0).Rows(0).Item("Customer_FileLocation").ToString + "\" + DS_Config.Tables(0).Rows(0).Item("Customer_FileName").ToString)
                        ViewState("originalpath") = System.IO.Path.GetDirectoryName(DS_Config.Tables(0).Rows(0).Item("Customer_FileLocation").ToString + "\" + DS_Config.Tables(0).Rows(0).Item("Customer_FileName").ToString)
                    End If
                End If
                FileName = SaveLocation(fn) & "\" & fn

                Try
                    System.IO.File.Copy(ViewState("originalpath") & "\" & fn, SaveLocation(fn) & "\" & fn.Replace(".csv", ".txt"), True)

                Catch ex As System.IO.DirectoryNotFoundException
                    builder.AppendLine(ex.Message)
                    RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("BCSV") + "</Font>"
                    oErrHandle = New MSGCOMMON.MsgErrorHndlr
                    oErrHandle.WriteErrorLog(1, "Master_frmVehRBUpload", "UpdateCustomerFromFile()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
                End Try
            Else
                ViewState("originalpath") = System.IO.Path.GetPathRoot(FlUpload.PostedFile.FileName)
                FileName = SaveLocation(fn) & "\" & fn
                FlUpload.PostedFile.SaveAs(FileName.Replace(".csv", ".txt"))
            End If

            FileName = SaveLocation(fn) & "\" & fn
            Dim dsTemplateConfig As New DataSet
            Dim strDelimiter As String = String.Empty
            Dim intnum As Integer

            If FileName.Substring(FileName.Length - 3, 3).ToUpper = "CSV" Then
                FileName = FileName.Replace(".csv", ".txt")
                builder.Append(vbCrLf)
                ConstructFile(oErrHandle.GetErrorDescParameter("IMPST") + " " + Format(Now(), "dd/MM/yyyy (hh:mm:ss)") + " ")
                dsTemplateConfig = objLAConfig.FetchCustInfoTemplateConfig()

                If File.Exists(FileName) Then
                    Using sr As StreamReader = New StreamReader(FileName, System.Text.Encoding.Default)
                        Dim line As String
                        Do
                            line = sr.ReadLine()
                            If Len(line) > 0 Then
                                Filelines.Add(line, ImportfileRecordcount)
                                ImportfileRecordcount = ImportfileRecordcount + 1
                            End If
                        Loop Until line Is Nothing
                        sr.Close()
                    End Using
                Else
                    builder.AppendLine("No file found")
                    oErrHandle.WriteErrorLog(1, "ABSImport", "Customer Import", "No file found", 64)
                End If

                If Filelines.Count > 0 And dsTemplateConfig.Tables(0).Rows.Count > 0 Then
                    If Not IsDBNull(dsTemplateConfig.Tables(1).Rows(0).Item("delimiter")) Then 'And dsTemplateConfig.Tables(1).Rows(0).Item("delimiter") <> "0" 
                        strDelimiter = dsTemplateConfig.Tables(1).Rows(0).Item("delimiter").ToString.Trim
                        intFileFldCnt = Split(Filelines.Item("0").ToString.Replace("""", ""), strDelimiter).Length

                        If intFileFldCnt >= dsTemplateConfig.Tables(0).Rows.Count Then
                            For i As Integer = 0 To ImportfileRecordcount - 1
                                HeaderFields_importfile = Split(Filelines.Item(i.ToString).ToString.Replace("""", ""), strDelimiter)
                                StrTepXML = ""
                                Validate = True
                                For j = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1

                                    If (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") And (HeaderFields_importfile(j) = "" Or HeaderFields_importfile(j) = " ") Then
                                        HeaderFields_importfile(j) = "0.00"
                                    ElseIf (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") Then
                                        Try
                                            HeaderFields_importfile(j) = GetCurrentLanguageNoFormat(dsTemplateConfig.Tables(1).Rows(0).Item("character_set").ToString, HeaderFields_importfile(j).ToString.Trim, True)
                                        Catch ex As Exception
                                            builder.AppendLine("Unable to convert the amount")
                                            oErrHandle.WriteErrorLog(1, "ABSImport", "Customer Import", "Unable to convert the amount", 64)
                                        End Try
                                    End If

                                    If dsTemplateConfig.Tables.Count > 2 Then
                                        If dsTemplateConfig.Tables(2).Rows.Count > 0 Then
                                            For k As Integer = 0 To dsTemplateConfig.Tables(2).Rows.Count - 1
                                                If dsTemplateConfig.Tables(0).Rows(j).Item("field_name").ToString = dsTemplateConfig.Tables(2).Rows(k).Item("fixFldName").ToString Then
                                                    HeaderFields_importfile(j) = IIf(dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value") Is DBNull.Value, HeaderFields_importfile(j), dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value").ToString)
                                                End If
                                            Next
                                        End If
                                    End If

                                    If HeaderFields_importfile(j) <> "" And HeaderFields_importfile(j) <> " " Then
                                        If validatedata(dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString, HeaderFields_importfile(j)) = False Then
                                            Validate = False
                                        End If
                                    End If
                                    If Validate = True Then
                                        StrTepXML += Replace(dsTemplateConfig.Tables(0).Rows(j).Item("field_name"), " ", "").ToString.Trim + "=" + """" + HeaderFields_importfile(j).ToString.Trim + """ "
                                    Else
                                        StrTepXML = ""
                                        RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"

                                        Continue For
                                    End If
                                Next
                                StrXML += "<XMLSTR " + StrTepXML + "/>"
                            Next
                        Else
                            builder.AppendLine("Delimiter in file does not match with the configuration selected")
                        End If
                    ElseIf dsTemplateConfig.Tables(1).Rows(0).Item("file_mode").ToString = "FIXED" Then
                        Dim strFileLine As String
                        Dim intStartIndex As Integer
                        For i As Integer = 0 To ImportfileRecordcount - 1
                            StrTepXML = ""
                            Validate = True
                            intStartIndex = 1
                            strFileLine = Filelines.Item(i.ToString).ToString.Replace("""", "")
                            ReDim HeaderFields_importfile(dsTemplateConfig.Tables(0).Rows.Count)

                            For m As Integer = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1
                                intnum = strFileLine.Length
                                If intnum >= intStartIndex + dsTemplateConfig.Tables(0).Rows(m).Item("field_length") Then
                                    HeaderFields_importfile(m) = strFileLine.Substring(intStartIndex, dsTemplateConfig.Tables(0).Rows(m).Item("field_length"))
                                    intStartIndex = intStartIndex + dsTemplateConfig.Tables(0).Rows(m).Item("field_length")
                                Else
                                    builder.AppendLine("InCompelete Line")
                                    oErrHandle.WriteErrorLog(1, "ABSImport", "Customer Import", "InCompelete Line", 64)
                                    Continue For
                                End If
                            Next
                            For j = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1

                                If (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") And (HeaderFields_importfile(j) = "" Or HeaderFields_importfile(j) = " ") Then
                                    HeaderFields_importfile(j) = "0.00"
                                ElseIf (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") Then
                                    Try
                                        HeaderFields_importfile(j) = GetCurrentLanguageNoFormat(dsTemplateConfig.Tables(1).Rows(0).Item("character_set").ToString, HeaderFields_importfile(j).ToString.Trim, True)
                                    Catch ex As Exception
                                        builder.AppendLine("Unable to convert the amount")
                                        oErrHandle.WriteErrorLog(1, "Master_frmLAImport", "UpdateCustomerFromFile()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
                                    End Try
                                End If

                                If dsTemplateConfig.Tables.Count > 2 Then
                                    If dsTemplateConfig.Tables(2).Rows.Count > 0 Then
                                        For k As Integer = 0 To dsTemplateConfig.Tables(2).Rows.Count - 1
                                            If dsTemplateConfig.Tables(0).Rows(j).Item("field_name").ToString = dsTemplateConfig.Tables(2).Rows(k).Item("fixFldName").ToString Then
                                                HeaderFields_importfile(j) = dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value").ToString
                                            End If
                                        Next
                                    End If
                                End If

                                If HeaderFields_importfile(j) <> "" And HeaderFields_importfile(j) <> " " Then
                                    If validatedata(dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString, HeaderFields_importfile(j)) = False Then
                                        Validate = False
                                    End If
                                End If
                                If Validate = True Then
                                    StrTepXML += Replace(dsTemplateConfig.Tables(0).Rows(j).Item("field_name"), " ", "").ToString.Trim + "=" + """" + HeaderFields_importfile(j).ToString.Trim + """ "
                                Else
                                    StrTepXML = ""
                                    Continue For
                                End If
                            Next
                            StrXML += "<XMLSTR " + StrTepXML + "/>"
                        Next
                    End If
                End If
            Else
                ConstructFile(oErrHandle.GetErrorDescParameter("IMPIE"))
                builder.AppendLine(vbCrLf)
                ConstructFile(oErrHandle.GetErrorDescParameter("IMPET") + " " + Format(Now(), "dd/MM/yyyy (hh:mm:ss)"))
            End If
            Return StrXML
        Catch ex As Exception
            builder.AppendLine(ex.Message)
            RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"
        End Try
    End Function
    Private Function UpdateCustomerBalFromFile() As String
        Dim FileName As String
        Dim ds As New DataSet
        Dim Filelines As New Collection()
        Dim ImportfileRecordcount As Integer = 0
        Dim count As Integer = 0
        Dim HeaderFields_importfile() As String
        Dim Flag As Boolean = False
        Dim StrXML As String = ""
        Dim DS_Config As DataSet
        Dim Validate As Boolean = True
        Dim intFileFldCnt As Integer
        Dim StrTepXML As String
        Dim strFileName As String
        Dim intArchiveDays As Integer
        Dim strFlName As String = ""
        Try

            Dim fn As String = System.IO.Path.GetFileName(FlUpload.PostedFile.FileName)

            DS_Config = objLAConfig.FetchFilePathSettings()
            If fn = "" Then
                If DS_Config.Tables(0).Rows.Count > 0 Then
                    If rdLstImport.SelectedIndex = 0 Then
                        If DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString.EndsWith("\") Then
                            fn = System.IO.Path.GetFileName(DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString)
                            strFlName = DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString
                            ViewState("originalpath") = System.IO.Path.GetDirectoryName(DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString)
                        Else
                            fn = System.IO.Path.GetFileName(DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + "\" + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString)
                            strFlName = DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + "\" + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString
                            ViewState("originalpath") = System.IO.Path.GetDirectoryName(DS_Config.Tables(0).Rows(0).Item("Balance_FileLocation").ToString + "\" + DS_Config.Tables(0).Rows(0).Item("Balance_FileName").ToString)
                        End If
                    End If
                End If

                FileName = SaveLocation(fn) & "\" & fn
                Try
                    System.IO.File.Copy(ViewState("originalpath") & "\" & fn, SaveLocation(fn) & "\" & fn.Replace(".csv", ".txt"), True)

                Catch ex As System.IO.DirectoryNotFoundException
                    'RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("BCSV") + "</Font>"
                    builder.AppendLine("No file found")
                    oErrHandle = New MSGCOMMON.MsgErrorHndlr
                    oErrHandle.WriteErrorLog(1, "Master_frmVehRBUpload", "UpdateCustomerFromFile()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
                End Try
            Else
                ViewState("originalpath") = System.IO.Path.GetPathRoot(FlUpload.PostedFile.FileName)
                FileName = SaveLocation(fn) & "\" & fn
                FlUpload.PostedFile.SaveAs(FileName.Replace(".csv", ".txt"))
            End If

            FileName = SaveLocation(fn) & "\" & fn
            strFileName = fn
            intArchiveDays = DS_Config.Tables(0).Rows(0).Item("Balance_ArchiveDays")
            ArchiveFile(fn, intArchiveDays, strFlName)

            Dim dsTemplateConfig As New DataSet
            Dim strDelimiter As String = String.Empty
            Dim j As Integer
            Dim intnum As Integer
            builder.Append(vbCrLf)
            ConstructFile(oErrHandle.GetErrorDescParameter("IMPST") + " " + Format(Now(), "dd/MM/yyyy (hh:mm:ss)") + " ")

            If FileName.Substring(FileName.Length - 3, 3).ToUpper = "CSV" Then
                FileName = FileName.Replace(".csv", ".txt")
                dsTemplateConfig = objLAConfig.FetchBalanceTemplateConfig()

                If File.Exists(FileName) Then
                    Using sr As StreamReader = New StreamReader(FileName, System.Text.Encoding.Default)
                        Dim line As String
                        Do
                            line = sr.ReadLine()
                            If Len(line) > 0 Then
                                Filelines.Add(line, ImportfileRecordcount)
                                ImportfileRecordcount = ImportfileRecordcount + 1
                            End If

                        Loop Until line Is Nothing
                        sr.Close()
                    End Using
                Else
                    builder.AppendLine("File not found")
                    oErrHandle.WriteErrorLog(1, "ABSImport", "Customer Import", "No file found", 64)
                End If

                If Filelines.Count > 0 And dsTemplateConfig.Tables(0).Rows.Count > 0 Then
                    If Not IsDBNull(dsTemplateConfig.Tables(1).Rows(0).Item("delimiter")) And dsTemplateConfig.Tables(1).Rows(0).Item("delimiter") <> "0" Then
                        strDelimiter = dsTemplateConfig.Tables(1).Rows(0).Item("delimiter").ToString.Trim
                        intFileFldCnt = Split(Filelines.Item("0").ToString.Replace("""", ""), strDelimiter).Length
                        If intFileFldCnt >= dsTemplateConfig.Tables(0).Rows.Count Then
                            For i As Integer = 0 To ImportfileRecordcount - 1
                                HeaderFields_importfile = Split(Filelines.Item(i.ToString).ToString.Replace("""", ""), strDelimiter)
                                StrTepXML = ""
                                Validate = True
                                For j = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1
                                    If (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") And (HeaderFields_importfile(j) = "" Or HeaderFields_importfile(j) = " ") Then
                                        HeaderFields_importfile(j) = "0.00"
                                    ElseIf (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") Then
                                        Try
                                            HeaderFields_importfile(j) = GetCurrentLanguageNoFormat(dsTemplateConfig.Tables(1).Rows(0).Item("character_set").ToString, HeaderFields_importfile(j).ToString.Trim, True)
                                        Catch ex As Exception
                                            builder.AppendLine("Unable to convert the amount")
                                            oErrHandle.WriteErrorLog(1, "Master_frmLAImport", "UpdateCustomerBalFromFile()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
                                        End Try
                                    End If
                                    If dsTemplateConfig.Tables.Count > 2 Then
                                        If dsTemplateConfig.Tables(2).Rows.Count > 0 Then
                                            For k As Integer = 0 To dsTemplateConfig.Tables(2).Rows.Count - 1
                                                If dsTemplateConfig.Tables(0).Rows(j).Item("field_name").ToString = dsTemplateConfig.Tables(2).Rows(k).Item("fixFldName").ToString Then
                                                    HeaderFields_importfile(j) = IIf(dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value") Is DBNull.Value, HeaderFields_importfile(j), dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value").ToString)
                                                End If
                                            Next
                                        End If
                                    End If
                                    If HeaderFields_importfile(j) <> "" And HeaderFields_importfile(j) <> " " Then
                                        If validatedata(dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString, HeaderFields_importfile(j)) = False Then
                                            Validate = False
                                        End If
                                    End If


                                    If Validate = True Then
                                        StrTepXML += Replace(dsTemplateConfig.Tables(0).Rows(j).Item("field_name"), " ", "").ToString.Trim + "=" + """" + HeaderFields_importfile(j).ToString.Trim + """ "
                                    Else
                                        StrTepXML = ""
                                        Continue For
                                    End If
                                Next
                                StrXML += "<XMLSTR " + StrTepXML + "/>"
                            Next
                        Else
                            builder.AppendLine("Delimiter in file does not match with the configuration selected")
                        End If
                    ElseIf dsTemplateConfig.Tables(1).Rows(0).Item("file_mode").ToString = "FIXED" Then
                        Dim strFileLine As String
                        Dim intStartIndex As Integer
                        For i As Integer = 0 To ImportfileRecordcount - 1
                            StrTepXML = ""
                            Validate = True
                            intStartIndex = 1
                            strFileLine = Filelines.Item(i.ToString).ToString.Replace("""", "")
                            ReDim HeaderFields_importfile(dsTemplateConfig.Tables(0).Rows.Count)

                            For m As Integer = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1
                                intnum = strFileLine.Length
                                If intnum >= intStartIndex + dsTemplateConfig.Tables(0).Rows(m).Item("field_length") Then
                                    HeaderFields_importfile(m) = strFileLine.Substring(intStartIndex, dsTemplateConfig.Tables(0).Rows(m).Item("field_length"))
                                    intStartIndex = intStartIndex + dsTemplateConfig.Tables(0).Rows(m).Item("field_length")
                                Else
                                    builder.AppendLine("InCompelete Line")
                                    oErrHandle.WriteErrorLog(1, "ABSImport", "Customer Import", "InCompelete Line", 64)
                                    Continue For
                                End If
                            Next
                            For j = 0 To dsTemplateConfig.Tables(0).Rows.Count - 1
                                If (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") And (HeaderFields_importfile(j) = "" Or HeaderFields_importfile(j) = " ") Then
                                    HeaderFields_importfile(j) = "0.00"
                                ElseIf (dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString = "Decimal") Then
                                    Try
                                        HeaderFields_importfile(j) = GetCurrentLanguageNoFormat(dsTemplateConfig.Tables(1).Rows(0).Item("character_set").ToString, HeaderFields_importfile(j).ToString.Trim, True)
                                    Catch ex As Exception
                                        builder.AppendLine("Unable to Convert amount")
                                        oErrHandle.WriteErrorLog(1, "Master_frmLAImport", "UpdateCustomerBalFromFile()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
                                    End Try
                                End If

                                If dsTemplateConfig.Tables(2).Rows.Count > 0 Then
                                    For k As Integer = 0 To dsTemplateConfig.Tables(2).Rows.Count - 1
                                        If dsTemplateConfig.Tables(0).Rows(j).Item("field_name").ToString = dsTemplateConfig.Tables(2).Rows(k).Item("fixFldName").ToString Then
                                            HeaderFields_importfile(j) = dsTemplateConfig.Tables(2).Rows(k).Item("fixed_value").ToString
                                        End If
                                    Next
                                End If

                                If HeaderFields_importfile(j) <> "" And HeaderFields_importfile(j) <> " " Then
                                    If validatedata(dsTemplateConfig.Tables(0).Rows(j).Item("field_type").ToString, HeaderFields_importfile(j)) = False Then
                                        Validate = False
                                    End If
                                End If
                                If Validate = True Then
                                    StrTepXML += Replace(dsTemplateConfig.Tables(0).Rows(j).Item("field_name"), " ", "").ToString.Trim + "=" + """" + HeaderFields_importfile(j).ToString.Trim + """ "
                                Else
                                    StrTepXML = ""
                                    Continue For
                                End If
                            Next
                            StrXML += "<XMLSTR " + StrTepXML + "/>"
                        Next
                    End If
                End If
            Else
                ConstructFile(oErrHandle.GetErrorDescParameter("IMPIE"))
                builder.Append(vbCrLf)
                ConstructFile(oErrHandle.GetErrorDescParameter("IMPET") + Format(Now(), "dd/MM/yyyy (hh:mm:ss)"))
            End If


            Return StrXML
        Catch ex As Exception
            builder.AppendLine(ex.Message)
            RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"
        End Try
    End Function
    Public Sub ConstructFile(ByVal param As String)
        Try
            builder.Append(param)
            builder.Append(vbCrLf)
            If (builder.Length + 100 >= max) Then
                WriteRowInFile(builder)
            End If
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "ImportFile", "ConstructFile", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
        End Try

    End Sub
    Public Sub WriteRowInFile(ByVal builder As StringBuilder)
        Try
            Dim logfile As FileStream
            Dim objStreamWriter As StreamWriter
            logpath = ConfigurationManager.AppSettings("MSG_Error_Log_Path").ToString()
            newlog = New DirectoryInfo(logpath + "\" + logFileFolder + "\")
            logfilepath = newlog.FullName + "AccountImportRegistry_" + "ImportLog_" + Format(Now(), "dd-MM-yyyy_hh-mm-ss") + ".txt"

            logfile = New FileStream(logfilepath, FileMode.Append, FileAccess.Write)
            objStreamWriter = New StreamWriter(logfile)
            objStreamWriter.WriteLine(builder)
            objStreamWriter.Close()
            logfile.Close()
            builder.Remove(0, builder.Length)
        Catch ex As Exception
            oErrHandle.WriteErrorLog(1, "ImportFile", "WriteRowInFile", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
        End Try
    End Sub
    Private Function GetCVSFile(ByVal pathName As String, ByVal filename As String) As DataSet
        Dim excon As New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + pathName + ";Extended Properties=Text;")
        Dim excmd As New OleDbCommand("SELECT * FROM " + filename, excon)
        Dim exadp As New OleDbDataAdapter(excmd)
        excon.Open()
        Dim exdataset As New DataSet
        exadp.Fill(exdataset, "CustBal")
        excon.Close()
        Return exdataset
    End Function
    Private Function SaveLocation(ByVal flname As String) As String
        Try
            Dim path As String = Request.PhysicalApplicationPath & System.Configuration.ConfigurationManager.AppSettings("UploadPath") '"TempFile\UploadedFiles"
            If Directory.Exists(path) Then
                If File.Exists(path + "\" + flname) Then
                    File.Delete(path + "\" + flname)
                End If
            Else
                Directory.CreateDirectory(path)
            End If
            Return path

        Catch ex As Exception
            oErrHandle = New MSGCOMMON.MsgErrorHndlr
            oErrHandle.WriteErrorLog(1, "Master_frmVehRBUpload", "SaveLocation()", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserID"))
        End Try
    End Function
    Private Sub DelFile(ByVal flname As String)
        If File.Exists(flname) Then
            File.Delete(flname)
        End If
    End Sub
    Private Sub ArchiveFile(ByVal flname As String, ByVal archivedays As Integer, ByVal flpath As String)
        Dim strFile As String
        Dim strfilePre As String
        Dim strFileExtn As String
        Try
            Dim LastInd As Integer = flname.LastIndexOf(".")
            strFileExtn = flname.Substring(LastInd)
            strfilePre = flname.Substring(0, LastInd)

            Dim strFilePath As String = Server.MapPath("~/").ToString + ArchiveFolder + "\" + flname
            ArchivePath = Server.MapPath("~/")
            ArchiveLog = New DirectoryInfo(ArchivePath + ArchiveFolder + "\")

            ArchivePath = ArchiveLog.FullName + strfilePre + "_" + Format(Now(), "dd-MM-yyyy_hh-mm-ss") + strFileExtn

            If Not ArchiveLog.Exists() Then
                ArchiveLog.Create()
                ArchiveFileStream = File.Create(ArchivePath)
                ArchiveFileStream.Close()
            Else
                Dim strDirPath As String = Server.MapPath("~/").ToString + ArchiveFolder
                Dim strfilecol As String = ""
                Dim files As String() = Directory.GetFiles(strDirPath)
                Dim strdate As String = String.Format("{0:MM.dd.yyyy}", DateTime.Now)
                Dim toDay As Integer = DateTime.Now.Day
                Dim fileDay As Integer
                For Each strFile In files
                    strfilecol = strFile.Substring(strFile.LastIndexOf("_") + 1, strFile.LastIndexOf(".") - strFile.LastIndexOf("_") - 1)
                    fileDay = Date.Parse(strfilecol).Day
                    If DateDiff(DateInterval.Day, Date.Parse(strfilecol), Date.Parse(strdate)) > archivedays Then
                        File.Delete(strFile)
                    End If
                Next

                File.Copy(flpath, strFilePath)
                ArchiveFileStream.Close()
            End If
        Catch ex As Exception

        End Try
    End Sub
    Public Function SaveTextToFile(ByVal strData As String, ByVal FullPath As String, Optional ByVal ErrInfo As String = "") As Boolean
        If File.Exists(FullPath) Then
            File.Delete(FullPath)
        End If
        Dim bAns As Boolean = False
        Dim objReader As StreamWriter
        Try
            objReader = New StreamWriter(FullPath)
            objReader.Write(strData)
            objReader.Close()
            bAns = True
        Catch Ex As Exception
            ErrInfo = Ex.Message
        End Try
        Return bAns
    End Function
    Public Sub ErrorlogCreation(ByVal strSelected As String, ByVal ErrMsgs As String)
        ViewState("err") = ErrMsgs
        Dim blnRetrun As Boolean

        StrReturn = ErrMsgs
        If Len(StrReturn) = 0 Then
            StrReturn = oErrHandle.GetErrorDescParameter("INOERR")
        End If
        blnRetrun = SaveTextToFile(StrReturn, ViewState("originalpath") & "Import_Customer_" & strSelected & ".txt", "")
        If blnRetrun = True Then
            If ViewState("originalpath") = Nothing Then
            Else
                RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IERRLOG") + "</Font>"
            End If
            RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IERRLOG") + "Import_Customer_" & strSelected & ".txt" + "</Font>"
        Else
            RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("ILOGERR") + "</Font>"
        End If
    End Sub
    Public Function GetFileContents(ByVal FullPath As String, Optional ByRef ErrInfo As String = "") As String
        Dim strContents As String
        Dim objReader As StreamReader
        Try
            objReader = New StreamReader(FullPath, System.Text.Encoding.Default)
            strContents = objReader.ReadToEnd()
            objReader.Close()
            Return strContents
        Catch Ex As Exception
            ErrInfo = Ex.Message
        End Try
    End Function
    Private Function GetCurrentLanguageNoFormat(ByVal charSet As String, ByVal Num As String, ByVal isForward As Boolean) As String
        If Num.Length <> 0 Then
            Dim MultiLangNumFormat As System.Globalization.NumberFormatInfo
            Dim NumberValue As Decimal
            If isForward Then
                MultiLangNumFormat = New System.Globalization.CultureInfo("en-US").NumberFormat
                NumberValue = Decimal.Parse(Num, New CultureInfo(charSet))
            Else
                MultiLangNumFormat = New System.Globalization.CultureInfo(charSet).NumberFormat
                NumberValue = Decimal.Parse(Num, New CultureInfo("en-US"))
            End If

            Try
                Num = NumberValue.ToString("N", MultiLangNumFormat)
                Return Num.Replace(MultiLangNumFormat.CurrencyGroupSeparator, String.Empty)

            Catch ex As Exception
                RTlblError.Text = "<Font color=""red"">" + oErrHandle.GetErrorDescParameter("IMPERR") + "</Font>"
            End Try
        Else
            Return String.Empty
        End If
    End Function

End Class