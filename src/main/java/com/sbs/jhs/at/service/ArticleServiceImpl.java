package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.util.CUtil;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ArticleServiceImpl implements ArticleService {
	
	@Autowired
	private ArticleDao articleDao;
	
	@Override
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom) {  // getList();
		
		List<Article> articles = articleDao.getForPrintArticles(param, itemsInAPage, limitFrom);
		
		return articles;
	}
	
	@Override
	public Article getForPrintArticleById(int id) {
		
		Article article = articleDao.getForPrintArticleById(id);
		
		
		return article;
	}
	
	@Override
	public long add(Map<String, Object> param) { // add
		articleDao.add(param);
		return CUtil.getAsLong(param.get("id"));
	}
	
	@Override
	public int modify(@RequestParam Map<String, Object> param, long id) {
		int a = articleDao.modify(param);
		return a;
	}
	
	@Override
	public long softDelete(long id) {
		long a = articleDao.softDelete(id);
		return a;
	}
	
	@Override
	public void hitUp(int id) {
		articleDao.hitUp(id);
		
	}
	public void deleteModify(long id) {
		articleDao.deleteModify(id);
		
	}

	@Override
	public int getForPrintListArticlesCount() {
		return articleDao.getForPrintListArticlesCount();
	}

	@Override
	public int getForPageMoveBeforeArticle(int id) {
		return articleDao.getForPageMoveBeforeArticle(id);
	}

	@Override
	public int getForPageMoveAfterArticle(int id) {
		return articleDao.getForPageMoveAfterArticle(id);
	}



}



