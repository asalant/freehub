class TagsController < ApplicationController

  permit "admin or (manager of :organization)"

  def show
    @tag = ActsAsTaggableOn::Tag.find_by_name(params[:id])
    @people = Person.for_organization(@organization).tagged_with(params[:id]).paginate(params)
  end
end
