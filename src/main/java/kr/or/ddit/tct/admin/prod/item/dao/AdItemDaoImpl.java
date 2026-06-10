package kr.or.ddit.tct.admin.prod.item.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import jakarta.websocket.Session;
import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdItemDaoImpl implements IAdItemDao {

	private static IAdItemDao dao = new AdItemDaoImpl();
	private AdItemDaoImpl() {}

	public static IAdItemDao getInstance() {
	  if (dao == null) dao = new AdItemDaoImpl();
	  return dao;
	}
	  
	@Override
	public int insertItem(ItemVO vo) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
		      int cnt = session.insert("aditem.insertItem", vo);
		      if (cnt > 0) session.commit();
		return cnt;
		}
	}

	@Override
	public List<ItemVO> selectItemAll() {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
		      return session.selectList("aditem.selectItemAll");
		}
	}

	@Override
	public int deleteItem(String itemId) {
		try(SqlSession session = MyBatisUtil.getSqlSession()){
			int cnt = session.delete("aditem.deleteItem", itemId);
			if (cnt > 0) session.commit();
		return cnt;
		}
	}

}
