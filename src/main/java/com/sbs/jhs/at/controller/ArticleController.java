package com.sbs.jhs.at.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.service.ArticleService;

@Controller
public class ArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/article/list")
	public String showList(Model model) {
		int count = articleService.getCount();
		List<Article> articles = articleService.getForPrintArticles();

		model.addAttribute("count", count);
		model.addAttribute("articles", articles);

		return "article/list";
	}

	@RequestMapping("/article/detail") 
	public String showDetail(Model model, int id) {
		
	  Article article = articleService.getForPrintArticle(id);
	  
	  model.addAttribute("article", article);
	  
	  
	  
		return "article/detail"; 
	  }

	@RequestMapping("/article/write")
	public String showWrite(Model model) {
		return "article/write";
	}

	@RequestMapping("/article/doActionWrite")
	public String showDoActionWrite(Model model, String title, String body) {
		
		int id = articleService.articleWrite(title, body);
		
		

		return "home/main";
	}

	@RequestMapping("/article/modify")
	public String showModify(Model model) {

		return "article/modify";
	}

}
