module ProjectsHelper
  
  def avatar_thumb(avatar)
    image_tag(avatar.url(:thumb), :class => 'double_border', :width => 48, :height => 48)
  end
end
