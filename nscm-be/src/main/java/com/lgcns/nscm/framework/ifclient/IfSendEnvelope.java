package com.lgcns.nscm.framework.ifclient;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * nscm-if 실시간 송신 응답 본문.
 *
 * nscm-if 의 {@code BaseResponse<IfSendResponse>} 와 1:1 이다 — 그쪽 계약이 바뀌면 여기도 같이 본다.
 * result 코드 S/E/S_E/N/F 의 의미는 nscm-if {@code IfSendResponse} 주석 참고.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public record IfSendEnvelope(String code, String message, Payload result) {

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Payload(String ifId, String result, String message, boolean dryRun, List<Detail> details) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Detail(String confirmId, String eType, String eMessage) {
    }
}
