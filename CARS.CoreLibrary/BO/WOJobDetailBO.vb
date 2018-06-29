Public Class WOJobDetailBO
    Private _id_wo_no As String
    Private _id_job As String
    Private _id_make_job As String
    Private _id_catg_job As String
    Private _id_item_job As String
    Private _jobi_order_qty As String
    Private _jobi_deliver_qty As String
    Private _jobi_bo_qty As String
    Private _jobi_sell_price As String
    Private _jobi_dis_per As String
    Private _job_text As String
    Private _created_by As String
    Private _dt_created As Date
    Private _modified_by As String
    Private _dt_modified As Date
    Private _id_wo_prefix As String
    Private _id_make_rp As String
    Private _id_model_rp As String
    Private _id_rp_job As String
    Private _id_rc_job As String
    Private _cust_info As String
    Private _id_wodet_seq As Integer
    Private _id_work_code_wo As String
    Private _fixed_price As String
    Private _id_jobpcd_wo As String
    Private _wo_planned_time As String
    Private _tot_disc_amt As String
    Private _stat_req As Integer
    Private _chrg_std_time As Boolean
    Private _tot_vat_amt As String
    Private _tot_gm_amt As String
    Private _tot_spare_amt As String
    Private _tot_lab_amt As String
    Private _own_risk_amt As String
    Private _wo_hourley_price As String
    Private _job_status As String
    Private _wo_clk_time As String
    Private _wo_std_time As String
    Private _wo_chrg_time As String
    Private _job_doc As String
    Private _wo_doc As String
    Private _veh_grp As String
    Private _mechpcd_hp As String
    Private _tot_amount As String
    Private _wo_id_veh As String
    Private _wo_own_pay_vat As Boolean
    Private _job_dis As String
    Private _mec_det As String
    Private _dt_planned As String
    Private _dis_doc As String
    Private _id_deb_seq As Integer
    Private _id_mech_comp As String
    Private _own_risk_cust As String
    Private _own_risk_cr_cust As String
    Private _id_ser_call As Integer
    Private _id_warehouse As Integer
    Private _id_gm_vat As String
    Private _id_hp_vat As String
    Private _wo_incl_vat As Boolean
    Private _wo_discount As Decimal
    Private _id_subrep_code_wo As Integer
    Private _wo_ownriskvat As Decimal
    Private _hp_price As Decimal
    Private _createdby As String
    Private _flg_sprsts As Boolean
    Private _salesman As String
    Private _flg_vat_free As Boolean
    Private _cost_price As String
    Private _final_total As Decimal
    Private _final_vat As Decimal
    Private _final_discount As Decimal
    Private _wo_chrg_time_fp As String
    Private _tot_disc_amt_fp As Decimal
    Private _tot_vat_amt_fp As Decimal
    Private _tot_gm_amt_fp As Decimal
    Private _tot_spare_amt_fp As Decimal
    Private _tot_lab_amt_fp As Decimal
    Private _wo_int_note As String
    Private _category_id_settings As String
    Private _category_description As String
    Private _price_code_id_settings As String
    Private _price_code_description As String
    Private _id_rep_code As String
    Private _rp_repcode_des As String
    Private _work_code_id_settings As String
    Private _work_code_description As String
    Private _mech_id_compt As String
    Private _mech_compt_description As String
    Private _id_stationtype As String
    Private _station_type_description As String
    Private _garageMat As String
    Private _chrgTime As String
    'Spare Parts Columns
    Private _id_sp_item As String
    Private _id_sp_replace As String
    Private _item_sp_desc As String
    Private _id_item_catg As String
    Private _id_make As String
    Private _catg_desc As String
    Private _sp_make As String
    Private _item_avail_qty As Decimal
    Private _flg_allow_bckord As Boolean
    Private _jobi_dis_seq As Integer
    Private _jobi_vat_per As String
    Private _jobi_vat_seq As Integer
    Private _sp_item_price As String
    Private _sp_cost_price As Decimal
    Private _sp_disc_code_sell As String
    Private _sp_disc_code_buy As String
    Private _sp_location As String
    Private _sp_item_description As String
    Private _sp_i_item As String
    Private _id_wh_item As Integer
    Private _env_id_item As String
    Private _env_id_make As String
    Private _env_id_warehouse As String
    Private _flg_efd As Boolean
    Private _id_customer As String

    Private _id_rpg_catg_wo As String
    Private _id_rpg_code_wo As String
    Private _rp_desc As String
    Private _id_rep_code_wo As Integer
    Private _wo_fixed_price As Decimal
    Private _wo_gm_per As String
    Private _wo_gm_vatper As Decimal
    Private _wo_lbr_vatper As Decimal
    Private _flg_chrg_std_time As Boolean
    Private _flg_stat_req As Boolean
    Private _wo_job_txt As String
    Private _wo_own_risk_amt As Decimal
    Private _wo_tot_lab_amt As Decimal
    Private _wo_tot_spare_amt As Decimal
    Private _wo_tot_gm_amt As Decimal
    Private _wo_tot_vat_amt As Decimal
    Private _wo_tot_disc_amt As Decimal
    Private _wo_own_cr_custname As String
    Private _wo_own_risk_cust As String
    Private _wo_own_cr_cust As String
    Private _id_stype_wo As String
    Private _ownriskvatamt As Decimal
    Private _wo_tot_disc_amt_fp As Decimal
    Private _wo_tot_gm_amt_fp As Decimal
    Private _wo_tot_lab_amt_fp As Decimal
    Private _wo_tot_spare_amt_fp As Decimal
    Private _wo_tot_vat_amt_fp As Decimal
    Private _flg_val_stdtime As Boolean
    Private _flg_val_mileage As Boolean
    Private _flg_saveupddp As Boolean
    Private _flg_edtchgtime As Boolean
    Private _internal_note As String
    Private _wo_own_risk_custname As String
    Private _flg_disp_int_note As Boolean
    Private _id_job_deb As String
    Private _job_deb_name As String
    Private _id_woitem_seq As Integer
    Private _sp_slno As String
    Private _id_item_catg_job_id As String
    Private _order_line_text As String
    Private _td_calc As String
    Private _text As String
    Private _pickinglist_prev_printed As Boolean
    Private _deliverynote_prev_printed As Boolean
    Private _prev_picked As String
    Private _tobe_picked As String
    Private _spare_type As String
    Private _flg_force_vat As Boolean
    Private _flg_edit_sp As Boolean
    Private _export_type As String
    Private _hp_vat As String
    Private _gm_vat As String
    Private _sp_vat As String
    Private _dis_per As String
    Private _fixed_vat As String
    Private _vat_per As String
    Private _ownriskvat As String
    Private _debitor_type As String
    Private _dbt_per As String
    Private _dbt_amt As String
    Private _wo_vat_percentage As String
    Private _wo_spr_discper As String
    Private _sparecount As String
    Private _orgpercent As String
    Private _wo_fixed_vatper As String
    Private _jobvat As String
    Private _labouramt As String
    Private _labourdiscount As String
    Private _gmamount As String
    Private _gmdiscount As String
    Private _ownriskamt As String
    Private _spvat As String
    Private _spamtdeb As String
    Private _wo_cust_groupid As String
    Private _id_make_veh As String
    Private _wo_veh_reg_no As String
    Private _wo_veh_mileage As String
    Private _wo_cr_type As String
    Private _wo_charge_base As String
    Private _id_rppcd_hp As String
    Private _wo_cust_hourlyprice As String
    Private _debSlNo As String
    Private _flgGm As String
    Private _warehouseName As String
    Private _flg_stockitem_status As Boolean
    'Spares stock qty
    Private _id_make_namef As String
    Private _id_make_namet As String
    Private _categoryf As String
    Private _categoryt As String
    Private _id_item_modelf As String
    Private _id_item_modelt As String
    Private _id_itemf As String
    Private _id_itemt As String
    Private _item_descf As String
    Private _item_desct As String
    Private _id_sup_namef As String
    Private _id_sup_namet As String
    Private _id_replacesparef As String
    Private _id_replacesparet As String
    Private _pageindex As Integer
    Private _pagesize As Integer
    Private _sortexpression As String
    Private _isdefault As String
    Private _id_config As String
    Private _remarks As String
    Private _flag As String
    Private _id_def_seq As Integer
    Private _mechanic_doc As String
    Private _bus_pek_control_num As String
    Private _wo_pkkdate As String
    Private _rp_subrepcode_desc As String
    Private _id_subrep_code As String
    Private _id_catg_rp As String
    Private _rpcategory As String
    Private _id_work_cd_rp As String
    Private _workcodecategory As String
    Private _flg_use_std_time As Boolean
    Private _id_rp_prc_grp As String
    Private _pricecodeforjob As String
    Private _wo_vat_calcrisk As String
    Private _wo_discount_base As String
    Private _id_comp_rp As String
    Private _id_stype_rp As String
    Private _flg_use_gm As Boolean
    Private _repcode As String
    Private _repaircode As String
    Private _flg_fix_price As Boolean
    Private _id_operation As String
    Private _job_code As String
    Private _operation_num As String
    Private _first_name As String
    Private _last_name As String
    Private _id_login As String
    Private _id_seq As String
    Private _errMsg As String
    Private _reportPath As String
    Private _id_old_sp_replace As String
    Private _check_valid_std_time As String
    Private _use_confirm_dialogue As String
    Private _jobId As String
    Private _foreignjob As String
    Private _itemdesc As String
    Private _idwodetailseq As String
    Private _idwoitemseq As String
    Private _lineno As Integer
    Private _diff As String
    Private _idwolabseq As String
    Private _idMech As String
    Private _disc_amt As String
    Private _wc As String
    Private _rc As String
    Private _sp_supplierId As String
    Private _sp_FlgStockItem As Boolean
    Private _sp_FlgStockItemStatus As Boolean
    Private _sp_FlgNonStockItemStatus As Boolean
    Private _sp_currNo As String
    Private _sp_Name As String
    Private _sp_StockQty As String
    Private _prInclVat As String
    Private _wo_own_risk_desc As String
    Private _wo_own_risk_slno As Integer
    Private _reductionType As String
    Private _splitPer As String
    Private _debitorDiscount As String
    Private _custLabDiscount As String
    Private _custSpareDiscount As String
    Private _custGenDiscount As String
    Private _spareDiscount As Integer
    Private _debtVatPerc As Decimal

    Public Property Created_By() As String
        Get
            Return _created_by
        End Get
        Set(ByVal Value As String)
            _created_by = Value
        End Set
    End Property
    Public Property Dt_Created() As Date
        Get
            Return _dt_created
        End Get
        Set(ByVal Value As Date)
            _dt_created = Value
        End Set
    End Property
    Public Property Dt_Modified() As Date
        Get
            Return _dt_modified
        End Get
        Set(ByVal Value As Date)
            _dt_modified = Value
        End Set
    End Property
    Public Property Id_Catg_Job() As String
        Get
            Return _id_catg_job
        End Get
        Set(ByVal Value As String)
            _id_catg_job = Value
        End Set
    End Property
    Public Property Id_Item_Job() As String
        Get
            Return _id_item_job
        End Get
        Set(ByVal Value As String)
            _id_item_job = Value
        End Set
    End Property
    Public Property Id_Job() As String
        Get
            Return _id_job
        End Get
        Set(ByVal Value As String)
            _id_job = Value
        End Set
    End Property
    Public Property Id_Make_Job() As String
        Get
            Return _id_make_job
        End Get
        Set(ByVal Value As String)
            _id_make_job = Value
        End Set
    End Property
    Public Property Id_WO_NO() As String
        Get
            Return _id_wo_no
        End Get
        Set(ByVal Value As String)
            _id_wo_no = Value
        End Set
    End Property
    Public Property Job_Text() As String
        Get
            Return _job_text
        End Get
        Set(ByVal Value As String)
            _job_text = Value
        End Set
    End Property
    Public Property Jobi_Bo_Qty() As String
        Get
            Return _jobi_bo_qty
        End Get
        Set(ByVal Value As String)
            _jobi_bo_qty = Value
        End Set
    End Property
    Public Property Jobi_Deliver_Qty() As String
        Get
            Return _jobi_deliver_qty
        End Get
        Set(ByVal Value As String)
            _jobi_deliver_qty = Value
        End Set
    End Property
    Public Property Jobi_Dis_Per() As String
        Get
            Return _jobi_dis_per
        End Get
        Set(ByVal Value As String)
            _jobi_dis_per = Value
        End Set
    End Property
    Public Property Jobi_Order_Qty() As String
        Get
            Return _jobi_order_qty
        End Get
        Set(ByVal Value As String)
            _jobi_order_qty = Value
        End Set
    End Property
    Public Property Jobi_Sell_Price() As String
        Get
            Return _jobi_sell_price
        End Get
        Set(ByVal Value As String)
            _jobi_sell_price = Value
        End Set
    End Property
    Public Property Modified_By() As String
        Get
            Return _modified_by
        End Get
        Set(ByVal Value As String)
            _modified_by = Value
        End Set
    End Property
    Public Property Id_Make_Rp() As String
        Get
            Return _id_make_rp
        End Get
        Set(ByVal Value As String)
            _id_make_rp = Value
        End Set
    End Property
    Public Property Id_Model_Rp() As String
        Get
            Return _id_model_rp
        End Get
        Set(ByVal Value As String)
            _id_model_rp = Value
        End Set
    End Property
    Public Property Id_Rp_Job() As String
        Get
            Return _id_rp_job
        End Get
        Set(ByVal Value As String)
            _id_rp_job = Value
        End Set
    End Property
    Public Property Id_Rc_Job() As String
        Get
            Return _id_rc_job
        End Get
        Set(ByVal Value As String)
            _id_rc_job = Value
        End Set
    End Property
    Public Property Cust_Info() As String
        Get
            Return _cust_info
        End Get
        Set(ByVal Value As String)
            _cust_info = Value
        End Set
    End Property
    Public Property Id_Wodet_Seq() As Integer
        Get
            Return _id_wodet_seq
        End Get
        Set(ByVal Value As Integer)
            _id_wodet_seq = Value
        End Set
    End Property
    Public Property Id_Work_Code_WO() As String
        Get
            Return _id_work_code_wo
        End Get
        Set(ByVal Value As String)
            _id_work_code_wo = Value
        End Set
    End Property
    Public Property Fixed_Price() As String
        Get
            Return _fixed_price
        End Get
        Set(ByVal Value As String)
            _fixed_price = Value
        End Set
    End Property
    Public Property Id_Jobpcd_WO() As String
        Get
            Return _id_jobpcd_wo
        End Get
        Set(ByVal Value As String)
            _id_jobpcd_wo = Value
        End Set
    End Property
    Public Property WO_Planned_Time() As String
        Get
            Return _wo_planned_time
        End Get
        Set(ByVal Value As String)
            _wo_planned_time = Value
        End Set
    End Property
    Public Property Tot_Disc_Amt() As String
        Get
            Return _tot_disc_amt
        End Get
        Set(ByVal Value As String)
            _tot_disc_amt = Value
        End Set
    End Property
    Public Property Stat_Req() As Integer
        Get
            Return _stat_req
        End Get
        Set(ByVal Value As Integer)
            _stat_req = Value
        End Set
    End Property
    Public Property Chrg_Std_Time() As Boolean
        Get
            Return _chrg_std_time
        End Get
        Set(ByVal Value As Boolean)
            _chrg_std_time = Value
        End Set
    End Property
    Public Property Tot_Vat_Amt() As String
        Get
            Return _tot_vat_amt
        End Get
        Set(ByVal Value As String)
            _tot_vat_amt = Value
        End Set
    End Property
    Public Property Tot_Gm_Amt() As String
        Get
            Return _tot_gm_amt
        End Get
        Set(ByVal Value As String)
            _tot_gm_amt = Value
        End Set
    End Property
    Public Property Tot_Spare_Amt() As String
        Get
            Return _tot_spare_amt
        End Get
        Set(ByVal Value As String)
            _tot_spare_amt = Value
        End Set
    End Property
    Public Property Tot_Lab_Amt() As String
        Get
            Return _tot_lab_amt
        End Get
        Set(ByVal Value As String)
            _tot_lab_amt = Value
        End Set
    End Property
    Public Property Own_Risk_Amt() As String
        Get
            Return _own_risk_amt
        End Get
        Set(ByVal Value As String)
            _own_risk_amt = Value
        End Set
    End Property
    Public Property WO_Hourley_Price() As String
        Get
            Return _wo_hourley_price
        End Get
        Set(ByVal Value As String)
            _wo_hourley_price = Value
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
    Public Property WO_Clk_Time() As String
        Get
            Return _wo_clk_time
        End Get
        Set(ByVal Value As String)
            _wo_clk_time = Value
        End Set
    End Property
    Public Property WO_Std_Time() As String
        Get
            Return _wo_std_time
        End Get
        Set(ByVal Value As String)
            _wo_std_time = Value
        End Set
    End Property
    Public Property WO_Chrg_Time() As String
        Get
            Return _wo_chrg_time
        End Get
        Set(ByVal Value As String)
            _wo_chrg_time = Value
        End Set
    End Property
    Public Property Job_Doc() As String
        Get
            Return _job_doc
        End Get
        Set(ByVal Value As String)
            _job_doc = Value
        End Set
    End Property
    Public Property WO_Doc() As String
        Get
            Return _wo_doc
        End Get
        Set(ByVal Value As String)
            _wo_doc = Value
        End Set
    End Property
    Public Property Veh_Grp() As String
        Get
            Return _veh_grp
        End Get
        Set(ByVal Value As String)
            _veh_grp = Value
        End Set
    End Property
    Public Property Mechpcd_HP() As String
        Get
            Return _mechpcd_hp
        End Get
        Set(ByVal Value As String)
            _mechpcd_hp = Value
        End Set
    End Property
    Public Property Tot_Amount() As String
        Get
            Return _tot_amount
        End Get
        Set(ByVal Value As String)
            _tot_amount = Value
        End Set
    End Property
    Public Property WO_Own_Pay_Vat() As Boolean
        Get
            Return _wo_own_pay_vat
        End Get
        Set(ByVal Value As Boolean)
            _wo_own_pay_vat = Value
        End Set
    End Property
    Public Property WO_Id_Veh() As String
        Get
            Return _wo_id_veh
        End Get
        Set(ByVal Value As String)
            _wo_id_veh = Value
        End Set
    End Property
    Public Property Job_Dis() As String
        Get
            Return _job_dis
        End Get
        Set(ByVal Value As String)
            _job_dis = Value
        End Set
    End Property
    Public Property Mec_Det() As String
        Get
            Return _mec_det
        End Get
        Set(ByVal Value As String)
            _mec_det = Value
        End Set
    End Property
    Public Property Dt_Planned() As String
        Get
            Return _dt_planned
        End Get
        Set(ByVal Value As String)
            _dt_planned = Value
        End Set
    End Property
    Public Property Dis_Doc() As String
        Get
            Return _dis_doc
        End Get
        Set(ByVal Value As String)
            _dis_doc = Value
        End Set
    End Property
    Public Property Id_Deb_Seq() As Integer
        Get
            Return _id_deb_seq
        End Get
        Set(ByVal Value As Integer)
            _id_deb_seq = Value
        End Set
    End Property
    Public Property Id_Mech_Comp() As String
        Get
            Return _id_mech_comp
        End Get
        Set(ByVal Value As String)
            _id_mech_comp = Value
        End Set
    End Property
    Public Property Own_Risk_Cust() As String
        Get
            Return _own_risk_cust
        End Get
        Set(ByVal Value As String)
            _own_risk_cust = Value
        End Set
    End Property
    Public Property Own_Risk_Cr_Cust() As String
        Get
            Return _own_risk_cr_cust
        End Get
        Set(ByVal Value As String)
            _own_risk_cr_cust = Value
        End Set
    End Property
    Public Property Id_Ser_Call() As Integer
        Get
            Return _id_ser_call
        End Get
        Set(ByVal Value As Integer)
            _id_ser_call = Value
        End Set
    End Property
    Public Property Id_Warehouse() As Integer
        Get
            Return _id_warehouse
        End Get
        Set(ByVal Value As Integer)
            _id_warehouse = Value
        End Set
    End Property
    Public Property Id_Gm_Vat() As String
        Get
            Return _id_gm_vat
        End Get
        Set(ByVal Value As String)
            _id_gm_vat = Value
        End Set
    End Property
    Public Property Id_Hp_Vat() As String
        Get
            Return _id_hp_vat
        End Get
        Set(ByVal Value As String)
            _id_hp_vat = Value
        End Set
    End Property
    Public Property WO_Incl_Vat() As Boolean
        Get
            Return _wo_incl_vat
        End Get
        Set(ByVal Value As Boolean)
            _wo_incl_vat = Value
        End Set
    End Property
    Public Property WO_Discount() As Decimal
        Get
            Return _wo_discount
        End Get
        Set(ByVal Value As Decimal)
            _wo_discount = Value
        End Set
    End Property
    Public Property Id_Subrep_Code_WO() As Integer
        Get
            Return _id_subrep_code_wo
        End Get
        Set(ByVal Value As Integer)
            _id_subrep_code_wo = Value
        End Set
    End Property
    Public Property WO_Ownriskvat() As Decimal
        Get
            Return _wo_ownriskvat
        End Get
        Set(ByVal Value As Decimal)
            _wo_ownriskvat = Value
        End Set
    End Property
    Public Property HP_Price() As Decimal
        Get
            Return _hp_price
        End Get
        Set(ByVal Value As Decimal)
            _hp_price = Value
        End Set
    End Property
    Public Property Flg_Sprsts() As Boolean
        Get
            Return _flg_sprsts
        End Get
        Set(ByVal Value As Boolean)
            _flg_sprsts = Value
        End Set
    End Property
    Public Property Salesman() As String
        Get
            Return _salesman
        End Get
        Set(ByVal Value As String)
            _salesman = Value
        End Set
    End Property
    Public Property Flg_Vat_Free() As Boolean
        Get
            Return _flg_vat_free
        End Get
        Set(ByVal Value As Boolean)
            _flg_vat_free = Value
        End Set
    End Property
    Public Property Cost_Price() As String
        Get
            Return _cost_price
        End Get
        Set(ByVal Value As String)
            _cost_price = Value
        End Set
    End Property
    Public Property Final_Total() As Decimal
        Get
            Return _final_total
        End Get
        Set(ByVal Value As Decimal)
            _final_total = Value
        End Set
    End Property
    Public Property Final_Vat() As Decimal
        Get
            Return _final_vat
        End Get
        Set(ByVal Value As Decimal)
            _final_vat = Value
        End Set
    End Property
    Public Property Final_Discount() As Decimal
        Get
            Return _final_discount
        End Get
        Set(ByVal Value As Decimal)
            _final_discount = Value
        End Set
    End Property
    Public Property WO_Chrg_Time_Fp() As String
        Get
            Return _wo_chrg_time_fp
        End Get
        Set(ByVal Value As String)
            _wo_chrg_time_fp = Value
        End Set
    End Property
    Public Property Tot_Disc_Amt_Fp() As Decimal
        Get
            Return _tot_disc_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _tot_disc_amt_fp = Value
        End Set
    End Property
    Public Property Tot_Vat_Amt_Fp() As Decimal
        Get
            Return _tot_vat_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _tot_vat_amt_fp = Value
        End Set
    End Property
    Public Property Tot_Gm_Amt_Fp() As Decimal
        Get
            Return _tot_gm_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _tot_gm_amt_fp = Value
        End Set
    End Property
    Public Property Tot_Spare_Amt_Fp() As Decimal
        Get
            Return _tot_spare_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _tot_spare_amt_fp = Value
        End Set
    End Property
    Public Property Tot_Lab_Amt_Fp() As Decimal
        Get
            Return _tot_lab_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _tot_lab_amt_fp = Value
        End Set
    End Property
    Public Property WO_Int_Note() As String
        Get
            Return _wo_int_note
        End Get
        Set(ByVal Value As String)
            _wo_int_note = Value
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
    Public Property Category_Id_Settings() As String
        Get
            Return _category_id_settings
        End Get
        Set(ByVal Value As String)
            _category_id_settings = Value
        End Set
    End Property
    Public Property Category_Description() As String
        Get
            Return _category_description
        End Get
        Set(ByVal Value As String)
            _category_description = Value
        End Set
    End Property
    Public Property Price_Code_Id_Settings() As String
        Get
            Return _price_code_id_settings
        End Get
        Set(ByVal Value As String)
            _price_code_id_settings = Value
        End Set
    End Property
    Public Property Price_Code_Description() As String
        Get
            Return _price_code_description
        End Get
        Set(ByVal Value As String)
            _price_code_description = Value
        End Set
    End Property
    Public Property Id_Rep_Code() As String
        Get
            Return _id_rep_code
        End Get
        Set(ByVal Value As String)
            _id_rep_code = Value
        End Set
    End Property
    Public Property Rp_RepCode_Des() As String
        Get
            Return _rp_repcode_des
        End Get
        Set(ByVal Value As String)
            _rp_repcode_des = Value
        End Set
    End Property
    Public Property Work_Code_Id_Settings() As String
        Get
            Return _work_code_id_settings
        End Get
        Set(ByVal Value As String)
            _work_code_id_settings = Value
        End Set
    End Property
    Public Property Work_Code_Description() As String
        Get
            Return _work_code_description
        End Get
        Set(ByVal Value As String)
            _work_code_description = Value
        End Set
    End Property
    Public Property Mech_Id_Compt() As String
        Get
            Return _mech_id_compt
        End Get
        Set(ByVal Value As String)
            _mech_id_compt = Value
        End Set
    End Property
    Public Property Mech_Compt_Description() As String
        Get
            Return _mech_compt_description
        End Get
        Set(ByVal Value As String)
            _mech_compt_description = Value
        End Set
    End Property
    Public Property Id_StationType() As String
        Get
            Return _id_stationtype
        End Get
        Set(ByVal Value As String)
            _id_stationtype = Value
        End Set
    End Property
    Public Property Station_Type_Description() As String
        Get
            Return _station_type_description
        End Get
        Set(ByVal Value As String)
            _station_type_description = Value
        End Set
    End Property

    Public Property Id_Item() As String
        Get
            Return _id_sp_item
        End Get
        Set(ByVal Value As String)
            _id_sp_item = Value
        End Set
    End Property
    Public Property Id_Sp_Replace() As String
        Get
            Return _id_sp_replace
        End Get
        Set(ByVal Value As String)
            _id_sp_replace = Value
        End Set
    End Property
    Public Property Item_Sp_Desc() As String
        Get
            Return _item_sp_desc
        End Get
        Set(ByVal Value As String)
            _item_sp_desc = Value
        End Set
    End Property
    Public Property Id_Item_Catg() As String
        Get
            Return _id_item_catg
        End Get
        Set(ByVal Value As String)
            _id_item_catg = Value
        End Set
    End Property
    Public Property Id_Make() As String
        Get
            Return _id_make
        End Get
        Set(ByVal Value As String)
            _id_make = Value
        End Set
    End Property
    Public Property Category_Desc() As String
        Get
            Return _catg_desc
        End Get
        Set(ByVal Value As String)
            _catg_desc = Value
        End Set
    End Property
    Public Property Sp_Make() As String
        Get
            Return _sp_make
        End Get
        Set(ByVal Value As String)
            _sp_make = Value
        End Set
    End Property
    Public Property Item_Avail_Qty() As Decimal
        Get
            Return _item_avail_qty
        End Get
        Set(ByVal Value As Decimal)
            _item_avail_qty = Value
        End Set
    End Property
    Public Property Flg_Allow_Bckord() As Boolean
        Get
            Return _flg_allow_bckord
        End Get
        Set(ByVal Value As Boolean)
            _flg_allow_bckord = Value
        End Set
    End Property
    Public Property Jobi_Dis_Seq() As Integer
        Get
            Return _jobi_dis_seq
        End Get
        Set(ByVal Value As Integer)
            _jobi_dis_seq = Value
        End Set
    End Property
    Public Property Jobi_Vat_Per() As String
        Get
            Return _jobi_vat_per
        End Get
        Set(ByVal Value As String)
            _jobi_vat_per = Value
        End Set
    End Property
    Public Property Jobi_Vat_Seq() As Integer
        Get
            Return _jobi_vat_seq
        End Get
        Set(ByVal Value As Integer)
            _jobi_vat_seq = Value
        End Set
    End Property
    Public Property Sp_Item_Price() As String
        Get
            Return _sp_item_price
        End Get
        Set(ByVal Value As String)
            _sp_item_price = Value
        End Set
    End Property
    Public Property Sp_Cost_Price() As Decimal
        Get
            Return _sp_cost_price
        End Get
        Set(ByVal Value As Decimal)
            _sp_cost_price = Value
        End Set
    End Property
    Public Property Sp_Disc_Code_Sell() As String
        Get
            Return _sp_disc_code_sell
        End Get
        Set(ByVal Value As String)
            _sp_disc_code_sell = Value
        End Set
    End Property
    Public Property Sp_Disc_Code_Buy() As String
        Get
            Return _sp_disc_code_buy
        End Get
        Set(ByVal Value As String)
            _sp_disc_code_buy = Value
        End Set
    End Property
    Public Property Sp_Location() As String
        Get
            Return _sp_location
        End Get
        Set(ByVal Value As String)
            _sp_location = Value
        End Set
    End Property
    Public Property Sp_Item_Description() As String
        Get
            Return _sp_item_description
        End Get
        Set(ByVal Value As String)
            _sp_item_description = Value
        End Set
    End Property
    Public Property Sp_I_Item() As String
        Get
            Return _sp_i_item
        End Get
        Set(ByVal Value As String)
            _sp_i_item = Value
        End Set
    End Property
    Public Property Id_Wh_Item() As Integer
        Get
            Return _id_wh_item
        End Get
        Set(ByVal Value As Integer)
            _id_wh_item = Value
        End Set
    End Property
    Public Property Env_Id_Item() As String
        Get
            Return _env_id_item
        End Get
        Set(ByVal Value As String)
            _env_id_item = Value
        End Set
    End Property
    Public Property Env_Id_Make() As String
        Get
            Return _env_id_make
        End Get
        Set(ByVal Value As String)
            _env_id_make = Value
        End Set
    End Property
    Public Property Env_Id_Warehouse() As String
        Get
            Return _env_id_warehouse
        End Get
        Set(ByVal Value As String)
            _env_id_warehouse = Value
        End Set
    End Property
    Public Property Flg_Efd() As Boolean
        Get
            Return _flg_efd
        End Get
        Set(ByVal Value As Boolean)
            _flg_efd = Value
        End Set
    End Property
    Public Property Id_Customer() As String
        Get
            Return _id_customer
        End Get
        Set(ByVal Value As String)
            _id_customer = Value
        End Set
    End Property
    Public Property Id_Rpg_Catg_WO() As String
        Get
            Return _id_rpg_catg_wo
        End Get
        Set(ByVal Value As String)
            _id_rpg_catg_wo = Value
        End Set
    End Property
    Public Property Id_Rpg_Code_WO() As String
        Get
            Return _id_rpg_code_wo
        End Get
        Set(ByVal Value As String)
            _id_rpg_code_wo = Value
        End Set
    End Property
    Public Property Rp_Desc() As String
        Get
            Return _rp_desc
        End Get
        Set(ByVal Value As String)
            _rp_desc = Value
        End Set
    End Property
    Public Property Id_Rep_Code_WO() As Integer
        Get
            Return _id_rep_code_wo
        End Get
        Set(ByVal Value As Integer)
            _id_rep_code_wo = Value
        End Set
    End Property
    Public Property WO_Fixed_Price() As Decimal
        Get
            Return _wo_fixed_price
        End Get
        Set(ByVal Value As Decimal)
            _wo_fixed_price = Value
        End Set
    End Property
    Public Property WO_Gm_Per() As String
        Get
            Return _wo_gm_per
        End Get
        Set(ByVal Value As String)
            _wo_gm_per = Value
        End Set
    End Property
    Public Property WO_Gm_Vatper() As Decimal
        Get
            Return _wo_gm_vatper
        End Get
        Set(ByVal Value As Decimal)
            _wo_gm_vatper = Value
        End Set
    End Property
    Public Property WO_Lbr_Vatper() As Decimal
        Get
            Return _wo_lbr_vatper
        End Get
        Set(ByVal Value As Decimal)
            _wo_lbr_vatper = Value
        End Set
    End Property
    Public Property Flg_Chrg_Std_Time() As Boolean
        Get
            Return _flg_chrg_std_time
        End Get
        Set(ByVal Value As Boolean)
            _flg_chrg_std_time = Value
        End Set
    End Property
    Public Property Flg_Stat_Req() As Boolean
        Get
            Return _flg_stat_req
        End Get
        Set(ByVal Value As Boolean)
            _flg_stat_req = Value
        End Set
    End Property
    Public Property WO_Job_Txt() As String
        Get
            Return _wo_job_txt
        End Get
        Set(ByVal Value As String)
            _wo_job_txt = Value
        End Set
    End Property
    Public Property WO_Own_Risk_Amt() As Decimal
        Get
            Return _wo_own_risk_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_own_risk_amt = Value
        End Set
    End Property
    Public Property WO_Tot_Lab_Amt() As Decimal
        Get
            Return _wo_tot_lab_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_lab_amt = Value
        End Set
    End Property
    Public Property WO_Tot_Spare_Amt() As Decimal
        Get
            Return _wo_tot_spare_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_spare_amt = Value
        End Set
    End Property
    Public Property WO_Tot_Gm_Amt() As Decimal
        Get
            Return _wo_tot_gm_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_gm_amt = Value
        End Set
    End Property
    Public Property WO_Tot_Vat_Amt() As Decimal
        Get
            Return _wo_tot_vat_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_vat_amt = Value
        End Set
    End Property
    Public Property WO_Tot_Disc_Amt() As Decimal
        Get
            Return _wo_tot_disc_amt
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_disc_amt = Value
        End Set
    End Property
    Public Property WO_Own_Cr_Custname() As String
        Get
            Return _wo_own_cr_custname
        End Get
        Set(ByVal Value As String)
            _wo_own_cr_custname = Value
        End Set
    End Property
    Public Property WO_Own_Risk_Cust() As String
        Get
            Return _wo_own_risk_cust
        End Get
        Set(ByVal Value As String)
            _wo_own_risk_cust = Value
        End Set
    End Property
    Public Property WO_Own_Cr_Cust() As String
        Get
            Return _wo_own_cr_cust
        End Get
        Set(ByVal Value As String)
            _wo_own_cr_cust = Value
        End Set
    End Property
    Public Property Id_Stype_WO() As String
        Get
            Return _id_stype_wo
        End Get
        Set(ByVal Value As String)
            _id_stype_wo = Value
        End Set
    End Property
    Public Property Ownriskvatamt() As Decimal
        Get
            Return _ownriskvatamt
        End Get
        Set(ByVal Value As Decimal)
            _ownriskvatamt = Value
        End Set
    End Property
    Public Property WO_Tot_Disc_Amt_Fp() As Decimal
        Get
            Return _wo_tot_disc_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_disc_amt_fp = Value
        End Set
    End Property
    Public Property WO_Tot_Gm_Amt_Fp() As Decimal
        Get
            Return _wo_tot_gm_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_gm_amt_fp = Value
        End Set
    End Property
    Public Property WO_Tot_Lab_Amt_Fp() As Decimal
        Get
            Return _wo_tot_lab_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_lab_amt_fp = Value
        End Set
    End Property
    Public Property WO_Tot_Spare_Amt_Fp() As Decimal
        Get
            Return _wo_tot_spare_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_spare_amt_fp = Value
        End Set
    End Property
    Public Property WO_Tot_Vat_Amt_Fp() As Decimal
        Get
            Return _wo_tot_vat_amt_fp
        End Get
        Set(ByVal Value As Decimal)
            _wo_tot_vat_amt_fp = Value
        End Set
    End Property
    Public Property Flg_Val_Stdtime() As Boolean
        Get
            Return _flg_val_stdtime
        End Get
        Set(ByVal Value As Boolean)
            _flg_val_stdtime = Value
        End Set
    End Property
    Public Property Flg_Val_Mileage() As Boolean
        Get
            Return _flg_val_mileage
        End Get
        Set(ByVal Value As Boolean)
            _flg_val_mileage = Value
        End Set
    End Property
    Public Property Flg_Saveupddp() As Boolean
        Get
            Return _flg_saveupddp
        End Get
        Set(ByVal Value As Boolean)
            _flg_saveupddp = Value
        End Set
    End Property
    Public Property Flg_Edtchgtime() As Boolean
        Get
            Return _flg_edtchgtime
        End Get
        Set(ByVal Value As Boolean)
            _flg_edtchgtime = Value
        End Set
    End Property
    Public Property Internal_Note() As String
        Get
            Return _internal_note
        End Get
        Set(ByVal Value As String)
            _internal_note = Value
        End Set
    End Property
    Public Property WO_Own_Risk_Custname() As String
        Get
            Return _wo_own_risk_custname
        End Get
        Set(ByVal Value As String)
            _wo_own_risk_custname = Value
        End Set
    End Property
    Public Property Flg_Disp_Int_Note() As Boolean
        Get
            Return _flg_disp_int_note
        End Get
        Set(ByVal Value As Boolean)
            _flg_disp_int_note = Value
        End Set
    End Property
    Public Property Id_Job_Deb() As String
        Get
            Return _id_job_deb
        End Get
        Set(ByVal Value As String)
            _id_job_deb = Value
        End Set
    End Property
    Public Property Job_Deb_Name() As String
        Get
            Return _job_deb_name
        End Get
        Set(ByVal Value As String)
            _job_deb_name = Value
        End Set
    End Property
    Public Property Id_WOItem_Seq() As Integer
        Get
            Return _id_woitem_seq
        End Get
        Set(ByVal Value As Integer)
            _id_woitem_seq = Value
        End Set
    End Property
    Public Property Sp_Slno() As String
        Get
            Return _sp_slno
        End Get
        Set(ByVal Value As String)
            _sp_slno = Value
        End Set
    End Property
    Public Property Id_Item_Catg_Job_Id() As String
        Get
            Return _id_item_catg_job_id
        End Get
        Set(ByVal Value As String)
            _id_item_catg_job_id = Value
        End Set
    End Property
    Public Property Order_Line_Text() As String
        Get
            Return _order_line_text
        End Get
        Set(ByVal Value As String)
            _order_line_text = Value
        End Set
    End Property
    Public Property Td_Calc() As String
        Get
            Return _td_calc
        End Get
        Set(ByVal Value As String)
            _td_calc = Value
        End Set
    End Property
    Public Property Text() As String
        Get
            Return _text
        End Get
        Set(ByVal Value As String)
            _text = Value
        End Set
    End Property
    Public Property Pickinglist_Prev_Printed() As Boolean
        Get
            Return _pickinglist_prev_printed
        End Get
        Set(ByVal Value As Boolean)
            _pickinglist_prev_printed = Value
        End Set
    End Property
    Public Property Deliverynote_Prev_Printed() As Boolean
        Get
            Return _deliverynote_prev_printed
        End Get
        Set(ByVal Value As Boolean)
            _deliverynote_prev_printed = Value
        End Set
    End Property
    Public Property Prev_Picked() As String
        Get
            Return _prev_picked
        End Get
        Set(ByVal Value As String)
            _prev_picked = Value
        End Set
    End Property
    Public Property Spare_Type() As String
        Get
            Return _spare_type
        End Get
        Set(ByVal Value As String)
            _spare_type = Value
        End Set
    End Property
    Public Property Flg_Force_Vat() As Boolean
        Get
            Return _flg_force_vat
        End Get
        Set(ByVal Value As Boolean)
            _flg_force_vat = Value
        End Set
    End Property
    Public Property Flg_Edit_Sp() As Boolean
        Get
            Return _flg_edit_sp
        End Get
        Set(ByVal Value As Boolean)
            _flg_edit_sp = Value
        End Set
    End Property
    Public Property Export_Type() As String
        Get
            Return _export_type
        End Get
        Set(ByVal Value As String)
            _export_type = Value
        End Set
    End Property
    Public Property HP_Vat() As String
        Get
            Return _hp_vat
        End Get
        Set(ByVal Value As String)
            _hp_vat = Value
        End Set
    End Property
    Public Property GM_Vat() As String
        Get
            Return _gm_vat
        End Get
        Set(ByVal Value As String)
            _gm_vat = Value
        End Set
    End Property
    Public Property SP_Vat() As String
        Get
            Return _sp_vat
        End Get
        Set(ByVal Value As String)
            _sp_vat = Value
        End Set
    End Property
    Public Property Dis_Per() As String
        Get
            Return _dis_per
        End Get
        Set(ByVal Value As String)
            _dis_per = Value
        End Set
    End Property
    Public Property Fixed_Vat() As String
        Get
            Return _fixed_vat
        End Get
        Set(ByVal Value As String)
            _fixed_vat = Value
        End Set
    End Property
    Public Property Vat_Per() As String
        Get
            Return _vat_per
        End Get
        Set(ByVal Value As String)
            _vat_per = Value
        End Set
    End Property
    Public Property Ownriskvat() As String
        Get
            Return _ownriskvat
        End Get
        Set(ByVal Value As String)
            _ownriskvat = Value
        End Set
    End Property
    Public Property Debitor_Type() As String
        Get
            Return _debitor_type
        End Get
        Set(ByVal Value As String)
            _debitor_type = Value
        End Set
    End Property
    Public Property Dbt_Per() As String
        Get
            Return _dbt_per
        End Get
        Set(ByVal Value As String)
            _dbt_per = Value
        End Set
    End Property
    Public Property Dbt_Amt() As String
        Get
            Return _dbt_amt
        End Get
        Set(ByVal Value As String)
            _dbt_amt = Value
        End Set
    End Property
    Public Property GarageMat() As String
        Get
            Return _garageMat
        End Get
        Set(ByVal Value As String)
            _garageMat = Value
        End Set
    End Property
    Public Property ChrgTime() As String
        Get
            Return _chrgTime
        End Get
        Set(ByVal Value As String)
            _chrgTime = Value
        End Set
    End Property
    Public Property WO_Cust_Groupid() As String
        Get
            Return _wo_cust_groupid
        End Get
        Set(ByVal Value As String)
            _wo_cust_groupid = Value
        End Set
    End Property
    Public Property Id_Make_Veh() As String
        Get
            Return _id_make_veh
        End Get
        Set(ByVal Value As String)
            _id_make_veh = Value
        End Set
    End Property
    Public Property WO_Veh_Reg_No() As String
        Get
            Return _wo_veh_reg_no
        End Get
        Set(ByVal Value As String)
            _wo_veh_reg_no = Value
        End Set
    End Property
    Public Property WO_Veh_Mileage() As String
        Get
            Return _wo_veh_mileage
        End Get
        Set(ByVal Value As String)
            _wo_veh_mileage = Value
        End Set
    End Property
    Public Property WO_Cr_Type() As String
        Get
            Return _wo_cr_type
        End Get
        Set(ByVal Value As String)
            _wo_cr_type = Value
        End Set
    End Property
    Public Property WO_Charge_Base() As String
        Get
            Return _wo_charge_base
        End Get
        Set(ByVal Value As String)
            _wo_charge_base = Value
        End Set
    End Property
    Public Property Id_RpPcd_Hp() As String
        Get
            Return _id_rppcd_hp
        End Get
        Set(ByVal Value As String)
            _id_rppcd_hp = Value
        End Set
    End Property
    Public Property WO_Cust_HourlyPrice() As String
        Get
            Return _wo_cust_hourlyprice
        End Get
        Set(ByVal Value As String)
            _wo_cust_hourlyprice = Value
        End Set
    End Property
    Public Property Deb_Sl_No() As String
        Get
            Return _debSlNo
        End Get
        Set(ByVal Value As String)
            _debSlNo = Value
        End Set
    End Property
    Public Property Spare_Count() As String
        Get
            Return _sparecount
        End Get
        Set(ByVal Value As String)
            _sparecount = Value
        End Set
    End Property
    Public Property Org_Per() As String
        Get
            Return _orgpercent
        End Get
        Set(ByVal Value As String)
            _orgpercent = Value
        End Set
    End Property
    Public Property Flg_Gm() As String
        Get
            Return _flgGm
        End Get
        Set(ByVal Value As String)
            _flgGm = Value
        End Set
    End Property
    Public Property WarehouseName() As String
        Get
            Return _warehouseName
        End Get
        Set(ByVal Value As String)
            _warehouseName = Value
        End Set
    End Property
    Public Property Flg_StockItem_Status() As String
        Get
            Return _flg_stockitem_status
        End Get
        Set(ByVal Value As String)
            _flg_stockitem_status = Value
        End Set
    End Property
    Public Property Id_Make_NameF() As String
        Get
            Return _id_make_namef
        End Get
        Set(ByVal Value As String)
            _id_make_namef = Value
        End Set
    End Property
    Public Property Id_Make_NameT() As String
        Get
            Return _id_make_namet
        End Get
        Set(ByVal Value As String)
            _id_make_namet = Value
        End Set
    End Property
    Public Property CategoryF() As String
        Get
            Return _categoryf
        End Get
        Set(ByVal Value As String)
            _categoryf = Value
        End Set
    End Property
    Public Property CategoryT() As String
        Get
            Return _categoryt
        End Get
        Set(ByVal Value As String)
            _categoryt = Value
        End Set
    End Property
    Public Property Id_Item_ModelF() As String
        Get
            Return _id_item_modelf
        End Get
        Set(ByVal Value As String)
            _id_item_modelf = Value
        End Set
    End Property
    Public Property Id_Item_ModelT() As String
        Get
            Return _id_item_modelt
        End Get
        Set(ByVal Value As String)
            _id_item_modelt = Value
        End Set
    End Property
    Public Property Id_ItemF() As String
        Get
            Return _id_itemf
        End Get
        Set(ByVal Value As String)
            _id_itemf = Value
        End Set
    End Property
    Public Property Id_ItemT() As String
        Get
            Return _id_itemt
        End Get
        Set(ByVal Value As String)
            _id_itemt = Value
        End Set
    End Property
    Public Property Item_DescF() As String
        Get
            Return _item_descf
        End Get
        Set(ByVal Value As String)
            _item_descf = Value
        End Set
    End Property
    Public Property Item_DescT() As String
        Get
            Return _item_desct
        End Get
        Set(ByVal Value As String)
            _item_desct = Value
        End Set
    End Property
    Public Property Id_Sup_NameF() As String
        Get
            Return _id_sup_namef
        End Get
        Set(ByVal Value As String)
            _id_sup_namef = Value
        End Set
    End Property
    Public Property Id_Sup_NameT() As String
        Get
            Return _id_sup_namet
        End Get
        Set(ByVal Value As String)
            _id_sup_namet = Value
        End Set
    End Property
    Public Property Id_ReplaceSpareF() As String
        Get
            Return _id_replacesparef
        End Get
        Set(ByVal Value As String)
            _id_replacesparef = Value
        End Set
    End Property
    Public Property Id_ReplaceSpareT() As String
        Get
            Return _id_replacesparet
        End Get
        Set(ByVal Value As String)
            _id_replacesparet = Value
        End Set
    End Property
    Public Property PageIndex() As String
        Get
            Return _pageindex
        End Get
        Set(ByVal Value As String)
            _pageindex = Value
        End Set
    End Property
    Public Property PageSize() As String
        Get
            Return _pagesize
        End Get
        Set(ByVal Value As String)
            _pagesize = Value
        End Set
    End Property
    Public Property SortExpression() As String
        Get
            Return _sortexpression
        End Get
        Set(ByVal Value As String)
            _sortexpression = Value
        End Set
    End Property
    Public Property IsDefault() As String
        Get
            Return _isdefault
        End Get
        Set(ByVal Value As String)
            _isdefault = Value
        End Set
    End Property
    Public Property IdConfig() As String
        Get
            Return _id_config
        End Get
        Set(ByVal Value As String)
            _id_config = Value
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
    Public Property Flag() As String
        Get
            Return _flag
        End Get
        Set(ByVal Value As String)
            _flag = Value
        End Set
    End Property
    Public Property Id_Def_Seq() As Integer
        Get
            Return _id_def_seq
        End Get
        Set(ByVal Value As Integer)
            _id_def_seq = Value
        End Set
    End Property
    Public Property Mechanic_Doc() As String
        Get
            Return _mechanic_doc
        End Get
        Set(ByVal Value As String)
            _mechanic_doc = Value
        End Set
    End Property
    Public Property Bus_Pek_Control_Num() As String
        Get
            Return _bus_pek_control_num
        End Get
        Set(ByVal Value As String)
            _bus_pek_control_num = Value
        End Set
    End Property
    Public Property WO_PKKDate() As String
        Get
            Return _wo_pkkdate
        End Get
        Set(ByVal Value As String)
            _wo_pkkdate = Value
        End Set
    End Property
    Public Property Rp_SubRepCode_Desc() As String
        Get
            Return _rp_subrepcode_desc
        End Get
        Set(ByVal Value As String)
            _rp_subrepcode_desc = Value
        End Set
    End Property
    Public Property Id_SubRepCode() As String
        Get
            Return _id_subrep_code
        End Get
        Set(ByVal Value As String)
            _id_subrep_code = Value
        End Set
    End Property
    Public Property Id_Catg_Rp() As String
        Get
            Return _id_catg_rp
        End Get
        Set(ByVal Value As String)
            _id_catg_rp = Value
        End Set
    End Property
    Public Property RpCategory() As String
        Get
            Return _rpcategory
        End Get
        Set(ByVal Value As String)
            _rpcategory = Value
        End Set
    End Property
    Public Property Id_Work_Cd_Rp() As String
        Get
            Return _id_work_cd_rp
        End Get
        Set(ByVal Value As String)
            _id_work_cd_rp = Value
        End Set
    End Property
    Public Property WorkCodeCategory() As String
        Get
            Return _workcodecategory
        End Get
        Set(ByVal Value As String)
            _workcodecategory = Value
        End Set
    End Property
    Public Property Flg_Use_Std_Time() As Boolean
        Get
            Return _flg_use_std_time
        End Get
        Set(ByVal Value As Boolean)
            _flg_use_std_time = Value
        End Set
    End Property
    Public Property Id_Rp_Prc_Grp() As String
        Get
            Return _id_rp_prc_grp
        End Get
        Set(ByVal Value As String)
            _id_rp_prc_grp = Value
        End Set
    End Property
    Public Property PriceCodeforJob() As String
        Get
            Return _pricecodeforjob
        End Get
        Set(ByVal Value As String)
            _pricecodeforjob = Value
        End Set
    End Property
    Public Property WO_Vat_Calcrisk() As String
        Get
            Return _wo_vat_calcrisk
        End Get
        Set(ByVal Value As String)
            _wo_vat_calcrisk = Value
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
    Public Property Id_Comp_Rp() As String
        Get
            Return _id_comp_rp
        End Get
        Set(ByVal Value As String)
            _id_comp_rp = Value
        End Set
    End Property
    Public Property Id_Stype_Rp() As String
        Get
            Return _id_stype_rp
        End Get
        Set(ByVal Value As String)
            _id_stype_rp = Value
        End Set
    End Property
    Public Property Flg_Use_Gm() As Boolean
        Get
            Return _flg_use_gm
        End Get
        Set(ByVal Value As Boolean)
            _flg_use_gm = Value
        End Set
    End Property
    Public Property RepCode() As String
        Get
            Return _repcode
        End Get
        Set(ByVal Value As String)
            _repcode = Value
        End Set
    End Property
    Public Property RepairCode() As String
        Get
            Return _repaircode
        End Get
        Set(ByVal Value As String)
            _repaircode = Value
        End Set
    End Property
    Public Property Flg_Fix_Price() As Boolean
        Get
            Return _flg_fix_price
        End Get
        Set(ByVal Value As Boolean)
            _flg_fix_price = Value
        End Set
    End Property
    Public Property Id_Operation() As String
        Get
            Return _id_operation
        End Get
        Set(ByVal Value As String)
            _id_operation = Value
        End Set
    End Property
    Public Property Job_Code() As String
        Get
            Return _job_code
        End Get
        Set(ByVal Value As String)
            _job_code = Value
        End Set
    End Property
    Public Property Operation_Num() As String
        Get
            Return _operation_num
        End Get
        Set(ByVal Value As String)
            _operation_num = Value
        End Set
    End Property
    Public Property First_Name() As String
        Get
            Return _first_name
        End Get
        Set(ByVal Value As String)
            _first_name = Value
        End Set
    End Property
    Public Property Last_Name() As String
        Get
            Return _last_name
        End Get
        Set(ByVal Value As String)
            _last_name = Value
        End Set
    End Property
    Public Property Id_Login() As String
        Get
            Return _id_login
        End Get
        Set(ByVal Value As String)
            _id_login = Value
        End Set
    End Property
    Public Property Id_Seq() As String
        Get
            Return _id_seq
        End Get
        Set(ByVal Value As String)
            _id_seq = Value
        End Set
    End Property
    Public Property ErrMsg() As String
        Get
            Return _errMsg
        End Get
        Set(ByVal Value As String)
            _errMsg = Value
        End Set
    End Property
    Public Property ToBe_Picked() As String
        Get
            Return _tobe_picked
        End Get
        Set(ByVal Value As String)
            _tobe_picked = Value
        End Set
    End Property
    Public Property ReportPath() As String
        Get
            Return _reportPath
        End Get
        Set(ByVal Value As String)
            _reportPath = Value
        End Set
    End Property
    Public Property Id_Old_Sp_Replace() As String
        Get
            Return _id_old_sp_replace
        End Get
        Set(ByVal Value As String)
            _id_old_sp_replace = Value
        End Set
    End Property
    Public Property Use_Confirm_Dialogue() As String
        Get
            Return _use_confirm_dialogue
        End Get
        Set(ByVal Value As String)
            _use_confirm_dialogue = Value
        End Set
    End Property
    Public Property Check_Valid_Std_Time() As String
        Get
            Return _check_valid_std_time
        End Get
        Set(ByVal Value As String)
            _check_valid_std_time = Value
        End Set
    End Property
    Private _idjob As String
    Private _nei As String
    Private _ford As Integer
    Private _bestilt As String
    Private _levert As String
    Private _pris As String
    Private _rab As String
    Private _belop As String
    Private _mechanicName As String
    Private _debtType As String
    'New Objects
    Public Property IdJob() As String
        Get
            Return _idjob
        End Get
        Set(ByVal Value As String)
            _idjob = Value
        End Set
    End Property
    Public Property Nei() As String
        Get
            Return _nei
        End Get
        Set(ByVal Value As String)
            _nei = Value
        End Set
    End Property
    Public Property Ford() As Integer
        Get
            Return _ford
        End Get
        Set(ByVal Value As Integer)
            _ford = Value
        End Set
    End Property
    Public Property Bestilt() As String
        Get
            Return _bestilt
        End Get
        Set(ByVal Value As String)
            _bestilt = Value
        End Set
    End Property
    Public Property Levert() As String
        Get
            Return _levert
        End Get
        Set(ByVal Value As String)
            _levert = Value
        End Set
    End Property
    Public Property Pris() As String
        Get
            Return _pris
        End Get
        Set(ByVal Value As String)
            _pris = Value
        End Set
    End Property
    Public Property Rab() As String
        Get
            Return _rab
        End Get
        Set(ByVal Value As String)
            _rab = Value
        End Set
    End Property
    Public Property Belop() As String
        Get
            Return _belop
        End Get
        Set(ByVal Value As String)
            _belop = Value
        End Set
    End Property
    Public Property JobId() As String
        Get
            Return _jobId
        End Get
        Set(ByVal Value As String)
            _jobId = Value
        End Set
    End Property
    Public Property ForeignJob() As String
        Get
            Return _foreignjob
        End Get
        Set(ByVal Value As String)
            _foreignjob = Value
        End Set
    End Property
    Public Property ItemDesc() As String
        Get
            Return _itemdesc
        End Get
        Set(ByVal Value As String)
            _itemdesc = Value
        End Set
    End Property
    Public Property IdWODetailseq() As String
        Get
            Return _idwodetailseq
        End Get
        Set(ByVal Value As String)
            _idwodetailseq = Value
        End Set
    End Property
    Public Property IdWOItemseq() As String
        Get
            Return _idwoitemseq
        End Get
        Set(ByVal Value As String)
            _idwoitemseq = Value
        End Set
    End Property
    Public Property LineNo() As Integer
        Get
            Return _lineno
        End Get
        Set(ByVal Value As Integer)
            _lineno = Value
        End Set
    End Property

    Public Property Diff() As String
        Get
            Return _diff
        End Get
        Set(ByVal Value As String)
            _diff = Value
        End Set
    End Property
    Public Property IdWOLabSeq() As String
        Get
            Return _idwolabseq
        End Get
        Set(ByVal Value As String)
            _idwolabseq = Value
        End Set
    End Property
    Public Property IdMech() As String
        Get
            Return _idMech
        End Get
        Set(ByVal Value As String)
            _idMech = Value
        End Set
    End Property
    Public Property Disc_Amt() As String
        Get
            Return _disc_amt
        End Get
        Set(ByVal Value As String)
            _disc_amt = Value
        End Set
    End Property
    Public Property WC() As String
        Get
            Return _wc
        End Get
        Set(ByVal Value As String)
            _wc = Value
        End Set
    End Property
    Public Property RC() As String
        Get
            Return _rc
        End Get
        Set(ByVal Value As String)
            _rc = Value
        End Set
    End Property
    Public Property SP_SupplierID() As String
        Get
            Return _sp_supplierId
        End Get
        Set(ByVal Value As String)
            _sp_supplierId = Value
        End Set
    End Property
    Public Property Sp_FlgStockItem() As Boolean
        Get
            Return _sp_FlgStockItem
        End Get
        Set(ByVal Value As Boolean)
            _sp_FlgStockItem = Value
        End Set
    End Property
    Public Property SP_FlgStockItemStatus() As Boolean
        Get
            Return _sp_FlgStockItemStatus
        End Get
        Set(ByVal Value As Boolean)
            _sp_FlgStockItemStatus = Value
        End Set
    End Property
    Public Property SP_FlgNonStockItemStatus() As Boolean
        Get
            Return _sp_FlgNonStockItemStatus
        End Get
        Set(ByVal Value As Boolean)
            _sp_FlgNonStockItemStatus = Value
        End Set
    End Property
    Public Property SP_CurrentNo() As String
        Get
            Return _sp_currNo
        End Get
        Set(ByVal Value As String)
            _sp_currNo = Value
        End Set
    End Property
    Public Property SP_SupplierName() As String
        Get
            Return _sp_Name
        End Get
        Set(ByVal Value As String)
            _sp_Name = Value
        End Set
    End Property
    Public Property Sp_StockQty() As String
        Get
            Return _sp_StockQty
        End Get
        Set(ByVal Value As String)
            _sp_StockQty = Value
        End Set
    End Property
    Public Property PriceInclVat() As String
        Get
            Return _prInclVat
        End Get
        Set(ByVal Value As String)
            _prInclVat = Value
        End Set
    End Property
    Public Property MechanicName() As String
        Get
            Return _mechanicName
        End Get
        Set(ByVal Value As String)
            _mechanicName = Value
        End Set
    End Property
    Public Property DebtType() As String
        Get
            Return _debtType
        End Get
        Set(ByVal Value As String)
            _debtType = Value
        End Set
    End Property
    Public Property WO_Own_Risk_Desc() As String
        Get
            Return _wo_own_risk_desc
        End Get
        Set(ByVal Value As String)
            _wo_own_risk_desc = Value
        End Set
    End Property
    Public Property WO_Own_Risk_SlNo() As Integer
        Get
            Return _wo_own_risk_slno
        End Get
        Set(ByVal Value As Integer)
            _wo_own_risk_slno = Value
        End Set
    End Property
    Public Property ReductionType() As String
        Get
            Return _reductionType
        End Get
        Set(ByVal Value As String)
            _reductionType = Value
        End Set
    End Property
    Public Property SplitPercent() As String
        Get
            Return _splitPer
        End Get
        Set(ByVal Value As String)
            _splitPer = Value
        End Set
    End Property
    Public Property DebitorDiscount() As String
        Get
            Return _debitorDiscount
        End Get
        Set(ByVal Value As String)
            _debitorDiscount = Value
        End Set
    End Property
    Public Property CustLabDiscount() As String
        Get
            Return _custLabDiscount
        End Get
        Set(ByVal Value As String)
            _custLabDiscount = Value
        End Set
    End Property
    Public Property CustSpareDiscount() As String
            Get
                Return _custSpareDiscount
            End Get
            Set(ByVal Value As String)
                _custSpareDiscount = Value
            End Set
        End Property
    Public Property CustGenDiscount() As String
            Get
                Return _custGenDiscount
            End Get
            Set(ByVal Value As String)
                _custGenDiscount = Value
            End Set
    End Property
    Public Property SpareDiscount() As Integer
        Get
            Return _spareDiscount
        End Get
        Set(ByVal Value As Integer)
            _spareDiscount = Value
        End Set
    End Property
    Public Property DebtVatPercentage() As Decimal
        Get
            Return _debtVatPerc
        End Get
        Set(ByVal Value As Decimal)
            _debtVatPerc = Value
        End Set
    End Property

End Class


