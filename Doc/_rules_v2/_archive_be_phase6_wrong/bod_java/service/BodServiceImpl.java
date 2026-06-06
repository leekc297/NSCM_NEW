package com.lgcns.nscm.master.bod.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.master.bod.dto.BodRequest;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * DMF0015 BOD ServiceImpl — Phase 6 PoC (보완 6)
 *
 * 룰: Doc/_rules_v2/_tobe/11_be_controller_service.md §3
 * - @Service + @RequiredArgsConstructor + extends BaseService
 * - nameSpace = "master.bod." (MyBatis SQL ID prefix)
 * - selectList / executeProc 사용 (SQL ID hardcoding X)
 * - sesUserId / sesLangCd / mnuId 자동 주입
 */
@Slf4j
@Service
@RequiredArgsConstructor
@SuppressWarnings("unchecked")
public class BodServiceImpl extends BaseService implements BodService {

    private final String nameSpace = "master.bod.";
    private static final String MENU_ID = "DMF0015";

    @Override
    public List<Map<String, Object>> retrieveMain(UserSession userSession, BodRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("sesUserId", userSession.getUserId());
        params.put("sesLangCd", userSession.getLangCd());
        params.put("sesGrId", userSession.getCurrentGrId());
        params.put("mnuId", MENU_ID);
        params.putAll(request.toMap());

        Map<String, Object> result = selectList(nameSpace + "retrieveMain", params);
        return (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
    }

    @Override
    public void saveMain(UserSession userSession, BodRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("sesUserId", userSession.getUserId());
        params.put("sesLangCd", userSession.getLangCd());
        params.put("mnuId", MENU_ID);
        params.put("inData", request.getInData());  // CLOB JSON

        executeProc(nameSpace + "saveMain", params);
    }

    @Override
    public List<Map<String, Object>> retrieveBodItem(UserSession userSession, BodRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("sesUserId", userSession.getUserId());
        params.put("sesLangCd", userSession.getLangCd());
        params.put("mnuId", MENU_ID);
        params.putAll(request.toMap());

        Map<String, Object> result = selectList(nameSpace + "retrieveBodItem", params);
        return (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
    }

    @Override
    public void saveBodItem(UserSession userSession, BodRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("sesUserId", userSession.getUserId());
        params.put("sesLangCd", userSession.getLangCd());
        params.put("mnuId", MENU_ID);
        params.put("inData", request.getInData());

        executeProc(nameSpace + "saveBodItem", params);
    }
}
