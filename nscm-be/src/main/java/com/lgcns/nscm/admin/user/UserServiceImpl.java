package com.lgcns.nscm.admin.user;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl extends BaseService implements UserService {

	private final String nameSpace = "admin.user.";

	@Override
	public User retrieveUser(String userId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);

		Map<String, Object> result = selectList(nameSpace + "retrieveUser", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		return User.of(data.get(0));
	}

	@Override
	public void updateLangCd(String userId, String langCd) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("langCd", langCd);

		selectList(nameSpace + "updateLangCd", params);

		return;
	}
}
