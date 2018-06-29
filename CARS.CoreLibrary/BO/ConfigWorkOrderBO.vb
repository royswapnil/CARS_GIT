Public Class ConfigWorkOrderBO
    Private _ord_num As String
    Private _ord_ser As String
    Private _id_own_risk As String
    Private _id_gm_price As String
    Private _id_cal_dis As String
    Private _id_subsidery As String
    Private _id_dept As String
    Private _id_disc_seq As String
    Private _prod_grp As String
    Private _id_item_catg_map As String
    Private _desc As String
    Private _dis_code As String
    Private _vat_code As String
    Private _wopr As String
    Private _wo_vat_calcrisk As String
    Private _wo_gar_matprice_perc As String
    Private _wo_charege_base As String
    Private _wo_discount_base As String
    Private _wo_curr_series As String
    Private _use_delv_address As String
    Private _use_manual_rwrk As String
    Private _use_vehicle_sp As String
    Private _use_pc_job As String
    Private _wo_status As String
    Private _use_default_cust As String
    Private _id_customer As String
    Private _use_cnfrm_dia As String
    Private _use_save_job_grid As String
    Private _use_va_acc_code As String
    Private _va_acc_code As String
    Private _use_all_spare_search As String
    Private _disp_rinv_pinv As String
    Private _idsettings As String
    Private _remarks As String
    Private _id_vat_seq As String
    Private _vatcodeoncust As String
    Private _vatcodeonitem As String
    Private _vatcodeonvehicle As String
    Private _vatcodeonorderline As String
    Private _vat_acccode As String
    Private _lastchangedby As String
    Private _vat_status As String
    Private _lastchangedon As String

    Public Property Ord_Num() As String
        Get
            Return _ord_num
        End Get
        Set(ByVal Value As String)
            _ord_num = Value
        End Set
    End Property
    Public Property Ord_Ser() As String
        Get
            Return _ord_ser
        End Get
        Set(ByVal Value As String)
            _ord_ser = Value
        End Set
    End Property
    Public Property Own_Risk() As String
        Get
            Return _id_own_risk
        End Get
        Set(ByVal Value As String)
            _id_own_risk = Value
        End Set
    End Property
    Public Property GMat_Price() As String
        Get
            Return _id_gm_price
        End Get
        Set(ByVal Value As String)
            _id_gm_price = Value
        End Set
    End Property
    Public Property Cal_Disc() As String
        Get
            Return _id_cal_dis
        End Get
        Set(ByVal Value As String)
            _id_cal_dis = Value
        End Set
    End Property
    Public Property Id_Subsidery() As String
        Get
            Return _id_subsidery
        End Get
        Set(ByVal Value As String)
            _id_subsidery = Value
        End Set
    End Property
    Public Property Id_Dept() As String
        Get
            Return _id_dept
        End Get
        Set(ByVal Value As String)
            _id_dept = Value
        End Set
    End Property
    Public Property Id_Disc_Seq() As String
        Get
            Return _id_disc_seq
        End Get
        Set(ByVal Value As String)
            _id_disc_seq = Value
        End Set
    End Property
    Public Property Product_Group() As String
        Get
            Return _prod_grp
        End Get
        Set(ByVal Value As String)
            _prod_grp = Value
        End Set
    End Property
    Public Property Id_Item_Catg_Map() As String
        Get
            Return _id_item_catg_map
        End Get
        Set(ByVal Value As String)
            _id_item_catg_map = Value
        End Set
    End Property
    Public Property Disc_Code() As String
        Get
            Return _dis_code
        End Get
        Set(ByVal Value As String)
            _dis_code = Value
        End Set
    End Property
    Public Property VAT_Code() As String
        Get
            Return _vat_code
        End Get
        Set(ByVal Value As String)
            _vat_code = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return _desc
        End Get
        Set(ByVal Value As String)
            _desc = Value
        End Set
    End Property
    Public Property WOPr() As String
        Get
            Return _wopr
        End Get
        Set(ByVal Value As String)
            _wopr = Value
        End Set
    End Property
    Public Property WO_VAT_CalcRisk() As String
        Get
            Return _wo_vat_calcrisk
        End Get
        Set(ByVal Value As String)
            _wo_vat_calcrisk = Value
        End Set
    End Property
    Public Property WO_GMPrice_Perc() As String
        Get
            Return _wo_gar_matprice_perc
        End Get
        Set(ByVal Value As String)
            _wo_gar_matprice_perc = Value
        End Set
    End Property
    Public Property WO_Charege_Base() As String
        Get
            Return _wo_charege_base
        End Get
        Set(ByVal Value As String)
            _wo_charege_base = Value
        End Set
    End Property
    Public Property WO_Discount_Base() As String
        Get
            Return _wo_discount_base
        End Get
        Set(ByVal Value As String)
            _wo_discount_base = Value
        End Set
    End Property
    Public Property WO_Curr_Series() As String
        Get
            Return _wo_curr_series
        End Get
        Set(ByVal Value As String)
            _wo_curr_series = Value
        End Set
    End Property
    Public Property Use_Delv_Address() As String
        Get
            Return _use_delv_address
        End Get
        Set(ByVal Value As String)
            _use_delv_address = Value
        End Set
    End Property
    Public Property Use_Manual_Rwrk() As String
        Get
            Return _use_manual_rwrk
        End Get
        Set(ByVal Value As String)
            _use_manual_rwrk = Value
        End Set
    End Property
    Public Property Use_Vehicle_Sp() As String
        Get
            Return _use_vehicle_sp
        End Get
        Set(ByVal Value As String)
            _use_vehicle_sp = Value
        End Set
    End Property
    Public Property Use_Pc_Job() As String
        Get
            Return _use_pc_job
        End Get
        Set(ByVal Value As String)
            _use_pc_job = Value
        End Set
    End Property
    Public Property WO_Status() As String
        Get
            Return _wo_status
        End Get
        Set(ByVal Value As String)
            _wo_status = Value
        End Set
    End Property
    Public Property Use_Default_Cust() As String
        Get
            Return _use_default_cust
        End Get
        Set(ByVal Value As String)
            _use_default_cust = Value
        End Set
    End Property
    Public Property IdCustomer() As String
        Get
            Return _id_customer
        End Get
        Set(ByVal Value As String)
            _id_customer = Value
        End Set
    End Property
    Public Property Use_Cnfrm_Dialogue() As String
        Get
            Return _use_cnfrm_dia
        End Get
        Set(ByVal Value As String)
            _use_cnfrm_dia = Value
        End Set
    End Property
    Public Property Use_SaveJob_Grid() As String
        Get
            Return _use_save_job_grid
        End Get
        Set(ByVal Value As String)
            _use_save_job_grid = Value
        End Set
    End Property
    Public Property Use_VA_ACC_Code() As String
        Get
            Return _use_va_acc_code
        End Get
        Set(ByVal Value As String)
            _use_va_acc_code = Value
        End Set
    End Property
    Public Property VA_ACC_Code() As String
        Get
            Return _va_acc_code
        End Get
        Set(ByVal Value As String)
            _va_acc_code = Value
        End Set
    End Property
    Public Property Use_All_Spare_Search() As String
        Get
            Return _use_all_spare_search
        End Get
        Set(ByVal Value As String)
            _use_all_spare_search = Value
        End Set
    End Property
    Public Property Disp_Rinv_Pinv() As String
        Get
            Return _disp_rinv_pinv
        End Get
        Set(ByVal Value As String)
            _disp_rinv_pinv = Value
        End Set
    End Property
    Public Property IdSettings() As String
        Get
            Return _idsettings
        End Get
        Set(ByVal Value As String)
            _idsettings = Value
        End Set
    End Property
    Public Property Remarks() As String
        Get
            Return _remarks
        End Get
        Set(ByVal Value As String)
            _remarks = Value
        End Set
    End Property
    Public Property Id_Vat_Seq() As String
        Get
            Return _id_vat_seq
        End Get
        Set(ByVal Value As String)
            _id_vat_seq = Value
        End Set
    End Property
    Public Property VatCodeOnCust() As String
        Get
            Return _vatcodeoncust
        End Get
        Set(ByVal Value As String)
            _vatcodeoncust = Value
        End Set
    End Property
    Public Property VatCodeOnItem() As String
        Get
            Return _vatcodeonitem
        End Get
        Set(ByVal Value As String)
            _vatcodeonitem = Value
        End Set
    End Property
    Public Property VatCodeOnVehicle() As String
        Get
            Return _vatcodeonvehicle
        End Get
        Set(ByVal Value As String)
            _vatcodeonvehicle = Value
        End Set
    End Property
    Public Property VatCodeOnOrderLine() As String
        Get
            Return _vatcodeonorderline
        End Get
        Set(ByVal Value As String)
            _vatcodeonorderline = Value
        End Set
    End Property
    Public Property Vat_Acccode() As String
        Get
            Return _vat_acccode
        End Get
        Set(ByVal Value As String)
            _vat_acccode = Value
        End Set
    End Property
    Public Property LastChangedBy() As String
        Get
            Return _lastchangedby
        End Get
        Set(ByVal Value As String)
            _lastchangedby = Value
        End Set
    End Property
    Public Property VatStatus() As String
        Get
            Return _vat_status
        End Get
        Set(ByVal Value As String)
            _vat_status = Value
        End Set
    End Property
    Public Property LastChangedOn() As String
        Get
            Return _lastchangedon
        End Get
        Set(ByVal Value As String)
            _lastchangedon = Value
        End Set
    End Property


End Class
