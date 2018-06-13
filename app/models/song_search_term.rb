class SongSearchTerm
  attr_reader :where_clause, :where_args, :order
  def initialize(search_term)
    search_term = search_term.downcase
    @where_clause = ""
    @where_args = {}
    build_for_search(search_term)
  end

  private

  def build_for_search(search_term)
    @where_clause << case_insensitive_search(:title)
    @where_args[:title] = starts_with(search_term)

    @where_clause << " OR #{case_insensitive_search(:artist)}"
    @where_args[:artist] = starts_with(search_term)
  end

  def starts_with(search_term)
    search_term + "%"
  end

  def case_insensitive_search(field_name)
    "lower(#{field_name}) like :#{field_name}"
  end
end
