package com.sbs.jhs.at.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ReplyDao;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.util.Util;

@Service
public class ReplyService {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private FileService fileService;

	public List<Reply> getForPrintReplies(Map<String, Object> param) {

		List<Reply> replies = replyDao.getForPrintRepliesFrom(param);
		
		// 처음보는 기능 : '람다' 라는 것.
		// stream은 '람다' 기능 중 하나
		// 스트림은 '데이터의 흐름’입니다. 배열 또는 컬렉션 인스턴스에 함수 여러 개를 조합해서 원하는 결과를 필터링하고 가공된 결과를 얻을 수 있습니다.
		// mapping 과정을 통해서 reply.getId() 들만 모아서 collect 리스트로 만든다는 의미. (복잡한 반복문을 대신하고 있다.)
		List<Integer> replyIds = replies.stream().map(reply -> reply.getId()).collect(Collectors.toList());
		if ( replyIds.size() > 0 ) {   // common : 범용, attachment : 첨부파일, 1 : 첫번째 파일 을 가져와봐. 하는 함수
			
			
			Map<Integer, Map<Integer, File>> filesMap = fileService.getFilesMapKeyRelIdAndFileNo("reply", replyIds, "common", "attachment");
			// 그냥 List가 아닌 map으로 가져온다.

			for ( Reply reply : replies ) {
				Map<Integer, File> filesMap2 = filesMap.get(reply.getId());

				if (filesMap2 != null) {
					reply.getExtra().put("file__common__attachment", filesMap2);
					
					
					System.out.println("reply야, 너가 put한 이름이 뭐니?? : " + reply.getExtra().get("file__common__attachment"));
					
					
					
				}
				
			
			
			}
		
		}
		
		
		

		Member actor = (Member) param.get("actor");


		for (Reply reply : replies) {

			// 출력용 부가데이터를 추가한다.
			updateForPrintInfo(actor, reply);
		}

		return replies;

	}

	public void updateForPrintInfo(Member actor, Reply reply) {
		reply.getExtra().put("actorCanDelete", actorCanDelete(actor, reply));
		reply.getExtra().put("actorCanModify", actorCanModify(actor, reply));

	}

	// 액터가 해당 댓글을 수정할 수 있는지를 알려준다.
	public boolean actorCanModify(Member actor, Reply reply) {
		return actor != null && actor.getId() == reply.getMemberId() ? true : false;
	}

	// 액터가 해당 댓글을 삭제할 수 있는지를 알려준다.
	public boolean actorCanDelete(Member actor, Reply reply) {
		return actorCanModify(actor, reply);
	}

	public int writeReply(@RequestParam Map<String, Object> param) {
		replyDao.writeReply(param);
		
		int id = Util.getAsInt(param.get("id"));
		
		// 이 값이 존재한다는거 자체가 댓글만 입력된게 아닌 파일첨부된 댓글이 입력된 것임을 알 수 있다.
		// fileIdsStr로 Ids 복수형을 보아 파일이 1개가 아닌 여러개가 전송될 수도 있겠구나. 여러개 첨부 가능하구나. 라고 유추할 수 있다.
		String fileIdsStr = (String) param.get("fileIdsStr"); 
		
		
		// 몰라도 되는 코드이지만 의미하는 바는? 파일이 여러개일 경우 파일 번호를 ,기준으로 쪼개서 한 곳에 모으는 작업을 하는 코드
		if (fileIdsStr != null && fileIdsStr.length() > 0) {
			List<Integer> fileIds = Arrays.asList(fileIdsStr.split(",")).stream().map(s -> Integer.parseInt(s.trim()))
					.collect(Collectors.toList());

			// 1. 파일이 먼저 생성된 후에, 관련 데이터가 생성되는 경우에는, file의 relId가 일단 0으로 저장된다.
			// 2. 그것을 뒤늦게라도 이렇게 고처야 한다.
			// 3. 최초 셋팅한 fileId는 0 이고, 파일이 생성되어야 relId를 알 수 있으니 마지막 쯤에 update로 relId를 입력해주는 것!
			// 4. 먼저 발송, 저장된 파일의 관련 relId 셋팅해주어야 댓글에서 파일을 불러올 수 있다. 그렇지 않으면 파일 보여지지 않는다.
			for (int fileId : fileIds) {
				fileService.changeRelId(fileId, id);
			}
		
			
		}
		
		
		return id;
	}

	public Map<String, Object> softDeleteReply(int id) {
		replyDao.softDeleteReply(id);
		fileService.deleteFiles("reply", id);
		Map<String, Object> rs = new HashMap<>();
		rs.put("msg", String.format("%d번 댓글을 삭제했습니다.", id));
		rs.put("resultCode", "S-1");
		return rs;
	}

	public Reply getForPrintReplyById(int id) {
		Reply reply = replyDao.getForPrintReplyById(id);
		
		Map<Integer, File> filesMap = fileService.getFilesMapKeyFileNo("reply", id, "common", "attachment");
		Util.putExtraVal(reply, "file__common__attachment", filesMap);
		

		return reply;
	}

	public ResultData modifyReply(Map<String, Object> param) {
		
		replyDao.modifyReply(param);
		
		
		int id = Util.getAsInt(param.get("id"));
		
		
		Reply reply = getForPrintReplyById(id);
		
		param.put("file__common__attachment", reply.getExtra().get("file__common__attachment"));

		
		return new ResultData("S-1", String.format("%d번 댓글을 수정하였습니다.", Util.getAsInt(param.get("id"))), param);
	}

	

}
