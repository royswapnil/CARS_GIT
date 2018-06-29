Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Namespace ABS10SS3DO

    Public Class ReportSettings
#Region "MEMBER VARIABLES"
        Dim _subsidiary As SqlTypes.SqlInt32
        Dim _department As SqlTypes.SqlInt32
        Dim _orderType As SqlTypes.SqlString
        Dim _reportID As SqlTypes.SqlString
        Dim _displaySettingsXML As SqlTypes.SqlXml
        Dim _userID As SqlTypes.SqlString
        Dim _image As SqlTypes.SqlBytes
        Dim _imageDisplaySettings As SqlTypes.SqlXml
        Dim _reportSettingID As SqlTypes.SqlInt32
        Dim _reportName As SqlTypes.SqlString
        Dim _name As SqlTypes.SqlString
        Dim _cation As SqlTypes.SqlString
#End Region

#Region "PROPERTIES"
        Public Property Subsidiary() As SqlTypes.SqlInt32
            Get
                Return _subsidiary
            End Get
            Set(ByVal value As SqlTypes.SqlInt32)
                _subsidiary = value
            End Set
        End Property
        Public Property Department() As SqlTypes.SqlInt32
            Get
                Return _department
            End Get
            Set(ByVal value As SqlTypes.SqlInt32)
                _department = value
            End Set
        End Property
        Public Property OrderType() As SqlTypes.SqlString
            Get
                Return _orderType
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _orderType = value
            End Set
        End Property
        Public Property ReportID() As SqlTypes.SqlString
            Get
                Return _reportID
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _reportID = value
            End Set
        End Property
        Public Property DisplaySettingsXML() As SqlTypes.SqlXml
            Get
                Return _displaySettingsXML
            End Get
            Set(ByVal value As SqlTypes.SqlXml)
                _displaySettingsXML = value
            End Set
        End Property
        Public Property UserID() As SqlTypes.SqlString
            Get
                Return _userID
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _userID = value
            End Set
        End Property
        Public Property Image() As SqlTypes.SqlBytes
            Get
                Return _image
            End Get
            Set(ByVal value As SqlTypes.SqlBytes)
                _image = value
            End Set
        End Property
        Public Property ImageDisplaySettings() As SqlTypes.SqlXml
            Get
                Return _imageDisplaySettings
            End Get
            Set(ByVal value As SqlTypes.SqlXml)
                _imageDisplaySettings = value
            End Set
        End Property
        Public Property ReportSettingID() As SqlTypes.SqlInt32
            Get
                Return _reportSettingID
            End Get
            Set(ByVal value As SqlTypes.SqlInt32)
                _reportSettingID = value
            End Set
        End Property
        Public Property ReportName() As SqlTypes.SqlString
            Get
                Return _reportName
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _reportName = value
            End Set
        End Property
        Public Property Name() As SqlTypes.SqlString
            Get
                Return _name
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _name = value
            End Set
        End Property
        Public Property Caption() As SqlTypes.SqlString
            Get
                Return _cation
            End Get
            Set(ByVal value As SqlTypes.SqlString)
                _cation = value
            End Set
        End Property
#End Region

#Region "FUNCTIONS"
        Public Function LoadDisplaySettings() As DataSet
            Dim sqlParam(4) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            Return SqlHelper.ExecuteDataset(CommandType.StoredProcedure, "USP_REP_LOAD_REPORTSETTINGS", sqlParam)
        End Function

        Public Function SaveDisplaySettings() As Integer
            Dim sqlParam(6) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(4) = New SqlParameter
            With sqlParam(4)
                .ParameterName = "@DISPLAYSETTINGSXML"
                .Direction = ParameterDirection.Input
                .SqlValue = DisplaySettingsXML
                .SqlDbType = SqlDbType.Xml
            End With
            sqlParam(5) = New SqlParameter
            With sqlParam(5)
                .ParameterName = "@USERID"
                .Direction = ParameterDirection.Input
                .SqlValue = UserID
                .SqlDbType = SqlDbType.VarChar
                .Size = 20
            End With
            Return SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure, "USP_REP_SAVE_REPORTDISPLAYSETTINGS", sqlParam)
        End Function
        Public Function LoadImagewithDisplaySettings() As Integer
            Dim sqlParam(6) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@IMAGE"
                .Direction = ParameterDirection.Input
                .SqlDbType = SqlDbType.Image
                .Size = 50
                .SqlValue = _image
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(4) = New SqlParameter
            With sqlParam(4)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.Int
            End With

        End Function
        Public Function SaveImagewithDisplaySettings() As Integer
            Dim sqlParam(6) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@IMAGE"
                .Direction = ParameterDirection.Input
                .SqlDbType = SqlDbType.Image

                .SqlValue = _image
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(4) = New SqlParameter
            With sqlParam(4)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(5) = New SqlParameter
            With sqlParam(5)
                .ParameterName = "@DISPLAYSETTINGSXML"
                .Direction = ParameterDirection.Input
                .SqlValue = ImageDisplaySettings
                .SqlDbType = SqlDbType.Xml
                .Size = 500
            End With
            sqlParam(6) = New SqlParameter
            With sqlParam(6)
                .ParameterName = "@USERID"
                .Direction = ParameterDirection.Input
                .SqlValue = UserID
                .SqlDbType = SqlDbType.VarChar
                .Size = 20
            End With
            Return SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure, "USP_REP_SAVE_REPORTIMAGEDISPLAYSETTINGS", sqlParam)
        End Function
        Public Function SavePrinterSettings() As Integer
            Dim sqlParam(5) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With

            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(4) = New SqlParameter
            With sqlParam(4)
                .ParameterName = "@PRINTERSETTINGSXML"
                .Direction = ParameterDirection.Input
                .SqlValue = DisplaySettingsXML
                .SqlDbType = SqlDbType.Xml
                .Size = 500
            End With
            sqlParam(5) = New SqlParameter
            With sqlParam(5)
                .ParameterName = "@USERID"
                .Direction = ParameterDirection.Input
                .SqlValue = UserID
                .SqlDbType = SqlDbType.VarChar
                .Size = 20
            End With
            Return SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure, "USP_REP_SAVE_REPORTPRINTERSETTINGS", sqlParam)
        End Function
        Public Function SaveReportSettings() As Integer
            Dim sqlParam(8) As SqlParameter
            sqlParam(0) = New SqlParameter
            With sqlParam(0)
                .ParameterName = "@REPORTID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportID
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(1) = New SqlParameter
            With sqlParam(1)
                .ParameterName = "@REPORTSETTINGID"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportSettingID
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(2) = New SqlParameter
            With sqlParam(2)
                .ParameterName = "@REPORTNAME"
                .Direction = ParameterDirection.Input
                .SqlValue = ReportName
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(3) = New SqlParameter
            With sqlParam(3)
                .ParameterName = "@TYPE"
                .Direction = ParameterDirection.Input
                .SqlValue = OrderType
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(4) = New SqlParameter
            With sqlParam(4)
                .ParameterName = "@SUBSIDIARY"
                .Direction = ParameterDirection.Input
                .SqlValue = Subsidiary
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(5) = New SqlParameter
            With sqlParam(5)
                .ParameterName = "@DEPARTMENT"
                .Direction = ParameterDirection.Input
                .SqlValue = Department
                .SqlDbType = SqlDbType.Int
            End With
            sqlParam(6) = New SqlParameter
            With sqlParam(6)
                .ParameterName = "@USERID"
                .Direction = ParameterDirection.Input
                .SqlValue = UserID
                .SqlDbType = SqlDbType.VarChar
                .Size = 20
            End With
            sqlParam(7) = New SqlParameter
            With sqlParam(7)
                .ParameterName = "@NAME"
                .Direction = ParameterDirection.Input
                .SqlValue = Name
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            sqlParam(8) = New SqlParameter
            With sqlParam(8)
                .ParameterName = "@CAPTION"
                .Direction = ParameterDirection.Input
                .SqlValue = Caption
                .SqlDbType = SqlDbType.VarChar
                .Size = 50
            End With
            Return SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure, "USP_REP_SAVE_REPORTSETTINGS", sqlParam)
        End Function
#End Region

    End Class
End Namespace

