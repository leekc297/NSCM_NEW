package com.lgcns.nscm.admin.auth;

import java.util.List;

import com.lgcns.nscm.admin.auth.dto.UnitDto;

public interface AuthService {

	boolean checkMenuAuth(String userId, String mnuId) throws Exception;
	boolean checkMenuBtnAuth(String userId, String mnuId, String shtNm, String mnuBtnCd) throws Exception;
	List<String> retrieveMenuBtnAuth(String userId, String mnuId) throws Exception;
	List<UnitDto> retrieveUnitAuth(String userId, String mnuId) throws Exception;

}
