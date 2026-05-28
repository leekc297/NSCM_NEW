package com.lgcns.nscm.admin.message;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.message.dto.MessageDto;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageServiceImpl extends BaseService implements MessageService {

	/**
	 * @MethodName : retrieveMessages
	 * @Description: 전체 다국어를 반환 하는 함수
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @return
	 * @param      : @throws Exception
	 */
	@Override
	public List<MessageDto> retrieveMessages() throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		return MessageDto.listOf((List<Map<String, Object>>) selectList("admin.message.retrieveMessage", paramMap).get(DEFAULT_DATA_RESULT));
	}

	/**
	 * @MethodName : retrieveMessages
	 * @Description: 언어별 다국어를 반환하는 함수
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param langCd
	 * @param      : @return
	 * @param      : @throws Exception
	 */
	@Override
	public List<MessageDto> retrieveMessages(String langCd) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("langCd", langCd);
		return MessageDto.listOf((List<Map<String, Object>>) selectList("admin.message.retrieveMessage", paramMap).get(DEFAULT_DATA_RESULT));
	}


}
