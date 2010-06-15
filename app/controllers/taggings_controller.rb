class TaggingsController < ApplicationController
  permit "admin or (manager of :organization)"

  def create

  end

  def destroy
    @person.tag_list.delete params[:id]
    @person.save
    redirect_to person_path(:organization_key => @organization.key, :id => @person)
  end
end
