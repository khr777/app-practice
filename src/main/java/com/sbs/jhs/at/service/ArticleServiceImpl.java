package com.sbs.jhs.at.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.util.Util;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ArticleServiceImpl implements ArticleService {

	@Autowired
	private ArticleDao articleDao;

	@Override
	public List<Article> getForPrintArticles(@RequestParam Map<String, Object> param, int itemsInAPage, int limitFrom,
			String searchKeywordType, String searchKeywordTypeBody, String searchKeyword) { // getList();

		List<Article> articles = articleDao.getForPrintArticles(param, itemsInAPage, limitFrom, searchKeywordType,
				searchKeywordTypeBody, searchKeyword);

		return articles;
	}

	@Override
	public Article getForPrintArticleById(int id) {

		Article article = articleDao.getForPrintArticleById(id);

		return article;
	}

	@Override
	public int write(Map<String, Object> param) { // add
		articleDao.write(param);
		return Util.getAsInt(param.get("id"));
	}

	@Override
	public int modify(@RequestParam Map<String, Object> param, int id) {
		int a = articleDao.modify(param);
		return a;
	}

	@Override
	public int softDelete(int id) {
		int a = articleDao.softDelete(id);
		return a;
	}

	@Override
	public void hitUp(int id) {
		articleDao.hitUp(id);

	}

	@Override
	public void deleteModify(int id) {
		articleDao.deleteModify(id);

	}

	@Override
	public int getForPrintListArticlesCount(@RequestParam Map<String, Object> param, String searchKeywordType,
			String searchKeywordTypeBody, String searchKeyword) {
		return articleDao.getForPrintListArticlesCount(param, searchKeywordType, searchKeywordTypeBody, searchKeyword);
	}

	@Override
	public Integer getForPageMoveBeforeArticle(int id) {
		return articleDao.getForPageMoveBeforeArticle(id);
	}

	@Override
	public Integer getForPageMoveAfterArticle(int id) {
		return articleDao.getForPageMoveAfterArticle(id);
	}

	@Override
	public Map<String, Object> writeReply(@RequestParam Map<String, Object> param) {
		articleDao.writeReply(param);
		int id = Util.getAsInt(param.get("articleId"));
		Map<String, Object> rs = new HashMap<>();
		rs.put("msg", String.format("%d번 게시물 댓글이 생성되었습니다.", id));
		return rs;
	}

	@Override
	public List<ArticleReply> getForPrintArticleReplies(int articleId) {
		return articleDao.getForPrintArticleReplies(articleId);
	}

	@Override
	public Map<String, Object> getArticleReplyDeleteAvailable(int id) {
		ArticleReply articleReply = getArticleReply(id);
		return null;
	}

	@Override
	public ArticleReply getArticleReply(int id) {
		return articleDao.getArticleReply(id);
	}

	@Override
	public Map<String, Object> softDeleteArticleReply(int id) {
		articleDao.softDeleteArticleReply(id);
		Map<String, Object> rs = new HashMap<>();
		rs.put("msg", String.format("%d번 댓글을 삭제했습니다.", id));
		return rs;
	}

	@Override
	public ArticleReply getForPrintArticleReplyById(int id) {
		ArticleReply articleReply = articleDao.getForPrintArticleReplyById(id);

		return articleReply;
	}
	
	@Override
	public Map<String, Object> modifyReply(@RequestParam Map<String, Object> param, int id) {
		
		articleDao.modifyReply(param);
		
		Map<String, Object> rs = new HashMap<>();
		//rs.put("msg", String.format("%d번 댓글을 삭제했습니다.", id));
		rs.put("resultCode", "S-1");
		return rs;
	}

	@Override
	public List<ArticleReply> getForPrintArticleReplies(int id, int from) {
		return articleDao.getForPrintArticleRepliesFrom(id, from);
	}

}
