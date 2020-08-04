package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.Article;

public interface ArticleService {
	
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);
		

	public Article getForPrintArticleById(int id);
	

	public int write(Map<String, Object> param);

	public int modify(@RequestParam Map<String, Object> param, int id);

	public int softDelete(int id);

	public void hitUp(int id);


	public void deleteModify(int id);


	public int getForPrintListArticlesCount(@RequestParam Map<String, Object> param, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);


	public Integer getForPageMoveBeforeArticle(int id);


	public Integer getForPageMoveAfterArticle(int id);


}



