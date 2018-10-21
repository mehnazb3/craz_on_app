collection @items

attributes :id, :status, :created_at, :location_id, :updated_at

child :user do
  attributes :id, :first_name, :last_name, :email
end
code do |kso|
  { type: kso.class.to_s }
end

code do |kso|
  if kso.class.to_s == Share.to_s
    {
      message: kso.message,
      micro_blog_id: kso.micro_blog_id
    }
  end
end