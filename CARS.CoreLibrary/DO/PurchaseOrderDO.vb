Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports System.Web.Services

Public Class PurchaseOrderDO
    Dim ConnectionString As String
    Dim objDB As Database
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub

    Public Function FetchPurchaseOrders(ByVal POnum As String, ByVal supplier As String, ByVal fromDate As Integer, ByVal toDate As Integer, ByVal spareNumber As String, ByVal isDelivered As String, ByVal isConfirmedOrder As String, ByVal isUnconfirmedOrder As String, ByVal isExactPOnum As String, ByVal isExactSupp As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_FETCH_HEADER")
                objDB.AddInParameter(objcmd, "@NUMBER", DbType.String, POnum)
                objDB.AddInParameter(objcmd, "@SUPPLIER", DbType.String, supplier)
                objDB.AddInParameter(objcmd, "@FROMDATE", DbType.Int32, fromDate)
                objDB.AddInParameter(objcmd, "@TODATE", DbType.Int32, toDate)
                objDB.AddInParameter(objcmd, "@CONFIRMED", DbType.Boolean, isConfirmedOrder)
                objDB.AddInParameter(objcmd, "@UNCONFIRMED", DbType.Boolean, isUnconfirmedOrder)
                objDB.AddInParameter(objcmd, "@IS_EXACT_PONUM", DbType.Boolean, isExactPOnum)
                objDB.AddInParameter(objcmd, "@IS_EXACT_SUPP", DbType.Boolean, isExactSupp)


                If (String.Compare("%", isDelivered) = 0) Then
                    objDB.AddInParameter(objcmd, "@ISDELIVERED", DbType.Int32, 2)
                Else
                    objDB.AddInParameter(objcmd, "@ISDELIVERED", DbType.Boolean, isDelivered)
                End If

                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Dim theex = ex.GetType()
            Throw ex
        End Try
    End Function

    Public Function Fetch_PO_Items(ByVal POnum As String) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_FETCH_ITEMS")
                objDB.AddInParameter(objcmd, "@NUMBER", DbType.String, POnum)

                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Dim theex = ex.GetType()
            Throw ex
        End Try
    End Function

    Public Function generate_PO_number(ByVal deptID As Integer, ByVal warehouseID As Integer) As DataSet
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_GENERATE_PONUMBER")
                objDB.AddInParameter(objcmd, "@DeptId", DbType.Int32, deptID)
                objDB.AddInParameter(objcmd, "@WarehouseId", DbType.Int32, warehouseID)

                Return objDB.ExecuteDataSet(objcmd)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function SavePurchaseOrder(ByVal PurchaseOrderItem As PurchaseOrderHeaderBO, ByVal login As String) As Integer
        Try
            Dim strStatus As Integer = 0

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_CREATE_POHEADER")

                objDB.AddInParameter(objcmd, "@USER", DbType.String, login)
                objDB.AddInParameter(objcmd, "@PREFIX", DbType.String, PurchaseOrderItem.PREFIX)
                objDB.AddInParameter(objcmd, "@NUMBER", DbType.String, PurchaseOrderItem.NUMBER)
                objDB.AddInParameter(objcmd, "@ID_ORDERTYPE", DbType.String, PurchaseOrderItem.ID_ORDERTYPE)
                objDB.AddInParameter(objcmd, "@SUPP_CURRENTNO", DbType.String, PurchaseOrderItem.SUPP_CURRENTNO)
                objDB.AddInParameter(objcmd, "@ID_DEPT", DbType.Int32, PurchaseOrderItem.ID_DEPT)
                objDB.AddInParameter(objcmd, "@ID_WAREHOUSE", DbType.Int32, PurchaseOrderItem.ID_WAREHOUSE)
                objDB.AddInParameter(objcmd, "@DT_CREATED_SIMPLE", DbType.Int32, PurchaseOrderItem.DT_CREATED_SIMPLE)
                objDB.AddInParameter(objcmd, "@DT_EXPECTED_DELIVERY", DbType.Int64, PurchaseOrderItem.DT_EXPECTED_DELIVERY)
                objDB.AddInParameter(objcmd, "@DELIVERY_METHOD", DbType.Int32, PurchaseOrderItem.DELIVERY_METHOD)
                objDB.AddInParameter(objcmd, "@STATUS", DbType.String, PurchaseOrderItem.STATUS)
                objDB.AddInParameter(objcmd, "@ANNOTATION", DbType.String, PurchaseOrderItem.ANNOTATION)
                objDB.AddInParameter(objcmd, "@FINISHED", DbType.String, PurchaseOrderItem.FINISHED)


                Try
                    objDB.ExecuteNonQuery(objcmd)

                    'strStatus = objDB.GetParameterValue(objcmd, "@RETVAL").ToString + ";" + objDB.GetParameterValue(objcmd, "@RETSPARE").ToString
                    strStatus = 1
                Catch ex As Exception
                    Dim theex = ex.GetType()
                    Throw ex
                End Try

            End Using
            Return strStatus

        Catch ex As Exception
            Throw
        End Try



    End Function

    Public Function Add_PO_Item(ByVal POitem As PurchaseOrderItemsBO, ByVal login As String) As Integer
        Try
            Dim strStatus As Integer = 0

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_ADD_POITEMS")

                objDB.AddInParameter(objcmd, "@USER", DbType.String, login)
                objDB.AddInParameter(objcmd, "@ID_PO", DbType.String, POitem.ID_PO)
                objDB.AddInParameter(objcmd, "@POPREFIX", DbType.String, POitem.POPREFIX)
                objDB.AddInParameter(objcmd, "@PONUMBER", DbType.String, POitem.PONUMBER)
                objDB.AddInParameter(objcmd, "@ID_ITEM", DbType.String, POitem.ID_ITEM)
                objDB.AddInParameter(objcmd, "@ITEM_CATG_DESC", DbType.String, POitem.ITEM_CATG_DESC)
                objDB.AddInParameter(objcmd, "@ORDERQTY", DbType.Decimal, POitem.ORDERQTY)
                objDB.AddInParameter(objcmd, "@DELIVERED_QTY", DbType.Decimal, POitem.DELIVERED_QTY)
                objDB.AddInParameter(objcmd, "@REMAINING_QTY", DbType.Decimal, POitem.REMAINING_QTY)
                objDB.AddInParameter(objcmd, "@BUYCOST", DbType.Decimal, POitem.BUYCOST)
                objDB.AddInParameter(objcmd, "@TOTALCOST", DbType.Decimal, POitem.TOTALCOST)
                objDB.AddInParameter(objcmd, "@BACKORDERQTY", DbType.Decimal, POitem.BACKORDERQTY)
                objDB.AddInParameter(objcmd, "@CONFIRMQTY", DbType.Decimal, POitem.CONFIRMQTY)
                objDB.AddInParameter(objcmd, "@DELIVERED", DbType.Boolean, POitem.DELIVERED)
                objDB.AddInParameter(objcmd, "@ANNOTATION", DbType.String, POitem.ANNOTATION)


                Try
                    objDB.ExecuteNonQuery(objcmd)


                    strStatus = 1
                Catch ex As Exception
                    Dim theex = ex.GetType()
                    Throw ex
                End Try

            End Using
            Return strStatus

        Catch ex As Exception
            Throw
        End Try



    End Function

    Public Function updatePOitem(ByVal ponumber As String, ByVal polineno As String, ByVal orderqty As String, ByVal buycost As String, ByVal totalcost As String, ByVal login As String) As Integer
        Try
            Dim strStatus As Integer = 0

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_UPDATE_POITEMS")

                objDB.AddInParameter(objcmd, "@PONUMBER", DbType.String, ponumber)
                objDB.AddInParameter(objcmd, "@POLINENO", DbType.Int64, polineno)
                objDB.AddInParameter(objcmd, "@ORDERQTY", DbType.Decimal, orderqty)
                objDB.AddInParameter(objcmd, "@BUYCOST", DbType.Decimal, buycost)
                objDB.AddInParameter(objcmd, "@TOTALCOST", DbType.Decimal, totalcost)
                objDB.AddInParameter(objcmd, "@USER", DbType.String, login)

                Try
                    objDB.ExecuteNonQuery(objcmd)

                    strStatus = 1
                Catch ex As Exception
                    Dim theex = ex.GetType()
                    Throw ex
                End Try

            End Using
            Return strStatus

        Catch ex As Exception
            Throw
        End Try



    End Function

    Public Function setPOtoSent(ByVal ponumber As String, ByVal login As String) As Integer
        Try
            Dim strStatus As Integer = 0

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_SETSTATUS_POITEMS")

                objDB.AddInParameter(objcmd, "@PONUMBER", DbType.String, ponumber)
                objDB.AddInParameter(objcmd, "@USER", DbType.String, login)

                Try
                    objDB.ExecuteNonQuery(objcmd)

                    strStatus = 1
                Catch ex As Exception
                    Dim theex = ex.GetType()
                    Throw ex
                End Try

            End Using
            Return strStatus

        Catch ex As Exception
            Throw
        End Try



    End Function



    Public Function poExists(ByVal ponum As String) As String
        Try
            Dim polineno As String

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PURCHASEORDERS_FETCH_LAST")

                objDB.AddInParameter(objcmd, "@PONUMBER", DbType.String, ponum)


                Try
                    polineno = objDB.ExecuteScalar(objcmd)


                Catch ex As Exception

                End Try

            End Using
            Return polineno

        Catch ex As Exception
            Dim theex = ex.GetType()

            Throw ex
        End Try

    End Function

    Public Function Fetch_PO_id(ByVal ponum As String) As Integer
        Try
            Dim id As Integer

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PO_FETCH_HEADER_ID")

                objDB.AddInParameter(objcmd, "@NUMBER", DbType.String, ponum)


                Try
                    id = objDB.ExecuteScalar(objcmd)


                Catch ex As Exception

                End Try

            End Using
            Return id

        Catch ex As Exception
            Dim theex = ex.GetType()

            Throw ex
        End Try

    End Function

    Public Function getCostPrice(ByVal itemID As String, ByVal suppcurrentno As String, ByVal orderType As String) As Decimal
        Try
            Dim costPrice As Decimal

            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_PRICE_FETCH")

                objDB.AddInParameter(objcmd, "@ID_ORDERTYPE", DbType.String, orderType)
                objDB.AddInParameter(objcmd, "@SUPP_CURRENTNO", DbType.String, suppcurrentno)
                objDB.AddInParameter(objcmd, "@ID_ITEM", DbType.String, itemID)


                Try
                    costPrice = objDB.ExecuteScalar(objcmd)

                Catch ex As Exception

                End Try

            End Using
            Return costPrice

        Catch ex As Exception
            Dim theex = ex.GetType()

            Throw ex
        End Try

    End Function

End Class
