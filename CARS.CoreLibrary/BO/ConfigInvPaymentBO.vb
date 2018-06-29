Public Class ConfigInvPaymentBO

    Private _invPrefix As String
    Private _invDesc As String
    Private _invStartNo As Integer
    Private _invEndNo As Integer
    Private _invWarningBefore As Integer
    Private _createdBy As String
    Private _textCode As String
    Private _invSeries As Integer
    Private _createddate As String
    Private _modifieddate As String
    Private _modifiedby As String
    Public Property InvPrefix() As String
        Get
            Return _invPrefix
        End Get
        Set(ByVal Value As String)
            _invPrefix = Value
        End Set
    End Property
    Public Property InvDesc() As String
        Get
            Return _invDesc
        End Get
        Set(ByVal Value As String)
            _invDesc = Value
        End Set
    End Property
    Public Property InvStartNo() As Integer
        Get
            Return _invStartNo
        End Get
        Set(ByVal Value As Integer)
            _invStartNo = Value
        End Set
    End Property
    Public Property InvEndNo() As Integer
        Get
            Return _invEndNo
        End Get
        Set(ByVal Value As Integer)
            _invEndNo = Value
        End Set
    End Property
    Public Property InvWarningBefore() As Integer
        Get
            Return _invWarningBefore
        End Get
        Set(ByVal Value As Integer)
            _invWarningBefore = Value
        End Set
    End Property
    Public Property CreatedBy() As String
        Get
            Return _createdBy
        End Get
        Set(ByVal Value As String)
            _createdBy = Value
        End Set
    End Property
    Public Property TextCode() As String
        Get
            Return _textCode
        End Get
        Set(ByVal Value As String)
            _textCode = Value
        End Set
    End Property
    Public Property InvSeries() As Integer
        Get
            Return _invSeries
        End Get
        Set(ByVal Value As Integer)
            _invSeries = Value
        End Set
    End Property
    Public Property CreatedDate() As String
        Get
            Return _createddate
        End Get
        Set(ByVal Value As String)
            _createddate = Value
        End Set
    End Property
    Public Property ModifiedDate() As String
        Get
            Return _modifieddate
        End Get
        Set(ByVal Value As String)
            _modifieddate = Value
        End Set
    End Property
    Public Property ModifiedBy() As String
        Get
            Return _modifiedby
        End Get
        Set(ByVal Value As String)
            _modifiedby = Value
        End Set
    End Property

End Class
