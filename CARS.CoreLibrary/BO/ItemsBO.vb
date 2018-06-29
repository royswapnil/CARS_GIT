Public Class ItemsBO
    'Private _ID_ITEM As String
    'Private _ITEM_DESC
    'Private _ID_MAKE
    'Private _ITEM_DISC_CODE
    'Private _ID_SUPPLIER_ITEM
    'Private _SUP_Name
    'Private LOCATION
    'Private ALT_LOCATION
    'Private PACAKGE_QTY
    'Private ANNOTATION
    'Private PREVIOUS_ITEM_ID
    'Private NEW_ITEM_ID
    'Private BASIC_PRICE
    'Private AVG_PRICE
    'Private LAST_COST_PRICE
    'Private ITEM_PRICE

    'Private FLG_STOCK_ITEM
    'Private FLG_VAT_INCL
    'Private FLGOBTAIN_SPARE
    'Private FLG_OBSOLETE_SPARE
    'Private FLG_BLOCK_AUTO_ORD
    'Private FLG_AUTOADJUST_PRICE
    'Private FLG_LABELS
    'Private FLG_ALLOW_DISCOUNT
    'Private DISCOUNT

    'Private DT_CREATED
    'Private CREATED_BY
    'Private DT_MODIFIED
    'Private MODIFIED_BY


    Public Property ID_ITEM As String
    Public Property ITEM_DESC As String
    Public Property ID_MAKE As String
    Public Property ID_MAKE_NAME As String
    Public Property ITEM_DISC_CODE As Integer
    Public Property ITEM_DISC_CODE_BUY As String
    Public Property ID_SUPPLIER_ITEM As String
    Public Property SUP_Name As String
    Public Property LOCATION As String
    Public Property ALT_LOCATION As String
    Public Property PACKAGE_QTY As String
    Public Property ANNOTATION As String
    Public Property PREVIOUS_ITEM_ID As String
    Public Property NEW_ITEM_ID As String
    Public Property BASIC_PRICE As String
    Public Property AVG_PRICE As String
    Public Property LAST_COST_PRICE As String
    Public Property COST_PRICE1 As String
    Public Property COST_PRICE2 As String
    Public Property ITEM_PRICE As String
    Public Property LAST_BUY_PRICE As String
    Public Property DT_LAST_BUY As String
    Public Property QTY_BO_SUPPLIER As String
    Public Property ID_WH_ITEM As String
    Public Property ITEM_AVAIL_QTY As String
    Public Property MIN_STOCK As String
    Public Property MAX_STOCK As String
    Public Property FLG_STOCK_ITEM As Boolean
    Public Property FLG_VAT_INCL As String
    Public Property FLG_OBTAIN_SPARE As String
    Public Property FLG_OBSOLETE_SPARE As String
    Public Property FLG_BLOCK_AUTO_ORD As String
    Public Property FLG_AUTOADJUST_PRICE As String
    Public Property FLG_LABELS As String
    Public Property FLG_ALLOW_DISCOUNT As String
    Public Property FLG_REPLACEMENT_PURCHASE As String
    Public Property FLG_AUTO_ARRIVAL As String
    Public Property FLG_SAVE_TO_NONSTOCK As String
    Public Property FLG_EFD As String
    Public Property WEIGHT As String
    Public Property ID_UNIT_ITEM As String
    Public Property UNIT_DESC As String
    Public Property DISCOUNT As String
    Public Property TEXT As String
    Public Property DT_CREATED As String
    Public Property CREATED_BY As String
    Public Property DT_MODIFIED As String
    Public Property MODIFIED_BY As String
    Public Property ITEM_DESC_NAME2 As String
    Public Property ID_ITEM_MODEL As Integer
    Public Property ID_ITEM_CATG As Integer
    Public Property ITEM_CATG_DESC As String
    Public Property ITEM_REORDER_LEVEL As String
    Public Property ID_VAT_CODE As Integer
    Public Property ACCOUNT_CODE As String
    Public Property FLG_ALLOW_BCKORD As String
    Public Property FLG_CALC_PRICE As String
    Public Property FLG_CNT_STOCK As String
    Public Property FLG_DUTY As String
    Public Property Class_Code As String
    Public Property ID_SPCATEGORY As Integer
    Public Property QTY_NOT_DELIVERED As String
    Public Property TD_CALC As String
    Public Property FLG_STOCKITEM As String
    Public Property VA_EXCHANGE_VEH As String
    Public Property VA_ORDER_COST As String
    Public Property FLG_STOCKITEM_STATUS As String
    Public Property ENV_ID_ITEM As String
    Public Property ENV_ID_MAKE As String
    Public Property ENV_ID_WAREHOUSE As String
    Public Property SUPP_CURRENTNO As String
    Public Property SUP_CURRENCY_CODE As String

    'Values for taking out advanced spare information
    Public Property PO_NO As String
    Public Property PO_QTY As String
    Public Property PO_DT_CREATED As String
    Public Property PO_DT_EXPDLVDATE As String
    Public Property PO_ANNOTATION As String
    Public Property IR_NO As String
    Public Property IR_QTY As String
    Public Property COUNTING_DATE As String
    Public Property COUNTING_CREATED_BY As String
    Public Property DT_LAST_SOLD As String
    Public Property DT_LAST_BO As String
    Public Property TOTAL_BO_QTY As String
    Public Property TOTAL_ORDER_BO_QTY As String
    Public Property TOTAL_BARGAIN_BO_QTY As String


    Public Class ItemsHistory
        Property M_YEAR As Integer
        Property M_PERIOD As String
        Property M_TOTAL_SOLD_QTY As Double
        Property M_TOTAL_COST As Double
        Property M_TOTAL_GROSS As Double
    End Class

    Public Property ID_SETTINGS As String
    Public Property DESCRIPTION As String
    Public Property SLNO As String
    Public Property MIN_AMT As Decimal
    Public Property MAX_AMT As Decimal
    Public Property ADDED_FEE_PERC As String
    Public Property ENV_NAME As String
    Public Property ENV_VATCODE As String
    Public Property SUPPLIER_NUMBER As String
    Public Property CATEGORY As String
    Public Property INITIALCLASSCODE As String
    Public Property FLG_ALLOW_CLASSIFICATION As Boolean
    Public Property ALLOW_BCKORD As String
    Public Property CNT_STOCK As String
    Public Property ALLOW_CLASSIFICATION As String
    Public Property ITEM_DISC_CODE_BUYING As String
    Public Property ID_ITEM_DISC_CODE_BUYING As String
    Public Property ITEM_DISC_CODE_SELL As String
    Public Property ID_ITEM_DISC_CODE_SELL As String

End Class