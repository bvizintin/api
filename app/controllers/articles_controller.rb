class ArticlesController < ApplicationController
  def index
    articles = Article.order(created_at: :desc)
    paginated = paginator.call(articles, params: pagination_params, base_url: request.url)
    options = { meta: paginated.meta.to_h, links: paginated.links.to_h }
    render json: serializer.new(paginated.items, options), status: :ok
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  rescue ActiveRecord::RecordNotFound => e         #ovo se vrti u slučaju da je 404 greška
    render json: {message: e.message, detail: "We can't find specified article", soultion: "Kontaktirajte podršku"}
  end

  def serializer
    ArticleSerializer
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit![:page]
  end
end
