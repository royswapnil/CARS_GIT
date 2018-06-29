Public Class AccountConfigSchedulerBO

    Private _intschedule_id As String
    Private _strbalance_filelocation As String
    Private _strbalance_filename As String
    Private _intbalance_archivedays As String
    Private _cbalance_sch_basis As String
    Private _cbalance_timeformat As String
    Private _intbalance_sch_daily_interval_mins As String
    Private _intbalance_sch_week_day As String
    Private _intbalance_sch_month_day As String
    Private _strbalance_sch_daily_stime As String
    Private _strbalance_sch_daily_etime As String
    Private _strbalance_sch_week_time As String
    Private _strbalance_sch_month_time As String
    Private _strcustomer_filelocation As String
    Private _strcustomer_filename As String
    Private _ccustomer_sch_basis As String
    Private _ccustomer_timeformat As String
    Private _intcustomer_sch_daily_interval_mins As String
    Private _intcustomer_sch_week_day As String
    Private _intcustomer_sch_month_day As String
    Private _strcustomer_sch_daily_stime As String
    Private _strcustomer_sch_daily_etime As String
    Private _strcustomer_sch_week_time As String
    Private _strcustomer_sch_month_time As String
    Private _strcreated_by As String
    Private _strfile_type As String
    Private _strbalance_file_name As String
    Private _strcustomer_file_name As String
    Private _strbalance_template As String
    Private _strcustomer_template As String
    Private _strtask_time As String
    Private _template_id As String
    Private _template_name As String

#Region "Properties"
    Public Property Task_Time() As String
        Get
            Return _strtask_time
        End Get
        Set(ByVal value As String)
            _strtask_time = value
        End Set
    End Property
    Public Property Schedule_Id() As String
        Get
            Return _intschedule_id
        End Get
        Set(ByVal value As String)
            _intschedule_id = value
        End Set
    End Property
    Public Property Balance_FileLocation() As String
        Get
            Return _strbalance_filelocation
        End Get
        Set(ByVal value As String)
            _strbalance_filelocation = value
        End Set
    End Property
    Public Property Balance_FileName() As String
        Get
            Return _strbalance_filename
        End Get
        Set(ByVal value As String)
            _strbalance_filename = value
        End Set
    End Property
    Public Property Balance_ArchiveDays() As String
        Get
            Return _intbalance_archivedays
        End Get
        Set(ByVal value As String)
            _intbalance_archivedays = value
        End Set
    End Property
    Public Property Balance_Sch_Basis() As String
        Get
            Return _cbalance_sch_basis
        End Get
        Set(ByVal value As String)
            _cbalance_sch_basis = value
        End Set
    End Property
    Public Property Balance_Sch_TimeFormat() As String
        Get
            Return _cbalance_timeformat
        End Get
        Set(ByVal value As String)
            _cbalance_timeformat = value
        End Set
    End Property
    Public Property Balance_Sch_Daily_Interval_mins() As String
        Get
            Return _intbalance_sch_daily_interval_mins
        End Get
        Set(ByVal value As String)
            _intbalance_sch_daily_interval_mins = value
        End Set
    End Property
    Public Property Balance_Sch_Week_Day() As String
        Get
            Return _intbalance_sch_week_day
        End Get
        Set(ByVal value As String)
            _intbalance_sch_week_day = value
        End Set
    End Property
    Public Property Balance_Sch_Month_Day() As String
        Get
            Return _intbalance_sch_month_day
        End Get
        Set(ByVal value As String)
            _intbalance_sch_month_day = value
        End Set
    End Property
    Public Property Balance_Sch_Daily_STime() As String
        Get
            Return _strbalance_sch_daily_stime
        End Get
        Set(ByVal value As String)
            _strbalance_sch_daily_stime = value
        End Set
    End Property
    Public Property Balance_Sch_Daily_ETime() As String
        Get
            Return _strbalance_sch_daily_etime
        End Get
        Set(ByVal value As String)
            _strbalance_sch_daily_etime = value
        End Set
    End Property
    Public Property Balance_Sch_Week_Time() As String
        Get
            Return _strbalance_sch_week_time
        End Get
        Set(ByVal value As String)
            _strbalance_sch_week_time = value
        End Set
    End Property
    Public Property Balance_Sch_Month_Time() As String
        Get
            Return _strbalance_sch_month_time
        End Get
        Set(ByVal value As String)
            _strbalance_sch_month_time = value
        End Set
    End Property
    Public Property Customer_FileLocation() As String
        Get
            Return _strcustomer_filelocation
        End Get
        Set(ByVal value As String)
            _strcustomer_filelocation = value
        End Set
    End Property
    Public Property Customer_FileName() As String
        Get
            Return _strcustomer_filename
        End Get
        Set(ByVal value As String)
            _strcustomer_filename = value
        End Set
    End Property
    Public Property Customer_Sch_Basis() As String
        Get
            Return _ccustomer_sch_basis
        End Get
        Set(ByVal value As String)
            _ccustomer_sch_basis = value
        End Set
    End Property
    Public Property Customer_Sch_TimeFormat() As String
        Get
            Return _ccustomer_timeformat
        End Get
        Set(ByVal value As String)
            _ccustomer_timeformat = value
        End Set
    End Property
    Public Property Customer_Sch_Daily_Interval_mins() As String
        Get
            Return _intcustomer_sch_daily_interval_mins
        End Get
        Set(ByVal value As String)
            _intcustomer_sch_daily_interval_mins = value
        End Set
    End Property
    Public Property Customer_Sch_Week_Day() As String
        Get
            Return _intcustomer_sch_week_day
        End Get
        Set(ByVal value As String)
            _intcustomer_sch_week_day = value
        End Set
    End Property
    Public Property Customer_Sch_Month_Day() As String
        Get
            Return _intcustomer_sch_month_day
        End Get
        Set(ByVal value As String)
            _intcustomer_sch_month_day = value
        End Set
    End Property
    Public Property Customer_Sch_Daily_STime() As String
        Get
            Return _strcustomer_sch_daily_stime
        End Get
        Set(ByVal value As String)
            _strcustomer_sch_daily_stime = value
        End Set
    End Property
    Public Property Customer_Sch_Daily_ETime() As String
        Get
            Return _strcustomer_sch_daily_etime
        End Get
        Set(ByVal value As String)
            _strcustomer_sch_daily_etime = value
        End Set
    End Property
    Public Property Customer_Sch_Week_Time() As String
        Get
            Return _strcustomer_sch_week_time
        End Get
        Set(ByVal value As String)
            _strcustomer_sch_week_time = value
        End Set
    End Property
    Public Property Customer_Sch_Month_Time() As String
        Get
            Return _strcustomer_sch_month_time
        End Get
        Set(ByVal value As String)
            _strcustomer_sch_month_time = value
        End Set
    End Property
    Public Property Created_By() As String
        Get
            Return _strcreated_by
        End Get
        Set(ByVal value As String)
            _strcreated_by = value
        End Set
    End Property
    Public Property File_Type() As String
        Get
            Return _strfile_type
        End Get
        Set(ByVal value As String)
            _strfile_type = value
        End Set
    End Property
    Public Property Balance_File_Name() As String
        Get
            Return _strbalance_file_name
        End Get
        Set(ByVal value As String)
            _strbalance_file_name = value
        End Set
    End Property
    Public Property Customer_File_Name() As String
        Get
            Return _strcustomer_file_name
        End Get
        Set(ByVal value As String)
            _strcustomer_file_name = value
        End Set
    End Property
    Public Property Balance_Template() As String
        Get
            Return _strbalance_template
        End Get
        Set(ByVal value As String)
            _strbalance_template = value
        End Set
    End Property
    Public Property Customer_Template() As String
        Get
            Return _strcustomer_template
        End Get
        Set(ByVal value As String)
            _strcustomer_template = value
        End Set
    End Property

    Public Property Template_Id() As String
        Get
            Return _template_id
        End Get
        Set(ByVal Value As String)
            _template_id = Value
        End Set
    End Property
    Public Property Template_Name() As String
        Get
            Return _template_name
        End Get
        Set(ByVal Value As String)
            _template_name = Value
        End Set
    End Property
#End Region


End Class
