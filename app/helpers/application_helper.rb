module ApplicationHelper
  def sidebar_link_classes(path)
    base = "flex items-center px-2 py-1.5 rounded-lg transition-colors"

    if current_page?(path)
      "#{base} bg-blue-700 text-white"
    else
      "#{base} text-blue-100 hover:bg-blue-800 hover:text-white"
    end
  end
end
