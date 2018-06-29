Public Class ConfigSubsidiaryBO
#Region "Variable"
    Private _subsidiaryID As String
    Private _subsidiaryName As String
    Private _subsidiaryManager As String
    Private _addressLine1 As String
    Private _addressLine2 As String
    Private _telephone As String
    Private _mobile As String
    Private _email As String
    Private _organization As String
    Private _userID As String
    Private _swift As String
    Private _iban As String
    Private _bankAccnt As String
    Private _transferMethod As String
    Private _accntCode As String
    Private _zipCode As String
    Private _city As String
    Private _country As String
    Private _state As String
    Private _cdate As String
    Private _faxNo As String
    Private _mdate As String
    Private _modifiedBy As String

#End Region
    Public Property SubsidiaryID() As String
        Get
            Return _subsidiaryID
        End Get
        Set(ByVal value As String)
            _subsidiaryID = value
        End Set
    End Property
    Public Property SubsidiaryName() As String
        Get
            Return _subsidiaryName
        End Get
        Set(ByVal value As String)
            _subsidiaryName = value
        End Set
    End Property
    Public Property SubsidiaryManager() As String
        Get
            Return _subsidiaryManager
        End Get
        Set(ByVal value As String)
            _subsidiaryManager = value
        End Set
    End Property
    Public Property AddressLine1() As String
        Get
            Return _addressLine1
        End Get
        Set(ByVal value As String)
            _addressLine1 = value
        End Set
    End Property
    Public Property AddressLine2() As String
        Get
            Return _addressLine2
        End Get
        Set(ByVal value As String)
            _addressLine2 = value
        End Set
    End Property
    Public Property Telephone() As String
        Get
            Return _telephone
        End Get
        Set(ByVal value As String)
            _telephone = value
        End Set
    End Property
    Public Property Mobile() As String
        Get
            Return _mobile
        End Get
        Set(ByVal value As String)
            _mobile = value
        End Set
    End Property
    Public Property Email() As String
        Get
            Return _email
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property
    Public Property Organization() As String
        Get
            Return _organization
        End Get
        Set(ByVal Value As String)
            _organization = Value
        End Set
    End Property
    Public Property UserID() As String
        Get
            Return _userID
        End Get
        Set(ByVal Value As String)
            _userID = Value
        End Set
    End Property
    Public Property Swift() As String
        Get
            Return _swift
        End Get
        Set(ByVal value As String)
            _swift = value
        End Set
    End Property
    Public Property IBAN() As String
        Get
            Return _iban
        End Get
        Set(ByVal value As String)
            _iban = value
        End Set
    End Property
    Public Property BankAccnt() As String
        Get
            Return _bankAccnt
        End Get
        Set(ByVal value As String)
            _bankAccnt = value
        End Set
    End Property
    Public Property TransferMethod() As String
        Get
            Return _transferMethod
        End Get
        Set(ByVal value As String)
            _transferMethod = value
        End Set
    End Property
    Public Property AccntCode() As String
        Get
            Return _accntCode
        End Get
        Set(ByVal value As String)
            _accntCode = value
        End Set
    End Property
    Public Property ZipCode() As String
        Get
            Return _zipCode
        End Get
        Set(ByVal value As String)
            _zipCode = value
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
    Public Property CreatedDate() As String
        Get
            Return _cdate
        End Get
        Set(ByVal value As String)
            _cdate = value
        End Set
    End Property
    Public Property FaxNo() As String
        Get
            Return _faxNo
        End Get
        Set(ByVal value As String)
            _faxNo = value
        End Set
    End Property
    Public Property ModifiedDate() As String
        Get
            Return _mdate
        End Get
        Set(ByVal value As String)
            _mdate = value
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
