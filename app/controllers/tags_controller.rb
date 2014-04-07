class TagsController < ApplicationController

  before_filter :authorize_admin_or_manager

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @people = Person.for_organization(@organization).tagged_with(@tag.name).paginate(params)
  end
end
