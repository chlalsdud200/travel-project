package kr.or.ddit.tct.admin.prod.reg.service;

import java.util.List;

import jakarta.servlet.ServletContext;
import kr.or.ddit.tct.admin.prod.dto.AdRegImgPoolItemDto;
import kr.or.ddit.tct.comm.dto.CommonApi;

public interface IAdRegImgService {

	public List<AdRegImgPoolItemDto> getImgPool(String folder);

	public CommonApi<?> applyRegImg(String regId, String imgPath, Integer viewSequence, String originName,
			ServletContext sctx);

	public int deleteRegImgMappingByMapNo(String regId, List<Integer> mapNoList);

	public int updateRegImgViewSequence(String regId, int mapNo, int viewSequence);
}
