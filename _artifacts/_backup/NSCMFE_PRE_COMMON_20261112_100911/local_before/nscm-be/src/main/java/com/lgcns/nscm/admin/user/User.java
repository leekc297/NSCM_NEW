package com.lgcns.nscm.admin.user;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class User {
	private String userId;
	private String password;
	private String userNm;
	private String userEngNm;
	private String langCd;

	public static User of(Map<String, Object> data) {
		return User.builder()
			.userId((String) data.get("USER_ID"))
			.password((String) data.get("PASSWORD"))
			.userNm((String) data.get("USER_NM"))
			.userEngNm((String) data.get("USER_ENG_NM"))
			.langCd((String) data.get("LANG_CD"))
			.build();
	}

    public static List<User> listOf(List<Map<String, Object>> datas) {
    	List<User> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(User.of(datas.get(i)));
		}
    	return result;
    }
}
