module UrlHelper

  def organization_path(*args)
    if Organization === args[0]
      options = args.extract_options!
      organization_key_path(options.merge(:organization_key => args[0].key))
    else
      super
    end
  end
  
  def organization_url(*args)
    if Organization === args[0]
      options = args.extract_options!
      organization_key_url(options.merge(:organization_key => args[0].key))
    else
      super
    end
  end

  def edit_organization_path(*args)
    if Organization === args[0]
      options = args.extract_options!
      edit_organization_key_path(options.merge(:organization_key => args[0].key))
    else
      super
    end
  end

  def user_home_path(user)
    if user.organization
      organization_path user.organization
    else
      user_path :id => user.id
    end
  end

  def day_visits_path(*args)
    if args[0].respond_to? :to_date
      super(:year => args[0].to_date.year, :month => args[0].to_date.month, :day => args[0].to_date.day)
    else
      super
    end
  end
  
end
