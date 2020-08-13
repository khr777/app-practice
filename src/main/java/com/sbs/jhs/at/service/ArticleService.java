package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;

public interface ArticleService {
	
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);
		

	public Article getForPrintArticleById(int id, Member actor);
	

	public int write(Map<String, Object> param);

	public int modify(@RequestParam Map<String, Object> param, int id);

	public int softDelete(int id);

	public void hitUp(int id);


	public void deleteModify(int id);


	public int getForPrintListArticlesCount(@RequestParam Map<String, Object> param, String searchKeywordType, String searchKeywordTypeBody, String searchKeyword);


	public Integer getForPageMoveBeforeArticle(int id);


	public Integer getForPageMoveAfterArticle(int id);




	public Map<String, Object> getReplyDeleteAvailable(int id);


	public Reply getReply(int id);




	public Reply getForPrintReplyById(int id);


	public boolean actorCanModify(Member loginedMember, Article article);
	
	public boolean actorCanDelete(Member actor, Article article);


	public void writeRelIdUpdate(int newArticleId);


	public boolean actorCanModify(Member loginedMember, int id);


	public ResultData checkActorCanModify(Member loginedMember, int id);
	


}



