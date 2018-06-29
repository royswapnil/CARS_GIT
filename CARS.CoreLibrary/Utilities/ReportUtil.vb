Imports Microsoft.VisualBasic
Imports CrystalDecisions.Shared
Imports CrystalDecisions.CrystalReports.Engine
Imports System.Xml
Imports System.IO
Imports CARS.CoreLibrary.CARS.Utilities.CommonUtility
Namespace CARS.Utilities
    Public Class ReportUtil

#Region "Declarations"
        Private _ReportPath As String
        Private rptDoc As ReportDocument
        Private Shared objReportUtil As ReportUtil
        Private objCommonUtil As New CARS.Utilities.CommonUtility
#End Region

#Region "Constructors"
        Private Sub New(ByVal ReportPath As String)
            _ReportPath = ReportPath
        End Sub
        Public Shared Function CreateReportUtilObject(ByVal ReportPath As String)
            objReportUtil = New ReportUtil(ReportPath)
            Return objReportUtil
        End Function
#End Region

#Region "Properties"
        Public Property ReportPath() As String
            Get
                Return _ReportPath
            End Get
            Set(ByVal value As String)
                _ReportPath = value
            End Set
        End Property
#End Region

#Region "Public Functions"
        Public Function CreateReport(ByVal ConnectionString As String, ByVal FileName As String, Optional ByVal ParameterValues As String = "") As ReportDocument
            Dim strServerName As String = String.Empty
            Dim strUserId As String = String.Empty
            Dim strPassword As String = String.Empty
            Dim strDatabaseName As String = String.Empty
            ReadConnectionSettings(ConnectionString, strServerName, strUserId, strPassword, strDatabaseName)
            LoadReport(FileName)
            SetDbLogon(strServerName, strUserId, strPassword, strDatabaseName)
            SetDBParameterValues(ParameterValues)
            SetReportParameterValues(ParameterValues)
            Return rptDoc
        End Function
        Public Function CreateReport(ByVal FileName As String, ByVal dsDataset As DataSet, Optional ByVal ParameterValues As String = "") As ReportDocument
            LoadReport(FileName)
            Dim rptSubDoc As ReportDocument
            Dim rptTable As CrystalDecisions.CrystalReports.Engine.Table
            Try
                For Each rptTable In rptDoc.Database.Tables
                    rptDoc.SetDataSource(dsDataset.Tables(rptTable.Location))
                Next
                For Each rptSubDoc In rptDoc.Subreports
                    rptSubDoc = rptDoc.OpenSubreport(rptSubDoc.Name)
                    For Each rptTable In rptSubDoc.Database.Tables
                        rptSubDoc.SetDataSource(dsDataset.Tables(rptTable.Location))
                    Next
                Next
                SetReportParameterValues(ParameterValues)
                Return rptDoc
            Catch ex As Exception
                Dim oAppLog As New MSGCOMMON.MsgErrorHndlr
                oAppLog.WriteErrorLog("1", "ReportUtil", "CreateReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
                oAppLog = Nothing
                Throw New Exception("Improper Dataset")
            Finally
                If Not rptTable Is Nothing Then
                    rptTable.Dispose()
                End If
            End Try
        End Function
        Public Function CreateReport(ByVal FileName As String, ByVal dtDataTable As DataTable, Optional ByVal ParameterValues As String = "") As ReportDocument
            LoadReport(FileName)
            Try
                dtDataTable.TableName = rptDoc.Database.Tables(0).Location
                rptDoc.SetDataSource(dtDataTable)
                SetReportParameterValues(ParameterValues)
                Return rptDoc
            Catch ex As Exception
                Dim oAppLog As New MSGCOMMON.MsgErrorHndlr
                oAppLog.WriteErrorLog("1", "ReportUtil", "CreateReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
                oAppLog = Nothing
                Throw New Exception("Improper DataTable")
            Finally
            End Try

        End Function
        Public Function CreateReport(ByVal FileName As String, ByVal dvDataView As DataView, Optional ByVal ParameterValues As String = "") As ReportDocument
            LoadReport(FileName)
            Try
                dvDataView.Table.TableName = rptDoc.Database.Tables(0).Location
                rptDoc.SetDataSource(dvDataView.ToTable(dvDataView.Table.TableName))
                SetReportParameterValues(ParameterValues)
                Return rptDoc
            Catch ex As Exception
                Dim oAppLog As New MSGCOMMON.MsgErrorHndlr
                oAppLog.WriteErrorLog("1", "ReportUtil", "CreateReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, "UserID")
                oAppLog = Nothing
                Throw New Exception("Improper DataTable")
            Finally
            End Try
        End Function
        Public Function CreateReportForInvoicePrint(ByVal ConnectionString As String, ByVal FileName As String, ByVal invXML As String, ByVal rptType As String) As ReportDocument
            Dim strServerName As String = String.Empty
            Dim strUserId As String = String.Empty
            Dim strPassword As String = String.Empty
            Dim strDatabaseName As String = String.Empty
            ReadConnectionSettings(ConnectionString, strServerName, strUserId, strPassword, strDatabaseName)
            LoadReport(FileName)
            SetDbLogon(strServerName, strUserId, strPassword, strDatabaseName)
            rptDoc.SetParameterValue("@INV_NOS_WOSXML", invXML)
            rptDoc.SetParameterValue("@TYPE", rptType)
            Return rptDoc
        End Function
        Public Function CreateTransactionReport(ByVal ConnectionString As String, ByVal FileName As String, ByVal TransXML As String) As ReportDocument
            Dim strServerName As String = String.Empty
            Dim strUserId As String = String.Empty
            Dim strPassword As String = String.Empty
            Dim strDatabaseName As String = String.Empty
            ReadConnectionSettings(ConnectionString, strServerName, strUserId, strPassword, strDatabaseName)
            LoadReport(FileName)
            SetDbLogon(strServerName, strUserId, strPassword, strDatabaseName)
            rptDoc.SetParameterValue("@IV_XMLDOC", TransXML)
            Return rptDoc
        End Function
        Public Function CreateReportForList(ByVal ConnectionString As String, ByVal FileName As String, ByVal spareXML As String, ByVal ID_WO_NO As String, ByVal ID_WO_PREFIX As String) As ReportDocument
            Dim strServerName As String = String.Empty
            Dim strUserId As String = String.Empty
            Dim strPassword As String = String.Empty
            Dim strDatabaseName As String = String.Empty
            ReadConnectionSettings(ConnectionString, strServerName, strUserId, strPassword, strDatabaseName)
            LoadReport(FileName)
            SetDbLogon(strServerName, strUserId, strPassword, strDatabaseName)
            rptDoc.SetParameterValue("@IV_XMLDOC", spareXML)
            rptDoc.SetParameterValue("@ID_WO_NO", ID_WO_NO)
            rptDoc.SetParameterValue("@ID_WO_PREFIX", ID_WO_PREFIX)
            Return rptDoc
        End Function
#End Region

#Region "Private Functions"
        Private Sub LoadReport(ByVal FileName As String)
            Try
                Dim strFilename As String = _ReportPath + "\" + FileName
                rptDoc = New ReportDocument()
                rptDoc.Load(strFilename, OpenReportMethod.OpenReportByTempCopy)
            Catch ex As Exception
                Throw
            End Try
        End Sub
        Private Sub SetDBParameterValues(ByVal ParameterValues As String)
            Dim xmlDoc As XmlDocument
            Try
                If Not String.IsNullOrEmpty(ParameterValues) Then
                    xmlDoc = New XmlDocument
                    xmlDoc.LoadXml(ParameterValues)
                    Dim xNode As XmlNode = xmlDoc.SelectSingleNode("//Parameters")
                    Dim attrib As XmlAttribute
                    If Not IsNothing(xNode) Then
                        For Each attrib In xNode.Attributes
                            Select Case rptDoc.ParameterFields("@" + attrib.Name).ParameterValueType
                                Case ParameterValueKind.BooleanParameter
                                    Dim boolVal As Boolean
                                    Dim boolChk As Boolean
                                    boolChk = Boolean.TryParse(attrib.Value, boolVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue("@" + attrib.Name, boolVal)
                                    Else
                                        rptDoc.SetParameterValue("@" + attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.CurrencyParameter
                                    Dim currVal As Decimal
                                    Dim boolChk As Boolean
                                    boolChk = Decimal.TryParse(attrib.Value, currVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue("@" + attrib.Name, currVal)
                                    Else
                                        rptDoc.SetParameterValue("@" + attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.DateParameter
                                    Dim dateVal As Date
                                    Dim bool As Boolean
                                    bool = DateTime.TryParse(attrib.Value, dateVal)
                                    If (bool) Then
                                        rptDoc.SetParameterValue("@" + attrib.Name, dateVal)
                                    Else
                                        rptDoc.SetParameterValue("@" + attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.DateTimeParameter
                                    Dim datetimeVal As DateTime
                                    Dim boolChk As Boolean
                                    boolChk = DateTime.TryParse(attrib.Value, datetimeVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue("@" + attrib.Name, datetimeVal)
                                    Else
                                        rptDoc.SetParameterValue("@" + attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.NumberParameter
                                    Dim integerVal As Double
                                    Dim boolChk As Boolean
                                    boolChk = Double.TryParse(attrib.Value, integerVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue("@" + attrib.Name, integerVal)
                                    Else
                                        rptDoc.SetParameterValue("@" + attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.StringParameter
                                    Dim strValue As String = String.Empty
                                    strValue = objCommonUtil.ConvertStr(attrib.Value)
                                    rptDoc.SetParameterValue("@" + attrib.Name, IIf(String.IsNullOrEmpty(attrib.Value), DBNull.Value, strValue))

                            End Select

                        Next
                    End If
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub
        Private Sub SetReportParameterValues(ByVal ParameterValues As String)
            Dim xmlDoc As XmlDocument
            Try
                If Not String.IsNullOrEmpty(ParameterValues) Then
                    xmlDoc = New XmlDocument
                    xmlDoc.LoadXml(ParameterValues)
                    Dim xNode As XmlNode = xmlDoc.SelectSingleNode("//ReportParameters")
                    If Not IsNothing(xNode) Then
                        Dim attrib As XmlAttribute
                        For Each attrib In xNode.Attributes
                            Select Case rptDoc.ParameterFields(attrib.Name).ParameterValueType
                                Case ParameterValueKind.BooleanParameter
                                    Dim boolVal As Boolean
                                    Dim boolChk As Boolean
                                    boolChk = Boolean.TryParse(attrib.Value, boolVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue(attrib.Name, boolVal)
                                    Else
                                        rptDoc.SetParameterValue(attrib.Name, False)
                                    End If

                                Case ParameterValueKind.CurrencyParameter
                                    Dim currVal As Integer
                                    Dim boolChk As Boolean
                                    boolChk = Integer.TryParse(attrib.Value, currVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue(attrib.Name, currVal)
                                    Else
                                        rptDoc.SetParameterValue(attrib.Name, 0)
                                    End If

                                Case ParameterValueKind.DateParameter
                                    Dim dateVal As Date
                                    Dim bool As Boolean
                                    bool = DateTime.TryParse(attrib.Value, dateVal)
                                    If (bool) Then
                                        rptDoc.SetParameterValue(attrib.Name, dateVal)
                                    Else
                                        rptDoc.SetParameterValue(attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.DateTimeParameter
                                    Dim datetimeVal As DateTime
                                    Dim boolChk As Boolean
                                    boolChk = DateTime.TryParse(attrib.Value, datetimeVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue(attrib.Name, datetimeVal)
                                    Else
                                        rptDoc.SetParameterValue(attrib.Name, DBNull.Value)
                                    End If

                                Case ParameterValueKind.NumberParameter
                                    Dim integerVal As Int32
                                    Dim boolChk As Boolean
                                    boolChk = Int32.TryParse(attrib.Value, integerVal)
                                    If (boolChk) Then
                                        rptDoc.SetParameterValue(attrib.Name, integerVal)
                                    Else
                                        rptDoc.SetParameterValue(attrib.Name, 0)
                                    End If
                                Case ParameterValueKind.StringParameter
                                    rptDoc.SetParameterValue(attrib.Name, attrib.Value)
                            End Select
                        Next
                    End If
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub
        Private Sub SetDbLogon(ByVal strServerName As String, ByVal strUserId As String, ByVal strPassword As String, ByVal strDatabaseName As String)
            Dim rptTable As CrystalDecisions.CrystalReports.Engine.Table
            Dim rptSub As ReportDocument
            Dim rptSubDoc As ReportDocument
            Dim myLogonInfo As TableLogOnInfo
            Try
                For Each rptTable In rptDoc.Database.Tables
                    myLogonInfo = New CrystalDecisions.Shared.TableLogOnInfo
                    myLogonInfo = rptTable.LogOnInfo
                    With myLogonInfo.ConnectionInfo
                        .ServerName = strServerName
                        .DatabaseName = strDatabaseName
                        .UserID = strUserId
                        .Password = strPassword
                    End With
                    rptTable.ApplyLogOnInfo(myLogonInfo)
                    rptTable.Location = strDatabaseName + ".dbo." & rptTable.Location.Substring(rptTable.Location.LastIndexOf(".") + 1)
                Next
                For Each rptSub In rptDoc.Subreports
                    rptSubDoc = rptDoc.OpenSubreport(rptSub.Name)
                    For Each rptTable In rptSubDoc.Database.Tables
                        myLogonInfo = New CrystalDecisions.Shared.TableLogOnInfo
                        myLogonInfo = rptTable.LogOnInfo
                        With myLogonInfo.ConnectionInfo
                            .ServerName = strServerName
                            .DatabaseName = strDatabaseName
                            .UserID = strUserId
                            .Password = strPassword
                        End With
                        rptTable.ApplyLogOnInfo(myLogonInfo)
                        rptTable.Location = strDatabaseName + ".dbo." & rptTable.Location.Substring(rptTable.Location.LastIndexOf(".") + 1)
                    Next
                Next
            Catch ex As Exception
                Throw
            Finally
                If Not rptTable Is Nothing Then
                    rptTable.Dispose()
                End If
            End Try
        End Sub
#End Region

#Region "Utilities"
        Private Sub ReadConnectionSettings(ByVal ConnectionString As String, ByRef strServerName As String, ByRef strUserId As String, ByRef strPassword As String, ByRef strDatabaseName As String)
            Dim blnSuccessflg As Boolean = False
            Dim strConnection As String
            Dim strServerString As String
            Dim strUserIdString As String
            Dim strPasswordString As String
            Dim strDatabaseNameString As String
            strConnection = ConnectionString
            Try
                If Trim(strConnection) <> "" Then
                    Dim chrStrSplitter As Char = ";"
                    strUserIdString = Left(strConnection, strConnection.IndexOf(chrStrSplitter))
                    strUserId = Mid(strUserIdString, strUserIdString.IndexOf("=") + 2)
                    strConnection = Mid(strConnection, strConnection.IndexOf(chrStrSplitter) + 2)
                    strPasswordString = Left(strConnection, strConnection.IndexOf(chrStrSplitter))
                    strPassword = Mid(strPasswordString, strPasswordString.IndexOf("=") + 2)
                    strConnection = Mid(strConnection, strConnection.IndexOf(chrStrSplitter) + 2)
                    strDatabaseNameString = Left(strConnection, strConnection.IndexOf(chrStrSplitter))
                    strDatabaseName = Mid(strDatabaseNameString, strDatabaseNameString.IndexOf("=") + 2)
                    strServerString = Mid(strConnection, strConnection.IndexOf(chrStrSplitter) + 2)
                    strServerName = Mid(strServerString, strServerString.IndexOf("=") + 2)
                    blnSuccessflg = True
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub

        


#End Region

    End Class

End Namespace
