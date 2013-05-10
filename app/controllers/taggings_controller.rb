class TaggingsController < ApplicationController
  permit "admin or (manager of :organization)"

  def create
    @person.tag_list << params[:id]
    @person.save!
    if request.xhr?
      index
    else
      redirect_to_person_path
    end
  end

  def destroy
    tagging = Tagging.find params[:id]
    @person.taggings.delete tagging
    if request.xhr?
      index
    else
      redirect_to_person_path
    end
  end

  def index
    render :partial => '/taggings/index', :locals => { :person => @person }
  end

  private

  def redirect_to_person_path
    redirect_to person_path(:organization_key => @organization.key, :id => @person)
  end
end
