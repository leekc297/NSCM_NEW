package com.lgcns.nscm.admin.user;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.ArrayList;
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

		if (data == null || data.isEmpty()) {
			return null; // Case 3(빈 커서) → 백엔드가 공유 GUEST 폴백 로그인 처리
		}

		return User.of(data.get(0));
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<String> retrieveUserGroups(String userId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);

		Map<String, Object> result = selectList(nameSpace + "retrieveUserGroups", params);
		List<Object> data = (List<Object>) result.get(DEFAULT_DATA_RESULT);

		List<String> groups = new ArrayList<String>();
		if (data != null) {
			for (Object row : data) {
				if (row == null) continue;
				// resultType=string 이면 String, 혹시 Map 으로 오면 첫 값 사용
				if (row instanceof Map) {
					Object v = ((Map<String, Object>) row).values().stream().findFirst().orElse(null);
					if (v != null) groups.add(String.valueOf(v));
				} else {
					groups.add(String.valueOf(row));
				}
			}
		}
		return groups;
	}

	@Override
	@SuppressWarnings("unchecked")
	public String retrieveUserDefaultDiv(String userId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);

		Map<String, Object> result = selectList(nameSpace + "retrieveUserDefaultDiv", params);
		List<Object> data = (List<Object>) result.get(DEFAULT_DATA_RESULT);

		if (data == null || data.isEmpty()) return null;

		Object row = data.get(0);
		if (row == null) return null;
		// resultType=string 이면 String, 혹시 Map 으로 오면 첫 값 사용
		if (row instanceof Map) {
			Object v = ((Map<String, Object>) row).values().stream().findFirst().orElse(null);
			return v == null ? null : String.valueOf(v);
		}
		return String.valueOf(row);
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
