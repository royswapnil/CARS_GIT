Public Class TimeRegDetBO
    Private _id_login As String
    Private _mech_firstName As String
    Private _login_name As String
    Private _job_lineNo As String
    Private _id_woLabSeq As String
    Private _lab_desc As String
    Private _description As String
    Private _id_sett As String
    Private _id_tr_seq As String
    Private _dt_clockin As String
    Private _dt_clockout As String
    Private _time_clockin As String
    Private _time_clockout As String
    Private _id_unsoldTime As String
    Private _orderNo As String
    Private _jobNo As String
    Private _unsoldTime As String
    Private _lineNo As String
    Private _idMech As String
    Private _mechName As String
    Private _text As String
    Private _totalClockedTime As String
    Private _wo_lab_hrs As String
    Private _clocked_time As String
    Private _totaltimeonorder As String
    Private _totaltimeunsold As String

    Public Property Id_Login() As String
        Get
            Return _id_login
        End Get
        Set(ByVal value As String)
            _id_login = value
        End Set
    End Property
    Public Property Mech_FirstName() As String
        Get
            Return _mech_firstName
        End Get
        Set(ByVal value As String)
            _mech_firstName = value
        End Set
    End Property
    Public Property Login_Name() As String
        Get
            Return _login_name
        End Get
        Set(ByVal Value As String)
            _login_name = Value
        End Set
    End Property
    Public Property Job_LineNo() As String
        Get
            Return _job_lineNo
        End Get
        Set(ByVal Value As String)
            _job_lineNo = Value
        End Set
    End Property
    Public Property Lab_Desc() As String
        Get
            Return _lab_desc
        End Get
        Set(ByVal Value As String)
            _lab_desc = Value
        End Set
    End Property
    Public Property Id_WoLab_Seq() As String
        Get
            Return _id_woLabSeq
        End Get
        Set(ByVal Value As String)
            _id_woLabSeq = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _id_sett
        End Get
        Set(ByVal Value As String)
            _id_sett = Value
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
    Public Property Id_Tr_Seq() As String
        Get
            Return _id_tr_seq
        End Get
        Set(ByVal Value As String)
            _id_tr_seq = Value
        End Set
    End Property
    Public Property Dt_clockin() As String
        Get
            Return _dt_clockin
        End Get
        Set(ByVal Value As String)
            _dt_clockin = Value
        End Set
    End Property
    Public Property Dt_clockout() As String
        Get
            Return _dt_clockout
        End Get
        Set(ByVal Value As String)
            _dt_clockout = Value
        End Set
    End Property
    Public Property Time_clockin() As String
        Get
            Return _time_clockin
        End Get
        Set(ByVal Value As String)
            _time_clockin = Value
        End Set
    End Property
    Public Property Time_clockout() As String
        Get
            Return _time_clockout
        End Get
        Set(ByVal Value As String)
            _time_clockout = Value
        End Set
    End Property
    Public Property Id_UnsoldTime() As String
        Get
            Return _id_unsoldTime
        End Get
        Set(ByVal Value As String)
            _id_unsoldTime = Value
        End Set
    End Property
    Public Property OrderNo() As String
        Get
            Return _orderNo
        End Get
        Set(ByVal Value As String)
            _orderNo = Value
        End Set
    End Property
    Public Property JobNo() As String
        Get
            Return _jobNo
        End Get
        Set(ByVal Value As String)
            _jobNo = Value
        End Set
    End Property
    Public Property LineNo() As String
        Get
            Return _lineNo
        End Get
        Set(ByVal Value As String)
            _lineNo = Value
        End Set
    End Property
    Public Property IdMech() As String
        Get
            Return _idMech
        End Get
        Set(ByVal Value As String)
            _idMech = Value
        End Set
    End Property
    Public Property MechName() As String
        Get
            Return _mechName
        End Get
        Set(ByVal Value As String)
            _mechName = Value
        End Set
    End Property
    Public Property Text() As String
        Get
            Return _text
        End Get
        Set(ByVal Value As String)
            _text = Value
        End Set
    End Property
    Public Property UnsoldTime() As String
        Get
            Return _unsoldTime
        End Get
        Set(ByVal Value As String)
            _unsoldTime = Value
        End Set
    End Property
    Public Property TotalClockedTime() As String
        Get
            Return _totalClockedTime
        End Get
        Set(ByVal Value As String)
            _totalClockedTime = Value
        End Set
    End Property
    Public Property Wo_Lab_Hrs() As String
        Get
            Return _wo_lab_hrs
        End Get
        Set(ByVal Value As String)
            _wo_lab_hrs = Value
        End Set
    End Property
    Public Property Clocked_Time() As String
        Get
            Return _clocked_time
        End Get
        Set(ByVal Value As String)
            _clocked_time = Value
        End Set
    End Property
    Public Property TotalTimeOnOrder() As String
        Get
            Return _totaltimeonorder
        End Get
        Set(ByVal Value As String)
            _totaltimeonorder = Value
        End Set
    End Property
    Public Property TotalTimeUnsold() As String
        Get
            Return _totaltimeunsold
        End Get
        Set(ByVal Value As String)
            _totaltimeunsold = Value
        End Set
    End Property


End Class
