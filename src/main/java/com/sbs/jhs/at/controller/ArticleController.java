package com.sbs.jhs.at.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.ArticleService;
import com.sbs.jhs.at.util.Util;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/article/list")
	public String showList(Model model, @RequestParam Map<String, Object> param) {

		String searchKeywordType = "";
		if (param.get("searchKeywordType") != null) {
			searchKeywordType = (String) param.get("searchKeywordType");

		}
		System.out.println("title : " + searchKeywordType);
		String searchKeywordTypeBody = "";
		if (param.get("searchKeywordTypeBody") != null) {
			searchKeywordTypeBody = (String) param.get("searchKeywordTypeBody");

		}
		System.out.println("body : " + searchKeywordTypeBody);
		String searchKeyword = "";
		if (param.get("searchKeyword") != null) {
			searchKeyword = (String) param.get("searchKeyword");

		}

		int page = 1;
		if (param.get("page") != null) {
			page = Integer.parseInt((String) param.get("page"));
		}
		int itemsInAPage = 10; // 게시물 리스트에 보여줄 게시물 개수
		int limitFrom = (page - 1) * itemsInAPage;
		int totalCount = articleService.getForPrintListArticlesCount(param, searchKeywordType, searchKeywordTypeBody,
				searchKeyword);
		int totalPage = (int) Math.ceil(totalCount / (double) itemsInAPage);

		List<Article> articles = articleService.getForPrintArticles(param, itemsInAPage, limitFrom, searchKeywordType,
				searchKeywordTypeBody, searchKeyword);

		model.addAttribute("articles", articles);

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("cPage", param.get("page"));

		return "article/list";
	}

	// public String showDetail(Model model, int id) { 이렇게 해도 된다. "int id"로
	// 실무에서 @RequestParam 방법을 많이 사용한다. (int id 방법도 있지만)
	// 모든 parameter가 'param'에 다 들어가 있다. 꺼내 쓰기만 하면 된다.
	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param) {
		
		
		
		
		int id = Util.getAsInt(param.get("id"));
		articleService.hitUp(id);

		Article article = articleService.getForPrintArticleById(id);

		int beforeId = Util.getAsInt(articleService.getForPageMoveBeforeArticle(id));
		int afterId = Util.getAsInt(articleService.getForPageMoveAfterArticle(id));

		model.addAttribute("beforeId", beforeId);
		model.addAttribute("afterId", afterId);

		model.addAttribute("article", article);

		//List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(article.getId());

		//model.addAttribute("articleReplies", articleReplies); // 굽는다.
		return "article/detail";
	}

	@RequestMapping("/usr/article/write")
	public String showWrite(Model model) {
		return "article/write";
	}

	@RequestMapping("/usr/article/doWrite")
	public String doWrite(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		param.put("memberId", request.getAttribute("loginedMemberId"));
		
		//System.out.println("memberId : " + Util.getAsInt(request.getAttribute("loginedMemberId")));
		
		int newArticleId = articleService.write(param);

		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", newArticleId + "");
		/*
		 * String msg = newId + "번 게시물이 추가되었습니다.";
		 * 
		 * StringBuilder sb = new StringBuilder();
		 * 
		 * sb.append("alert('" + msg + "');");
		 * sb.append("location.replace('./detail?id=" + newId + "');");
		 * 
		 * sb.insert(0, "<script>"); sb.append("</script>");
		 */
		// Spring Boot의 특징 : 이런식으로 하면 jsp에서 지정한 param->redirectUrl로 이동한다.
		return "redirect:" + redirectUrl;
	}

	@RequestMapping("/usr/article/doWriteReply")
	public String doWriteReply(@RequestParam Map<String, Object> param) {

		int newArticleReplyId = articleService.writeReply(param);

		int articleId = Util.getAsInt((String) param.get("articleId"));

		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", articleId + "");

		// Spring Boot의 특징 : "redirect:" 이런식으로 하면 jsp에서 지정한 param->redirectUrl로 이동한다.
		return "redirect:" + redirectUrl;
	}

	@RequestMapping("/usr/article/modify")
	public String showModify(Model model, int id) {

		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);

		return "article/modify";
	}

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String showDoModify(@RequestParam Map<String, Object> param, int id) {

		articleService.modify(param, id);

		String msg = id + "번 게시물이 수정되었습니다.";

		StringBuilder sb = new StringBuilder();

		sb.append("alert('" + msg + "');");
		sb.append("location.replace('./detail?id=" + id + "');");

		sb.insert(0, "<script>");
		sb.append("</script>");

		return sb.toString();

	}

	@RequestMapping("/usr/article/delete")
	@ResponseBody
	public String showDelete(int id) {

		articleService.softDelete(id);

		String msg = id + "번 게시물이 삭제되었습니다.";

		StringBuilder sb = new StringBuilder();

		sb.append("alert('" + msg + "');");
		sb.append("location.replace('./list');");

		sb.insert(0, "<script>");
		sb.append("</script>");

		return sb.toString();

	}

	@RequestMapping("/usr/article/doDeleteReply")
	public String doDeleteReply(Model model, @RequestParam Map<String, Object> param) {

		// 댓글 삭제 가능한지 물어보는 메서드
		// Map<String, Object> articleReplyDeleteAvailable =
		// articleService.getArticleReplyDeleteAvailable(id);

		// Map<String, Object> rs = articleService.softDeleteArticleReply(id);

		Map<String, Object> rs = articleService.softDeleteArticleReply(Util.getAsInt(param.get("id")));

		String redirectUrl = (String) param.get("redirectUrl");
		System.out.println("redirectUrl : " + redirectUrl);
		int articleId = Util.getAsInt(param.get("articleId"));
		redirectUrl = redirectUrl.replace("#id", articleId + "");
		System.out.println("redirectUrl : " + redirectUrl);
		// ---------------- 혹시 articleId 형 변환을 해야 할 수도???????????

		/*
		 * String msg = id + "번 게시물이 삭제되었습니다.";
		 * 
		 * StringBuilder sb = new StringBuilder();
		 * 
		 * sb.append("alert('" + msg + "');"); sb.append("location.replace('./list');");
		 * 
		 * sb.insert(0, "<script>"); sb.append("</script>");
		 * 
		 * return sb.toString();
		 */
		return "redirect:" + redirectUrl;
	}

	@RequestMapping("/usr/article/modifyReply")
	public String showModifyReply(Model model, int id) {

		ArticleReply articleReply = articleService.getForPrintArticleReplyById(id);

		model.addAttribute("articleReply", articleReply);

		return "article/modifyReply";
	}

	@RequestMapping("/usr/article/doModifyReply")
	public String doModifyReply(@RequestParam Map<String, Object> param, int id) {

		
		System.out.println("param : " + param);
		articleService.modifyReply(param, id);

		String redirectUrl = (String) param.get("redirectUrl");

		return "redirect:" + redirectUrl;

	}
	
	@RequestMapping("/usr/article/doWriteReplyAjax")
	@ResponseBody // Ajax는 이걸 꼭 해주어야 한다.
	public ResultData doWriteReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> rsDataBody = new HashMap<>();
		param.put("memberId", request.getAttribute("loginedMemberId"));
		System.out.println("param : " + param);
		int newArticleReplyId =  articleService.writeReply(param);
		rsDataBody.put("articleReplyId", newArticleReplyId);
		
		
		return new ResultData("S-1", String.format("%d번 댓글이 생성되었습니다.", newArticleReplyId));
	}
	
	
	
	
	
	/*
	 * // Rs 의미 : Map 을 return 한다는 의미.
	 * 
	 * @RequestMapping("/usr/article/getForPrintArticleRepliesRs")
	 * 
	 * @ResponseBody public Map<String, Object> getForPrintArticleRepliesRs(int id,
	 * int from) { List<ArticleReply> articleReplies =
	 * articleService.getForPrintArticleReplies(id, from);
	 * System.out.println(articleReplies); Map<String, Object> rs = new HashMap<>();
	 * rs.put("resultCode", "S-1"); rs.put("msg", String.format("총 %d개의 댓글이 있습니다.",
	 * articleReplies.size())); rs.put("articleReplies", articleReplies);
	 * 
	 * 
	 * return rs; }
	 * 
	 */
	
	// Rs 의미 : Map 을 return 한다는 의미.
	@RequestMapping("/usr/article/getForPrintArticleRepliesRs") 
	@ResponseBody
	public ResultData getForPrintArticleRepliesRs(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(param);
		Map<String, Object> rsDataBody = new HashMap<>();
		rsDataBody.put("articleReplies", articleReplies);
		
		
		return new ResultData("S-1", String.format("%d개의 댓글을 불러왔습니다.", articleReplies.size()),rsDataBody );
	}
	@RequestMapping("/usr/article/doDeleteReplyAjax")
	@ResponseBody
	public ResultData doDeleteReply(@RequestParam Map<String, Object> param, int id) {
		

		articleService.softDeleteArticleReply(id);

		  
		// ★ 시간 지연을 걸 수 있음.
		// Ajax 너무 빨라서 "삭제중입니다.. 안 보일 때 사용해서 참고할 것.
		try {
			Thread.sleep(1000);  // 3초 쉬는거.  3초 잠재우는 것.
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		
		
		return new ResultData("S-1", String.format("%d번 댓글을 삭제하였습니다.",id ));
	}
	
	@RequestMapping("/usr/article/doModifyReplyAjax")
	@ResponseBody
	public Map<String, Object> doModifyReplyAjax(@RequestParam Map<String, Object> param, int id, HttpServletRequest request) {

		
		
		Map<String, Object> rs = articleService.modifyReply(param, id);
		
		//임시용 
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		
		
		
		return rs;

	}
	



}
