package kr.or.ddit.tct.sales.orders.vo;

import java.util.Date;

public class OrdersVO {

	private String orderNo; /*  */
	private String userId; /*  */
	private int totalPrice; /*  */
	private Date orderDate; /*  */
	private String orderStatus; /*  */
	
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}
	public Date getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}
	public String getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}
	
	@Override
	public String toString() {
		return "OrdersVO [orderNo=" + orderNo + ", userId=" + userId + ", totalPrice=" + totalPrice + ", orderDate="
				+ orderDate + ", orderStatus=" + orderStatus + "]";
	}
	
	
	
}
