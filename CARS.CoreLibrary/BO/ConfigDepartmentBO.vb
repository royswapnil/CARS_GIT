Public Class ConfigDepartmentBO
#Region "Variable "

    Private _idDept As String
    Private _deptName As String
    Private _subsidiaryID As String
    Private _deptMgr As String
    Private _location As String
    Private _mobile As String
    Private _phone As String
    Private _fLgWareHouse As String
    Private _fLgAccValReq As Boolean
    Private _createdBy As String
    Private _modifiedBy As String
    Private _dtSubsideryId As String
    Private _dtCreated As String
    Private _dtModified As String
    Private _loginId As String
    Private _zipcode As String
    Private _address1 As String
    Private _address2 As String
    Private _deptAccountCode As String
    Private _discountCode As String
    Private _itemCatg As String
    Private _idMake As String
    Private _idItemCatg As String
    Private _ownRiskAcctCode As String
    Private _blDeptWorkOrder As Boolean
    Private _fLGExportSupplier As Boolean
    Private _flgLunchWithdraw As Boolean
    Private _fromTime As String
    Private _toTime As String
    Private _flgIntCustExp As Boolean
    Private _tempCode As String
    Private _idTempCode As String
    Private _makeFrom As String
    Private _makeTo As String
    Private _filter As String
    Private _idConfig As String
    Private _idConfig2 As String
    Private _idConfig3 As String
    Private _idConfig4 As String
    Private _idConfig5 As String
    Private _rpIdItemCatg As String
    Private _rpIdMake As String
    Private _idMakeName As String
    Private _subName As String
    Private _city As String
    Private _country As String
    Private _state As String
    Private _dpt_scanflg As String
    Private _dpt_sch_importflag As String

#End Region
    Public Property DeptAccountCode() As String
        Get
            Return _deptAccountCode
        End Get
        Set(ByVal Value As String)
            _deptAccountCode = Value
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
    Public Property LoginId() As String
        Get
            Return _loginId
        End Get
        Set(ByVal Value As String)
            _loginId = Value
        End Set
    End Property
    Public Property CreatedBy() As String
        Get
            Return _createdBy
        End Get
        Set(ByVal Value As String)
            _createdBy = Value
        End Set
    End Property
    Public Property DateCreated() As String
        Get
            Return _dtCreated
        End Get
        Set(ByVal Value As String)
            _dtCreated = Value
        End Set
    End Property
    Public Property DtSubsideryId As String
        Get
            Return _dtSubsideryId
        End Get
        Set(ByVal Value As String)
            _dtSubsideryId = Value
        End Set
    End Property
    Public Property DateModified() As String
        Get
            Return _dtModified
        End Get
        Set(ByVal Value As String)
            _dtModified = Value
        End Set
    End Property
    Public Property FlgWareHouse() As String
        Get
            Return _fLgWareHouse
        End Get
        Set(ByVal Value As String)
            _fLgWareHouse = Value
        End Set
    End Property
    Public Property FlgAccValReq() As Boolean
        Get
            Return _fLgAccValReq
        End Get
        Set(ByVal Value As Boolean)
            _fLgWareHouse = Value
        End Set
    End Property
    Public Property SubsideryId() As String
        Get
            Return _subsidiaryID
        End Get
        Set(ByVal Value As String)
            _subsidiaryID = Value
        End Set
    End Property
    Public Property DeptId() As String
        Get
            Return _idDept
        End Get
        Set(ByVal Value As String)
            _idDept = Value
        End Set
    End Property
    Public Property Location() As String
        Get
            Return _location
        End Get
        Set(ByVal Value As String)
            _location = Value
        End Set
    End Property
    Public Property DeptManager() As String
        Get
            Return _deptMgr
        End Get
        Set(ByVal Value As String)
            _deptMgr = Value
        End Set
    End Property
    Public Property ModifiedBy() As String
        Get
            Return _modifiedBy
        End Get
        Set(ByVal Value As String)
            _modifiedBy = Value
        End Set
    End Property
    Public Property Phone() As String
        Get
            Return _phone
        End Get
        Set(ByVal Value As String)
            _phone = Value
        End Set
    End Property
    Public Property Mobile() As String
        Get
            Return _mobile
        End Get
        Set(ByVal Value As String)
            _mobile = Value
        End Set
    End Property
    Public Property ZipCode() As String
        Get
            Return _zipcode
        End Get
        Set(ByVal Value As String)
            _zipcode = Value
        End Set
    End Property
    Public Property Address1 As String
        Get
            Return _address1
        End Get
        Set(ByVal Value As String)
            _address1 = Value
        End Set
    End Property
    Public Property Address2 As String
        Get
            Return _address2
        End Get
        Set(ByVal Value As String)
            _address2 = Value
        End Set
    End Property
    Public Property DiscountCode() As String
        Get
            Return _discountCode
        End Get
        Set(ByVal Value As String)
            _discountCode = Value
        End Set
    End Property
    Public Property ItemCatg() As String
        Get
            Return _itemCatg
        End Get
        Set(ByVal Value As String)
            _itemCatg = Value
        End Set
    End Property
    Public Property IdMake() As String
        Get
            Return _idMake
        End Get
        Set(ByVal Value As String)
            _idMake = Value
        End Set
    End Property
    Public Property IdItemCatg() As String
        Get
            Return _idItemCatg
        End Get
        Set(ByVal Value As String)
            _idItemCatg = Value
        End Set
    End Property
    Public Property FlgExportSupplier() As Boolean
        Get
            Return _fLGExportSupplier
        End Get
        Set(ByVal Value As Boolean)
            _fLGExportSupplier = Value
        End Set
    End Property
    Public Property OwnRiskAcctCode() As String
        Get
            Return _ownRiskAcctCode
        End Get
        Set(ByVal Value As String)
            _ownRiskAcctCode = Value
        End Set
    End Property
    Public Property FlgLunchWithdraw() As Boolean
        Get
            Return _flgLunchWithdraw
        End Get
        Set(ByVal value As Boolean)
            _flgLunchWithdraw = value
        End Set
    End Property
    Public Property FromTime() As String
        Get
            Return _fromTime
        End Get
        Set(ByVal value As String)
            _fromTime = value
        End Set
    End Property
    Public Property ToTime() As String
        Get
            Return _toTime
        End Get
        Set(ByVal value As String)
            _toTime = value
        End Set
    End Property
    Public Property FlgIntCustExp() As Boolean
        Get
            Return _flgIntCustExp
        End Get
        Set(ByVal value As Boolean)
            _flgIntCustExp = value
        End Set
    End Property
    Public Property TempCode() As String
        Get
            Return _tempCode
        End Get
        Set(ByVal Value As String)
            _tempCode = Value
        End Set
    End Property
    Public Property MakeFrom() As String
        Get
            Return _makeFrom
        End Get
        Set(ByVal Value As String)
            _makeFrom = Value
        End Set
    End Property
    Public Property MakeTo() As String
        Get
            Return _makeTo
        End Get
        Set(ByVal Value As String)
            _makeTo = Value
        End Set
    End Property
    Public Property Filter() As String
        Get
            Return _filter
        End Get
        Set(ByVal value As String)
            _filter = value
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
    Public Property IdConfig2() As String
        Get
            Return _idConfig2
        End Get
        Set(ByVal Value As String)
            _idConfig2 = Value
        End Set
    End Property
    Public Property IdConfig3() As String
        Get
            Return _idConfig3
        End Get
        Set(ByVal Value As String)
            _idConfig3 = Value
        End Set
    End Property
    Public Property IdConfig4() As String
        Get
            Return _idConfig4
        End Get
        Set(ByVal Value As String)
            _idConfig4 = Value
        End Set
    End Property
    Public Property IdConfig5() As String
        Get
            Return _idConfig5
        End Get
        Set(ByVal Value As String)
            _idConfig5 = Value
        End Set
    End Property
    Public Property RPIdMake() As String
        Get
            Return _rpIdMake
        End Get
        Set(ByVal Value As String)
            _rpIdMake = Value
        End Set
    End Property
    Public Property RPIdItemCatg() As String
        Get
            Return _rpIdItemCatg
        End Get
        Set(ByVal Value As String)
            _rpIdItemCatg = Value
        End Set
    End Property
    Public Property IdMakeName() As String
        Get
            Return _idMakeName
        End Get
        Set(ByVal Value As String)
            _idMakeName = Value
        End Set
    End Property
    Public Property IdTempCode() As String
        Get
            Return _idTempCode
        End Get
        Set(ByVal Value As String)
            _idTempCode = Value
        End Set
    End Property
    Public Property SubsidiaryName() As String
        Get
            Return _subName
        End Get
        Set(ByVal Value As String)
            _subName = Value
        End Set
    End Property
    Public Property City() As String
        Get
            Return _city
        End Get
        Set(ByVal value As String)
            _city = value
        End Set
    End Property
    Public Property Country() As String
        Get
            Return _country
        End Get
        Set(ByVal value As String)
            _country = value
        End Set
    End Property
    Public Property State() As String
        Get
            Return _state
        End Get
        Set(ByVal value As String)
            _state = value
        End Set
    End Property
    Public Property Dpt_ScanFlg() As String
        Get
            Return _dpt_scanflg
        End Get
        Set(ByVal value As String)
            _dpt_scanflg = value
        End Set
    End Property
    Public Property Dpt_Sch_ImportFlag() As String
        Get
            Return _dpt_sch_importflag
        End Get
        Set(ByVal value As String)
            _dpt_sch_importflag = value
        End Set
    End Property

End Class
