Public Class ConfigEmailTemplateBO

    Private _id_template As String
    Private _template_code As String
    Private _subject As String
    Private _short_message As String
    Private _message As String
    Private _flg_default As Boolean
    Private _start_time As String
    Private _use_mon As String
    Private _use_tue As String
    Private _use_wed As String
    Private _use_thur As String
    Private _use_fri As String
    Private _use_sat As String
    Private _use_sun As String


    Public Property Id_Template() As String
        Get
            Return _id_template
        End Get
        Set(ByVal Value As String)
            _id_template = Value
        End Set
    End Property
    Public Property Template_Code() As String
        Get
            Return _template_code
        End Get
        Set(ByVal Value As String)
            _template_code = Value
        End Set
    End Property
    Public Property Subject() As String
        Get
            Return _subject
        End Get
        Set(ByVal Value As String)
            _subject = Value
        End Set
    End Property
    Public Property Short_Message() As String
        Get
            Return _short_message
        End Get
        Set(ByVal Value As String)
            _short_message = Value
        End Set
    End Property
    Public Property Message() As String
        Get
            Return _message
        End Get
        Set(ByVal Value As String)
            _message = Value
        End Set
    End Property
    Public Property Flg_Default() As Boolean
        Get
            Return _flg_default
        End Get
        Set(ByVal Value As Boolean)
            _flg_default = Value
        End Set
    End Property
    Public Property Start_Time() As String
        Get
            Return _start_time
        End Get
        Set(ByVal Value As String)
            _start_time = Value
        End Set
    End Property
    Public Property Use_Mon() As String
        Get
            Return _use_mon
        End Get
        Set(ByVal Value As String)
            _use_mon = Value
        End Set
    End Property
    Public Property Use_Tue() As String
        Get
            Return _use_tue
        End Get
        Set(ByVal Value As String)
            _use_tue = Value
        End Set
    End Property
    Public Property Use_Wed() As String
        Get
            Return _use_wed
        End Get
        Set(ByVal Value As String)
            _use_wed = Value
        End Set
    End Property
    Public Property Use_Thur() As String
        Get
            Return _use_thur
        End Get
        Set(ByVal Value As String)
            _use_thur = Value
        End Set
    End Property
    Public Property Use_Fri() As String
        Get
            Return _use_fri
        End Get
        Set(ByVal Value As String)
            _use_fri = Value
        End Set
    End Property
    Public Property Use_Sat() As String
        Get
            Return _use_sat
        End Get
        Set(ByVal Value As String)
            _use_sat = Value
        End Set
    End Property
    Public Property Use_Sun() As String
        Get
            Return _use_sun
        End Get
        Set(ByVal Value As String)
            _use_sun = Value
        End Set
    End Property


End Class

