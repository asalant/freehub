class TagsController < ApplicationController

  permit "admin or (manager of :organization)"

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @people = Person.for_organization(@organization).tagged_with(@tag.name).paginate(params)
  end
end
