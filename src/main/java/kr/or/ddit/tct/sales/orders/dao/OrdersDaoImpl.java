package kr.or.ddit.tct.sales.orders.dao;

public class OrdersDaoImpl implements IOrdersDao {

	private static IOrdersDao ordDao = new OrdersDaoImpl();
	
	private OrdersDaoImpl() {
		// TODO Auto-generated constructor stub
	}
	
	private static IOrdersDao getInstance() {
		return ordDao;
	}
}
