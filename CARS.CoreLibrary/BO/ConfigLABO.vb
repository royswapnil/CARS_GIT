Public Class ConfigLABO
    Private _flg_grouping As String
    Private _flg_exportmode As String
    Private _flg_export_allowMulMonthsflg As String
    Private _flg_export_eachinvoice As String
    Private _path_export_invjournal As String
    Private _path_export_custinfo As String
    Private _path_import_custinfo As String
    Private _path_import_custbal As String
    Private _prefixfilename_export_invjournal As String
    Private _suffixfilename_export_invjournal As String
    Private _flg_export_invjournal_seqnos As String
    Private _prefixfilename_export_custinfo As String
    Private _suffixfilename_export_custinfo As String
    Private _flg_export_cust_seqnos As String
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _dt_eff_from As String
    Private _dt_eff_to As String
    Private _exp_invjournal_series As String
    Private _exp_invjournal_cur_series As String
    Private _exp_cust_series As String
    Private _exp_cust_cur_series As String
    Private _error_acc_code As String

    Private _sch_basis As String
    Private _sch_timeformat As String
    Private _sch_daily_interval_mins As String
    Private _sch_week_day As String
    Private _sch_month_day As String
    Private _sch_daily_stime As String
    Private _sch_daily_etime As String
    Private _sch_week_time As String
    Private _sch_month_time As String

    Private _customer_id As String
    Private _cust_ord_no As String
    Private _cust_reg_no As String
    Private _cust_vin_no As String
    Private _cust_vin_no_len As String
    Private _customer_name As String
    Private _cust_fixed_text As String
    Private _invoice_journal_temp As String
    Private _custinfo_temp As String
    Private _strtask_time As String

    Private _flg_export_useinvoicenum As String
    Private _flg_export_usecreditnote As String
    Private _flg_export_useblanksp As String
    Private _flg_export_usecomblines As String
    Private _flg_export_usesplit As String
    Private _flg_export_useadddate As String
    Private _flg_export_remcost As String
    Private _flg_export_useaddtext As String
    Private _flg_export_useadditionaltext As String
    Private _export_addtext As String
    Private _export_additionaltext As String
    Private _export_customertext As String
    Private _flg_export_usecustomertext As String
    Private _flg_export_vochertype As String
    Private _export_vochertype As String
    Private _flg_display_allinvnum As String
    Private _fp_acc_code As String
    Private _flg_export_valid As String
    Private _errinvoicesname As String
    Private _flg_use_bill_addr_exp As String
    Private _acc_cfg_seq As String
    Private _template_id As String
    Private _template_name As String
    Private _cust_series As String
    Private _cust_desc As String
    Public Property Flg_Grouping() As String
        Get
            Return _flg_grouping
        End Get
        Set(ByVal Value As String)
            _flg_grouping = Value
        End Set
    End Property
    Public Property Flg_ExportMode() As String
        Get
            Return _flg_exportmode
        End Get
        Set(ByVal Value As String)
            _flg_exportmode = Value
        End Set
    End Property
    Public Property Flg_Export_AllowMulMonths() As String
        Get
            Return _flg_export_allowMulMonthsflg
        End Get
        Set(ByVal Value As String)
            _flg_export_allowMulMonthsflg = Value
        End Set
    End Property
    Public Property Flg_Export_EachInvoice() As String
        Get
            Return _flg_export_eachinvoice
        End Get
        Set(ByVal Value As String)
            _flg_export_eachinvoice = Value
        End Set
    End Property
    Public Property Path_Export_InvJournal() As String
        Get
            Return _path_export_invjournal
        End Get
        Set(ByVal Value As String)
            _path_export_invjournal = Value
        End Set
    End Property
    Public Property Path_Export_CustInfo() As String
        Get
            Return _path_export_custinfo
        End Get
        Set(ByVal Value As String)
            _path_export_custinfo = Value
        End Set
    End Property
    Public Property Path_Import_CustInfo() As String
        Get
            Return _path_import_custinfo
        End Get
        Set(ByVal Value As String)
            _path_import_custinfo = Value
        End Set
    End Property
    Public Property Path_Import_CustBal() As String
        Get
            Return _path_import_custbal
        End Get
        Set(ByVal Value As String)
            _path_import_custbal = Value
        End Set
    End Property
    Public Property PrefixFileName_Export_InvJournal() As String
        Get
            Return _prefixfilename_export_invjournal
        End Get
        Set(ByVal Value As String)
            _prefixfilename_export_invjournal = Value
        End Set
    End Property
    Public Property SuffixFileName_Export_InvJournal() As String
        Get
            Return _suffixfilename_export_invjournal
        End Get
        Set(ByVal Value As String)
            _suffixfilename_export_invjournal = Value
        End Set
    End Property
    Public Property Flg_Export_InvJournal_SeqNos() As String
        Get
            Return _flg_export_invjournal_seqnos
        End Get
        Set(ByVal Value As String)
            _flg_export_invjournal_seqnos = Value
        End Set
    End Property
    Public Property PrefixFileName_Export_CustInfo() As String
        Get
            Return _prefixfilename_export_custinfo
        End Get
        Set(ByVal Value As String)
            _prefixfilename_export_custinfo = Value
        End Set
    End Property
    Public Property SuffixFileName_Export_CustInfo() As String
        Get
            Return _suffixfilename_export_custinfo
        End Get
        Set(ByVal Value As String)
            _suffixfilename_export_custinfo = Value
        End Set
    End Property
    Public Property Flg_Export_Cust_SeqNos() As String
        Get
            Return _flg_export_cust_seqnos
        End Get
        Set(ByVal Value As String)
            _flg_export_cust_seqnos = Value
        End Set
    End Property
    Public Property Created_By() As String
        Get
            Return _created_by
        End Get
        Set(ByVal Value As String)
            _created_by = Value
        End Set
    End Property
    Public Property Dt_Created() As String
        Get
            Return _dt_created
        End Get
        Set(ByVal Value As String)
            _dt_created = Value
        End Set
    End Property
    Public Property Modified_By() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal Value As String)
            _modified_by = Value
        End Set
    End Property
    Public Property Dt_Modified() As String
        Get
            Return _dt_modified
        End Get
        Set(ByVal Value As String)
            _dt_modified = Value
        End Set
    End Property
    Public Property Dt_Eff_From() As String
        Get
            Return _dt_eff_from
        End Get
        Set(ByVal Value As String)
            _dt_eff_from = Value
        End Set
    End Property
    Public Property Dt_Eff_To() As String
        Get
            Return _dt_eff_to
        End Get
        Set(ByVal Value As String)
            _dt_eff_to = Value
        End Set
    End Property
    Public Property Exp_InvJournal_Series() As String
        Get
            Return _exp_invjournal_series
        End Get
        Set(ByVal Value As String)
            _exp_invjournal_series = Value
        End Set
    End Property
    Public Property Exp_InvJournal_Cur_Series() As String
        Get
            Return _exp_invjournal_cur_series
        End Get
        Set(ByVal Value As String)
            _exp_invjournal_cur_series = Value
        End Set
    End Property
    Public Property Exp_Cust_Series() As String
        Get
            Return _exp_cust_series
        End Get
        Set(ByVal Value As String)
            _exp_cust_series = Value
        End Set
    End Property
    Public Property Exp_Cust_Cur_Series() As String
        Get
            Return _exp_cust_cur_series
        End Get
        Set(ByVal Value As String)
            _exp_cust_cur_series = Value
        End Set
    End Property
    Public Property Error_Acc_Code() As String
        Get
            Return _error_acc_code
        End Get
        Set(ByVal Value As String)
            _error_acc_code = Value
        End Set
    End Property
    Public Property Sch_Basis() As String
        Get
            Return _sch_basis
        End Get
        Set(ByVal Value As String)
            _sch_basis = Value
        End Set
    End Property
    Public Property Sch_TimeFormat() As String
        Get
            Return _sch_timeformat
        End Get
        Set(ByVal Value As String)
            _sch_timeformat = Value
        End Set
    End Property
    Public Property Sch_Daily_Interval_mins() As String
        Get
            Return _sch_daily_interval_mins
        End Get
        Set(ByVal Value As String)
            _sch_daily_interval_mins = Value
        End Set
    End Property
    Public Property Sch_Week_Day() As String
        Get
            Return _sch_week_day
        End Get
        Set(ByVal Value As String)
            _sch_week_day = Value
        End Set
    End Property
    Public Property Sch_Month_Day() As String
        Get
            Return _sch_month_day
        End Get
        Set(ByVal Value As String)
            _sch_month_day = Value
        End Set
    End Property
    Public Property Sch_Daily_STime() As String
        Get
            Return _sch_daily_stime
        End Get
        Set(ByVal Value As String)
            _sch_daily_stime = Value
        End Set
    End Property
    Public Property Sch_Daily_ETime() As String
        Get
            Return _sch_daily_etime
        End Get
        Set(ByVal Value As String)
            _sch_daily_etime = Value
        End Set
    End Property
    Public Property Sch_Week_Time() As String
        Get
            Return _sch_week_time
        End Get
        Set(ByVal Value As String)
            _sch_week_time = Value
        End Set
    End Property
    Public Property Sch_Month_Time() As String
        Get
            Return _sch_month_time
        End Get
        Set(ByVal Value As String)
            _sch_month_time = Value
        End Set
    End Property
    Public Property Customer_ID() As String
        Get
            Return _customer_id
        End Get
        Set(ByVal Value As String)
            _customer_id = Value
        End Set
    End Property
    Public Property Cust_Ord_No() As String
        Get
            Return _cust_ord_no
        End Get
        Set(ByVal Value As String)
            _cust_ord_no = Value
        End Set
    End Property
    Public Property Cust_Reg_No() As String
        Get
            Return _cust_reg_no
        End Get
        Set(ByVal Value As String)
            _cust_reg_no = Value
        End Set
    End Property
    Public Property Cust_Vin_No() As String
        Get
            Return _cust_vin_no
        End Get
        Set(ByVal Value As String)
            _cust_vin_no = Value
        End Set
    End Property
    Public Property Cust_Vin_No_Len() As String
        Get
            Return _cust_vin_no_len
        End Get
        Set(ByVal Value As String)
            _cust_vin_no_len = Value
        End Set
    End Property
    Public Property Customer_Name() As String
        Get
            Return _customer_name
        End Get
        Set(ByVal Value As String)
            _customer_name = Value
        End Set
    End Property
    Public Property Cust_Fixed_Text() As String
        Get
            Return _cust_fixed_text
        End Get
        Set(ByVal Value As String)
            _cust_fixed_text = Value
        End Set
    End Property
    Public Property Invoice_Journal_Temp() As String
        Get
            Return _invoice_journal_temp
        End Get
        Set(ByVal Value As String)
            _invoice_journal_temp = Value
        End Set
    End Property
    Public Property CustInfo_Temp() As String
        Get
            Return _custinfo_temp
        End Get
        Set(ByVal Value As String)
            _custinfo_temp = Value
        End Set
    End Property
    Public Property StrTask_Time() As String
        Get
            Return _strtask_time
        End Get
        Set(ByVal Value As String)
            _strtask_time = Value
        End Set
    End Property
    Public Property Flg_Export_UseInvoiceNum() As String
        Get
            Return _flg_export_useinvoicenum
        End Get
        Set(ByVal Value As String)
            _flg_export_useinvoicenum = Value
        End Set
    End Property
    Public Property Flg_Export_UseCreditnote() As String
        Get
            Return _flg_export_usecreditnote
        End Get
        Set(ByVal Value As String)
            _flg_export_usecreditnote = Value
        End Set
    End Property
    Public Property Flg_Export_UseBlankSp() As String
        Get
            Return _flg_export_useblanksp
        End Get
        Set(ByVal Value As String)
            _flg_export_useblanksp = Value
        End Set
    End Property
    Public Property Flg_Export_UseCombLines() As String
        Get
            Return _flg_export_usecomblines
        End Get
        Set(ByVal Value As String)
            _flg_export_usecomblines = Value
        End Set
    End Property
    Public Property Flg_Export_UseSplit() As String
        Get
            Return _flg_export_usesplit
        End Get
        Set(ByVal Value As String)
            _flg_export_usesplit = Value
        End Set
    End Property
    Public Property Flg_Export_UseAddDate() As String
        Get
            Return _flg_export_useadddate
        End Get
        Set(ByVal Value As String)
            _flg_export_useadddate = Value
        End Set
    End Property
    Public Property Flg_Export_RemCost() As String
        Get
            Return _flg_export_remcost
        End Get
        Set(ByVal Value As String)
            _flg_export_remcost = Value
        End Set
    End Property
    Public Property Flg_Export_UseAddText() As String
        Get
            Return _flg_export_useaddtext
        End Get
        Set(ByVal Value As String)
            _flg_export_useaddtext = Value
        End Set
    End Property
    Public Property Flg_Export_UseAdditionalText() As String
        Get
            Return _flg_export_useadditionaltext
        End Get
        Set(ByVal Value As String)
            _flg_export_useadditionaltext = Value
        End Set
    End Property
    Public Property Export_AddText() As String
        Get
            Return _export_addtext
        End Get
        Set(ByVal Value As String)
            _export_addtext = Value
        End Set
    End Property
    Public Property Export_AdditionalText() As String
        Get
            Return _export_additionaltext
        End Get
        Set(ByVal Value As String)
            _export_additionaltext = Value
        End Set
    End Property
    Public Property Export_CustomerText() As String
        Get
            Return _export_customertext
        End Get
        Set(ByVal Value As String)
            _export_customertext = Value
        End Set
    End Property
    Public Property Flg_Export_UseCustomerText() As String
        Get
            Return _flg_export_usecustomertext
        End Get
        Set(ByVal Value As String)
            _flg_export_usecustomertext = Value
        End Set
    End Property
    Public Property Flg_Export_VocherType() As String
        Get
            Return _flg_export_vochertype
        End Get
        Set(ByVal Value As String)
            _flg_export_vochertype = Value
        End Set
    End Property
    Public Property Export_VocherType() As String
        Get
            Return _export_vochertype
        End Get
        Set(ByVal Value As String)
            _export_vochertype = Value
        End Set
    End Property
    Public Property Flg_Display_AllInvNum() As String
        Get
            Return _flg_display_allinvnum
        End Get
        Set(ByVal Value As String)
            _flg_display_allinvnum = Value
        End Set
    End Property
    Public Property FP_Acc_Code() As String
        Get
            Return _fp_acc_code
        End Get
        Set(ByVal Value As String)
            _fp_acc_code = Value
        End Set
    End Property
    Public Property Flg_Export_Valid() As String
        Get
            Return _flg_export_valid
        End Get
        Set(ByVal Value As String)
            _flg_export_valid = Value
        End Set
    End Property
    Public Property ErrInvoicesName() As String
        Get
            Return _errinvoicesname
        End Get
        Set(ByVal Value As String)
            _errinvoicesname = Value
        End Set
    End Property
    Public Property Flg_Use_Bill_Addr_Exp() As String
        Get
            Return _flg_use_bill_addr_exp
        End Get
        Set(ByVal Value As String)
            _flg_use_bill_addr_exp = Value
        End Set
    End Property
    Public Property Acc_Cfg_Seq() As String
        Get
            Return _acc_cfg_seq
        End Get
        Set(ByVal Value As String)
            _acc_cfg_seq = Value
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
    Public Property Cust_Series() As String
        Get
            Return _cust_series
        End Get
        Set(ByVal Value As String)
            _cust_series = Value
        End Set
    End Property
    Public Property Cust_Desc() As String
        Get
            Return _cust_desc
        End Get
        Set(ByVal Value As String)
            _cust_desc = Value
        End Set
    End Property


End Class
