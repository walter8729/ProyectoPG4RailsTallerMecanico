module ApplicationHelper
  def sidebar_link_classes(path)
    base = "flex items-center px-2 py-1.5 rounded-lg transition-colors"

    if current_page?(path)
      "#{base} bg-blue-700 text-white"
    else
      "#{base} text-blue-100 hover:bg-blue-800 hover:text-white"
    end
  end

  # Ícono de Ver / Detalle (Ojo)
  def icon_eye
    content_tag(:svg, class: "w-4 h-4", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2") do
      content_tag(:path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M15 12a3 3 0 11-6 0 3 3 0 016 0z") +
      content_tag(:path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z")
    end
  end

  # Ícono de Editar (Lápiz)
  def icon_pencil
    content_tag(:svg, class: "w-4 h-4", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2") do
      content_tag(:path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z")
    end
  end

  # Ícono de Eliminar (Papelera)
  def icon_trash
    content_tag(:svg, class: "w-4 h-4", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2") do
      content_tag(:path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16")
    end
  end
end
