package com.lgcns.nscm.admin.auth.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

/**
 * 시트 단위 버튼 권한 한 건 — (SHT_NM, MNU_BTN_CD).
 * PR_GET_MNU_BTN_AUTH 커서는 이미 (MNU_ID, SHT_NM, MNU_BTN_CD) 를 반환하는데, 기존 mnuBtnAuth
 * (메뉴 단위 버튼 노출용) 은 MNU_BTN_CD 만 평면화해 써 왔다. 그리드 편집가부를 시트 단위 SAVE 권한으로
 * 잠그기 위해 SHT_NM 을 함께 FE 로 넘기는 용도(additive — 기존 mnuBtnAuth 동작 불변).
 * SHT_NM 이 null 인 버튼(헤더 단위 등)은 특정 그리드 시트와 매칭되지 않는다.
 */
@Getter
@Builder
@AllArgsConstructor
public class MnuBtnAuthSheet {
    private String shtNm;
    private String btnCd;

    public static MnuBtnAuthSheet of(Map<String, Object> data) {
        return MnuBtnAuthSheet.builder()
            .shtNm((String) data.get("SHT_NM"))
            .btnCd(String.valueOf(data.get("MNU_BTN_CD")))
            .build();
    }

    public static List<MnuBtnAuthSheet> listOf(List<Map<String, Object>> datas) {
        List<MnuBtnAuthSheet> result = new ArrayList<>();
        for (Map<String, Object> data : datas) {
            result.add(of(data));
        }
        return result;
    }
}
