Public Class ConfigVehicleBO
#Region "Variable"
    Private _makeCode As String
    Private _description As String
    Private _priceCode As String
    Private _discountCode As String
    Private _vatCode As String
    Private _id_makeCode As String
    Private _idSettings As String
    Private _idMdlGrp As String
    Private _idVehGrp As String
    Private _idVgPCode As String
    Private _vhIntervalName As String
    Private _vhDesc As String
    Private _retValSaved As String
    Private _retValNtSaved As String
#End Region
#Region "Property"
    Public Property Make_Code() As String
        Get
            Return _makeCode
        End Get
        Set(ByVal Value As String)
            _makeCode = Value
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
    Public Property Price_Code() As String
        Get
            Return _priceCode
        End Get
        Set(ByVal Value As String)
            _priceCode = Value
        End Set
    End Property
    Public Property Discount_Code() As String
        Get
            Return _discountCode
        End Get
        Set(ByVal Value As String)
            _discountCode = Value
        End Set
    End Property
    Public Property Vat_Code() As String
        Get
            Return _vatCode
        End Get
        Set(ByVal Value As String)
            _vatCode = Value
        End Set
    End Property
    Public Property Id_Make_Code() As String
        Get
            Return _id_makeCode
        End Get
        Set(ByVal Value As String)
            _id_makeCode = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _idSettings
        End Get
        Set(ByVal Value As String)
            _idSettings = Value
        End Set
    End Property
    Public Property Model_Group() As String
        Get
            Return _idMdlGrp
        End Get
        Set(ByVal Value As String)
            _idMdlGrp = Value
        End Set
    End Property
    Public Property Id_Veh_Grp() As String
        Get
            Return _idVehGrp
        End Get
        Set(ByVal Value As String)
            _idVehGrp = Value
        End Set
    End Property
    Public Property Id_Vg_PCode() As String
        Get
            Return _idVgPCode
        End Get
        Set(ByVal Value As String)
            _idVgPCode = Value
        End Set
    End Property
    Public Property Vh_IntervalName() As String
        Get
            Return _vhIntervalName
        End Get
        Set(ByVal Value As String)
            _vhIntervalName = Value
        End Set
    End Property
    Public Property Veh_Description() As String
        Get
            Return _vhDesc
        End Get
        Set(ByVal Value As String)
            _vhDesc = Value
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


#End Region
End Class
