Public Class RepPackCodeBO
    Private _id_rep_code As String
    Private _rp_repcode_des As String
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _langid As String
    Private _idRepairPkgCatg As String
    Private _idConfig As String
    Private _repairPkgDesc As String
    Private _retval_saved As String
    Private _retval_notsaved As String
    Private _idrepcode As String
    Private _isdefault As String
    Private _isdefaultvalue As String
    Private _rp_subrepcode_desc As String
    Private _idsubrepcode As String
    Private _ispkk As String
    Private _idchklistcode As String
    Private _idchklistdesc As String
    Private _idchklistcodeold As String
    Private _workcodedesc As String
    Private _idworkcode As String
    Public Property Created_By() As String
        Get
            Return _created_by
        End Get
        Set(ByVal Value As String)
            _created_by = Value
        End Set
    End Property
    Public Property CreatedDate() As String
        Get
            Return _dt_created
        End Get
        Set(ByVal Value As String)
            _dt_created = Value
        End Set
    End Property
    Public Property ModifiedDate() As String
        Get
            Return _dt_modified
        End Get
        Set(ByVal Value As String)
            _dt_modified = Value
        End Set
    End Property
    Public Property Id_Rep_Code() As String
        Get
            Return _id_rep_code
        End Get
        Set(ByVal Value As String)
            _id_rep_code = Value
        End Set
    End Property
    Public Property ModifiedBy() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal Value As String)
            _modified_by = Value
        End Set
    End Property
    Public Property RP_Repcode_Desc() As String
        Get
            Return _rp_repcode_des
        End Get
        Set(ByVal Value As String)
            _rp_repcode_des = Value
        End Set
    End Property
    Public Property LangId() As String
        Get
            Return _langid
        End Get
        Set(ByVal Value As String)
            _langid = Value
        End Set
    End Property
    Public Property IdRepairPkgCatg() As String
        Get
            Return _idRepairPkgCatg
        End Get
        Set(ByVal Value As String)
            _idRepairPkgCatg = Value
        End Set
    End Property
    Public Property IdConfig() As String
        Get
            Return _idConfig
        End Get
        Set(ByVal Value As String)
            _idConfig = Value
        End Set
    End Property
    Public Property RepairPkgDesc() As String
        Get
            Return _repairPkgDesc
        End Get
        Set(ByVal Value As String)
            _repairPkgDesc = Value
        End Set
    End Property
    Public Property RetVal_Saved() As String
        Get
            Return _retval_saved
        End Get
        Set(ByVal Value As String)
            _retval_saved = Value
        End Set
    End Property
    Public Property RetVal_NotSaved() As String
        Get
            Return _retval_notsaved
        End Get
        Set(ByVal Value As String)
            _retval_notsaved = Value
        End Set
    End Property
    Public Property IdRepCode() As String
        Get
            Return _id_rep_code
        End Get
        Set(ByVal Value As String)
            _id_rep_code = Value
        End Set
    End Property
    Public Property IsDefault() As String
        Get
            Return _isdefault
        End Get
        Set(ByVal Value As String)
            _isdefault = Value
        End Set
    End Property
    Public Property IsDefaultValue() As String
        Get
            Return _isdefaultvalue
        End Get
        Set(ByVal Value As String)
            _isdefaultvalue = Value
        End Set
    End Property
    Public Property Rp_SubRepCode_Desc() As String
        Get
            Return _rp_subrepcode_desc
        End Get
        Set(ByVal Value As String)
            _rp_subrepcode_desc = Value
        End Set
    End Property
    Public Property IdSubRepCode() As String
        Get
            Return _idsubrepcode
        End Get
        Set(ByVal Value As String)
            _idsubrepcode = Value
        End Set
    End Property
    Public Property IsPKK() As String
        Get
            Return _ispkk
        End Get
        Set(ByVal Value As String)
            _ispkk = Value
        End Set
    End Property
    Public Property IdChkListCode() As String
        Get
            Return _idchklistcode
        End Get
        Set(ByVal Value As String)
            _idchklistcode = Value
        End Set
    End Property
    Public Property IdChkListDesc() As String
        Get
            Return _idchklistdesc
        End Get
        Set(ByVal Value As String)
            _idchklistdesc = Value
        End Set
    End Property
    Public Property IdChkListCodeOld() As String
        Get
            Return _idchklistcodeold
        End Get
        Set(ByVal Value As String)
            _idchklistcodeold = Value
        End Set
    End Property
    Public Property WorkCodeDesc() As String
        Get
            Return _workcodedesc
        End Get
        Set(ByVal Value As String)
            _workcodedesc = Value
        End Set
    End Property
    Public Property IdWorkCode() As String
        Get
            Return _idworkcode
        End Get
        Set(ByVal Value As String)
            _idworkcode = Value
        End Set
    End Property


End Class
