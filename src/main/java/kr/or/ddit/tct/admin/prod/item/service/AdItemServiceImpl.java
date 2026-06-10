package kr.or.ddit.tct.admin.prod.item.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.item.dao.AdItemDaoImpl;
import kr.or.ddit.tct.admin.prod.item.dao.IAdItemDao;
import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;

public class AdItemServiceImpl implements IAdItemService{

	private static IAdItemService service = new AdItemServiceImpl();
	private final IAdItemDao dao = AdItemDaoImpl.getInstance();

	private AdItemServiceImpl() {}

	public static IAdItemService getInstance() {
	  if (service == null) service = new AdItemServiceImpl();
	  return service;
	}
	
	@Override
	public int createItem(ItemVO vo) {
		return dao.insertItem(vo);
	}

	@Override
	public List<ItemVO> getItemAll() {
		return dao.selectItemAll();
	}

	@Override
	public int deleteItem(String itemId) {
		return dao.deleteItem(itemId);
	}

}
