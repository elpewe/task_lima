class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true,
                            length: { minimum: 5 }
  validates :content, presence: true,
                            length: { minimum: 10 }
  validates :status, presence: true

  scope :status_active, -> {where(status: 'active')}
  has_many :comments, dependent: :destroy
  
  
  def self.to_csv(id, options = {})
    CSV.generate(options) do |csv|
      csv.add_row column_names
      values = find(id).attributes.values
      csv.add_row values
      find(id).comments.each do |comment|
        valc = comment.attributes.values
        csv.add_row valc
      end
    end
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      article_hash = row.to_hash
      article = Article.where(id: article_hash["id"])
      if article.count == 1
        article.first.update_attributes(article_hash)
      else
        Article.create!(article_hash)
      end
    end
  end
end
