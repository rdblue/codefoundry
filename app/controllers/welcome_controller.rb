class WelcomeController < ApplicationController
  def index
    @new_projects = Project.newest.limit(5)
    @popular_projects = Project.by_hits.limit(5)
  end

  def about
    render_marker( params[:action] )
  end

  # copy #about for #faq and #roadmap
  alias_method :faq, :about
  alias_method :roadmap, :about
end
