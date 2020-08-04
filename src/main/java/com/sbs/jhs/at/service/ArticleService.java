package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.Article;

public interface ArticleService {
	
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom);
		

	public Article getForPrintArticleById(int id);
	

	public long add(Map<String, Object> param);

	public int modify(@RequestParam Map<String, Object> param, long id);

	public long softDelete(long id);

	public void hitUp(int id);


	public void deleteModify(long id);


	public int getForPrintListArticlesCount();


	public int getForPageMoveBeforeArticle(int id);


	public int getForPageMoveAfterArticle(int id);


}



