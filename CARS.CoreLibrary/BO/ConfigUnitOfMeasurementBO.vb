Public Class ConfigUnitOfMeasurementBO
    Private _id_uom As String
    Private _unit_desc As String
    Private _description As String
    Private _createdBy As String
    Private _modifiedBy As String

    Public Property Id_UOM() As String
        Get
            Return _id_uom
        End Get
        Set(ByVal value As String)
            _id_uom = value
        End Set
    End Property
    Public Property Unit_Desc() As String
        Get
            Return _unit_desc
        End Get
        Set(ByVal value As String)
            _unit_desc = value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _description
        End Get
        Set(ByVal value As String)
            _description = value
        End Set
    End Property
    Public Property CreatedBy() As String
        Get
            Return _createdBy
        End Get
        Set(ByVal value As String)
            _createdBy = value
        End Set
    End Property
    Public Property ModifiedBy() As String
        Get
            Return _modifiedBy
        End Get
        Set(ByVal value As String)
            _modifiedBy = value
        End Set
    End Property
End Class
