class TaggingsController < ApplicationController
  permit "admin or (manager of :organization)"

  def create
    @person.tag_list << params[:id]
    @person.save
    if request.xhr?
      index
    else
      redirect_to_person_path
    end
  end

  def destroy
    @person.tag_list.delete params[:id]
    @person.save
    if request.xhr?
      index
    else
      redirect_to_person_path
    end
  end

  def index
    render :template => '/taggings/_index', :layout => false
  end

  private

  def redirect_to_person_path
    redirect_to person_path(:organization_key => @organization.key, :id => @person)
  end
end
