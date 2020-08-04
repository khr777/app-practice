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
import com.sbs.jhs.at.service.ArticleService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j 
public class ArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/article/list")
	public String showList(Model model, @RequestParam Map<String, Object> param) {
		

		
		
		
		int page = 1;
		if ( param.get("page") != null  ) {
			page = Integer.parseInt((String)param.get("page"));
		}
		int itemsInAPage = 10; // 게시물 리스트에 보여줄 게시물 개수
		int limitFrom = (page-1) * itemsInAPage;
		int totalCount = articleService.getForPrintListArticlesCount();
		System.out.println("totalCount : " + totalCount);
		int totalPage = (int) Math.ceil(totalCount / (double) itemsInAPage);

	
		
		List<Article> articles = articleService.getForPrintArticles(param, itemsInAPage, limitFrom);
		
		
		
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
		
		int id = Integer.parseInt((String)param.get("id"));
		articleService.hitUp(id);

		Article article = articleService.getForPrintArticleById(id);
		
		
		int beforeId = articleService.getForPageMoveBeforeArticle(id);
		int afterId = articleService.getForPageMoveAfterArticle(id);
		model.addAttribute("article", article);
		model.addAttribute("beforeId", beforeId);
		model.addAttribute("afterId", afterId);

		return "article/detail";
	}

	@RequestMapping("/article/add")
	public String showWrite(Model model) {
		return "article/add";
	}

	@RequestMapping("/article/doAdd")
	@ResponseBody
	public String showDoAdd(@RequestParam Map<String, Object> param) {

		long newId = articleService.add(param);
		
		String msg = newId + "번 게시물이 추가되었습니다.";

		StringBuilder sb = new StringBuilder();

		sb.append("alert('" + msg + "');");
		sb.append("location.replace('./detail?id=" + newId + "');");

		sb.insert(0, "<script>");
		sb.append("</script>");

		return sb.toString();
	}

	@RequestMapping("/article/modify")
	public String showModify(Model model, int id) {

		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);
		
		

		return "article/modify";
	}

	@RequestMapping("/article/doModify")
	@ResponseBody
	public String showDoModify(@RequestParam Map<String, Object> param, long id) {

		articleService.modify(param, id);

		
		  String msg = id + "번 게시물이 수정되었습니다.";
		  
		  StringBuilder sb = new StringBuilder();
		  
		  sb.append("alert('" + msg + "');");
		  sb.append("location.replace('./detail?id=" + id + "');");
		  
		  sb.insert(0, "<script>"); sb.append("</script>");
		  
		  return sb.toString();
		  
	}

	@RequestMapping("/article/delete")
	@ResponseBody
	public String showDelete(long id) {
		 
		articleService.softDelete(id);

		String msg = id + "번 게시물이 삭제되었습니다.";

		StringBuilder sb = new StringBuilder();

		sb.append("alert('" + msg + "');");
		sb.append("location.replace('./list');");

		sb.insert(0, "<script>");
		sb.append("</script>");

		return sb.toString();
		
	}

}
