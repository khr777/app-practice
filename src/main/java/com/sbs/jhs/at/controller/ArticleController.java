package com.sbs.jhs.at.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Reply;
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

		// List<Reply> replies = articleService.getForPrintReplies(article.getId());

		// model.addAttribute("replies", replies); // 굽는다.
		return "article/detail";
	}

	@RequestMapping("/usr/article/write")
	public String showWrite(Model model) {
		return "article/write";
	}

	// 얘... 아작스... 아님....
	@RequestMapping("/usr/article/doWriteAjax") // 근데 이거 Ajax 할 필요 없을 것 같음.. ★
	@ResponseBody // Ajax는 이걸 꼭 해주어야 한다.
	public ResultData doWriteAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> rsDataBody = new HashMap<>();
		param.put("memberId", request.getAttribute("loginedMemberId"));
		
		System.out.println("relId :" +  param.get("relId"));
		
		
		int newArticleId = articleService.write(param);
		rsDataBody.put("newArticleId", newArticleId);

		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", newArticleId + "");
		
		System.out.println("안되는건가?????/	");
		System.out.println("relTypeCode : " + param.get("relTypeCode"));
		System.out.println("relId : " + param.get("relId"));
		
		
		
		
		
		

		return new ResultData("S-1", String.format("%d번 게시물이 생성되었습니다.", newArticleId), redirectUrl);
	}

	/*
	 * @RequestMapping("/usr/article/doWrite") public String doWrite(@RequestParam
	 * Map<String, Object> param, HttpServletRequest request) {
	 * param.put("memberId", request.getAttribute("loginedMemberId"));
	 * 
	 * //System.out.println("memberId : " +
	 * Util.getAsInt(request.getAttribute("loginedMemberId")));
	 * 
	 * int newArticleId = articleService.write(param);
	 * 
	 * String redirectUrl = (String) param.get("redirectUrl"); redirectUrl =
	 * redirectUrl.replace("#id", newArticleId + "");
	 * 
	 * String msg = newId + "번 게시물이 추가되었습니다.";
	 * 
	 * StringBuilder sb = new StringBuilder();
	 * 
	 * sb.append("alert('" + msg + "');");
	 * sb.append("location.replace('./detail?id=" + newId + "');");
	 * 
	 * sb.insert(0, "<script>"); sb.append("</script>");
	 * 
	 * // Spring Boot의 특징 : 이런식으로 하면 jsp에서 지정한 param->redirectUrl로 이동한다. return
	 * "redirect:" + redirectUrl; }
	 */

	@RequestMapping("/usr/article/modify")
	public String showModify(Model model, int id) {

		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);

		return "article/modify";
	}

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String showDoModify(@RequestParam Map<String, Object> param, int id, HttpServletRequest request) {

		Member loginedMember = (Member) request.getAttribute("loginedMember");
		Article article = articleService.getForPrintArticleById(id);

		/*
		 * if ( articleService.actorCanModify(loginedMember, article) == false) { return
		 * new ResultData("F-1", String.format("%d번 게시물을 수정할 권한이 없습니다.",id )); }
		 * 
		 */

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

	@RequestMapping("/usr/article/modifyReply")
	public String showModifyReply(Model model, int id) {

		Reply reply = articleService.getForPrintReplyById(id);

		model.addAttribute("reply", reply);

		return "article/modifyReply";
	}

}
