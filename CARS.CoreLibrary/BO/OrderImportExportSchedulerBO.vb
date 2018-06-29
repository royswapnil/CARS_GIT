Public Class OrderImportExportSchedulerBO
    Private _import_filelocation As String
    Private _import_filename As String
    Private _import_archivedays As String
    Private _import_sch_basis As String
    Private _import_timeformat As String
    Private _import_sch_daily_interval_mins As String
    Private _import_sch_week_day As String
    Private _import_sch_month_day As String
    Private _import_sch_daily_stime As String
    Private _import_sch_daily_etime As String
    Private _import_sch_week_time As String
    Private _import_sch_month_time As String

    Private _export_filelocation As String
    Private _export_filename As String
    Private _export_archivedays As String
    Private _export_sch_basis As String
    Private _export_timeformat As String
    Private _export_sch_daily_interval_mins As String
    Private _export_sch_week_day As String
    Private _export_sch_month_day As String
    Private _export_sch_daily_stime As String
    Private _export_sch_daily_etime As String
    Private _export_sch_week_time As String
    Private _export_sch_month_time As String

    Private _import_template As String
    Private _export_template As String
    Private _order_imp_sch_id As String
    Private _order_exp_sch_id As String
    Private _template_id As String
    Private _template_name As String

    Public Property Import_FileLocation() As String
        Get
            Return _import_filelocation
        End Get
        Set(ByVal value As String)
            _import_filelocation = value
        End Set
    End Property
    Public Property Import_FileName() As String
        Get
            Return _import_filename
        End Get
        Set(ByVal value As String)
            _import_filename = value
        End Set
    End Property
    Public Property Import_ArchiveDays() As String
        Get
            Return _import_archivedays
        End Get
        Set(ByVal value As String)
            _import_archivedays = value
        End Set
    End Property
    Public Property Import_Sch_Basis() As String
        Get
            Return _import_sch_basis
        End Get
        Set(ByVal value As String)
            _import_sch_basis = value
        End Set
    End Property
    Public Property Import_Sch_TimeFormat() As String
        Get
            Return _import_timeformat
        End Get
        Set(ByVal value As String)
            _import_timeformat = value
        End Set
    End Property
    Public Property Import_Sch_Daily_Interval_mins() As String
        Get
            Return _import_sch_daily_interval_mins
        End Get
        Set(ByVal value As String)
            _import_sch_daily_interval_mins = value
        End Set
    End Property
    Public Property Import_Sch_Week_Day() As String
        Get
            Return _import_sch_week_day
        End Get
        Set(ByVal value As String)
            _import_sch_week_day = value
        End Set
    End Property
    Public Property Import_Sch_Month_Day() As String
        Get
            Return _import_sch_month_day
        End Get
        Set(ByVal value As String)
            _import_sch_month_day = value
        End Set
    End Property
    Public Property Import_Sch_Daily_STime() As String
        Get
            Return _import_sch_daily_stime
        End Get
        Set(ByVal value As String)
            _import_sch_daily_stime = value
        End Set
    End Property
    Public Property Import_Sch_Daily_ETime() As String
        Get
            Return _import_sch_daily_etime
        End Get
        Set(ByVal value As String)
            _import_sch_daily_etime = value
        End Set
    End Property
    Public Property Import_Sch_Week_Time() As String
        Get
            Return _import_sch_week_time
        End Get
        Set(ByVal value As String)
            _import_sch_week_time = value
        End Set
    End Property
    Public Property Import_Sch_Month_Time() As String
        Get
            Return _import_sch_month_time
        End Get
        Set(ByVal value As String)
            _import_sch_month_time = value
        End Set
    End Property
    Public Property Export_FileLocation() As String
        Get
            Return _export_filelocation
        End Get
        Set(ByVal value As String)
            _export_filelocation = value
        End Set
    End Property
    Public Property Export_FileName() As String
        Get
            Return _export_filename
        End Get
        Set(ByVal value As String)
            _export_filename = value
        End Set
    End Property
    Public Property Export_ArchiveDays() As String
        Get
            Return _export_archivedays
        End Get
        Set(ByVal value As String)
            _export_archivedays = value
        End Set
    End Property
    Public Property Export_Sch_Basis() As String
        Get
            Return _export_sch_basis
        End Get
        Set(ByVal value As String)
            _export_sch_basis = value
        End Set
    End Property
    Public Property Export_Sch_TimeFormat() As String
        Get
            Return _export_timeformat
        End Get
        Set(ByVal value As String)
            _export_timeformat = value
        End Set
    End Property
    Public Property Export_Sch_Daily_Interval_mins() As String
        Get
            Return _export_sch_daily_interval_mins
        End Get
        Set(ByVal value As String)
            _export_sch_daily_interval_mins = value
        End Set
    End Property
    Public Property Export_Sch_Week_Day() As String
        Get
            Return _export_sch_week_day
        End Get
        Set(ByVal value As String)
            _export_sch_week_day = value
        End Set
    End Property
    Public Property Export_Sch_Month_Day() As String
        Get
            Return _export_sch_month_day
        End Get
        Set(ByVal value As String)
            _export_sch_month_day = value
        End Set
    End Property
    Public Property Export_Sch_Daily_STime() As String
        Get
            Return _export_sch_daily_stime
        End Get
        Set(ByVal value As String)
            _export_sch_daily_stime = value
        End Set
    End Property
    Public Property Export_Sch_Daily_ETime() As String
        Get
            Return _export_sch_daily_etime
        End Get
        Set(ByVal value As String)
            _export_sch_daily_etime = value
        End Set
    End Property
    Public Property Export_Sch_Week_Time() As String
        Get
            Return _export_sch_week_time
        End Get
        Set(ByVal value As String)
            _export_sch_week_time = value
        End Set
    End Property
    Public Property Export_Sch_Month_Time() As String
        Get
            Return _export_sch_month_time
        End Get
        Set(ByVal value As String)
            _export_sch_month_time = value
        End Set
    End Property
    Public Property Import_Template() As String
        Get
            Return _import_template
        End Get
        Set(ByVal value As String)
            _import_template = value
        End Set
    End Property
    Public Property Export_Template() As String
        Get
            Return _export_template
        End Get
        Set(ByVal value As String)
            _export_template = value
        End Set
    End Property
    Public Property Order_Imp_Sch_Id() As String
        Get
            Return _order_imp_sch_id
        End Get
        Set(ByVal value As String)
            _order_imp_sch_id = value
        End Set
    End Property
    Public Property Order_Exp_Sch_Id() As String
        Get
            Return _order_exp_sch_id
        End Get
        Set(ByVal value As String)
            _order_exp_sch_id = value
        End Set
    End Property
    Public Property Template_Id() As String
        Get
            Return _template_id
        End Get
        Set(ByVal value As String)
            _template_id = value
        End Set
    End Property
    Public Property Template_Name() As String
        Get
            Return _template_name
        End Get
        Set(ByVal value As String)
            _template_name = value
        End Set
    End Property

End Class
