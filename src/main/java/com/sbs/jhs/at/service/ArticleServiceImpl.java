package com.sbs.jhs.at.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;
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
	public int writeReply(@RequestParam Map<String, Object> param) {
		articleDao.writeReply(param);
		
		return Util.getAsInt(param.get("id"));
	}
	/*
	 * @Override public List<Reply> getForPrintArticleReplies(int articleId)
	 * { return articleDao.getForPrintArticleReplies(articleId); }
	 */

	@Override
	public Map<String, Object> getReplyDeleteAvailable(int id) {
		Reply reply = getReply(id);
		return null;
	}

	@Override
	public Reply getReply(int id) {
		return articleDao.getReply(id);
	}

	@Override
	public Map<String, Object> softDeleteReply(int id) {
		articleDao.softDeleteReply(id);
		Map<String, Object> rs = new HashMap<>();
		rs.put("msg", String.format("%d번 댓글을 삭제했습니다.", id));
		rs.put("resultCode", "S-1");
		return rs;
	}

	@Override
	public Reply getForPrintReplyById(int id) {
		Reply reply = articleDao.getForPrintReplyById(id);

		return reply;
	}
	
	
	@Override
	public List<Reply> getForPrintReplies(@RequestParam Map<String, Object> param) {
		
		
		
		List<Reply> replies =  articleDao.getForPrintRepliesFrom(param);
		
		Member actor = (Member)param.get("actor");
		
		
		System.out.println("articleService's member : " + actor);
		
		
		
		for ( Reply reply : replies ) {
			
			// 출력용 부가데이터를 추가한다.
			updateForPrintInfo(actor, reply);
		}
		
		return replies;
		
	}

	public void updateForPrintInfo(Member actor, Reply reply) {
		reply.getExtra().put("actorCanDelete", actorCanDelete(actor, reply));
		reply.getExtra().put("actorCanModify", actorCanModify(actor, reply));
		
	}
	
	// 액터가 해당 댓글을 수정할 수 있는지를 알려준다.
	public boolean actorCanModify(Member actor, Reply reply) {
		 return actor != null && actor.getId() == reply.getMemberId() ? true : false;
	}

	
	//액터가 해당 댓글을 삭제할 수 있는지를 알려준다.
	public boolean actorCanDelete(Member actor, Reply reply) {
		return actorCanModify(actor, reply);
	}


}
