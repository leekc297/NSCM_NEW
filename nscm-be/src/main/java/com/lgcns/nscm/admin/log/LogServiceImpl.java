package com.lgcns.nscm.admin.log;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.log.dto.LogDto;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes", "unchecked" })
@Service
public class LogServiceImpl extends BaseService implements LogService {

	private final String nameSpace = "admin.log.";


	/**
	 * @MethodName : logBack
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 2. 19.
	 * @param      : @param uLID
	 * @throws Exception
	 */
	@Override
	public void logBack(String sULID) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("traceId", sULID);
		update(nameSpace+"updateSysLog", params);
	}


	/**
	 * @MethodName : retrieveLog
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 2. 19.
	 * @param      : @param params
	 * @param      : @return
	 * @throws Exception
	 */
	@Override
	public List<LogDto> retrieveLog(Map<String, Object> params) throws Exception {
		Map<String, Object> result = selectList(nameSpace + "selectSysLog", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));
		return LogDto.listOf(data);
	}


/*========================================================================================================================== */




}
