package kr.or.ddit.tct.admin.prod.item.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;

public interface IAdItemService {

	int createItem(ItemVO vo);
	List<ItemVO> getItemAll();
	int deleteItem(String itemId);
}
