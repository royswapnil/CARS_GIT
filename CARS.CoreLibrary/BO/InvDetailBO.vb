Public Class InvDetailBO
    Private _id_wo_no As String
    Private _id_wo_prefix As String
    Private _dt_order As String
    Private _no_of_jobs As String
    Private _deb_name As String
    Private _deb_id As String
    Private _maxinvoice As String
    Private _id_job_deb As String
    Private _wo_veh_reg_no As String
    Private _wo_amount As String
    Private _flg_cust_batchinv As String
    Private _paytype As String
    Private _wo_type_woh As String
    Private _wo_type As String
    Private _id_wodet_seq As String
    Private _id_job As String
    Private _job_text As String
    Private _id_rep_code_wo As String
    Private _rep_code_wo As String
    Private _id_rpg_code_wo As String
    Private _rpg_code_wo As String
    Private _job_amount_dec As String
    Private _job_amount As String
    Private _is_selected As String
    Private _idInvNo As String
    Private _dtInvoice As String
    Private _custName As String
    Private _invoiceAmt As String
    Private _flgBatchInv As String
    Private _creditNo As String
    Private _invPDF As String
    Private _seqNo As String
    Private _flg_kre_Ord As String
    Private _flg_Alrd_Cr As String
    Public Property Id_WO_NO() As String
        Get
            Return _id_wo_no
        End Get
        Set(ByVal value As String)
            _id_wo_no = value
        End Set
    End Property
    Public Property Id_WO_Prefix() As String
        Get
            Return _id_wo_prefix
        End Get
        Set(ByVal value As String)
            _id_wo_prefix = value
        End Set
    End Property
    Public Property Dt_Order() As String
        Get
            Return _dt_order
        End Get
        Set(ByVal value As String)
            _dt_order = value
        End Set
    End Property
    Public Property No_Of_Jobs() As String
        Get
            Return _no_of_jobs
        End Get
        Set(ByVal value As String)
            _no_of_jobs = value
        End Set
    End Property
    Public Property Deb_Name() As String
        Get
            Return _deb_name
        End Get
        Set(ByVal value As String)
            _deb_name = value
        End Set
    End Property
    Public Property Deb_Id() As String
        Get
            Return _deb_id
        End Get
        Set(ByVal value As String)
            _deb_id = value
        End Set
    End Property
    Public Property MaxInvoice() As String
        Get
            Return _maxinvoice
        End Get
        Set(ByVal value As String)
            _maxinvoice = value
        End Set
    End Property
    Public Property Id_Job_Deb() As String
        Get
            Return _id_job_deb
        End Get
        Set(ByVal value As String)
            _id_job_deb = value
        End Set
    End Property
    Public Property WO_Veh_Reg_No() As String
        Get
            Return _wo_veh_reg_no
        End Get
        Set(ByVal value As String)
            _wo_veh_reg_no = value
        End Set
    End Property
    Public Property WO_Amount() As String
        Get
            Return _wo_amount
        End Get
        Set(ByVal value As String)
            _wo_amount = value
        End Set
    End Property
    Public Property Flg_Cust_Batchinv() As String
        Get
            Return _flg_cust_batchinv
        End Get
        Set(ByVal value As String)
            _flg_cust_batchinv = value
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
    Public Property WO_Type_Woh() As String
        Get
            Return _wo_type_woh
        End Get
        Set(ByVal value As String)
            _wo_type_woh = value
        End Set
    End Property
    Public Property WO_Type() As String
        Get
            Return _wo_type
        End Get
        Set(ByVal value As String)
            _wo_type = value
        End Set
    End Property
    Public Property Id_WoDet_Seq() As String
        Get
            Return _id_wodet_seq
        End Get
        Set(ByVal value As String)
            _id_wodet_seq = value
        End Set
    End Property
    Public Property Id_Job() As String
        Get
            Return _id_job
        End Get
        Set(ByVal value As String)
            _id_job = value
        End Set
    End Property
    Public Property WO_Job_Text() As String
        Get
            Return _job_text
        End Get
        Set(ByVal value As String)
            _job_text = value
        End Set
    End Property
    Public Property Id_Rep_Code_WO() As String
        Get
            Return _id_rep_code_wo
        End Get
        Set(ByVal value As String)
            _id_rep_code_wo = value
        End Set
    End Property
    Public Property Rep_Code_WO() As String
        Get
            Return _rep_code_wo
        End Get
        Set(ByVal value As String)
            _rep_code_wo = value
        End Set
    End Property
    Public Property Id_Rpg_Code_WO() As String
        Get
            Return _id_rpg_code_wo
        End Get
        Set(ByVal value As String)
            _id_rpg_code_wo = value
        End Set
    End Property
    Public Property Rpg_Code_WO() As String
        Get
            Return _rpg_code_wo
        End Get
        Set(ByVal value As String)
            _rpg_code_wo = value
        End Set
    End Property
    Public Property Job_Amount_Format() As String
        Get
            Return _job_amount_dec
        End Get
        Set(ByVal value As String)
            _job_amount_dec = value
        End Set
    End Property
    Public Property Job_Amount() As String
        Get
            Return _job_amount
        End Get
        Set(ByVal value As String)
            _job_amount = value
        End Set
    End Property
    Public Property Is_Selected() As String
        Get
            Return _is_selected
        End Get
        Set(ByVal value As String)
            _is_selected = value
        End Set
    End Property
    Public Property Id_Inv_No() As String
        Get
            Return _idInvNo
        End Get
        Set(ByVal value As String)
            _idInvNo = value
        End Set
    End Property
    Public Property Dt_Invoice() As String
        Get
            Return _dtInvoice
        End Get
        Set(ByVal value As String)
            _dtInvoice = value
        End Set
    End Property
    Public Property CustomerName() As String
        Get
            Return _custName
        End Get
        Set(ByVal value As String)
            _custName = value
        End Set
    End Property
    Public Property InvoiceAmt() As String
        Get
            Return _invoiceAmt
        End Get
        Set(ByVal value As String)
            _invoiceAmt = value
        End Set
    End Property
    Public Property Flg_Batch_Inv() As String
        Get
            Return _flgBatchInv
        End Get
        Set(ByVal value As String)
            _flgBatchInv = value
        End Set
    End Property
    Public Property Credit_No() As String
        Get
            Return _creditNo
        End Get
        Set(ByVal value As String)
            _creditNo = value
        End Set
    End Property
    Public Property InvoicePDF() As String
        Get
            Return _invPDF
        End Get
        Set(ByVal value As String)
            _invPDF = value
        End Set
    End Property
    Public Property SeqNo() As String
        Get
            Return _seqNo
        End Get
        Set(ByVal value As String)
            _seqNo = value
        End Set
    End Property
    Public Property Flg_Kre_Ord() As String
        Get
            Return _flg_kre_Ord
        End Get
        Set(ByVal value As String)
            _flg_kre_Ord = value
        End Set
    End Property
    Public Property Flg_Alrdy_Cr() As String
        Get
            Return _flg_Alrd_Cr
        End Get
        Set(ByVal value As String)
            _flg_Alrd_Cr = value
        End Set
    End Property


End Class
