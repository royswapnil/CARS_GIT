Public Class ConfigInvoiceBO
#Region "Variables"
    Private _invprefix As String
    Private _crePrefix As String
    Private _invPaySeries As String
    Private _idConfig As String
    Private _idSett As String
    Private _description As String
    Private _idDept As String
    Private _idSub As String
    Private _invTimeRnd As String
    Private _invTimeRndPer As Decimal
    Private _invRndDec As Decimal
    Private _invPrRndValPer As Decimal
    Private _extVatCode As String
    Private _accCode As String
    Private _invTimeRndUnit As String
    Private _invTimeRndFn As String
    Private _invPriceRndFn As String
    Private _kidCustOrd As String
    Private _kidInvOrd As String
    Private _kidWoOrd As String
    Private _kidFixedOrd As String
    Private _kidCustNod As String
    Private _kidInvNod As String
    Private _kidWoNod As String
    Private _kidFixedNumber As String
    Private _flgKidMod10 As Boolean
    Private _flgInvFees As Boolean
    Private _invFeesAmt As Decimal
    Private _invFeesAccCode As String
    Private _idNumSeries As String
    Private _invNoSeries As String
    Private _creNoSeries As String
    Private _kidFixedNod As String
    Private _xmlVal As String
    Private _userId As String
#End Region
#Region "Property"
    Public Property Inv_Prefix() As String
        Get
            Return _invprefix
        End Get
        Set(ByVal Value As String)
            _invprefix = Value
        End Set
    End Property
    Public Property Cre_Prefix() As String
        Get
            Return _crePrefix
        End Get
        Set(ByVal Value As String)
            _crePrefix = Value
        End Set
    End Property
    Public Property IdNumSeries() As String
        Get
            Return _idNumSeries
        End Get
        Set(ByVal Value As String)
            _idNumSeries = Value
        End Set
    End Property
    Public Property InvNoSeries() As String
        Get
            Return _invNoSeries
        End Get
        Set(ByVal Value As String)
            _invNoSeries = Value
        End Set
    End Property
    Public Property CreNoSeries() As String
        Get
            Return _creNoSeries
        End Get
        Set(ByVal Value As String)
            _creNoSeries = Value
        End Set
    End Property
    Public Property Inv_PaySeries() As String
        Get
            Return _invPaySeries
        End Get
        Set(ByVal Value As String)
            _invPaySeries = Value
        End Set
    End Property
    Public Property Id_Config() As String
        Get
            Return _idConfig
        End Get
        Set(ByVal Value As String)
            _idConfig = Value
        End Set
    End Property
    Public Property Id_Settings() As String
        Get
            Return _idSett
        End Get
        Set(ByVal Value As String)
            _idSett = Value
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
    Public Property IdDept() As String
        Get
            Return _idDept
        End Get
        Set(ByVal Value As String)
            _idDept = Value
        End Set
    End Property
    Public Property IdSubsidery() As String
        Get
            Return _idSub
        End Get
        Set(ByVal Value As String)
            _idSub = Value
        End Set
    End Property
    Public Property InvTimeRnd() As String
        Get
            Return _invTimeRnd
        End Get
        Set(ByVal Value As String)
            _invTimeRnd = Value
        End Set
    End Property
    Public Property InvTimeRndPer() As Decimal
        Get
            Return _invTimeRndPer
        End Get
        Set(ByVal Value As Decimal)
            _invTimeRndPer = Value
        End Set
    End Property
    Public Property InvPrRndValPer() As Decimal
        Get
            Return _invPrRndValPer
        End Get
        Set(ByVal Value As Decimal)
            _invPrRndValPer = Value
        End Set
    End Property
    Public Property ExtVatCode() As String
        Get
            Return _extVatCode
        End Get
        Set(ByVal Value As String)
            _extVatCode = Value
        End Set
    End Property
    Public Property AccountCode() As String
        Get
            Return _accCode
        End Get
        Set(ByVal Value As String)
            _accCode = Value
        End Set
    End Property
    Public Property InvTimeRndUnit As String
        Get
            Return _invTimeRndUnit
        End Get
        Set(ByVal Value As String)
            _invTimeRndUnit = Value
        End Set
    End Property
    Public Property InvTimeRndFn As String
        Get
            Return _invTimeRndFn
        End Get
        Set(ByVal Value As String)
            _invTimeRndFn = Value
        End Set
    End Property
    Public Property InvPriceRndFn As String
        Get
            Return _invPriceRndFn
        End Get
        Set(ByVal Value As String)
            _invPriceRndFn = Value
        End Set
    End Property
    Public Property InvRndDec As Decimal
        Get
            Return _invRndDec
        End Get
        Set(ByVal Value As Decimal)
            _invRndDec = Value
        End Set
    End Property
    Public Property KidCustOrd As String
        Get
            Return _kidCustOrd
        End Get
        Set(ByVal Value As String)
            _kidCustOrd = Value
        End Set
    End Property
    Public Property KidInvOrd As String
        Get
            Return _kidInvOrd
        End Get
        Set(ByVal Value As String)
            _kidInvOrd = Value
        End Set
    End Property
    Public Property KidWoOrd As String
        Get
            Return _kidWoOrd
        End Get
        Set(ByVal Value As String)
            _kidWoOrd = Value
        End Set
    End Property
    Public Property KidFixedOrd As String
        Get
            Return _kidFixedOrd
        End Get
        Set(ByVal Value As String)
            _kidFixedOrd = Value
        End Set
    End Property
    Public Property KidCustNod As String
        Get
            Return _kidCustNod
        End Get
        Set(ByVal Value As String)
            _kidCustNod = Value
        End Set
    End Property
    Public Property KidInvNod As String
        Get
            Return _kidInvNod
        End Get
        Set(ByVal Value As String)
            _kidInvNod = Value
        End Set
    End Property
    Public Property KidWoNod As String
        Get
            Return _kidWoNod
        End Get
        Set(ByVal Value As String)
            _kidWoNod = Value
        End Set
    End Property
    Public Property KidFixedNumber As String
        Get
            Return _kidFixedNumber
        End Get
        Set(ByVal Value As String)
            _kidFixedNumber = Value
        End Set
    End Property
    Public Property KidFixedNod As String
        Get
            Return _kidFixedNod
        End Get
        Set(ByVal Value As String)
            _kidFixedNod = Value
        End Set
    End Property
    Public Property FlgKidMod10 As Boolean
        Get
            Return _flgKidMod10
        End Get
        Set(ByVal Value As Boolean)
            _flgKidMod10 = Value
        End Set
    End Property
    Public Property FlgInvFees As Boolean
        Get
            Return _flgInvFees
        End Get
        Set(ByVal Value As Boolean)
            _flgInvFees = Value
        End Set
    End Property
    Public Property InvFeesAmt As Decimal
        Get
            Return _invFeesAmt
        End Get
        Set(ByVal Value As Decimal)
            _invFeesAmt = Value
        End Set
    End Property
    Public Property InvFeesAccCode As String
        Get
            Return _invFeesAccCode
        End Get
        Set(ByVal Value As String)
            _invFeesAccCode = Value
        End Set
    End Property
    Public Property XmlVal() As String
        Get
            Return _xmlVal
        End Get
        Set(ByVal Value As String)
            _xmlVal = Value
        End Set
    End Property
    Public Property UserId() As String
        Get
            Return _userId
        End Get
        Set(ByVal Value As String)
            _userId = Value
        End Set
    End Property
#End Region
End Class
