Public Class ScanDataImportSchedulerBO
    Private _import_name As String
    Private _filelocation As String
    Private _import_description As String
    Private _sch_basis As String
    Private _sch_timeformat As String
    Private _sch_daily_interval_mins As String
    Private _sch_week_day As String
    Private _sch_month_day As String
    Private _sch_daily_stime As String
    Private _sch_daily_etime As String
    Private _sch_week_time As String
    Private _sch_month_time As String
    Private _sch_base As String
    Private _sch_id As String
    Private _dte_from As DateTime

    Public Property Import_Name() As String
        Get
            Return _import_name
        End Get
        Set(ByVal value As String)
            _import_name = value
        End Set
    End Property
    Public Property FileLocation() As String
        Get
            Return _filelocation
        End Get
        Set(ByVal value As String)
            _filelocation = value
        End Set
    End Property
    Public Property Import_Description() As String
        Get
            Return _import_description
        End Get
        Set(ByVal value As String)
            _import_description = value
        End Set
    End Property
    Public Property Sch_Basis() As String
        Get
            Return _sch_basis
        End Get
        Set(ByVal value As String)
            _sch_basis = value
        End Set
    End Property
    Public Property Sch_TimeFormat() As String
        Get
            Return _sch_timeformat
        End Get
        Set(ByVal value As String)
            _sch_timeformat = value
        End Set
    End Property
    Public Property Sch_Daily_Interval_mins() As String
        Get
            Return _sch_daily_interval_mins
        End Get
        Set(ByVal value As String)
            _sch_daily_interval_mins = value
        End Set
    End Property
    Public Property Sch_Week_Day() As String
        Get
            Return _sch_week_day
        End Get
        Set(ByVal value As String)
            _sch_week_day = value
        End Set
    End Property
    Public Property Sch_Month_Day() As String
        Get
            Return _sch_month_day
        End Get
        Set(ByVal value As String)
            _sch_month_day = value
        End Set
    End Property
    Public Property Sch_Daily_STime() As String
        Get
            Return _sch_daily_stime
        End Get
        Set(ByVal value As String)
            _sch_daily_stime = value
        End Set
    End Property
    Public Property Sch_Daily_ETime() As String
        Get
            Return _sch_daily_etime
        End Get
        Set(ByVal value As String)
            _sch_daily_etime = value
        End Set
    End Property
    Public Property Sch_Week_Time() As String
        Get
            Return _sch_week_time
        End Get
        Set(ByVal value As String)
            _sch_week_time = value
        End Set
    End Property
    Public Property Sch_Month_Time() As String
        Get
            Return _sch_month_time
        End Get
        Set(ByVal value As String)
            _sch_month_time = value
        End Set
    End Property
    Public Property Sch_Base() As String
        Get
            Return _sch_base
        End Get
        Set(ByVal value As String)
            _sch_base = value
        End Set
    End Property
    Public Property Sch_Id() As String
        Get
            Return _sch_id
        End Get
        Set(ByVal value As String)
            _sch_id = value
        End Set
    End Property
    Public Property Dte_From() As DateTime
        Get
            Return _dte_from
        End Get
        Set(ByVal value As DateTime)
            _dte_from = value
        End Set
    End Property




End Class
