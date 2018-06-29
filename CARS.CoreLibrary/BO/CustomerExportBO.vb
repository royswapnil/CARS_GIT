Public Class CustomerExportBO
#Region "Variables"
    Private _templateId As String
    Private _templateName As String
    Private _description As String
    Private _fileName As String
    Private _fileType As String
    Private _fieldName As String
    Private _positionFrom As String
    Private _orderInFile As String
    Private _decimalDivide As String
    Private _fixedInfo As String
    Private _encChar As String
    Private _delimiterOther As String
    Private _charSet As String
    Private _decimalDelimiter As String
    Private _thousandsDelimiter As String
    Private _dateFormat As String
    Private _timeFormat As String
    Private _fileMode As String
    Private _delimiter As String
    Private _length As String
    Private _fieldId As String
    Private _configuration As String
    Private _specialDelim As String
    Private _userId As String
    Private _isDecimalDivide As String
    Private _prefixLen As String
    Private _seriesLen As String
    Private _jobIdLen As String

#End Region
#Region "Property"
    
    Public Property TemplateId() As String
        Get
            Return _templateId
        End Get
        Set(ByVal Value As String)
            _templateId = Value
        End Set
    End Property
    Public Property TemplateName() As String
        Get
            Return _templateName
        End Get
        Set(ByVal Value As String)
            _templateName = Value
        End Set
    End Property
    Public Property Length() As String
        Get
            Return _length
        End Get
        Set(ByVal Value As String)
            _length = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _description
        End Get
        Set(ByVal Value As String)
            _description = Value
        End Set
    End Property
    Public Property FileName() As String
        Get
            Return _fileName
        End Get
        Set(ByVal Value As String)
            _fileName = Value
        End Set
    End Property
    Public Property FileType() As String
        Get
            Return _fileType
        End Get
        Set(ByVal Value As String)
            _fileType = Value
        End Set
    End Property
    Public Property FieldName() As String
        Get
            Return _fieldName
        End Get
        Set(ByVal Value As String)
            _fieldName = Value
        End Set
    End Property
    Public Property PositionFrom() As String
        Get
            Return _positionFrom
        End Get
        Set(ByVal Value As String)
            _positionFrom = Value
        End Set
    End Property
    Public Property OrderInFile() As String
        Get
            Return _orderInFile
        End Get
        Set(ByVal Value As String)
            _orderInFile = Value
        End Set
    End Property
    Public Property DecimalDivide() As String
        Get
            Return _decimalDivide
        End Get
        Set(ByVal Value As String)
            _decimalDivide = Value
        End Set
    End Property
    Public Property FixedInformation() As String
        Get
            Return _fixedInfo
        End Get
        Set(ByVal Value As String)
            _fixedInfo = Value
        End Set
    End Property
    Public Property EnclosingChar() As String
        Get
            Return _encChar
        End Get
        Set(ByVal Value As String)
            _encChar = Value
        End Set
    End Property
    Public Property DelimiterOther() As String
        Get
            Return _delimiterOther
        End Get
        Set(ByVal Value As String)
            _delimiterOther = Value
        End Set
    End Property
    Public Property CharacterSet() As String
        Get
            Return _charSet
        End Get
        Set(ByVal Value As String)
            _charSet = Value
        End Set
    End Property
    Public Property DecimalDelimiter() As String
        Get
            Return _decimalDelimiter
        End Get
        Set(ByVal Value As String)
            _decimalDelimiter = Value
        End Set
    End Property
    Public Property ThousandsDelimiter() As String
        Get
            Return _thousandsDelimiter
        End Get
        Set(ByVal Value As String)
            _thousandsDelimiter = Value
        End Set
    End Property
    Public Property DateFormat() As String
        Get
            Return _dateFormat
        End Get
        Set(ByVal Value As String)
            _dateFormat = Value
        End Set
    End Property
    Public Property TimeFormat() As String
        Get
            Return _timeFormat
        End Get
        Set(ByVal Value As String)
            _timeFormat = Value
        End Set
    End Property
    Public Property FileMode() As String
        Get
            Return _fileMode
        End Get
        Set(ByVal Value As String)
            _fileMode = Value
        End Set
    End Property
    Public Property Delimiter() As String
        Get
            Return _delimiter
        End Get
        Set(ByVal Value As String)
            _delimiter = Value
        End Set
    End Property
    Public Property FieldId() As Integer
        Get
            Return _fieldId
        End Get
        Set(ByVal Value As Integer)
            _fieldId = Value
        End Set
    End Property
    Public Property Configuration() As String
        Get
            Return _configuration
        End Get
        Set(ByVal Value As String)
            _configuration = Value
        End Set
    End Property
    Public Property SpecialDelimiter() As String
        Get
            Return _specialDelim
        End Get
        Set(ByVal Value As String)
            _specialDelim = Value
        End Set
    End Property
    Public Property UserId() As String
        Get
            Return _userId
        End Get
        Set(ByVal Value As String)
            _userId = Value
        End Set
    End Property
    Public Property IsDecimalDivide() As String
        Get
            Return _isDecimalDivide
        End Get
        Set(ByVal Value As String)
            _isDecimalDivide = Value
        End Set
    End Property
    Public Property PrefixLen() As String
        Get
            Return _prefixLen
        End Get
        Set(ByVal Value As String)
            _prefixLen = Value
        End Set
    End Property
    Public Property SeriesLen() As String
        Get
            Return _seriesLen
        End Get
        Set(ByVal Value As String)
            _seriesLen = Value
        End Set
    End Property
    Public Property JobIdLen() As String
        Get
            Return _jobIdLen
        End Get
        Set(ByVal Value As String)
            _jobIdLen = Value
        End Set
    End Property
#End Region


End Class
