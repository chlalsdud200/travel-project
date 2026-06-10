package kr.or.ddit.tct.admin.prod.item.dao;

import java.util.List;

import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;

public interface IAdItemDao {

	int insertItem(ItemVO vo);
    List<ItemVO> selectItemAll();
    int deleteItem(String itemId);
}
