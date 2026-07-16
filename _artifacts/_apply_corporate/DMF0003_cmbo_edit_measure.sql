-- =====================================================================
-- DMF0003 — CMBO MktFcstEditMeasure 등록 (82 신규행 Measure 편집 콤보)
-- 원천: MKT_FCST_MEASURE lookup (SEGMENT1=division, SEGMENT2=code, SEGMENT3=name,
--       ATTRIBUTE2=TMM여부). AS-IS UP_FX_GetCommonDataList V_Code='MktFcstEditMeasure' 1:1
--       (@Param1=DIVISION_ID). TO-BE UP_FX_GETCOMMONDATALIST_DM 에 이 분기 미이관 → lookup 직접 CMBO.
-- 파라미터: @divisionId — FE 가 값 quoting 전달('82'), BE makeComboQuery raw 치환 대응
--           (PlantSitebyEndCustomer/IncotermsEdit 선례. 미quoting 시 SEGMENT1=82 숫자비교 ORA-01722 위험).
-- 1차 범위: division + VALID + TMM(ATTRIBUTE2='Y') 제외. VMI(site VMI_YN) 세부 필터는 후속(행별 동적).
-- 멱등 MERGE. 감사 'admin'.
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (SELECT 'MktFcstEditMeasure' SQL_ID FROM DUAL) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
    t.MDU_DIVS_CD = 'DM',
    t.SQL_NM = 'MKT FCST 편집가능 Measure (division)',
    t.SQL_DTL_CTN = 'SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''MKT_FCST_MEASURE'' AND SEGMENT1 = @divisionId AND VALID_YN = ''Y'' AND NVL(ATTRIBUTE2, ''N'') <> ''Y'' ORDER BY SEGMENT2',
    t.USE_YN = 'Y',
    t.LAST_UPDATED_BY = 'admin',
    t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('MktFcstEditMeasure', 'DM', 'MKT FCST 편집가능 Measure (division)',
     'SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''MKT_FCST_MEASURE'' AND SEGMENT1 = @divisionId AND VALID_YN = ''Y'' AND NVL(ATTRIBUTE2, ''N'') <> ''Y'' ORDER BY SEGMENT2',
     'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복 (ROLLBACK — 필요 시 수동)
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='MktFcstEditMeasure';
-- COMMIT;
