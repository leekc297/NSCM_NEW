package com.lgcns.nscm.admin.user;

public interface UserService {

	User retrieveUser(String userId) throws Exception;
	void updateLangCd(String userId, String langCd) throws Exception;

}
