Public Class ConfigWarehouseBO
#Region "Variables"

    Dim _warehouseID As Integer
    Dim _warehouseName As String
    Dim _warehouseManagerName As String
    Dim _warehouseLocation As String
    Dim _warehousePhone As String
    Dim _warehousePhoneMobile As String
    Dim _warehouseZipcode As String
    Dim _warehouseCountry As String
    Dim _warehouseState As String
    Dim _warehouseCity As String
    Dim _warehouseAddress1 As String
    Dim _warehouseAddress2 As String
    Dim _subsideryID As Integer
    Dim _createdBy As String
    Dim _dateCreated As Date
    Dim _modifiedBy As String
    Dim _dateModified As Date
    Dim _isSuccess As Boolean
    Dim _errorMessage As String
    Dim _subsideryName As String
    Dim _flgConfigZipCode As Boolean

#End Region
#Region "Properties"

    Public Property WarehouseID() As Integer
        Get
            Return _warehouseID
        End Get
        Set(ByVal value As Integer)
            _warehouseID = value
        End Set
    End Property

    Public Property WarehouseName() As String
        Get
            Return _warehouseName
        End Get
        Set(ByVal value As String)
            _warehouseName = value
        End Set
    End Property

    Public Property WarehouseManagerName() As String
        Get
            Return _warehouseManagerName
        End Get
        Set(ByVal value As String)
            _warehouseManagerName = value
        End Set
    End Property

    Public Property WarehouseLocation() As String
        Get
            Return _warehouseLocation
        End Get
        Set(ByVal value As String)
            _warehouseLocation = value
        End Set
    End Property

    Public Property WarehousePhone() As String
        Get
            Return _warehousePhone
        End Get
        Set(ByVal value As String)
            _warehousePhone = value
        End Set
    End Property

    Public Property WarehousePhoneMobile() As String
        Get
            Return _warehousePhoneMobile
        End Get
        Set(ByVal value As String)
            _warehousePhoneMobile = value
        End Set
    End Property
    Public Property WarehouseZipcode() As String
        Get
            Return _warehouseZipcode
        End Get
        Set(ByVal value As String)
            _warehouseZipcode = value
        End Set
    End Property

    Public Property WarehouseCountry() As String
        Get
            Return _warehouseCountry
        End Get
        Set(ByVal value As String)
            _warehouseCountry = value
        End Set
    End Property

    Public Property WarehouseState() As String
        Get
            Return _warehouseState
        End Get
        Set(ByVal value As String)
            _warehouseState = value
        End Set
    End Property

    Public Property WarehouseCity() As String
        Get
            Return _warehouseCity
        End Get
        Set(ByVal value As String)
            _warehouseCity = value
        End Set
    End Property
    Public Property WarehouseAddress1() As String
        Get
            Return _warehouseAddress1
        End Get
        Set(ByVal value As String)
            _warehouseAddress1 = value
        End Set
    End Property

    Public Property WarehouseAddress2() As String
        Get
            Return _warehouseAddress2
        End Get
        Set(ByVal value As String)
            _warehouseAddress2 = value
        End Set
    End Property
    Public Property WarehouseIDSubsidery() As Integer
        Get
            Return _subsideryID
        End Get
        Set(ByVal value As Integer)
            _subsideryID = value
        End Set
    End Property

    Public Property WareHouseSubsideryName() As String
        Get
            Return _subsideryName
        End Get
        Set(ByVal value As String)
            _subsideryName = value
        End Set
    End Property
    Public Property WarehouseCreatedBy() As String
        Get
            Return _createdBy
        End Get
        Set(ByVal value As String)
            _createdBy = value
        End Set
    End Property

    Public Property WarehouseCreatedDate() As Date
        Get
            Return _dateCreated
        End Get
        Set(ByVal value As Date)
            _dateCreated = value
        End Set
    End Property
    Public Property WarehouseModifiedBy() As String
        Get
            Return _modifiedBy
        End Get
        Set(ByVal value As String)
            _modifiedBy = value
        End Set
    End Property

    Public Property WarehouseModifiedDate() As Date
        Get
            Return _dateModified
        End Get
        Set(ByVal value As Date)
            _dateModified = value
        End Set
    End Property

    Public Property IsSuccess() As Boolean
        Get
            Return _isSuccess
        End Get
        Set(ByVal value As Boolean)
            _isSuccess = value
        End Set
    End Property

    Public Property ErrorMessage() As String
        Get
            Return _errorMessage
        End Get
        Set(ByVal value As String)
            _errorMessage = value
        End Set
    End Property

    Public Property Flg_ConfigZipCode() As Boolean
        Get
            Return _flgConfigZipCode
        End Get
        Set(ByVal value As Boolean)
            _flgConfigZipCode = value
        End Set
    End Property

#End Region
End Class
