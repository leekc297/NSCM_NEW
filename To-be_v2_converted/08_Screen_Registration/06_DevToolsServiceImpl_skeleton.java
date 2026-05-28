/*=============================================================================================
 * File         : DevToolsServiceImpl.java + interface + DTO + Mapper.xml
 * Location     : nscm-be/src/main/java/com/lgcns/nscm/admin/devtools/
 * Description  : 개발 도구 서비스 — PR_GET_PROCEDURES_METADATA 호출 + DTO 변환
 *
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.devtools
 * @author   : Marisoft
 * @date     : 2026-05-13
 *===========================================================================================*/

// ============================================================
// 1. DevToolsService.java (Interface)
// ============================================================
package com.lgcns.nscm.admin.devtools;

import java.util.List;
import com.lgcns.nscm.admin.devtools.dto.ProcedureMetadata;

public interface DevToolsService {
    List<ProcedureMetadata> retrieveProceduresMetadata() throws Exception;
    List<ProcedureMetadata> retrieveProcedureMetadataByMenu(String menuId) throws Exception;
}


// ============================================================
// 2. DevToolsServiceImpl.java
// ============================================================
package com.lgcns.nscm.admin.devtools;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.devtools.dto.ProcedureMetadata;
import com.lgcns.nscm.framework.service.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class DevToolsServiceImpl extends BaseService implements DevToolsService {

    private final String nameSpace = "admin.devtools.";

    @Override
    public List<ProcedureMetadata> retrieveProceduresMetadata() throws Exception {
        Map<String, Object> result = selectList(nameSpace + "retrieveProceduresMetadata",
                                                new HashMap<>());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
        log.info("retrieveProceduresMetadata rows={}", data == null ? 0 : data.size());
        return ProcedureMetadata.listOf(data);
    }

    @Override
    public List<ProcedureMetadata> retrieveProcedureMetadataByMenu(String menuId) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("menuId", menuId);
        Map<String, Object> result = selectList(nameSpace + "retrieveProcedureMetadataByMenu", params);
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
        log.info("retrieveProcedureMetadataByMenu menuId={} rows={}", menuId,
                 data == null ? 0 : data.size());
        return ProcedureMetadata.listOf(data);
    }
}


// ============================================================
// 3. dto/ProcedureMetadata.java
// ============================================================
package com.lgcns.nscm.admin.devtools.dto;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class ProcedureMetadata {
    private String menuId;        // 'DMF0099'
    private String menuDesc;      // 'Sales Monitor'
    private String sheetName;     // 'main'
    private String mnuBtnCd;      // 'SEARCH'
    private String apiId;
    private String procName;      // 'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA'
    private String colName;       // 'DIVISION_ID'
    private String dataTpCd;      // 'STRING' / 'NUMBER' / 'DATE' / 'CURSOR'
    private String colTpCd;       // 'IN' / 'OUT' / 'NORMAL'
    private Integer sortOrd;

    public static ProcedureMetadata of(Map<String, Object> r) {
        return ProcedureMetadata.builder()
                .menuId(str(r, "MNU_ID"))
                .menuDesc(str(r, "MNU_DESC"))
                .sheetName(str(r, "SHT_NM"))
                .mnuBtnCd(str(r, "MNU_BTN_CD"))
                .apiId(str(r, "API_ID"))
                .procName(str(r, "PROC_NM"))
                .colName(str(r, "COL_NM"))
                .dataTpCd(str(r, "DATA_TP_CD"))
                .colTpCd(str(r, "COL_TP_CD"))
                .sortOrd(num(r, "SORT_ORD"))
                .build();
    }

    public static List<ProcedureMetadata> listOf(List<Map<String, Object>> data) {
        if (data == null) return List.of();
        return data.stream().map(ProcedureMetadata::of).collect(Collectors.toList());
    }

    private static String str(Map<String, Object> r, String k) {
        Object v = r.get(k);
        return v == null ? "" : v.toString();
    }
    private static Integer num(Map<String, Object> r, String k) {
        Object v = r.get(k);
        if (v == null) return 0;
        if (v instanceof Number n) return n.intValue();
        return Integer.parseInt(Objects.toString(v, "0"));
    }
}


// ============================================================
// 4. src/main/resources/sql/admin/DevTools.xml (MyBatis)
// ============================================================
/*
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.lgcns.nscm.admin.devtools">

    <resultMap id="devToolsResultMap" type="java.util.HashMap" />

    <!-- 전체 메타 -->
    <select id="retrieveProceduresMetadata" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA(
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet,
              resultMap=devToolsResultMap}
        ) }
    </select>

    <!-- 메뉴별 메타 -->
    <select id="retrieveProcedureMetadataByMenu" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURE_METADATA_BY_MENU(
            #{menuId, mode=IN, jdbcType=VARCHAR},
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet,
              resultMap=devToolsResultMap}
        ) }
    </select>
</mapper>
*/
