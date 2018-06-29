Public Class OrderBO
    'For Order autocomplete
    Private _id_search As String
    Private _custid As String
    Private _custname As String
    Private _custadd1 As String
    Private _custzip As String
    Private _custphonemobile
    Private _regno As String
    Private _refno As String
    Private _status As String
    Private _ordno As String
    Private _prefix As String
    Private _invno As String
    Private _invoicedt As String
    Private _woseries As String
    Private _paytype As String
    Private _ordertype As String
    Private _orderStatus As String

    'For order autocomplete
    Public Property ID_SEARCH() As String
        Get
            Return _id_search
        End Get
        Set(ByVal value As String)
            _id_search = value
        End Set
    End Property
    Public Property IDCUSTOMER() As String
        Get
            Return _custid
        End Get
        Set(ByVal value As String)
            _custid = value
        End Set
    End Property
    Public Property CUSTOMER() As String
        Get
            Return _custname
        End Get
        Set(ByVal value As String)
            _custname = value
        End Set
    End Property
    Public Property CUSTADD1() As String
        Get
            Return _custadd1
        End Get
        Set(ByVal value As String)
            _custadd1 = value
        End Set
    End Property
    Public Property CUSTZIP() As String
        Get
            Return _custzip
        End Get
        Set(ByVal value As String)
            _custzip = value
        End Set
    End Property
    Public Property CUSTPHONEMOBILE() As String
        Get
            Return _custphonemobile
        End Get
        Set(ByVal value As String)
            _custphonemobile = value
        End Set
    End Property
    Public Property REFNO() As String
        Get
            Return _refno
        End Get
        Set(ByVal value As String)
            _refno = value
        End Set
    End Property
    Public Property REGNO() As String
        Get
            Return _regno
        End Get
        Set(ByVal value As String)
            _regno = value
        End Set
    End Property
    Public Property STATUS() As String
        Get
            Return _status
        End Get
        Set(ByVal value As String)
            _status = value
        End Set
    End Property
    Public Property ORDNO() As String
        Get
            Return _ordno
        End Get
        Set(ByVal value As String)
            _ordno = value
        End Set
    End Property
    Public Property PREFIX() As String
        Get
            Return _prefix
        End Get
        Set(ByVal value As String)
            _prefix = value
        End Set
    End Property
    Public Property InvNo() As String
        Get
            Return _invno
        End Get
        Set(ByVal value As String)
            _invno = value
        End Set
    End Property
    Public Property InvDate() As String
        Get
            Return _invoicedt
        End Get
        Set(ByVal value As String)
            _invoicedt = value
        End Set
    End Property
    Public Property WOSeries() As String
        Get
            Return _woseries
        End Get
        Set(ByVal value As String)
            _woseries = value
        End Set
    End Property
    Public Property PayType() As String
        Get
            Return _paytype
        End Get
        Set(ByVal value As String)
            _paytype = value
        End Set
    End Property
    Public Property OrderType() As String
        Get
            Return _ordertype
        End Get
        Set(ByVal value As String)
            _ordertype = value
        End Set
    End Property
    Public Property OrderStatus() As String
        Get
            Return _orderStatus
        End Get
        Set(ByVal value As String)
            _orderStatus = value
        End Set
    End Property
End Class
