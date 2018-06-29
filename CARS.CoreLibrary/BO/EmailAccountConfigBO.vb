Public Class ConfigEmailAccountBO
    Private _id_email_accnt As String
    Private _subsidiary As String
    Private _setting_name As String
    Private _email As String
    Private _smtp As String
    Private _port As String
    Private _username As String
    Private _password As String
    Private _id_subsidiary As String
    Private _cryptation As String
    Public Property Id_Email_Accnt() As String
        Get
            Return _id_email_accnt
        End Get
        Set(ByVal Value As String)
            _id_email_accnt = Value
        End Set
    End Property
    Public Property Subsidiary() As String
        Get
            Return _subsidiary
        End Get
        Set(ByVal Value As String)
            _subsidiary = Value
        End Set
    End Property
    Public Property Setting_Name() As String
        Get
            Return _setting_name
        End Get
        Set(ByVal Value As String)
            _setting_name = Value
        End Set
    End Property
    Public Property Email() As String
        Get
            Return _email
        End Get
        Set(ByVal Value As String)
            _email = Value
        End Set
    End Property
    Public Property Smtp() As String
        Get
            Return _smtp
        End Get
        Set(ByVal Value As String)
            _smtp = Value
        End Set
    End Property
    Public Property Port() As String
        Get
            Return _port
        End Get
        Set(ByVal Value As String)
            _port = Value
        End Set
    End Property
    Public Property Username() As String
        Get
            Return _username
        End Get
        Set(ByVal Value As String)
            _username = Value
        End Set
    End Property
    Public Property Password() As String
        Get
            Return _password
        End Get
        Set(ByVal Value As String)
            _password = Value
        End Set
    End Property
    Public Property Id_Subsidiary() As String
        Get
            Return _id_subsidiary
        End Get
        Set(ByVal Value As String)
            _id_subsidiary = Value
        End Set
    End Property
    Public Property Cryptation() As String
        Get
            Return _cryptation
        End Get
        Set(ByVal Value As String)
            _cryptation = Value
        End Set
    End Property



End Class
