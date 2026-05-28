package com.lgcns.nscm.admin.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class SuccessTestService extends BaseService{

	public MenuDto retrieveOne() throws Exception {

		MenuDto result = MenuDto.builder()
				.mnuId("TEST001")
				.mnuDesc("응답 테스트용 가상의 메뉴입니다")
				.build();

		return result;
	}

	public List<MenuDto> retrieveList() throws Exception {

		MenuDto menu1 = MenuDto.builder()
				.mnuId("TEST001")
				.mnuDesc("응답 테스트용 가상의 메뉴입니다")
				.build();
		MenuDto menu2 = MenuDto.builder()
				.mnuId("TEST002")
				.mnuDesc("응답 테스트용 가상의 메뉴입니다")
				.build();

		List<MenuDto> result = new ArrayList<MenuDto>();
		result.add(menu1);
		result.add(menu2);

		return result;
	}

	// 오라클 input 값을 테이블 형식으로 받는 테스트
	public Map<String, Object> testOraTable() throws Exception{

			List<Map<String, Object>> testList = new ArrayList<Map<String, Object>>();
			Map<String, Object> testMap = new HashMap<String, Object>();
			testMap.put("col1", "a");
			testMap.put("col2", "b");
			testMap.put("col3", 1);
			Map<String, Object> testMap2 = new HashMap<String, Object>();
			testMap2.put("col1", "가");
			testMap2.put("col2", "나");
			testMap2.put("col3", 11);
			testList.add(testMap);
			testList.add(testMap2);

			return selectList("admin.lookup.test", Map.of("test", testList));
		}

}
