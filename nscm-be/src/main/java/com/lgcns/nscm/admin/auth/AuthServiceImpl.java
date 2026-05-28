package com.lgcns.nscm.admin.auth;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.auth.dto.UnitDto;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.utils.MapUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl extends BaseService implements AuthService {

	private final String nameSpace = "admin.auth.";

	@Override
	public boolean checkMenuAuth(String userId, String mnuId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		Map<String, Object> result = selectList(nameSpace + "checkMenuAuth", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		String hasAuthYn = data.get(0).get("HAS_AUTH_YN").toString();

		return hasAuthYn.equals("Y");
	}

	@Override
	public boolean checkMenuBtnAuth(String userId, String mnuId, String shtNm, String mnuBtnCd) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);
		params.put("shtNm", shtNm);
		params.put("mnuBtnCd", mnuBtnCd);
		MapUtils.decodeMap(params);
		Map<String, Object> result = selectList(nameSpace + "checkMenuBtnAuth", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		String hasAuthYn = data.get(0).get("HAS_AUTH_YN").toString();

		return hasAuthYn.equals("Y");
	}

	@Override
	public List<String> retrieveMenuBtnAuth(String userId, String mnuId) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		Map<String, Object> result = selectList(nameSpace + "retrieveMenuBtnAuth", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		List<String> mnuBtnAuth = data.stream()
				.map(map -> String.valueOf(map.get("MNU_BTN_CD")))
				.collect(Collectors.toList());

		return mnuBtnAuth;

	}

	@Override
	public List<UnitDto> retrieveUnitAuth(String userId, String mnuId) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		Map<String, Object> result = selectList(nameSpace + "retrieveUnitAuth", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		return UnitDto.listOf(data);
	}

}
