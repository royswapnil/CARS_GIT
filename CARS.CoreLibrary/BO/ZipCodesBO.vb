Public Class ZipCodesBO
#Region "Variables"
    Private _userID As String
    Private _zipCode As String
    Private _country As String
    Private _state As String
    Private _city As String
    Private _createdBy As String
    Private _idZip As Integer
    Private _idParam As String
    Private _description As String
#End Region

    Public Property UserId() As String
        Get
            Return _userID
        End Get
        Set(ByVal Value As String)
            _userID = Value
        End Set
    End Property
    Public Property ZipCode() As String
        Get
            Return _zipCode
        End Get
        Set(ByVal Value As String)
            _zipCode = Value
        End Set
    End Property
    Public Property Country() As String
        Get
            Return _country
        End Get
        Set(ByVal Value As String)
            _country = Value
        End Set
    End Property
    Public Property State() As String
        Get
            Return _state
        End Get
        Set(ByVal Value As String)
            _state = Value
        End Set
    End Property
    Public Property City() As String
        Get
            Return _city
        End Get
        Set(ByVal Value As String)
            _city = Value
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
    Public Property IdZip() As Integer
        Get
            Return _idZip
        End Get
        Set(ByVal Value As Integer)
            _idZip = Value
        End Set
    End Property
    Public Property IdParam() As String
        Get
            Return _idParam
        End Get
        Set(ByVal Value As String)
            _idParam = Value
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

End Class
