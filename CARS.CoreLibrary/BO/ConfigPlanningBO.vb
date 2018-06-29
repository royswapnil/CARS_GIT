Public Class ConfigPlanningBO
    Private _id_station As String
    Private _station_name As String
    Private _id_station_type As String
    Private _station_type As String
    Private _id_dept As String
    Private _deptName As String
    Public Property Id_Station() As String
        Get
            Return _id_station
        End Get
        Set(ByVal Value As String)
            _id_station = Value
        End Set
    End Property
    Public Property Station_Name() As String
        Get
            Return _station_name
        End Get
        Set(ByVal Value As String)
            _station_name = Value
        End Set
    End Property
    Public Property Id_StationType() As String
        Get
            Return _id_station_type
        End Get
        Set(ByVal Value As String)
            _id_station_type = Value
        End Set
    End Property
    Public Property StationType() As String
        Get
            Return _station_type
        End Get
        Set(ByVal Value As String)
            _station_type = Value
        End Set
    End Property
    Public Property Id_Dept() As String
        Get
            Return _id_dept
        End Get
        Set(ByVal Value As String)
            _id_dept = Value
        End Set
    End Property
    Public Property DeptName() As String
        Get
            Return _deptName
        End Get
        Set(ByVal Value As String)
            _deptName = Value
        End Set
    End Property

End Class
