package com.lgcns.nscm.master.bod.service;

import java.util.List;
import java.util.Map;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.master.bod.dto.BodRequest;

/**
 * DMF0015 BOD Service Interface — Phase 6 PoC (보완 6)
 */
public interface BodService {

    List<Map<String, Object>> retrieveMain(UserSession userSession, BodRequest request) throws Exception;
    void saveMain(UserSession userSession, BodRequest request) throws Exception;
    List<Map<String, Object>> retrieveBodItem(UserSession userSession, BodRequest request) throws Exception;
    void saveBodItem(UserSession userSession, BodRequest request) throws Exception;
}
