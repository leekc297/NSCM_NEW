package com.lgcns.nscm.admin.message.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class MessageDto {
    private String messageId;
    private String messageNm;
    private String langCd;
    private String messageType;
    private String i18nCtn;

    public static MessageDto of(Map<String, Object> data) {
    	return MessageDto.builder()
    		.messageId((String) data.get("MSG_ID"))
    		.messageNm((String) data.get("MSG_NM"))
    		.langCd((String) data.get("LANG_CD"))
    		.messageType((String) data.get("MSG_TP_CD"))
    		.i18nCtn((String) data.get("I18N_CTN"))
    		.build();
    }

    public static List<MessageDto> listOf(List<Map<String, Object>> datas) {
    	List<MessageDto> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(MessageDto.of(datas.get(i)));
		}
    	return result;
    }
}
