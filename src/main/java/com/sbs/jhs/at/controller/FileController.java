package com.sbs.jhs.at.controller;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.google.common.base.Joiner;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.FileService;
import com.sbs.jhs.at.service.VideoStreamService;
import com.sbs.jhs.at.util.Util;

@Controller
public class FileController {
	@Autowired
	private FileService fileService;
	@Autowired
	private VideoStreamService videoStreamService;
	
	// 구아바 기능 (캐시를하면 DB파일을 브라우저로 한번에 보내고 받고 하는게 아닌 서버에 지정한 시간만큼 
	// 보관을 해두고 파일자체의 이동횟수를 현저히 줄여준다.
	// 나중에 응용해서 어떤것에도 사용할 수 있다.
	private LoadingCache<Integer, File> fileCache = CacheBuilder.newBuilder().maximumSize(100)
			.expireAfterAccess(2, TimeUnit.MINUTES).build(new CacheLoader<Integer, File>() {
				// 10을 2로 바꾸면 2분 동안 서버에 저장해놓겠다. 임의로 저장시간을 조정해서 사용할 수 있다.
				// 캐시 저장시간이 길면 좋겠지만 그러면 메모리?를 차지해서.. 
				@Override
				public File load(Integer fileId) {
					return fileService.getFileById(fileId);
				}
			});

	
	
	// ResponseEntity 의미 : 우리가 구현한걸 사용자가 보게되는게 그걸 좀 더 세밀하게 하는?
	// mp4라는 것은 rangeRequest를 한다.. 영리하게도 한번에 긴 영상을 가져오는게 아니라 10초씩 영상을 가져와 보여준다.
	@RequestMapping("/usr/file/streamVideo")
	public ResponseEntity<byte[]> streamVideo(@RequestHeader(value = "Range", required = false) String httpRangeList,
			int id) {
		// 캐시(작업으로?)로 서버에 일정시간 저장해둘 파일을 가져온다.
		// 그러나 캐시한테 데이터를 받아올 때는 그냥 받아오는게 아니라 Util에 만들어놓은 코드처럼 활용해서 가져와야 한다.
		// 만약 fileService.getFileById(id); 로 파일을 받아오면 매번 파일을 받아서 전달하게 된다.
		// 그러나 아래와 같이 파일을 한번 불러오면 어딘가에 잠시 불러온 파일을 저장해놓고 
		// DB를 귀찮게 하지 않고 어딘가에서 재빠르게 가져와 쓰게 된다. 
		File file = Util.getCacheData(fileCache, id);
		
		
		
		// file.getBody()에는 byte배열이 들어있다..? 이 외의 자료를 알려주기만 하면 브라우저가 
		// 요청하는 10초? 단위 영상분을 알아서 전달하고 전달하고 전달한다.
		return videoStreamService.prepareContent(new ByteArrayInputStream(file.getBody()), file.getFileSize(),
				file.getFileExt(), httpRangeList);
	
	}
	
	
	// 다중 파일 업로드가 가능하도록 설계되어 있다.   반복문을 통해서.	
	@RequestMapping("/usr/file/doUploadAjax")
	@ResponseBody
	public ResultData uploadAjax(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {
		
		
		
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		
		List<Integer> fileIds = new ArrayList<>();

		for (String fileInputName : fileMap.keySet()) {
			MultipartFile multipartFile = fileMap.get(fileInputName);
			String[] fileInputNameBits = fileInputName.split("__");

			if (fileInputNameBits[0].equals("file")) {
				
				byte[] fileBytes = Util.getFileBytesFromMultipartFile(multipartFile);

				if ( fileBytes == null || fileBytes.length == 0 ) {
					continue;
				}
				
				
				String relTypeCode = fileInputNameBits[1];
				int relId = Integer.parseInt(fileInputNameBits[2]);
				String typeCode = fileInputNameBits[3];
				String type2Code = fileInputNameBits[4];
				int fileNo = Integer.parseInt(fileInputNameBits[5]);
				String originFileName = multipartFile.getOriginalFilename();
				String fileExtTypeCode = Util.getFileExtTypeCodeFromFileName(multipartFile.getOriginalFilename());
				String fileExtType2Code = Util.getFileExtType2CodeFromFileName(multipartFile.getOriginalFilename());
				String fileExt = Util.getFileExtFromFileName(multipartFile.getOriginalFilename()).toLowerCase();
				int fileSize = (int)multipartFile.getSize();

				int fileId = fileService.saveFile(relTypeCode, relId, typeCode, type2Code, fileNo, originFileName,
						fileExtTypeCode, fileExtType2Code, fileExt, fileBytes, fileSize);

				fileIds.add(fileId);
			}
		}

		Map<String, Object> rsDataBody = new HashMap<>();
		rsDataBody.put("fileIdsStr", Joiner.on(",").join(fileIds));
		rsDataBody.put("fileIds", fileIds);

		return new ResultData("S-1", String.format("%d개의 파일을 저장했습니다.", fileIds.size()), rsDataBody);
	}

	// 다중 파일 업로드가 가능하도록 설계되어 있다.   반복문을 통해서.	
	@RequestMapping("/usr/file/doUpDateUploadAjax")
	@ResponseBody
	public ResultData doUpDateUploadAjax(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {
		
		
		
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		
		List<Integer> fileIds = new ArrayList<>();

		for (String fileInputName : fileMap.keySet()) {
			MultipartFile multipartFile = fileMap.get(fileInputName);
			String[] fileInputNameBits = fileInputName.split("__");

			if (fileInputNameBits[0].equals("file")) {
				
				byte[] fileBytes = Util.getFileBytesFromMultipartFile(multipartFile);

				if ( fileBytes == null || fileBytes.length == 0 ) {
					continue;
				}
				
				
				String relTypeCode = fileInputNameBits[1];
				int relId = Integer.parseInt(fileInputNameBits[2]);
				String typeCode = fileInputNameBits[3];
				String type2Code = fileInputNameBits[4];
				int fileNo = Integer.parseInt(fileInputNameBits[5]);
				String originFileName = multipartFile.getOriginalFilename();
				String fileExtTypeCode = Util.getFileExtTypeCodeFromFileName(multipartFile.getOriginalFilename());
				String fileExtType2Code = Util.getFileExtType2CodeFromFileName(multipartFile.getOriginalFilename());
				String fileExt = Util.getFileExtFromFileName(multipartFile.getOriginalFilename()).toLowerCase();
				int fileSize = (int)multipartFile.getSize();

				fileService.updateFile(relTypeCode, relId, typeCode, type2Code, fileNo, originFileName,
						fileExtTypeCode, fileExtType2Code, fileExt, fileBytes, fileSize);

			}
		}

		Map<String, Object> rsDataBody = new HashMap<>();
		rsDataBody.put("fileIdsStr", Joiner.on(",").join(fileIds));
		rsDataBody.put("fileIds", fileIds);

		return new ResultData("S-1", String.format("%d개의 파일을 저장했습니다.", fileIds.size()), rsDataBody);
	}	


}
