Public Class PurchaseOrderItemsBO

    Private _id_po As String
    Private _polineno As String
    Private _poprefix As String
    Private _ponumber As String
    Private _id_item As String
    Private _item_catg_desc As String
    Private _orderqty As Decimal
    Private _delivered_qty As String
    Private _remaining_qty As String
    Private _buycost As Decimal
    Private _totalcost As Decimal
    Private _backorderqty As String
    Private _id_woitem_seq As String
    Private _confirmqty As String
    Private _created_by As String
    Private _modified_by As String
    Private _dt_created As String
    Private _dt_modified As String
    Private _delivered As String
    Private _annotation As String


    Public Property ID_PO() As String
        Get
            Return _id_po
        End Get
        Set(ByVal value As String)
            _id_po = value
        End Set
    End Property

    Public Property POLINENO() As String
        Get
            Return _polineno
        End Get
        Set(ByVal value As String)
            _polineno = value
        End Set
    End Property

    Public Property POPREFIX() As String
        Get
            Return _poprefix
        End Get
        Set(ByVal value As String)
            _poprefix = value
        End Set
    End Property

    Public Property PONUMBER() As String
        Get
            Return _ponumber
        End Get
        Set(ByVal value As String)
            _ponumber = value
        End Set
    End Property




    Public Property ID_ITEM() As String
        Get
            Return _id_item
        End Get
        Set(ByVal value As String)
            _id_item = value
        End Set
    End Property

    Public Property ITEM_CATG_DESC() As String
        Get
            Return _item_catg_desc
        End Get
        Set(ByVal value As String)
            _item_catg_desc = value
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

    Public Property DT_MODIFED() As String
        Get
            Return _dt_modified
        End Get
        Set(ByVal value As String)
            _dt_modified = value
        End Set
    End Property



    Public Property ORDERQTY() As Decimal
        Get
            Return _orderqty
        End Get
        Set(ByVal value As Decimal)
            _orderqty = value
        End Set
    End Property

    Public Property DELIVERED_QTY() As String
        Get
            Return _delivered_qty
        End Get
        Set(ByVal value As String)
            _delivered_qty = value
        End Set
    End Property



    Public Property REMAINING_QTY() As String
        Get
            Return _remaining_qty
        End Get
        Set(ByVal value As String)
            _remaining_qty = value
        End Set
    End Property

    Public Property BUYCOST() As Decimal
        Get
            Return _buycost
        End Get
        Set(ByVal value As Decimal)
            _buycost = value
        End Set
    End Property

    Public Property TOTALCOST() As Decimal
        Get
            Return _totalcost
        End Get
        Set(ByVal value As Decimal)
            _totalcost = value
        End Set
    End Property





    Public Property BACKORDERQTY() As String
        Get
            Return _backorderqty
        End Get
        Set(ByVal value As String)
            _backorderqty = value
        End Set
    End Property

    Public Property ID_WOITEM_SEQ() As String
        Get
            Return _id_woitem_seq
        End Get
        Set(ByVal value As String)
            _id_woitem_seq = value
        End Set
    End Property

    Public Property CONFIRMQTY() As String
        Get
            Return _confirmqty
        End Get
        Set(ByVal value As String)
            _confirmqty = value
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

    Public Property ANNOTATION() As String
        Get
            Return _annotation
        End Get
        Set(ByVal value As String)
            _annotation = value
        End Set
    End Property



End Class
