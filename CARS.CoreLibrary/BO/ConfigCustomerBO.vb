Public Class ConfigCustomerBO
#Region "Variable"
    Private _cust_start As String
    Private _cust_end As String
    Private _created_by As String
    Private _strxml As String
    Private _user_id As String
    Private _id_cust_reg_cd As String
    Private _region As String
    Private _id_pay_term As String
    Private _terms As String
    Private _flg_freemonth As Boolean
    Private _pay_description As String
    Private _id_cust_warn As Integer
    Private _warn_text As String
    Private _id_cust_group As String
    Private _id_cust_pc_code As String
    Private _cust_pc As String
    Private _id_cust_pay_type As String
    Private _pay_type As String
    Private _id_cust_vat_cd As String
    Private _vat_code As String
    Private _vat_description As String
    Private _id_cust_disc_cd As String
    Private _discount_code As String
    Private _discount_description As String
    Private _id_settings As String
    Private _retValSaved As String
    Private _retValNtSaved As String
    Private _custGrpDesc As String
    Private _custAccCode As String
    Private _currency As String
    Private _useInternalCust As String
    Private _priceCodeDesc As String
    Private _dptName As String
    Private _grgPrPer As String
    Private _desc As String
    Private _gpAccCode As String
    Private _idDept As String
    Private _idCustGrpSeq As String
    Private _idRpCode As String
    Private _custName As String
    Private _flgPrice As String
    Private _price As String
    Private _idMapSeq As String
    Private _idCustomer As String
    Private _idRp As String
    Private _errMsg As String
    Private _succMsg As String


#End Region
#Region "Property"
    Public Property Cust_Start() As String
        Get
            Return _cust_start
        End Get
        Set(ByVal Value As String)
            _cust_start = Value
        End Set
    End Property
    Public Property Cust_End() As String
        Get
            Return _cust_end
        End Get
        Set(ByVal Value As String)
            _cust_end = Value
        End Set
    End Property
    Public Property UserId() As String
        Get
            Return _user_id
        End Get
        Set(ByVal Value As String)
            _user_id = Value
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
    Public Property Strxml() As String
        Get
            Return _strxml
        End Get
        Set(ByVal Value As String)
            _strxml = Value
        End Set
    End Property
    Public Property Id_Cust_Reg_Cd() As String
        Get
            Return _id_cust_reg_cd
        End Get
        Set(ByVal Value As String)
            _id_cust_reg_cd = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _id_settings
        End Get
        Set(ByVal Value As String)
            _id_settings = Value
        End Set
    End Property
    Public Property Region() As String
        Get
            Return _region
        End Get
        Set(ByVal Value As String)
            _region = Value
        End Set
    End Property
    Public Property Id_Cust_Pc_Code() As String
        Get
            Return _id_cust_pc_code
        End Get
        Set(ByVal Value As String)
            _id_cust_pc_code = Value
        End Set
    End Property
    Public Property Cust_Pc() As String
        Get
            Return _cust_pc
        End Get
        Set(ByVal Value As String)
            _cust_pc = Value
        End Set
    End Property
    Public Property Id_Pay_Term() As String
        Get
            Return _id_pay_term
        End Get
        Set(ByVal Value As String)
            _id_pay_term = Value
        End Set
    End Property
    Public Property Terms() As String
        Get
            Return _terms
        End Get
        Set(ByVal Value As String)
            _terms = Value
        End Set
    End Property
    Public Property Flg_Freemonth() As Boolean
        Get
            Return _flg_freemonth
        End Get
        Set(ByVal Value As Boolean)
            _flg_freemonth = Value
        End Set
    End Property
    Public Property Pay_Description() As String
        Get
            Return _pay_description
        End Get
        Set(ByVal Value As String)
            _pay_description = Value
        End Set
    End Property
    Public Property Id_Cust_Pay_Type() As String
        Get
            Return _id_cust_pay_type
        End Get
        Set(ByVal Value As String)
            _id_cust_pay_type = Value
        End Set
    End Property
    Public Property Pay_Type() As String
        Get
            Return _pay_type
        End Get
        Set(ByVal Value As String)
            _pay_type = Value
        End Set
    End Property
    Public Property Id_Cust_Warn() As String
        Get
            Return _id_cust_warn
        End Get
        Set(ByVal Value As String)
            _id_cust_warn = Value
        End Set
    End Property
    Public Property Warn_Text() As String
        Get
            Return _warn_text
        End Get
        Set(ByVal Value As String)
            _warn_text = Value
        End Set
    End Property
    Public Property Id_Cust_Vat_Cd() As String
        Get
            Return _id_cust_vat_cd
        End Get
        Set(ByVal Value As String)
            _id_cust_vat_cd = Value
        End Set
    End Property
    Public Property Vat_Code() As String
        Get
            Return _vat_code
        End Get
        Set(ByVal Value As String)
            _vat_code = Value
        End Set
    End Property
    Public Property Vat_Description() As String
        Get
            Return _vat_description
        End Get
        Set(ByVal Value As String)
            _vat_description = Value
        End Set
    End Property
    Public Property Id_Cust_Disc_Cd() As String
        Get
            Return _id_cust_disc_cd
        End Get
        Set(ByVal Value As String)
            _id_cust_disc_cd = Value
        End Set
    End Property
    Public Property Discount_Code() As String
        Get
            Return _discount_code
        End Get
        Set(ByVal Value As String)
            _discount_code = Value
        End Set
    End Property
    Public Property Discount_Description() As String
        Get
            Return _discount_description
        End Get
        Set(ByVal Value As String)
            _discount_description = Value
        End Set
    End Property
    Public Property Id_Cust_Group() As String
        Get
            Return _id_cust_group
        End Get
        Set(ByVal Value As String)
            _id_cust_group = Value
        End Set
    End Property
    Public Property RetVal_Saved() As String
        Get
            Return _retValSaved
        End Get
        Set(ByVal Value As String)
            _retValSaved = Value
        End Set
    End Property
    Public Property RetVal_NotSaved() As String
        Get
            Return _retValNtSaved
        End Get
        Set(ByVal Value As String)
            _retValNtSaved = Value
        End Set
    End Property
    Public Property Cust_GrpDesc() As String
        Get
            Return _custGrpDesc
        End Get
        Set(ByVal Value As String)
            _custGrpDesc = Value
        End Set
    End Property
    Public Property Cust_AccCode() As String
        Get
            Return _custAccCode
        End Get
        Set(ByVal Value As String)
            _custAccCode = Value
        End Set
    End Property
    Public Property Currency() As String
        Get
            Return _currency
        End Get
        Set(ByVal Value As String)
            _currency = Value
        End Set
    End Property
    Public Property UseIntCustomer() As String
        Get
            Return _useInternalCust
        End Get
        Set(ByVal Value As String)
            _useInternalCust = Value
        End Set
    End Property
    Public Property PriceCodeDesc() As String
        Get
            Return _priceCodeDesc
        End Get
        Set(ByVal Value As String)
            _priceCodeDesc = Value
        End Set
    End Property
    Public Property DeptName() As String
        Get
            Return _dptName
        End Get
        Set(ByVal Value As String)
            _dptName = Value
        End Set
    End Property
    Public Property Garg_Price_Per() As String
        Get
            Return _grgPrPer
        End Get
        Set(ByVal Value As String)
            _grgPrPer = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _desc
        End Get
        Set(ByVal Value As String)
            _desc = Value
        End Set
    End Property
    Public Property GP_AccCode() As String
        Get
            Return _gpAccCode
        End Get
        Set(ByVal Value As String)
            _gpAccCode = Value
        End Set
    End Property
    Public Property IdDept() As String
        Get
            Return _idDept
        End Get
        Set(ByVal Value As String)
            _idDept = Value
        End Set
    End Property
    Public Property Id_Cust_Group_Seq() As String
        Get
            Return _idCustGrpSeq
        End Get
        Set(ByVal Value As String)
            _idCustGrpSeq = Value
        End Set
    End Property
    Public Property Id_Rp_Code() As String
        Get
            Return _idRpCode
        End Get
        Set(ByVal Value As String)
            _idRpCode = Value
        End Set
    End Property
    Public Property Cust_Name() As String
        Get
            Return _custName
        End Get
        Set(ByVal Value As String)
            _custName = Value
        End Set
    End Property
    Public Property Flg_Price() As String
        Get
            Return _flgPrice
        End Get
        Set(ByVal Value As String)
            _flgPrice = Value
        End Set
    End Property
    Public Property Price() As String
        Get
            Return _price
        End Get
        Set(ByVal Value As String)
            _price = Value
        End Set
    End Property
    Public Property Id_Map_Seq() As String
        Get
            Return _idMapSeq
        End Get
        Set(ByVal Value As String)
            _idMapSeq = Value
        End Set
    End Property
    Public Property Id_Customer() As String
        Get
            Return _idCustomer
        End Get
        Set(ByVal Value As String)
            _idCustomer = Value
        End Set
    End Property
    Public Property Id_Rp() As String
        Get
            Return _idRp
        End Get
        Set(ByVal Value As String)
            _idRp = Value
        End Set
    End Property
    Public Property ErrMsg() As String
        Get
            Return _errMsg
        End Get
        Set(ByVal Value As String)
            _errMsg = Value
        End Set
    End Property
    Public Property SuccMsg() As String
        Get
            Return _succMsg
        End Get
        Set(ByVal Value As String)
            _succMsg = Value
        End Set
    End Property
#End Region
End Class
