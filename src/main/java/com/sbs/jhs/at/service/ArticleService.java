package com.sbs.jhs.at.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.util.Util;

@Service
public class ArticleService {
	
	@Autowired
	private ArticleDao articleDao;
	
	public List<Article> getForPrintArticles() {
		
		
		List<Article> articles = articleDao.getForPrintArticles();
		
		return articles;
	}

	public Article getForPrintArticleById(int id) {
		
		Article article = articleDao.getForPrintArticleById(id);
		
		
		return article;
	}

	public long add(@RequestParam Map<String, Object> param) {
		return articleDao.add(param);
	}

	public int modify(String title, String body, int id) {
		int a = articleDao.modify(title, body, id);
		return a;
	}

	public int delete(int id) {
		int a = articleDao.delete(id);
		return a;
	}

	public void hitUp(int id) {
		articleDao.hitUp(id);
		
	}

}



