package com.lgcns.nscm.admin.menu.dto;

import java.util.List;

import com.lgcns.nscm.admin.auth.dto.MnuBtnAuthSheet;
import com.lgcns.nscm.admin.auth.dto.UnitDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class MenuAuthDto {
    private List<String> mnuBtnAuth;
    // 시트 단위 버튼 권한 (SHT_NM, MNU_BTN_CD). 그리드 편집가부를 시트 단위 SAVE 권한으로 잠그는
    //   FE 용 추가 필드 — 기존 mnuBtnAuth(메뉴 단위 버튼 노출)는 그대로 둔다.
    private List<MnuBtnAuthSheet> mnuBtnAuthSheets;
    // 이 메뉴에 "정의된" 버튼 전체 (사용자 무관, SCM_ADM_MNU_BTN_MPG_M). 그리드 자동 SAVE 잠금의
    //   saveDefined 판정용 — SAVE 미부여가 (A)권한없음인지 (B)화면에 SAVE 정의 자체가 없음(EXECUTE 저장)인지 가른다.
    private List<MnuBtnAuthSheet> mnuBtnDefs;
    private List<UnitDto> unitAuth;
}
