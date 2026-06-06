package com.lgcns.nscm.master.bod.dto;

import java.util.HashMap;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DMF0015 BOD Request DTO — Phase 6 PoC (보완 6)
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BodRequest {

    // Main 조회 파라미터
    private String divisionId;
    private String bodType;
    private String fromSite;
    private String toSite;
    private String activeFlag;

    // Sub 조회 파라미터 (Bod Item)
    private String bodId;

    // 저장 (Main/Sub 공통 — CLOB JSON)
    private String inData;

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("divisionId", divisionId);
        map.put("bodType", bodType);
        map.put("fromSite", fromSite);
        map.put("toSite", toSite);
        map.put("activeFlag", activeFlag);
        map.put("bodId", bodId);
        return map;
    }
}
