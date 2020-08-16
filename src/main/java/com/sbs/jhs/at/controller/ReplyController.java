package com.sbs.jhs.at.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.ReplyService;
import com.sbs.jhs.at.util.Util;

@Controller
public class ReplyController {
	@Autowired
	private ReplyService replyService;

	// Rs 의미 : Map 을 return 한다는 의미.
	@RequestMapping("/usr/reply/getForPrintRepliesRs")
	@ResponseBody
	public ResultData getForPrintRepliesRs(@RequestParam Map<String, Object> param, HttpServletRequest request) {

		Member loginedMember = (Member) request.getAttribute("loginedMember");
		Map<String, Object> rsDataBody = new HashMap<>();

		param.put("relTypeCode", "article");
		Util.changeMapKey(param, "articleId", "relId");

		param.put("actor", loginedMember);

		List<Reply> replies = replyService.getForPrintReplies(param);

		rsDataBody.put("replies", replies);

		System.out.println("rsDateBody size : " + replies.size());
		return new ResultData("S-1", String.format("%d개의 댓글을 불러왔습니다.", replies.size()), rsDataBody);
	}

	@RequestMapping("/usr/reply/doWriteReplyAjax")
	@ResponseBody // Ajax는 이걸 꼭 해주어야 한다.
	public ResultData doWriteReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> rsDataBody = new HashMap<>();
		param.put("memberId", request.getAttribute("loginedMemberId"));
		
		
		int newReplyId =  replyService.writeReply(param);
		rsDataBody.put("replyId", newReplyId);
		
		
		return new ResultData("S-1", String.format("%d번 댓글이 생성되었습니다.", newReplyId));
	}
	
	@RequestMapping("/usr/reply/doDeleteReplyAjax")
	@ResponseBody
	public ResultData doDeleteReply(@RequestParam Map<String, Object> param, int id, HttpServletRequest request) {
		
		Member loginedMember = (Member)request.getAttribute("loginedMember");
		Reply reply = replyService.getForPrintReplyById(id);
		
		
		if ( replyService.actorCanDelete(loginedMember, reply) == false) {
			return new ResultData("F-1", String.format("%d번 댓글을 삭제할 권한이 없습니다.",id ));
		}

		replyService.softDeleteReply(id);

		  
		// ★ 시간 지연을 걸 수 있음.
		// Ajax 너무 빨라서 "삭제중입니다.. 안 보일 때 사용해서 참고할 것.
		try {
			Thread.sleep(1000);  // 3초 쉬는거.  3초 잠재우는 것.
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		
		return new ResultData("S-1", String.format("%d번 댓글을 삭제하였습니다.",id ));
	}
	
	@RequestMapping("/usr/reply/doModifyReplyAjax")
	@ResponseBody
	public ResultData doModifyReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, int id) {

		Member loginedMember = (Member)request.getAttribute("loginedMember");
		Reply reply = replyService.getForPrintReplyById(id);
		
		
		if ( replyService.actorCanModify(loginedMember, reply) == false) {
			return new ResultData("F-1", String.format("%d번 댓글을 수정할 권한이 없습니다.",id ));
		}
		
		
		// Util.getNewMapOf은 정말 필요한 것만 옮겨 담으려고 만듬
		Map<String, Object> modifyReplyParam = Util.getNewMapOf(param, "id" , "body");
		
		ResultData rd = replyService.modifyReply(modifyReplyParam);
		
		reply = replyService.getForPrintReplyById(id);
		
		
		return rd;

	}



}
