package com.lgcns.nscm.admin.user;

import java.util.List;
import java.util.Map;

public interface UserService {

	User retrieveUser(String userId) throws Exception;
	void updateLangCd(String userId, String langCd) throws Exception;
	void updateTmzCd(String userId, String tmzCd) throws Exception;

	/** 로그인 성공 시 최종 로그인 일시(SCM_ADM_USER_M.LOGN_DTM) 기록 */
	void updateLognDtm(String userId) throws Exception;

	/** 사용자가 속한 그룹 권한명(USER_GR_NM) 목록 */
	List<String> retrieveUserGroups(String userId) throws Exception;

	/** 사용자가 속한 그룹(USER_GR_ID + USER_GR_NM) 목록. USE_YN='Y' 만. 화면 Assign Group 조회용. */
	List<Map<String, Object>> retrieveUserGroupList(String userId) throws Exception;

	/** 로그인 사용자의 기본 사업부(권한 사업부 중 최상단 1건). 없으면 null. */
	String retrieveUserDefaultDiv(String userId) throws Exception;

	/** 로그인 사용자의 소속 회사(SCM_MST_SSO_USER_INFO.COMPANY_ID). 없으면 null. */
	String retrieveUserCompanyId(String userId) throws Exception;

}
