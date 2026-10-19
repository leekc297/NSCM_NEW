# -*- coding: utf-8 -*-
"""DMF0035 MKT 로컬 BE HTTP 실측 — 클라우드 브라우저 응답(B) 대조 기준: 키 이름·행 수

⚠️ [2026-09-02 실측 경고] 아래 파라미터의 'ALL' 은 **무필터 센티널이 아니다** — 결과가 항상 0행이 된다.
   PKG_DMF0035 는 필터마다 `IF NVL(P_xxx,'@#@#@#') <> '@#@#@#' THEN DELETE ... WHERE NOT EXISTS(
   ... LIKE '%'||TOKEN||'%')` 구조라(P_ITEM_ID = L2452~2472, 로그마커 E52), 'ALL' 을 주면 분기가 켜져
   ITEM_ID 가 '%ALL%' 에 안 맞는 행을 전부 삭제한다.
   사내 실측(div40 / CURRENT / 20260901~20261130): 'ALL' → O_RC1 0 / NULL → O_RC1 515.
   ⇒ 무필터는 **NULL(또는 미전달)**. 이 스크립트로 0행이 나와도 "데이터 없음"으로 판정하지 말 것.
   단계별 실제 원인은 SCM_SYS_LOG_BATCH 마커(D5/D61/E3A8/E52/G2)로 확인 —
   `_artifacts/_diagnostics/DMF0035_MKT_FCST_CLOUD_VERIFY.sql` §4B 참조.
"""
import io, sys, json, requests; sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
base, user = "http://localhost:8080", "minyonglee1"
s = requests.Session(); r = s.post(f"{base}/user/login", json={"userId": user}, timeout=30); print("login", r.status_code, (r.json().get("result") or {}).get("userId"))
common = dict(divisionId='40', deptId='ALL', endCustomer='ALL', scmSiteId='ALL', projectCode='ALL', itemId='ALL', itemType='ALL',
              fromYyyymmdd='20260801', toYyyymmdd='20270228', sesUserId=user, plantSiteId='ALL', bizType='ALL', owner='', userId=user, menuId='DMF0035')
mkt = dict(common, versionNo='CURRENT', bucket='WEEKLY', cellYn='N', senderCode='ALL', userDeptId='', groupId='')
title = dict(divisionId='40', bucket='WEEKLY', fromYyyymmdd='20260801', toYyyymmdd='20270228', sesUserId=user, userId=user)
for sheet, body in (("mktFcstSpreadTitle", title), ("mktFcstWaterfall", mkt)):
    r = s.post(f"{base}/DMF0035/{sheet}/SEARCH/call-proc", json=body, timeout=300)
    j = r.json(); res = j.get("result") or {}
    print(sheet, "HTTP", r.status_code, "code", j.get("code"), "result keys", list(res.keys())[:6], {k: (len(v) if isinstance(v, list) else v) for k, v in res.items() if k.lower().startswith(("o_", "code", "msg"))})
    if isinstance(res.get("o_rc1"), list) and res["o_rc1"]: print("   first row keys(앞 12):", list(res["o_rc1"][0].keys())[:12])
