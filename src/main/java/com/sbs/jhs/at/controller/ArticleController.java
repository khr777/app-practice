package com.sbs.jhs.at.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.service.ArticleService;
import com.sbs.jhs.at.util.Util;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/article/list")
	public String showList(Model model, @RequestParam Map<String, Object> param) {

		
		
		String searchKeywordType = "";
		if (param.get("searchKeywordType") != null ) {
			searchKeywordType = (String)param.get("searchKeywordType"); 
			
		}
		System.out.println("title : " + searchKeywordType);
		String searchKeywordTypeBody = "";
		if (param.get("searchKeywordTypeBody") != null ) {
			searchKeywordTypeBody = (String) param.get("searchKeywordTypeBody");
			
		}
		System.out.println("body : " + searchKeywordTypeBody);
		String searchKeyword = "";
		if (param.get("searchKeyword") != null ) {
			searchKeyword = (String) param.get("searchKeyword");
			
		}
		System.out.println("검색어 : " + searchKeyword);
		

		int page = 1;
		if (param.get("page") != null) {
			page = Integer.parseInt((String) param.get("page"));
		}
		int itemsInAPage = 10; // 게시물 리스트에 보여줄 게시물 개수
		int limitFrom = (page - 1) * itemsInAPage;
		int totalCount = articleService.getForPrintListArticlesCount(param, searchKeywordType, searchKeywordTypeBody, searchKeyword);
		int totalPage = (int) Math.ceil(totalCount / (double) itemsInAPage);

		List<Article> articles = articleService.getForPrintArticles(param, itemsInAPage, limitFrom, searchKeywordType, searchKeywordTypeBody, searchKeyword);

		model.addAttribute("articles", articles);

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("cPage", param.get("page"));

		return "article/list";
	}

	// public String showDetail(Model model, int id) { 이렇게 해도 된다. "int id"로
	// 실무에서 @RequestParam 방법을 많이 사용한다. (int id 방법도 있지만)
	// 모든 parameter가 'param'에 다 들어가 있다. 꺼내 쓰기만 하면 된다.
	@RequestMapping("/article/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param) {

		int id = Integer.parseInt((String) param.get("id"));
		articleService.hitUp(id);

		Article article = articleService.getForPrintArticleById(id);

		int beforeId = Util.getAsInt(articleService.getForPageMoveBeforeArticle(id));
		int afterId = Util.getAsInt(articleService.getForPageMoveAfterArticle(id));

		model.addAttribute("beforeId", beforeId);
		model.addAttribute("afterId", afterId);

		model.addAttribute("article", article);
		
		
		List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(article.getId());
		
		
		
		
		model.addAttribute("articleReplies", articleReplies); // 굽는다.
		return "article/detail";
	}

	@RequestMapping("/article/write")
	public String showWrite(Model model) {
		return "article/write";
	}

	@RequestMapping("/article/doWrite")
	public String doWrite(@RequestParam Map<String, Object> param) {

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
	
	@RequestMapping("/article/doWriteReply")
	public String doWriteReply(@RequestParam Map<String, Object> param) {
		
		System.out.println("param이 담고 있는 것은? : " + param);
		Map<String, Object> rs = articleService.writeReply(param);
		
		int articleId = Util.getAsInt((String)param.get("articleId"));    

		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", articleId + "");
		
		
		// Spring Boot의 특징 : "redirect:" 이런식으로 하면 jsp에서 지정한 param->redirectUrl로 이동한다.
		return "redirect:" + redirectUrl;
	}


	@RequestMapping("/article/modify")
	public String showModify(Model model, int id) {

		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);

		return "article/modify";
	}

	@RequestMapping("/article/doModify")
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

	@RequestMapping("/article/delete")
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
	
	@RequestMapping("/article/doDeleteReply")
	public String doDeleteReply(Model model, @RequestParam Map<String, Object> param) {
		
		// 댓글 삭제 가능한지 물어보는 메서드
		//Map<String, Object> articleReplyDeleteAvailable = articleService.getArticleReplyDeleteAvailable(id);

		// Map<String, Object> rs = articleService.softDeleteArticleReply(id);
		
		Map<String, Object> rs = articleService.softDeleteArticleReply(Util.getAsInt(param.get("id")));
		
		String redirectUrl = (String)param.get("redirectUrl");
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

	
	
	

}
