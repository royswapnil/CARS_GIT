Public Class ConfigDeptWarehouseBO
#Region "Variables"
    Private _loginId As String
    Private _departmentWareHouseId As Int32
    Private _wareHouseValue As String
    Private _departmentId As Int32
    Private _wareHouseId As Int32
    Private _isDefault As Boolean
    Private _dateCreated As DateTime
    Private _modifiedBy As String
    Private _dateModified As DateTime
    Private _isSuccess As Boolean
    Private _errorMessage As String
    Private _departmentname As String
    Private _connWarehouses As String
#End Region
#Region "Properties"

    Public Property LoginId() As String
        Get
            Return _loginId
        End Get
        Set(ByVal value As String)
            _loginId = value
        End Set
    End Property
    Public Property DepartmentWareHouseId() As Int32
        Get
            Return _departmentWareHouseId
        End Get
        Set(ByVal value As Int32)
            _departmentWareHouseId = value
        End Set
    End Property
    Public Property DepartmentId() As Int32
        Get
            Return _departmentId
        End Get
        Set(ByVal value As Int32)
            _departmentId = value
        End Set
    End Property
    Public Property WareHouseValue() As String
        Get
            Return _wareHouseValue
        End Get
        Set(ByVal value As String)
            _wareHouseValue = value
        End Set
    End Property
    Public Property WareHouseId() As Int32
        Get
            Return _wareHouseId
        End Get
        Set(ByVal value As Int32)
            _wareHouseId = value
        End Set
    End Property
    Public Property DateCreated() As DateTime
        Get
            Return _dateCreated
        End Get
        Set(ByVal Value As DateTime)
            _dateCreated = Value
        End Set
    End Property
    Public Property IsDefault() As Boolean
        Get
            Return _isDefault
        End Get
        Set(ByVal value As Boolean)
            _isDefault = value
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
    Public Property DateModified() As DateTime
        Get
            Return _dateModified
        End Get
        Set(ByVal Value As DateTime)
            _dateModified = Value
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
    Public Property DepartmentName() As String
        Get
            Return _departmentname
        End Get
        Set(ByVal value As String)
            _departmentname = value
        End Set
    End Property
    Public Property ConnWarehouses() As String
        Get
            Return _connWarehouses
        End Get
        Set(ByVal value As String)
            _connWarehouses = value
        End Set
    End Property
#End Region
End Class
