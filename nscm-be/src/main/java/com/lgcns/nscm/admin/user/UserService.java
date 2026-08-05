package com.lgcns.nscm.admin.user;

import java.util.List;

public interface UserService {

	User retrieveUser(String userId) throws Exception;
	void updateLangCd(String userId, String langCd) throws Exception;

	/** 사용자가 속한 그룹 권한명(USER_GR_NM) 목록 */
	List<String> retrieveUserGroups(String userId) throws Exception;
	
	/** 로그인 사용자의 기본 사업부(권한 사업부 중 최상단 1건). 없으면 null. */
	String retrieveUserDefaultDiv(String userId) throws Exception;

}
