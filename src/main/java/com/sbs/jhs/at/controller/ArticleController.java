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
	public String showList(Model model) {
		List<Article> articles = articleService.getForPrintArticles();

		model.addAttribute("articles", articles);

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
		
		
		
		model.addAttribute("article", article);

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
	public String showDoModify(Model model, String title, String body, int id) {

		articleService.modify(title, body, id);

		
		  String msg = id + "번 게시물이 수정되었습니다.";
		  
		  StringBuilder sb = new StringBuilder();
		  
		  sb.append("alert('" + msg + "');");
		  sb.append("location.replace('./detail?id=" + id + "');");
		  
		  sb.insert(0, "<script>"); sb.append("</script>");
		  
		  return sb.toString();
		  
	}

	@RequestMapping("/article/delete")
	public String showDelete(Model model, int id) {
		articleService.delete(id);

		return "home/main";
	}

}
