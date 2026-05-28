package com.lgcns.nscm.admin.lookup;

import java.util.Map;

/**
 * lookup Interface
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.lookup
 * @FileName : LookupService.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : LookupService
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
public interface LookupService {


	Map<String, Object> retrieveLookup(Map<String, Object> params) throws Exception;


	Map<String, Object> retrieveCombo(Map<String, Object> params) throws Exception;


	Map<String, Object> retrieveComboMuti(Map<String, Object> params) throws Exception;




}
