package kr.or.ddit.tct.sales.orders.service;

public class OrdersServiceImpl implements IOrdersService{

	private static IOrdersService ordService = new OrdersServiceImpl();
	
	private OrdersServiceImpl() {
		// TODO Auto-generated constructor stub
	}
	
	public static IOrdersService getInstance() {
		return ordService;
	}
}
