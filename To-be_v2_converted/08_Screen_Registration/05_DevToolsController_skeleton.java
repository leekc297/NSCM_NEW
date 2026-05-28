/*=============================================================================================
 * File         : DevToolsController.java (To-Be FE 위치: nscm-be/src/main/java/com/lgcns/nscm/admin/devtools/)
 * Description  : 개발 도구 — procedures.d.ts 메타 조회 API
 *              : FE pnpm gen:procedures 호출 대상.
 *
 * 호출 경로   : GET /admin/dev/procedures-metadata
 *              GET /admin/dev/procedures-metadata/{menuId}
 *
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.devtools
 * @author   : Marisoft
 * @date     : 2026-05-13
 * @description : SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA 호출
 *===========================================================================================*/
package com.lgcns.nscm.admin.devtools;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.devtools.dto.ProcedureMetadata;
import com.lgcns.nscm.framework.controller.BaseController;
import com.lgcns.nscm.framework.response.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "99. 개발 도구", description = "FE procedures.d.ts 자동 생성 등 개발 보조 API")
@RestController
@RequiredArgsConstructor
public class DevToolsController extends BaseController {

    private final DevToolsService devToolsService;

    @Operation(summary = "전체 procedures.d.ts 메타 조회",
               description = "모든 메뉴 × Sheet × Button × PKG.SP × 컬럼 메타데이터 반환. "
                           + "FE의 pnpm gen:procedures가 호출.")
    @GetMapping("/admin/dev/procedures-metadata")
    public ResponseEntity<BaseResponse<List<ProcedureMetadata>>> retrieveProceduresMetadata()
            throws Exception {
        return successResponseEntity(devToolsService.retrieveProceduresMetadata());
    }

    @Operation(summary = "메뉴별 procedures.d.ts 메타 조회",
               description = "특정 MENU_ID 만의 메타데이터.")
    @GetMapping("/admin/dev/procedures-metadata/{menuId}")
    public ResponseEntity<BaseResponse<List<ProcedureMetadata>>> retrieveProcedureMetadataByMenu(
            @PathVariable String menuId) throws Exception {
        return successResponseEntity(devToolsService.retrieveProcedureMetadataByMenu(menuId));
    }
}
