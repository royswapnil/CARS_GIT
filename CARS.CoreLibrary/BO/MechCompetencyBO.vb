Public Class MechCompetencyBO

    Private _id_compt As String
    Private _compt_description As String
    Private _hidId_compt As String
    Private _idseq As String
    Private _mechanicid As String
    Private _pricecode As String
    Private _competencycode As String
    Private _idmech As String
    Private _cost_time As String
    Private _cost_hour As String
    Private _cost_garage As String
    Private _idsettings As String
    Private _idconfig As String
    Private _description As String

    Public Property IdCompt() As String
        Get
            Return _id_compt
        End Get
        Set(ByVal Value As String)
            _id_compt = Value
        End Set
    End Property
    Public Property Compt_Description() As String
        Get
            Return _compt_description
        End Get
        Set(ByVal Value As String)
            _compt_description = Value
        End Set
    End Property
    Public Property HiIdCompt() As String
        Get
            Return _hidId_compt
        End Get
        Set(ByVal Value As String)
            _hidId_compt = Value
        End Set
    End Property
    Public Property IdSeq() As String
        Get
            Return _idseq
        End Get
        Set(ByVal Value As String)
            _idseq = Value
        End Set
    End Property
    Public Property MechanicId() As String
        Get
            Return _mechanicid
        End Get
        Set(ByVal Value As String)
            _mechanicid = Value
        End Set
    End Property
    Public Property PriceCode() As String
        Get
            Return _pricecode
        End Get
        Set(ByVal Value As String)
            _pricecode = Value
        End Set
    End Property
    Public Property CompetencyCode() As String
        Get
            Return _competencycode
        End Get
        Set(ByVal Value As String)
            _competencycode = Value
        End Set
    End Property
    Public Property IdMech() As String
        Get
            Return _idmech
        End Get
        Set(ByVal Value As String)
            _idmech = Value
        End Set
    End Property
    Public Property CostTime() As String
        Get
            Return _cost_time
        End Get
        Set(ByVal Value As String)
            _cost_time = Value
        End Set
    End Property
    Public Property CostHour() As String
        Get
            Return _cost_hour
        End Get
        Set(ByVal Value As String)
            _cost_hour = Value
        End Set
    End Property
    Public Property CostGarage() As String
        Get
            Return _cost_garage
        End Get
        Set(ByVal Value As String)
            _cost_garage = Value
        End Set
    End Property
    Public Property IdSettings() As String
        Get
            Return _idsettings
        End Get
        Set(ByVal Value As String)
            _idsettings = Value
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
    Public Property IdConfig() As String
        Get
            Return _idconfig
        End Get
        Set(ByVal Value As String)
            _idconfig = Value
        End Set
    End Property

End Class
