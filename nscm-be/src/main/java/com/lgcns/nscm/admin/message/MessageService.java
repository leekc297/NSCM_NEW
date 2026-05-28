package com.lgcns.nscm.admin.message;

import java.util.List;

import com.lgcns.nscm.admin.message.dto.MessageDto;

public interface MessageService {

	List<MessageDto> retrieveMessages() throws Exception;

	List<MessageDto> retrieveMessages(String langCd) throws Exception;



}
