Public Class PurchaseOrderHeaderBO


    Private _prefix As String
    Private _number As String
    Private _dt_expected_delivery As String
    Private _id_ordertype As String
    Private _id_dept As String
    Private _id_warehouse As String
    Private _created_by As String
    Private _dt_created As String
    Private _modified_by As String
    Private _dt_modified As String
    Private _supp_currentno As String
    Private _supp_name As String
    Private _delivered As String
    Private _delivery_method As String
    Private _status As String
    Private _finished As String
    Private _annotation As String
    Private _dt_created_simple As String






    Public Property PREFIX() As String
        Get
            Return _prefix
        End Get
        Set(ByVal value As String)
            _prefix = value
        End Set
    End Property

    Public Property NUMBER() As String
        Get
            Return _number
        End Get
        Set(ByVal value As String)
            _number = value
        End Set
    End Property


    Public Property DT_EXPECTED_DELIVERY() As String
        Get
            Return _dt_expected_delivery
        End Get
        Set(ByVal value As String)
            _dt_expected_delivery = value
        End Set
    End Property



    Public Property ID_ORDERTYPE() As String
        Get
            Return _id_ordertype
        End Get
        Set(ByVal value As String)
            _id_ordertype = value
        End Set
    End Property


    Public Property ID_DEPT() As String
        Get
            Return _id_dept
        End Get
        Set(ByVal value As String)
            _id_dept = value
        End Set
    End Property

    Public Property ID_WAREHOUSE() As String
        Get
            Return _id_warehouse
        End Get
        Set(ByVal value As String)
            _id_warehouse = value
        End Set
    End Property

    Public Property CREATED_BY() As String
        Get
            Return _created_by

        End Get
        Set(ByVal value As String)
            _created_by = value
        End Set
    End Property

    Public Property DT_CREATED() As String
        Get
            Return _dt_created
        End Get
        Set(ByVal value As String)
            _dt_created = value
        End Set
    End Property

    Public Property MODIFIED_BY() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal value As String)
            _modified_by = value
        End Set
    End Property



    Public Property SUPP_CURRENTNO() As String
        Get
            Return _supp_currentno
        End Get
        Set(ByVal value As String)
            _supp_currentno = value
        End Set
    End Property

    Public Property SUPP_NAME() As String
        Get
            Return _supp_name
        End Get
        Set(ByVal value As String)
            _supp_name = value
        End Set
    End Property

    Public Property DELIVERED() As String
        Get
            Return _delivered
        End Get
        Set(ByVal value As String)
            _delivered = value
        End Set
    End Property

    Public Property DELIVERY_METHOD() As String
        Get
            Return _delivery_method
        End Get
        Set(ByVal value As String)
            _delivery_method = value
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

    Public Property FINISHED() As String
        Get
            Return _finished
        End Get
        Set(ByVal value As String)
            _finished = value
        End Set
    End Property

    Public Property ANNOTATION() As String
        Get
            Return _annotation
        End Get
        Set(ByVal value As String)
            _annotation = value
        End Set
    End Property



    Public Property DT_CREATED_SIMPLE() As String
        Get
            Return _dt_created_simple
        End Get
        Set(ByVal value As String)
            _dt_created_simple = value
        End Set
    End Property

End Class
