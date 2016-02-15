json.array!(@comments) do |comment|
  json.extract! comment, :id, :article_id, :user_id, :content, :status
  json.url comment_url(comment, format: :json)
end
