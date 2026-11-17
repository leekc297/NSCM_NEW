package com.lgcns.nscm.framework.ifclient;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import com.lgcns.nscm.framework.utils.SecurityUtil;

import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.netty.http.client.HttpClient;

/**
 * nscm-if 실시간 송신 클라이언트.
 *
 * AS-IS {@code CallClient.FN_ERP_UIWebService(reqNo, changeType, status)} 자리를 대신한다.
 * AS-IS 는 화면이 UIC0001.asmx 를 SOAP 으로 직접 불렀고 응답 {@code Result{E_TYPE, E_MESSAGE}} 를
 * {@code RtFlag}/{@code ReErrorMsg} 로 받았다. TO-BE 는 ASMX 가 없으므로 nscm-if 의
 * {@code POST /api/if/send/{IF_ID}} 를 부르고, 그 응답을 AS-IS 와 같은 {E_TYPE, E_MESSAGE} 로 되돌린다.
 * FE 는 이미 그 계약으로 분기하고 있어 화면 코드는 경로만 바뀐다.
 *
 * <p>result -&gt; E_TYPE 대응 (AS-IS RtFlag 의미에 맞춘다)
 * <pre>
 *   S    -&gt; S      전부 성공
 *   E    -&gt; E      ERP 오류          AS-IS MSG00197
 *   S_E  -&gt; S_E    일부 성공·일부 오류
 *   N    -&gt; N      전송 대상 없음. AS-IS UIWebService(FN_ERP_UI_TransferPosting2/_NERP_*)가 조회 0건이면
 *                   RtFlag="N" 을 돌려주고, 화면(GetErpIFCheckNew)은 S 와 같은 else 분기로 'B' 적재·2차 송신·확정을
 *                   이어 간다. 변경요청 'C' 적재 SP 가 현재 수량 0 행을 제외하므로(CHG_BATCH_NEW_C "변경 생성경우 0은 제외")
 *                   Qty 0 행 Request 는 늘 이 경로다. F 로 바꾸면 보상 삭제 + MSG01215 로 빠진다(2026-11-10 결함 수정).
 *   F    -&gt; C_E    PO 미도달(연결·타임아웃) = SAP PI 호출 실패  MSG00306
 *   호출 자체 실패 -&gt; C_E   AS-IS catch 블록이 RtFlag="C_E" 를 넣던 것과 같다
 * </pre>
 *
 * <p>E_MESSAGE 는 AS-IS ReErrorMsg 포맷을 그대로 맞춘다 — {@code CONFIRM_ID:메시지^CONFIRM_ID:메시지}.
 * 화면이 '^' 로 끊고 ':' 앞을 CONFIRM_ID 로 쓰기 때문이다(AS-IS SSP0015 cs:7277~7291).
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class IfSendClient {

    /** nscm-if 실시간 송신 경로. {0}=IF_ID */
    private static final String SEND_PATH = "/api/if/send/{ifId}";

    private static final String HDR_TOKEN = "X-IF-Token";
    private static final String HDR_USER = "X-User-Id";

    /** AS-IS ReErrorMsg 구분자. */
    private static final String MSG_DELIM = "^";
    private static final String ID_DELIM = ":";

    private static final String OK = "S";

    private final NscmIfProperties props;

    /**
     * @param ifId   nscm-if IF_ID (예: NSD0100)
     * @param params FE 가 보낸 AS-IS 인자 — CHANGE_REQ_NO / CHANGE_TYPE / SHIPMENT_STATUS
     * @return {E_TYPE, E_MESSAGE} (+ 진단용 IF_RESULT, IF_MESSAGE)
     */
    public Map<String, String> send(String ifId, Map<String, Object> params) {
        Map<String, Object> p = (params == null) ? Collections.emptyMap() : params;
        String changeReqNo = str(p.get("CHANGE_REQ_NO"));
        String changeType = str(p.get("CHANGE_TYPE"));
        String shipmentStatus = str(p.get("SHIPMENT_STATUS"));

        // base-url 만 필수다. 토큰은 선택이다 — nscm-if 가 /api 고정 토큰 인증을 제거했고
        //   (b199f149: HeaderTokenAuthenticationFilter 삭제, CallerIdentityFilter 로 X-User-Id 기록만)
        //   호출자 제한은 L4 ACL·방화벽이 맡는다. 토큰을 필수로 두면 설정이 빈 환경에서
        //   송신이 전부 C_E 로 떨어진다.
        if (props.getBaseUrl().isEmpty()) {
            log.error("nscm-if 설정 누락 — base-url 이 비어 있다. ifId={}", ifId);
            return result("C_E", "nscm-if base-url 미설정", "", "");
        }

        Map<String, String> body = new LinkedHashMap<>();
        body.put("changeReqNo", changeReqNo);
        body.put("changeType", changeType);
        body.put("shipmentStatus", shipmentStatus);

        String userId = SecurityUtil.getUserSession().getUserId();
        log.info("nscm-if send ifId={} changeReqNo={} changeType={} shipmentStatus={} by={}",
                ifId, changeReqNo, changeType, shipmentStatus, userId);

        try {
            String token = props.getToken();
            IfSendEnvelope res = client()
                    .post()
                    .uri(uriBuilder -> uriBuilder.path(SEND_PATH).build(ifId))
                    .contentType(MediaType.APPLICATION_JSON)
                    // 토큰은 설정돼 있을 때만 보낸다. nscm-if 는 더 이상 검사하지 않지만(b199f149),
                    //   되돌릴 경우를 위해 전송 자체는 남긴다.
                    .headers(h -> {
                        if (!token.isEmpty()) {
                            h.set(HDR_TOKEN, token);
                        }
                    })
                    .header(HDR_USER, (userId == null || userId.isEmpty()) ? "nscm-be" : userId)
                    .bodyValue(body)
                    .retrieve()
                    .bodyToMono(IfSendEnvelope.class)
                    .block(Duration.ofMillis(props.getReadTimeoutMs()));

            return toAsIs(res, changeReqNo);
        } catch (Exception e) {
            // AS-IS CallClient 의 catch 와 같은 자리 — PI(=PO)에 닿지 못한 경우.
            log.error("nscm-if 호출 실패 ifId={} changeReqNo={}", ifId, changeReqNo, e);
            return result("C_E", e.getMessage() == null ? "nscm-if 호출 실패" : e.getMessage(), "", "");
        }
    }

    /** nscm-if 응답 -> AS-IS {E_TYPE, E_MESSAGE}. */
    private Map<String, String> toAsIs(IfSendEnvelope env, String changeReqNo) {
        IfSendEnvelope.Payload r = (env == null) ? null : env.result();
        if (r == null) {
            log.error("nscm-if 응답 본문 없음 changeReqNo={}", changeReqNo);
            return result("C_E", "nscm-if 응답 없음", "", "");
        }

        String code = str(r.result());
        String eType = switch (code) {
            case "S", "E", "S_E", "N" -> code; // N: 전송 대상 없음 — AS-IS RtFlag "N" 그대로(화면이 정상 처리). F 로 바꾸지 말 것
            case "F" -> "C_E"; // PO 미도달 = SAP PI 호출 실패
            default -> "C_E";
        };

        boolean noError = OK.equals(eType) || "N".equals(eType);
        String eMessage = noError ? "" : failureMessage(r);
        if (eMessage.isEmpty() && !noError) {
            eMessage = str(r.message());
        }

        log.info("nscm-if 응답 changeReqNo={} result={} -> E_TYPE={} dryRun={} details={}",
                changeReqNo, code, eType, r.dryRun(), (r.details() == null ? 0 : r.details().size()));

        return result(eType, eMessage, code, str(r.message()));
    }

    /** 실패 detail 만 AS-IS ReErrorMsg 포맷(CONFIRM_ID:메시지^…)으로 잇는다. */
    private static String failureMessage(IfSendEnvelope.Payload r) {
        List<IfSendEnvelope.Detail> details = r.details();
        if (details == null || details.isEmpty()) {
            return "";
        }
        List<String> parts = new ArrayList<>();
        for (IfSendEnvelope.Detail d : details) {
            if (d == null || OK.equals(str(d.eType()))) {
                continue;
            }
            parts.add(str(d.confirmId()) + ID_DELIM + str(d.eMessage()));
        }
        return String.join(MSG_DELIM, parts);
    }

    private Map<String, String> result(String eType, String eMessage, String ifResult, String ifMessage) {
        Map<String, String> map = new LinkedHashMap<>();
        map.put("E_TYPE", eType);
        map.put("E_MESSAGE", eMessage == null ? "" : eMessage);
        // 진단용 — 화면은 쓰지 않는다. 로그·테스트에서 nscm-if 원값을 확인할 때 본다.
        map.put("IF_RESULT", ifResult);
        map.put("IF_MESSAGE", ifMessage);
        return map;
    }

    private WebClient client() {
        HttpClient http = HttpClient.create()
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, props.getConnectTimeoutMs())
                .doOnConnected(c -> c.addHandlerLast(new ReadTimeoutHandler(props.getReadTimeoutMs() / 1000)));
        return WebClient.builder()
                .baseUrl(props.getBaseUrl())
                .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .clientConnector(new org.springframework.http.client.reactive.ReactorClientHttpConnector(http))
                .build();
    }

    private static String str(Object o) {
        return (o == null) ? "" : String.valueOf(o);
    }
}
