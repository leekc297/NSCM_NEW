package com.lgcns.nscm.framework.handler;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class FileUploadTest extends BaseService {

    public void testFileUpload() {


    	try {
            String sFile = "C:\\Users\\story55\\Desktop\\MSSQL_다중_RTN값.txt";
            Path path = Paths.get(sFile);
            File file = path.toFile();

            if (file.exists()) {
                // 1. 파일명 (전체 경로 제외)
                String fileName = file.getName();

                // 2. 파일 확장자 추출
                String extension = "";
                int i = fileName.lastIndexOf('.');
                if (i > 0) {
                    extension = fileName.substring(i + 1);
                }

                // 3. 파일 크기 (Bytes)
                long fileSize = file.length();

                // 4. BLOB에 저장할 바이너리 정보 (byte 배열)
                byte[] fileByte = Files.readAllBytes(path);

                // 결과 출력 (오라클 내부 테스트용)
                log.info("파일명: " + fileName);
                log.info("확장자: " + extension);
                log.info("파일크기: " + fileSize + " bytes");
                log.info("바이너리 길이: " + fileByte.length);

                String id = "4B780E2F0364C778E06351DC220A67AB";

                Map<String, Object> param = new HashMap<String, Object>();
                param.put("id", id);
                param.put("name", fileName);
                param.put("ext", extension);
                param.put("size", fileSize);
                param.put("ctn", fileByte);


                int res = 0;
				try {
					res = update("admin.file.fileUploadTest", param);
				} catch (Exception e) {
					e.printStackTrace();
				}

            } else {
            	log.info("파일을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {

    	FileUploadTest test = new FileUploadTest();
    	test.testFileUpload();
	}

}
