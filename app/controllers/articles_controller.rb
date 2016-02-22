class ArticlesController < ApplicationController
  require 'roo'
  # attr_accessible :id, :title, :content
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :export, :import]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  # GET /articles
  # GET /articles.json
  def index
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find_by_id(params[:id])
    @comments = @article.comments.order("id desc")
    @comment = Comment.new
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = "Article created!"
      respond_to do |format|
        format.html { redirect_to root_url }
        format.js
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    flash[:success] = "Article deleted"
    redirect_to request.referrer || root_url
  end

  #export
  # def export
    # @article = Article.all
    # # @comments= @article.comments
    # respond_to do |format|
      # format.html
      # format.csv {
      # # debugger
        # send_data Article.to_csv(params[:id])
      # }
      # format.xls {send_data Article.to_csv(params[:id]) }
    # end
  # end
# 
  # def import
  # end

  def export
    @as_article = params[:id].present?
    @article = Article.find(params[:id]) if @as_article
  end

  def download_file
    if params[:id].present?
      @articles = Article.where(:id => params[:id])
      @comments = @articles.first.comments
    else
      @articles = Article.all
      @comments = Comment.all
    end

    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    wb.add_worksheet(name: "Articles") do |sheet|
      sheet.add_row ["ID", "Title", "Content", "Status"]
      @articles.each do |article|
        sheet.add_row [article.id, article.title, article.content, article.status]
      end
    end
    wb.add_worksheet(name: "Comments") do |sheet|
      sheet.add_row ["ID", "Article ID", "Content"]
      @comments.each do |comment|
        sheet.add_row [comment.id, comment.article_id, comment.content, comment.status]
      end
    end    
    send_data xlsx.to_stream.read, type: "application/xlsx", filename: "complete.xlsx"
  end

  # # POST
  # def import
    # spreadsheet = open_spreadsheet(params[:file])
    # header = spreadsheet.row(1)
    # (2..spreadsheet.last_row).each do |i|
      # row = Hash[[header, spreadsheet.row(i)].transpose]
      # parameters = ActionController::Parameters.new(row)
      # article = Article.find_by_title(row["title"]) || new
      # row = Hash[[header, spreadsheet.row(i)].transpose]
      # article.update!(row)
      # #article = find_by_title(row["title"])
      # #article.comments.create!(parameters.permit(:article_id, :comment))
      # #comment = article.comments.build
     # spreadsheet.default_sheet = spreadsheet.sheets.last
      # header = spreadsheet.row(1)     
      # (2..spreadsheet.last_row).each do |i|
        # row = Hash[[header, spreadsheet.row(i)].transpose]
        # parameters = ActionController::Parameters.new(row)
        # comment = article.comments.find_by_comment(row["comment"]) || article.comments.build
        # comment.update!(parameters.permit(:article_id, :comment))
        # end
      # end
  # end
  
  #import
  def import
    Article.import(params[:file])
    redirect_to root_url, notice: "Articles imported"
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    redirect_to root_url if @article.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :content, :status)
  end
  def open_spreadsheet(file)
      case File.extname(file.original_filename)
        when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
        when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
        when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end
end  

