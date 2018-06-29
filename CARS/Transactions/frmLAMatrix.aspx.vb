Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmLAMatrix
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared details As New List(Of LinkToAccountingBO)()
    Shared objLAServ As New Services.LinkToAccounting.LinkToAccounting
    Shared objLABO As New CARS.CoreLibrary.LinkToAccountingBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Session("Decimal_Seperator") = ConfigurationManager.AppSettings.Get("ReportDecimalSeperator").ToString()
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAMatrix", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadAccCode() As Collection
        Dim dtConfig As New Collection
        Try
            dtConfig = objLAServ.Load_ConfigDetails()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAMatrix", "LoadAccCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function LoadAccCodeType() As Collection
        Dim dtConfig As New Collection
        Try
            dtConfig = objLAServ.Load_AccCodeType()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAMatrix", "LoadAccCodeType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function SaveMatrix(ByVal saleCodeType As String, ByVal deptId As String, ByVal vatCode As String, ByVal deptAccCode As String, _
    ByVal custGrpId As String, ByVal custGrpAccCode As String, ByVal projectId As String, ByVal selling_GL_Crdb As String, ByVal selling_GL_AccNo As String, _
    ByVal selling_GL_DepAccNo As String, ByVal selling_GL_Dimension As String, ByVal discount_GL_Crdb As String, ByVal discount_GL_AccNo As String, _
    ByVal discount_GL_DepAccNo As String, ByVal discount_GL_Dimension As String, ByVal stock_GL_Crdb As String, ByVal stock_GL_AccNo As String, ByVal stock_GL_DepAccNo As String, _
    ByVal stock_GL_Dimension As String, ByVal cost_GL_Crdb As String, ByVal cost_GL_AccNo As String, ByVal cost_GL_DepAccNo As String, ByVal cost_GL_Dimension As String, _
    ByVal sellCost_GL_Crdb As String, ByVal sellCost_GL_AccNo As String, ByVal sellCost_GL_DepAccNo As String, ByVal sellCost_GL_Dimension As String, _
    ByVal cust_AccNo_CrDb As String, ByVal genLedger As String, ByVal desc As String, ByVal saleCode_desc As String, ByVal selling_GL_Desc As String, _
    ByVal discount_GL_Desc As String, ByVal stock_GL_Desc As String, ByVal cost_GL_Desc As String, ByVal sellCost_GL_Desc As String, ByVal laMatrixId As String, _
    ByVal id_SellCost_GL_Id As String, ByVal id_Cost_GL_Id As String, ByVal id_Stock_GL_Id As String, ByVal id_Discount_GL_Id As String, ByVal id_Selling_GL_Id As String) As String
        Dim strResult As String
        Try

            objLABO.Id_SaleCode_Type = saleCodeType
            objLABO.Id_DeptId = deptId
            objLABO.Id_DeptAcCode = deptAccCode
            objLABO.Id_VatCode = vatCode
            objLABO.Id_CUSTOMER = custGrpId
            objLABO.Id_CustGrpAcCode = custGrpAccCode
            objLABO.Id_Project = projectId
            objLABO.Id_Selling_GL_Desc = selling_GL_Desc
            objLABO.Id_Selling_GL_CrDb = selling_GL_Crdb
            objLABO.Id_Selling_GL_AccNo = selling_GL_AccNo
            objLABO.Id_Selling_GL_DeptAccNo = selling_GL_DepAccNo
            objLABO.Id_Selling_GL_Dimension = selling_GL_Dimension
            objLABO.Id_Discount_GL_Desc = discount_GL_Desc
            objLABO.Id_Discount_GL_CrDb = discount_GL_Crdb
            objLABO.Id_Discount_GL_AccNo = discount_GL_AccNo
            objLABO.Id_Discount_GL_DeptAccNo = discount_GL_DepAccNo
            objLABO.Id_Discount_GL_Dimension = discount_GL_Dimension
            objLABO.Id_Stock_GL_Desc = stock_GL_Desc
            objLABO.Id_Stock_GL_CrDb = stock_GL_Crdb
            objLABO.Id_Stock_GL_AccNo = stock_GL_AccNo
            objLABO.Id_Stock_GL_DeptAccNo = stock_GL_DepAccNo
            objLABO.Id_Stock_GL_Dimension = stock_GL_Dimension
            objLABO.Id_Cost_GL_Desc = cost_GL_Desc
            objLABO.Id_Cost_GL_CrDb = cost_GL_Crdb
            objLABO.Id_Cost_GL_AccNo = cost_GL_AccNo
            objLABO.Id_Cost_GL_DeptAccNo = cost_GL_DepAccNo
            objLABO.Id_Cost_GL_Dimension = cost_GL_Dimension
            objLABO.Id_SellCost_GL_Desc = sellCost_GL_Desc
            objLABO.Id_SellCost_GL_CrDb = sellCost_GL_Crdb
            objLABO.Id_SellCost_GL_AccNo = sellCost_GL_AccNo
            objLABO.Id_SellCost_GL_DeptAccNo = sellCost_GL_DepAccNo
            objLABO.Id_SellCost_GL_Dimension = sellCost_GL_Dimension
            objLABO.Id_Cust_AccNo_CrDb = cust_AccNo_CrDb
            objLABO.Id_GenLedger = genLedger
            objLABO.Id_Description = desc
            objLABO.Id_Created_By = loginName
            objLABO.Id_SaleCode_Desc = saleCode_desc
            objLABO.Id_Selling_GL_DeptAccNo = selling_GL_DepAccNo
            objLABO.LA_SlNo = laMatrixId
            objLABO.Id_Selling_GL_Id = id_Selling_GL_Id
            objLABO.Id_Discount_GL_Id = id_Discount_GL_Id
            objLABO.Id_Cost_GL_Id = id_Cost_GL_Id
            objLABO.Id_Stock_GL_Id = id_Stock_GL_Id
            objLABO.Id_SellCost_GL_Id = id_SellCost_GL_Id

            strResult = objLAServ.Matrix_Save(objLABO)



        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfLA", "SaveConfiguration", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function Load_LA_Matrix(ByVal laSLNO As String) As Collection
        Dim dtConfig As New Collection
        Try
            dtConfig = objLAServ.Fetch_Configuration(laSLNO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmLAMatrix", "Load_LA_Matrix", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
End Class