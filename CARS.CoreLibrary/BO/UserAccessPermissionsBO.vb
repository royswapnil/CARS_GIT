Imports System.Web
Public Class UserAccessPermissionsBO
    Dim ID_SCR As Integer
    Dim ID_ACC_DELETE As Boolean
    Dim ID_ACC_EDIT As Boolean
    Dim ID_ACC_ADD As Boolean
    Private ID_ACC_PRINT As Boolean
    Private ID_ACC_VIEW As Boolean
    Dim DISCOUNT As Boolean
    Dim HOURLYPRICE As Boolean
    Dim NEGATIVEQUNATITY As Boolean
    Dim SPCOSTPRICE As Boolean
    Dim SPDISCOUNT As Boolean
    Dim SPPRICE As Boolean
    Dim PAYDET As Boolean
    Dim _moduleName As String
    Dim _langName As String

#Region "Property"
    Public Property PF_ACC_SCR() As Integer
        Get
            Return ID_SCR
        End Get
        Set(ByVal Value As Integer)
            ID_SCR = Value
        End Set
    End Property
    Public Property PF_ACC_DELETE() As Boolean
        Get
            Return ID_ACC_DELETE
        End Get
        Set(ByVal Value As Boolean)
            ID_ACC_DELETE = Value
        End Set

    End Property

    Public Property PF_ACC_EDIT() As Boolean
        Get
            Return ID_ACC_EDIT
        End Get
        Set(ByVal Value As Boolean)
            ID_ACC_EDIT = Value
        End Set
    End Property

    Public Property PF_ACC_ADD() As Boolean
        Get
            Return ID_ACC_ADD
        End Get
        Set(ByVal Value As Boolean)
            ID_ACC_ADD = Value
        End Set
    End Property
    Public Property PF_ACC_VIEW() As Boolean
        Get
            Return ID_ACC_VIEW
        End Get
        Set(ByVal Value As Boolean)
            ID_ACC_VIEW = Value
        End Set
    End Property
    Public Property PF_ACC_PRINT() As Boolean
        Get
            Return ID_ACC_PRINT
        End Get
        Set(ByVal Value As Boolean)
            ID_ACC_PRINT = Value
        End Set
    End Property
    Public Property PF_DISCOUNT() As Boolean
        Get
            Return DISCOUNT
        End Get
        Set(ByVal Value As Boolean)
            DISCOUNT = Value
        End Set
    End Property
    Public Property PF_HOURLYPRICE() As Boolean
        Get
            Return HOURLYPRICE
        End Get
        Set(ByVal Value As Boolean)
            HOURLYPRICE = Value
        End Set
    End Property
    Public Property PF_NEGATIVEQUNATITY() As Boolean
        Get
            Return NEGATIVEQUNATITY
        End Get
        Set(ByVal Value As Boolean)
            NEGATIVEQUNATITY = Value
        End Set
    End Property
    Public Property PF_SPCOSTPRICE() As Boolean
        Get
            Return SPCOSTPRICE
        End Get
        Set(ByVal Value As Boolean)
            SPCOSTPRICE = Value
        End Set
    End Property
    Public Property PF_SPDISCOUNT() As Boolean
        Get
            Return SPDISCOUNT
        End Get
        Set(ByVal Value As Boolean)
            SPDISCOUNT = Value
        End Set
    End Property

    Public Property PF_SPPRICE() As Boolean
        Get
            Return SPPRICE
        End Get
        Set(ByVal Value As Boolean)
            SPPRICE = Value
        End Set
    End Property
    Public Property PF_PAYDET() As Boolean
        Get
            Return PAYDET
        End Get
        Set(ByVal Value As Boolean)
            PAYDET = Value
        End Set
    End Property
    Public Property Module_Name() As String
        Get
            Return _moduleName
        End Get
        Set(ByVal Value As String)
            _moduleName = Value
        End Set
    End Property
    Public Property Lang_Name() As String
        Get
            Return _langName
        End Get
        Set(ByVal Value As String)
            _langName = Value
        End Set
    End Property
#End Region
  
End Class
