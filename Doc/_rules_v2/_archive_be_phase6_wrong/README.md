# Phase 6 PoC — 잘못된 BE 패키지 (Archive)

> ⚠️ **이 폴더의 내용은 사용 금지 — 사용자 지적 (2026-06-04) 으로 archive**.
>
> **사유**: NSCM 의 BE 아키텍처는 단일 `GeneralController` 의 동적 SP 호출 패턴. 화면별 Controller/Service/DTO/MyBatis XML 작성은 **불필요**한 오버엔지니어링.

---

## 잘못된 작업 (Phase 6 PoC 보완 6)

PoC 의 보완 6 (BE 패키지 작성) 에서 룰 11 의 Spring Boot 표준 패턴을 mechanic 하게 적용한 결과:

| 파일 | 원래 위치 | 실제 필요 여부 |
|---|---|---|
| `BodController.java` | `nscm-be/src/main/java/com/lgcns/nscm/master/bod/` | ❌ 불필요 |
| `service/BodService.java` | 동일 | ❌ |
| `service/BodServiceImpl.java` | 동일 | ❌ |
| `dto/BodRequest.java` | 동일 | ❌ |
| `Bod.xml` | `nscm-be/src/main/resources/sql/master/` | ❌ |

→ **5 파일 모두 archive 이동 — 본 폴더에 보존 (학습 reference)**.

---

## 정답: NSCM 의 동적 SP 호출 아키텍처

### §1 단일 라우터

```java
// nscm-be/src/main/java/com/lgcns/nscm/general/GeneralController.java
@PostMapping("/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc")
public ResponseEntity callProc(
    @LoginUser UserSession userSession,
    @RequestBody Map<String, Object> params,
    @PathVariable String mnuId,
    @PathVariable String shtNm,
    @PathVariable String mnuBtnCd
) {
    params.put("mnuId", mnuId);
    params.put("shtNm", shtNm);
    params.put("mnuBtnCd", mnuBtnCd);
    return successResponseEntity(generalService.execBtn(params));
}
```

→ **모든 신규 화면 = 본 endpoint 자동 사용**. 별도 Controller 작성 불필요.

### §2 신규 화면 BE 작업 인벤토리

| 항목 | 필요? |
|---|---|
| Controller / Service / ServiceImpl / DTO / MyBatis XML | ❌ |
| `SCM_ADM_API_M` 메타 (URL ↔ SP 매핑) | ✅ |
| `SCM_ADM_PROC_M` 메타 (SP IN/OUT 명세) | ✅ |
| `SCM_ADM_MNU_M_SHEET_COLUMNS` 메타 (grid column) | ✅ |
| SP body (Oracle PL/SQL) | ✅ |
| 권한 메타 (`USER_GR_MNU_MPG_M` / `BTN_MPG_M`) | ✅ |

→ **메타 SQL + SP body 만으로 BE 작업 100% 완료**. Java 코드 0 줄.

### §3 예외 (별도 Controller 필요한 경우)

매우 드문 케이스:
- 인증 / 메뉴 트리 / 권한 (`admin/auth`, `admin/menu`, `admin/user`)
- Lookup / Combo / Lookup-Muti (`admin/lookup`)
- 시스템 (`admin/log`, `admin/message`)
- 파일 (`general/file`)

→ 위 모두 **시스템 기능** (도메인 화면 X). DM/SCM/FP/SCP/SSP 도메인의 master 화면은 별도 Controller 불필요.

---

## 룰 정정 사항

> 본 archive 와 동기:

- ✅ `_tobe/11_be_controller_service.md` — Spring Boot 표준 → **NSCM 동적 SP 호출 아키텍처** 로 전면 재작성
- ✅ `_asis/02_screens/DMF0015/PoC_FIX_REPORT.md` — 보완 6 "잘못된 fix" 명시 + 정정 사항 추가

---

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | Phase 6 PoC 보완 6 잘못된 BE 패키지 5 파일 archive — NSCM 동적 SP 호출 아키텍처와 불일치 |
