Public Class ConfigSettingsBO
    Private _userId As String
    Private _strXMLDOC As String
    Private _idconfig As String
    Private _idsettings As String
    Private _description As String
    Private _retValSaved As String
    Private _retValNotSaved As String
    Private _tr_percentage As String
    Private _smsserver As String
    Private _smsprefix As String
    Private _smssuffix As String
    Private _smsctrycde As String
    Private _smsnochars As String
    Private _smsstdigit As String
    Private _smsmailusr As String
    Private _messid As String
    Private _deptid As String
    Private _deptname As String
    Private _commercialtext As String
    Private _detailtext As String
    Private _vatperc As String
    Private _extvatcode As String
    Private _extaccntcode As String
    Private _typestation As String
    Private _idstype As String

    Public Property UserId() As String
        Get
            Return _userId
        End Get
        Set(ByVal Value As String)
            _userId = Value
        End Set
    End Property
    Public Property StrXMLDOC() As String
        Get
            Return _strXMLDOC
        End Get
        Set(ByVal Value As String)
            _strXMLDOC = Value
        End Set
    End Property
    Public Property IdConfig() As String
        Get
            Return _idconfig
        End Get
        Set(ByVal Value As String)
            _idconfig = Value
        End Set
    End Property
    Public Property IdSettings() As String
        Get
            Return _idsettings
        End Get
        Set(ByVal Value As String)
            _idsettings = Value
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
    Public Property RetVal_Saved() As String
        Get
            Return _retValSaved
        End Get
        Set(ByVal Value As String)
            _retValSaved = Value
        End Set
    End Property
    Public Property RetVal_NotSaved() As String
        Get
            Return _retValNotSaved
        End Get
        Set(ByVal Value As String)
            _retValNotSaved = Value
        End Set
    End Property
    Public Property TR_Percentage() As String
        Get
            Return _tr_percentage
        End Get
        Set(ByVal Value As String)
            _tr_percentage = Value
        End Set
    End Property
    Public Property SmsServer() As String
        Get
            Return _smsserver
        End Get
        Set(ByVal Value As String)
            _smsserver = Value
        End Set
    End Property
    Public Property SmsPrefix() As String
        Get
            Return _smsprefix
        End Get
        Set(ByVal Value As String)
            _smsprefix = Value
        End Set
    End Property
    Public Property SmsSuffix() As String
        Get
            Return _smssuffix
        End Get
        Set(ByVal Value As String)
            _smssuffix = Value
        End Set
    End Property
    Public Property SmsCtryCde() As String
        Get
            Return _smsctrycde
        End Get
        Set(ByVal Value As String)
            _smsctrycde = Value
        End Set
    End Property
    Public Property SmsNoChars() As String
        Get
            Return _smsnochars
        End Get
        Set(ByVal Value As String)
            _smsnochars = Value
        End Set
    End Property
    Public Property SmsStDigit() As String
        Get
            Return _smsstdigit
        End Get
        Set(ByVal Value As String)
            _smsstdigit = Value
        End Set
    End Property
    Public Property SmsMailUsr() As String
        Get
            Return _smsmailusr
        End Get
        Set(ByVal Value As String)
            _smsmailusr = Value
        End Set
    End Property
    Public Property MessId() As String
        Get
            Return _messid
        End Get
        Set(ByVal Value As String)
            _messid = Value
        End Set
    End Property
    Public Property DeptId() As String
        Get
            Return _deptid
        End Get
        Set(ByVal Value As String)
            _deptid = Value
        End Set
    End Property
    Public Property DeptName() As String
        Get
            Return _deptname
        End Get
        Set(ByVal Value As String)
            _deptname = Value
        End Set
    End Property
    Public Property CommercialText() As String
        Get
            Return _commercialtext
        End Get
        Set(ByVal Value As String)
            _commercialtext = Value
        End Set
    End Property
    Public Property DetailText() As String
        Get
            Return _detailtext
        End Get
        Set(ByVal Value As String)
            _detailtext = Value
        End Set
    End Property
    Public Property VatPerc() As String
        Get
            Return _vatperc
        End Get
        Set(ByVal Value As String)
            _vatperc = Value
        End Set
    End Property
    Public Property ExtVatCode() As String
        Get
            Return _extvatcode
        End Get
        Set(ByVal Value As String)
            _extvatcode = Value
        End Set
    End Property
    Public Property ExtAccntCode() As String
        Get
            Return _extaccntcode
        End Get
        Set(ByVal Value As String)
            _extaccntcode = Value
        End Set
    End Property
    Public Property IdStype() As String
        Get
            Return _idstype
        End Get
        Set(ByVal Value As String)
            _idstype = Value
        End Set
    End Property
    Public Property StationType() As String
        Get
            Return _typestation
        End Get
        Set(ByVal Value As String)
            _typestation = Value
        End Set
    End Property

End Class
