Public Class WOPaymentDetailBO
    Private _id_wo_no As String
    Private _id_job As String
    Private _id_wo_prefix As String
    Private _tot_vat_amt As Decimal
    Private _tot_gm_amt As Decimal
    Private _tot_spare_amt As Decimal
    Private _tot_lab_amt As Decimal
    Private _own_risk_amt As Decimal
    Private _job_status As String
    Private _tot_amount As Decimal
    Private _final_vat As String
    Private _tot_disc_amt As Decimal
    Private _id_debtor As String
    Private _debitor_name As String
    Private _tot_net_amt As Decimal
    Private _idXml As String
    Private _loginId As String
    Private _idWoDetSeq As String
    Private _flgBatch As String
    Private _status As String
    Public Property Id_WO_NO() As String
        Get
            Return _id_wo_no
        End Get
        Set(ByVal Value As String)
            _id_wo_no = Value
        End Set
    End Property
    Public Property Id_WO_Prefix() As String
        Get
            Return _id_wo_prefix
        End Get
        Set(ByVal Value As String)
            _id_wo_prefix = Value
        End Set
    End Property
    Public Property Job_No() As String
        Get
            Return _id_job
        End Get
        Set(ByVal Value As String)
            _id_job = Value
        End Set
    End Property
    Public Property Tot_Spare_Amt() As Decimal
        Get
            Return _tot_spare_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_spare_amt = Value
        End Set
    End Property
    Public Property Tot_Vat_Amt() As Decimal
        Get
            Return _tot_vat_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_vat_amt = Value
        End Set
    End Property
    Public Property Tot_Lab_Amt() As Decimal
        Get
            Return _tot_lab_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_lab_amt = Value
        End Set
    End Property
    Public Property Tot_GM_Amt() As Decimal
        Get
            Return _tot_gm_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_gm_amt = Value
        End Set
    End Property
    Public Property Own_Risk_Amt() As Decimal
        Get
            Return _own_risk_amt
        End Get
        Set(ByVal Value As Decimal)
            _own_risk_amt = Value
        End Set
    End Property
    Public Property Tot_Amount() As Decimal
        Get
            Return _tot_amount
        End Get
        Set(ByVal Value As Decimal)
            _tot_amount = Value
        End Set
    End Property
    Public Property Tot_Net_Amount() As Decimal
        Get
            Return _tot_net_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_net_amt = Value
        End Set
    End Property
    Public Property Job_Status() As String
        Get
            Return _job_status
        End Get
        Set(ByVal Value As String)
            _job_status = Value
        End Set
    End Property
    Public Property Id_Debitor() As String
        Get
            Return _id_debtor
        End Get
        Set(ByVal Value As String)
            _id_debtor = Value
        End Set
    End Property
    Public Property Debitor_Name() As String
        Get
            Return _debitor_name
        End Get
        Set(ByVal Value As String)
            _debitor_name = Value
        End Set
    End Property
    Public Property ToT_Disc_Amt() As Decimal
        Get
            Return _tot_disc_amt
        End Get
        Set(ByVal Value As Decimal)
            _tot_disc_amt = Value
        End Set
    End Property
    Public Property IdXml() As String
        Get
            Return _idXml
        End Get
        Set(ByVal Value As String)
            _idXml = Value
        End Set
    End Property
    Public Property LoginId() As String
        Get
            Return _loginId
        End Get
        Set(ByVal Value As String)
            _loginId = Value
        End Set
    End Property
    Public Property IdWODetSeq() As String
        Get
            Return _idWoDetSeq
        End Get
        Set(ByVal Value As String)
            _idWoDetSeq = Value
        End Set
    End Property
    Public Property FlgBatch() As String
        Get
            Return _flgBatch
        End Get
        Set(ByVal Value As String)
            _flgBatch = Value
        End Set
    End Property
    Public Property Status() As String
        Get
            Return _status
        End Get
        Set(ByVal Value As String)
            _status = Value
        End Set
    End Property
End Class
