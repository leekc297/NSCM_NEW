package com.lgcns.nscm.admin.log;

import java.util.List;
import java.util.Map;

import com.lgcns.nscm.admin.log.dto.LogDto;

public interface LogService {


	/**
	 * front 최종로그 처리
	 * @MethodName : logBack
	 * @Description:
	 <p><b>Usage Example:</b></p>
	 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
	 * {@code
	 *
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 19.
	 * @param      : @param uLID
	 * @return     : void
	 * @throws Exception
	 */
	void logBack(String uLID) throws Exception;

	/**
	 * 시스템 log 정보를 조회한다.
	 * @MethodName : retrieveLog
	 * @Description:
	 <p><b>Usage Example:</b></p>
	 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
	 * {@code
	 *
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 19.
	 * @param      : @param params
	 * @param      : @return
	 * @return     : String
	 * @throws Exception
	 */
	List<LogDto> retrieveLog(Map<String, Object> params) throws Exception;


}
