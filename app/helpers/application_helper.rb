module ApplicationHelper
  def nested_get(item, *params)
    memo = item
    params.each do |param|
      memo = memo[param] if memo
    end
    memo
  end
end
