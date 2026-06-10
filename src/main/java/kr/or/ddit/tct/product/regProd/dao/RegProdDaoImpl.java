package kr.or.ddit.tct.product.regProd.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.product.dto.MainSearchDto;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class RegProdDaoImpl implements IregProdDao {
	
	private static IregProdDao dao = new RegProdDaoImpl();
	
	private RegProdDaoImpl() {
		
	}
	
	public static IregProdDao getInstance() {
		if(dao == null) dao = new RegProdDaoImpl();
		return dao;
	}
	
	@Override
	public List<RegProDtoVO> selectAllForSale(MainSearchDto param) {
		List<RegProDtoVO> list = null;
		
		try(SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
			
			list = sqlSession.selectList("regprod.selectAllForSale", param);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public RegProDtoVO selectDetailByRegId(String regId) {
	    RegProDtoVO vo = null;

	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	    	
	        vo = sqlSession.selectOne("regprod.selectDetailByRegId", regId);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return vo;
	}

	@Override
	public List<String> findCountryIdsByName(String name) {
		List<String> list = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
			
			list = sqlSession.selectList("regprod.findCountryIdsByName", name);
			
		} catch (Exception e){
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<String> findLocationIdsByName(String name) {
		List<String> list = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
			
			list = sqlSession.selectList("regprod.findLocationIdsByName", name);
			
		} catch (Exception e){
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<RegProDtoVO> selectTop5() {
		List<RegProDtoVO> list = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
			
			list = sqlSession.selectList("regprod.selectTop5");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<ItemVO> selectItemListByRegId(String regId) {
		List<ItemVO> list = null;
		
		try(SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
			list = sqlSession.selectList("regprod.selectItemListByRegId", regId);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public List<String> selectImgPathListByRegId(String regId) {
		List<String> list = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        list = sqlSession.selectList("regprod.selectImgPathListByRegId", regId);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		
		return list;
	}

	@Override
	public List<Map<String, Object>> selectItineraryRowsByRegId(String regId) {
	    List<Map<String, Object>> list = new ArrayList<>();

	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        List<Map<String, Object>> result =
	            sqlSession.selectList("regprod.selectItineraryRowsByRegId", regId);
	        if (result != null) list = result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	@Override
	public int selectReservedQtyByRegId(String regId) {
	    Integer v = 0;

	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        v = sqlSession.selectOne("regprod.selectReservedQtyByRegId", regId);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return (v == null) ? 0 : v;
	}

}
